Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934450Ab1KCBko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:40:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448Ab1KCBkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:40:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:42 2011
Message-Id: <20111102222742.534472538@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [031/101] rtl2800usb: Fix incorrect storage of MAC address on big-endian platforms
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -1694,14 +1694,15 @@ static void rt2800_efuse_read(struct rt2
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


