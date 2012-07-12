Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162223Ab2GLWpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:45:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51498 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162250Ab2GLWpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:45:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Josh Boyer <jwboyer@redhat.com>
Subject: [ 172/187] macvtap: zerocopy: validate vectors before building skb
Date: Thu, 12 Jul 2012 15:35:28 -0700
Message-Id: <20120712191539.247999600@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit b92946e2919134ebe2a4083e4302236295ea2a73 upstream.

There're several reasons that the vectors need to be validated:

- Return error when caller provides vectors whose num is greater than UIO_MAXIOV.
- Linearize part of skb when userspace provides vectors grater than MAX_SKB_FRAGS.
- Return error when userspace provides vectors whose total length may exceed
- MAX_SKB_FRAGS * PAGE_SIZE.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/macvtap.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -528,9 +528,10 @@ static int zerocopy_sg_from_iovec(struct
 		}
 		base = (unsigned long)from->iov_base + offset1;
 		size = ((base & ~PAGE_MASK) + len + ~PAGE_MASK) >> PAGE_SHIFT;
+		if (i + size > MAX_SKB_FRAGS)
+			return -EMSGSIZE;
 		num_pages = get_user_pages_fast(base, size, 0, &page[i]);
-		if ((num_pages != size) ||
-		    (num_pages > MAX_SKB_FRAGS - skb_shinfo(skb)->nr_frags))
+		if (num_pages != size)
 			/* put_page is in skb free */
 			return -EFAULT;
 		skb->data_len += len;
@@ -647,7 +648,7 @@ static ssize_t macvtap_get_user(struct m
 	int err;
 	struct virtio_net_hdr vnet_hdr = { 0 };
 	int vnet_hdr_len = 0;
-	int copylen;
+	int copylen = 0;
 	bool zerocopy = false;
 
 	if (q->flags & IFF_VNET_HDR) {
@@ -676,15 +677,31 @@ static ssize_t macvtap_get_user(struct m
 	if (unlikely(len < ETH_HLEN))
 		goto err;
 
+	err = -EMSGSIZE;
+	if (unlikely(count > UIO_MAXIOV))
+		goto err;
+
 	if (m && m->msg_control && sock_flag(&q->sk, SOCK_ZEROCOPY))
 		zerocopy = true;
 
 	if (zerocopy) {
+		/* Userspace may produce vectors with count greater than
+		 * MAX_SKB_FRAGS, so we need to linearize parts of the skb
+		 * to let the rest of data to be fit in the frags.
+		 */
+		if (count > MAX_SKB_FRAGS) {
+			copylen = iov_length(iv, count - MAX_SKB_FRAGS);
+			if (copylen < vnet_hdr_len)
+				copylen = 0;
+			else
+				copylen -= vnet_hdr_len;
+		}
 		/* There are 256 bytes to be copied in skb, so there is enough
 		 * room for skb expand head in case it is used.
 		 * The rest buffer is mapped from userspace.
 		 */
-		copylen = vnet_hdr.hdr_len;
+		if (copylen < vnet_hdr.hdr_len)
+			copylen = vnet_hdr.hdr_len;
 		if (!copylen)
 			copylen = GOODCOPY_LEN;
 	} else


