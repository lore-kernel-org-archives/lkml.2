Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab2AJRWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:22:55 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:36065 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab2AJRWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:22:53 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: mikekrufky@gmail.com, linux-media@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3/4] DVB: dib0700, add corrected Nova-TD frontend_attach
Date: Tue, 10 Jan 2012 18:11:24 +0100
Message-Id: <1326215485-20846-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1326215485-20846-1-git-send-email-jslaby@suse.cz>
References: <1326215485-20846-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This means cut & paste from the former f. attach. But while at it write
to the right GPIO to turn on the right LED. Also turn the other two
off jsut for sure.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   36 +++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index e5c2bd2..3ab45ae 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -3105,6 +3105,38 @@ static int stk7070pd_frontend_attach1(struct dvb_usb_adapter *adap)
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
 }
 
+/**
+ * novatd_frontend_attach - Nova-TD specific attach
+ *
+ * Nova-TD has GPIO0, 1 and 2 for LEDs. So do not fiddle with them except for
+ * information purposes.
+ */
+static int novatd_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvb_usb_device *dev = adap->dev;
+
+	if (adap->id == 0) {
+		stk7070pd_init(dev);
+
+		/* turn the power LED on, the other two off (just in case) */
+		dib0700_set_gpio(dev, GPIO0, GPIO_OUT, 0);
+		dib0700_set_gpio(dev, GPIO1, GPIO_OUT, 0);
+		dib0700_set_gpio(dev, GPIO2, GPIO_OUT, 1);
+
+		if (dib7000p_i2c_enumeration(&dev->i2c_adap, 2, 18,
+					     stk7070pd_dib7000p_config) != 0) {
+			err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n",
+			    __func__);
+			return -ENODEV;
+		}
+	}
+
+	adap->fe_adap[0].fe = dvb_attach(dib7000p_attach, &dev->i2c_adap,
+			adap->id == 0 ? 0x80 : 0x82,
+			&stk7070pd_dib7000p_config[adap->id]);
+	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
+}
+
 /* S5H1411 */
 static struct s5h1411_config pinnacle_801e_config = {
 	.output_mode   = S5H1411_PARALLEL_OUTPUT,
@@ -3876,7 +3908,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 				.pid_filter_count = 32,
 				.pid_filter       = stk70x0p_pid_filter,
 				.pid_filter_ctrl  = stk70x0p_pid_filter_ctrl,
-				.frontend_attach  = stk7070pd_frontend_attach0,
+				.frontend_attach  = novatd_frontend_attach,
 				.tuner_attach     = dib7070p_tuner_attach,
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
@@ -3889,7 +3921,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 				.pid_filter_count = 32,
 				.pid_filter       = stk70x0p_pid_filter,
 				.pid_filter_ctrl  = stk70x0p_pid_filter_ctrl,
-				.frontend_attach  = stk7070pd_frontend_attach1,
+				.frontend_attach  = novatd_frontend_attach,
 				.tuner_attach     = dib7070p_tuner_attach,
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
-- 
1.7.8


