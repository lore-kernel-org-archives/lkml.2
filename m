Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab2BEWrr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:47:47 -0500
Received: from 1wt.eu ([62.212.114.60]:61864 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab2BEW0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:18 -0500
Message-Id: <20120205220950.642723239@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:17 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 28/91] cfq-iosched: fix locking around ioc->ioc_data assignment
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit ab4bd22d3cce6977dc039664cc2d052e3147d662 upstream.

Since we are modifying this RCU pointer, we need to hold
the lock protecting it around it.

This fixes a potential reuse and double free of a cfq
io_context structure. The bug has been in CFQ for a long
time, it hit very few people but those it did hit seemed
to see it a lot.

Tracked in RH bugzilla here:

https://bugzilla.redhat.com/show_bug.cgi?id=577968

Credit goes to Paul Bolle for figuring out that the issue
was around the one-hit ioc->ioc_data cache. Thanks to his
hard work the issue is now fixed.

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/cfq-iosched.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/block/cfq-iosched.c
===================================================================
--- longterm-2.6.27.orig/block/cfq-iosched.c	2012-02-05 22:34:34.185915429 +0100
+++ longterm-2.6.27/block/cfq-iosched.c	2012-02-05 22:34:38.850917663 +0100
@@ -1286,8 +1286,11 @@
 	cic->dead_key = (unsigned long) cic->key;
 	cic->key = NULL;
 
-	if (ioc->ioc_data == cic)
+	if (rcu_dereference(ioc->ioc_data) == cic) {
+		spin_lock(&ioc->lock);
 		rcu_assign_pointer(ioc->ioc_data, NULL);
+		spin_unlock(&ioc->lock);
+	}
 
 	if (cic->cfqq[ASYNC]) {
 		cfq_exit_cfqq(cfqd, cic->cfqq[ASYNC]);


