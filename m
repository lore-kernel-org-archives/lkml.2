Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab2DPGQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 02:16:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab2DPGQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 02:16:41 -0400
Subject: [PATCH 2/6] macvtap: zerocopy: fix truesize underestimation
To: netdev@vger.kernel.org, xma@us.ibm.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, mst@redhat.com
From: Jason Wang <jasowang@redhat.com>
Cc: ebiederm@xmission.com
Date: Mon, 16 Apr 2012 14:07:59 +0800
Message-ID: <20120416060758.14140.40252.stgit@intel-e5620-16-2.englab.nay.redhat.com>
In-Reply-To: <20120416060749.14140.19433.stgit@intel-e5620-16-2.englab.nay.redhat.com>
References: <20120416060749.14140.19433.stgit@intel-e5620-16-2.englab.nay.redhat.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the skb fragment were pinned/built from user pages, we should
account the page instead of length for truesize.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/macvtap.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index bd4a70d..7cb2684 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -519,6 +519,7 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
 		struct page *page[MAX_SKB_FRAGS];
 		int num_pages;
 		unsigned long base;
+		unsigned long truesize;
 
 		len = from->iov_len - offset;
 		if (!len) {
@@ -533,10 +534,11 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
 		    (num_pages > MAX_SKB_FRAGS - skb_shinfo(skb)->nr_frags))
 			/* put_page is in skb free */
 			return -EFAULT;
+		truesize = size * PAGE_SIZE;
 		skb->data_len += len;
 		skb->len += len;
-		skb->truesize += len;
-		atomic_add(len, &skb->sk->sk_wmem_alloc);
+		skb->truesize += truesize;
+		atomic_add(truesize, &skb->sk->sk_wmem_alloc);
 		while (len) {
 			int off = base & ~PAGE_MASK;
 			int size = min_t(int, len, PAGE_SIZE - off);

