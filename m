Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175Ab2I1Ugn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:36:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63188 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965004Ab2I1Uad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:30:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 168/218] macvtap: zerocopy: fix truesize underestimation
Date: Fri, 28 Sep 2012 13:16:25 -0700
Message-Id: <20120928201520.790138548@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit 4ef67ebedffa44ed9939b34708ac2fee06d2f65f upstream.

As the skb fragment were pinned/built from user pages, we should
account the page instead of length for truesize.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/macvtap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -520,6 +520,7 @@ static int zerocopy_sg_from_iovec(struct
 		struct page *page[MAX_SKB_FRAGS];
 		int num_pages;
 		unsigned long base;
+		unsigned long truesize;
 
 		len = from->iov_len - offset;
 		if (!len) {
@@ -535,10 +536,11 @@ static int zerocopy_sg_from_iovec(struct
 		if (num_pages != size)
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


