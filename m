Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1DEVi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 17:38:28 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:45672 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015Ab1DEViV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 17:38:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ebefRqvNPDpsFlAp/d45lOmfYW+9RRxpWvLptC9jUBDP1F5fTYPvfAqu8HAMfQKDCk
         I4RrDKWFs5ibl4/dv/H5tBPo4uh9fWSftjMgk0YWPKFuMEDeBgNCDjZjs49qOrN0A0aF
         a+OKdgvPjaLm2Dt14hL4vzy+/3Es2vfUFikWw=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: davinci-linux-open-source@linux.davincidsp.com, linux-i2c@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bastian Ruppert <Bastian.Ruppert@sewerin.de>,
        Brad Griffis <bgriffis@ti.com>, Jon Povey <jon.povey@racelogic.co.uk>,
        Philby John <pjohn@in.mvista.com>, Sekhar Nori <nsekhar@ti.com>,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 4/6] i2c-davinci: use the DA8xx's ICPFUNC to toggle I2C as gpio
Date: Tue,  5 Apr 2011 17:38:07 -0400
Message-Id: <b370ead67f06434d2f8ae1e94ede12f625c3edfc.1302031487.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1302031487.git.bengardiner@nanometrics.ca>
References: <cover.1302031487.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the da850evm, with the default config of polling keys enabled, several
"controller timed out" errors were observed on the console; as well as the
same error observed on custom hardware when communicating with a i2c
touchscreen device. [1]

Discussion of the causes and potential workarounds began on the e2e forums [2]
where Brad Griffis pointed out that the da850 (and da830) has an i2c controller
whose SCL and SDA may be manipulated as GPIOs by using the ICPFUNC registers
of the i2c controller. He further suggested a means of using this feature to
send clock pulses on the I2C bus to free the frozen slave device.

Implement the suggested procedure by toggling SCL and checking SDA using the
ICPFUNC registers of the I2C controller when present. Allow platforms to
indicate the presence of the ICPFUNC registers with a has_pfunc platform data
flag.

[1] http://permalink.gmane.org/gmane.linux.davinci/22291
[2] http://e2e.ti.com/support/dsp/omap_applications_processors/f/42/p/99895/350610.aspx

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: Bastian Ruppert <Bastian.Ruppert@sewerin.de>
Cc: Brad Griffis <bgriffis@ti.com>
Cc: Jon Povey <jon.povey@racelogic.co.uk>
Cc: Philby John <pjohn@in.mvista.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Ben Dooks <ben-linux@fluff.org>

---
 arch/arm/mach-davinci/include/mach/i2c.h |    6 ++-
 drivers/i2c/busses/i2c-davinci.c         |   88 ++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/include/mach/i2c.h b/arch/arm/mach-davinci/include/mach/i2c.h
index ab07a44..858c5c6 100644
--- a/arch/arm/mach-davinci/include/mach/i2c.h
+++ b/arch/arm/mach-davinci/include/mach/i2c.h
@@ -19,12 +19,16 @@
  * @bus_delay:	post-transaction delay (usec)
  * @sda_pin:	GPIO pin ID to use for SDA
  * @scl_pin:	GPIO pin ID to use for SCL
+ * @has_pfunc:	set this to true if the i2c controller on your chip has a
+ *		ICPFUNC register which allows the SDA and SCL pins to be
+ *		controlled as gpio (like in DA850)
  */
 struct davinci_i2c_platform_data {
 	unsigned int	bus_freq;
 	unsigned int	bus_delay;
 	unsigned int	sda_pin;
 	unsigned int	scl_pin;
+	bool		has_pfunc;
 };
 
 /* for board setup code */
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 0a2c697..5bdc98c 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -65,6 +65,11 @@
 #define DAVINCI_I2C_IVR_REG	0x28
 #define DAVINCI_I2C_EMDR_REG	0x2c
 #define DAVINCI_I2C_PSC_REG	0x30
+#define DAVINCI_I2C_PFUNC_REG	0x48
+#define DAVINCI_I2C_PDIR_REG	0x4c
+#define DAVINCI_I2C_PDIN_REG	0x50
+#define DAVINCI_I2C_DSET_REG	0x58
+#define DAVINCI_I2C_DCLR_REG	0x5c
 
 #define DAVINCI_I2C_IVR_AAS	0x07
 #define DAVINCI_I2C_IVR_SCD	0x06
@@ -98,6 +103,29 @@
 #define DAVINCI_I2C_IMR_NACK	BIT(1)
 #define DAVINCI_I2C_IMR_AL	BIT(0)
 
+/* set SDA and SCL as GPIO */
+#define DAVINCI_I2C_PFUNC_PFUNC0	BIT(0)
+
+/* set SCL as output when used as GPIO*/
+#define DAVINCI_I2C_PDIR_PDIR0	BIT(0)
+/* set SDA as output when used as GPIO*/
+#define DAVINCI_I2C_PDIR_PDIR1	BIT(1)
+
+/* read SCL GPIO level */
+#define DAVINCI_I2C_PDIN_PDIN0 BIT(0)
+/* read SDA GPIO level */
+#define DAVINCI_I2C_PDIN_PDIN1 BIT(1)
+
+/*set the SCL GPIO high */
+#define DAVINCI_I2C_DSET_PDSET0	BIT(0)
+/*set the SDA GPIO high */
+#define DAVINCI_I2C_DSET_PDSET1	BIT(1)
+
+/* set the SCL GPIO low */
+#define DAVINCI_I2C_DCLR_PDCLR0	BIT(0)
+/* set the SDA GPIO low */
+#define DAVINCI_I2C_DCLR_PDCLR1	BIT(1)
+
 struct davinci_i2c_dev {
 	struct device           *dev;
 	void __iomem		*base;
@@ -182,6 +210,64 @@ static void generic_i2c_clock_pulse(struct davinci_i2c_dev *dev)
 	}
 }
 
+static inline void davinci_i2c_reset_ctrl(struct davinci_i2c_dev *i2c_dev,
+								int val);
+
+/* Generate gpio a pulse on the i2c clock pin. */
+static void i2c_davinci_pfunc_i2c_clock_pulse(struct davinci_i2c_dev *dev)
+{
+	u32 flag = 0;
+	u16 i;
+
+	davinci_i2c_reset_ctrl(dev, 0);
+
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, 0x00);
+
+	/* SCL output, SDA input */
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_PDIR_REG,
+				DAVINCI_I2C_PDIR_PDIR0);
+
+	/* change to GPIO mode */
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_PFUNC_REG,
+				DAVINCI_I2C_PFUNC_PFUNC0);
+
+	/* SCL high */
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_DSET_REG,
+				DAVINCI_I2C_DSET_PDSET0);
+	udelay(5);
+	for (i = 0; i < 16; i++) {
+		/* SCL low */
+		davinci_i2c_write_reg(dev, DAVINCI_I2C_DCLR_REG,
+					DAVINCI_I2C_DCLR_PDCLR0);
+		udelay(5);
+		/* SCL high */
+		davinci_i2c_write_reg(dev, DAVINCI_I2C_DSET_REG,
+					DAVINCI_I2C_DSET_PDSET0);
+		udelay(5);
+
+		/* read the state of SDA */
+		flag = davinci_i2c_read_reg(dev, DAVINCI_I2C_PDIN_REG);
+		if (flag & DAVINCI_I2C_PDIN_PDIN1) {
+			dev_dbg(dev->dev, "recovered after %d SCL pulses",
+					i + 1);
+			break;
+		}
+	}
+
+	/* change back to I2C mode */
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_PFUNC_REG, 0);
+
+	/* take the I2C dev out of reset */
+	davinci_i2c_reset_ctrl(dev, 1);
+
+	/* read the state of SDA */
+	flag = davinci_i2c_read_reg(dev, DAVINCI_I2C_PDIN_REG);
+	if (flag & DAVINCI_I2C_PDIN_PDIN1)
+		return;
+
+	dev_err(dev->dev, "I2C slave will not release SDA.\n");
+}
+
 /* This routine does i2c bus recovery as specified in the
  * i2c protocol Rev. 03 section 3.16 titled "Bus clear"
  */
@@ -756,6 +842,8 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 	pdata = dev->dev->platform_data;
 	if (pdata->scl_pin)
 		dev->pulse_scl = generic_i2c_clock_pulse;
+	else if (pdata->has_pfunc)
+		dev->pulse_scl = i2c_davinci_pfunc_i2c_clock_pulse;
 
 	return 0;
 
-- 
1.7.1

