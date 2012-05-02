Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab2EBDr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:47:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758617Ab2EBDqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:46:51 -0400
Subject: [V2 PATCH 1/9] macvtap: zerocopy: fix offset calculation when
 building skb
To: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 02 May 2012 11:41:30 +0800
Message-ID: <20120502034130.11782.25906.stgit@amd-6168-8-1.englab.nay.redhat.com>
In-Reply-To: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: StGit/0.16-1-g60c4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the offset calculation when building skb:

- offset1 were used as skb data offset not vector offset
- reset offset to zero only when we advance to next vector

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/macvtap.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

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

