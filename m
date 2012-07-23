Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab2GWBmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:42:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53962 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857Ab2GWBmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:11 -0400
Message-Id: <20120723010654.135814246@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [ 017/108] macvtap: zerocopy: fix truesize underestimation
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit 4ef67ebedffa44ed9939b34708ac2fee06d2f65f upstream.

As the skb fragment were pinned/built from user pages, we should
account the page instead of length for truesize.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/macvtap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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



