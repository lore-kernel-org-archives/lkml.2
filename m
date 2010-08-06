Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965560Ab0HFTHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:07:52 -0400
Received: from kroah.org ([198.145.64.141]:58664 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965134Ab0HFTAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:00:32 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:58:36 2010
Message-Id: <20100806185836.606300963@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:57:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "John W. Linville" <linville@tuxdriver.com>,
        =?ISO-8859-15?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Michael Buesch <mb@bu3sch.de>, Ben Hutchings <ben@decadent.org.uk>
Subject: [31/34] ssb: do not read SPROM if it does not exist
In-Reply-To: <20100806185853.GA28270@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John W. Linville <linville@tuxdriver.com>

commit d53cdbb94a52a920d5420ed64d986c3523a56743 upstream.

Attempting to read registers that don't exist on the SSB bus can cause
hangs on some boxes.  At least some b43 devices are 'in the wild' that
don't have SPROMs at all.  When the SSB bus support loads, it attempts
to read these (non-existant) SPROMs and causes hard hangs on the box --
no console output, etc.

This patch adds some intelligence to determine whether or not the SPROM
is present before attempting to read it.  This avoids those hard hangs
on those devices with no SPROM attached to their SSB bus.  The
SSB-attached devices (e.g. b43, et al.) won't work, but at least the box
will survive to test further patches. :-)

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ssb/driver_chipcommon.c           |    2 ++
 drivers/ssb/pci.c                         |    5 +++++
 drivers/ssb/sprom.c                       |   14 ++++++++++++++
 include/linux/ssb/ssb.h                   |    3 +++
 include/linux/ssb/ssb_driver_chipcommon.h |   15 +++++++++++++++
 5 files changed, 39 insertions(+)

--- a/drivers/ssb/driver_chipcommon.c
+++ b/drivers/ssb/driver_chipcommon.c
@@ -233,6 +233,8 @@ void ssb_chipcommon_init(struct ssb_chip
 {
 	if (!cc->dev)
 		return; /* We don't have a ChipCommon */
+	if (cc->dev->id.revision >= 11)
+		cc->status = chipco_read32(cc, SSB_CHIPCO_CHIPSTAT);
 	ssb_pmu_init(cc);
 	chipco_powercontrol_init(cc);
 	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_FAST);
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -620,6 +620,11 @@ static int ssb_pci_sprom_get(struct ssb_
 	int err = -ENOMEM;
 	u16 *buf;
 
+	if (!ssb_is_sprom_available(bus)) {
+		ssb_printk(KERN_ERR PFX "No SPROM available!\n");
+		return -ENODEV;
+	}
+
 	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
 	if (!buf)
 		goto out;
--- a/drivers/ssb/sprom.c
+++ b/drivers/ssb/sprom.c
@@ -179,3 +179,17 @@ const struct ssb_sprom *ssb_get_fallback
 {
 	return fallback_sprom;
 }
+
+/* http://bcm-v4.sipsolutions.net/802.11/IsSpromAvailable */
+bool ssb_is_sprom_available(struct ssb_bus *bus)
+{
+	/* status register only exists on chipcomon rev >= 11 and we need check
+	   for >= 31 only */
+	/* this routine differs from specs as we do not access SPROM directly
+	   on PCMCIA */
+	if (bus->bustype == SSB_BUSTYPE_PCI &&
+	    bus->chipco.dev->id.revision >= 31)
+		return bus->chipco.capabilities & SSB_CHIPCO_CAP_SPROM;
+
+	return true;
+}
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -390,6 +390,9 @@ extern int ssb_bus_sdiobus_register(stru
 
 extern void ssb_bus_unregister(struct ssb_bus *bus);
 
+/* Does the device have an SPROM? */
+extern bool ssb_is_sprom_available(struct ssb_bus *bus);
+
 /* Set a fallback SPROM.
  * See kdoc at the function definition for complete documentation. */
 extern int ssb_arch_set_fallback_sprom(const struct ssb_sprom *sprom);
--- a/include/linux/ssb/ssb_driver_chipcommon.h
+++ b/include/linux/ssb/ssb_driver_chipcommon.h
@@ -53,6 +53,7 @@
 #define  SSB_CHIPCO_CAP_64BIT		0x08000000	/* 64-bit Backplane */
 #define  SSB_CHIPCO_CAP_PMU		0x10000000	/* PMU available (rev >= 20) */
 #define  SSB_CHIPCO_CAP_ECI		0x20000000	/* ECI available (rev >= 20) */
+#define  SSB_CHIPCO_CAP_SPROM		0x40000000	/* SPROM present */
 #define SSB_CHIPCO_CORECTL		0x0008
 #define  SSB_CHIPCO_CORECTL_UARTCLK0	0x00000001	/* Drive UART with internal clock */
 #define	 SSB_CHIPCO_CORECTL_SE		0x00000002	/* sync clk out enable (corerev >= 3) */
@@ -385,6 +386,7 @@
 
 
 /** Chip specific Chip-Status register contents. */
+#define SSB_CHIPCO_CHST_4322_SPROM_EXISTS	0x00000040 /* SPROM present */
 #define SSB_CHIPCO_CHST_4325_SPROM_OTP_SEL	0x00000003
 #define SSB_CHIPCO_CHST_4325_DEFCIS_SEL		0 /* OTP is powered up, use def. CIS, no SPROM */
 #define SSB_CHIPCO_CHST_4325_SPROM_SEL		1 /* OTP is powered up, SPROM is present */
@@ -398,6 +400,18 @@
 #define SSB_CHIPCO_CHST_4325_RCAL_VALUE_SHIFT	4
 #define SSB_CHIPCO_CHST_4325_PMUTOP_2B 		0x00000200 /* 1 for 2b, 0 for to 2a */
 
+/** Macros to determine SPROM presence based on Chip-Status register. */
+#define SSB_CHIPCO_CHST_4312_SPROM_PRESENT(status) \
+	((status & SSB_CHIPCO_CHST_4325_SPROM_OTP_SEL) != \
+		SSB_CHIPCO_CHST_4325_OTP_SEL)
+#define SSB_CHIPCO_CHST_4322_SPROM_PRESENT(status) \
+	(status & SSB_CHIPCO_CHST_4322_SPROM_EXISTS)
+#define SSB_CHIPCO_CHST_4325_SPROM_PRESENT(status) \
+	(((status & SSB_CHIPCO_CHST_4325_SPROM_OTP_SEL) != \
+		SSB_CHIPCO_CHST_4325_DEFCIS_SEL) && \
+	 ((status & SSB_CHIPCO_CHST_4325_SPROM_OTP_SEL) != \
+		SSB_CHIPCO_CHST_4325_OTP_SEL))
+
 
 
 /** Clockcontrol masks and values **/
@@ -564,6 +578,7 @@ struct ssb_chipcommon_pmu {
 struct ssb_chipcommon {
 	struct ssb_device *dev;
 	u32 capabilities;
+	u32 status;
 	/* Fast Powerup Delay constant */
 	u16 fast_pwrup_delay;
 	struct ssb_chipcommon_pmu pmu;


