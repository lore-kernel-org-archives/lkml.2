Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab2GWBmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:42:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53963 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859Ab2GWBmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:11 -0400
Message-Id: <20120723010653.983024423@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [ 016/108] macvtap: zerocopy: fix offset calculation when building skb
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

commit 3afc9621f15701c557e60f61eba9242bac2771dd upstream.

This patch fixes the offset calculation when building skb:

- offset1 were used as skb data offset not vector offset
- reset offset to zero only when we advance to next vector

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/macvtap.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 0427c65..bd4a70d 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -505,10 +505,11 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
 		if (copy > size) {
 			++from;
 			--count;
-		}
+			offset = 0;
+		} else
+			offset += size;
 		copy -= size;
 		offset1 += size;
-		offset = 0;
 	}
 
 	if (len == offset1)
@@ -519,13 +520,13 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
 		int num_pages;
 		unsigned long base;
 
-		len = from->iov_len - offset1;
+		len = from->iov_len - offset;
 		if (!len) {
-			offset1 = 0;
+			offset = 0;
 			++from;
 			continue;
 		}
-		base = (unsigned long)from->iov_base + offset1;
+		base = (unsigned long)from->iov_base + offset;
 		size = ((base & ~PAGE_MASK) + len + ~PAGE_MASK) >> PAGE_SHIFT;
 		num_pages = get_user_pages_fast(base, size, 0, &page[i]);
 		if ((num_pages != size) ||
@@ -546,7 +547,7 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
 			len -= size;
 			i++;
 		}
-		offset1 = 0;
+		offset = 0;
 		++from;
 	}
 	return 0;



