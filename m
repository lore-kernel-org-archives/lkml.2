Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab1FVQDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 12:03:51 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:40584 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932471Ab1FVQDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 12:03:48 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-uvc-devel@lists.berlios.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Smelkov <kirr@mns.spb.ru>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC, PATCH] USB: EHCI: Allow users to override 80% max periodic bandwidth
Date: Wed, 22 Jun 2011 20:02:47 +0400
Message-Id: <1308758567-8205-1-git-send-email-kirr@mns.spb.ru>
X-Mailer: git-send-email 1.7.6.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are cases, when 80% max isochronous bandwidth is too limiting.

For example I have two USB video capture cards which stream uncompressed
video, and to stream full NTSC + PAL videos we'd need

    NTSC 640x480 YUV422 @30fps      ~17.6 MB/s
    PAL  720x576 YUV422 @25fps      ~19.7 MB/s

isoc bandwidth.

Now, due to limited alt settings in capture devices NTSC one ends up
streaming with max_pkt_size=2688  and  PAL with max_pkt_size=2892, both
with interval=1. In terms of microframe time allocation this gives

    NTSC    ~53us
    PAL     ~57us

and together

    ~110us  >  100us == 80% of 125us uframe time.

So those two devices can't work together simultaneously because the'd
over allocate isochronous bandwidth.

80% seemed a bit arbitrary to me, and I've tried to raise it to 90% and
both devices started to work together, so I though sometimes it would be
a good idea for users to override hardcoded default of max 80% isoc
bandwidth.

After all, isn't it a user who should decide how to load the bus? If I
can live with 10% or even 5% bulk bandwidth that should be ok. I'm a USB
newcomer, but that 80% seems to be chosen pretty arbitrary to me, just
to serve as a reasonable default.

NOTE: for two streams with max_pkt_size=3072 (worst case) both time
allocation would be 60us+60us=120us which is 96% periodic bandwidth
leaving 4% for bulk and control. I think this should work too.

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-hcd.c   |   16 ++++++++++++++++
 drivers/usb/host/ehci-sched.c |   17 +++++++----------
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index c606b02..1d36e72 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -112,6 +112,14 @@ static unsigned int hird;
 module_param(hird, int, S_IRUGO);
 MODULE_PARM_DESC(hird, "host initiated resume duration, +1 for each 75us\n");
 
+/*
+ * max periodic time per microframe
+ * (be careful, USB 2.0 requires it to be 100us = 80% of 125us)
+ */
+static unsigned int uframe_periodic_max = 100;
+module_param(uframe_periodic_max, uint, S_IRUGO);
+MODULE_PARM_DESC(uframe_periodic_max, "maximum allowed periodic part of a microframe, us");
+
 #define	INTR_MASK (STS_IAA | STS_FATAL | STS_PCD | STS_ERR | STS_INT)
 
 /*-------------------------------------------------------------------------*/
@@ -571,6 +579,14 @@ static int ehci_init(struct usb_hcd *hcd)
 	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
 
 	/*
+	 * tell user, if using non-standard (80% == 100 usec/uframe) bandwidth
+	 */
+	if (uframe_periodic_max != 100)
+		ehci_info(ehci, "using non-standard max periodic bandwith "
+				"(%u%% == %u usec/uframe)",
+				100*uframe_periodic_max/125, uframe_periodic_max);
+
+	/*
 	 * hw default: 1K periodic list heads, one per frame.
 	 * periodic_size can shrink by USBCMD update if hcc_params allows.
 	 */
diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index d12426f..fb374f2 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -172,7 +172,7 @@ periodic_usecs (struct ehci_hcd *ehci, unsigned frame, unsigned uframe)
 		}
 	}
 #ifdef	DEBUG
-	if (usecs > 100)
+	if (usecs > uframe_periodic_max)
 		ehci_err (ehci, "uframe %d sched overrun: %d usecs\n",
 			frame * 8 + uframe, usecs);
 #endif
@@ -709,11 +709,8 @@ static int check_period (
 	if (uframe >= 8)
 		return 0;
 
-	/*
-	 * 80% periodic == 100 usec/uframe available
-	 * convert "usecs we need" to "max already claimed"
-	 */
-	usecs = 100 - usecs;
+	/* convert "usecs we need" to "max already claimed" */
+	usecs = uframe_periodic_max - usecs;
 
 	/* we "know" 2 and 4 uframe intervals were rejected; so
 	 * for period 0, check _every_ microframe in the schedule.
@@ -1286,9 +1283,9 @@ itd_slot_ok (
 {
 	uframe %= period;
 	do {
-		/* can't commit more than 80% periodic == 100 usec */
+		/* can't commit more than uframe_periodic_max usec */
 		if (periodic_usecs (ehci, uframe >> 3, uframe & 0x7)
-				> (100 - usecs))
+				> (uframe_periodic_max - usecs))
 			return 0;
 
 		/* we know urb->interval is 2^N uframes */
@@ -1345,7 +1342,7 @@ sitd_slot_ok (
 #endif
 
 		/* check starts (OUT uses more than one) */
-		max_used = 100 - stream->usecs;
+		max_used = uframe_periodic_max - stream->usecs;
 		for (tmp = stream->raw_mask & 0xff; tmp; tmp >>= 1, uf++) {
 			if (periodic_usecs (ehci, frame, uf) > max_used)
 				return 0;
@@ -1354,7 +1351,7 @@ sitd_slot_ok (
 		/* for IN, check CSPLIT */
 		if (stream->c_usecs) {
 			uf = uframe & 7;
-			max_used = 100 - stream->c_usecs;
+			max_used = uframe_periodic_max - stream->c_usecs;
 			do {
 				tmp = 1 << uf;
 				tmp <<= 8;
-- 
1.7.6.rc1

