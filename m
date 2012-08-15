Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab2HOUXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:23:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:36809 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab2HOTud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:33 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 061/165] hwmon: (w83627ehf) Properly report thermal diode sensors
Date: Wed, 15 Aug 2012 15:46:45 -0400
Message-ID: <1345060109-9187-62-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hwmon/w83627ehf.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index dc53e61..4473207 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -1284,7 +1284,8 @@ static void w83627ehf_device_remove_files(struct device *dev)
 }
 
 /* Get the monitoring functions started */
-static inline void __devinit w83627ehf_init_device(struct w83627ehf_data *data)
+static inline void __devinit w83627ehf_init_device(struct w83627ehf_data *data,
+						   enum kinds kind)
 {
 	int i;
 	u8 tmp, diode;
@@ -1313,10 +1314,16 @@ static inline void __devinit w83627ehf_init_device(struct w83627ehf_data *data)
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
@@ -1364,7 +1371,7 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize the chip */
-	w83627ehf_init_device(data);
+	w83627ehf_init_device(data, sio_data->kind);
 
 	data->vrm = vid_which_vrm();
 	superio_enter(sio_data->sioreg);
-- 
1.7.12.rc2

