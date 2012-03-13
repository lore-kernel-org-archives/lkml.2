Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965294Ab2CMAZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:25:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:48967 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965148Ab2CMAZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:01 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ondrej Zary <linux@rainbow-software.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 163/196] rt2500usb: fallback to SW encryption for TKIP+AES
Date: Mon, 12 Mar 2012 20:21:16 -0400
Message-Id: <1331598109-31424-118-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 8ebb705..2961228 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -348,6 +348,7 @@ static int rt2500usb_config_key(struct rt2x00_dev *rt2x00dev,
 	int timeout;
 	u32 mask;
 	u16 reg;
+	enum cipher curr_cipher;
 
 	if (crypto->cmd == SET_KEY) {
 		/*
@@ -358,6 +359,7 @@ static int rt2500usb_config_key(struct rt2x00_dev *rt2x00dev,
 		mask = TXRX_CSR0_KEY_ID.bit_mask;
 
 		rt2500usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
+		curr_cipher = rt2x00_get_field16(reg, TXRX_CSR0_ALGORITHM);
 		reg &= mask;
 
 		if (reg && reg == mask)
@@ -366,6 +368,14 @@ static int rt2500usb_config_key(struct rt2x00_dev *rt2x00dev,
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
-- 
1.7.9.3

