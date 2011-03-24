Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab1CXDa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 23:30:28 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:38300 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865Ab1CXDa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 23:30:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s2H+4PBufUj6xdQ5mtoxm9XhVc7qqfyk0HB+Cl9Uv26bPvhHTDKWPADtEAXKJDLPxJ
         py0x5Vq8T8j6zGJLlXayUGswLy0Ca9bTNVlx6JqJw2EndhJ/qFAtJ+2zY+stkT3zX+6n
         sET1LhpMShQLxj89wfLMaOWhu217czwCCtcMI=
MIME-Version: 1.0
In-Reply-To: <4D8A58E1.5090509@openvz.org>
References: <4D8A58E1.5090509@openvz.org>
Date: Thu, 24 Mar 2011 11:30:26 +0800
Message-ID: <AANLkTimU3Hw5ZSo86Fv4RUtNPtS3kZBoWm4kh4MQaymu@mail.gmail.com>
Subject: Re: [PATCH -tip] kgdb, x86: Pull up NMI notifier handler priority
From: Dongdong Deng <libfetion@gmail.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>,
        Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@redhat.com>, Lin Ming <ming.m.lin@intel.com>,
        Don Zickus <dzickus@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        KGDB Mailing List <Kgdb-bugreport@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 4:32 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> kgdb needs IPI to be sent and handled before perf
> or anything else NMI, otherwise kgdb hangs with bootup
> self-tests (found on P4 HT SMP machine). Raise its priority
> so that we're called first in a notifier chain.
>
> Reported-by: Don Zickus <dzickus@redhat.com>
> Tested-by: Lin Ming <ming.m.lin@intel.com>
> CC: Jason Wessel <jason.wessel@windriver.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>
> Don, Jason, take a look please.
>
>  arch/x86/kernel/kgdb.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> Index: linux-2.6.git/arch/x86/kernel/kgdb.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/kgdb.c
> +++ linux-2.6.git/arch/x86/kernel/kgdb.c
> @@ -592,9 +592,12 @@ static struct notifier_block kgdb_notifi
>        .notifier_call  = kgdb_notify,
>
>        /*
> -        * Lowest-prio notifier priority, we want to be notified last:
> +        * We might need to send an IPI and
> +        * do cpu roundup before anything else
> +        * in notifier chain so high priority
> +        * is needed.
>         */
> -       .priority       = NMI_LOCAL_LOW_PRIOR,
> +       .priority       = NMI_LOCAL_HIGH_PRIOR,
>  };

CC: kgdb maillist.

I quote Jason's early email to explain why debugger tends to
set the low level of die_notifier.

"The original thinking was that if you are using a low level debugger
that you would want to stop on such a event or breakpoint because there
is nothing else handling it and your system is about to print an oops
message."

For keeping above purpose, I have a "ugly" proposal that splitting
kgdb die handling to two parts.

1: The first part with HIGH priority and just handle NMI event,
 if the NMI event is not belong kgdb, it return NOTIFY_DONE and pass to others.

2: The second part with low priority to handling others.

Due to above handling logic could let kgdb source get complexly, I
couldn't make sure
it is a suitable method here, if it is OK, I can send a formal patch. :-)


$git diff
-----------
arch/x86/kernel/kgdb.c |   67 +++++++++++++++++++++++++++++++++++------------
 1 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index dba0b36..afd18db 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -516,23 +516,6 @@ static int __kgdb_notify(struct die_args *args,
unsigned long cmd)
 	struct pt_regs *regs = args->regs;

 	switch (cmd) {
-	case DIE_NMI:
-		if (atomic_read(&kgdb_active) != -1) {
-			/* KGDB CPU roundup */
-			kgdb_nmicallback(raw_smp_processor_id(), regs);
-			was_in_debug_nmi[raw_smp_processor_id()] = 1;
-			touch_nmi_watchdog();
-			return NOTIFY_STOP;
-		}
-		return NOTIFY_DONE;
-
-	case DIE_NMIUNKNOWN:
-		if (was_in_debug_nmi[raw_smp_processor_id()]) {
-			was_in_debug_nmi[raw_smp_processor_id()] = 0;
-			return NOTIFY_STOP;
-		}
-		return NOTIFY_DONE;
-
 	case DIE_DEBUG:
 		if (atomic_read(&kgdb_cpu_doing_single_step) != -1) {
 			if (user_mode(regs))
@@ -588,6 +571,52 @@ kgdb_notify(struct notifier_block *self, unsigned
long cmd, void *ptr)
 	return ret;
 }

+static int
+kgdb_nmi_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
+{
+	unsigned long flags;
+	struct pt_regs *regs = ((struct die_args*)ptr)->regs;
+	int ret = NOTIFY_DONE;
+
+	local_irq_save(flags);
+
+	switch (cmd) {
+	case DIE_NMI:
+		if (atomic_read(&kgdb_active) != -1) {
+			/* KGDB CPU roundup */
+			kgdb_nmicallback(raw_smp_processor_id(), regs);
+			was_in_debug_nmi[raw_smp_processor_id()] = 1;
+			touch_nmi_watchdog();
+			ret = NOTIFY_STOP;
+		}
+		break;
+
+	case DIE_NMIUNKNOWN:
+		if (was_in_debug_nmi[raw_smp_processor_id()]) {
+			was_in_debug_nmi[raw_smp_processor_id()] = 0;
+			ret = NOTIFY_STOP;
+		}
+		break;
+	default:
+		break;
+	}
+
+	local_irq_restore(flags);
+	return ret;
+}
+
+static struct notifier_block kgdb_nmi_notifier = {
+	.notifier_call	= kgdb_nmi_notify,
+
+	/*
+	 * We might need to send an IPI and
+	 * do cpu roundup before anything else
+	 * in notifier chain so high priority
+	 * is needed.
+	 */
+	.priority	= NMI_LOCAL_HIGH_PRIOR,
+};
+
 static struct notifier_block kgdb_notifier = {
 	.notifier_call	= kgdb_notify,

@@ -605,6 +634,9 @@ static struct notifier_block kgdb_notifier = {
  */
 int kgdb_arch_init(void)
 {
+	int err = register_die_notifier(&kgdb_nmi_notifier);
+	if (err)
+		return err;
 	return register_die_notifier(&kgdb_notifier);
 }

@@ -673,6 +705,7 @@ void kgdb_arch_exit(void)
 			breakinfo[i].pev = NULL;
 		}
 	}
+	unregister_die_notifier(&kgdb_nmi_notifier);
 	unregister_die_notifier(&kgdb_notifier);
 }

-- 
1.6.0.4
