Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab1GCQil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 12:38:41 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:35628 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154Ab1GCQiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 12:38:12 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-uvc-devel@lists.berlios.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Smelkov <kirr@mns.spb.ru>
Subject: =?UTF-8?q?=5BPATCH=20v4=202/2=5D=20USB=3A=20EHCI=3A=20Allow=20users=20to=20override=2080=25=20max=20periodic=20bandwidth?=
Date: Sun,  3 Jul 2011 20:36:57 +0400
Message-Id: <814bb70c49a62111145aafe705884065ae0af869.1309710420.git.kirr@mns.spb.ru>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <cover.1309710420.git.kirr@mns.spb.ru>
References: <cover.1309710420.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1309710420.git.kirr@mns.spb.ru>
References: <cover.1309710420.git.kirr@mns.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

NOTE 1
~~~~~~

for two streams with max_pkt_size=3072 (worst case) both time
allocation would be 60us+60us=120us which is 96% periodic bandwidth
leaving 4% for bulk and control.  Alan Stern suggested that bulk then
would be problematic (less than 300*8 bittimes left per microframe), but
I think that is still enough for control traffic.

NOTE 2
~~~~~~

Sarah Sharp expressed concern that maxing out periodic bandwidth
could lead to vendor-specific hardware bugs on host controllers, because

> It's entirely possible that you'll run into
> vendor-specific bugs if you try to pack the schedule with isochronous
> transfers.  I don't think any hardware designer would seriously test or
> validate their hardware with a schedule that is basically a violation of
> the USB bus spec (more than 80% for periodic transfers).

So far I've only tested this patch on my HP Mini 5103 with N10 chipset

    kirr@mini:~$ lspci
    00:00.0 Host bridge: Intel Corporation N10 Family DMI Bridge
    00:02.0 VGA compatible controller: Intel Corporation N10 Family Integrated Graphics Controller
    00:02.1 Display controller: Intel Corporation N10 Family Integrated Graphics Controller
    00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 1 (rev 02)
    00:1c.3 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 4 (rev 02)
    00:1d.0 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 (rev 02)
    00:1d.3 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 (rev 02)
    00:1d.7 USB Controller: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
    00:1f.0 ISA bridge: Intel Corporation NM10 Family LPC Controller (rev 02)
    00:1f.2 SATA controller: Intel Corporation N10/ICH7 Family SATA AHCI Controller (rev 02)
    01:00.0 Network controller: Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller (rev 01)
    02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8059 PCI-E Gigabit Ethernet Controller (rev 11)

and the system works stable with 110us/uframe (~88%) isoc bandwith allocated for
above-mentioned isochronous transfers.

NOTE 3
~~~~~~

This feature is off by default. I mean max periodic bandwidth is set to
100us/uframe by default exactly as it was before the patch. So only those of us
who need the extreme settings are taking the risk - normal users who do not
alter uframe_periodic_max sysfs attribute should not see any change at all.

NOTE 4
~~~~~~

I've tried to update documentation in Documentation/ABI/ thoroughly, but
only "TBD" was put into Documentation/usb/ehci.txt -- the text there seems
to be outdated and much needing refreshing, before it could be amended.

Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 Documentation/ABI/testing/sysfs-module |   23 +++++++
 Documentation/usb/ehci.txt             |    2 +
 drivers/usb/host/ehci-hcd.c            |    6 ++
 drivers/usb/host/ehci-sched.c          |   17 ++---
 drivers/usb/host/ehci-sysfs.c          |  104 ++++++++++++++++++++++++++++++-
 drivers/usb/host/ehci.h                |    2 +
 6 files changed, 140 insertions(+), 14 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-module b/Documentation/ABI/testing/sysfs-module
index cfcec3b..9489ea8 100644
--- a/Documentation/ABI/testing/sysfs-module
+++ b/Documentation/ABI/testing/sysfs-module
@@ -10,3 +10,26 @@ KernelVersion:	2.6.35
 Contact:	masa-korg@dsn.okisemi.com
 Description:	Write/read Option ROM data.
 
+
+What:		/sys/module/ehci_hcd/drivers/.../uframe_periodic_max
+Date:		July 2011
+KernelVersion:	3.1
+Contact:	Kirill Smelkov <kirr@mns.spb.ru>
+Description:	Maximum time allowed for periodic transfers per microframe (μs)
+
+		[ USB 2.0 sets maximum allowed time for periodic transfers per
+		  microframe to be 80%, that is 100 microseconds out of 125
+		  microseconds (full microframe).
+
+		  However there are cases, when 80% max isochronous bandwidth is
+		  too limiting. For example two video streams could require 110
+		  microseconds of isochronous bandwidth per microframe to work
+		  together. ]
+
+		Through this setting it is possible to raise the limit so that
+		the host controller would allow allocating more than 100
+		microseconds of periodic bandwidth per microframe.
+
+		Beware, non-standard modes are usually not thoroughly tested by
+		hardware designers, and the hardware can malfunction when this
+		setting differ from default 100.
diff --git a/Documentation/usb/ehci.txt b/Documentation/usb/ehci.txt
index 9dcafa7..160bd6c 100644
--- a/Documentation/usb/ehci.txt
+++ b/Documentation/usb/ehci.txt
@@ -210,3 +210,5 @@ TBD:  Interrupt and ISO transfer performance issues.  Those periodic
 transfers are fully scheduled, so the main issue is likely to be how
 to trigger "high bandwidth" modes.
 
+TBD:  More than standard 80% periodic bandwidth allocation is possible
+through sysfs uframe_periodic_max parameter. Describe that.
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
index 29824a9..14ced00 100644
--- a/drivers/usb/host/ehci-sysfs.c
+++ b/drivers/usb/host/ehci-sysfs.c
@@ -74,21 +74,117 @@ static ssize_t store_companion(struct device *dev,
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
+	unsigned		frame, uframe;
+	unsigned short		allocated_max;
+	unsigned long		flags;
+	ssize_t			ret;
+
+	ehci = hcd_to_ehci(bus_to_hcd(dev_get_drvdata(dev)));
+	if (kstrtouint(buf, 0, &uframe_periodic_max) < 0)
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
+	 * for request to decrease max periodic bandwidth, we have to check
+	 * every microframe in the schedule to see whether the decrease is
+	 * possible.
+	 */
+	if (uframe_periodic_max < ehci->uframe_periodic_max) {
+		allocated_max = 0;
+
+		for (frame = 0; frame < ehci->periodic_size; ++frame)
+			for (uframe = 0; uframe < 7; ++uframe)
+				allocated_max = max(allocated_max,
+						    periodic_usecs (ehci, frame, uframe));
+
+		if (allocated_max > uframe_periodic_max) {
+			ehci_info(ehci,
+				"cannot decrease uframe_periodic_max becase "
+				"periodic bandwidth is already allocated "
+				"(%u > %u)\n",
+				allocated_max, uframe_periodic_max);
+			goto out_unlock;
+		}
+	}
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

