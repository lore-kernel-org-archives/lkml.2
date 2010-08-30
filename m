Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab0H3Que (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:50:34 -0400
Received: from mail119.messagelabs.com ([216.82.241.195]:58225 "EHLO
	mail119.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab0H3Qud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:50:33 -0400
X-VirusChecked: Checked
X-Env-Sender: jcarlyle@motorola.com
X-Msg-Ref: server-11.tower-119.messagelabs.com!1283187030!46122477!1
X-StarScan-Version: 6.2.4; banners=-,-,-
X-Originating-IP: [129.188.136.8]
In-Reply-To: <4C7BD8BE.7050600@kernel.org>
References: <4C7BD8BE.7050600@kernel.org>
From: Jeffrey Carlyle <jeff.carlyle@motorola.com>
To: Tejun Heo <tj@kernel.org>
Date: Mon, 30 Aug 2010 11:19:56 -0500
Subject: [PATCH v6] scatterlist: prevent invalid free when alloc fails
Cc: OLUSANYA SOYANNWO <olusanya.soyannwo@motorola.com>,
        <linux-kernel@vger.kernel.org>, Hu Tao <taohu@motorola.com>,
        <jaxboe@fusionio.com>, <torvalds@osdl.org>,
        Jeffrey Carlyle <jeff.carlyle@motorola.com>
Message-Id: <20100830165022.96032603843@il93ubuntu.localdomain>
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When alloc fails, free_table is being called. Depending on the number of
bytes requested, we determine if we are going to call _get_free_page()
or kmalloc(). When alloc fails, our math is wrong (due to sg_size - 1),
and the last buffer is wrongfully assumed to have been allocated by
kmalloc. Hence, kfree gets called and a panic occurs.

Signed-off-by: Jeffrey Carlyle <jeff.carlyle@motorola.com>
Signed-off-by: Olusanya Soyannwo <c23746@motorola.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>
---
 lib/scatterlist.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index a5ec428..ecdea70 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -248,8 +248,18 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents,
 		left -= sg_size;
 
 		sg = alloc_fn(alloc_size, gfp_mask);
-		if (unlikely(!sg))
+		if (unlikely(!sg)) {
+			/*
+			 * Adjust entry count to reflect that the last
+			 * entry of the previous table won't be used for
+			 * linkage.  Without this, sg_kfree() may get
+			 * confused.
+			 */
+			if (prv)
+				table->nents = ++table->orig_nents;
+
 			return -ENOMEM;
+		}
 
 		sg_init_table(sg, alloc_size);
 		table->nents = table->orig_nents += sg_size;
-- 
1.6.3.3

