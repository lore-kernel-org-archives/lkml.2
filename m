Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab0ESFqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 01:46:39 -0400
Received: from ozlabs.org ([203.10.76.45]:56709 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab0ESFqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 01:46:38 -0400
Date: Wed, 19 May 2010 15:46:36 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, benh@kernel.crashing.org, stable@kernel.org,
       tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] mutex: Fix optimistic spinning vs. BKL
Message-ID: <20100519054636.GC12389@ozlabs.org>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
	hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
	benh@kernel.crashing.org, stable@kernel.org, tglx@linutronix.de,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-tip-commits@vger.kernel.org
References: <20100507042010.GR12389@ozlabs.org>
 <tip-227945799cc10d77c6ef812f3eb8a61a78689454@git.kernel.org>
 <20100518160838.GA20658@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100518160838.GA20658@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 06:08:38PM +0200, Ingo Molnar wrote:
> 
> * tip-bot for Tony Breeds <tony@bakeyournoodle.com> wrote:
> 
> > Commit-ID:  227945799cc10d77c6ef812f3eb8a61a78689454
> > Gitweb:     http://git.kernel.org/tip/227945799cc10d77c6ef812f3eb8a61a78689454
> > Author:     Tony Breeds <tony@bakeyournoodle.com>
> > AuthorDate: Fri, 7 May 2010 14:20:10 +1000
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Tue, 11 May 2010 17:07:24 +0200
> > 
> > mutex: Fix optimistic spinning vs. BKL
> 
> Tony, mind sending a version of this patch that does not 
> include a jiffies based spinning loop?

Subject: [PATCH] mutex: Fix optimistic spinning vs. BKL

Currently, we can hit a nasty case with optimistic spinning on
mutexes:

    CPU A tries to take a mutex, while holding the BKL

    CPU B tried to take the BLK while holding the mutex

This looks like a AB-BA scenario but in practice, is allowed and
happens due to the auto-release-on-schedule nature of the BKL.

In that case, the optimistic spinning code can get us into a situation
where instead of going to sleep, A will spin waiting for B who is
spinning waiting for A, and the only way out of that loop is the
need_resched() test in mutex_spin_on_owner().

This patch fixes both in a rather crude way. I completely disable
spinning if we own the BKL, and I add a safety timeout using jiffies
to fallback to sleeping if we end up spinning for more than 1 or 2
jiffies.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
---
 kernel/mutex.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 632f04c..c38d302 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -172,6 +172,13 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		struct thread_info *owner;
 
 		/*
+		 * If we own the BKL, then don't spin. The owner of the mutex
+		 * might be waiting on us to release the BKL.
+		 */
+		if (current->lock_depth >= 0)
+			break;
+
+		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
-- 
1.6.6.1


Yours Tony
