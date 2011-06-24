Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab1FXQtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:49:40 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:38229 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab1FXQtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:49:13 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-uvc-devel@lists.berlios.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH v2 2/2] USB: EHCI: Allow users to override 80% max periodic bandwidth
Date: Fri, 24 Jun 2011 20:48:08 +0400
Message-Id: <9bddf2a6062b2fc27db87de58a335e7c6b920e53.1308933456.git.kirr@mns.spb.ru>
X-Mailer: git-send-email 1.7.6.rc3
In-Reply-To: <cover.1308933456.git.kirr@mns.spb.ru>
References: <cover.1308933456.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1308933456.git.kirr@mns.spb.ru>
References: <cover.1308933456.git.kirr@mns.spb.ru>
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
newcomer, but that 80% set in stone by USB 2.0 specification seems to be
chosen pretty arbitrary to me, just to serve as a reasonable default.

NOTE: for two streams with max_pkt_size=3072 (worst case) both time
allocation would be 60us+60us=120us which is 96% periodic bandwidth
leaving 4% for bulk and control.  Alan Stern suggested that bulk then
would be problematic (less than 300*8 bittimes left per microframe), but
I think that is still enough for control traffic.

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/usb/host/ehci-hcd.c   |    6 +++
 drivers/usb/host/ehci-sched.c |   17 +++----
 drivers/usb/host/ehci-sysfs.c |   98 +++++++++++++++++++++++++++++++++++++++--
 drivers/usb/host/ehci.h       |    2 +
 4 files changed, 109 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 8306155..4ee62be 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -572,6 +572,12 @@ static int ehci_init(struct usb_hcd *hcd)
 	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
 
 	/*
+	 * by default set standard 80% (== 100 usec/uframe) max periodic
+	 * bandwidth as required by USB 2.0
+	 */
+	ehci->uframe_periodic_max = 100;
+
+	/*
 	 * hw default: 1K periodic list heads, one per frame.
 	 * periodic_size can shrink by USBCMD update if hcc_params allows.
 	 */
diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index 6c9fbe3..2abf854 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -172,7 +172,7 @@ periodic_usecs (struct ehci_hcd *ehci, unsigned frame, unsigned uframe)
 		}
 	}
 #ifdef	DEBUG
-	if (usecs > 100)
+	if (usecs > ehci->uframe_periodic_max)
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
+	usecs = ehci->uframe_periodic_max - usecs;
 
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
+				> (ehci->uframe_periodic_max - usecs))
 			return 0;
 
 		/* we know urb->interval is 2^N uframes */
@@ -1345,7 +1342,7 @@ sitd_slot_ok (
 #endif
 
 		/* check starts (OUT uses more than one) */
-		max_used = 100 - stream->usecs;
+		max_used = ehci->uframe_periodic_max - stream->usecs;
 		for (tmp = stream->raw_mask & 0xff; tmp; tmp >>= 1, uf++) {
 			if (periodic_usecs (ehci, frame, uf) > max_used)
 				return 0;
@@ -1354,7 +1351,7 @@ sitd_slot_ok (
 		/* for IN, check CSPLIT */
 		if (stream->c_usecs) {
 			uf = uframe & 7;
-			max_used = 100 - stream->c_usecs;
+			max_used = ehci->uframe_periodic_max - stream->c_usecs;
 			do {
 				tmp = 1 << uf;
 				tmp <<= 8;
diff --git a/drivers/usb/host/ehci-sysfs.c b/drivers/usb/host/ehci-sysfs.c
index 347c8cb..fe212ef 100644
--- a/drivers/usb/host/ehci-sysfs.c
+++ b/drivers/usb/host/ehci-sysfs.c
@@ -74,21 +74,111 @@ static ssize_t store_companion(struct device *dev,
 }
 static DEVICE_ATTR(companion, 0644, show_companion, store_companion);
 
+
+/*
+ * Display / Set uframe_periodic_max
+ */
+static ssize_t show_uframe_periodic_max(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct ehci_hcd		*ehci;
+	int			n;
+
+	ehci = hcd_to_ehci(bus_to_hcd(dev_get_drvdata(dev)));
+	n = scnprintf(buf, PAGE_SIZE, "%d\n", ehci->uframe_periodic_max);
+	return n;
+}
+
+
+static ssize_t store_uframe_periodic_max(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct ehci_hcd		*ehci;
+	unsigned		uframe_periodic_max;
+	unsigned		frame, uframe, allocated;
+	unsigned long		flags;
+	ssize_t			ret;
+
+	ehci = hcd_to_ehci(bus_to_hcd(dev_get_drvdata(dev)));
+	if (sscanf(buf, "%u", &uframe_periodic_max) != 1)
+		return -EINVAL;
+
+	if (uframe_periodic_max < 100 || uframe_periodic_max >= 125) {
+		ehci_info(ehci, "rejecting invalid request for "
+				"uframe_periodic_max=%u\n", uframe_periodic_max);
+		return -EINVAL;
+	}
+
+	ret = -EINVAL;
+
+	/*
+	 * lock, so that our checking does not race with possible periodic
+	 * bandwidth allocation through submitting new urbs.
+	 */
+	spin_lock_irqsave (&ehci->lock, flags);
+
+	/*
+         * for request to decrease max periodic bandwidth, we have to check
+         * every microframe in the schedule to see whether the decrease is
+         * possible.
+	 */
+	if (uframe_periodic_max < ehci->uframe_periodic_max)
+		for (frame = 0; frame < ehci->periodic_size; ++frame)
+			for (uframe = 0; uframe < 7; ++uframe) {
+				allocated = periodic_usecs (ehci, frame, uframe);
+				if (allocated > uframe_periodic_max) {
+					ehci_info(ehci,
+		"cannot decrease uframe_periodic_max becase periodic bandwidth "
+		"is already allocated (%u > %u)\n",
+						  allocated, uframe_periodic_max);
+					goto out_unlock;
+				}
+			}
+
+	/* increasing is always ok */
+
+	ehci_info(ehci, "setting max periodic bandwidth to %u%% "
+			"(== %u usec/uframe)\n",
+			100*uframe_periodic_max/125, uframe_periodic_max);
+
+	if (uframe_periodic_max != 100)
+		ehci_warn(ehci, "max periodic bandwidth set is non-standard\n");
+
+	ehci->uframe_periodic_max = uframe_periodic_max;
+	ret = count;
+
+out_unlock:
+	spin_unlock_irqrestore (&ehci->lock, flags);
+	return ret;
+}
+static DEVICE_ATTR(uframe_periodic_max, 0644, show_uframe_periodic_max, store_uframe_periodic_max);
+
+
 static inline int create_sysfs_files(struct ehci_hcd *ehci)
 {
+	struct device	*controller = ehci_to_hcd(ehci)->self.controller;
 	int	i = 0;
 
 	/* with integrated TT there is no companion! */
 	if (!ehci_is_TDI(ehci))
-		i = device_create_file(ehci_to_hcd(ehci)->self.controller,
-				       &dev_attr_companion);
+		i = device_create_file(controller, &dev_attr_companion);
+	if (i)
+		goto out;
+
+	i = device_create_file(controller, &dev_attr_uframe_periodic_max);
+out:
 	return i;
 }
 
 static inline void remove_sysfs_files(struct ehci_hcd *ehci)
 {
+	struct device	*controller = ehci_to_hcd(ehci)->self.controller;
+
 	/* with integrated TT there is no companion! */
 	if (!ehci_is_TDI(ehci))
-		device_remove_file(ehci_to_hcd(ehci)->self.controller,
-				   &dev_attr_companion);
+		device_remove_file(controller, &dev_attr_companion);
+
+	device_remove_file(controller, &dev_attr_uframe_periodic_max);
 }
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index bd6ff48..fa3129f 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -87,6 +87,8 @@ struct ehci_hcd {			/* one per controller */
 	union ehci_shadow	*pshadow;	/* mirror hw periodic table */
 	int			next_uframe;	/* scan periodic, start here */
 	unsigned		periodic_sched;	/* periodic activity count */
+	unsigned		uframe_periodic_max; /* max periodic time per uframe */
+
 
 	/* list of itds & sitds completed while clock_frame was still active */
 	struct list_head	cached_itd_list;
-- 
1.7.6.rc3

