Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab2DTSAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:00:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757305Ab2DTSAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:00:22 -0400
Date: Fri, 20 Apr 2012 19:59:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] mm: set task exit code before complete_vfork_done()
Message-ID: <20120420175934.GA31905@redhat.com>
References: <20120409200336.8368.63793.stgit@zurg> <20120412080948.26401.23572.stgit@zurg> <20120412235446.GA4815@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412235446.GA4815@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, Oleg Nesterov wrote:
>
> Damn, Konstantin I have to admit, I'll try to find another technical
> reason against mm-correctly-synchronize-rss-counters-at-exit-exec.patch
> even with this fix ;)
>
> Most probably I am wrong, but it looks overcomplicated. Somehow I
> dislike irrationally the fact you moved mm_release() from exit_mm().

And perhaps you can help me to discredit your patch?

It turns out, I do not really understand this code in do_exit:

	/* sync mm's RSS info before statistics gathering */
	if (tsk->mm)
		sync_mm_rss(tsk->mm);

Which "statistics gathering" ? Probably I missed something, but
after the quick grep it seems to me that this is only needed for
taskstats_exit()->xacct_add_tsk().

So why we can't simply add sync_mm_rss() into xacct_add_tsk() ?
Yes, this way we do not "account" put_user(clear_child_tid) but
I think we do not care.

IOW, what do you think about the trivial patch below? Uncompiled,
untested, probably incomplete. acct_update_integrals() looks
suspicious too.

Oleg.

--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -91,6 +91,7 @@ void xacct_add_tsk(struct taskstats *sta
 	stats->virtmem = p->acct_vm_mem1 * PAGE_SIZE / MB;
 	mm = get_task_mm(p);
 	if (mm) {
+		sync_mm_rss(mm);
 		/* adjust to KB unit */
 		stats->hiwater_rss   = get_mm_hiwater_rss(mm) * PAGE_SIZE / KB;
 		stats->hiwater_vm    = get_mm_hiwater_vm(mm)  * PAGE_SIZE / KB;
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -643,6 +643,8 @@ static void exit_mm(struct task_struct *
 	mm_release(tsk, mm);
 	if (!mm)
 		return;
+
+	sync_mm_rss(mm);
 	/*
 	 * Serialize with any possible pending coredump.
 	 * We must hold mmap_sem around checking core_state
@@ -960,9 +962,6 @@ void do_exit(long code)
 				preempt_count());
 
 	acct_update_integrals(tsk);
-	/* sync mm's RSS info before statistics gathering */
-	if (tsk->mm)
-		sync_mm_rss(tsk->mm);
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
 		hrtimer_cancel(&tsk->signal->real_timer);
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -823,10 +823,10 @@ static int exec_mmap(struct mm_struct *m
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
-	sync_mm_rss(old_mm);
 	mm_release(tsk, old_mm);
 
 	if (old_mm) {
+		sync_mm_rss(old_mm);
 		/*
 		 * Make sure that if there is a core dump in progress
 		 * for the old mm, we get out and die instead of going

