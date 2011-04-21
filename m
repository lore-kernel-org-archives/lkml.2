Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab1DUTEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:04:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab1DUTEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:04:35 -0400
Date: Thu, 21 Apr 2011 21:03:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>, Chris Metcalf <cmetcalf@tilera.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: arch/tile/kernel/hardwall.c:do_hardwall_trap unsafe/wrong usage of
	->sighand
Message-ID: <20110421190332.GA2570@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org> <1302031310-1765-3-git-send-email-matt@console-pimps.org> <20110413194231.GA15330@redhat.com> <20110414113456.5182a582@mfleming-mobl1.ger.corp.intel.com> <20110414190012.GA23517@redhat.com> <20110416140813.5c90b1fc@mfleming-mobl1.ger.corp.intel.com> <20110418164513.GA25930@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418164513.GA25930@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18, Oleg Nesterov wrote:
>
> On 04/16, Matt Fleming wrote:
> >
> > 	3. I suspect most people find the rules of ->sighand pretty
> > 	confusing. Just look at
> >
> > 		arch/tile/kernel/hardwall.c:do_hardwall_trap()
> >
> > 	the use of siglock there looks buggy to me.
>
> Indeed, I agree. It shouldn't use __group_send_sig_info() at all.
> I'll send the patch. Nobody outside of signal code should play with
> ->sighand, this is almost always wrong.

Hmm. It turns out, I can't make the patch because I do not understand
what this code tries to do.

hardwall_activate() adds the thread to hardwall_list, but do_hardwall_trap()
sends the signal to the whole process. I know nothing about arch/tile and
probably this is correct, but could you confirm this?

Note that SIGILL can be delivered to another thread in the thread-group, is
it correct?

Also. Is it supposed that SIGILL can have a hanlder or can be blocked, or
it should always kill the whole thread group?

I think we need the patch below, assuming that SIGILL should be sent to
the single thread and it is fine to have a handler for SIGILL.

Oleg.

--- sigprocmask/arch/tile/kernel/hardwall.c~1_sighand	2011-04-06 21:33:42.000000000 +0200
+++ sigprocmask/arch/tile/kernel/hardwall.c	2011-04-21 20:56:36.000000000 +0200
@@ -268,12 +268,10 @@ void __kprobes do_hardwall_trap(struct p
 	found_processes = 0;
 	list_for_each_entry(p, &rect->task_head, thread.hardwall_list) {
 		BUG_ON(p->thread.hardwall != rect);
-		if (p->sighand) {
+		if (!(p->flags & PF_EXITING)) {
 			found_processes = 1;
 			pr_notice("hardwall: killing %d\n", p->pid);
-			spin_lock(&p->sighand->siglock);
-			__group_send_sig_info(info.si_signo, &info, p);
-			spin_unlock(&p->sighand->siglock);
+			do_send_sig_info(info.si_signo, &info, p, false);
 		}
 	}
 	if (!found_processes)

