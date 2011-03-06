Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab1CFLan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 06:30:43 -0500
Received: from ist.d-labs.de ([213.239.218.44]:34944 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab1CFLak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 06:30:40 -0500
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: Florian Mickler <florian@mickler.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: [PATCH] [media] dib0700: get rid of on-stack dma buffers
Date: Sun,  6 Mar 2011 12:16:52 +0100
Message-Id: <1299410212-24897-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.rc3
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
---

Please take a look at it, as I do not do that much kernel hacking
and don't wanna brake anybodys computer... :)

>From my point of view this should _not_ go to stable even though it would
be applicable. But if someone feels strongly about that and can
take responsibility for that change...


drivers/media/dvb/dvb-usb/dib0700_core.c |  121 +++++++++++++++++++++++-------
 1 files changed, 94 insertions(+), 27 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 98ffb40..1a12182 100644
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
+	ret = dib0700_ctrl_wr(d, buf, sizeof(buf));
+
+	kfree(buf);
+	return ret;
 }
 
 static int dib0700_set_usb_xfer_len(struct dvb_usb_device *d, u16 nb_ts_packets)
@@ -141,13 +160,20 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 	uint8_t gen_mode = 0; /* 0=master i2c, 1=gpio i2c */
 	uint8_t en_start = 0;
 	uint8_t en_stop = 0;
-	uint8_t buf[255]; /* TBV: malloc ? */
+	uint8_t *buf;
 	int result, i;
 
+	buf = kmalloc(255, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	/* Ensure nobody else hits the i2c bus while we're sending our
 	   sequence of messages, (such as the remote control thread) */
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-		return -EAGAIN;
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0) {
+		result = -EAGAIN;
+		goto out;
+	}
+
 
 	for (i = 0; i < num; i++) {
 		if (i == 0) {
@@ -220,8 +246,12 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 			}
 		}
 	}
+	result = i;
 	mutex_unlock(&d->i2c_mutex);
-	return i;
+
+out:
+	kfree(buf);
+	return result;
 }
 
 /*
@@ -232,10 +262,17 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	int i,len;
-	u8 buf[255];
+	s16 ret;
+	u8 *buf;
 
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-		return -EAGAIN;
+	buf = kmalloc(255, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0) {
+		ret = -EAGAIN;
+		goto out;
+	}
 
 	for (i = 0; i < num; i++) {
 		/* fill in the address */
@@ -264,9 +301,11 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
 				break;
 		}
 	}
-
+	ret = i;
 	mutex_unlock(&d->i2c_mutex);
-	return i;
+out:
+	kfree(buf);
+	return ret;
 }
 
 static int dib0700_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msg,
@@ -297,15 +336,23 @@ struct i2c_algorithm dib0700_i2c_algo = {
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
 
@@ -313,7 +360,13 @@ static int dib0700_set_clock(struct dvb_usb_device *d, u8 en_pll,
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
@@ -325,7 +378,10 @@ static int dib0700_set_clock(struct dvb_usb_device *d, u8 en_pll,
 	b[8] = (dsuScaler >> 8)   & 0xff; // MSB
 	b[9] =  dsuScaler         & 0xff; // LSB
 
-	return dib0700_ctrl_wr(d, b, 10);
+	ret = dib0700_ctrl_wr(d, b, 10);
+
+	kfree(b);
+	return ret;
 }
 
 int dib0700_ctrl_clock(struct dvb_usb_device *d, u32 clk_MHz, u8 clock_out_gp3)
@@ -361,11 +417,14 @@ int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw
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
@@ -386,7 +445,7 @@ int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw
 
 		if (ret < 0) {
 			err("firmware download failed at %d with %d",pos,ret);
-			return ret;
+			goto out;
 		}
 	}
 
@@ -407,7 +466,7 @@ int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw
 	usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				  REQUEST_GET_VERSION,
 				  USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
-				  b, sizeof(b), USB_CTRL_GET_TIMEOUT);
+				  b, 16, USB_CTRL_GET_TIMEOUT);
 	fw_version = (b[8] << 24) | (b[9] << 16) | (b[10] << 8) | b[11];
 
 	/* set the buffer size - DVB-USB is allocating URB buffers
@@ -426,16 +485,21 @@ int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw
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
@@ -443,7 +507,7 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 			st->nb_packet_buffer_size);
 		if (ret < 0) {
 			deb_info("can not set the USB xfer len\n");
-			return ret;
+			goto out;
 		}
 	}
 
@@ -468,7 +532,10 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 
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

