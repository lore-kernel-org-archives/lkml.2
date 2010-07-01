Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab0GAUti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:49:38 -0400
Received: from kroah.org ([198.145.64.141]:47150 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932509Ab0GAUtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:33 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:28 2010
Message-Id: <20100701173428.143370669@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tony Breeds <tony@bakeyournoodle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 015/164] mutex: Fix optimistic spinning vs. BKL
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Breeds <tony@bakeyournoodle.com>

commit fd6be105b883244127a734ac9f14ae94a022dcc0 upstream.

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
LKML-Reference: <20100519054636.GC12389@ozlabs.org>
[ added an unlikely() attribute to the branch ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/mutex.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -172,6 +172,13 @@ __mutex_lock_common(struct mutex *lock,
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


