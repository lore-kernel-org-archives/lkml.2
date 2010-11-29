Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab0K2SPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:15:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41319 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab0K2SPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:15:51 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=qK-MKYc896kA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=7N4O53Tz1J5yzHckWZQA:9 a=Pb905KO5GJKhMdu_N1UA:7 a=XULuoXUyqyXkEwv_aO6AVk81n4gA:4 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=sK8ylSXCQLFLuM5I:21 a=vYAjElNnYxOD0s2d:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 29 Nov 2010 13:15:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: matthieu castet <castet.matthieu@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Kees Cook <kees.cook@canonical.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
Message-ID: <20101129181542.GA11630@home.goodmis.org>
References: <4CE2F914.9070106@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE2F914.9070106@free.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch breaks function tracer:

------------[ cut here ]------------
WARNING: at kernel/trace/ftrace.c:1014 ftrace_bug+0x114/0x171()
Hardware name: Precision WorkStation 470    
Modules linked in: i2c_core(+)
Pid: 86, comm: modprobe Not tainted 2.6.37-rc2+ #68
Call Trace:
 [<ffffffff8104e957>] warn_slowpath_common+0x85/0x9d
 [<ffffffffa00026db>] ? __process_new_adapter+0x7/0x34 [i2c_core]
 [<ffffffffa00026db>] ? __process_new_adapter+0x7/0x34 [i2c_core]
 [<ffffffff8104e989>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff810a9dfe>] ftrace_bug+0x114/0x171
 [<ffffffffa00026db>] ? __process_new_adapter+0x7/0x34 [i2c_core]
 [<ffffffff810aa0db>] ftrace_process_locs+0x1ae/0x274
 [<ffffffffa00026db>] ? __process_new_adapter+0x7/0x34 [i2c_core]
 [<ffffffff810aa29e>] ftrace_module_notify+0x39/0x44
 [<ffffffff814405cf>] notifier_call_chain+0x37/0x63
 [<ffffffff8106e054>] __blocking_notifier_call_chain+0x46/0x5b
 [<ffffffff8106e07d>] blocking_notifier_call_chain+0x14/0x16
 [<ffffffff8107ffde>] sys_init_module+0x73/0x1f3
 [<ffffffff8100acf2>] system_call_fastpath+0x16/0x1b
---[ end trace 2aff4f4ca53ec746 ]---
ftrace faulted on writing [<ffffffffa00026db>]
__process_new_adapter+0x7/0x34 [i2c_core]


On Tue, Nov 16, 2010 at 10:35:16PM +0100, matthieu castet wrote:
>  
> @@ -2650,6 +2810,18 @@ static struct module *load_module(void __user *umod,
>  	kfree(info.strmap);
>  	free_copy(&info);
>  
> +	/* Set RO and NX regions for core */
> +	set_section_ro_nx(mod->module_core,
> +				mod->core_text_size,
> +				mod->core_ro_size,
> +				mod->core_size);
> +
> +	/* Set RO and NX regions for init */
> +	set_section_ro_nx(mod->module_init,
> +				mod->init_text_size,
> +				mod->init_ro_size,
> +				mod->init_size);
> +

Here we set the text read only before we call the notifiers. The
function tracer changes the calls to mcount into nops via a notifier
call so this must be done after the module notifiers.

>  	/* Done! */
>  	trace_module_load(mod);
>  	return mod;
> @@ -2753,6 +2925,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
>  	mod->symtab = mod->core_symtab;
>  	mod->strtab = mod->core_strtab;
>  #endif
> +	unset_section_ro_nx(mod, mod->module_init);
>  	module_free(mod, mod->module_init);
>  	mod->module_init = NULL;
>  	mod->init_size = 0;

Below is the patch that fixes this bug.

-- Steve

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/module.c b/kernel/module.c
index ba421e6..5ccf52c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2804,18 +2804,6 @@ static struct module *load_module(void __user *umod,
 	kfree(info.strmap);
 	free_copy(&info);
 
-	/* Set RO and NX regions for core */
-	set_section_ro_nx(mod->module_core,
-				mod->core_text_size,
-				mod->core_ro_size,
-				mod->core_size);
-
-	/* Set RO and NX regions for init */
-	set_section_ro_nx(mod->module_init,
-				mod->init_text_size,
-				mod->init_ro_size,
-				mod->init_size);
-
 	/* Done! */
 	trace_module_load(mod);
 	return mod;
@@ -2876,6 +2864,18 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
 
+	/* Set RO and NX regions for core */
+	set_section_ro_nx(mod->module_core,
+				mod->core_text_size,
+				mod->core_ro_size,
+				mod->core_size);
+
+	/* Set RO and NX regions for init */
+	set_section_ro_nx(mod->module_init,
+				mod->init_text_size,
+				mod->init_ro_size,
+				mod->init_size);
+
 	do_mod_ctors(mod);
 	/* Start the module */
 	if (mod->init != NULL)


