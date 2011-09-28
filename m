Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab1I1Ol7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:41:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61099 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1I1Ol5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:41:57 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 2/2] virtio-net: Prevent NULL dereference
Date: Wed, 28 Sep 2011 17:40:55 +0300
Message-Id: <1317220855-9352-2-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1317220855-9352-1-git-send-email-levinsasha928@gmail.com>
References: <1317220855-9352-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevents a NULL dereference when the user has passed a length
longer than an actual buffer to virtio-net.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/net/virtio_net.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index bde0dec..4a53d2a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -208,12 +208,22 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 		return NULL;
 	}
 
-	while (len) {
+	while (len && page) {
 		set_skb_frag(skb, page, offset, &len);
 		page = (struct page *)page->private;
 		offset = 0;
 	}
 
+	/*
+	 * This is the case where we ran out of pages in our linked list, but
+	 * supposedly have more data to read.
+	 */	
+	if (len > 0) {
+		pr_debug("%s: missing data to assemble skb\n", skb->dev->name);
+		dev_kfree_skb(skb);
+		return NULL;
+	}
+
 	if (page)
 		give_pages(vi, page);
 
-- 
1.7.6.1

