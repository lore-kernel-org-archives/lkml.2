Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab2CGLvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:51:22 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:44234 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2CGLvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:51:02 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 8/9] drm/i915/intel_i2c: use INDEX cycles for i2c read transactions
Date: Wed,  7 Mar 2012 19:50:49 +0800
Message-Id: <1331121050-17857-9-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is very common for an i2c device to require a small 1 or 2 byte write
followed by a read.  For example, when reading from an i2c EEPROM it is
common to write and address, offset or index followed by a reading some
values.

The i915 gmbus controller provides a special "INDEX" cycle for performing
such a small write followed by a read.  The INDEX can be either one or two
bytes long.  The advantage of using such a cycle is that the CPU has
slightly less work to do once the read with INDEX cycle is started.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index c3d8c70..41f9ae2 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -256,12 +256,40 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	I915_WRITE(GMBUS0 + reg_offset, bus->reg0);
 
 	for (i = 0; i < num; i++) {
-		u16 len = msgs[i].len;
-		u8 *buf = msgs[i].buf;
+		u16 len;
+		u8 *buf;
+		u32 gmbus5 = 0;
+		u32 gmbus1_index = 0;
+
+		/*
+		 * The gmbus controller can combine a 1 or 2 byte write with a
+		 * read that immediately follows it by using an "INDEX" cycle.
+		 */
+		if (i + 1 < num &&
+		    !(msgs[i].flags & I2C_M_RD) &&
+		    (msgs[i + 1].flags & I2C_M_RD) &&
+		    msgs[i].len <= 2) {
+			if (msgs[i].len == 2)
+				gmbus5 = GMBUS_2BYTE_INDEX_EN |
+					 msgs[i].buf[1] |
+					 (msgs[i].buf[0] << 8);
+			if (msgs[i].len == 1)
+				gmbus1_index = GMBUS_CYCLE_INDEX |
+					       (msgs[i].buf[0] <<
+						GMBUS_SLAVE_INDEX_SHIFT);
+			i += 1;  /* set i to the index of the read xfer */
+		}
+
+		len = msgs[i].len;
+		buf = msgs[i].buf;
+
+		/* GMBUS5 holds 16-bit index, but must be 0 if not used */
+		I915_WRITE(GMBUS5 + reg_offset, gmbus5);
 
 		if (msgs[i].flags & I2C_M_RD) {
 			I915_WRITE(GMBUS1 + reg_offset,
 				   GMBUS_CYCLE_WAIT |
+				   gmbus1_index |
 				   (len << GMBUS_BYTE_COUNT_SHIFT) |
 				   (msgs[i].addr << GMBUS_SLAVE_ADDR_SHIFT) |
 				   GMBUS_SLAVE_READ | GMBUS_SW_RDY);
-- 
1.7.7.3

