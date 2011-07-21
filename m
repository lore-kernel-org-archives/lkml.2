Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1GUA3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 20:29:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab1GUA3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 20:29:36 -0400
Date: Wed, 20 Jul 2011 20:29:21 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: axboe@kernel.dk, "Alasdair G. Kergon" <agk@redhat.com>
cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] backing-dev: use synchronize_rcu_expedited instead of
 synchronize_rcu
Message-ID: <Pine.LNX.4.64.1107202019420.26781@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens

Please would you consider taking this into the block tree? It seems to 
speed up device deletion enormously.

Mikulas

---

backing-dev: use synchronize_rcu_expedited instead of synchronize_rcu

synchronize_rcu sleeps several timer ticks. synchronize_rcu_expedited is 
much faster.

With 100Hz timer frequency, when we remove 10000 block devices with 
"dmsetup remove_all" command, it takes 27 minutes. With this patch, 
removing 10000 block devices takes only 15 seconds.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 mm/backing-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-3.0-rc7-fast/mm/backing-dev.c
===================================================================
--- linux-3.0-rc7-fast.orig/mm/backing-dev.c	2011-07-19 18:01:00.000000000 +0200
+++ linux-3.0-rc7-fast/mm/backing-dev.c	2011-07-19 18:01:07.000000000 +0200
@@ -505,7 +505,7 @@ static void bdi_remove_from_list(struct 
 	list_del_rcu(&bdi->bdi_list);
 	spin_unlock_bh(&bdi_lock);
 
-	synchronize_rcu();
+	synchronize_rcu_expedited();
 }
 
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
