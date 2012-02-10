Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab2BJWo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:44:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933007Ab2BJWow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:44:52 -0500
MIME-Version: 1.0
Message-Id: <20120210223443.359169839@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>
Subject: [patch 35/55] hwmon: (w83627ehf) Fix number of fans for NCT6776F
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 585c0fd8216e0c9f98e2434092af7ec0f999522d upstream.

NCT6776F can select fan input pins for fans 3 to 5 with a secondary set of
chip register bits. Check that second set of bits in addition to the first set
to detect if fans 3..5 are monitored.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/w83627ehf.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -2104,9 +2104,29 @@ static int __devinit w83627ehf_probe(str
 		fan4min = 0;
 		fan5pin = 0;
 	} else if (sio_data->kind == nct6776) {
-		fan3pin = !(superio_inb(sio_data->sioreg, 0x24) & 0x40);
-		fan4pin = !!(superio_inb(sio_data->sioreg, 0x1C) & 0x01);
-		fan5pin = !!(superio_inb(sio_data->sioreg, 0x1C) & 0x02);
+		bool gpok = superio_inb(sio_data->sioreg, 0x27) & 0x80;
+		u8 regval;
+
+		superio_select(sio_data->sioreg, W83627EHF_LD_HWM);
+		regval = superio_inb(sio_data->sioreg, SIO_REG_ENABLE);
+
+		if (regval & 0x80)
+			fan3pin = gpok;
+		else
+			fan3pin = !(superio_inb(sio_data->sioreg, 0x24) & 0x40);
+
+		if (regval & 0x40)
+			fan4pin = gpok;
+		else
+			fan4pin = !!(superio_inb(sio_data->sioreg, 0x1C)
+				     & 0x01);
+
+		if (regval & 0x20)
+			fan5pin = gpok;
+		else
+			fan5pin = !!(superio_inb(sio_data->sioreg, 0x1C)
+				     & 0x02);
+
 		fan4min = fan4pin;
 	} else if (sio_data->kind == w83667hg || sio_data->kind == w83667hg_b) {
 		fan3pin = 1;


