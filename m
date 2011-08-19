Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab1HSNdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:33:00 -0400
Received: from smtp.citrix.com ([66.165.176.89]:64883 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab1HSNaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:30:01 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158355"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Robert Love <robert.w.love@intel.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>, devel@open-fcoe.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 66/75] fcoe: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:38 +0100
Message-ID: <1313760467-8598-66-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/fcoe/fcoe.c           |    2 +-
 drivers/scsi/fcoe/fcoe_transport.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ba710e3..3416ab6 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1514,7 +1514,7 @@ int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 			return -ENOMEM;
 		}
 		frag = &skb_shinfo(skb)->frags[skb_shinfo(skb)->nr_frags - 1];
-		cp = kmap_atomic(frag->page, KM_SKB_DATA_SOFTIRQ)
+		cp = kmap_atomic(skb_frag_page(frag), KM_SKB_DATA_SOFTIRQ)
 			+ frag->page_offset;
 	} else {
 		cp = (struct fcoe_crc_eof *)skb_put(skb, tlen);
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 41068e8..f6613f9 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -108,8 +108,9 @@ u32 fcoe_fc_crc(struct fc_frame *fp)
 		len = frag->size;
 		while (len > 0) {
 			clen = min(len, PAGE_SIZE - (off & ~PAGE_MASK));
-			data = kmap_atomic(frag->page + (off >> PAGE_SHIFT),
-					   KM_SKB_DATA_SOFTIRQ);
+			data = kmap_atomic(
+				skb_frag_page(frag) + (off >> PAGE_SHIFT),
+				KM_SKB_DATA_SOFTIRQ);
 			crc = crc32(crc, data + (off & ~PAGE_MASK), clen);
 			kunmap_atomic(data, KM_SKB_DATA_SOFTIRQ);
 			off += clen;
-- 
1.7.2.5

