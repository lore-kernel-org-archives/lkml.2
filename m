Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0LWVkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 16:40:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0LWVkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 16:40:02 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=OTOI4JRePMMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=Tty9oNO6AAAA:8 a=gYEQ8mzL28JxlgqyKe4A:9 a=U8YqrTRRTyOZVScarHgA:7 a=yKGLrr5gt8heyf_0cL_o5oKvEjgA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ng3Vkt7Pqmks4EZY:21 a=UD5GxWyabubQfatM:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL] module: Move RO/NX module protection to after
 ftrace module update
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Valdis.Kletnieks" <Valdis.Kletnieks@vt.edu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Dec 2010 16:39:59 -0500
Message-ID: <1293140399.22802.402.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/x86/security tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/x86/security


Steven Rostedt (1):
      module: Move RO/NX module protection to after ftrace module update

----
 kernel/module.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)
---------------------------
commit 94462ad3b14739d158a1ab87bb30008c1e5a6bc1
Author: Steven Rostedt <rostedt@goodmis.org>
Date:   Mon Nov 29 13:15:42 2010 -0500

    module: Move RO/NX module protection to after ftrace module update
    
    The commit:
    
    84e1c6bb38eb318e456558b610396d9f1afaabf0
    x86: Add RO/NX protection for loadable kernel modules
    
    Broke the function tracer with this output:
    
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
    
    The cause was that the module text was set to read only before ftrace
    could convert the calls to mcount to nops. Thus, the conversions failed
    due to not being able to write to the text locations.
    
    The simple fix is to move setting the module to read only after the
    module notifiers are called (where ftrace sets the module mcounts to nops).
    
    Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Acked-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/module.c b/kernel/module.c
index 562f665..34e00b7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2816,18 +2816,6 @@ static struct module *load_module(void __user *umod,
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
@@ -2888,6 +2876,18 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
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


