Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab0GMKXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:23:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797Ab0GMKX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:23:28 -0400
Date: Tue, 13 Jul 2010 06:22:18 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-mm@kvack.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc: riel@redhat.com, cl@linux-foundation.org, a.p.zijlstra@chello.nl,
        Xiaotian Feng <dfeng@redhat.com>, linux-kernel@vger.kernel.org,
        lwang@redhat.com, penberg@cs.helsinki.fi, akpm@linux-foundation.org,
        davem@davemloft.net
Message-Id: <20100713102217.2835.75779.sendpatchset@danny.redhat>
In-Reply-To: <20100713101650.2835.15245.sendpatchset@danny.redhat>
References: <20100713101650.2835.15245.sendpatchset@danny.redhat>
Subject: [PATCH -mmotm 29/30] fix null pointer deref in swap_entry_free
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ea7b13006f42f7dcadd1bfb874d5e525b4c259e3 Mon Sep 17 00:00:00 2001
From: Xiaotian Feng <dfeng@redhat.com>
Date: Tue, 13 Jul 2010 13:44:08 +0800
Subject: [PATCH 29/30] fix null pointer deref in swap_entry_free

Commit b3a27d uses p->bdev->bd_disk, this will lead a null pointer
deref with swap over nfs.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 mm/swapfile.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index d8a05e4..3eb53fc 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -577,7 +577,6 @@ static unsigned char swap_entry_free(struct swap_info_struct *p,
 
 	/* free if no reference */
 	if (!usage) {
-		struct gendisk *disk = p->bdev->bd_disk;
 		if (offset < p->lowest_bit)
 			p->lowest_bit = offset;
 		if (offset > p->highest_bit)
@@ -587,9 +586,11 @@ static unsigned char swap_entry_free(struct swap_info_struct *p,
 			swap_list.next = p->type;
 		nr_swap_pages++;
 		p->inuse_pages--;
-		if ((p->flags & SWP_BLKDEV) &&
-				disk->fops->swap_slot_free_notify)
-			disk->fops->swap_slot_free_notify(p->bdev, offset);
+		if (p->flags & SWP_BLKDEV) {
+			struct gendisk *disk = p->bdev->bd_disk;
+			if (disk->fops->swap_slot_free_notify)
+				disk->fops->swap_slot_free_notify(p->bdev, offset);
+		}
 	}
 
 	return usage;
-- 
1.7.1.1

