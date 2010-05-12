Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab0ELDWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:22:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42708 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab0ELDWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:22:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=L1/UT+O6Sdy0XXnkoWwdDBpodSKJ6biklymYCW+a8BZxU5r7H429Aiv0FoaMcN9cF
	RHeA73T81P2fEiRIybu4A==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 01/12] rwsem: test for no active locks in __rwsem_do_wake undo code
Date: Tue, 11 May 2010 20:20:51 -0700
Message-Id: <1273634462-2672-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273634462-2672-1-git-send-email-walken@google.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are no active threasd using a semaphore, it is always correct to
unqueue blocked threads. This seems to be what was intended in the undo code.

What was done instead, was to look for a sem count of zero - this is an
impossible situation, given that at least one thread is known to be queued
on the semaphore. The code might be correct as written, but it's hard to
reason about and it's not what was intended (otherwise the goto out would
have been unconditional).

Go for checking the active count - the alternative is not worth the headache.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rwsem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 3e3365e..8d6a13e 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -138,7 +138,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 
 	/* undo the change to count, but check for a transition 1->0 */
  undo:
-	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) != 0)
+	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) & RWSEM_ACTIVE_MASK)
 		goto out;
 	goto try_again;
 }
-- 
1.7.0.1

