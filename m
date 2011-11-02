Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab1KCBei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:34:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50483 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932856Ab1KCBe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:34:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:54 2011
Message-Id: <20111102221454.516968140@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [048/107] hwmon: (w83627ehf) Properly report thermal diode sensors
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit bf164c58e58328c40ebc597a8ac00cc6840f9703 upstream.

The w83627ehf driver is improperly reporting thermal diode sensors as
type 2, instead of 3. This caused "sensors" and possibly other
monitoring tools to report these sensors as "transistor" instead of
"thermal diode".

Furthermore, diode subtype selection (CPU vs. external) is only
supported by the original W83627EHF/EHG. All later models only support
CPU diode type, and some (NCT6776F) don't even have the register in
question so we should avoid reading from it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/w83627ehf.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -1239,7 +1239,8 @@ static void w83627ehf_device_remove_file
 }
 
 /* Get the monitoring functions started */
-static inline void __devinit w83627ehf_init_device(struct w83627ehf_data *data)
+static inline void __devinit w83627ehf_init_device(struct w83627ehf_data *data,
+						   enum kinds kind)
 {
 	int i;
 	u8 tmp, diode;
@@ -1268,10 +1269,16 @@ static inline void __devinit w83627ehf_i
 		w83627ehf_write_value(data, W83627EHF_REG_VBAT, tmp | 0x01);
 
 	/* Get thermal sensor types */
-	diode = w83627ehf_read_value(data, W83627EHF_REG_DIODE);
+	switch (kind) {
+	case w83627ehf:
+		diode = w83627ehf_read_value(data, W83627EHF_REG_DIODE);
+		break;
+	default:
+		diode = 0x70;
+	}
 	for (i = 0; i < 3; i++) {
 		if ((tmp & (0x02 << i)))
-			data->temp_type[i] = (diode & (0x10 << i)) ? 1 : 2;
+			data->temp_type[i] = (diode & (0x10 << i)) ? 1 : 3;
 		else
 			data->temp_type[i] = 4; /* thermistor */
 	}
@@ -1319,7 +1326,7 @@ static int __devinit w83627ehf_probe(str
 	}
 
 	/* Initialize the chip */
-	w83627ehf_init_device(data);
+	w83627ehf_init_device(data, sio_data->kind);
 
 	data->vrm = vid_which_vrm();
 	superio_enter(sio_data->sioreg);


