Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab0ELDWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:22:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42691 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab0ELDWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:22:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=uRz/NL3Tm+fjGx/C5zEs1NeDsEHZ4yPW8Q8DcelZ61aWXGK7U95T1Py6Lk7fnKX6E
	iA9U8w5zRogGFOCLfRYEw==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 06/12] rwsem: wake queued readers when other readers are active
Date: Tue, 11 May 2010 20:20:56 -0700
Message-Id: <1273634462-2672-7-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273634462-2672-1-git-send-email-walken@google.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change addresses the following situation:

- Thread A holds the rwsem for write
- Thread B tries to acquire the rwsem for read; blocks & gets queued
- Thread A releases the rwsem, notices active count goes back to 0
- Thread C acquires the rwsem for read
- Thread A acquires the spinlock & tries to wake thread B, but fails because
  active count is not zero anymore.

In this situation, it would be perfectly fine to let threads B and C work
in parallel as they each only want a read acquire on the rwsem. We can
recognize this situation and let A wake B as long as there are no active
writers on the rwsem.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rwsem.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 92c8f8e..9d0899b 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -115,8 +115,8 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 
  retry_readers:
 	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
-	if (!downgrading && (oldcount & RWSEM_ACTIVE_MASK))
-		/* Someone grabbed the sem already */
+	if (!downgrading && (oldcount < RWSEM_WAITING_BIAS))
+		/* Someone grabbed the sem for write already */
 		goto undo_readers;
 
 	next = sem->wait_list.next;
@@ -143,7 +143,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	goto retry_writer;
 
  undo_readers:
-	if (rwsem_atomic_update(-adjustment, sem) & RWSEM_ACTIVE_MASK)
+	if (rwsem_atomic_update(-adjustment, sem) < RWSEM_WAITING_BIAS)
 		goto out;
 	goto retry_readers;
 }
-- 
1.7.0.1

