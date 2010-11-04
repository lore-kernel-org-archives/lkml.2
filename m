Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0KDIsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 04:48:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:34881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab0KDIoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 04:44:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,294,1286175600"; 
   d="scan'208";a="570251184"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [PATCH v14 06/17] Use callback to deal with skb_release_data() specially.
Date: Thu,  4 Nov 2010 17:05:02 +0800
Message-Id: <bd4abd1568dfc75daed6713f9a568bf0f895de4b.1288860477.git.xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1288861513-5707-1-git-send-email-xiaohui.xin@intel.com>
References: <1288861513-5707-1-git-send-email-xiaohui.xin@intel.com>
In-Reply-To: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1288860477.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1288860477.git.xiaohui.xin@intel.com>
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
 net/core/skbuff.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c83b421..5e6d69c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -210,6 +210,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 
 	/* make sure we initialize shinfo sequentially */
 	shinfo = skb_shinfo(skb);
+	shinfo->destructor_arg = NULL;
 	memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
 	atomic_set(&shinfo->dataref, 1);
 
@@ -343,6 +344,13 @@ static void skb_release_data(struct sk_buff *skb)
 		if (skb_has_frags(skb))
 			skb_drop_fraglist(skb);
 
+		if (skb->dev && dev_is_mpassthru(skb->dev)) {
+			struct skb_ext_page *ext_page =
+				skb_shinfo(skb)->destructor_arg;
+			if (ext_page && ext_page->dtor)
+				ext_page->dtor(ext_page);
+		}
+
 		kfree(skb->head);
 	}
 }
-- 
1.7.3

