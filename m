Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab1JZBsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:48:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45787 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab1JZBst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:48:49 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 01/13] ida: make ida_simple_get/put() IRQ safe
Date: Tue, 25 Oct 2011 18:48:27 -0700
Message-Id: <1319593719-19132-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319593719-19132-1-git-send-email-tj@kernel.org>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's often convenient to be able to release resource from IRQ context.
Make ida_simple_*() use irqsave/restore spin ops so that they are IRQ
safe.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 lib/idr.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index db040ce..dabdf79 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -944,6 +944,7 @@ int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
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
 
-- 
1.7.3.1

