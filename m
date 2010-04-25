Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0DYJRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 05:17:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:55113 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab0DYJRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 05:17:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,269,1270450800"; 
   d="scan'208";a="561295830"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
       jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [RFC][PATCH v4 08/18] Ignore skb_reserve() when device is using external buffer.
Date: Sun, 25 Apr 2010 17:19:55 +0800
Message-Id: <1272187206-18534-8-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1272187206-18534-7-git-send-email-xiaohui.xin@intel.com>
References: <1272187206-18534-1-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-2-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-3-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-4-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-5-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-6-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-7-git-send-email-xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

Make the skb->data and skb->head from external buffer
to be consistent, we ignore the room reserved by driver
for kernel skb.

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
Signed-off-by: Zhao Yu <yzhao81@gmail.com>
Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---
 include/linux/skbuff.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8949b15..4458dc8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1206,6 +1206,15 @@ static inline int skb_tailroom(const struct sk_buff *skb)
  */
 static inline void skb_reserve(struct sk_buff *skb, int len)
 {
+	/* Since skb_reserve() is only for an empty buffer,
+	 * and when the skb is getting external buffer, we cannot
+	 * retain the external buffer has the same reserved space
+	 * in the header which kernel allocatd skb has, so have to
+	 * ignore this. And we have recorded the external buffer
+	 * info in the destructor_arg field, so use it as indicator.
+	 */
+	if (skb_shinfo(skb)->destructor_arg)
+		return;
 	skb->data += len;
 	skb->tail += len;
 }
-- 
1.5.4.4

