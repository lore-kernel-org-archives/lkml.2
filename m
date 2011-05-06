Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab1EFAhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:37:48 -0400
Received: from kroah.org ([198.145.64.141]:37369 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520Ab1EFA0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:26:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:18 2011
Message-Id: <20110506002218.452437766@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ondrej Zary <linux@rainbow-software.org>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [134/143] rt2500usb: fallback to SW encryption for TKIP+AES
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ondrej Zary <linux@rainbow-software.org>

commit 75f64dd54a185150ebfc45e99351c890d4a2252f upstream.

HW crypto in rt2500usb does not seem to support keys with different ciphers,
which breaks TKIP+AES mode. Fall back to software encryption to fix it.

This should fix long-standing problems with rt2500usb and WPA, such as:
http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=4&t=4834
https://bugzilla.redhat.com/show_bug.cgi?id=484888

Also tested that it does not break WEP, TKIP-only and AES-only modes.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Adjust context for 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -347,6 +347,7 @@ static int rt2500usb_config_key(struct r
 	int timeout;
 	u32 mask;
 	u16 reg;
+	enum cipher curr_cipher;
 
 	if (crypto->cmd == SET_KEY) {
 		/*
@@ -357,6 +358,7 @@ static int rt2500usb_config_key(struct r
 		mask = TXRX_CSR0_KEY_ID.bit_mask;
 
 		rt2500usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
+		curr_cipher = rt2x00_get_field16(reg, TXRX_CSR0_ALGORITHM);
 		reg &= mask;
 
 		if (reg && reg == mask)
@@ -365,6 +367,14 @@ static int rt2500usb_config_key(struct r
 		reg = rt2x00_get_field16(reg, TXRX_CSR0_KEY_ID);
 
 		key->hw_key_idx += reg ? ffz(reg) : 0;
+		/*
+		 * Hardware requires that all keys use the same cipher
+		 * (e.g. TKIP-only, AES-only, but not TKIP+AES).
+		 * If this is not the first key, compare the cipher with the
+		 * first one and fall back to SW crypto if not the same.
+		 */
+		if (key->hw_key_idx > 0 && crypto->cipher != curr_cipher)
+			return -EOPNOTSUPP;
 
 		/*
 		 * The encryption key doesn't fit within the CSR cache,


