Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab3AHXgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:36:15 -0500
Received: from mail.windriver.com ([147.11.1.11]:63165 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab3AHXgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:36:12 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 01/77] net: sock: validate data_len before allocating skb in sock_alloc_send_pskb()
Date: Tue, 8 Jan 2013 18:34:40 -0500
Message-ID: <1357688156-25387-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cc9b17ad29ecaa20bfe426a8d4dbfb94b13ff1cc upstream.

We need to validate the number of pages consumed by data_len, otherwise frags
array could be overflowed by userspace. So this patch validate data_len and
return -EMSGSIZE when data_len may occupies more frags than MAX_SKB_FRAGS.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/sock.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 78b7087..4b45ad8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1425,6 +1425,11 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
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
@@ -1443,14 +1448,12 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
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
-- 
1.7.12.1

