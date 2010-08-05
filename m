Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011Ab0HESR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:17:26 -0400
Received: from ns2.cypress.com ([157.95.67.5]:53271 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933328Ab0HESRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:17:22 -0400
From: Kevin McNeely <kev@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Brown <davidb@codeaurora.org>, Trilok Soni <tsoni@codeaurora.org>,
        Fred <fwk@ubuntu.linuxcertified.com>, Kevin McNeely <kev@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Todd Fischer <todd.fischer@ridgerun.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: cyttsp i2c and spi touchscreen driver init submit
Date: Thu,  5 Aug 2010 11:12:02 -0700
Message-Id: <1281031924-3032-1-git-send-email-kev@cypress.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <Kevin McNeely <kev@cypress.com>
References: <Kevin McNeely <kev@cypress.com>
X-Brightmail-Tracker: AAAAAA==
MIME-Version: 1.0
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fred <fwk@ubuntu.linuxcertified.com>

This is a new touchscreen driver for the Cypress Semiconductor
cyttsp family of devices.  This updated driver is for both the i2c and spi
versions of the devices. The driver code consists of common core code for
both i2c and spi driver.  This submission is in response to review comments
from the initial submission.

Signed-off-by: Kevin McNeely <kev@cypress.com>
---
 drivers/input/touchscreen/Kconfig            |   33 +
 drivers/input/touchscreen/Makefile           |    3 +
 drivers/input/touchscreen/cyttsp_board-xxx.c |  110 ++
 drivers/input/touchscreen/cyttsp_core.c      | 1778 ++++++++++++++++++++++++++
 drivers/input/touchscreen/cyttsp_core.h      |   49 +
 drivers/input/touchscreen/cyttsp_i2c.c       |  183 +++
 drivers/input/touchscreen/cyttsp_spi.c       |  339 +++++
 include/linux/cyttsp.h                       |  104 ++
 8 files changed, 2599 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/cyttsp_board-xxx.c
 create mode 100755 drivers/input/touchscreen/cyttsp_core.c
 create mode 100755 drivers/input/touchscreen/cyttsp_core.h
 create mode 100755 drivers/input/touchscreen/cyttsp_i2c.c
 create mode 100755 drivers/input/touchscreen/cyttsp_spi.c
 create mode 100755 include/linux/cyttsp.h

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 3b9d5e2..b923379 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -603,4 +603,37 @@ config TOUCHSCREEN_TPS6507X
 	  To compile this driver as a module, choose M here: the
 	  module will be called tps6507x_ts.
 
+config TOUCHSCREEN_CYTTSP_I2C
+	default n
+	tristate "Cypress TTSP i2c touchscreen"
+	depends on I2C
+	help
+	  Say Y here if you have a Cypress TTSP touchscreen
+	  connected to your system's i2c bus.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cyttsp_i2c.
+
+config TOUCHSCREEN_CYTTSP_SPI
+	default n
+	tristate "Cypress TTSP spi touchscreen"
+	depends on SPI_MASTER
+	help
+	  Say Y here if you have a Cypress TTSP touchscreen
+	  connected to your system's spi bus.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cyttsp_spi.
+
+config TOUCHSCREEN_CYTTSP_CORE
+	default y
+	bool "Cypress TTSP touchscreen core"
+	depends on TOUCHSCREEN_CYTTSP_I2C || TOUCHSCREEN_CYTTSP_SPI
+	help
+	  Always activated for Cypress TTSP touchscreen
+
 endif
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 497964a..b3bdb09 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -47,3 +47,6 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
 obj-$(CONFIG_TOUCHSCREEN_TPS6507X)	+= tps6507x-ts.o
+obj-$(CONFIG_TOUCHSCREEN_CYTTSP_CORE)	+= cyttsp_core.o
+obj-$(CONFIG_TOUCHSCREEN_CYTTSP_SPI)	+= cyttsp_spi.o
+obj-$(CONFIG_TOUCHSCREEN_CYTTSP_I2C)	+= cyttsp_i2c.o
diff --git a/drivers/input/touchscreen/cyttsp_board-xxx.c b/drivers/input/touchscreen/cyttsp_board-xxx.c
new file mode 100644
index 0000000..cda08c8
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp_board-xxx.c
@@ -0,0 +1,110 @@
+#include <linux/cyttsp.h>
+#define CY_USE_MT		/* undef for ST only */
+#define TS_GPIO_IRQ	150
+
+static int cyttsp_init(int on)
+{
+	if (on) {
+		/* add any special code to initialize any required system hw
+		 * such as regulators or gpio pins
+		 */
+		int rc;
+		pr_info(" %s: in cyttsp_platform_init \n", __func__);
+
+	 	rc = gpio_tlmm_config(GPIO_CFG(TS_GPIO_IRQ, 0, GPIO_INPUT,
+		                GPIO_PULL_UP, GPIO_6MA), GPIO_ENABLE);
+		if (rc)
+		        printk(KERN_ALERT "%s: Could not configure gpio %d\n",
+		                        __func__, TS_GPIO_IRQ);
+
+		rc = gpio_request(TS_GPIO_IRQ, "ts_irq");
+		if (rc)
+		        pr_err("%s: unable to request gpio %d (%d)\n",
+		                        __func__, TS_GPIO_IRQ, rc);
+	} else {
+		gpio_free(TS_GPIO_IRQ);
+	}
+	return 0;
+}
+
+static int cyttsp_wakeup(void)
+{
+	return 0;
+}
+
+static struct cyttsp_platform_data cypress_ttsp_platform_data = {
+	.wakeup = cyttsp_wakeup,
+	.init = cyttsp_init,
+#ifdef CY_USE_MT
+	.mt_sync = input_mt_sync,
+#endif
+	.maxx = 479,
+	.maxy = 799,
+	.flags = 0,
+	.gen = CY_GEN3,
+	.use_st = 0,
+	.use_mt = 1,
+	.use_trk_id = 0,
+	.use_hndshk = 1,
+	.use_timer = 0,
+	.use_sleep = 1,
+	.use_gestures = 0,
+	.use_load_file = 0,
+	.use_force_fw_update = 1,
+	.use_virtual_keys = 1,
+	/* activate up to 4 groups
+	 * and set active distance
+	 */
+	.gest_set = CY_GEST_GRP_NONE | CY_ACT_DIST,
+	/* change act_intrvl to customize the Active power state
+	 * scanning/processing refresh interval for Operating mode
+	 */
+	.act_intrvl = CY_ACT_INTRVL_DFLT,
+	/* change tch_tmout to customize the touch timeout for the
+	 * Active power state for Operating mode
+	 */
+	.tch_tmout = CY_TCH_TMOUT_DFLT,
+	/* change lp_intrvl to customize the Low Power power state
+	 * scanning/processing refresh interval for Operating mode
+	 */
+	.lp_intrvl = CY_LP_INTRVL_DFLT,
+	.name = CY_I2C_NAME,
+	.irq_gpio = TS_GPIO_IRQ,
+};
+
+#ifdef USE_I2C
+static struct i2c_board_info cyttsp_info[] __initdata = {
+	{
+		I2C_BOARD_INFO(CY_I2C_NAME, 0x24),
+		.platform_data = &cypress_ttsp_platform_data,
+		.irq = MSM_GPIO_TO_INT(TS_GPIO_IRQ),
+	},
+};
+
+static void __init xxx_init(void)
+	i2c_register_board_info(0, cyttsp_info,
+			ARRAY_SIZE(cyttsp_info));
+#else // USE_SPI
+static struct spi_board_info xxx_cyttsp_spi_board_info[] __initdata = {
+	{
+		.modalias = CY_SPI_NAME,
+		.platform_data  = &cypress_ttsp_platform_data,
+		.irq = TS_GPIO_IRQ,
+		.max_speed_hz   = 1000000,
+		.bus_num = 4,
+		.chip_select = 0,
+		.mode = SPI_MODE_0,
+	},
+};
+
+#endif
+
+static void __init xxx_cyttsp_init(void)
+{
+	printk(KERN_INFO "irq = %d\n", xxx_cyttsp_spi_board_info[0].irq);
+	spi_register_board_info(xxx_cyttsp_spi_board_info,
+			ARRAY_SIZE(xxx_cyttsp_spi_board_info));
+}
+
+#endif
+
diff --git a/drivers/input/touchscreen/cyttsp_core.c b/drivers/input/touchscreen/cyttsp_core.c
new file mode 100755
index 0000000..95019e9
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp_core.c
@@ -0,0 +1,1778 @@
+/* Core Source for:
+ * Cypress TrueTouch(TM) Standard Product (TTSP) touchscreen drivers.
+ * For use with Cypress Txx2xx and Txx3xx parts.
+ * Supported parts include:
+ * CY8CTST241
+ * CY8CTMG240
+ * CY8CTST341
+ * CY8CTMA340
+ *
+ * Copyright (C) 2009, 2010 Cypress Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, and only version 2, as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ *
+ * Contact Cypress Semiconductor at www.cypress.com (kev@cypress.com)
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
+#include <linux/byteorder/generic.h>
+#include <linux/bitops.h>
+#include <linux/cyttsp.h>
+#include <linux/ctype.h>
+#include "cyttsp_core.h"
+
+#define DBG(x)
+
+/* rely on kernel input.h to define Multi-Touch capability */
+#ifndef ABS_MT_TRACKING_ID
+/* define only if not defined already by system; */
+/* value based on linux kernel 2.6.30.10 */
+#define ABS_MT_TRACKING_ID (ABS_MT_BLOB_ID + 1)
+#endif /* ABS_MT_TRACKING_ID */
+
+#define	TOUCHSCREEN_TIMEOUT (msecs_to_jiffies(28))
+/* Bootloader File 0 offset */
+#define CY_BL_FILE0       0x00
+/* Bootloader command directive */
+#define CY_BL_CMD         0xFF
+/* Bootloader Enter Loader mode */
+#define CY_BL_ENTER       0x38
+/* Bootloader Write a Block */
+#define CY_BL_WRITE_BLK   0x39
+/* Bootloader Terminate Loader mode */
+#define CY_BL_TERMINATE   0x3B
+/* Bootloader Exit and Verify Checksum command */
+#define CY_BL_EXIT        0xA5
+/* Bootloader default keys */
+#define CY_BL_KEY0 0
+#define CY_BL_KEY1 1
+#define CY_BL_KEY2 2
+#define CY_BL_KEY3 3
+#define CY_BL_KEY4 4
+#define CY_BL_KEY5 5
+#define CY_BL_KEY6 6
+#define CY_BL_KEY7 7
+
+#define CY_DIFF(m, n)               ((m) != (n))
+#define GET_NUM_TOUCHES(x)          ((x) & 0x0F)
+#define GET_TOUCH1_ID(x)            (((x) & 0xF0) >> 4)
+#define GET_TOUCH2_ID(x)            ((x) & 0x0F)
+#define GET_TOUCH3_ID(x)            (((x) & 0xF0) >> 4)
+#define GET_TOUCH4_ID(x)            ((x) & 0x0F)
+#define IS_LARGE_AREA(x)            (((x) & 0x10) >> 4)
+#define IS_BAD_PKT(x)               ((x) & 0x20)
+#define FLIP_DATA_FLAG              0x01
+#define REVERSE_X_FLAG              0x02
+#define REVERSE_Y_FLAG              0x04
+#define FLIP_DATA(flags)            ((flags) & FLIP_DATA_FLAG)
+#define REVERSE_X(flags)            ((flags) & REVERSE_X_FLAG)
+#define REVERSE_Y(flags)            ((flags) & REVERSE_Y_FLAG)
+#define FLIP_XY(x, y)      {typeof(x) tmp; tmp = (x); (x) = (y); (y) = tmp; }
+#define INVERT_X(x, xmax)           ((xmax) - (x))
+#define INVERT_Y(y, ymax)           ((ymax) - (y))
+#define SET_HSTMODE(reg, mode)      ((reg) & (mode))
+#define GET_HSTMODE(reg)            ((reg & 0x70) >> 4)
+#define GET_BOOTLOADERMODE(reg)     ((reg & 0x10) >> 4)
+
+/* maximum number of concurrent ST track IDs */
+#define CY_NUM_ST_TCH_ID            2
+/* maximum number of concurrent MT track IDs */
+#define CY_NUM_MT_TCH_ID            4
+/* maximum number of track IDs */
+#define CY_NUM_TRK_ID               16
+
+#define CY_NTCH                     0 /* lift off */
+#define CY_TCH                      1 /* touch down */
+#define CY_ST_FNGR1_IDX             0
+#define CY_ST_FNGR2_IDX             1
+#define CY_MT_TCH1_IDX              0
+#define CY_MT_TCH2_IDX              1
+#define CY_MT_TCH3_IDX              2
+#define CY_MT_TCH4_IDX              3
+#define CY_XPOS                     0
+#define CY_YPOS                     1
+#define CY_IGNR_TCH               (-1)
+#define CY_SMALL_TOOL_WIDTH         10
+#define CY_LARGE_TOOL_WIDTH         255
+#define CY_REG_BASE                 0x00
+#define CY_REG_GEST_SET             0x1E
+#define CY_REG_ACT_INTRVL           0x1D
+#define CY_REG_TCH_TMOUT            (CY_REG_ACT_INTRVL+1)
+#define CY_REG_LP_INTRVL            (CY_REG_TCH_TMOUT+1)
+#define CY_SOFT_RESET               (1 << 0)
+#define CY_DEEP_SLEEP               (1 << 1)
+#define CY_LOW_POWER                (1 << 2)
+#define CY_MAXZ                     255
+#define CY_INIT                     1
+#define CY_DELAY_DFLT               10 /* ms */
+#define CY_DELAY_SYSINFO            20 /* ms */
+#define CY_DELAY_BL                 300
+#define CY_DELAY_DNLOAD             100 /* ms */
+#define CY_HNDSHK_BIT               0x80
+#define CY_NUM_RETRY                4 /* max number of retries for read ops */
+/* device mode bits */
+#define CY_OPERATE_MODE             0x00
+#define CY_SYSINFO_MODE             0x10
+/* power mode select bits */
+#define CY_SOFT_RESET_MODE          0x01 /* return to Bootloader mode */
+#define CY_DEEP_SLEEP_MODE          0x02
+#define CY_LOW_POWER_MODE           0x04
+#define CY_NUM_KEY                  8
+
+/* TrueTouch Standard Product Gen3 (Txx3xx) interface definition */
+struct cyttsp_xydata {
+	u8 hst_mode;
+	u8 tt_mode;
+	u8 tt_stat;
+	u16 x1 __attribute__ ((packed));
+	u16 y1 __attribute__ ((packed));
+	u8 z1;
+	u8 touch12_id;
+	u16 x2 __attribute__ ((packed));
+	u16 y2 __attribute__ ((packed));
+	u8 z2;
+	u8 gest_cnt;
+	u8 gest_id;
+	u16 x3 __attribute__ ((packed));
+	u16 y3 __attribute__ ((packed));
+	u8 z3;
+	u8 touch34_id;
+	u16 x4 __attribute__ ((packed));
+	u16 y4 __attribute__ ((packed));
+	u8 z4;
+	u8 tt_undef[3];
+	u8 gest_set;
+	u8 tt_reserved;
+};
+
+struct cyttsp_xydata_gen2 {
+	u8 hst_mode;
+	u8 tt_mode;
+	u8 tt_stat;
+	u16 x1 __attribute__ ((packed));
+	u16 y1 __attribute__ ((packed));
+	u8 z1;
+	u8 evnt_idx;
+	u16 x2 __attribute__ ((packed));
+	u16 y2 __attribute__ ((packed));
+	u8 tt_undef1;
+	u8 gest_cnt;
+	u8 gest_id;
+	u8 tt_undef[14];
+	u8 gest_set;
+	u8 tt_reserved;
+};
+
+/* TrueTouch Standard Product Gen2 (Txx2xx) interface definition */
+enum cyttsp_gen2_std {
+	CY_GEN2_NOTOUCH = 0x03, /* Both touches removed */
+	CY_GEN2_GHOST =   0x02, /* ghost */
+	CY_GEN2_2TOUCH =  0x03, /* 2 touch; no ghost */
+	CY_GEN2_1TOUCH =  0x01, /* 1 touch only */
+	CY_GEN2_TOUCH2 =  0x01, /* 1st touch removed; 2nd touch remains */
+};
+
+/* TTSP System Information interface definition */
+struct cyttsp_sysinfo_data {
+	u8 hst_mode;
+	u8 mfg_cmd;
+	u8 mfg_stat;
+	u8 cid[3];
+	u8 tt_undef1;
+	u8 uid[8];
+	u8 bl_verh;
+	u8 bl_verl;
+	u8 tts_verh;
+	u8 tts_verl;
+	u8 app_idh;
+	u8 app_idl;
+	u8 app_verh;
+	u8 app_verl;
+	u8 tt_undef[6];
+	u8 act_intrvl;
+	u8 tch_tmout;
+	u8 lp_intrvl;
+};
+
+/* TTSP Bootloader Register Map interface definition */
+#define CY_BL_CHKSUM_OK 0x01
+struct cyttsp_bootloader_data {
+	u8 bl_file;
+	u8 bl_status;
+	u8 bl_error;
+	u8 blver_hi;
+	u8 blver_lo;
+	u8 bld_blver_hi;
+	u8 bld_blver_lo;
+	u8 ttspver_hi;
+	u8 ttspver_lo;
+	u8 appid_hi;
+	u8 appid_lo;
+	u8 appver_hi;
+	u8 appver_lo;
+	u8 cid_0;
+	u8 cid_1;
+	u8 cid_2;
+};
+
+#define cyttsp_wake_data cyttsp_xydata
+
+struct cyttsp {
+	struct device *pdev;
+	int irq;
+	struct input_dev *input;
+	struct work_struct work;
+	struct timer_list timer;
+	struct mutex mutex;
+	char phys[32];
+	struct cyttsp_platform_data *platform_data;
+	struct cyttsp_bootloader_data bl_data;
+	struct cyttsp_sysinfo_data sysinfo_data;
+	u8 num_prv_st_tch;
+	u16 act_trk[CY_NUM_TRK_ID];
+	u16 prv_mt_tch[CY_NUM_MT_TCH_ID];
+	u16 prv_st_tch[CY_NUM_ST_TCH_ID];
+	u16 prv_mt_pos[CY_NUM_TRK_ID][2];
+	struct cyttsp_bus_ops *bus_ops;
+	unsigned fw_loader_mode:1;
+	unsigned suspended:1;
+};
+
+struct cyttsp_track_data {
+	u8 prv_tch;
+	u8 cur_tch;
+	u16 tmp_trk[CY_NUM_MT_TCH_ID];
+	u16 snd_trk[CY_NUM_MT_TCH_ID];
+	u16 cur_trk[CY_NUM_TRK_ID];
+	u16 cur_st_tch[CY_NUM_ST_TCH_ID];
+	u16 cur_mt_tch[CY_NUM_MT_TCH_ID];
+	/* if NOT CY_USE_TRACKING_ID then only */
+	/* uses CY_NUM_MT_TCH_ID positions */
+	u16 cur_mt_pos[CY_NUM_TRK_ID][2];
+	/* if NOT CY_USE_TRACKING_ID then only */
+	/* uses CY_NUM_MT_TCH_ID positions */
+	u8 cur_mt_z[CY_NUM_TRK_ID];
+	u8 tool_width;
+	u16 st_x1;
+	u16 st_y1;
+	u8 st_z1;
+	u16 st_x2;
+	u16 st_y2;
+	u8 st_z2;
+};
+
+static const u8 bl_cmd[] = {
+	CY_BL_FILE0, CY_BL_CMD, CY_BL_EXIT,
+	CY_BL_KEY0, CY_BL_KEY1, CY_BL_KEY2,
+	CY_BL_KEY3, CY_BL_KEY4, CY_BL_KEY5,
+	CY_BL_KEY6, CY_BL_KEY7
+};
+
+#define LOCK(m) do { \
+	DBG(printk(KERN_INFO "%s: lock\n", __func__);) \
+	mutex_lock(&(m)); \
+} while (0);
+
+#define UNLOCK(m) do { \
+	DBG(printk(KERN_INFO "%s: unlock\n", __func__);) \
+	mutex_unlock(&(m)); \
+} while (0);
+
+DBG(
+static void print_data_block(const char *func, u8 command,
+			u8 length, void *data)
+{
+	char buf[1024];
+	unsigned buf_len = sizeof(buf);
+	char *p = buf;
+	int i;
+	int l;
+
+	l = snprintf(p, buf_len, "cmd 0x%x: ", command);
+	buf_len -= l;
+	p += l;
+	for (i = 0; i < length && buf_len; i++, p += l, buf_len -= l)
+		l = snprintf(p, buf_len, "%02x ", *((char *)data + i));
+	printk(KERN_DEBUG "%s: %s\n", func, buf);
+})
+
+static u8 ttsp_convert_gen2(u8 cur_tch, struct cyttsp_xydata *pxy_data)
+{
+	struct cyttsp_xydata_gen2 *pxy_data_gen2;
+	pxy_data_gen2 = (struct cyttsp_xydata_gen2 *)(pxy_data);
+
+	if (pxy_data_gen2->evnt_idx == CY_GEN2_NOTOUCH) {
+		cur_tch = 0;
+	} else if (cur_tch == CY_GEN2_GHOST) {
+		cur_tch = 0;
+	} else if (cur_tch == CY_GEN2_2TOUCH) {
+		/* stuff artificial track ID1 and ID2 */
+		pxy_data->touch12_id = 0x12;
+		pxy_data->z1 = CY_MAXZ;
+		pxy_data->z2 = CY_MAXZ;
+		cur_tch--; /* 2 touches */
+	} else if (cur_tch == CY_GEN2_1TOUCH) {
+		/* stuff artificial track ID1 and ID2 */
+		pxy_data->touch12_id = 0x12;
+		pxy_data->z1 = CY_MAXZ;
+		pxy_data->z2 = CY_NTCH;
+		if (pxy_data_gen2->evnt_idx == CY_GEN2_TOUCH2) {
+			/* push touch 2 data into touch1
+			 * (first finger up; second finger down) */
+			/* stuff artificial track ID1 for touch2 info */
+			pxy_data->touch12_id = 0x20;
+			/* stuff touch 1 with touch 2 coordinate data */
+			pxy_data->x1 = pxy_data->x2;
+			pxy_data->y1 = pxy_data->y2;
+		}
+	} else {
+		cur_tch = 0;
+	}
+	return cur_tch;
+}
+
+static int ttsp_read_block_data(struct cyttsp *ts, u8 command,
+	u8 length, void *buf)
+{
+	int rc;
+	int tries;
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+
+	if (!buf || !length) {
+		printk(KERN_ERR "%s: Error, buf:%s len:%u\n",
+				__func__, !buf ? "NULL" : "OK", length);
+		return -EIO;
+	}
+
+	for (tries = 0, rc = 1; tries < CY_NUM_RETRY && rc; tries++)
+		rc = ts->bus_ops->read(ts->bus_ops, command, length, buf);
+
+	if (rc < 0)
+		printk(KERN_ERR "%s: error %d\n", __func__, rc);
+	DBG(print_data_block(__func__, command, length, buf);)
+	return rc;
+}
+
+static int ttsp_write_block_data(struct cyttsp *ts, u8 command,
+	u8 length, void *buf)
+{
+	int rc;
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+
+	if (!buf || !length) {
+		printk(KERN_ERR "%s: Error, buf:%s len:%u\n",
+				__func__, !buf ? "NULL" : "OK", length);
+		return -EIO;
+	}
+	rc = ts->bus_ops->write(ts->bus_ops, command, length, buf);
+	if (rc < 0)
+		printk(KERN_ERR "%s: error %d\n", __func__, rc);
+	DBG(print_data_block(__func__, command, length, buf);)
+	return rc;
+}
+
+static int ttsp_tch_ext(struct cyttsp *ts, void *buf)
+{
+	int rc;
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+
+	if (!buf) {
+		printk(KERN_ERR "%s: Error, buf:%s\n",
+				__func__, !buf ? "NULL" : "OK");
+		return -EIO;
+	}
+	rc = ts->bus_ops->ext(ts->bus_ops, buf);
+	if (rc < 0)
+		printk(KERN_ERR "%s: error %d\n", __func__, rc);
+	return rc;
+}
+
+static bool cyttsp_inlist(u16 prev_track[], u8 cur_trk_id, u8 *prev_loc,
+	u8 num_touches)
+{
+	u8 id = 0;
+
+	DBG(printk(KERN_INFO"%s: IN p[%d]=%d c=%d n=%d loc=%d\n",
+		__func__, id, prev_track[id], cur_trk_id,
+		num_touches, *prev_loc);)
+
+	for (*prev_loc = CY_IGNR_TCH; id < num_touches; id++) {
+		DBG(printk(KERN_INFO"%s: p[%d]=%d c=%d n=%d loc=%d\n",
+			__func__, id, prev_track[id], cur_trk_id,
+				num_touches, *prev_loc);)
+		if (prev_track[id] == cur_trk_id) {
+			*prev_loc = id;
+			break;
+		}
+	}
+	DBG(printk(KERN_INFO"%s: OUT p[%d]=%d c=%d n=%d loc=%d\n", __func__,
+		id, prev_track[id], cur_trk_id, num_touches, *prev_loc);)
+
+	return *prev_loc < CY_NUM_TRK_ID;
+}
+
+static bool cyttsp_next_avail_inlist(u16 cur_trk[], u8 *new_loc,
+	u8 num_touches)
+{
+	u8 id = 0;
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+
+	for (*new_loc = CY_IGNR_TCH; id < num_touches; id++) {
+		if (cur_trk[id] > CY_NUM_TRK_ID) {
+			*new_loc = id;
+			break;
+		}
+	}
+	return *new_loc < CY_NUM_TRK_ID;
+}
+
+/* ************************************************************************
+ * The cyttsp_xy_worker function reads the XY coordinates and sends them to
+ * the input layer.  It is scheduled from the interrupt (or timer).
+ * *************************************************************************/
+void handle_single_touch(struct cyttsp_xydata *xy, struct cyttsp_track_data *t,
+			 struct cyttsp *ts)
+{
+	u8 id;
+	u8 use_trk_id = ts->platform_data->use_trk_id;
+
+	DBG(printk(KERN_INFO"%s: ST STEP 0 - ST1 ID=%d  ST2 ID=%d\n",
+		__func__, t->cur_st_tch[CY_ST_FNGR1_IDX],
+		t->cur_st_tch[CY_ST_FNGR2_IDX]);)
+
+	if (t->cur_st_tch[CY_ST_FNGR1_IDX] > CY_NUM_TRK_ID) {
+		/* reassign finger 1 and 2 positions to new tracks */
+		if (t->cur_tch > 0) {
+			/* reassign st finger1 */
+			if (use_trk_id) {
+				id = CY_MT_TCH1_IDX;
+				t->cur_st_tch[CY_ST_FNGR1_IDX] =
+							t->cur_mt_tch[id];
+			} else {
+				id = GET_TOUCH1_ID(xy->touch12_id);
+				t->cur_st_tch[CY_ST_FNGR1_IDX] = id;
+			}
+			t->st_x1 = t->cur_mt_pos[id][CY_XPOS];
+			t->st_y1 = t->cur_mt_pos[id][CY_YPOS];
+			t->st_z1 = t->cur_mt_z[id];
+
+			DBG(printk(KERN_INFO"%s: ST STEP 1 - ST1 ID=%3d\n",
+				__func__, t->cur_st_tch[CY_ST_FNGR1_IDX]);)
+
+			if ((t->cur_tch > 1) &&
+				(t->cur_st_tch[CY_ST_FNGR2_IDX] >
+				CY_NUM_TRK_ID)) {
+				/* reassign st finger2 */
+				if (use_trk_id) {
+					id = CY_MT_TCH2_IDX;
+					t->cur_st_tch[CY_ST_FNGR2_IDX] =
+						t->cur_mt_tch[id];
+				} else {
+					id = GET_TOUCH2_ID(xy->touch12_id);
+					t->cur_st_tch[CY_ST_FNGR2_IDX] = id;
+				}
+				t->st_x2 = t->cur_mt_pos[id][CY_XPOS];
+				t->st_y2 = t->cur_mt_pos[id][CY_YPOS];
+				t->st_z2 = t->cur_mt_z[id];
+
+				DBG(
+				printk(KERN_INFO"%s: ST STEP 2 - ST2 ID=%3d\n",
+				__func__, t->cur_st_tch[CY_ST_FNGR2_IDX]);)
+			}
+		}
+	} else if (t->cur_st_tch[CY_ST_FNGR2_IDX] > CY_NUM_TRK_ID) {
+		if (t->cur_tch > 1) {
+			/* reassign st finger2 */
+			if (use_trk_id) {
+				/* reassign st finger2 */
+				id = CY_MT_TCH2_IDX;
+				t->cur_st_tch[CY_ST_FNGR2_IDX] =
+							t->cur_mt_tch[id];
+			} else {
+				/* reassign st finger2 */
+				id = GET_TOUCH2_ID(xy->touch12_id);
+				t->cur_st_tch[CY_ST_FNGR2_IDX] = id;
+			}
+			t->st_x2 = t->cur_mt_pos[id][CY_XPOS];
+			t->st_y2 = t->cur_mt_pos[id][CY_YPOS];
+			t->st_z2 = t->cur_mt_z[id];
+
+			DBG(printk(KERN_INFO"%s: ST STEP 3 - ST2 ID=%3d\n",
+				   __func__, t->cur_st_tch[CY_ST_FNGR2_IDX]);)
+		}
+	}
+	/* if the 1st touch is missing and there is a 2nd touch,
+	 * then set the 1st touch to 2nd touch and terminate 2nd touch
+	 */
+	if ((t->cur_st_tch[CY_ST_FNGR1_IDX] > CY_NUM_TRK_ID) &&
+			(t->cur_st_tch[CY_ST_FNGR2_IDX] < CY_NUM_TRK_ID)) {
+		t->st_x1 = t->st_x2;
+		t->st_y1 = t->st_y2;
+		t->st_z1 = t->st_z2;
+		t->cur_st_tch[CY_ST_FNGR1_IDX] = t->cur_st_tch[CY_ST_FNGR2_IDX];
+		t->cur_st_tch[CY_ST_FNGR2_IDX] = CY_IGNR_TCH;
+	}
+	/* if the 2nd touch ends up equal to the 1st touch,
+	 * then just report a single touch */
+	if (t->cur_st_tch[CY_ST_FNGR1_IDX] == t->cur_st_tch[CY_ST_FNGR2_IDX])
+		t->cur_st_tch[CY_ST_FNGR2_IDX] = CY_IGNR_TCH;
+
+	/* set Single Touch current event signals */
+	if (t->cur_st_tch[CY_ST_FNGR1_IDX] < CY_NUM_TRK_ID) {
+		input_report_abs(ts->input, ABS_X, t->st_x1);
+		input_report_abs(ts->input, ABS_Y, t->st_y1);
+		input_report_abs(ts->input, ABS_PRESSURE, t->st_z1);
+		input_report_key(ts->input, BTN_TOUCH, CY_TCH);
+		input_report_abs(ts->input, ABS_TOOL_WIDTH, t->tool_width);
+
+		DBG(printk(KERN_INFO"%s:ST->F1:%3d X:%3d Y:%3d Z:%3d\n",
+			   __func__, t->cur_st_tch[CY_ST_FNGR1_IDX],
+			   t->st_x1, t->st_y1, t->st_z1);)
+
+		if (t->cur_st_tch[CY_ST_FNGR2_IDX] < CY_NUM_TRK_ID) {
+			input_report_key(ts->input, BTN_2, CY_TCH);
+			input_report_abs(ts->input, ABS_HAT0X, t->st_x2);
+			input_report_abs(ts->input, ABS_HAT0Y, t->st_y2);
+
+			DBG(printk(KERN_INFO"%s:ST->F2:%3d X:%3d Y:%3d Z:%3d\n",
+				__func__, t->cur_st_tch[CY_ST_FNGR2_IDX],
+				t->st_x2, t->st_y2, t->st_z2);)
+		} else {
+			input_report_key(ts->input, BTN_2, CY_NTCH);
+		}
+	} else {
+		input_report_abs(ts->input, ABS_PRESSURE, CY_NTCH);
+		input_report_key(ts->input, BTN_TOUCH, CY_NTCH);
+		input_report_key(ts->input, BTN_2, CY_NTCH);
+	}
+	/* update platform data for the current single touch info */
+	ts->prv_st_tch[CY_ST_FNGR1_IDX] = t->cur_st_tch[CY_ST_FNGR1_IDX];
+	ts->prv_st_tch[CY_ST_FNGR2_IDX] = t->cur_st_tch[CY_ST_FNGR2_IDX];
+
+}
+
+void handle_multi_touch(struct cyttsp_track_data *t, struct cyttsp *ts)
+{
+
+	u8 id;
+	u8 i, loc;
+	void (*mt_sync_func)(struct input_dev *) = ts->platform_data->mt_sync;
+
+	if (!ts->platform_data->use_trk_id)
+		goto no_track_id;
+
+	/* terminate any previous touch where the track
+	 * is missing from the current event */
+	for (id = 0; id < CY_NUM_TRK_ID; id++) {
+		if ((ts->act_trk[id] == CY_NTCH) || (t->cur_trk[id] != CY_NTCH))
+			continue;
+
+		input_report_abs(ts->input, ABS_MT_TRACKING_ID, id);
+		input_report_abs(ts->input, ABS_MT_TOUCH_MAJOR, CY_NTCH);
+		input_report_abs(ts->input, ABS_MT_WIDTH_MAJOR, t->tool_width);
+		input_report_abs(ts->input, ABS_MT_POSITION_X,
+					ts->prv_mt_pos[id][CY_XPOS]);
+		input_report_abs(ts->input, ABS_MT_POSITION_Y,
+					ts->prv_mt_pos[id][CY_YPOS]);
+		if (mt_sync_func)
+			mt_sync_func(ts->input);
+		ts->act_trk[id] = CY_NTCH;
+		ts->prv_mt_pos[id][CY_XPOS] = 0;
+		ts->prv_mt_pos[id][CY_YPOS] = 0;
+	}
+	/* set Multi-Touch current event signals */
+	for (id = 0; id < CY_NUM_MT_TCH_ID; id++) {
+		if (t->cur_mt_tch[id] >= CY_NUM_TRK_ID)
+			continue;
+
+		input_report_abs(ts->input, ABS_MT_TRACKING_ID,
+						t->cur_mt_tch[id]);
+		input_report_abs(ts->input, ABS_MT_TOUCH_MAJOR,
+						t->cur_mt_z[id]);
+		input_report_abs(ts->input, ABS_MT_WIDTH_MAJOR,
+						t->tool_width);
+		input_report_abs(ts->input, ABS_MT_POSITION_X,
+						t->cur_mt_pos[id][CY_XPOS]);
+		input_report_abs(ts->input, ABS_MT_POSITION_Y,
+						t->cur_mt_pos[id][CY_YPOS]);
+		if (mt_sync_func)
+			mt_sync_func(ts->input);
+
+		ts->act_trk[id] = CY_TCH;
+		ts->prv_mt_pos[id][CY_XPOS] = t->cur_mt_pos[id][CY_XPOS];
+		ts->prv_mt_pos[id][CY_YPOS] = t->cur_mt_pos[id][CY_YPOS];
+	}
+	return;
+no_track_id:
+
+	/* set temporary track array elements to voids */
+	memset(t->tmp_trk, CY_IGNR_TCH, sizeof(t->tmp_trk));
+	memset(t->snd_trk, CY_IGNR_TCH, sizeof(t->snd_trk));
+
+	/* get what is currently active */
+	for (i = id = 0; id < CY_NUM_TRK_ID && i < CY_NUM_MT_TCH_ID; id++) {
+		if (t->cur_trk[id] == CY_TCH) {
+			/* only incr counter if track found */
+			t->tmp_trk[i] = id;
+			i++;
+		}
+	}
+	DBG(printk(KERN_INFO"%s: T1: t0=%d, t1=%d, t2=%d, t3=%d\n", __func__,
+					t->tmp_trk[0], t->tmp_trk[1],
+					t->tmp_trk[2], t->tmp_trk[3]);)
+	DBG(printk(KERN_INFO"%s: T1: p0=%d, p1=%d, p2=%d, p3=%d\n", __func__,
+					ts->prv_mt_tch[0], ts->prv_mt_tch[1],
+					ts->prv_mt_tch[2], ts->prv_mt_tch[3]);)
+
+	/* pack in still active previous touches */
+	for (id = t->prv_tch = 0; id < CY_NUM_MT_TCH_ID; id++) {
+		if (t->tmp_trk[id] >= CY_NUM_TRK_ID)
+			continue;
+
+		if (cyttsp_inlist(ts->prv_mt_tch, t->tmp_trk[id], &loc,
+							CY_NUM_MT_TCH_ID)) {
+			loc &= CY_NUM_MT_TCH_ID - 1;
+			t->snd_trk[loc] = t->tmp_trk[id];
+			t->prv_tch++;
+			DBG(printk(KERN_INFO"%s: in list s[%d]=%d "
+					"t[%d]=%d, loc=%d p=%d\n", __func__,
+					loc, t->snd_trk[loc],
+					id, t->tmp_trk[id],
+					loc, t->prv_tch);)
+		} else {
+			DBG(printk(KERN_INFO"%s: is not in list s[%d]=%d"
+					" t[%d]=%d loc=%d\n", __func__,
+					id, t->snd_trk[id],
+					id, t->tmp_trk[id],
+					loc);)
+		}
+	}
+	DBG(printk(KERN_INFO"%s: S1: s0=%d, s1=%d, s2=%d, s3=%d p=%d\n",
+		   __func__,
+		   t->snd_trk[0], t->snd_trk[1], t->snd_trk[2],
+		   t->snd_trk[3], t->prv_tch);)
+
+	/* pack in new touches */
+	for (id = 0; id < CY_NUM_MT_TCH_ID; id++) {
+		if (t->tmp_trk[id] >= CY_NUM_TRK_ID)
+			continue;
+
+		if (!cyttsp_inlist(t->snd_trk, t->tmp_trk[id], &loc,
+							CY_NUM_MT_TCH_ID)) {
+
+			DBG(
+			printk(KERN_INFO"%s: not in list t[%d]=%d, loc=%d\n",
+				   __func__,
+				   id, t->tmp_trk[id], loc);)
+
+			if (cyttsp_next_avail_inlist(t->snd_trk, &loc,
+							CY_NUM_MT_TCH_ID)) {
+				loc &= CY_NUM_MT_TCH_ID - 1;
+				t->snd_trk[loc] = t->tmp_trk[id];
+				DBG(printk(KERN_INFO "%s: put in list s[%d]=%d"
+					" t[%d]=%d\n", __func__,
+					loc,
+					t->snd_trk[loc], id, t->tmp_trk[id]);
+				    )
+			}
+		} else {
+			DBG(printk(KERN_INFO"%s: is in list s[%d]=%d "
+				"t[%d]=%d loc=%d\n", __func__,
+				id, t->snd_trk[id], id, t->tmp_trk[id], loc);)
+		}
+	}
+	DBG(printk(KERN_INFO"%s: S2: s0=%d, s1=%d, s2=%d, s3=%d\n", __func__,
+			t->snd_trk[0], t->snd_trk[1],
+			t->snd_trk[2], t->snd_trk[3]);)
+
+	/* sync motion event signals for each current touch */
+	for (id = 0; id < CY_NUM_MT_TCH_ID; id++) {
+		/* z will either be 0 (NOTOUCH) or
+		 * some pressure (TOUCH)
+		 */
+		DBG(printk(KERN_INFO "%s: MT0 prev[%d]=%d "
+				"temp[%d]=%d send[%d]=%d\n",
+				__func__, id, ts->prv_mt_tch[id],
+				id, t->tmp_trk[id], id, t->snd_trk[id]);)
+
+		if (t->snd_trk[id] < CY_NUM_TRK_ID) {
+			input_report_abs(ts->input, ABS_MT_TOUCH_MAJOR,
+					t->cur_mt_z[t->snd_trk[id]]);
+			input_report_abs(ts->input, ABS_MT_WIDTH_MAJOR,
+					t->tool_width);
+			input_report_abs(ts->input, ABS_MT_POSITION_X,
+					t->cur_mt_pos[t->snd_trk[id]][CY_XPOS]);
+			input_report_abs(ts->input, ABS_MT_POSITION_Y,
+					t->cur_mt_pos[t->snd_trk[id]][CY_YPOS]);
+			if (mt_sync_func)
+				mt_sync_func(ts->input);
+
+			DBG(printk(KERN_INFO"%s: MT1 -> TID:"
+				"%3d X:%3d  Y:%3d  Z:%3d\n", __func__,
+				t->snd_trk[id],
+				t->cur_mt_pos[t->snd_trk[id]][CY_XPOS],
+				t->cur_mt_pos[t->snd_trk[id]][CY_YPOS],
+				t->cur_mt_z[t->snd_trk[id]]);)
+
+		} else if (ts->prv_mt_tch[id] < CY_NUM_TRK_ID) {
+			/* void out this touch */
+			input_report_abs(ts->input, ABS_MT_TOUCH_MAJOR,
+							CY_NTCH);
+			input_report_abs(ts->input, ABS_MT_WIDTH_MAJOR,
+							t->tool_width);
+			input_report_abs(ts->input, ABS_MT_POSITION_X,
+				ts->prv_mt_pos[ts->prv_mt_tch[id]][CY_XPOS]);
+			input_report_abs(ts->input, ABS_MT_POSITION_Y,
+				ts->prv_mt_pos[ts->prv_mt_tch[id]][CY_YPOS]);
+
+			if (mt_sync_func)
+				mt_sync_func(ts->input);
+
+			DBG(printk(KERN_INFO"%s: "
+				"MT2->TID:%2d X:%3d Y:%3d Z:%3d liftoff-sent\n",
+				__func__, ts->prv_mt_tch[id],
+				ts->prv_mt_pos[ts->prv_mt_tch[id]][CY_XPOS],
+				ts->prv_mt_pos[ts->prv_mt_tch[id]][CY_YPOS],
+				CY_NTCH);)
+		} else {
+			/* do not stuff any signals for this
+			 * previously and currently void touches
+			 */
+			DBG(printk(KERN_INFO"%s: "
+				"MT3->send[%d]=%d - No touch - NOT sent\n",
+				__func__, id, t->snd_trk[id]);)
+		}
+	}
+
+	/* save current posted tracks to
+	 * previous track memory */
+	for (id = 0; id < CY_NUM_MT_TCH_ID; id++) {
+		ts->prv_mt_tch[id] = t->snd_trk[id];
+		if (t->snd_trk[id] < CY_NUM_TRK_ID) {
+			ts->prv_mt_pos[t->snd_trk[id]][CY_XPOS] =
+					t->cur_mt_pos[t->snd_trk[id]][CY_XPOS];
+			ts->prv_mt_pos[t->snd_trk[id]][CY_YPOS] =
+					t->cur_mt_pos[t->snd_trk[id]][CY_YPOS];
+			DBG(printk(KERN_INFO"%s: "
+				"MT4->TID:%2d X:%3d Y:%3d Z:%3d save for prv\n",
+				__func__, t->snd_trk[id],
+				ts->prv_mt_pos[t->snd_trk[id]][CY_XPOS],
+				ts->prv_mt_pos[t->snd_trk[id]][CY_YPOS],
+				CY_NTCH);)
+		}
+	}
+	memset(ts->act_trk, CY_NTCH, sizeof(ts->act_trk));
+	for (id = 0; id < CY_NUM_MT_TCH_ID; id++) {
+		if (t->snd_trk[id] < CY_NUM_TRK_ID)
+			ts->act_trk[t->snd_trk[id]] = CY_TCH;
+	}
+}
+
+void cyttsp_xy_worker(struct cyttsp *ts)
+{
+	struct cyttsp_xydata xy_data;
+	u8 id, tilt, rev_x, rev_y;
+	struct cyttsp_track_data trc;
+	s32 retval;
+
+	DBG(printk(KERN_INFO "%s: Enter\n", __func__);)
+	/* get event data from CYTTSP device */
+	retval = ttsp_read_block_data(ts, CY_REG_BASE,
+				      sizeof(xy_data), &xy_data);
+
+	if (retval < 0) {
+		printk(KERN_ERR "%s: Error, fail to read device on i2c bus\n",
+			__func__);
+		goto exit_xy_worker;
+	}
+
+	/* touch extension handling */
+	retval = ttsp_tch_ext(ts, &xy_data);
+
+	if (retval < 0) {
+		printk(KERN_ERR "%s: Error, touch extension handling\n",
+			__func__);
+		goto exit_xy_worker;
+	} else if (retval > 0) {
+		DBG(printk(KERN_INFO "%s: Touch extension handled\n",
+			__func__);)
+		goto exit_xy_worker;
+	}
+
+	/* provide flow control handshake */
+	if (ts->irq) {
+		if (ts->platform_data->use_hndshk) {
+			u8 cmd;
+			cmd = xy_data.hst_mode & CY_HNDSHK_BIT ?
+				xy_data.hst_mode & ~CY_HNDSHK_BIT :
+				xy_data.hst_mode | CY_HNDSHK_BIT;
+			retval = ttsp_write_block_data(ts, CY_REG_BASE,
+						       sizeof(cmd), (u8 *)&cmd);
+		}
+	}
+	trc.cur_tch = GET_NUM_TOUCHES(xy_data.tt_stat);
+	if (GET_HSTMODE(xy_data.hst_mode) != CY_OPERATE_MODE) {
+		/* terminate all active tracks */
+		trc.cur_tch = CY_NTCH;
+		DBG(printk(KERN_INFO "%s: Invalid mode detected\n",
+			__func__);)
+	} else if (IS_LARGE_AREA(xy_data.tt_stat) == 1) {
+		/* terminate all active tracks */
+		trc.cur_tch = CY_NTCH;
+		DBG(printk(KERN_INFO "%s: Large area detected\n",
+			__func__);)
+	} else if (trc.cur_tch > CY_NUM_MT_TCH_ID) {
+		/* terminate all active tracks */
+		trc.cur_tch = CY_NTCH;
+		DBG(printk(KERN_INFO "%s: Num touch error detected\n",
+			__func__);)
+	} else if (IS_BAD_PKT(xy_data.tt_mode)) {
+		/* terminate all active tracks */
+		trc.cur_tch = CY_NTCH;
+		DBG(printk(KERN_INFO "%s: Invalid buffer detected\n",
+			__func__);)
+	}
+
+	/* set tool size */
+	trc.tool_width = CY_SMALL_TOOL_WIDTH;
+
+	if (ts->platform_data->gen == CY_GEN2) {
+		/* translate Gen2 interface data into comparable Gen3 data */
+		trc.cur_tch = ttsp_convert_gen2(trc.cur_tch, &xy_data);
+	}
+
+	/* clear current active track ID array and count previous touches */
+	for (id = 0, trc.prv_tch = CY_NTCH; id < CY_NUM_TRK_ID; id++) {
+		trc.cur_trk[id] = CY_NTCH;
+		trc.prv_tch += ts->act_trk[id];
+	}
+
+	/* send no events if there were no previous touches */
+	/* and no new touches */
+	if ((trc.prv_tch == CY_NTCH) && ((trc.cur_tch == CY_NTCH) ||
+				(trc.cur_tch > CY_NUM_MT_TCH_ID)))
+		goto exit_xy_worker;
+
+	DBG(printk(KERN_INFO "%s: prev=%d  curr=%d\n", __func__,
+		   trc.prv_tch, trc.cur_tch);)
+
+	/* clear current single-touch array */
+	memset(trc.cur_st_tch, CY_IGNR_TCH, sizeof(trc.cur_st_tch));
+
+	/* clear single touch positions */
+	trc.st_x1 = trc.st_y1 = trc.st_z1 =
+			trc.st_x2 = trc.st_y2 = trc.st_z2 = CY_NTCH;
+
+	/* clear current multi-touch arrays */
+	memset(trc.cur_mt_tch, CY_IGNR_TCH, sizeof(trc.cur_mt_tch));
+	memset(trc.cur_mt_pos, CY_NTCH, sizeof(trc.cur_mt_pos));
+	memset(trc.cur_mt_z, CY_NTCH, sizeof(trc.cur_mt_z));
+
+	DBG(
+	if (trc.cur_tch) {
+		unsigned i;
+		u8 *pdata = (u8 *)&xy_data;
+
+		printk(KERN_INFO "%s: TTSP data_pack: ", __func__);
+		for (i = 0; i < sizeof(struct cyttsp_xydata); i++)
+			printk(KERN_INFO "[%d]=0x%x ", i, pdata[i]);
+		printk(KERN_INFO "\n");
+	})
+
+	/* Determine if display is tilted */
+	tilt = !!FLIP_DATA(ts->platform_data->flags);
+	/* Check for switch in origin */
+	rev_x = !!REVERSE_X(ts->platform_data->flags);
+	rev_y = !!REVERSE_Y(ts->platform_data->flags);
+
+	/* process the touches */
+	switch (trc.cur_tch) {
+	case 4:
+		xy_data.x4 = be16_to_cpu(xy_data.x4);
+		xy_data.y4 = be16_to_cpu(xy_data.y4);
+		if (tilt)
+			FLIP_XY(xy_data.x4, xy_data.y4);
+
+		if (rev_x)
+			xy_data.x4 = INVERT_X(xy_data.x4,
+					ts->platform_data->maxx);
+		if (rev_y)
+			xy_data.y4 = INVERT_X(xy_data.y4,
+					ts->platform_data->maxy);
+
+		id = GET_TOUCH4_ID(xy_data.touch34_id);
+		if (ts->platform_data->use_trk_id) {
+			trc.cur_mt_pos[CY_MT_TCH4_IDX][CY_XPOS] = xy_data.x4;
+			trc.cur_mt_pos[CY_MT_TCH4_IDX][CY_YPOS] = xy_data.y4;
+			trc.cur_mt_z[CY_MT_TCH4_IDX] = xy_data.z4;
+		} else {
+			trc.cur_mt_pos[id][CY_XPOS] = xy_data.x4;
+			trc.cur_mt_pos[id][CY_YPOS] = xy_data.y4;
+			trc.cur_mt_z[id] = xy_data.z4;
+		}
+		trc.cur_mt_tch[CY_MT_TCH4_IDX] = id;
+		trc.cur_trk[id] = CY_TCH;
+		if (ts->prv_st_tch[CY_ST_FNGR1_IDX] <	CY_NUM_TRK_ID) {
+			if (ts->prv_st_tch[CY_ST_FNGR1_IDX] == id) {
+				trc.st_x1 = xy_data.x4;
+				trc.st_y1 = xy_data.y4;
+				trc.st_z1 = xy_data.z4;
+				trc.cur_st_tch[CY_ST_FNGR1_IDX] = id;
+			} else if (ts->prv_st_tch[CY_ST_FNGR2_IDX] == id) {
+				trc.st_x2 = xy_data.x4;
+				trc.st_y2 = xy_data.y4;
+				trc.st_z2 = xy_data.z4;
+				trc.cur_st_tch[CY_ST_FNGR2_IDX] = id;
+			}
+		}
+		DBG(printk(KERN_INFO"%s: 4th XYZ:% 3d,% 3d,% 3d  ID:% 2d\n\n",
+				__func__, xy_data.x4, xy_data.y4, xy_data.z4,
+				(xy_data.touch34_id & 0x0F));)
+
+		/* do not break */
+	case 3:
+		xy_data.x3 = be16_to_cpu(xy_data.x3);
+		xy_data.y3 = be16_to_cpu(xy_data.y3);
+		if (tilt)
+			FLIP_XY(xy_data.x3, xy_data.y3);
+
+		if (rev_x)
+			xy_data.x3 = INVERT_X(xy_data.x3,
+					ts->platform_data->maxx);
+		if (rev_y)
+			xy_data.y3 = INVERT_X(xy_data.y3,
+					ts->platform_data->maxy);
+
+		id = GET_TOUCH3_ID(xy_data.touch34_id);
+		if (ts->platform_data->use_trk_id) {
+			trc.cur_mt_pos[CY_MT_TCH3_IDX][CY_XPOS] = xy_data.x3;
+			trc.cur_mt_pos[CY_MT_TCH3_IDX][CY_YPOS] = xy_data.y3;
+			trc.cur_mt_z[CY_MT_TCH3_IDX] = xy_data.z3;
+		} else {
+			trc.cur_mt_pos[id][CY_XPOS] = xy_data.x3;
+			trc.cur_mt_pos[id][CY_YPOS] = xy_data.y3;
+			trc.cur_mt_z[id] = xy_data.z3;
+		}
+		trc.cur_mt_tch[CY_MT_TCH3_IDX] = id;
+		trc.cur_trk[id] = CY_TCH;
+		if (ts->prv_st_tch[CY_ST_FNGR1_IDX] < CY_NUM_TRK_ID) {
+			if (ts->prv_st_tch[CY_ST_FNGR1_IDX] == id) {
+				trc.st_x1 = xy_data.x3;
+				trc.st_y1 = xy_data.y3;
+				trc.st_z1 = xy_data.z3;
+				trc.cur_st_tch[CY_ST_FNGR1_IDX] = id;
+			} else if (ts->prv_st_tch[CY_ST_FNGR2_IDX] == id) {
+				trc.st_x2 = xy_data.x3;
+				trc.st_y2 = xy_data.y3;
+				trc.st_z2 = xy_data.z3;
+				trc.cur_st_tch[CY_ST_FNGR2_IDX] = id;
+			}
+		}
+		DBG(printk(KERN_INFO"%s: 3rd XYZ:% 3d,% 3d,% 3d  ID:% 2d\n",
+			__func__, xy_data.x3, xy_data.y3, xy_data.z3,
+			((xy_data.touch34_id >> 4) & 0x0F));)
+
+		/* do not break */
+	case 2:
+		xy_data.x2 = be16_to_cpu(xy_data.x2);
+		xy_data.y2 = be16_to_cpu(xy_data.y2);
+		if (tilt)
+			FLIP_XY(xy_data.x2, xy_data.y2);
+
+		if (rev_x)
+			xy_data.x2 = INVERT_X(xy_data.x2,
+					ts->platform_data->maxx);
+		if (rev_y)
+			xy_data.y2 = INVERT_X(xy_data.y2,
+					ts->platform_data->maxy);
+		id = GET_TOUCH2_ID(xy_data.touch12_id);
+		if (ts->platform_data->use_trk_id) {
+			trc.cur_mt_pos[CY_MT_TCH2_IDX][CY_XPOS] = xy_data.x2;
+			trc.cur_mt_pos[CY_MT_TCH2_IDX][CY_YPOS] = xy_data.y2;
+			trc.cur_mt_z[CY_MT_TCH2_IDX] = xy_data.z2;
+		} else {
+			trc.cur_mt_pos[id][CY_XPOS] = xy_data.x2;
+			trc.cur_mt_pos[id][CY_YPOS] = xy_data.y2;
+			trc.cur_mt_z[id] = xy_data.z2;
+		}
+		trc.cur_mt_tch[CY_MT_TCH2_IDX] = id;
+		trc.cur_trk[id] = CY_TCH;
+		if (ts->prv_st_tch[CY_ST_FNGR1_IDX] <	CY_NUM_TRK_ID) {
+			if (ts->prv_st_tch[CY_ST_FNGR1_IDX] == id) {
+				trc.st_x1 = xy_data.x2;
+				trc.st_y1 = xy_data.y2;
+				trc.st_z1 = xy_data.z2;
+				trc.cur_st_tch[CY_ST_FNGR1_IDX] = id;
+			} else if (ts->prv_st_tch[CY_ST_FNGR2_IDX] == id) {
+				trc.st_x2 = xy_data.x2;
+				trc.st_y2 = xy_data.y2;
+				trc.st_z2 = xy_data.z2;
+				trc.cur_st_tch[CY_ST_FNGR2_IDX] = id;
+			}
+		}
+		DBG(printk(KERN_INFO"%s: 2nd XYZ:% 3d,% 3d,% 3d  ID:% 2d\n",
+				__func__, xy_data.x2, xy_data.y2, xy_data.z2,
+				(xy_data.touch12_id & 0x0F));)
+
+		/* do not break */
+	case 1:
+		xy_data.x1 = be16_to_cpu(xy_data.x1);
+		xy_data.y1 = be16_to_cpu(xy_data.y1);
+		if (tilt)
+			FLIP_XY(xy_data.x1, xy_data.y1);
+
+		if (rev_x)
+			xy_data.x1 = INVERT_X(xy_data.x1,
+					ts->platform_data->maxx);
+		if (rev_y)
+			xy_data.y1 = INVERT_X(xy_data.y1,
+					ts->platform_data->maxy);
+
+		id = GET_TOUCH1_ID(xy_data.touch12_id);
+		if (ts->platform_data->use_trk_id) {
+			trc.cur_mt_pos[CY_MT_TCH1_IDX][CY_XPOS] = xy_data.x1;
+			trc.cur_mt_pos[CY_MT_TCH1_IDX][CY_YPOS] = xy_data.y1;
+			trc.cur_mt_z[CY_MT_TCH1_IDX] = xy_data.z1;
+		} else {
+			trc.cur_mt_pos[id][CY_XPOS] = xy_data.x1;
+			trc.cur_mt_pos[id][CY_YPOS] = xy_data.y1;
+			trc.cur_mt_z[id] = xy_data.z1;
+		}
+		trc.cur_mt_tch[CY_MT_TCH1_IDX] = id;
+		trc.cur_trk[id] = CY_TCH;
+		if (ts->prv_st_tch[CY_ST_FNGR1_IDX] <	CY_NUM_TRK_ID) {
+			if (ts->prv_st_tch[CY_ST_FNGR1_IDX] == id) {
+				trc.st_x1 = xy_data.x1;
+				trc.st_y1 = xy_data.y1;
+				trc.st_z1 = xy_data.z1;
+				trc.cur_st_tch[CY_ST_FNGR1_IDX] = id;
+			} else if (ts->prv_st_tch[CY_ST_FNGR2_IDX] == id) {
+				trc.st_x2 = xy_data.x1;
+				trc.st_y2 = xy_data.y1;
+				trc.st_z2 = xy_data.z1;
+				trc.cur_st_tch[CY_ST_FNGR2_IDX] = id;
+			}
+		}
+		DBG(printk(KERN_INFO"%s: S1st XYZ:% 3d,% 3d,% 3d  ID:% 2d\n",
+				__func__, xy_data.x1, xy_data.y1, xy_data.z1,
+				((xy_data.touch12_id >> 4) & 0x0F));)
+
+		break;
+	case 0:
+	default:
+		break;
+	}
+
+	if (ts->platform_data->use_st)
+		handle_single_touch(&xy_data, &trc, ts);
+
+	if (ts->platform_data->use_mt)
+		handle_multi_touch(&trc, ts);
+
+	/* handle gestures */
+	if (ts->platform_data->use_gestures && xy_data.gest_id) {
+		input_report_key(ts->input, BTN_3, CY_TCH);
+		input_report_abs(ts->input, ABS_HAT1X, xy_data.gest_id);
+		input_report_abs(ts->input, ABS_HAT2Y, xy_data.gest_cnt);
+	}
+
+	/* signal the view motion event */
+	input_sync(ts->input);
+
+	/* update platform data for the current multi-touch information */
+	memcpy(ts->act_trk, trc.cur_trk, CY_NUM_TRK_ID);
+
+exit_xy_worker:
+	DBG(printk(KERN_INFO"%s: finished.\n", __func__);)
+	return;
+}
+
+/* ************************************************************************
+ * ISR function. This function is general, initialized in drivers init
+ * function and disables further IRQs until this IRQ is processed in worker.
+ * *************************************************************************/
+static irqreturn_t cyttsp_irq(int irq, void *handle)
+{
+	struct cyttsp *ts = (struct cyttsp *)handle;
+
+	DBG(printk(KERN_INFO"%s: Got IRQ!\n", __func__);)
+	cyttsp_xy_worker(ts);
+	return IRQ_HANDLED;
+}
+
+/* schedulable worker entry for timer polling method */
+void cyttsp_xy_worker_(struct work_struct *work)
+{
+	struct cyttsp *ts = container_of(work, struct cyttsp, work);
+	cyttsp_xy_worker(ts);
+}
+
+/* Timer function used as touch interrupt generator for polling method */
+static void cyttsp_timer(unsigned long handle)
+{
+	struct cyttsp *ts = (struct cyttsp *)handle;
+
+	DBG(printk(KERN_INFO"%s: TTSP timer event!\n", __func__);)
+	/* schedule motion signal handling */
+	if (!work_pending(&ts->work))
+		schedule_work(&ts->work);
+	mod_timer(&ts->timer, jiffies + TOUCHSCREEN_TIMEOUT);
+	return;
+}
+
+
+/* ************************************************************************
+ * Probe initialization functions
+ * ************************************************************************ */
+static int cyttsp_load_bl_regs(struct cyttsp *ts)
+{
+	int retval;
+
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+
+	retval =  ttsp_read_block_data(ts, CY_REG_BASE,
+				sizeof(ts->bl_data), &(ts->bl_data));
+
+	if (retval < 0) {
+		DBG(printk(KERN_INFO "%s: Failed reading block data, err:%d\n",
+			__func__, retval);)
+		goto fail;
+	}
+
+	DBG({
+	      int i;
+	      u8 *bl_data = (u8 *)&(ts->bl_data);
+	      for (i = 0; i < sizeof(struct cyttsp_bootloader_data); i++)
+			printk(KERN_INFO "%s bl_data[%d]=0x%x\n",
+				__func__, i, bl_data[i]);
+	})
+
+	return 0;
+fail:
+	return retval;
+}
+
+static int cyttsp_exit_bl_mode(struct cyttsp *ts)
+{
+	int retval;
+	int tries = 0;
+
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+
+	retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(bl_cmd),
+				       (void *)bl_cmd);
+	if (retval < 0) {
+		printk(KERN_ERR "%s: Failed writing block data, err:%d\n",
+			__func__, retval);
+		goto fail;
+	}
+	do {
+		msleep(500);
+		cyttsp_load_bl_regs(ts);
+	} while (GET_BOOTLOADERMODE(ts->bl_data.bl_status) && tries++ < 10);
+	return 0;
+fail:
+	return retval;
+}
+
+static int cyttsp_set_sysinfo_mode(struct cyttsp *ts)
+{
+	int retval;
+	u8 cmd = CY_SYSINFO_MODE;
+
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+
+	retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd), &cmd);
+	/* wait for TTSP Device to complete switch to SysInfo mode */
+	msleep(500);
+	if (retval < 0) {
+		printk(KERN_ERR "%s: Failed writing block data, err:%d\n",
+			__func__, retval);
+		goto write_block_data_fail;
+	}
+	retval = ttsp_read_block_data(ts, CY_REG_BASE, sizeof(ts->sysinfo_data),
+			&(ts->sysinfo_data));
+
+	if (retval < 0) {
+		printk(KERN_ERR "%s: Failed reading block data, err:%d\n",
+			__func__, retval);
+		goto read_block_data_fail;
+	}
+
+	DBG(printk(KERN_INFO"%s:SI2: hst_mode=0x%02X mfg_cmd=0x%02X "
+		"mfg_stat=0x%02X\n", __func__, ts->sysinfo_data.hst_mode,
+		ts->sysinfo_data.mfg_cmd,
+		ts->sysinfo_data.mfg_stat);)
+
+	DBG(printk(KERN_INFO"%s:SI2: bl_ver=0x%02X%02X\n",
+		__func__, ts->sysinfo_data.bl_verh, ts->sysinfo_data.bl_verl);)
+
+	DBG(printk(KERN_INFO"%s:SI2: sysinfo act_intrvl=0x%02X "
+		"tch_tmout=0x%02X lp_intrvl=0x%02X\n",
+		__func__, ts->sysinfo_data.act_intrvl,
+		ts->sysinfo_data.tch_tmout,
+		ts->sysinfo_data.lp_intrvl);)
+
+	printk(KERN_INFO"%s:SI2:tts_ver=0x%02X%02X app_id=0x%02X%02X "
+		"app_ver=0x%02X%02X c_id=0x%02X%02X%02X\n", __func__,
+		ts->sysinfo_data.tts_verh, ts->sysinfo_data.tts_verl,
+		ts->sysinfo_data.app_idh, ts->sysinfo_data.app_idl,
+		ts->sysinfo_data.app_verh, ts->sysinfo_data.app_verl,
+		ts->sysinfo_data.cid[0], ts->sysinfo_data.cid[1],
+		ts->sysinfo_data.cid[2]);
+	return 0;
+
+write_block_data_fail:
+read_block_data_fail:
+	return retval;
+}
+
+static int cyttsp_set_operational_mode(struct cyttsp *ts)
+{
+	int retval;
+	u8 cmd = CY_OPERATE_MODE;
+
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+
+	retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd), &cmd);
+	if (retval < 0) {
+		printk(KERN_ERR "%s: Failed writing block data, err:%d\n",
+			__func__, retval);
+		goto write_block_data_fail;
+	}
+	/* wait for TTSP Device to complete switch to Operational mode */
+	msleep(500);
+	return 0;
+write_block_data_fail:
+	return retval;
+}
+
+static int cyttsp_soft_reset(struct cyttsp *ts)
+{
+	int retval;
+	int tries;
+	u8 cmd = CY_SOFT_RESET_MODE;
+
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+	/* reset TTSP Device back to bootloader mode */
+	retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd), &cmd);
+	/* wait for TTSP Device to complete reset back to bootloader */
+	tries = 0;
+	msleep(200);
+	do {
+		msleep(100);
+		cyttsp_load_bl_regs(ts);
+	} while (ts->bl_data.bl_status != 0x10 &&
+		ts->bl_data.bl_status != 0x11 &&
+		tries++ < 100);
+	if (tries >= 100)
+		printk(KERN_ERR "%s: bootlodader not ready, status 0x%02x\n",
+			__func__, ts->bl_data.bl_status);
+	return retval;
+}
+
+static int cyttsp_power_on(struct cyttsp *ts)
+{
+	int retval = 0;
+	u8 cmd;
+	int tries = 0;
+
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+	/* check if the TTSP device has a bootloader installed */
+	retval = cyttsp_soft_reset(ts);
+	if (retval < 0)
+		goto bypass;
+
+	do {
+		msleep(500);
+		retval = cyttsp_load_bl_regs(ts);
+	} while (!GET_BOOTLOADERMODE(ts->bl_data.bl_status) &&
+		!(GET_HSTMODE(ts->bl_data.bl_file) == CY_OPERATE_MODE) &&
+		tries++ < 10);
+
+	/* is bootloader missing? */
+	if (!GET_BOOTLOADERMODE(ts->bl_data.bl_status)) {
+		/* skip all bootloader and sys info and */
+		/* go straight to operational mode */
+		if (!(retval < 0)) {
+			cyttsp_set_operational_mode(ts);
+			goto bypass;
+		}
+	}
+	if (retval < 0)
+		goto bypass;
+
+	retval = cyttsp_exit_bl_mode(ts);
+
+	if (retval < 0)
+		goto bypass;
+
+	/* switch to System Information mode to read */
+	/* versions and set interval registers */
+	retval = cyttsp_set_sysinfo_mode(ts);
+	if (retval < 0)
+		goto bypass;
+	if ((CY_DIFF(ts->platform_data->act_intrvl, CY_ACT_INTRVL_DFLT) ||
+		CY_DIFF(ts->platform_data->tch_tmout, CY_TCH_TMOUT_DFLT) ||
+		CY_DIFF(ts->platform_data->lp_intrvl, CY_LP_INTRVL_DFLT))) {
+
+		u8 intrvl_ray[3];
+
+		intrvl_ray[0] = ts->platform_data->act_intrvl;
+		intrvl_ray[1] = ts->platform_data->tch_tmout;
+		intrvl_ray[2] = ts->platform_data->lp_intrvl;
+
+		DBG(printk(KERN_INFO"%s: act_intrvl=0x%02X"
+			"tch_tmout=0x%02X lp_intrvl=0x%02X\n",
+			__func__, ts->platform_data->act_intrvl,
+			ts->platform_data->tch_tmout,
+			ts->platform_data->lp_intrvl);)
+
+		/* set intrvl registers */
+		retval = ttsp_write_block_data(ts,
+				CY_REG_ACT_INTRVL,
+					sizeof(intrvl_ray), intrvl_ray);
+
+		msleep(CY_DELAY_SYSINFO);
+	}
+	/* switch back to Operational mode */
+	DBG(printk(KERN_INFO"%s: switch back to operational mode\n",
+		__func__);)
+	if (retval < 0)
+		goto bypass;
+
+	cmd = CY_OPERATE_MODE;
+	retval = ttsp_write_block_data(ts,
+		CY_REG_BASE, sizeof(cmd), &cmd);
+	/* wait for TTSP Device to complete switch to */
+	/* Operational mode */
+	msleep(1000);
+	/* init gesture setup */
+	if (retval < 0)
+		goto bypass;
+
+	if (ts->platform_data->use_gestures) {
+		u8 gesture_setup;
+
+		DBG(printk(KERN_INFO"%s: Init gesture setup\n", __func__);)
+
+		gesture_setup = ts->platform_data->gest_set;
+		retval = ttsp_write_block_data(ts, CY_REG_GEST_SET,
+				sizeof(gesture_setup), &gesture_setup);
+		msleep(CY_DELAY_DFLT);
+	}
+
+bypass:
+	if (retval < 0)
+		ts->platform_data->power_state = CY_IDLE_STATE;
+	else
+		ts->platform_data->power_state = CY_ACTIVE_STATE;
+
+	DBG(printk(KERN_INFO"%s: Power state is %s\n",
+			__func__, (ts->platform_data->power_state ==
+			CY_ACTIVE_STATE) ? "ACTIVE" : "IDLE");)
+	return retval;
+}
+
+#ifdef CONFIG_PM
+int cyttsp_resume(void *handle)
+{
+	int retval = 0;
+	struct cyttsp *ts = container_of(handle, struct cyttsp, pdev);
+	struct cyttsp_xydata xydata;
+
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+	LOCK(ts->mutex);
+	if (!ts->fw_loader_mode && ts->suspended) {
+		ts->suspended = 0;
+		if (ts->platform_data->use_sleep &&
+			(ts->platform_data->power_state != CY_ACTIVE_STATE)) {
+			if (ts->platform_data->wakeup)
+				retval = ts->platform_data->wakeup();
+
+			if (retval < 0)
+				printk(KERN_ERR "%s:"
+					" Error, wakeup failed!\n",
+					__func__);
+			else {
+				if (ts->platform_data->use_timer)
+					mod_timer(&ts->timer,
+					jiffies + TOUCHSCREEN_TIMEOUT);
+				else
+					enable_irq(ts->irq);
+				retval = ttsp_read_block_data(ts, CY_REG_BASE,
+					sizeof(xydata), &xydata);
+				if (!(retval < 0) &&
+					(GET_HSTMODE(xydata.hst_mode) ==
+					CY_OPERATE_MODE))
+					ts->platform_data->power_state =
+						CY_ACTIVE_STATE;
+			}
+		}
+	}
+	UNLOCK(ts->mutex);
+	DBG(printk(KERN_INFO"%s: Wake Up %s\n", __func__,
+		(retval < 0) ? "FAIL" : "PASS");)
+	return retval;
+}
+
+int cyttsp_suspend(void *handle)
+{
+	struct cyttsp *ts = container_of(handle, struct cyttsp, pdev);
+	u8 sleep_mode = 0;
+	int retval = 0;
+
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+
+	LOCK(ts->mutex);
+	if (!ts->fw_loader_mode) {
+		if (ts->platform_data->use_timer) {
+			del_timer(&ts->timer);
+			cancel_work_sync(&ts->work);
+		} else {
+			/* this call waits for any pending IRQ handlers */
+			disable_irq(ts->irq);
+		}
+		ts->suspended = 1;
+		if (ts->platform_data->use_sleep &&
+				(ts->platform_data->power_state ==
+				CY_ACTIVE_STATE)) {
+			sleep_mode = CY_DEEP_SLEEP_MODE;
+			retval = ttsp_write_block_data(ts,
+				CY_REG_BASE, sizeof(sleep_mode), &sleep_mode);
+			if (!(retval < 0))
+				ts->platform_data->power_state = CY_SLEEP_STATE;
+		}
+		DBG(printk(KERN_INFO"%s: Sleep Power state is %s\n", __func__,
+			(ts->platform_data->power_state == CY_ACTIVE_STATE) ?
+			"ACTIVE" :
+			((ts->platform_data->power_state == CY_SLEEP_STATE) ?
+			"SLEEP" : "LOW POWER"));)
+	}
+	UNLOCK(ts->mutex);
+	return retval;
+}
+#endif
+
+static ssize_t firmware_write(struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t pos, size_t size)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct cyttsp *ts = dev_get_drvdata(dev);
+	LOCK(ts->mutex);
+	DBG({
+		char str[128];
+		char *p = str;
+		int i;
+		for (i = 0; i < size; i++, p += 2)
+			sprintf(p, "%02x", (unsigned char)buf[i]);
+		printk(KERN_DEBUG "%s: size %d, pos %ld payload %s\n",
+		       __func__, size, (long)pos, str);
+	})
+	ttsp_write_block_data(ts, CY_REG_BASE, size, buf);
+	UNLOCK(ts->mutex);
+	return size;
+}
+
+static ssize_t firmware_read(struct kobject *kobj,
+	struct bin_attribute *ba,
+	char *buf, loff_t pos, size_t size)
+{
+	int count = 0;
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct cyttsp *ts = dev_get_drvdata(dev);
+
+	LOCK(ts->mutex);
+	if (!ts->fw_loader_mode)
+		goto exit;
+	if (!cyttsp_load_bl_regs(ts)) {
+		*(unsigned short *)buf = ts->bl_data.bl_status << 8 |
+			ts->bl_data.bl_error;
+		count = sizeof(unsigned short);
+	} else {
+		printk(KERN_ERR "%s: error reading status\n", __func__);
+		count = 0;
+	}
+exit:
+	UNLOCK(ts->mutex);
+	return count;
+}
+
+static struct bin_attribute cyttsp_firmware = {
+	.attr = {
+		.name = "firmware",
+		.mode = 0644,
+	},
+	.size = 128,
+	.read = firmware_read,
+	.write = firmware_write,
+};
+
+static ssize_t attr_fwloader_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct cyttsp *ts = dev_get_drvdata(dev);
+	return sprintf(buf, "0x%02X%02X 0x%02X%02X 0x%02X%02X 0x%02X%02X%02X\n",
+		ts->sysinfo_data.tts_verh, ts->sysinfo_data.tts_verl,
+		ts->sysinfo_data.app_idh, ts->sysinfo_data.app_idl,
+		ts->sysinfo_data.app_verh, ts->sysinfo_data.app_verl,
+		ts->sysinfo_data.cid[0], ts->sysinfo_data.cid[1],
+		ts->sysinfo_data.cid[2]);
+}
+
+static ssize_t attr_fwloader_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t size)
+{
+	char *p;
+	int ret;
+	struct cyttsp *ts = dev_get_drvdata(dev);
+	unsigned val = simple_strtoul(buf, &p, 10);
+
+	ret = p - buf;
+	if (*p && isspace(*p))
+		ret++;
+	printk(KERN_DEBUG "%s: %u\n", __func__, val);
+
+	LOCK(ts->mutex)
+	if (val && !ts->fw_loader_mode) {
+		ts->fw_loader_mode = 1;
+		if (ts->suspended) {
+			cyttsp_resume(ts);
+		} else {
+			if (ts->platform_data->use_timer)
+				del_timer(&ts->timer);
+			else
+				disable_irq_nosync(ts->irq);
+			cancel_work_sync(&ts->work);
+		}
+		ts->suspended = 0;
+		if (sysfs_create_bin_file(&dev->kobj, &cyttsp_firmware))
+			printk(KERN_ERR "%s: unable to create file\n",
+				__func__);
+		cyttsp_soft_reset(ts);
+		printk(KERN_INFO "%s: FW loader started.\n", __func__);
+	} else if (!val && ts->fw_loader_mode) {
+		sysfs_remove_bin_file(&dev->kobj, &cyttsp_firmware);
+		cyttsp_soft_reset(ts);
+		cyttsp_exit_bl_mode(ts);
+		cyttsp_set_sysinfo_mode(ts);
+		cyttsp_set_operational_mode(ts);
+
+		if (ts->platform_data->use_timer)
+			mod_timer(&ts->timer, jiffies + TOUCHSCREEN_TIMEOUT);
+		else
+			enable_irq(ts->irq);
+		ts->fw_loader_mode = 0;
+		printk(KERN_INFO "%s: FW loader finished.\n", __func__);
+	}
+	UNLOCK(ts->mutex);
+	return  ret == size ? ret : -EINVAL;
+}
+
+static struct device_attribute fwloader =
+	__ATTR(fwloader, 0644, attr_fwloader_show, attr_fwloader_store);
+
+void *cyttsp_core_init(struct cyttsp_bus_ops *bus_ops, struct device *pdev)
+{
+	struct input_dev *input_device;
+	struct cyttsp *ts;
+	int retval = 0;
+
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+
+	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
+	if (ts == NULL) {
+		printk(KERN_ERR "%s: Error, kzalloc\n", __func__);
+		goto error_alloc_data_failed;
+	}
+	mutex_init(&ts->mutex);
+	ts->pdev = pdev;
+	ts->platform_data = pdev->platform_data;
+	ts->bus_ops = bus_ops;
+
+	if (ts->platform_data->init)
+		retval = ts->platform_data->init(1);
+	if (retval) {
+		printk(KERN_ERR "%s: platform init failed!\n", __func__);
+		goto error_init;
+	}
+
+	if (ts->platform_data->use_timer)
+		ts->irq = -1;
+	else
+		ts->irq = gpio_to_irq(ts->platform_data->irq_gpio);
+
+	retval = cyttsp_power_on(ts);
+	if (retval < 0) {
+		printk(KERN_ERR "%s: Error, power on failed!\n", __func__);
+		goto error_power_on;
+	}
+
+	/* Create the input device and register it. */
+	input_device = input_allocate_device();
+	if (!input_device) {
+		retval = -ENOMEM;
+		printk(KERN_ERR "%s: Error, failed to allocate input device\n",
+			__func__);
+		goto error_input_allocate_device;
+	}
+
+	ts->input = input_device;
+	input_device->name = ts->platform_data->name;
+	input_device->phys = ts->phys;
+	input_device->dev.parent = ts->pdev;
+	/* init the touch structures */
+	ts->num_prv_st_tch = CY_NTCH;
+	memset(ts->act_trk, CY_NTCH, sizeof(ts->act_trk));
+	memset(ts->prv_mt_pos, CY_NTCH, sizeof(ts->prv_mt_pos));
+	memset(ts->prv_mt_tch, CY_IGNR_TCH, sizeof(ts->prv_mt_tch));
+	memset(ts->prv_st_tch, CY_IGNR_TCH, sizeof(ts->prv_st_tch));
+
+	__set_bit(EV_SYN, input_device->evbit);
+	__set_bit(EV_KEY, input_device->evbit);
+	__set_bit(EV_ABS, input_device->evbit);
+	__set_bit(BTN_TOUCH, input_device->keybit);
+	__set_bit(BTN_2, input_device->keybit);
+	if (ts->platform_data->use_gestures)
+		__set_bit(BTN_3, input_device->keybit);
+
+	input_set_abs_params(input_device, ABS_X, 0, ts->platform_data->maxx,
+			     0, 0);
+	input_set_abs_params(input_device, ABS_Y, 0, ts->platform_data->maxy,
+			     0, 0);
+	input_set_abs_params(input_device, ABS_TOOL_WIDTH, 0,
+			     CY_LARGE_TOOL_WIDTH, 0, 0);
+	input_set_abs_params(input_device, ABS_PRESSURE, 0, CY_MAXZ, 0, 0);
+	input_set_abs_params(input_device, ABS_HAT0X, 0,
+			     ts->platform_data->maxx, 0, 0);
+	input_set_abs_params(input_device, ABS_HAT0Y, 0,
+			     ts->platform_data->maxy, 0, 0);
+	if (ts->platform_data->use_gestures) {
+		input_set_abs_params(input_device, ABS_HAT1X, 0, CY_MAXZ,
+				     0, 0);
+		input_set_abs_params(input_device, ABS_HAT1Y, 0, CY_MAXZ,
+				     0, 0);
+	}
+	if (ts->platform_data->use_mt) {
+		input_set_abs_params(input_device, ABS_MT_POSITION_X, 0,
+				     ts->platform_data->maxx, 0, 0);
+		input_set_abs_params(input_device, ABS_MT_POSITION_Y, 0,
+				     ts->platform_data->maxy, 0, 0);
+		input_set_abs_params(input_device, ABS_MT_TOUCH_MAJOR, 0,
+				     CY_MAXZ, 0, 0);
+		input_set_abs_params(input_device, ABS_MT_WIDTH_MAJOR, 0,
+				     CY_LARGE_TOOL_WIDTH, 0, 0);
+		if (ts->platform_data->use_trk_id)
+			input_set_abs_params(input_device, ABS_MT_TRACKING_ID,
+					0, CY_NUM_TRK_ID, 0, 0);
+	}
+
+	if (ts->platform_data->use_virtual_keys)
+		input_set_capability(input_device, EV_KEY, KEY_PROG1);
+
+	retval = input_register_device(input_device);
+	if (retval) {
+		printk(KERN_ERR "%s: Error, failed to register input device\n",
+			__func__);
+		goto error_input_register_device;
+	}
+	DBG(printk(KERN_INFO "%s: Registered input device %s\n",
+		   __func__, input_device->name);)
+
+	/* Prepare our worker structure prior to setting up the timer ISR */
+	INIT_WORK(&ts->work, cyttsp_xy_worker_);
+
+	/* Timer or Interrupt setup */
+	if (ts->platform_data->use_timer) {
+		DBG(printk(KERN_INFO "%s: Setting up Timer\n", __func__);)
+		setup_timer(&ts->timer, cyttsp_timer, (unsigned long) ts);
+		mod_timer(&ts->timer, jiffies + TOUCHSCREEN_TIMEOUT);
+	} else {
+		DBG(
+		printk(KERN_INFO "%s: Setting up Interrupt. Device name=%s\n",
+			__func__, input_device->name);)
+		retval = request_threaded_irq(ts->irq, NULL, cyttsp_irq,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   input_device->name, ts);
+
+		if (retval) {
+			printk(KERN_ERR "%s: Error, could not request irq\n",
+				__func__);
+			goto error_free_irq;
+		} else {
+			DBG(printk(KERN_INFO "%s: Interrupt=%d\n",
+				__func__, ts->irq);)
+		}
+	}
+	retval = device_create_file(pdev, &fwloader);
+	if (retval) {
+		printk(KERN_ERR "%s: Error, could not create attribute\n",
+			__func__);
+		goto device_create_error;
+	}
+	dev_set_drvdata(pdev, ts);
+	printk(KERN_INFO "%s: Successful.\n", __func__);
+	return ts;
+
+device_create_error:
+error_free_irq:
+	if (ts->irq >= 0)
+		free_irq(ts->irq, ts);
+	input_unregister_device(input_device);
+error_input_register_device:
+	input_free_device(input_device);
+error_input_allocate_device:
+error_power_on:
+	if (ts->platform_data->init)
+		ts->platform_data->init(0);
+error_init:
+	kfree(ts);
+error_alloc_data_failed:
+	return NULL;
+}
+
+/* registered in driver struct */
+void cyttsp_core_release(void *handle)
+{
+	struct cyttsp *ts = handle;
+
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+	cancel_work_sync(&ts->work);
+	if (ts->platform_data->use_timer)
+		del_timer_sync(&ts->timer);
+	else
+		free_irq(ts->irq, ts);
+	input_unregister_device(ts->input);
+	input_free_device(ts->input);
+	if (ts->platform_data->init)
+		ts->platform_data->init(0);
+	kfree(ts);
+}
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard touchscreen driver core");
+MODULE_AUTHOR("Cypress");
+
diff --git a/drivers/input/touchscreen/cyttsp_core.h b/drivers/input/touchscreen/cyttsp_core.h
new file mode 100755
index 0000000..25a732d
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp_core.h
@@ -0,0 +1,49 @@
+/* Header file for:
+ * Cypress TrueTouch(TM) Standard Product (TTSP) touchscreen drivers.
+ * For use with Cypress Txx2xx and Txx3xx parts.
+ * Supported parts include:
+ * CY8CTST241
+ * CY8CTMG240
+ * CY8CTST341
+ * CY8CTMA340
+ *
+ * Copyright (C) 2009, 2010 Cypress Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, and only version 2, as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ *
+ * Contact Cypress Semiconductor at www.cypress.com (kev@cypress.com)
+ *
+ */
+
+
+#ifndef __CYTTSP_CORE_H__
+#define __CYTTSP_CORE_H__
+
+#include <linux/kernel.h>
+
+struct cyttsp_bus_ops {
+	s32 (*write)(void *handle, u8 addr, u8 length, const void *values);
+	s32 (*read)(void *handle, u8 addr, u8 length, void *values);
+	s32 (*ext)(void *handle, void *values);
+};
+
+void *cyttsp_core_init(struct cyttsp_bus_ops *bus_ops, struct device *pdev);
+void cyttsp_core_release(void *handle);
+#ifdef CONFIG_PM
+int cyttsp_resume(void *handle);
+int cyttsp_suspend(void *handle);
+#endif
+
+#endif /* __CYTTSP_CORE_H__ */
diff --git a/drivers/input/touchscreen/cyttsp_i2c.c b/drivers/input/touchscreen/cyttsp_i2c.c
new file mode 100755
index 0000000..ef96105
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp_i2c.c
@@ -0,0 +1,183 @@
+/* Source for:
+ * Cypress TrueTouch(TM) Standard Product (TTSP) I2C touchscreen driver.
+ * For use with Cypress Txx2xx and Txx3xx parts with I2C interface.
+ * Supported parts include:
+ * CY8CTST241
+ * CY8CTMG240
+ * CY8CTST341
+ * CY8CTMA340
+ *
+ * Copyright (C) 2009, 2010 Cypress Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, and only version 2, as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ *
+ * Contact Cypress Semiconductor at www.cypress.com (kev@cypress.com)
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/cyttsp.h>
+#include "cyttsp_core.h"
+
+#define DBG(x)
+
+struct cyttsp_i2c {
+	struct cyttsp_bus_ops ops;
+	struct i2c_client *client;
+	void *ttsp_client;
+};
+
+static s32 ttsp_i2c_read_block_data(void *handle, u8 addr,
+	u8 length, void *values)
+{
+	struct cyttsp_i2c *ts = container_of(handle, struct cyttsp_i2c, ops);
+	return i2c_smbus_read_i2c_block_data(ts->client,
+		addr, length, values);
+}
+
+static s32 ttsp_i2c_write_block_data(void *handle, u8 addr,
+	u8 length, const void *values)
+{
+	struct cyttsp_i2c *ts = container_of(handle, struct cyttsp_i2c, ops);
+	return i2c_smbus_write_i2c_block_data(ts->client,
+		addr, length, values);
+}
+
+static s32 ttsp_i2c_tch_ext(void *handle, void *values)
+{
+	int retval = 0;
+	struct cyttsp_i2c *ts = container_of(handle, struct cyttsp_i2c, ops);
+
+	DBG(printk(KERN_INFO "%s: Enter\n", __func__);)
+
+	/* Add custom touch extension handling code here */
+	/* set: retval < 0 for any returned system errors,
+		retval = 0 if normal touch handling is required,
+		retval > 0 if normal touch handling is *not* required */
+	if (!ts || !values)
+		retval = -EIO;
+
+	return retval;
+}
+static int __devinit cyttsp_i2c_probe(struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	struct cyttsp_i2c *ts;
+	int retval;
+
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+
+	if (!i2c_check_functionality(client->adapter,
+		I2C_FUNC_SMBUS_READ_WORD_DATA))
+		return -EIO;
+
+	/* allocate and clear memory */
+	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
+	if (ts == NULL) {
+		printk(KERN_ERR "%s: Error, kzalloc.\n", __func__);
+		retval = -ENOMEM;
+		goto error_alloc_data_failed;
+	}
+
+	/* register driver_data */
+	ts->client = client;
+	i2c_set_clientdata(client, ts);
+	ts->ops.write = ttsp_i2c_write_block_data;
+	ts->ops.read = ttsp_i2c_read_block_data;
+	ts->ops.ext = ttsp_i2c_tch_ext;
+
+	ts->ttsp_client = cyttsp_core_init(&ts->ops, &client->dev);
+	if (!ts->ttsp_client)
+		goto ttsp_core_err;
+
+	printk(KERN_INFO "%s: Successful registration %s\n",
+		__func__, CY_I2C_NAME);
+	return 0;
+
+ttsp_core_err:
+	kfree(ts);
+error_alloc_data_failed:
+	return retval;
+}
+
+
+/* registered in driver struct */
+static int __devexit cyttsp_i2c_remove(struct i2c_client *client)
+{
+	struct cyttsp_i2c *ts;
+
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+	ts = i2c_get_clientdata(client);
+	cyttsp_core_release(ts->ttsp_client);
+	kfree(ts);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int cyttsp_i2c_suspend(struct i2c_client *client, pm_message_t message)
+{
+	return cyttsp_suspend(dev_get_drvdata(&client->dev));
+}
+
+static int cyttsp_i2c_resume(struct i2c_client *client)
+{
+	return cyttsp_resume(dev_get_drvdata(&client->dev));
+}
+#endif
+
+static const struct i2c_device_id cyttsp_i2c_id[] = {
+	{ CY_I2C_NAME, 0 },  { }
+};
+
+static struct i2c_driver cyttsp_i2c_driver = {
+	.driver = {
+		.name = CY_I2C_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = cyttsp_i2c_probe,
+	.remove = __devexit_p(cyttsp_i2c_remove),
+	.id_table = cyttsp_i2c_id,
+#ifdef CONFIG_PM
+	.suspend = cyttsp_i2c_suspend,
+	.resume = cyttsp_i2c_resume,
+#endif
+};
+
+static int cyttsp_i2c_init(void)
+{
+	int retval;
+	retval = i2c_add_driver(&cyttsp_i2c_driver);
+	printk(KERN_INFO "%s: Cypress TrueTouch(R) Standard Product I2C "
+		"Touchscreen Driver (Built %s @ %s) returned %d\n",
+		 __func__, __DATE__, __TIME__, retval);
+
+	return retval;
+}
+
+static void cyttsp_i2c_exit(void)
+{
+	return i2c_del_driver(&cyttsp_i2c_driver);
+}
+
+module_init(cyttsp_i2c_init);
+module_exit(cyttsp_i2c_exit);
+
+MODULE_ALIAS("i2c:cyttsp");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard Product (TTSP) I2C driver");
+MODULE_AUTHOR("Cypress");
+MODULE_DEVICE_TABLE(i2c, cyttsp_i2c_id);
diff --git a/drivers/input/touchscreen/cyttsp_spi.c b/drivers/input/touchscreen/cyttsp_spi.c
new file mode 100755
index 0000000..cb6432a
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp_spi.c
@@ -0,0 +1,339 @@
+/* Source for:
+ * Cypress TrueTouch(TM) Standard Product (TTSP) SPI touchscreen driver.
+ * For use with Cypress Txx2xx and Txx3xx parts with SPI interface.
+ * Supported parts include:
+ * CY8CTST241
+ * CY8CTMG240
+ * CY8CTST341
+ * CY8CTMA340
+ *
+ * Copyright (C) 2009, 2010 Cypress Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, and only version 2, as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ *
+ * Contact Cypress Semiconductor at www.cypress.com (kev@cypress.com)
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/spi/spi.h>
+#include <linux/delay.h>
+#include <linux/cyttsp.h>
+#include "cyttsp_core.h"
+
+#define DBG(x)
+
+#define CY_SPI_WR_OP      0x00 /* r/~w */
+#define CY_SPI_RD_OP      0x01
+#define CY_SPI_CMD_BYTES  4
+#define CY_SPI_SYNC_BYTES 2
+#define CY_SPI_SYNC_ACK1  0x62 /* from protocol v.2 */
+#define CY_SPI_SYNC_ACK2  0x9D /* from protocol v.2 */
+#define CY_SPI_SYNC_NACK  0x69
+#define CY_SPI_DATA_SIZE  64
+#define CY_SPI_DATA_BUF_SIZE (CY_SPI_CMD_BYTES + CY_SPI_DATA_SIZE)
+#define CY_SPI_BITS_PER_WORD 8
+
+struct cyttsp_spi {
+	struct cyttsp_bus_ops ops;
+	struct spi_device *spi_client;
+	void *ttsp_client;
+	u8 wr_buf[CY_SPI_DATA_BUF_SIZE];
+	u8 rd_buf[CY_SPI_DATA_BUF_SIZE];
+};
+
+static void spi_complete(void *arg)
+{
+	complete(arg);
+}
+
+static int spi_sync_tmo(struct spi_device *spi, struct spi_message *message)
+{
+	DECLARE_COMPLETION_ONSTACK(done);
+	int status;
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+
+	message->complete = spi_complete;
+	message->context = &done;
+	status = spi_async(spi, message);
+	if (status == 0) {
+		int ret = wait_for_completion_interruptible_timeout(&done, HZ);
+		if (!ret) {
+			printk(KERN_ERR "%s: timeout\n", __func__);
+			status = -EIO;
+		} else
+			status = message->status;
+	}
+	message->context = NULL;
+	return status;
+}
+
+static int cyttsp_spi_xfer_(u8 op, struct cyttsp_spi *ts_spi,
+			    u8 reg, u8 *buf, int length)
+{
+	struct spi_message msg;
+	struct spi_transfer xfer = { 0 };
+	u8 *wr_buf = ts_spi->wr_buf;
+	u8 *rd_buf = ts_spi->rd_buf;
+	int retval;
+	int i;
+	DBG(printk(KERN_INFO "%s: Enter\n", __func__);)
+
+	if (length > CY_SPI_DATA_SIZE) {
+		printk(KERN_ERR "%s: length %d is too big.\n",
+			__func__, length);
+		return -EINVAL;
+	}
+	DBG(printk(KERN_INFO "%s: OP=%s length=%d\n", __func__,
+		   op == CY_SPI_RD_OP ? "Read" : "Write", length);)
+
+	wr_buf[0] = 0x00; /* header byte 0 */
+	wr_buf[1] = 0xFF; /* header byte 1 */
+	wr_buf[2] = reg;  /* reg index */
+	wr_buf[3] = op;   /* r/~w */
+	if (op == CY_SPI_WR_OP)
+		memcpy(wr_buf + CY_SPI_CMD_BYTES, buf, length);
+	DBG(
+	if (op == CY_SPI_RD_OP)
+		memset(rd_buf, CY_SPI_SYNC_NACK, CY_SPI_DATA_BUF_SIZE);)
+	DBG(
+	for (i = 0; i < (length + CY_SPI_CMD_BYTES); i++) {
+		if ((op == CY_SPI_RD_OP) && (i < CY_SPI_CMD_BYTES))
+			printk(KERN_INFO "%s: wr[%d]:0x%02x\n",
+				__func__, i, wr_buf[i]);
+		if (op == CY_SPI_WR_OP)
+			printk(KERN_INFO "%s: wr[%d]:0x%02x\n",
+				__func__, i, wr_buf[i]);
+	})
+
+	xfer.tx_buf = wr_buf;
+	xfer.rx_buf = rd_buf;
+	xfer.len = length + CY_SPI_CMD_BYTES;
+
+	if ((op == CY_SPI_RD_OP) && (xfer.len < 32))
+		xfer.len += 1;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+	retval = spi_sync_tmo(ts_spi->spi_client, &msg);
+	if (retval < 0) {
+		printk(KERN_ERR "%s: spi_sync_tmo() error %d\n",
+			__func__, retval);
+		retval = 0;
+	}
+	if (op == CY_SPI_RD_OP) {
+		DBG(
+		for (i = 0; i < (length + CY_SPI_CMD_BYTES); i++)
+			printk(KERN_INFO "%s: rd[%d]:0x%02x\n",
+				__func__, i, rd_buf[i]);)
+
+		for (i = 0; i < (length + CY_SPI_CMD_BYTES - 1); i++) {
+			if ((rd_buf[i] != CY_SPI_SYNC_ACK1) ||
+				(rd_buf[i + 1] != CY_SPI_SYNC_ACK2)) {
+				continue;
+			}
+			if (i <= (CY_SPI_CMD_BYTES - 1)) {
+				memcpy(buf, (rd_buf + i + CY_SPI_SYNC_BYTES),
+					length);
+				return 0;
+			}
+		}
+		DBG(printk(KERN_INFO "%s: byte sync error\n", __func__);)
+		retval = 1;
+	}
+	return retval;
+}
+
+static int cyttsp_spi_xfer(u8 op, struct cyttsp_spi *ts,
+			    u8 reg, u8 *buf, int length)
+{
+	int tries;
+	int retval;
+	DBG(printk(KERN_INFO "%s: Enter\n", __func__);)
+
+	if (op == CY_SPI_RD_OP) {
+		for (tries = CY_NUM_RETRY; tries; tries--) {
+			retval = cyttsp_spi_xfer_(op, ts, reg, buf, length);
+			if (retval == 0)
+				break;
+			else
+				msleep(10);
+		}
+	} else {
+		retval = cyttsp_spi_xfer_(op, ts, reg, buf, length);
+	}
+	return retval;
+}
+
+static s32 ttsp_spi_read_block_data(void *handle, u8 addr,
+				    u8 length, void *data)
+{
+	int retval;
+	struct cyttsp_spi *ts = container_of(handle, struct cyttsp_spi, ops);
+
+	DBG(printk(KERN_INFO "%s: Enter\n", __func__);)
+
+	retval = cyttsp_spi_xfer(CY_SPI_RD_OP, ts, addr, data, length);
+	if (retval < 0)
+		printk(KERN_ERR "%s: ttsp_spi_read_block_data failed\n",
+			__func__);
+
+	/* Do not print the above error if the data sync bytes were not found.
+	   This is a normal condition for the bootloader loader startup and need
+	   to retry until data sync bytes are found. */
+	if (retval > 0)
+		retval = -1;	/* now signal fail; so retry can be done */
+
+	return retval;
+}
+
+static s32 ttsp_spi_write_block_data(void *handle, u8 addr,
+				     u8 length, const void *data)
+{
+	int retval;
+	struct cyttsp_spi *ts = container_of(handle, struct cyttsp_spi, ops);
+
+	DBG(printk(KERN_INFO "%s: Enter\n", __func__);)
+
+	retval = cyttsp_spi_xfer(CY_SPI_WR_OP, ts, addr, (void *)data, length);
+	if (retval < 0)
+		printk(KERN_ERR "%s: ttsp_spi_write_block_data failed\n",
+			__func__);
+
+	if (retval == -EIO)
+		return 0;
+	else
+		return retval;
+}
+
+static s32 ttsp_spi_tch_ext(void *handle, void *values)
+{
+	int retval = 0;
+	struct cyttsp_spi *ts = container_of(handle, struct cyttsp_spi, ops);
+
+	DBG(printk(KERN_INFO "%s: Enter\n", __func__);)
+
+	/* Add custom touch extension handling code here */
+	/* set: retval < 0 for any returned system errors,
+		retval = 0 if normal touch handling is required,
+		retval > 0 if normal touch handling is *not* required */
+	if (!ts || !values)
+		retval = -EIO;
+
+	return retval;
+}
+
+static int __devinit cyttsp_spi_probe(struct spi_device *spi)
+{
+	struct cyttsp_spi *ts_spi;
+	int retval;
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+
+	/* Set up SPI*/
+	spi->bits_per_word = CY_SPI_BITS_PER_WORD;
+	spi->mode = SPI_MODE_0;
+	retval = spi_setup(spi);
+	if (retval < 0) {
+		printk(KERN_ERR "%s: SPI setup error %d\n", __func__, retval);
+		return retval;
+	}
+	ts_spi = kzalloc(sizeof(*ts_spi), GFP_KERNEL);
+	if (ts_spi == NULL) {
+		printk(KERN_ERR "%s: Error, kzalloc\n", __func__);
+		retval = -ENOMEM;
+		goto error_alloc_data_failed;
+	}
+	ts_spi->spi_client = spi;
+	dev_set_drvdata(&spi->dev, ts_spi);
+	ts_spi->ops.write = ttsp_spi_write_block_data;
+	ts_spi->ops.read = ttsp_spi_read_block_data;
+	ts_spi->ops.ext = ttsp_spi_tch_ext;
+
+	ts_spi->ttsp_client = cyttsp_core_init(&ts_spi->ops, &spi->dev);
+	if (!ts_spi->ttsp_client)
+		goto ttsp_core_err;
+	printk(KERN_INFO "%s: Successful registration %s\n",
+	       __func__, CY_SPI_NAME);
+
+	return 0;
+
+ttsp_core_err:
+	kfree(ts_spi);
+error_alloc_data_failed:
+	return retval;
+}
+
+/* registered in driver struct */
+static int __devexit cyttsp_spi_remove(struct spi_device *spi)
+{
+	struct cyttsp_spi *ts_spi = dev_get_drvdata(&spi->dev);
+	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
+	cyttsp_core_release(ts_spi->ttsp_client);
+	kfree(ts_spi);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int cyttsp_spi_suspend(struct spi_device *spi, pm_message_t message)
+{
+	return cyttsp_suspend(dev_get_drvdata(&spi->dev));
+}
+
+static int cyttsp_spi_resume(struct spi_device *spi)
+{
+	return cyttsp_resume(dev_get_drvdata(&spi->dev));
+}
+#endif
+
+static struct spi_driver cyttsp_spi_driver = {
+	.driver = {
+		.name = CY_SPI_NAME,
+		.bus = &spi_bus_type,
+		.owner = THIS_MODULE,
+	},
+	.probe = cyttsp_spi_probe,
+	.remove = __devexit_p(cyttsp_spi_remove),
+#ifdef CONFIG_PM
+	.suspend = cyttsp_spi_suspend,
+	.resume = cyttsp_spi_resume,
+#endif
+};
+
+static int __init cyttsp_spi_init(void)
+{
+	int err;
+
+	err = spi_register_driver(&cyttsp_spi_driver);
+	printk(KERN_INFO "%s: Cypress TrueTouch(R) Standard Product SPI "
+		"Touchscreen Driver (Built %s @ %s) returned %d\n",
+		 __func__, __DATE__, __TIME__, err);
+
+	return err;
+}
+module_init(cyttsp_spi_init);
+
+static void __exit cyttsp_spi_exit(void)
+{
+	spi_unregister_driver(&cyttsp_spi_driver);
+	printk(KERN_INFO "%s: module exit\n", __func__);
+}
+module_exit(cyttsp_spi_exit);
+
+MODULE_ALIAS("spi:cyttsp");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard Product (TTSP) SPI driver");
+MODULE_AUTHOR("Cypress");
+
diff --git a/include/linux/cyttsp.h b/include/linux/cyttsp.h
new file mode 100755
index 0000000..b2a289b
--- /dev/null
+++ b/include/linux/cyttsp.h
@@ -0,0 +1,104 @@
+/* Header file for:
+ * Cypress TrueTouch(TM) Standard Product (TTSP) touchscreen drivers.
+ * For use with Cypress Txx2xx and Txx3xx parts.
+ * Supported parts include:
+ * CY8CTST241
+ * CY8CTMG240
+ * CY8CTST341
+ * CY8CTMA340
+ *
+ * Copyright (C) 2009, 2010 Cypress Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, and only version 2, as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ *
+ * Contact Cypress Semiconductor at www.cypress.com (kev@cypress.com)
+ *
+ */
+#include <linux/input.h>
+
+#ifndef _CYTTSP_H_
+#define _CYTTSP_H_
+
+#include <linux/input.h>
+
+#define CY_SPI_NAME "cyttsp-spi"
+#define CY_I2C_NAME "cyttsp-i2c"
+/* Active Power state scanning/processing refresh interval */
+#define CY_ACT_INTRVL_DFLT 0x00
+/* touch timeout for the Active power */
+#define CY_TCH_TMOUT_DFLT 0xFF
+/* Low Power state scanning/processing refresh interval */
+#define CY_LP_INTRVL_DFLT 0x0A
+/*
+ *defines for Gen2 (Txx2xx); Gen3 (Txx3xx)
+ * use these defines to set cyttsp_platform_data.gen in board config file
+ */
+enum cyttsp_gen {
+	CY_GEN2,
+	CY_GEN3,
+};
+/*
+ * Active distance in pixels for a gesture to be reported
+ * if set to 0, then all gesture movements are reported
+ * Valid range is 0 - 15
+ */
+#define CY_ACT_DIST_DFLT 8
+#define CY_ACT_DIST CY_ACT_DIST_DFLT
+/* max num retries to read touch data */
+#define CY_NUM_RETRY 4
+
+enum cyttsp_gest {
+	CY_GEST_GRP_NONE = 0,
+	CY_GEST_GRP1 =	0x10,
+	CY_GEST_GRP2 = 0x20,
+	CY_GEST_GRP3 = 0x40,
+	CY_GEST_GRP4 = 0x80,
+};
+
+enum cyttsp_powerstate {
+	CY_IDLE_STATE,
+	CY_ACTIVE_STATE,
+	CY_LOW_PWR_STATE,
+	CY_SLEEP_STATE,
+};
+
+struct cyttsp_platform_data {
+	u32 maxx;
+	u32 maxy;
+	u32 flags;
+	enum cyttsp_gen gen;
+	unsigned use_st:1;
+	unsigned use_mt:1;
+	unsigned use_trk_id:1;
+	unsigned use_hndshk:1;
+	unsigned use_timer:1;
+	unsigned use_sleep:1;
+	unsigned use_gestures:1;
+	unsigned use_load_file:1;
+	unsigned use_force_fw_update:1;
+	unsigned use_virtual_keys:1;
+	enum cyttsp_powerstate power_state;
+	u8 gest_set;
+	u8 act_intrvl;  /* Active refresh interval; ms */
+	u8 tch_tmout;   /* Active touch timeout; ms */
+	u8 lp_intrvl;   /* Low power refresh interval; ms */
+	int (*wakeup)(void);
+	int (*init)(int on_off);
+	void (*mt_sync)(struct input_dev *);
+	char *name;
+	s16 irq_gpio;
+};
+
+#endif /* _CYTTSP_H_ */
-- 
1.6.3.3


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

