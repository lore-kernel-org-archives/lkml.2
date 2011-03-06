Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1CFOqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 09:46:15 -0500
Received: from ist.d-labs.de ([213.239.218.44]:44991 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab1CFOqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 09:46:10 -0500
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: Florian Mickler <florian@mickler.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Oliver Neukum <oliver@neukum.org>, Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 1/3 v2] [media] dib0700: get rid of on-stack dma buffers
Date: Sun,  6 Mar 2011 15:45:14 +0100
Message-Id: <1299422716-29461-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <20110306153805.001011a9@schatten.dmk.lab>
References: <20110306153805.001011a9@schatten.dmk.lab>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should fix warnings seen by some:
	WARNING: at lib/dma-debug.c:866 check_for_stack

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=15977.
Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Signed-off-by: Florian Mickler <florian@mickler.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <greg@kroah.com>
CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Oliver Neukum <oliver@neukum.org>
CC: Jack Stone <jwjstone@fastmail.fm>

[v2: use preallocated buffer where the mutex is held; fix sizeof in one case]
---
 drivers/media/dvb/dvb-usb/dib0700.h      |    5 +-
 drivers/media/dvb/dvb-usb/dib0700_core.c |   92 +++++++++++++++++++++++-------
 2 files changed, 74 insertions(+), 23 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700.h b/drivers/media/dvb/dvb-usb/dib0700.h
index 3537d65..1401e7d 100644
--- a/drivers/media/dvb/dvb-usb/dib0700.h
+++ b/drivers/media/dvb/dvb-usb/dib0700.h
@@ -45,8 +45,9 @@ struct dib0700_state {
 	u8 is_dib7000pc;
 	u8 fw_use_new_i2c_api;
 	u8 disable_streaming_master_mode;
-    u32 fw_version;
-    u32 nb_packet_buffer_size;
+	u32 fw_version;
+	u32 nb_packet_buffer_size;
+	u8 buf[255];
 };
 
 extern int dib0700_get_version(struct dvb_usb_device *d, u32 *hwversion,
diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 98ffb40..028ed87 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -27,11 +27,17 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 int dib0700_get_version(struct dvb_usb_device *d, u32 *hwversion,
 			u32 *romversion, u32 *ramversion, u32 *fwtype)
 {
-	u8 b[16];
-	int ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
+	int ret;
+	u8 *b;
+
+	b = kmalloc(16, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
+	ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
 				  REQUEST_GET_VERSION,
 				  USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
-				  b, sizeof(b), USB_CTRL_GET_TIMEOUT);
+				  b, 16, USB_CTRL_GET_TIMEOUT);
 	if (hwversion != NULL)
 		*hwversion  = (b[0] << 24)  | (b[1] << 16)  | (b[2] << 8)  | b[3];
 	if (romversion != NULL)
@@ -40,6 +46,8 @@ int dib0700_get_version(struct dvb_usb_device *d, u32 *hwversion,
 		*ramversion = (b[8] << 24)  | (b[9] << 16)  | (b[10] << 8) | b[11];
 	if (fwtype != NULL)
 		*fwtype     = (b[12] << 24) | (b[13] << 16) | (b[14] << 8) | b[15];
+
+	kfree(b);
 	return ret;
 }
 
@@ -101,8 +109,19 @@ int dib0700_ctrl_rd(struct dvb_usb_device *d, u8 *tx, u8 txlen, u8 *rx, u8 rxlen
 
 int dib0700_set_gpio(struct dvb_usb_device *d, enum dib07x0_gpios gpio, u8 gpio_dir, u8 gpio_val)
 {
-	u8 buf[3] = { REQUEST_SET_GPIO, gpio, ((gpio_dir & 0x01) << 7) | ((gpio_val & 0x01) << 6) };
-	return dib0700_ctrl_wr(d, buf, sizeof(buf));
+	s16 ret;
+	u8 *buf = kmalloc(3, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	buf[0] = REQUEST_SET_GPIO;
+	buf[1] = gpio;
+	buf[2] = ((gpio_dir & 0x01) << 7) | ((gpio_val & 0x01) << 6);
+
+	ret = dib0700_ctrl_wr(d, buf, 3);
+
+	kfree(buf);
+	return ret;
 }
 
 static int dib0700_set_usb_xfer_len(struct dvb_usb_device *d, u16 nb_ts_packets)
@@ -137,11 +156,12 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 	   properly support i2c read calls not preceded by a write */
 
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	struct dib0700_state *st = d->priv;
 	uint8_t bus_mode = 1;  /* 0=eeprom bus, 1=frontend bus */
 	uint8_t gen_mode = 0; /* 0=master i2c, 1=gpio i2c */
 	uint8_t en_start = 0;
 	uint8_t en_stop = 0;
-	uint8_t buf[255]; /* TBV: malloc ? */
+	uint8_t *buf = st->buf;
 	int result, i;
 
 	/* Ensure nobody else hits the i2c bus while we're sending our
@@ -221,6 +241,7 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 		}
 	}
 	mutex_unlock(&d->i2c_mutex);
+
 	return i;
 }
 
@@ -231,8 +252,9 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
 				   struct i2c_msg *msg, int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	struct dib0700_state *st = d->priv;
 	int i,len;
-	u8 buf[255];
+	u8 *buf = st->buf;
 
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
@@ -264,8 +286,8 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
 				break;
 		}
 	}
-
 	mutex_unlock(&d->i2c_mutex);
+
 	return i;
 }
 
@@ -297,15 +319,23 @@ struct i2c_algorithm dib0700_i2c_algo = {
 int dib0700_identify_state(struct usb_device *udev, struct dvb_usb_device_properties *props,
 			struct dvb_usb_device_description **desc, int *cold)
 {
-	u8 b[16];
-	s16 ret = usb_control_msg(udev, usb_rcvctrlpipe(udev,0),
+	s16 ret;
+	u8 *b;
+
+	b = kmalloc(16, GFP_KERNEL);
+	if (!b)
+		return	-ENOMEM;
+
+
+	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 		REQUEST_GET_VERSION, USB_TYPE_VENDOR | USB_DIR_IN, 0, 0, b, 16, USB_CTRL_GET_TIMEOUT);
 
 	deb_info("FW GET_VERSION length: %d\n",ret);
 
 	*cold = ret <= 0;
-
 	deb_info("cold: %d\n", *cold);
+
+	kfree(b);
 	return 0;
 }
 
@@ -313,7 +343,13 @@ static int dib0700_set_clock(struct dvb_usb_device *d, u8 en_pll,
 	u8 pll_src, u8 pll_range, u8 clock_gpio3, u16 pll_prediv,
 	u16 pll_loopdiv, u16 free_div, u16 dsuScaler)
 {
-	u8 b[10];
+	s16 ret;
+	u8 *b;
+
+	b = kmalloc(10, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
 	b[0] = REQUEST_SET_CLOCK;
 	b[1] = (en_pll << 7) | (pll_src << 6) | (pll_range << 5) | (clock_gpio3 << 4);
 	b[2] = (pll_prediv >> 8)  & 0xff; // MSB
@@ -325,7 +361,10 @@ static int dib0700_set_clock(struct dvb_usb_device *d, u8 en_pll,
 	b[8] = (dsuScaler >> 8)   & 0xff; // MSB
 	b[9] =  dsuScaler         & 0xff; // LSB
 
-	return dib0700_ctrl_wr(d, b, 10);
+	ret = dib0700_ctrl_wr(d, b, 10);
+
+	kfree(b);
+	return ret;
 }
 
 int dib0700_ctrl_clock(struct dvb_usb_device *d, u32 clk_MHz, u8 clock_out_gp3)
@@ -361,11 +400,14 @@ int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw
 {
 	struct hexline hx;
 	int pos = 0, ret, act_len, i, adap_num;
-	u8 b[16];
+	u8 *b;
 	u32 fw_version;
-
 	u8 buf[260];
 
+	b = kmalloc(16, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
 	while ((ret = dvb_usb_get_hexline(fw, &hx, &pos)) > 0) {
 		deb_fwdata("writing to address 0x%08x (buffer: 0x%02x %02x)\n",
 				hx.addr, hx.len, hx.chk);
@@ -386,7 +428,7 @@ int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw
 
 		if (ret < 0) {
 			err("firmware download failed at %d with %d",pos,ret);
-			return ret;
+			goto out;
 		}
 	}
 
@@ -407,7 +449,7 @@ int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw
 	usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				  REQUEST_GET_VERSION,
 				  USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
-				  b, sizeof(b), USB_CTRL_GET_TIMEOUT);
+				  b, 16, USB_CTRL_GET_TIMEOUT);
 	fw_version = (b[8] << 24) | (b[9] << 16) | (b[10] << 8) | b[11];
 
 	/* set the buffer size - DVB-USB is allocating URB buffers
@@ -426,16 +468,21 @@ int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw
 			}
 		}
 	}
-
+out:
+	kfree(b);
 	return ret;
 }
 
 int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 	struct dib0700_state *st = adap->dev->priv;
-	u8 b[4];
+	u8 *b;
 	int ret;
 
+	b = kmalloc(4, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
 	if ((onoff != 0) && (st->fw_version >= 0x10201)) {
 		/* for firmware later than 1.20.1,
 		 * the USB xfer length can be set  */
@@ -443,7 +490,7 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 			st->nb_packet_buffer_size);
 		if (ret < 0) {
 			deb_info("can not set the USB xfer len\n");
-			return ret;
+			goto out;
 		}
 	}
 
@@ -468,7 +515,10 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 
 	deb_info("data for streaming: %x %x\n", b[1], b[2]);
 
-	return dib0700_ctrl_wr(adap->dev, b, 4);
+	ret = dib0700_ctrl_wr(adap->dev, b, 4);
+out:
+	kfree(b);
+	return ret;
 }
 
 int dib0700_change_protocol(struct rc_dev *rc, u64 rc_type)
-- 
1.7.4.rc3

