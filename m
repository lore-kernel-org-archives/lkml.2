Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab2EBDrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:47:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758642Ab2EBDrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:47:05 -0400
Subject: [V2 PATCH 2/9] macvtap: zerocopy: fix truesize underestimation
To: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 02 May 2012 11:41:44 +0800
Message-ID: <20120502034144.11782.88947.stgit@amd-6168-8-1.englab.nay.redhat.com>
In-Reply-To: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: StGit/0.16-1-g60c4
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

