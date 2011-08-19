Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1HSN3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:29:08 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58716 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab1HSN3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:02 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732355"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Krishna Kumar <krkumar2@in.ibm.com>
Subject: [PATCH 33/75] macvtap: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:05 +0100
Message-ID: <1313760467-8598-33-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Shirley Ma <xma@...ibm.com>
Cc: Krishna Kumar <krkumar2@in.ibm.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/macvtap.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index ab96c31..7c3f84a 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -503,10 +503,10 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
 		skb->truesize += len;
 		atomic_add(len, &skb->sk->sk_wmem_alloc);
 		while (len) {
-			f = &skb_shinfo(skb)->frags[i];
-			f->page = page[i];
-			f->page_offset = base & ~PAGE_MASK;
-			f->size = min_t(int, len, PAGE_SIZE - f->page_offset);
+			__skb_fill_page_desc(
+				skb, i, page[i],
+				base & ~PAGE_MASK,
+				min_t(int, len, PAGE_SIZE - f->page_offset));
 			skb_shinfo(skb)->nr_frags++;
 			/* increase sk_wmem_alloc */
 			base += f->size;
-- 
1.7.2.5

