Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab0ESH5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:57:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:45603 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab0ESH5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:57:20 -0400
Date: Wed, 19 May 2010 07:56:43 GMT
From: tip-bot for Tony Breeds <tony@bakeyournoodle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       benh@kernel.crashing.org, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu, tony@bakeyournoodle.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       benh@kernel.crashing.org, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu, tony@bakeyournoodle.com
In-Reply-To: <20100519054636.GC12389@ozlabs.org>
References: <20100519054636.GC12389@ozlabs.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] mutex: Fix optimistic spinning vs. BKL
Message-ID: <tip-fd6be105b883244127a734ac9f14ae94a022dcc0@git.kernel.org>
Git-Commit-ID: fd6be105b883244127a734ac9f14ae94a022dcc0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 May 2010 07:56:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd6be105b883244127a734ac9f14ae94a022dcc0
Gitweb:     http://git.kernel.org/tip/fd6be105b883244127a734ac9f14ae94a022dcc0
Author:     Tony Breeds <tony@bakeyournoodle.com>
AuthorDate: Wed, 19 May 2010 15:46:36 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 May 2010 08:18:44 +0200

mutex: Fix optimistic spinning vs. BKL

Currently, we can hit a nasty case with optimistic
spinning on mutexes:

    CPU A tries to take a mutex, while holding the BKL

    CPU B tried to take the BLK while holding the mutex

This looks like a AB-BA scenario but in practice, is
allowed and happens due to the auto-release on
schedule() nature of the BKL.

In that case, the optimistic spinning code can get us
into a situation where instead of going to sleep, A
will spin waiting for B who is spinning waiting for
A, and the only way out of that loop is the
need_resched() test in mutex_spin_on_owner().

This patch fixes it by completely disabling spinning
if we own the BKL. This adds one more detail to the
extensive list of reasons why it's a bad idea for
kernel code to be holding the BKL.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: <stable@kernel.org>
LKML-Reference: <20100519054636.GC12389@ozlabs.org>
[ added an unlikely() attribute to the branch ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/mutex.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 632f04c..4c0b7b3 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -172,6 +172,13 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		struct thread_info *owner;
 
 		/*
+		 * If we own the BKL, then don't spin. The owner of
+		 * the mutex might be waiting on us to release the BKL.
+		 */
+		if (unlikely(current->lock_depth >= 0))
+			break;
+
+		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
