Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab2GWBmQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:42:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53965 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860Ab2GWBmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:12 -0400
Message-Id: <20120723010654.273014446@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [ 018/108] macvtap: zerocopy: put page when fail to get all requested  user pages
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

commit 02ce04bb3d28c3333231f43bca677228dbc686fe upstream.

When get_user_pages_fast() fails to get all requested pages, we could not use
kfree_skb() to free it as it has not been put in the skb fragments. So we need
to call put_page() instead.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/macvtap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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



