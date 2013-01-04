Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3ADUPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 15:15:07 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54899 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab3ADUPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 15:15:04 -0500
Date: Fri, 4 Jan 2013 21:15:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 03/31] x86, realmode: set real_mode permissions early
Message-ID: <20130104201516.GA24228@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-4-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1357260531-11115-4-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:48:23PM -0800, Yinghai Lu wrote:
> Trampoline code is executed by APs with kernel low mapping.
> We need to set trampoline code to EXEC early before we do smp
> AP bootings.

"... before we boot the APs."

> 
> Found the problem after switching to #PF handler set page table,
> and we do not set initial kernel low mapping with EXEC anymore in

"...table, since we do not make initial kernel low mapping executable
anymore, in ..."

> arch/x86/kernel/head_64.S.
> 
> Change to use early_initcall instead that will make sure tramopline

							   trampoline

> will have EXEC set.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/realmode/init.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
> index 8045026..b96fe6f 100644
> --- a/arch/x86/realmode/init.c
> +++ b/arch/x86/realmode/init.c
> @@ -111,5 +111,9 @@ static int __init set_real_mode_permissions(void)
>  
>  	return 0;
>  }
> -
> -arch_initcall(set_real_mode_permissions);
> +/*
> + * Trampoline will be executed by APs with SMP.
> + * So we need to set it to EXEC in do_pre_smp_initcalls() at least,
> + * and that needs early_initcall().
> + */
> +early_initcall(set_real_mode_permissions);

Now you have two conflicting comments, one over
set_real_mode_permissions() the one you're adding here. Let's merge them
into one (the diff is ontop of your patch).

--
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index b96fe6f54d2f..9eb0fa95881e 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -84,10 +84,11 @@ void __init setup_real_mode(void)
 }
 
 /*
- * set_real_mode_permissions() gets called very early, to guarantee the
- * availability of low memory.  This is before the proper kernel page
- * tables are set up, so we cannot set page permissions in that
- * function.  Thus, we use an arch_initcall instead.
+ * This function gets called very early to guarantee the availability
+ * of low memory. This is even before the proper kernel page tables are
+ * set up, so we cannot set page permissions in that function. However,
+ * trampoline code will be executed by APs so we need it to be marked
+ * executable at pre-SMP time, thus run it as a early_initcall().
  */
 static int __init set_real_mode_permissions(void)
 {
@@ -111,9 +112,4 @@ static int __init set_real_mode_permissions(void)
 
 	return 0;
 }
-/*
- * Trampoline will be executed by APs with SMP.
- * So we need to set it to EXEC in do_pre_smp_initcalls() at least,
- * and that needs early_initcall().
- */
 early_initcall(set_real_mode_permissions);

-- 
Regards/Gruss,
Boris.
