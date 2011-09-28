Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab1I1Wpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:45:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932858Ab1I1Wpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:45:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:41 2011
Message-Id: <20110928220141.426288771@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [153/244] rtl2800usb: Fix incorrect storage of MAC address on big-endian platforms
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit daabead1c32f331edcfb255fd973411c667977e8 upstream.

The eeprom data is stored in little-endian order in the rt2x00 library.
As it was converted to cpu order in the read routines, the data need to
be converted to LE on a big-endian platform.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2800lib.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3512,14 +3512,15 @@ static void rt2800_efuse_read(struct rt2
 	rt2800_regbusy_read(rt2x00dev, EFUSE_CTRL, EFUSE_CTRL_KICK, &reg);
 
 	/* Apparently the data is read from end to start */
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA3,
-					(u32 *)&rt2x00dev->eeprom[i]);
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA2,
-					(u32 *)&rt2x00dev->eeprom[i + 2]);
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA1,
-					(u32 *)&rt2x00dev->eeprom[i + 4]);
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA0,
-					(u32 *)&rt2x00dev->eeprom[i + 6]);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA3, &reg);
+	/* The returned value is in CPU order, but eeprom is le */
+	rt2x00dev->eeprom[i] = cpu_to_le32(reg);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA2, &reg);
+	*(u32 *)&rt2x00dev->eeprom[i + 2] = cpu_to_le32(reg);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA1, &reg);
+	*(u32 *)&rt2x00dev->eeprom[i + 4] = cpu_to_le32(reg);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA0, &reg);
+	*(u32 *)&rt2x00dev->eeprom[i + 6] = cpu_to_le32(reg);
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }


