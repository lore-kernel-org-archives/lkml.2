Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab0GGJu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 05:50:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40925 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab0GGJu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 05:50:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 7 Jul 2010 11:50:14 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH v2] firewire: cdev: check write quadlet request length to
 avoid buffer overflow
To: Clemens Ladisch <clemens@ladisch.de>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.cb22c58cc57838c0@s5r6.in-berlin.de>
Message-ID: <tkrat.e922615a6f88a33e@s5r6.in-berlin.de>
References: <4C29C1CA.1050705@ladisch.de>
 <tkrat.cb22c58cc57838c0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check that the data length of a write quadlet request actually is large
enough for a quadlet.  Otherwise, fw_fill_request could access the four
bytes after the end of the outbound_transaction_event structure.

Reported-by: Clemens Ladisch <clemens@ladisch.de>

Since struct outbound_transaction_event *e is slab-allocated, such an
access may hit unallocated memory only if sizeof(*e) == 256 or 512 or
any other power of 2 above 2**2.  In kernel 2.6.34, sizeof(*e) is > 128
and < 256 on 32bit architectures, and > 256 and < 512 on 64bit
architectures.  Thus the only problem is that a bogus write quadlet
request with user-specified length of < 3 will put 1...4 random bytes
into the packet payload; but this is the users's problem then, not the
kernel's.

Hence the corner case handling can be optimized by a !(sizeof(*e) & 255)
check as a weaker form of a sizeof(*e) == 256 or 512 check.  This is a
constant expression and will cause the whole check to be omitted by the
compiler's dead code elimination.

Of course this relies on certain behavior of the slab allocator.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -564,6 +564,11 @@ static int init_request(struct client *c
 	    (request->length > 4096 || request->length > 512 << speed))
 		return -EIO;
 
+	/* Corner case: Access past the end of *e in fw_fill_request() */
+	if (request->tcode == TCODE_WRITE_QUADLET_REQUEST &&
+	    request->length < 4 && (sizeof(*e) & 255) == 0)
+		return -EINVAL;
+
 	e = kmalloc(sizeof(*e) + request->length, GFP_KERNEL);
 	if (e == NULL)
 		return -ENOMEM;

-- 
Stefan Richter
-=====-==-=- -=== --===
http://arcgraph.de/sr/

