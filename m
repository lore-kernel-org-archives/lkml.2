Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921Ab0FEKHN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 06:07:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:65455 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846Ab0FEKHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 06:07:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,366,1272870000"; 
   d="scan'208";a="804988064"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
       herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [RFC PATCH v7 11/19] Use callback to deal with skb_release_data() specially.
Date: Sat,  5 Jun 2010 18:14:50 +0800
Message-Id: <1275732899-5423-11-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1275732899-5423-10-git-send-email-xiaohui.xin@intel.com>
References: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com>
 <1275732899-5423-2-git-send-email-xiaohui.xin@intel.com>
 <1275732899-5423-3-git-send-email-xiaohui.xin@intel.com>
 <1275732899-5423-4-git-send-email-xiaohui.xin@intel.com>
 <1275732899-5423-5-git-send-email-xiaohui.xin@intel.com>
 <1275732899-5423-6-git-send-email-xiaohui.xin@intel.com>
 <1275732899-5423-7-git-send-email-xiaohui.xin@intel.com>
 <1275732899-5423-8-git-send-email-xiaohui.xin@intel.com>
 <1275732899-5423-9-git-send-email-xiaohui.xin@intel.com>
 <1275732899-5423-10-git-send-email-xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

If buffer is external, then use the callback to destruct
buffers.

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---
 net/core/skbuff.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 37587f0..418457c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -385,6 +385,11 @@ static void skb_clone_fraglist(struct sk_buff *skb)
 
 static void skb_release_data(struct sk_buff *skb)
 {
+	/* check if the skb has external buffers, we have use destructor_arg
+	 * here to indicate
+	 */
+	struct skb_external_page *ext_page = skb_shinfo(skb)->destructor_arg;
+
 	if (!skb->cloned ||
 	    !atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
 			       &skb_shinfo(skb)->dataref)) {
@@ -397,6 +402,12 @@ static void skb_release_data(struct sk_buff *skb)
 		if (skb_has_frags(skb))
 			skb_drop_fraglist(skb);
 
+		/* if the skb has external buffers, use destructor here,
+		 * since after that skb->head will be kfree, in case skb->head
+		 * from external buffer cannot use kfree to destroy.
+		 */
+		if (dev_is_mpassthru(skb->dev) && ext_page && ext_page->dtor)
+			ext_page->dtor(ext_page);
 		kfree(skb->head);
 	}
 }
-- 
1.5.4.4

