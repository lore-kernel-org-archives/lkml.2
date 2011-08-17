Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1HQREo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:04:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab1HQREn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:04:43 -0400
Date: Wed, 17 Aug 2011 19:01:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/41] signal: Use set_current_blocked()
Message-ID: <20110817170152.GA22499@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <20110811160358.GA7989@redhat.com> <1313523659.3436.184.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313523659.3436.184.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, Matt Fleming wrote:
>
> Did you want me to send just the updated
> versions of patches or the entire series again? It would seem over the
> top to send the entire series.

This is up to you. Just in case, feel free to add my acked-by or
reviewed-by to any patch I didn't comment explicitly. Or may be

> Also, are you going to pull these patches into your tree and send them
> to Linus or would it be better to route them through -mm?

This is the question ;)

I simply do not know what should we do. I think this should be
routed via maintainers.

Or I can push this into the poor ptrace branch... but I am
thinking with horror about the possible conflicts in arch/ code...

What do you think?



Damn. And I can't relax. This is very minor, but I still think
it would be nice to have a common helper which plays sa_mask /
SA_NODEFER to set ->blocked. But in this case, you probably need
to resend the whole series ;)

I mean something like the patch below. OK, nevermind. Probably
this factorization doesn't buy too much, but it will complicate
the merging.

Oleg.

--- x/include/linux/signal.h
+++ x/include/linux/signal.h
@@ -254,6 +254,7 @@ extern void set_current_blocked(const si
 extern int show_unhandled_signals;
 
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
+extern void xxx(struct k_sigaction *ka);
 extern void exit_signals(struct task_struct *tsk);
 
 extern struct kmem_cache *sighand_cachep;
--- x/kernel/signal.c
+++ x/kernel/signal.c
@@ -2314,6 +2314,16 @@ relock:
 	return signr;
 }
 
+void xxx(struct k_sigaction *ka)
+{
+	sigset_t blocked;
+
+	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
+	if (!(ka->sa.sa_flags & SA_NODEFER))
+		sigaddset(&blocked, sig);
+	set_current_blocked(&blocked);
+}
+
 /*
  * It could be that complete_signal() picked us to notify about the
  * group-wide signal. Other threads should be notified now to take
--- x/arch/x86/kernel/signal.c
+++ x/arch/x86/kernel/signal.c
@@ -682,7 +682,6 @@ static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 		struct pt_regs *regs)
 {
-	sigset_t blocked;
 	int ret;
 
 	/* Are we from a system call? */
@@ -733,14 +732,10 @@ handle_signal(unsigned long sig, siginfo
 	 */
 	regs->flags &= ~X86_EFLAGS_TF;
 
-	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&blocked, sig);
-	set_current_blocked(&blocked);
+	xxx(ka);
 
 	tracehook_signal_handler(sig, info, ka, regs,
 				 test_thread_flag(TIF_SINGLESTEP));
-
 	return 0;
 }
 

