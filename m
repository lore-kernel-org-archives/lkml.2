Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0JBME7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 08:04:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55504 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab0JBME6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 08:04:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=cTAuU8yTMDQHs6pXNIWUJjrUeBwxvdD3wIcy/INLY/gdssvm+AGypKVjqG+ZzyrTK0
         g+UesjwJWnMRg7UkajKNF2XAb8IH3MHRB1gjWO0ItaHiRszCQ5nkXtRAuNVU3Rj0miPV
         2fT+QUHA/chTFP3eSCICVPLEfK9x9mhLtGHsc=
MIME-Version: 1.0
Date: Sat, 2 Oct 2010 20:04:57 +0800
Message-ID: <AANLkTimF+zy-qTmbtchGu_0Td7fZUsrsd7PNgkAdM8fA@mail.gmail.com>
Subject: Ask For Comment: add routines for exchanging data between sock buffer
 and scatter list
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Jens Axboe <axboe@kernel.dk>,
        Robert Love <robert.w.love@intel.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seems no routines provided for exchanging data directly
between sock buffer and scatter list in both scatterlist.c and skbuff.c,
so comes this work.
And it is hard to determine into which file these routines should be added,
so a head file is added.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

diff -Npur o/linux-2.6.36-rc4/include/skb_sg.h
m/linux-2.6.36-rc4/include/skb_sg.h
--- o/linux-2.6.36-rc4/include/skb_sg.h	1970-01-01 08:00:00.000000000 +0800
+++ m/linux-2.6.36-rc4/include/skb_sg.h	2010-10-02 19:21:18.000000000 +0800
@@ -0,0 +1,110 @@
+/*
+    Definition for exchanging data between sock buffer and scatter list
+
+    Copyright (C) Oct 2010 Hillf Danton <dhillf@gmail.com>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
+    MA 02110-1301  USA
+*/
+
+#ifndef __LINUX_SKB_SG_H
+#define __LINUX_SKB_SG_H
+
+#include <linux/scatterlist.h>
+#include <linux/skbuff.h>
+
+/*
+ * skb_copy_bits_to_sg - copy data from skb to sg list
+ * @len	length of data to be copied
+ *
+ * return the number of copied bytes
+ */
+
+static int skb_copy_bits_to_sg(struct sk_buff *skb, int offset_in_skb,
+                                             struct scatterlist *sg,
int offset_in_sg,
+                                             int len)
+{
+	int old = len;
+	struct sg_mapping_iter miter;
+
+	if (offset_in_skb >= skb->len)
+		return 0;
+	
+	/* skip offset in sg */
+	while (sg && offset_in_sg >= sg->length) {
+		offset_in_sg -= sg->length;
+		sg = sg_next(sg);
+	}
+	if (! sg)
+		return 0;
+
+	/* and go thru sg list */
+	while (len > 0 && sg) {
+		int this_len;
+		int err;
+		
+		sg_miter_start(&miter, sg, 1, SG_MITER_ATOMIC|SG_MITER_TO_SG);
+
+		if (offset_in_sg) {
+			/* we have to count this residual */
+			miter.__offset = offset_in_sg;
+			offset_in_sg = 0;
+		}
+
+		if (! sg_miter_next(&miter))
+			break;
+		
+		this_len = min(miter.length, len);
+		
+		err = skb_copy_bits(skb, offset_in_skb, miter.addr, this_len);
+
+		sg_miter_stop(&miter);
+
+		if (err)
+			break;
+
+		offset_in_skb += this_len;
+		len -= this_len;
+
+		sg = sg_next(sg);
+	}
+
+	return old - len;	
+}
+
+/*
+ * sg_fill_skb_page_desc - fill skb frags with info in sg list
+ * @index  the start index to fill
+ *
+ * return the number of filled frags
+ */
+
+static int sg_fill_skb_page_desc(struct sk_buff *skb, int index,
+                                                struct scatterlist *sg)
+{
+	int old = index;
+	struct page *page;
+	
+	for (; sg && index < MAX_SKB_FRAGS; index++) {
+		page = sg_page(sg);
+		get_page(page);
+		skb_add_rx_frag(skb, index, page, sg->offset, sg->length);
+		sg = sg_next(sg);
+	}
+	
+	return index - old;
+}
+
+#endif /* __LINUX_SKB_SG_H */
