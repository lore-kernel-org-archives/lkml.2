Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab2EBDri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:47:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758648Ab2EBDrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:47:14 -0400
Subject: [V2 PATCH 3/9] macvtap: zerocopy: put page when fail to get all
 requested user pages
To: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 02 May 2012 11:41:58 +0800
Message-ID: <20120502034157.11782.66606.stgit@amd-6168-8-1.englab.nay.redhat.com>
In-Reply-To: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: StGit/0.16-1-g60c4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When get_user_pages_fast() fails to get all requested pages, we could not use
kfree_skb() to free it as it has not been put in the skb fragments. So we need
to call put_page() instead.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/macvtap.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 7cb2684..9ab182a 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -531,9 +531,11 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
 		size = ((base & ~PAGE_MASK) + len + ~PAGE_MASK) >> PAGE_SHIFT;
 		num_pages = get_user_pages_fast(base, size, 0, &page[i]);
 		if ((num_pages != size) ||
-		    (num_pages > MAX_SKB_FRAGS - skb_shinfo(skb)->nr_frags))
-			/* put_page is in skb free */
+		    (num_pages > MAX_SKB_FRAGS - skb_shinfo(skb)->nr_frags)) {
+			for (i = 0; i < num_pages; i++)
+				put_page(page[i]);
 			return -EFAULT;
+		}
 		truesize = size * PAGE_SIZE;
 		skb->data_len += len;
 		skb->len += len;

