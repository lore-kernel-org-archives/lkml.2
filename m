Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1JZUdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:33:18 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40588 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab1JZUdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:33:17 -0400
Date: Wed, 26 Oct 2011 13:33:11 -0700
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: [PATCH] ida: make ida_simple_get/put() IRQ safe
Message-ID: <20111026203311.GF24261@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's often convenient to be able to release resource from IRQ context.
Make ida_simple_*() use irqsave/restore spin ops so that they are IRQ
safe.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
---
Andrew, can you please route this through mm?

Thank you.

 lib/idr.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: work/lib/idr.c
===================================================================
--- work.orig/lib/idr.c
+++ work/lib/idr.c
@@ -944,6 +944,7 @@ int ida_simple_get(struct ida *ida, unsi
 {
 	int ret, id;
 	unsigned int max;
+	unsigned long flags;
 
 	BUG_ON((int)start < 0);
 	BUG_ON((int)end < 0);
@@ -959,7 +960,7 @@ again:
 	if (!ida_pre_get(ida, gfp_mask))
 		return -ENOMEM;
 
-	spin_lock(&simple_ida_lock);
+	spin_lock_irqsave(&simple_ida_lock, flags);
 	ret = ida_get_new_above(ida, start, &id);
 	if (!ret) {
 		if (id > max) {
@@ -969,7 +970,7 @@ again:
 			ret = id;
 		}
 	}
-	spin_unlock(&simple_ida_lock);
+	spin_unlock_irqrestore(&simple_ida_lock, flags);
 
 	if (unlikely(ret == -EAGAIN))
 		goto again;
@@ -985,10 +986,12 @@ EXPORT_SYMBOL(ida_simple_get);
  */
 void ida_simple_remove(struct ida *ida, unsigned int id)
 {
+	unsigned long flags;
+
 	BUG_ON((int)id < 0);
-	spin_lock(&simple_ida_lock);
+	spin_lock_irqsave(&simple_ida_lock, flags);
 	ida_remove(ida, id);
-	spin_unlock(&simple_ida_lock);
+	spin_unlock_irqrestore(&simple_ida_lock, flags);
 }
 EXPORT_SYMBOL(ida_simple_remove);
 
