Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0JIWMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 18:12:35 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53765 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab0JIWMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 18:12:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 10 Oct 2010 00:12:20 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/2] ieee1394: remove the old IEEE 1394 driver stack
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.a80c49c9cfb3380e@s5r6.in-berlin.de>
Message-ID: <tkrat.3d7c94e2ecb3a995@s5r6.in-berlin.de>
References: <tkrat.a80c49c9cfb3380e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers
  - ohci1394 (controller driver)
  - ieee1394 (core)
  - dv1394, raw1394, video1394 (userspace ABI)
  - eth1394, sbp2 (protocol drivers)
are replaced by
  - firewire-ohci (controller driver)
  - firewire-core (core and userspace ABI)
  - firewire-net, firewire-sbp2 (protocol drivers)
which are more featureful, better performing, and more secure than the older
drivers; all with a smaller and more modern code base.

The driver firedtv in drivers/media/dvb/firewire/ contains backends to both
ieee1394 and firewire-core.  Its ieee1394 backend code can be removed in an
independent commit; firedtv as-is builds and works fine without ieee1394.

The driver pcilynx (another controller driver) is deleted without replacement
since PCILynx cards are exteremely rare.  Owners of these cards use them with
the stand-alone bus sniffer driver nosy instead.

The drivers nosy and init_ohci1394_dma which do not interact with either of
the two IEEE 1394 stacks are not affected by the ieee1394 subsystem removal.

There are still some issues with the newer firewire subsystem compared to
the older one:
  - The rare and quirky controllers ALi M52xx, Apple UniNorth v1, NVIDIA
    NForce2 are even less well supported by firewire-ohci than by ohci1394.
    I am looking into the M52xx issue.
  - The experimental firewire-net is reportedly less stable than its
    experimental cousin eth1394.
  - Audio playback of a certain group of audio devices (ones based on DICE
    chipset with EAP; supported by prerelease FFADO code) does not work yet.
    This issue is still under investigation.
  - There were some ieee1394 based out-of-the-mainline drivers.  Of them,
    only lisight, an audio driver for iSight webcams, seems still useful.
    Work is underway to reimplement it on top of firewire-core.

All these remainig issues are minor; they should not stand in the way of
overall better user experience of IEEE 1394 on Linux, together with a
reduction in support efforts and maintenance burden.  The coexistence of two
IEEE 1394 kernel driver stacks in the mainline since 2.6.22 shall end now,
as announced earlier this year.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 Documentation/ABI/obsolete/dv1394                  |    9 -
 Documentation/ABI/removed/dv1394                   |   14 +
 Documentation/ABI/removed/raw1394                  |   15 +
 .../ABI/removed/raw1394_legacy_isochronous         |   16 -
 Documentation/ABI/removed/video1394                |   16 +
 Documentation/feature-removal-schedule.txt         |   10 -
 drivers/Makefile                                   |    1 -
 drivers/firewire/Kconfig                           |    5 -
 drivers/ieee1394/Kconfig                           |  182 -
 drivers/ieee1394/Makefile                          |   16 -
 drivers/ieee1394/config_roms.c                     |  194 --
 drivers/ieee1394/config_roms.h                     |   19 -
 drivers/ieee1394/csr.c                             |  843 -----
 drivers/ieee1394/csr.h                             |   99 -
 drivers/ieee1394/csr1212.c                         | 1467 --------
 drivers/ieee1394/csr1212.h                         |  383 ---
 drivers/ieee1394/dma.c                             |  289 --
 drivers/ieee1394/dma.h                             |   89 -
 drivers/ieee1394/dv1394-private.h                  |  587 ----
 drivers/ieee1394/dv1394.c                          | 2584 --------------
 drivers/ieee1394/dv1394.h                          |  305 --
 drivers/ieee1394/eth1394.c                         | 1736 ----------
 drivers/ieee1394/eth1394.h                         |  234 --
 drivers/ieee1394/highlevel.c                       |  691 ----
 drivers/ieee1394/highlevel.h                       |  141 -
 drivers/ieee1394/hosts.c                           |  249 --
 drivers/ieee1394/hosts.h                           |  201 --
 drivers/ieee1394/ieee1394-ioctl.h                  |  106 -
 drivers/ieee1394/ieee1394.h                        |  220 --
 drivers/ieee1394/ieee1394_core.c                   | 1380 --------
 drivers/ieee1394/ieee1394_core.h                   |  172 -
 drivers/ieee1394/ieee1394_hotplug.h                |   19 -
 drivers/ieee1394/ieee1394_transactions.c           |  595 ----
 drivers/ieee1394/ieee1394_transactions.h           |   40 -
 drivers/ieee1394/ieee1394_types.h                  |   69 -
 drivers/ieee1394/iso.c                             |  568 ----
 drivers/ieee1394/iso.h                             |  195 --
 drivers/ieee1394/nodemgr.c                         | 1901 -----------
 drivers/ieee1394/nodemgr.h                         |  186 -
 drivers/ieee1394/ohci1394.c                        | 3590 --------------------
 drivers/ieee1394/ohci1394.h                        |  453 ---
 drivers/ieee1394/pcilynx.c                         | 1554 ---------
 drivers/ieee1394/pcilynx.h                         |  468 ---
 drivers/ieee1394/raw1394-private.h                 |   81 -
 drivers/ieee1394/raw1394.c                         | 3096 -----------------
 drivers/ieee1394/raw1394.h                         |  191 --
 drivers/ieee1394/sbp2.c                            | 2138 ------------
 drivers/ieee1394/sbp2.h                            |  346 --
 drivers/ieee1394/video1394.c                       | 1528 ---------
 drivers/ieee1394/video1394.h                       |   67 -
 50 files changed, 45 insertions(+), 29313 deletions(-)
 delete mode 100644 Documentation/ABI/obsolete/dv1394
 create mode 100644 Documentation/ABI/removed/dv1394
 create mode 100644 Documentation/ABI/removed/raw1394
 delete mode 100644 Documentation/ABI/removed/raw1394_legacy_isochronous
 create mode 100644 Documentation/ABI/removed/video1394
 delete mode 100644 drivers/ieee1394/Kconfig
 delete mode 100644 drivers/ieee1394/Makefile
 delete mode 100644 drivers/ieee1394/config_roms.c
 delete mode 100644 drivers/ieee1394/config_roms.h
 delete mode 100644 drivers/ieee1394/csr.c
 delete mode 100644 drivers/ieee1394/csr.h
 delete mode 100644 drivers/ieee1394/csr1212.c
 delete mode 100644 drivers/ieee1394/csr1212.h
 delete mode 100644 drivers/ieee1394/dma.c
 delete mode 100644 drivers/ieee1394/dma.h
 delete mode 100644 drivers/ieee1394/dv1394-private.h
 delete mode 100644 drivers/ieee1394/dv1394.c
 delete mode 100644 drivers/ieee1394/dv1394.h
 delete mode 100644 drivers/ieee1394/eth1394.c
 delete mode 100644 drivers/ieee1394/eth1394.h
 delete mode 100644 drivers/ieee1394/highlevel.c
 delete mode 100644 drivers/ieee1394/highlevel.h
 delete mode 100644 drivers/ieee1394/hosts.c
 delete mode 100644 drivers/ieee1394/hosts.h
 delete mode 100644 drivers/ieee1394/ieee1394-ioctl.h
 delete mode 100644 drivers/ieee1394/ieee1394.h
 delete mode 100644 drivers/ieee1394/ieee1394_core.c
 delete mode 100644 drivers/ieee1394/ieee1394_core.h
 delete mode 100644 drivers/ieee1394/ieee1394_hotplug.h
 delete mode 100644 drivers/ieee1394/ieee1394_transactions.c
 delete mode 100644 drivers/ieee1394/ieee1394_transactions.h
 delete mode 100644 drivers/ieee1394/ieee1394_types.h
 delete mode 100644 drivers/ieee1394/iso.c
 delete mode 100644 drivers/ieee1394/iso.h
 delete mode 100644 drivers/ieee1394/nodemgr.c
 delete mode 100644 drivers/ieee1394/nodemgr.h
 delete mode 100644 drivers/ieee1394/ohci1394.c
 delete mode 100644 drivers/ieee1394/ohci1394.h
 delete mode 100644 drivers/ieee1394/pcilynx.c
 delete mode 100644 drivers/ieee1394/pcilynx.h
 delete mode 100644 drivers/ieee1394/raw1394-private.h
 delete mode 100644 drivers/ieee1394/raw1394.c
 delete mode 100644 drivers/ieee1394/raw1394.h
 delete mode 100644 drivers/ieee1394/sbp2.c
 delete mode 100644 drivers/ieee1394/sbp2.h
 delete mode 100644 drivers/ieee1394/video1394.c
 delete mode 100644 drivers/ieee1394/video1394.h

diff --git a/Documentation/ABI/obsolete/dv1394 b/Documentation/ABI/obsolete/dv1394
deleted file mode 100644
index 2ee3686..0000000
--- a/Documentation/ABI/obsolete/dv1394
+++ /dev/null
@@ -1,9 +0,0 @@
-What:		dv1394 (a.k.a. "OHCI-DV I/O support" for FireWire)
-Contact:	linux1394-devel@lists.sourceforge.net
-Description:
-	New application development should use raw1394 + userspace libraries
-	instead, notably libiec61883 which is functionally equivalent.
-
-Users:
-	ffmpeg/libavformat (used by a variety of media players)
-	dvgrab v1.x (replaced by dvgrab2 on top of raw1394 and resp. libraries)
diff --git a/Documentation/ABI/removed/dv1394 b/Documentation/ABI/removed/dv1394
new file mode 100644
index 0000000..c2310b6
--- /dev/null
+++ b/Documentation/ABI/removed/dv1394
@@ -0,0 +1,14 @@
+What:		dv1394 (a.k.a. "OHCI-DV I/O support" for FireWire)
+Date:		May 2010 (scheduled), finally removed in kernel v2.6.37
+Contact:	linux1394-devel@lists.sourceforge.net
+Description:
+	/dev/dv1394/* were character device files, one for each FireWire
+	controller and for NTSC and PAL respectively, from which DV data
+	could be received by read() or transmitted by write().  A few
+	ioctl()s allowed limited control.
+	This special-purpose interface has been superseded by libraw1394 +
+	libiec61883 which are functionally equivalent, support HDV, and
+	transparently work on top of the newer firewire kernel drivers.
+
+Users:
+	ffmpeg/libavformat (if configured for DV1394)
diff --git a/Documentation/ABI/removed/raw1394 b/Documentation/ABI/removed/raw1394
new file mode 100644
index 0000000..490aa1e
--- /dev/null
+++ b/Documentation/ABI/removed/raw1394
@@ -0,0 +1,15 @@
+What:		raw1394 (a.k.a. "Raw IEEE1394 I/O support" for FireWire)
+Date:		May 2010 (scheduled), finally removed in kernel v2.6.37
+Contact:	linux1394-devel@lists.sourceforge.net
+Description:
+	/dev/raw1394 was a character device file that allowed low-level
+	access to FireWire buses.  Its major drawbacks were its inability
+	to implement sensible device security policies, and its low level
+	of abstraction that required userspace clients do duplicate much
+	of the kernel's ieee1394 core functionality.
+	Replaced by /dev/fw*, i.e. the <linux/firewire-cdev.h> ABI of
+	firewire-core.
+
+Users:
+	libraw1394 (works with firewire-cdev too, transparent to library ABI
+	users)
diff --git a/Documentation/ABI/removed/raw1394_legacy_isochronous b/Documentation/ABI/removed/raw1394_legacy_isochronous
deleted file mode 100644
index 1b62962..0000000
--- a/Documentation/ABI/removed/raw1394_legacy_isochronous
+++ /dev/null
@@ -1,16 +0,0 @@
-What:		legacy isochronous ABI of raw1394 (1st generation iso ABI)
-Date:		June 2007 (scheduled), removed in kernel v2.6.23
-Contact:	linux1394-devel@lists.sourceforge.net
-Description:
-	The two request types RAW1394_REQ_ISO_SEND, RAW1394_REQ_ISO_LISTEN have
-	been deprecated for quite some time.  They are very inefficient as they
-	come with high interrupt load and several layers of callbacks for each
-	packet.  Because of these deficiencies, the video1394 and dv1394 drivers
-	and the 3rd-generation isochronous ABI in raw1394 (rawiso) were created.
-
-Users:
-	libraw1394 users via the long deprecated API raw1394_iso_write,
-	raw1394_start_iso_write, raw1394_start_iso_rcv, raw1394_stop_iso_rcv
-
-	libdc1394, which optionally uses these old libraw1394 calls
-	alternatively to the more efficient video1394 ABI
diff --git a/Documentation/ABI/removed/video1394 b/Documentation/ABI/removed/video1394
new file mode 100644
index 0000000..c39c25a
--- /dev/null
+++ b/Documentation/ABI/removed/video1394
@@ -0,0 +1,16 @@
+What:		video1394 (a.k.a. "OHCI-1394 Video support" for FireWire)
+Date:		May 2010 (scheduled), finally removed in kernel v2.6.37
+Contact:	linux1394-devel@lists.sourceforge.net
+Description:
+	/dev/video1394/* were character device files, one for each FireWire
+	controller, which were used for isochronous I/O.  It was added as an
+	alternative to raw1394's isochronous I/O functionality which had
+	performance issues in its first generation.  Any video1394 user had
+	to use raw1394 + libraw1394 too because video1394 did not provide
+	asynchronous I/O for device discovery and configuration.
+	Replaced by /dev/fw*, i.e. the <linux/firewire-cdev.h> ABI of
+	firewire-core.
+
+Users:
+	libdc1394 (works with firewire-cdev too, transparent to library ABI
+	users)
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 1571c0c..fe2a4ba 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -637,16 +637,6 @@ Who:	Thomas Gleixner <tglx@linutronix.de>
 
 ----------------------------
 
-What:	old ieee1394 subsystem (CONFIG_IEEE1394)
-When:	2.6.37
-Files:	drivers/ieee1394/ except init_ohci1394_dma.c
-Why:	superseded by drivers/firewire/ (CONFIG_FIREWIRE) which offers more
-	features, better performance, and better security, all with smaller
-	and more modern code base
-Who:	Stefan Richter <stefanr@s5r6.in-berlin.de>
-
-----------------------------
-
 What:	The acpi_sleep=s4_nonvs command line option
 When:	2.6.37
 Files:	arch/x86/kernel/acpi/sleep.c
diff --git a/drivers/Makefile b/drivers/Makefile
index 0bbb456..d9dda3b 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -51,7 +51,6 @@ obj-y				+= net/
 obj-$(CONFIG_ATM)		+= atm/
 obj-$(CONFIG_FUSION)		+= message/
 obj-y				+= firewire/
-obj-y				+= ieee1394/
 obj-$(CONFIG_UIO)		+= uio/
 obj-y				+= cdrom/
 obj-y				+= auxdisplay/
diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index fcf3ea2..40a222e 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -3,9 +3,6 @@ menu "IEEE 1394 (FireWire) support"
 	# firewire-core does not depend on PCI but is
 	# not useful without PCI controller driver
 
-comment "You can enable one or both FireWire driver stacks."
-comment "The newer stack is recommended."
-
 config FIREWIRE
 	tristate "FireWire driver stack"
 	select CRC_ITU_T
@@ -64,8 +61,6 @@ config FIREWIRE_NET
 	  To compile this driver as a module, say M here:  The module will be
 	  called firewire-net.
 
-source "drivers/ieee1394/Kconfig"
-
 config FIREWIRE_NOSY
 	tristate "Nosy - a FireWire traffic sniffer for PCILynx cards"
 	depends on PCI
diff --git a/drivers/ieee1394/Kconfig b/drivers/ieee1394/Kconfig
deleted file mode 100644
index e02096c..0000000
--- a/drivers/ieee1394/Kconfig
+++ /dev/null

[...useless all-minus diff hunks deleted...]
Wasn't there a git option to create a shorter diff without all this noise?

-- 
Stefan Richter
-=====-==-=- =-=- -=-=-
http://arcgraph.de/sr/

