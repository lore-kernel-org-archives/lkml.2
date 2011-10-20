Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1JTJB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:01:56 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:32805 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab1JTJBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:01:54 -0400
X-IronPort-AV: E=Sophos;i="4.69,378,1315195200"; 
   d="scan'208";a="167568447"
From: Ian Campbell <ian.campbell@citrix.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Ian Campbell <ian.campbell@citrix.com>,
        Christoph Hellwig <hch@infradead.org>,
        David Miller <davem@davemloft.net>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] mm: add a "struct page_frag" type containing a page, offset and length
Date: Thu, 20 Oct 2011 10:01:44 +0100
Message-ID: <1319101309-28431-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1319101275.3385.129.camel@zakaz.uk.xensource.com>
References: <1319101275.3385.129.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few network drivers currently use skb_frag_struct for this purpose but I have
patches which add additional fields and semantics there which these other uses
do not want.

A structure for reference sub-page regions seems like a generally useful thing
so do so instead of adding a network subsystem specific structure.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Jens Axboe <jaxboe@fusionio.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Miller <davem@davemloft.net>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
[since v1: s/struct subpage/struct page_frag/ on advice from Christoph]
[since v2: s/page_offset/offset/ on advice from Andrew]
---
 include/linux/mm_types.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 774b895..29971a5 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -135,6 +135,17 @@ struct page {
 #endif
 ;
 
+struct page_frag {
+	struct page *page;
+#if (BITS_PER_LONG > 32) || (PAGE_SIZE >= 65536)
+	__u32 offset;
+	__u32 size;
+#else
+	__u16 offset;
+	__u16 size;
+#endif
+};
+
 typedef unsigned long __nocast vm_flags_t;
 
 /*
-- 
1.7.2.5

