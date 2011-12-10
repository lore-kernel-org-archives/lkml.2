Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1LJKxg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 05:53:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:53827 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab1LJKx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 05:53:26 -0500
Message-Id: <20111210104840.295857663@chello.nl>
User-Agent: quilt/0.48-1
Date: Sat, 10 Dec 2011 11:43:44 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: gregkh@suse.de, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ostrikov@nvidia.com, adobriyan@gmail.com,
        eric.dumazet@gmail.com, mingo@elte.hu, Oliver Neukum <oneukum@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/3] kref: Remove the memory barriers
References: <20111210104341.592561407@chello.nl>
Content-Disposition: inline; filename=kref-simplify-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1b0b3b9980e ("kref: fix CPU ordering with respect to krefs")
wrongly adds memory barriers to kref.

It states:

  some atomic operations are only atomic, not ordered. Thus a CPU is allowed
  to reorder memory references to an object to before the reference is
  obtained. This fixes it.

While true, it fails to show why this is a problem. I say it is not a
problem because if there is a race with kref_put() such that we could
end up referencing a free'd object without this memory barrier, we
would still have that race with the memory barrier.

The kref_put() in question could complete (and free the object) before
the atomic_inc() and we'd still be up shit creek.

The kref_init() case is even worse, if your object is published at this
time you're so wrong the memory barrier won't make a difference what
so ever. If its not published, the act of publishing should include
the needed barriers/locks to make sure all writes prior to the act of
publishing are complete such that others will only observe a complete
object.

Cc: adobriyan@gmail.com
Cc: eric.dumazet@gmail.com
Cc: mingo@elte.hu
Cc: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/kref.h |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6/include/linux/kref.h
===================================================================
--- linux-2.6.orig/include/linux/kref.h
+++ linux-2.6/include/linux/kref.h
@@ -28,7 +28,6 @@ struct kref {
 static inline void kref_init(struct kref *kref)
 {
 	atomic_set(&kref->refcount, 1);
-	smp_mb();
 }
 
 /**
@@ -39,7 +38,6 @@ static inline void kref_get(struct kref
 {
 	WARN_ON(!atomic_read(&kref->refcount));
 	atomic_inc(&kref->refcount);
-	smp_mb__after_atomic_inc();
 }
 
 /**


