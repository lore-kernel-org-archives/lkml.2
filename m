Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0C3XL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:11:59 -0400
Received: from kroah.org ([198.145.64.141]:48789 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302Ab0C3XL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:11:56 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:15 2010
Message-Id: <20100330225814.972178051@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Quan <david.quan@atheros.com>,
       Stephen Beahm <stephenbeahm@comcast.net>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [11/89] ath5k: Fix eeprom checksum check for custom sized eeproms
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 359207c687cc8f4f9845c8dadd0d6dabad44e584 upstream.

Commit 8bf3d79bc401ca417ccf9fc076d3295d1a71dbf5 enabled EEPROM
checksum checks to avoid bogus bug reports but failed to address
updating the code to consider devices with custom EEPROM sizes.
Devices with custom sized EEPROMs have the upper limit size stuffed
in the EEPROM. Use this as the upper limit instead of the static
default size. In case of a checksum error also provide back the
max size and whether or not this was the default size or a custom
one. If the EEPROM is busted we add a failsafe check to ensure
we don't loop forever or try to read bogus areas of hardware.

This closes bug 14874

http://bugzilla.kernel.org/show_bug.cgi?id=14874

Cc: stable@kernel.org
Cc: David Quan <david.quan@atheros.com>
Cc: Stephen Beahm <stephenbeahm@comcast.net>
Reported-by: Joshua Covington <joshuacov@googlemail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>

---
 drivers/net/wireless/ath/ath5k/eeprom.c |   32 +++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath5k/eeprom.h |    8 ++++++++
 2 files changed, 37 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -97,7 +97,7 @@ ath5k_eeprom_init_header(struct ath5k_hw
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	int ret;
 	u16 val;
-	u32 cksum, offset;
+	u32 cksum, offset, eep_max = AR5K_EEPROM_INFO_MAX;
 
 	/*
 	 * Read values from EEPROM and store them in the capability structure
@@ -116,12 +116,38 @@ ath5k_eeprom_init_header(struct ath5k_hw
 	 * Validate the checksum of the EEPROM date. There are some
 	 * devices with invalid EEPROMs.
 	 */
-	for (cksum = 0, offset = 0; offset < AR5K_EEPROM_INFO_MAX; offset++) {
+	AR5K_EEPROM_READ(AR5K_EEPROM_SIZE_UPPER, val);
+	if (val) {
+		eep_max = (val & AR5K_EEPROM_SIZE_UPPER_MASK) <<
+			   AR5K_EEPROM_SIZE_ENDLOC_SHIFT;
+		AR5K_EEPROM_READ(AR5K_EEPROM_SIZE_LOWER, val);
+		eep_max = (eep_max | val) - AR5K_EEPROM_INFO_BASE;
+
+		/*
+		 * Fail safe check to prevent stupid loops due
+		 * to busted EEPROMs. XXX: This value is likely too
+		 * big still, waiting on a better value.
+		 */
+		if (eep_max > (3 * AR5K_EEPROM_INFO_MAX)) {
+			ATH5K_ERR(ah->ah_sc, "Invalid max custom EEPROM size: "
+				  "%d (0x%04x) max expected: %d (0x%04x)\n",
+				  eep_max, eep_max,
+				  3 * AR5K_EEPROM_INFO_MAX,
+				  3 * AR5K_EEPROM_INFO_MAX);
+			return -EIO;
+		}
+	}
+
+	for (cksum = 0, offset = 0; offset < eep_max; offset++) {
 		AR5K_EEPROM_READ(AR5K_EEPROM_INFO(offset), val);
 		cksum ^= val;
 	}
 	if (cksum != AR5K_EEPROM_INFO_CKSUM) {
-		ATH5K_ERR(ah->ah_sc, "Invalid EEPROM checksum 0x%04x\n", cksum);
+		ATH5K_ERR(ah->ah_sc, "Invalid EEPROM "
+			  "checksum: 0x%04x eep_max: 0x%04x (%s)\n",
+			  cksum, eep_max,
+			  eep_max == AR5K_EEPROM_INFO_MAX ?
+				"default size" : "custom size");
 		return -EIO;
 	}
 
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -34,6 +34,14 @@
 #define AR5K_EEPROM_RFKILL_POLARITY_S	1
 
 #define AR5K_EEPROM_REG_DOMAIN		0x00bf	/* EEPROM regdom */
+
+/* FLASH(EEPROM) Defines for AR531X chips */
+#define AR5K_EEPROM_SIZE_LOWER		0x1b /* size info -- lower */
+#define AR5K_EEPROM_SIZE_UPPER		0x1c /* size info -- upper */
+#define AR5K_EEPROM_SIZE_UPPER_MASK	0xfff0
+#define AR5K_EEPROM_SIZE_UPPER_SHIFT	4
+#define AR5K_EEPROM_SIZE_ENDLOC_SHIFT	12
+
 #define AR5K_EEPROM_CHECKSUM		0x00c0	/* EEPROM checksum */
 #define AR5K_EEPROM_INFO_BASE		0x00c0	/* EEPROM header */
 #define AR5K_EEPROM_INFO_MAX		(0x400 - AR5K_EEPROM_INFO_BASE)


