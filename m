Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab1HSNaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:30:08 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58759 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab1HSN36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:58 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732477"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <James.Bottomley@suse.de>,
        Karen Xie <kxie@chelsio.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 65/75] cxgbi: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:37 +0100
Message-ID: <1313760467-8598-65-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: Karen Xie <kxie@chelsio.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/cxgbi/libcxgbi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 77ac217..0debb06 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1812,7 +1812,7 @@ static int sgl_read_to_frags(struct scatterlist *sg, unsigned int sgoffset,
 
 		}
 		copy = min(datalen, sglen);
-		if (i && page == frags[i - 1].page &&
+		if (i && page == skb_frag_page(&frags[i - 1]) &&
 		    sgoffset + sg->offset ==
 			frags[i - 1].page_offset + frags[i - 1].size) {
 			frags[i - 1].size += copy;
@@ -1948,7 +1948,7 @@ int cxgbi_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
 
 			/* data fits in the skb's headroom */
 			for (i = 0; i < tdata->nr_frags; i++, frag++) {
-				char *src = kmap_atomic(frag->page,
+				char *src = kmap_atomic(skb_frag_page(frag),
 							KM_SOFTIRQ0);
 
 				memcpy(dst, src+frag->page_offset, frag->size);
@@ -1963,7 +1963,7 @@ int cxgbi_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
 		} else {
 			/* data fit into frag_list */
 			for (i = 0; i < tdata->nr_frags; i++)
-				get_page(tdata->frags[i].page);
+				__skb_frag_ref(&tdata->frags[i]);
 
 			memcpy(skb_shinfo(skb)->frags, tdata->frags,
 				sizeof(skb_frag_t) * tdata->nr_frags);
-- 
1.7.2.5

