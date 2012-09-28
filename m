Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061Ab2I1UgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:36:01 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43081 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965019Ab2I1Uag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:30:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 169/218] macvtap: zerocopy: put page when fail to get all requested user pages
Date: Fri, 28 Sep 2012 13:16:26 -0700
Message-Id: <20120928201520.919924416@linuxfoundation.org>
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

commit 02ce04bb3d28c3333231f43bca677228dbc686fe upstream.

When get_user_pages_fast() fails to get all requested pages, we could not use
kfree_skb() to free it as it has not been put in the skb fragments. So we need
to call put_page() instead.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/macvtap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -533,9 +533,10 @@ static int zerocopy_sg_from_iovec(struct
 		if (i + size > MAX_SKB_FRAGS)
 			return -EMSGSIZE;
 		num_pages = get_user_pages_fast(base, size, 0, &page[i]);
-		if (num_pages != size)
-			/* put_page is in skb free */
-			return -EFAULT;
+		if (num_pages != size) {
+			for (i = 0; i < num_pages; i++)
+				put_page(page[i]);
+		}
 		truesize = size * PAGE_SIZE;
 		skb->data_len += len;
 		skb->len += len;


