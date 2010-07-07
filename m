Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0GGMho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 08:37:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42824 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0GGMhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 08:37:42 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 7 Jul 2010 14:37:30 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH v4] firewire: cdev: check write quadlet request length to
 avoid buffer overflow
To: Clemens Ladisch <clemens@ladisch.de>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.d41b80d60ff7d2cc@s5r6.in-berlin.de>
Message-ID: <tkrat.7f6d54033f30bb68@s5r6.in-berlin.de>
References: <4C29C1CA.1050705@ladisch.de>
 <tkrat.cb22c58cc57838c0@s5r6.in-berlin.de>
 <tkrat.e922615a6f88a33e@s5r6.in-berlin.de>
 <tkrat.b2582c62a3eaf0ab@s5r6.in-berlin.de> <4C346B44.2020407@ladisch.de>
 <tkrat.d41b80d60ff7d2cc@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clemens Ladisch <clemens@ladisch.de>

Check that the data length of a write quadlet request actually is large
enough for a quadlet.  Otherwise, fw_fill_request could access the four
bytes after the end of the outbound_transaction_event structure.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

Modification of Clemens' change:  Consolidate the check in
init_request() which is used by the affected ioctl_send_request() and
ioctl_send_broadcast_request() and the unaffected
ioctl_send_stream_packet(), to save a few lines of code.

Note, since struct outbound_transaction_event *e is slab-allocated, such
an out-of-bounds access won't hit unallocated memory but may result in a
(virtually impossible to exploit) information disclosure.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -564,6 +564,10 @@ static int init_request(struct client *c
 	    (request->length > 4096 || request->length > 512 << speed))
 		return -EIO;
 
+	if (request->tcode == TCODE_WRITE_QUADLET_REQUEST &&
+	    request->length < 4)
+		return -EINVAL;
+
 	e = kmalloc(sizeof(*e) + request->length, GFP_KERNEL);
 	if (e == NULL)
 		return -ENOMEM;

-- 
Stefan Richter
-=====-==-=- -=== --===
http://arcgraph.de/sr/

