Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab1CXQUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:20:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:45203 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab1CXQUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:20:07 -0400
Date: Thu, 24 Mar 2011 16:19:20 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, peterz@infradead.org,
        chris.mason@oracle.com, tj@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        chris.mason@oracle.com, torvalds@linux-foundation.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110323153727.GB12003@htj.dyndns.org>
References: <20110323153727.GB12003@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] mutex: Do adaptive spinning in mutex_trylock()
Message-ID: <tip-bcedb5fa5e7cfeea30b6effe0c47d8f09ffc82df@git.kernel.org>
Git-Commit-ID: bcedb5fa5e7cfeea30b6effe0c47d8f09ffc82df
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 24 Mar 2011 16:19:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bcedb5fa5e7cfeea30b6effe0c47d8f09ffc82df
Gitweb:     http://git.kernel.org/tip/bcedb5fa5e7cfeea30b6effe0c47d8f09ffc82df
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Thu, 24 Mar 2011 10:41:51 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Mar 2011 11:16:49 +0100

mutex: Do adaptive spinning in mutex_trylock()

Adaptive owner spinning is used in mutex_lock().
This patch also applies it to mutex_trylock().

btrfs has developed custom locking to avoid excessive context
switches in its btree implementation.  Generally, doing away
with the custom implementation and just using the mutex shows
better behavior; however, there's an interesting distinction in
the custom implemention of trylock.  It distinguishes between
simple trylock and tryspin, where the former just tries once and
then fail while the latter does some spinning before giving up.

Currently, mutex_trylock() doesn't use adaptive spinning.  It
tries just once.  I got curious whether using adaptive spinning
on mutex_trylock() would be beneficial and it seems so, for
btrfs anyway.

The following results are from "dbench 50" run on an opteron two
socket eight core machine with 4GiB of memory and an OCZ vertex
SSD. During the run, disk stays mostly idle and all CPUs are
fully occupied and the difference in locking performance becomes
quite visible.

SIMPLE is with the locking simplification patch[1] applied.
i.e. it basically just uses mutex.  SPIN is with this patch
applied on top - mutex_trylock() uses adaptive spinning.

        USER   SYSTEM   SIRQ    CXTSW  THROUGHPUT
 SIMPLE 61107  354977    217  8099529  845.100 MB/sec
 SPIN   63140  364888    214  6840527  879.077 MB/sec

On various runs, the adaptive spinning trylock consistently
posts higher throughput.  The amount of difference varies but it
outperforms consistently.

In general, using adaptive spinning on trylock makes sense as
trylock failure usually leads to costly unlock-relock sequence.

[1] http://article.gmane.org/gmane.comp.file-systems.btrfs/9658

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>
LKML-Reference: <20110323153727.GB12003@htj.dyndns.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/mutex.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 03465e8..2510cd1 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -442,6 +442,15 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
 	unsigned long flags;
 	int prev;
 
+	preempt_disable();
+
+	if (mutex_spin(lock)) {
+		mutex_set_owner(lock);
+		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		preempt_enable();
+		return 1;
+	}
+
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	prev = atomic_xchg(&lock->count, -1);
@@ -455,6 +464,7 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
 		atomic_set(&lock->count, 0);
 
 	spin_unlock_mutex(&lock->wait_lock, flags);
+	preempt_enable();
 
 	return prev == 1;
 }
