Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1HAVvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:51:52 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:22192
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034Ab1HAVvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:51:48 -0400
X-SpamScore: -5
X-BigFish: VS-5(zz119bMzz1202hzz8275bhz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Timur Tabi <timur@freescale.com>
To: <arnd@arndb.de>, <grant.likely@secretlab.ca>, <linuxppc-dev@ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/misc: introduce Freescale Data Collection Manager driver
Date: Mon, 1 Aug 2011 16:48:54 -0500
Message-ID: <1312235334-15036-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Data Collection Manager (DCM) is a feature of the FPGA on some Freescale
PowerPC reference boards that can read temperature, current, and voltage
settings from the sensors on those boards.  This driver exposes the DCM via a
sysfs interface (/sys/devices/platform/fsl-ocm.0).

The DCM collects and tallies data over a period of time in the background,
without utilizing any resources on the host (CPU, memory, etc).  The data is
summarized and made available when data collection stops.  This allows power
consumption to be measured while the host is performing some tasks (usually
a benchmark).

Signed-off-by: Timur Tabi <timur@freescale.com>
---

Grant, could you please review the way I instantiate the platform driver and
call the .probe function?

 Documentation/misc-devices/fsl_dcm.txt |   50 +++
 drivers/misc/Kconfig                   |   14 +
 drivers/misc/Makefile                  |    1 +
 drivers/misc/fsl_dcm.c                 |  750 ++++++++++++++++++++++++++++++++
 4 files changed, 815 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/fsl_dcm.txt
 create mode 100644 drivers/misc/fsl_dcm.c

diff --git a/Documentation/misc-devices/fsl_dcm.txt b/Documentation/misc-devices/fsl_dcm.txt
new file mode 100644
index 0000000..d679db3
--- /dev/null
+++ b/Documentation/misc-devices/fsl_dcm.txt
@@ -0,0 +1,50 @@
+Freescale Data Collection Manager (DCM) device driver
+
+Inside the FPGA of some Freescale QorIQ (PowerPC) reference boards is a
+microprocessor called the General Purpose Processor (GSMA).  Running on
+the GSMA is the Data Collection Manager (DCM), which is used to
+periodically read and tally voltage, current, and temperature measurements
+from the on-board sensors.  You can use this feature to measure power
+consumption while running tests, without having the host CPU perform those
+measurements.
+
+Only some Freescale reference boards are supported.  In most cases, the
+on-board dip switches need to be changed to enable the DCM.
+
+These are the boards that are currently supported:
+
+* P1022DS
+	Set SW9[7:8] to '10'.
+
+* P3060QDS
+	Set SW9[2] to 0 and SW9[8] to '1'.
+
+* P4080DS
+	Set SW9[7:8] to '10'.
+
+* P5020DS
+	Set SW9[7:8] to '10'.
+
+To use, first send "1" to the 'control' file:
+     echo 1 > /sys/devices/platform/fsl-dcm.0/control
+
+Then perform your benchmarks, when you are done, stop the monitoring:
+     echo 0 > /sys/devices/platform/fsl-dcm.0/control
+
+You can display the current status of data collection
+     cat /sys/devices/platform/fsl-dcm.0/control
+
+To view the results of data collection (after having been stopped):
+     cat /sys/devices/platform/fsl-dcm.0/result
+
+To change the sampling frequency to 10Hz (for example)
+     echo 10 > /sys/devices/platform/fsl-dcm.0/frequency
+
+Empirical evidence shows that the maximum sampling frequency is 48 Hz.
+Anything higher than that is unreliable.
+
+You can display the current sampling frequency:
+     cat /sys/devices/platform/fsl-dcm.0/frequency
+
+To display information about the DCM:
+     cat /sys/devices/platform/fsl-dcm.0/info
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 0a4d86c..93b4952 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -498,6 +498,20 @@ config USB_SWITCH_FSA9480
 	  stereo and mono audio, video, microphone and UART data to use
 	  a common connector port.
 
+config FSL_DCM
+	tristate "Freescale Data Collection Manager (DCM) driver"
+	depends on FSL_SOC && PPC_85xx
+	help
+	  Inside the FPGA of some Freescale QorIQ (PowerPC) reference boards
+	  is a microcontroller called the General Purpose Processor (GSMA).
+	  Running on the GSMA is the Data Collection Manager (DCM), which is
+	  used to periodically read and tally voltage, current, and temperature
+	  measurements from the on-board sensors.  You can use this feature to
+	  measure power consumption while running tests, without having the
+	  host CPU perform those measurements.
+
+	  See Documentation/misc-devices/fsl_dcm.txt for more information.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 8f3efb6..f039c59 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -47,3 +47,4 @@ obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
 obj-y				+= lis3lv02d/
 obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
+obj-$(CONFIG_FSL_DCM)		+= fsl_dcm.o
diff --git a/drivers/misc/fsl_dcm.c b/drivers/misc/fsl_dcm.c
new file mode 100644
index 0000000..0e50e08
--- /dev/null
+++ b/drivers/misc/fsl_dcm.c
@@ -0,0 +1,750 @@
+/*
+ * Freescale Data Collection Manager (DCM) device driver
+ *
+ * Copyright (C) 2011 Freescale Semiconductor, Inc.
+ * Author: Timur Tabi <timur@freescale.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ *
+ * Inside the FPGA of some Freescale QorIQ (PowerPC) reference boards is a
+ * microprocessor called the General Purpose Processor (GSMA).  Running on
+ * the GSMA is the Data Collection Manager (DCM), which is used to
+ * periodically read and tally voltage, current, and temperature measurements
+ * from the on-board sensors.  You can use this feature to measure power
+ * consumption while running tests, without having the host CPU perform those
+ * measurements.
+ *
+ * See Documentation/misc-devices/fsl_dcm.txt for more information.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/of_platform.h>
+
+/* sysfs commands for 'control' */
+#define SYSFS_DCM_CMD_STOP	0
+#define SYSFS_DCM_CMD_START	1
+
+/* Crecords can be either voltage, current, or temperature */
+enum crecord_type {
+	CR_V,	/* voltage */
+	CR_C,	/* current */
+	CR_T	/* temperature */
+};
+
+#define MAX_FREQUENCY		48	/* max freq (Hz) the DCM supports */
+#define DATA_ADDR		0x80	/* data address in DCM SRAM */
+
+struct crecord {
+	__be16	curr;		/* last sample read */
+	__be16	max;		/* maximum of all samples read */
+	__be16	qty1;		/* number of samples read  */
+	u8	qty2;
+	__be32	acc;		/* sum of all samples read */
+} __packed;
+#define MAX_CRECORDS	((0x100 - DATA_ADDR) / sizeof(struct crecord))
+
+struct om_info {
+	__be16	version;	/* DCM version number */
+	u8	prescale;	/* prescale value used (should be 0) */
+	u8	timer;		/* timer */
+	u8	count;		/* number of CRECORDS */
+	__be16	address;	/* address of CRECORD array in SRAM */
+	u8	res[3];
+} __packed;
+
+/**
+ * struct dcm_board - board-specific information
+ * @compatible: the 'compatible' property to search for
+ * @offsets: array of PIXIS address offsets (addr, data, dcmd, omsg, mack)
+ * @mask: enable mask for the OM_ENABLE command
+ * @convert_vout: board-specific function to convert a VOUT to millivolts
+ * @convert_iout: board-specific function to convert an IOUT to milliamps
+ * @convert_tout: board-specific function to convert a TOUT to degrees Celsius
+ * @ical: calibration factor for .convert_iout function
+ * @num: number of crecords (equal to the number of '1's in @mask)
+ * @names: array of names of each crecord
+ * @types: array of types of each crecord
+ */
+struct dcm_board {
+	const char *compatible;
+	unsigned int offsets[5];
+	u16 mask;
+	unsigned int (*convert_vout)(u16 vout);
+	unsigned int (*convert_iout)(u16 iout, unsigned int ical);
+	unsigned int (*convert_tout)(u16 tout);
+	unsigned int ical;
+	unsigned int num;
+	const char *names[MAX_CRECORDS];
+	enum crecord_type types[MAX_CRECORDS];
+};
+
+/* PIXIS register status bits */
+#define PX_OCMD_MSG	(1 << 0)
+#define PX_OACK_ERR	(1 << 1)
+#define PX_OACK_ACK	(1 << 0)	/* OACK is sometimes called MACK */
+
+/* DCM commands */
+#define OM_END			0x00
+#define OM_SETDLY		0x01
+#define OM_RST0			0x02
+#define OM_RST1			0x03
+#define OM_CHKDLY		0x04
+#define OM_PWR			0x05
+#define OM_WAKE			0x07
+#define OM_GETMEM		0x08
+#define OM_SETMEM		0x09
+#define OM_SCLR			0x10
+#define OM_START		0x11
+#define OM_STOP			0x12
+#define OM_GET			0x13
+#define OM_ENABLE		0x14
+#define OM_TIMER		0x15
+#define OM_SETV			0x30
+#define OM_INFO			0x31
+
+struct fsl_dcm_data {
+	struct device *dev;
+	const struct dcm_board *board;
+	void __iomem *base;	/* PIXIS/QIXIS base address */
+	u8 __iomem *addr;	/* SRAM address */
+	u8 __iomem *data;	/* SRAM data */
+	u8 __iomem *ocmd;	/* DCM command/status */
+	u8 __iomem *omsg;	/* DCM message */
+	u8 __iomem *mack;	/* DCM acknowledge */
+	struct crecord rec[MAX_CRECORDS];
+	u8 timer;
+	int running;
+};
+
+/*
+ * Converts a 16-bit VOUT value from the Zilker ZL6100 into a voltage value,
+ * in millivolts.
+ */
+static unsigned int voltage_from_zl6100(u16 vout)
+{
+	return (1000UL * vout) / (1 << 13);
+}
+
+/*
+ * Converts a 16-bit IOUT from the Texas Instruments INA220 chip into a
+ * current value, in milliamps.  'ical' is a board-specific calibration
+ * factor.
+ */
+static unsigned int current_from_ina220(u16 iout, unsigned int ical)
+{
+	unsigned long c;
+
+	/* milliamp = 1000 * ((iout / 100) / cal-factor) */
+	/*          = (iout * 100000) / ical         */
+	c = iout * 1000 * 100;
+	c /= ical;
+
+	return c;
+}
+
+/*
+ * Converts a 16-bit TOUT value from the sensor device into a temperature
+ * value, in degrees Celsius.
+ */
+static unsigned int temp_from_u16(u16 tout)
+{
+	return tout;
+}
+
+/*
+ * Write a byte to an address in SRAM
+ */
+static void write_sram(struct fsl_dcm_data *dcm, u8 offset, u8 v)
+{
+	out_8(dcm->addr, offset);
+	out_8(dcm->data, v);
+}
+
+/*
+ * Read a byte from an address in SRAM
+ */
+static u8 read_sram(struct fsl_dcm_data *dcm, u8 offset)
+{
+	out_8(dcm->addr, offset);
+
+	return in_8(dcm->data);
+}
+
+/*
+ * True TRUE if we can read/write SRAM, FALSE otherwise.
+ *
+ * If the SRAM is unavailable, it's probably because the DCM is busy with it.
+ */
+static int is_sram_available(struct fsl_dcm_data *dcm)
+{
+	u8 ack, cmd;
+
+	cmd = in_8(dcm->ocmd);
+	ack = in_8(dcm->mack);
+
+	if ((cmd & PX_OCMD_MSG) || (ack & PX_OACK_ACK)) {
+		dev_dbg(dcm->dev, "dcm is not ready (cmd=%02X mack=%02X)\n",
+			 cmd, ack);
+		return 0;
+	}
+
+	return 1;
+}
+
+/*
+ * Loads and program into SRAM, then tells the DCM to run it, and then waits
+ * for it to finish.
+ */
+static int run_program(struct fsl_dcm_data *dcm, u8 addr, unsigned int len, ...)
+{
+	u8 v, n;
+	va_list args;
+
+	if (addr + len > 0xff) {
+		dev_err(dcm->dev, "address/length of %u/%u is out of bounds\n",
+		       addr, len);
+		return 0;
+	}
+
+	/* load the program into SRAM */
+	va_start(args, len);
+	for (n = addr; n < addr + len; n++) {
+		v = va_arg(args, int);
+		write_sram(dcm, n, v);
+	}
+	va_end(args);
+
+	/* start the DCM */
+	out_8(dcm->omsg, addr);
+	out_8(dcm->ocmd, PX_OCMD_MSG);
+
+	/* wait for ack or error */
+	v = spin_event_timeout(in_8(dcm->mack) & (PX_OACK_ERR | PX_OACK_ACK),
+			       50000, 1000);
+	if ((!v) || (v & PX_OACK_ERR)) {
+		dev_err(dcm->dev, "timeout or error waiting for start ack\n");
+		return 0;
+	}
+
+	/* 4. allow the host to read SRAM */
+	out_8(dcm->ocmd, 0);
+
+	/* 5. wait for DCM to stop (ack == 0) or error (err == 1) */
+	spin_event_timeout(
+		((v = in_8(dcm->mack)) & (PX_OACK_ERR | PX_OACK_ACK)) != PX_OACK_ACK,
+		50000, 1000);
+
+	/* 6. check for error or timeout */
+	if (v & (PX_OACK_ERR | PX_OACK_ACK)) {
+		dev_err(dcm->dev, "timeout or error waiting for stop ack\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+#define TRATE0	241120		/* t-rate if prescale==0, in millihertz */
+#define TRATE1	38759330	/* t-rate if prescale==1, in millihertz */
+
+/*
+ * Empirical tests show that any frequency higher than 48Hz is unreliable.
+ */
+static int set_dcm_frequency(struct fsl_dcm_data *dcm, unsigned long frequency)
+{
+	unsigned long timer;
+
+	if (!is_sram_available(dcm)) {
+		dev_err(dcm->dev, "dcm is busy\n");
+		return 0;
+	}
+
+	/* Restrict the frequency to a supported range. */
+	frequency = clamp_t(unsigned long, frequency, 1, MAX_FREQUENCY);
+
+	/* We only support prescale == 0 */
+	timer = TRATE0 / frequency;
+	dcm->timer = (timer / 1000) - 1;
+
+	return run_program(dcm, 0, 6, OM_TIMER, 0, dcm->timer, 0, 0, OM_END);
+}
+
+static int copy_from_sram(struct fsl_dcm_data *dcm, unsigned int addr,
+			  void *buf, unsigned int len)
+{
+	u8 *p = buf;
+	unsigned int i;
+
+	if (addr + len > 0xff) {
+		dev_err(dcm->dev, "address/length of %u/%u is out of bounds\n",
+		       addr, len);
+		return 0;
+	}
+
+	for (i = 0; i < len; i++)
+		p[i] = read_sram(dcm, addr + i);
+
+	return 1;
+}
+
+/*
+ * Tells the DCM which channels to collect data on.
+ */
+static int select_dcm_channels(struct fsl_dcm_data *dcm, u16 mask)
+{
+	if (!is_sram_available(dcm)) {
+		dev_err(dcm->dev, "dcm is busy\n");
+		return 0;
+	}
+
+	return run_program(dcm, 0, 4, OM_ENABLE,
+		((mask >> 8) & 0xFF), mask & 0xFF, OM_END);
+}
+
+/*
+ * Tells the DCM to start data collection.  If the DCM is currently running,
+ * it is restarted.  Any currently collected data is cleared.
+ */
+static int start_data_collection(struct fsl_dcm_data *dcm)
+{
+	if (!is_sram_available(dcm)) {
+		dev_err(dcm->dev, "dcm is busy\n");
+		return 0;
+	}
+
+	if (dcm->running)
+		dev_dbg(dcm->dev, "restarting\n");
+
+	dcm->running = true;
+
+	return run_program(dcm, 0, 4, OM_STOP, OM_SCLR, OM_START, OM_END);
+}
+
+/*
+ * Tells the DCM to stop data collection.  Collected data is copied from
+ * SRAM into a local buffer.
+ */
+static int stop_data_collection(struct fsl_dcm_data *dcm)
+{
+	if (!dcm->running) {
+		dev_dbg(dcm->dev, "dcm is already stopped\n");
+		return 1;
+	}
+
+	if (!is_sram_available(dcm)) {
+		dev_err(dcm->dev, "dcm is busy\n");
+		return 0;
+	}
+
+	if (!run_program(dcm, 0, 4, OM_STOP, OM_GET, DATA_ADDR, OM_END)) {
+		dev_err(dcm->dev, "could not stop monitoring\n");
+		return 0;
+	}
+
+	if (!copy_from_sram(dcm, DATA_ADDR, dcm->rec,
+			    dcm->board->num * sizeof(struct crecord))) {
+		dev_err(dcm->dev, "could not copy sensor data\n");
+		return 0;
+	}
+
+	dcm->running = 0;
+	return 1;
+}
+
+ssize_t fsl_dcm_sysfs_control_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct fsl_dcm_data *dcm = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", dcm->running ? "running" : "stoppped");
+}
+
+ssize_t fsl_dcm_sysfs_control_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct fsl_dcm_data *dcm = dev_get_drvdata(dev);
+	unsigned long pm_cmd;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &pm_cmd);
+	if (ret)
+		return ret;
+
+	switch (pm_cmd) {
+	case SYSFS_DCM_CMD_START:
+		ret = start_data_collection(dcm);
+		if (!ret)
+			dev_err(dev, "failed to start power monitoring.\n");
+		break;
+	case SYSFS_DCM_CMD_STOP:
+		ret = stop_data_collection(dcm);
+		if (!ret)
+			dev_err(dev, "failed to stop power monitoring\n");
+		break;
+	default:
+		return -EIO;
+	}
+
+	return count;
+}
+
+/* Calculate the average, even if 'count' is zero */
+#define AVG(sum, count)	((sum) / ((count) ?: 1))
+
+static ssize_t fsl_dcm_sysfs_result(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct fsl_dcm_data *dcm = dev_get_drvdata(dev);
+	const struct dcm_board *board = dcm->board;
+	unsigned int i;
+	ssize_t len;
+
+	len = sprintf(buf,
+		"Name    Num        CURR         MAX              SUM       Max   Average\n"
+		"======  ===  ==========  ==========  ===============  ========  ========\n");
+
+	for (i = 0; i < board->num; i++) {
+		unsigned int num, max, avg;
+		const char *unit;
+
+		num = (dcm->rec[i].qty1 << 8) | (dcm->rec[i].qty2);
+
+		switch (board->types[i]) {
+		case CR_V:
+			max = board->convert_vout(dcm->rec[i].max);
+			avg = board->convert_vout(AVG(dcm->rec[i].acc, num));
+			unit = "mV";
+			break;
+		case CR_C:
+			max = board->convert_iout(dcm->rec[i].max, board->ical);
+			avg = board->convert_iout(AVG(dcm->rec[i].acc, num),
+						 board->ical);
+			unit = "mA";
+			break;
+		case CR_T:
+			max = board->convert_tout(dcm->rec[i].max);
+			avg = board->convert_tout(AVG(dcm->rec[i].acc, num));
+			unit = "C ";
+			break;
+		default:
+			continue;
+		}
+
+		len += sprintf(buf + len,
+			"%-6s  %3u  %5u/%04x  %5u/%04x  %8u/%06x %6d %s %6d %s\n",
+			board->names[i], num,
+			dcm->rec[i].curr, dcm->rec[i].curr,
+			dcm->rec[i].max, dcm->rec[i].max,
+			dcm->rec[i].acc, dcm->rec[i].acc,
+			max, unit, avg, unit);
+	}
+
+	return len;
+}
+
+ssize_t fsl_dcm_sysfs_info(struct device *dev, struct device_attribute *attr,
+	char *buf)
+{
+	struct fsl_dcm_data *dcm = dev_get_drvdata(dev);
+	struct om_info info;
+	ssize_t len;
+
+	if (!is_sram_available(dcm)) {
+		dev_err(dev, "dcm is busy\n");
+		return 0;
+	}
+
+	if (!run_program(dcm, 0, 2, OM_INFO, DATA_ADDR)) {
+		dev_err(dev, "could not run 'info' program\n");
+		return 0;
+	}
+
+	if (!copy_from_sram(dcm, DATA_ADDR, &info, sizeof(info))) {
+		dev_err(dev, "could not copy 'info' data\n");
+		return 0;
+	}
+
+	len = sprintf(buf, "DCM Version: %u\n", info.version);
+	len += sprintf(buf + len, "Prescale: %u\n", info.prescale);
+	len += sprintf(buf + len, "Timer: %u\n", info.timer);
+	len += sprintf(buf + len, "Number of CRECORDs: %u\n", info.count);
+	len += sprintf(buf + len, "CRECORD Address: %u\n", info.address);
+
+	return len;
+}
+
+ssize_t fsl_dcm_sysfs_frequency_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct fsl_dcm_data *dcm = dev_get_drvdata(dev);
+	unsigned long frequency;
+
+	frequency = TRATE0 / (dcm->timer + 1);
+
+	return sprintf(buf, "%lu Hz\n", frequency / 1000);
+}
+
+ssize_t fsl_dcm_sysfs_frequency_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct fsl_dcm_data *dcm = dev_get_drvdata(dev);
+	unsigned long frequency;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &frequency);
+	if (ret)
+		return ret;
+
+	set_dcm_frequency(dcm, frequency);
+
+	return count;
+}
+
+static DEVICE_ATTR(control, 0666, fsl_dcm_sysfs_control_show,
+		   fsl_dcm_sysfs_control_store);
+static DEVICE_ATTR(result, 0444, fsl_dcm_sysfs_result, NULL);
+static DEVICE_ATTR(info, 0444, fsl_dcm_sysfs_info, NULL);
+static DEVICE_ATTR(frequency, 0666, fsl_dcm_sysfs_frequency_show,
+		   fsl_dcm_sysfs_frequency_store);
+
+static const struct attribute_group fsl_dcm_attr_group = {
+	.attrs = (struct attribute *[]) {
+		&dev_attr_control.attr,
+		&dev_attr_result.attr,
+		&dev_attr_info.attr,
+		&dev_attr_frequency.attr,
+		NULL,
+	},
+};
+
+static int fsl_dcm_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct fsl_dcm_data *dcm;
+	int ret;
+
+	dcm = kzalloc(sizeof(struct fsl_dcm_data), GFP_KERNEL);
+	if (!dcm)
+		return -ENOMEM;
+
+	dcm->base = of_iomap(np, 0);
+	if (!dcm->base) {
+		dev_err(&pdev->dev, "could not map fpga node\n");
+		ret = -ENOMEM;
+		goto error_kzalloc;
+	}
+
+	dcm->dev = &pdev->dev;
+	dcm->board = pdev->dev.platform_data;
+
+	dcm->addr = dcm->base + dcm->board->offsets[0];
+	dcm->data = dcm->base + dcm->board->offsets[1];
+	dcm->ocmd = dcm->base + dcm->board->offsets[2];
+	dcm->omsg = dcm->base + dcm->board->offsets[3];
+	dcm->mack = dcm->base + dcm->board->offsets[4];
+
+	/* Check to make sure the DCM is enable and working */
+	if (!is_sram_available(dcm)) {
+		dev_err(&pdev->dev, "dcm is not responding\n");
+		ret = -ENODEV;
+		goto error_iomap;
+	}
+
+	dev_set_drvdata(&pdev->dev, dcm);
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &fsl_dcm_attr_group);
+	if (ret) {
+		dev_err(&pdev->dev, "could not create sysfs group\n");
+		goto error_iomap;
+	}
+
+	if (!select_dcm_channels(dcm, dcm->board->mask)) {
+		dev_err(&pdev->dev, "could not set crecord mask\n");
+		ret = -ENODEV;
+		goto error_sysfs;
+	}
+
+	/* Set the timer to the fastest support rate. */
+	if (!set_dcm_frequency(dcm, MAX_FREQUENCY)) {
+		dev_err(&pdev->dev, "could not set frequency\n");
+		ret = -ENODEV;
+		goto error_sysfs;
+	}
+
+	return 0;
+
+error_sysfs:
+	sysfs_remove_group(&pdev->dev.kobj, &fsl_dcm_attr_group);
+
+error_iomap:
+	iounmap(dcm->base);
+
+error_kzalloc:
+	kfree(dcm);
+
+	return ret;
+}
+
+static int fsl_dcm_remove(struct platform_device *pdev)
+{
+	struct fsl_dcm_data *dcm = dev_get_drvdata(&pdev->dev);
+
+	stop_data_collection(dcm);
+
+	sysfs_remove_group(&pdev->dev.kobj, &fsl_dcm_attr_group);
+
+	iounmap(dcm->base);
+	kfree(dcm);
+
+	return 0;
+}
+
+static struct platform_driver fsl_dcm_platform_driver = {
+	.probe = fsl_dcm_probe,
+	.remove = fsl_dcm_remove,
+	.driver	= {
+		.name = "fsl-dcm",
+		.owner = THIS_MODULE,
+	},
+};
+
+static const struct dcm_board dcm_types[] = {
+	{
+		"fsl,p1022ds-pixis",
+		{ 0x0a, 0x0d, 0x14, 0x15, 0x18},
+		0x155,
+		voltage_from_zl6100,
+		NULL,
+		temp_from_u16,
+		0,
+		5,
+		/* Current measurements are not reliable on this board */
+		{"Vdd", "OVdd", "S/XVdd", "GVdd", "CPU_Tj"},
+		{CR_V, CR_V, CR_V, CR_V, CR_T},
+	},
+	{
+		"fsl,p3060qds-pixis",
+		{ 0x12, 0x13, 0x14, 0x15, 0x18},
+		0x1ff,
+		voltage_from_zl6100,
+		current_from_ina220,
+		temp_from_u16,
+		10328,
+		9,
+		{"Vdd_CA", "Idd_CA", "Vdd_CB", "Idd_CB", "Vdd_PL", "Idd_PL",
+			"GVdd", "GIdd", "CPU_Tj"},
+		{CR_V, CR_C, CR_V, CR_C, CR_V, CR_C, CR_V, CR_C, CR_T},
+	},
+	{
+		"fsl,p4080ds-pixis",
+		{ 0x0a, 0x0d, 0x14, 0x15, 0x18},
+		0x155,
+		voltage_from_zl6100,
+		NULL,
+		temp_from_u16,
+		0,
+		5,
+		/* Current measurements are not reliable on this board */
+		{"Vdd_CA", "Vdd_CB", "Vdd_PL", "GVdd", "CPU_Tj"},
+		{CR_V, CR_V, CR_V, CR_V, CR_T},
+	},
+	{
+		"fsl,p5020ds-pixis",
+		{ 0x0a, 0x0d, 0x14, 0x15, 0x18},
+		0x1ff,
+		voltage_from_zl6100,
+		current_from_ina220,
+		temp_from_u16,
+		21064,
+		9,
+		{"Vdd_CA", "Idd_CA", "Vdd_CB", "Idd_CB", "Vdd_PL", "Idd_PL",
+			"GVdd", "GIdd", "CPU_Tj"},
+		{CR_V, CR_C, CR_V, CR_C, CR_V, CR_C, CR_V, CR_C, CR_T},
+	},
+};
+
+static int __init fsl_dcm_init(void)
+{
+	struct platform_device *pdev;
+	struct device_node *np = NULL;
+	unsigned int i;
+	int ret;
+
+	/* Look for a supported platform */
+	for (i = 0; i < ARRAY_SIZE(dcm_types); i++) {
+		np = of_find_compatible_node(NULL, NULL,
+					     dcm_types[i].compatible);
+		if (np)
+			break;
+	}
+	if (!np) {
+		pr_debug("fsl-dcm: unsupported platform\n");
+		return -ENODEV;
+	}
+
+	/* We found a supported platform, so register a platform driver */
+	ret = platform_driver_register(&fsl_dcm_platform_driver);
+	if (ret) {
+		pr_err("fsl-dcm: could not register platform driver\n");
+		goto error_np;
+	}
+
+	/* We need to create a device and add the data for this platform */
+	pdev = platform_device_alloc(fsl_dcm_platform_driver.driver.name, 0);
+	if (!pdev) {
+		ret = -ENOMEM;
+		goto error_drv;
+	}
+
+	/* Pass the device_node pointer to the probe function */
+	pdev->dev.of_node = np;
+
+	/* Pass the DCM platform data */
+	ret = platform_device_add_data(pdev, &dcm_types[i],
+				 sizeof(struct dcm_board));
+	if (ret) {
+		pr_err("fsl-dcm: could not register platform driver\n");
+		goto error_dev;
+	}
+
+	/* This will call the probe function */
+	ret = platform_device_add(pdev);
+	if (ret) {
+		pr_err("fsl-dcm: could not register platform driver\n");
+		goto error_dev;
+	}
+
+	of_node_put(np);
+
+	return 0;
+
+error_dev:
+	platform_device_unregister(pdev);
+
+error_drv:
+	platform_driver_unregister(&fsl_dcm_platform_driver);
+
+error_np:
+	of_node_put(np);
+
+	return ret;
+}
+
+static void __exit fsl_dcm_exit(void)
+{
+	platform_driver_unregister(&fsl_dcm_platform_driver);
+}
+
+MODULE_AUTHOR("Timur Tabi <timur@freescale.com>");
+MODULE_DESCRIPTION("Freescale Data Collection Manager driver");
+MODULE_LICENSE("GPL v2");
+
+module_init(fsl_dcm_init);
+module_exit(fsl_dcm_exit);
-- 
1.7.3.4


