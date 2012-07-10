Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab2GJFCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 01:02:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32811 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2GJFCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 01:02:35 -0400
Date: Tue, 10 Jul 2012 13:02:26 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, neilb@suse.de
Subject: [patch]block: stack unplug
Message-ID: <20120710050226.GA5835@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MD raid1 prepares to dispatch request in unplug callback. If make_request in
low level queue also uses unplug callback to dispatch request, the low level
queue's unplug callback will not be called. Recheck the callback list helps
this case.

Signed-off-by: Shaohua Li <shli@fusionio.com>

diff --git a/block/blk-core.c b/block/blk-core.c
index 93eb3e4..700cbfa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2900,17 +2900,16 @@ static void flush_plug_callbacks(struct blk_plug *plug)
 {
 	LIST_HEAD(callbacks);
 
-	if (list_empty(&plug->cb_list))
-		return;
-
-	list_splice_init(&plug->cb_list, &callbacks);
+	while (!list_empty(&plug->cb_list)) {
+		list_splice_init(&plug->cb_list, &callbacks);
 
-	while (!list_empty(&callbacks)) {
-		struct blk_plug_cb *cb = list_first_entry(&callbacks,
+		while (!list_empty(&callbacks)) {
+			struct blk_plug_cb *cb = list_first_entry(&callbacks,
 							  struct blk_plug_cb,
 							  list);
-		list_del(&cb->list);
-		cb->callback(cb);
+			list_del(&cb->list);
+			cb->callback(cb);
+		}
 	}
 }
 
