Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab2JJXBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:01:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33783 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757841Ab2JJXBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:01:46 -0400
X-Sasl-enc: PYJmfzU0eGYrjl/Lnk+qQRWxrGLixgp/RWWyCaVjCrvv 1349910105
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 025/122] drxk: allow loading firmware synchrousnously
Date: Thu, 11 Oct 2012 07:53:11 +0900
Message-Id: <20121010225342.666021217@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 8e30783b0b3270736b2cff6415c68b894bc411df upstream.

Due to udev-182, the firmware load was changed to be async, as
otherwise udev would give up of loading a firmware.

Add an option to return to the previous behaviour, async firmware
loads cause failures with the tda18271 driver.

Antti tested it with the following hardware:
        Hauppauge WinTV HVR 930C
        MaxMedia UB425-TC
        PCTV QuatroStick nano (520e)

Tested-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb/frontends/drxk.h      |    2 ++
 drivers/media/dvb/frontends/drxk_hard.c |   20 +++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/media/dvb/frontends/drxk.h
+++ b/drivers/media/dvb/frontends/drxk.h
@@ -28,6 +28,7 @@
  *				A value of 0 (default) or lower indicates that
  *				the correct number of parameters will be
  *				automatically detected.
+ * @load_firmware_sync:		Force the firmware load to be synchronous.
  *
  * On the *_gpio vars, bit 0 is UIO-1, bit 1 is UIO-2 and bit 2 is
  * UIO-3.
@@ -39,6 +40,7 @@ struct drxk_config {
 	bool	parallel_ts;
 	bool	dynamic_clk;
 	bool	enable_merr_cfg;
+	bool	load_firmware_sync;
 
 	bool	antenna_dvbt;
 	u16	antenna_gpio;
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6609,15 +6609,25 @@ struct dvb_frontend *drxk_attach(const s
 
 	/* Load firmware and initialize DRX-K */
 	if (state->microcode_name) {
-		status = request_firmware_nowait(THIS_MODULE, 1,
+		if (config->load_firmware_sync) {
+			const struct firmware *fw = NULL;
+
+			status = request_firmware(&fw, state->microcode_name,
+						  state->i2c->dev.parent);
+			if (status < 0)
+				fw = NULL;
+			load_firmware_cb(fw, state);
+		} else {
+			status = request_firmware_nowait(THIS_MODULE, 1,
 					      state->microcode_name,
 					      state->i2c->dev.parent,
 					      GFP_KERNEL,
 					      state, load_firmware_cb);
-		if (status < 0) {
-			printk(KERN_ERR
-			"drxk: failed to request a firmware\n");
-			return NULL;
+			if (status < 0) {
+				printk(KERN_ERR
+				       "drxk: failed to request a firmware\n");
+				return NULL;
+			}
 		}
 	} else if (init_drxk(state) < 0)
 		goto error;


