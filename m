Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032819Ab2I1Uah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:30:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964981Ab2I1Uaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:30:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 167/218] macvtap: zerocopy: fix offset calculation when building skb
Date: Fri, 28 Sep 2012 13:16:24 -0700
Message-Id: <20120928201520.679250618@linuxfoundation.org>
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

commit 3afc9621f15701c557e60f61eba9242bac2771dd upstream.

This patch fixes the offset calculation when building skb:

- offset1 were used as skb data offset not vector offset
- reset offset to zero only when we advance to next vector

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/macvtap.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -506,10 +506,11 @@ static int zerocopy_sg_from_iovec(struct
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
@@ -520,13 +521,13 @@ static int zerocopy_sg_from_iovec(struct
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
 		if (i + size > MAX_SKB_FRAGS)
 			return -EMSGSIZE;
@@ -548,7 +549,7 @@ static int zerocopy_sg_from_iovec(struct
 			len -= size;
 			i++;
 		}
-		offset1 = 0;
+		offset = 0;
 		++from;
 	}
 	return 0;


