Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab0DYOjI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 10:39:08 -0400
Received: from tex.lwn.net ([70.33.254.29]:34664 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab0DYOjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 10:39:05 -0400
Date: Sun, 25 Apr 2010 08:38:58 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Harald Welte <laforge@gnumonks.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       linux-kernel@vger.kernel.org, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn
Subject: Re: [PATCH 10/11] viafb: rework the I2C support in the VIA
 framebuffer driver
Message-ID: <20100425083858.269bf0d8@bike.lwn.net>
In-Reply-To: <20100424135316.GR24811@prithivi.gnumonks.org>
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>
	<1271614873-5952-11-git-send-email-corbet@lwn.net>
	<4BD20D56.7080402@gmx.de>
	<20100423155725.7d3b2d2d@bike.lwn.net>
	<4BD221E7.7060705@gmx.de>
	<20100423165256.654ca5eb@bike.lwn.net>
	<4BD22B96.5020102@gmx.de>
	<4BD2CC46.4060908@gmx.de>
	<20100424073359.349b4397@bike.lwn.net>
	<20100424135316.GR24811@prithivi.gnumonks.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Apr 2010 15:53:16 +0200
Harald Welte <laforge@gnumonks.org> wrote:

> Simply converting the original two busses to the new code is definitely
> the way to go.  Maybe we'll keep the code for the other two around, but
> somehow keep them inactive and don't advertise them unless somebody explicitly
> does so?

OK, my proposal would be to add the following patch into the early part
of the series; that will help to avoid the creation of confusion in the
middle until the full i2c/gpio configuration code is in.

Look good?

Thanks,

jon

viafb: Only establish i2c busses on ports that always had them

...otherwise it seems we run into conflicts with shadowy other users which
don't expect to see i2c taking control of ports it never used to do
anything with.

Reported-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via_i2c.c |   19 +++++++++++++------
 drivers/video/via/via_i2c.h |    1 +
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index fe5535c..b5253e3 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -170,13 +170,18 @@ static int create_i2c_bus(struct i2c_adapter *adapter,
 	return i2c_bit_add_bus(adapter);
 }
 
+/*
+ * By default, we only activate busses on ports 2c and 31 to avoid
+ * conflicts with other possible users; that default can be changed
+ * below.
+ */
 static struct via_i2c_adap_cfg adap_configs[] = {
-	[VIA_I2C_ADAP_26]	= { VIA_I2C_I2C,  VIASR, 0x26 },
-	[VIA_I2C_ADAP_31]	= { VIA_I2C_I2C,  VIASR, 0x31 },
-	[VIA_I2C_ADAP_25]	= { VIA_I2C_GPIO, VIASR, 0x25 },
-	[VIA_I2C_ADAP_2C]	= { VIA_I2C_GPIO, VIASR, 0x2c },
-	[VIA_I2C_ADAP_3D]	= { VIA_I2C_GPIO, VIASR, 0x3d },
-	{ 0, 0, 0 }
+	[VIA_I2C_ADAP_26]	= { VIA_I2C_I2C,  VIASR, 0x26, 0 },
+	[VIA_I2C_ADAP_31]	= { VIA_I2C_I2C,  VIASR, 0x31, 1 },
+	[VIA_I2C_ADAP_25]	= { VIA_I2C_GPIO, VIASR, 0x25, 0 },
+	[VIA_I2C_ADAP_2C]	= { VIA_I2C_GPIO, VIASR, 0x2c, 1 },
+	[VIA_I2C_ADAP_3D]	= { VIA_I2C_GPIO, VIASR, 0x3d, 0 },
+	{ 0, 0, 0, 0 }
 };
 
 int viafb_create_i2c_busses(struct viafb_par *viapar)
@@ -189,6 +194,8 @@ int viafb_create_i2c_busses(struct viafb_par *viapar)
 
 		if (adap_cfg->type == 0)
 			break;
+		if (!adap_cfg->is_active)
+			continue;
 
 		ret = create_i2c_bus(&i2c_stuff->adapter,
 				     &i2c_stuff->algo, adap_cfg,
diff --git a/drivers/video/via/via_i2c.h b/drivers/video/via/via_i2c.h
index 00ed978..73d682f 100644
--- a/drivers/video/via/via_i2c.h
+++ b/drivers/video/via/via_i2c.h
@@ -35,6 +35,7 @@ struct via_i2c_adap_cfg {
 	enum via_i2c_type	type;
 	u_int16_t		io_port;
 	u_int8_t		ioport_index;
+	u8			is_active;
 };
 
 struct via_i2c_stuff {
-- 
1.7.0.1

