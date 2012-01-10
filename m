Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab2AJRWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:22:19 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:36063 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584Ab2AJRWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:22:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: mikekrufky@gmail.com, linux-media@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 4/4] DVB: dib0700, add support for Nova-TD LEDs
Date: Tue, 10 Jan 2012 18:11:25 +0100
Message-Id: <1326215485-20846-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1326215485-20846-1-git-send-email-jslaby@suse.cz>
References: <1326215485-20846-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an override of read_status to intercept lock status. This allows
us to switch LEDs appropriately on and off with signal un/locked.

The second phase is to override sleep to properly turn off both.

This is a hackish way to achieve that.

Thanks to Mike Krufky for his help.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/dvb/dvb-usb/dib0700.h         |    2 +
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   41 ++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700.h b/drivers/media/dvb/dvb-usb/dib0700.h
index 9bd6d51..7de125c 100644
--- a/drivers/media/dvb/dvb-usb/dib0700.h
+++ b/drivers/media/dvb/dvb-usb/dib0700.h
@@ -48,6 +48,8 @@ struct dib0700_state {
 	u8 disable_streaming_master_mode;
 	u32 fw_version;
 	u32 nb_packet_buffer_size;
+	int (*read_status)(struct dvb_frontend *, fe_status_t *);
+	int (*sleep)(struct dvb_frontend* fe);
 	u8 buf[255];
 };
 
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 3ab45ae..f9e966a 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -3105,6 +3105,35 @@ static int stk7070pd_frontend_attach1(struct dvb_usb_adapter *adap)
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
 }
 
+static int novatd_read_status_override(struct dvb_frontend *fe,
+		fe_status_t *stat)
+{
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct dvb_usb_device *dev = adap->dev;
+	struct dib0700_state *state = dev->priv;
+	int ret;
+
+	ret = state->read_status(fe, stat);
+
+	if (!ret)
+		dib0700_set_gpio(dev, adap->id == 0 ? GPIO1 : GPIO0, GPIO_OUT,
+				!!(*stat & FE_HAS_LOCK));
+
+	return ret;
+}
+
+static int novatd_sleep_override(struct dvb_frontend* fe)
+{
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct dvb_usb_device *dev = adap->dev;
+	struct dib0700_state *state = dev->priv;
+
+	/* turn off LED */
+	dib0700_set_gpio(dev, adap->id == 0 ? GPIO1 : GPIO0, GPIO_OUT, 0);
+
+	return state->sleep(fe);
+}
+
 /**
  * novatd_frontend_attach - Nova-TD specific attach
  *
@@ -3114,6 +3143,7 @@ static int stk7070pd_frontend_attach1(struct dvb_usb_adapter *adap)
 static int novatd_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_usb_device *dev = adap->dev;
+	struct dib0700_state *st = dev->priv;
 
 	if (adap->id == 0) {
 		stk7070pd_init(dev);
@@ -3134,7 +3164,16 @@ static int novatd_frontend_attach(struct dvb_usb_adapter *adap)
 	adap->fe_adap[0].fe = dvb_attach(dib7000p_attach, &dev->i2c_adap,
 			adap->id == 0 ? 0x80 : 0x82,
 			&stk7070pd_dib7000p_config[adap->id]);
-	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
+
+	if (adap->fe_adap[0].fe == NULL)
+		return -ENODEV;
+
+	st->read_status = adap->fe_adap[0].fe->ops.read_status;
+	adap->fe_adap[0].fe->ops.read_status = novatd_read_status_override;
+	st->sleep = adap->fe_adap[0].fe->ops.sleep;
+	adap->fe_adap[0].fe->ops.sleep = novatd_sleep_override;
+
+	return 0;
 }
 
 /* S5H1411 */
-- 
1.7.8


