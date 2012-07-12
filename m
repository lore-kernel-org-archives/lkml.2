Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298Ab2GLXDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:03:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63192 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162026Ab2GLXC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:02:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 05/68] net: sock: validate data_len before allocating skb in sock_alloc_send_pskb()
Date: Thu, 12 Jul 2012 16:01:39 -0700
Message-Id: <20120712175035.892790805@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jason Wang <jasowang@redhat.com>

[ Upstream commit cc9b17ad29ecaa20bfe426a8d4dbfb94b13ff1cc ]

We need to validate the number of pages consumed by data_len, otherwise frags
array could be overflowed by userspace. So this patch validate data_len and
return -EMSGSIZE when data_len may occupies more frags than MAX_SKB_FRAGS.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1501,6 +1501,11 @@ struct sk_buff *sock_alloc_send_pskb(str
 	gfp_t gfp_mask;
 	long timeo;
 	int err;
+	int npages = (data_len + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
+
+	err = -EMSGSIZE;
+	if (npages > MAX_SKB_FRAGS)
+		goto failure;
 
 	gfp_mask = sk->sk_allocation;
 	if (gfp_mask & __GFP_WAIT)
@@ -1519,14 +1524,12 @@ struct sk_buff *sock_alloc_send_pskb(str
 		if (atomic_read(&sk->sk_wmem_alloc) < sk->sk_sndbuf) {
 			skb = alloc_skb(header_len, gfp_mask);
 			if (skb) {
-				int npages;
 				int i;
 
 				/* No pages, we're done... */
 				if (!data_len)
 					break;
 
-				npages = (data_len + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
 				skb->truesize += data_len;
 				skb_shinfo(skb)->nr_frags = npages;
 				for (i = 0; i < npages; i++) {


