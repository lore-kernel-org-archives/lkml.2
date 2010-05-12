Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0ELKj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 06:39:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab0ELKjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 06:39:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] rwsem: Test for no active locks in __rwsem_do_wake undo code
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Michel Lespinasse <walken@google.com>,
       David Howells <dhowells@redhat.com>
Date: Wed, 12 May 2010 11:38:45 +0100
Message-ID: <20100512103845.27535.31708.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Lespinasse <walken@google.com>

If there are no active threasd using a semaphore, it is always correct to
unqueue blocked threads.  This seems to be what was intended in the undo code.

What was done instead, was to look for a sem count of zero - this is an
impossible situation, given that at least one thread is known to be queued on
the semaphore.  The code might be correct as written, but it's hard to reason
about and it's not what was intended (otherwise the goto out would have been
unconditional).

Go for checking the active count - the alternative is not worth the headache.

Signed-off-by: Michel Lespinasse <walken@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 lib/rwsem.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 3e3365e..ceba8e2 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -136,9 +136,10 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
  out:
 	return sem;
 
-	/* undo the change to count, but check for a transition 1->0 */
+	/* undo the change to the active count, but check for a transition
+	 * 1->0 */
  undo:
-	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) != 0)
+	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) & RWSEM_ACTIVE_MASK)
 		goto out;
 	goto try_again;
 }

