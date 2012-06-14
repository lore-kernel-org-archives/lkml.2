Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab2FNX6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:58:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46571 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab2FNX6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:58:37 -0400
Message-Id: <20120614235645.759520610@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:57:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dean Nelson <dnelson@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Roman Kagan <rkagan@parallels.com>
Subject: [ 17/20] e1000: save skb counts in TX to avoid cache misses
In-Reply-To: <20120614235648.GA6552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dean Nelson <dnelson@redhat.com>

commit 31c15a2f24ebdab14333d9bf5df49757842ae2ec upstream.

Virtual Machines with emulated e1000 network adapter running on Parallels'
server were seeing kernel panics due to the e1000 driver dereferencing an
unexpected NULL pointer retrieved from buffer_info->skb.

The problem has been addressed for the e1000e driver, but not for the e1000.
Since the two drivers share similar code in the affected area, a port of the
following e1000e driver commit solves the issue for the e1000 driver:

commit 9ed318d546a29d7a591dbe648fd1a2efe3be1180
Author: Tom Herbert <therbert@google.com>
Date:   Wed May 5 14:02:27 2010 +0000

    e1000e: save skb counts in TX to avoid cache misses

    In e1000_tx_map, precompute number of segements and bytecounts which
    are derived from fields in skb; these are stored in buffer_info.  When
    cleaning tx in e1000_clean_tx_irq use the values in the associated
    buffer_info for statistics counting, this eliminates cache misses
    on skb fields.

Signed-off-by: Dean Nelson <dnelson@redhat.com>
Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Roman Kagan <rkagan@parallels.com>

---
 drivers/net/e1000/e1000.h      |    2 ++
 drivers/net/e1000/e1000_main.c |   18 +++++++++---------
 2 files changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/net/e1000/e1000.h
+++ b/drivers/net/e1000/e1000.h
@@ -150,6 +150,8 @@ struct e1000_buffer {
 	unsigned long time_stamp;
 	u16 length;
 	u16 next_to_watch;
+	unsigned int segs;
+	unsigned int bytecount;
 	u16 mapped_as_page;
 };
 
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -2798,7 +2798,7 @@ static int e1000_tx_map(struct e1000_ada
 	struct e1000_buffer *buffer_info;
 	unsigned int len = skb_headlen(skb);
 	unsigned int offset = 0, size, count = 0, i;
-	unsigned int f;
+	unsigned int f, bytecount, segs;
 
 	i = tx_ring->next_to_use;
 
@@ -2899,7 +2899,13 @@ static int e1000_tx_map(struct e1000_ada
 		}
 	}
 
+	segs = skb_shinfo(skb)->gso_segs ?: 1;
+	/* multiply data chunks by size of headers */
+	bytecount = ((segs - 1) * skb_headlen(skb)) + skb->len;
+
 	tx_ring->buffer_info[i].skb = skb;
+	tx_ring->buffer_info[i].segs = segs;
+	tx_ring->buffer_info[i].bytecount = bytecount;
 	tx_ring->buffer_info[first].next_to_watch = i;
 
 	return count;
@@ -3573,14 +3579,8 @@ static bool e1000_clean_tx_irq(struct e1
 			cleaned = (i == eop);
 
 			if (cleaned) {
-				struct sk_buff *skb = buffer_info->skb;
-				unsigned int segs, bytecount;
-				segs = skb_shinfo(skb)->gso_segs ?: 1;
-				/* multiply data chunks by size of headers */
-				bytecount = ((segs - 1) * skb_headlen(skb)) +
-				            skb->len;
-				total_tx_packets += segs;
-				total_tx_bytes += bytecount;
+				total_tx_packets += buffer_info->segs;
+				total_tx_bytes += buffer_info->bytecount;
 			}
 			e1000_unmap_and_free_tx_resource(adapter, buffer_info);
 			tx_desc->upper.data = 0;


