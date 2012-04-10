Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab2DJNFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:05:24 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39974 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab2DJNFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:05:22 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH RESEND] x86, intel_mid: ADC management
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Date: Tue, 10 Apr 2012 14:20:05 +0100
Message-ID: <20120410131930.28186.85370.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ended in a discussion of where shall we put it and then silence so
resending this because we still need it and we've got patches that depend
upon it getting backlogged.

From: Alan Cox <alan@linux.intel.com>

This is a fold up of the following ported to 3.3


commit f81040398e4b45323d4144fb05c126245e86866d
Author: Mika Westerberg <mika.westerberg@linux.intel.com>
Date:   Thu Jan 12 11:51:18 2012 +0200

    x86, mrst: add platform data for gpadc driver

    Now that the driver is converted to use intel_msic interfaces we can add
    the platform data back.

    Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 6d9d2d390f6e18ce1d419b9e2762c9bf139a80ea
Author: Mika Westerberg <mika.westerberg@linux.intel.com>
Date:   Thu Jan 12 11:51:17 2012 +0200

    gpadc: convert to use intel_msic

    In Medfield all the subdevices in MSIC chip are handled by intel_msic MFD
    driver. This patch converts gpadc driver to use interfaces provided by
    intel_msic driver.

    This will enable all the users (including sn95031 audio codec) to use gpadc
    again.

    Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>


commit f1532c8454b8958aee933a9915862345d62ee3f8
Author: Mika Westerberg <mika.westerberg@linux.intel.com>
Date:   Thu Jan 12 11:51:16 2012 +0200

    x86, mrst: remove gpadc platform data

    Nowadays these devices are handled by intel_msic MFD driver which has
    slightly different way of passing platform data to the drivers.

    So as a first step we remove the old platform data for gpadc driver. In
    subsequent patches we add it back in such format suitable for intel_msic
    driver.

    Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 8444512429fd93786f114824bb5c258272aa1d2d
Author: Bin Yang <bin.yang@intel.com>
Date:   Tue Oct 18 14:16:31 2011 +0100

    gpadc: add reg dump after timeout

    Sometimes, it is very hard to duplicate ADC timeout issue.
    Some issue only can be duplicated on a small quantity of boards.
    To add the registers dump after timeout will help debugging.

    Signed-off-by: Bin Yang <bin.yang@intel.com>

commit 26fc6e4e72d1cac189064b9c85290e3c8a907cf0
Author: Bin Yang <bin.yang@intel.com>
Date:   Tue Oct 18 14:16:30 2011 +0100

    gpadc: fix battery temp accuracy

    From oscilloscope result, BPTHERM takes <1ms to stabilize.
    So it needs to add 1ms delay after VBUSREF is enabled.

    Signed-off-by: Bin Yang <bin.yang@intel.com>

commit 9dc5019e570c59e70349b34ec864bfc447a0d0c5
Author: Bin Yang <bin.yang@intel.com>
Date:   Tue Oct 18 14:16:30 2011 +0100

    gpadc: optimize driver initialization

    ADC trimming cost a long time. It blocks the kernel boot sequence.
    Change to do trimming in a single workqueue.

    Signed-off-by: Bin Yang <bin.yang@intel.com>

commit 16149d8e3dfe0d663851318390ebafdede760281
Author: Bin Yang <bin.yang@intel.com>
Date:   Tue Oct 18 14:16:29 2011 +0100

    gpadc: read sample result in one loop

    RR bit is used to inform HW for sample result read.
    it needs to hold the RR bit for all channels result read.

    this patch moves the lines to set/clear RR bit outside the loop.

    Signed-off-by: Bin Yang <bin.yang@intel.com>

commit d910dd3b07b6e0766c96c59e48de5bcce1175f0c
Author: Bin Yang <bin.yang@intel.com>
Date:   Tue Oct 18 14:16:29 2011 +0100

    gpadc: fix logic err of last addr checking

    it has logic error to check last addr which is used.

    Signed-off-by: Bin Yang <bin.yang@intel.com>

commit 1b688193bd96331da73482399925d51cbf535780
Author: Bin Yang <bin.yang@intel.com>
Date:   Tue Oct 18 14:16:28 2011 +0100

    gpadc: update the calibration algorithm

    gpadc document had updated this algorithm in new version.

    This patch updates the driver base on new  document.

    Signed-off-by: Bin Yang <bin.yang@intel.com>

commit baa74900a34ad17de1619a8f009702e66eb4fbd4
Author: Bin Yang <bin.yang@intel.com>
Date:   Tue Oct 18 14:16:28 2011 +0100

    gpadc: fix sample result error

    During stress test, ADC results have some bad valules.
    Driver has a race condition issue. It initializes the output data to 0 first
    without any lock. And the caller may access the output pointer before function
    return.

    This patch moves the output data initializing code inside mutex protected period.
    And it also adds a limitation which forbid caller to access output pointer
    before function return.

    Signed-off-by: Bin Yang <bin.yang@intel.com>

commit 9c53a361051541a7cb24a8fde90d5c75c5d52d91
Author: He Bo <bo.he@intel.com>
Date:   Tue Oct 18 14:16:26 2011 +0100

    gpadc: system does not enter S3 after incoming call

    intel_mid_gpadc driver causes deadlock in S3, fix it.

    Signed-off-by: He Bo <bo.he@intel.com>

commit f25e645c187d3b9943ad0180e52984f51c77e64b
Author: Bin Yang <bin.yang@intel.com>
Date:   Tue Oct 18 14:16:25 2011 +0100

    gpadc: prevent CPU from S0i3 when ADC is active

    Under the following scenario:
    	1. IPC1 request sent to SCU
    	2. PM_CMD s0ix entry request sent to SCU
    	3. MWAIT C6 abort (or no attempt at MWAIT C6)
    	If steps #1 an #2 are sufficiently close (maybe within 200us) there is
    a possibility that SCU will handle the PM_CMD first and begin waiting on an
    ack_c6 response from the MWAIT that is expected. Since the MWAIT never comes
    (or is aborted) SCU will have to eventually time out before being able to move
    on and handle the IPC1 request.

    Signed-off-by: Bin Yang <bin.yang@intel.com>
    [ port to new pm_qos_add_request() interface -Guanqun ]
    Signed-off-by: Lu Guanqun <guanqun.lu@intel.com>

commit fdd0adef95e6b5836cc4ed5764a398b81841945d
Author: Bin Yang <bin.yang@intel.com>
Date:   Tue Oct 18 14:16:23 2011 +0100

    The coulomb count interrupt is not used by kernel driver. It needs to be
    handled inside firmware.

    Signed-off-by: Bin Yang <bin.yang@intel.com>

commit 1f4f11af853a74c015a9ffb5bc22d3f9140ce6d5
Author: Bin Yang <bin.yang@intel.com>
Date:   Tue Oct 18 14:16:19 2011 +0100

    gpadc: add gpadc driver support

    The general purpose ADC inside MSIC is used by battery and thermal.  This
    driver provides the channel allocation and basic ADC functions.

    Signed-off-by: Bin Yang <bin.yang@intel.com>
    Signed-off-by: Hao Wu <hao.wu@intel.com>



Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/include/asm/intel_mid_gpadc.h   |   13 +
 arch/x86/platform/mrst/Makefile          |    1 
 arch/x86/platform/mrst/intel_mid_gpadc.c |  645 ++++++++++++++++++++++++++++++
 arch/x86/platform/mrst/mrst.c            |    6 
 4 files changed, 665 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/intel_mid_gpadc.h
 create mode 100644 arch/x86/platform/mrst/intel_mid_gpadc.c


diff --git a/arch/x86/include/asm/intel_mid_gpadc.h b/arch/x86/include/asm/intel_mid_gpadc.h
new file mode 100644
index 0000000..ae79309
--- /dev/null
+++ b/arch/x86/include/asm/intel_mid_gpadc.h
@@ -0,0 +1,13 @@
+#ifndef __INTEL_MID_GPADC_H__
+#define __INTEL_MID_GPADC_H__
+
+#define CH_NEED_VREF		(1 << 8)
+#define CH_NEED_VCALIB		(1 << 9)
+#define CH_NEED_ICALIB		(1 << 10)
+
+int intel_mid_gpadc_gsmpulse_sample(int *vol, int *cur);
+int intel_mid_gpadc_sample(void *handle, int sample_count, ...);
+void intel_mid_gpadc_free(void *handle);
+void *intel_mid_gpadc_alloc(int count, ...);
+#endif
+
diff --git a/arch/x86/platform/mrst/Makefile b/arch/x86/platform/mrst/Makefile
index af1da7e..66e006c 100644
--- a/arch/x86/platform/mrst/Makefile
+++ b/arch/x86/platform/mrst/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_X86_INTEL_MID)	+= mrst.o
 obj-$(CONFIG_X86_INTEL_MID)	+= vrtc.o
 obj-$(CONFIG_EARLY_PRINTK_INTEL_MID)	+= early_printk_mrst.o
+obj-$(CONFIG_X86_INTEL_MID)	+= intel_mid_gpadc.o
diff --git a/arch/x86/platform/mrst/intel_mid_gpadc.c b/arch/x86/platform/mrst/intel_mid_gpadc.c
new file mode 100644
index 0000000..6927cae
--- /dev/null
+++ b/arch/x86/platform/mrst/intel_mid_gpadc.c
@@ -0,0 +1,645 @@
+/*
+ * intel_msic_gpadc.c - Intel Medfield MSIC GPADC Driver
+ *
+ * Copyright (C) 2010 Intel Corporation
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * Author: Jenny TC <jenny.tc@intel.com>
+ * Author: Bin Yang <bin.yang@intel.com>
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include <linux/platform_device.h>
+#include <linux/pm_qos.h>
+#include <linux/workqueue.h>
+#include <linux/mfd/intel_msic.h>
+#include <asm/intel_mid_gpadc.h>
+
+#define EEPROMCAL1		0x317
+#define EEPROMCAL2		0x318
+
+#define MCCINT_MCCCAL		(1 << 1)
+#define MCCINT_MOVERFLOW	(1 << 0)
+
+#define IRQLVL1MSK_ADCM		(1 << 1)
+
+#define ADC1CNTL1_AD1OFFSETEN	(1 << 6)
+#define ADC1CNTL1_AD1CALEN	(1 << 5)
+#define ADC1CNTL1_ADEN		(1 << 4)
+#define ADC1CNTL1_ADSTRT	(1 << 3)
+#define ADC1CNTL1_ADSLP		7
+#define ADC1CNTL1_ADSLP_DEF	1
+
+#define ADC1INT_ADC1CAL		(1 << 2)
+#define ADC1INT_GSM		(1 << 1)
+#define ADC1INT_RND		(1 << 0)
+
+#define ADC1CNTL3_ADCTHERM	(1 << 2)
+#define ADC1CNTL3_GSMDATARD	(1 << 1)
+#define ADC1CNTL3_RRDATARD	(1 << 0)
+
+#define ADC1CNTL2_DEF		0x7
+#define ADC1CNTL2_ADCGSMEN	(1 << 7)
+
+#define MSIC_STOPCH		(1 << 4)
+
+#define GPADC_CH_MAX		15
+
+#define PM_QOS_ADC_DRV_VALUE	4999
+
+#define GPADC_POWERON_DELAY	1
+
+struct gpadc_info {
+	int initialized;
+
+	struct workqueue_struct *workq;
+	wait_queue_head_t trimming_wait;
+	struct work_struct trimming_work;
+	int trimming_start;
+
+	/* This mutex protects gpadc sample/config from concurrent conflict.
+	   Any function, which does the sample or config, needs to
+	   hold this lock.
+	   If it is locked, it also means the gpadc is in active mode.
+	   GSM mode sample does not need to hold this lock. It can be used with
+	   normal sample concurrent without poweron.
+	*/
+	struct mutex lock;
+	struct device *dev;
+	int irq;
+	u8 irq_status;
+
+	int vzse;
+	int vge;
+	int izse;
+	int ige;
+	int addr_mask;
+
+	wait_queue_head_t wait;
+	int rnd_done;
+	int conv_done;
+	int gsmpulse_done;
+
+	struct pm_qos_request pm_qos_request;
+};
+
+struct gpadc_request {
+	int count;
+	int vref;
+	int ch[GPADC_CH_MAX];
+	int addr[GPADC_CH_MAX];
+};
+
+static struct gpadc_info gpadc_info;
+
+static inline int gpadc_clear_bits(u16 addr, u8 mask)
+{
+	return intel_msic_reg_update(addr, 0, mask);
+}
+
+static inline int gpadc_set_bits(u16 addr, u8 mask)
+{
+	return intel_msic_reg_update(addr, 0xff, mask);
+}
+
+static inline int gpadc_write(u16 addr, u8 data)
+{
+	return intel_msic_reg_write(addr, data);
+}
+
+static inline int gpadc_read(u16 addr, u8 *data)
+{
+	return intel_msic_reg_read(addr, data);
+}
+
+static void gpadc_dump(struct gpadc_info *mgi)
+{
+	u8 data;
+	int i;
+
+	gpadc_read(INTEL_MSIC_VAUDACNT, &data);
+	dev_err(mgi->dev, "VAUDACNT: 0x%x\n", data);
+	gpadc_read(INTEL_MSIC_IRQLVL1MSK, &data);
+	dev_err(mgi->dev, "IRQLVL1MSK: 0x%x\n", data);
+	gpadc_read(INTEL_MSIC_IRQLVL1, &data);
+	dev_err(mgi->dev, "IRQLVL1: 0x%x\n", data);
+	gpadc_read(INTEL_MSIC_ADC1INT, &data);
+	dev_err(mgi->dev, "ADC1INT: 0x%x\n", data);
+	gpadc_read(INTEL_MSIC_ADC1CNTL1, &data);
+	dev_err(mgi->dev, "ADC1CNTL1: 0x%x\n", data);
+	gpadc_read(INTEL_MSIC_ADC1CNTL2, &data);
+	dev_err(mgi->dev, "ADC1CNTL2: 0x%x\n", data);
+	gpadc_read(INTEL_MSIC_ADC1CNTL3, &data);
+	dev_err(mgi->dev, "ADC1CNTL3: 0x%x\n", data);
+	for (i = 0; i < GPADC_CH_MAX; i++) {
+		gpadc_read(INTEL_MSIC_ADC1ADDR0+i, &data);
+		dev_err(mgi->dev, "ADC1ADDR[%d]: 0x%x\n", i, data);
+	}
+}
+
+static int gpadc_poweron(struct gpadc_info *mgi, int vref)
+{
+	if (gpadc_set_bits(INTEL_MSIC_ADC1CNTL1, ADC1CNTL1_ADEN) != 0)
+		return -EIO;
+	msleep(GPADC_POWERON_DELAY);
+	if (vref) {
+		if (gpadc_set_bits(INTEL_MSIC_ADC1CNTL3,
+				   ADC1CNTL3_ADCTHERM) != 0)
+			return -EIO;
+		msleep(GPADC_POWERON_DELAY);
+	}
+	return 0;
+}
+
+static int gpadc_poweroff(struct gpadc_info *mgi)
+{
+	if (gpadc_clear_bits(INTEL_MSIC_ADC1CNTL1, ADC1CNTL1_ADEN) != 0)
+		return -EIO;
+	if (gpadc_clear_bits(INTEL_MSIC_ADC1CNTL3, ADC1CNTL3_ADCTHERM) != 0)
+		return -EIO;
+	return 0;
+}
+
+static void gpadc_trimming(struct work_struct *work)
+{
+	u8 data;
+	int fse, zse, fse_sign, zse_sign;
+	struct gpadc_info *mgi =
+		container_of(work, struct gpadc_info, trimming_work);
+
+	mutex_lock(&mgi->lock);
+	mgi->trimming_start = 1;
+	wake_up(&mgi->trimming_wait);
+	if (gpadc_poweron(mgi, 1)) {
+		dev_err(mgi->dev, "power on failed\n");
+		goto failed;
+	}
+	/* calibration */
+	gpadc_read(INTEL_MSIC_ADC1CNTL1, &data);
+	data &= ~ADC1CNTL1_AD1OFFSETEN;
+	data |= ADC1CNTL1_AD1CALEN;
+	gpadc_write(INTEL_MSIC_ADC1CNTL1, data);
+	gpadc_read(INTEL_MSIC_ADC1INT, &data);
+
+	/*workaround: no calib int */
+	msleep(300);
+	gpadc_set_bits(INTEL_MSIC_ADC1INT, ADC1INT_ADC1CAL);
+	gpadc_clear_bits(INTEL_MSIC_ADC1CNTL1, ADC1CNTL1_AD1CALEN);
+
+	/* voltage trim */
+	gpadc_read(EEPROMCAL1, &data);
+	zse = (data & 0xf)/2;
+	fse = ((data >> 4) & 0xf)/2;
+	gpadc_read(EEPROMCAL2, &data);
+	zse_sign = (data & (1 << 6)) ? 1 : 0;
+	fse_sign = (data & (1 << 7)) ? 1 : 0;
+	zse *= zse_sign;
+	fse *= fse_sign;
+	mgi->vzse = zse;
+	mgi->vge = fse - zse;
+
+	/* current trim */
+	fse = (data & 0xf)/2;
+	fse_sign = (data & (1 << 5)) ? 1 : 0;
+	fse = ~(fse_sign * fse) + 1;
+	gpadc_read(INTEL_MSIC_ADC1OFFSETH, &data);
+	zse = data << 2;
+	gpadc_read(INTEL_MSIC_ADC1OFFSETL, &data);
+	zse += data & 0x3;
+	mgi->izse = zse;
+	mgi->ige = fse + zse;
+	if (gpadc_poweroff(mgi)) {
+		dev_err(mgi->dev, "power off failed\n");
+		goto failed;
+	}
+
+failed:
+	mutex_unlock(&mgi->lock);
+}
+
+static irqreturn_t msic_gpadc_isr(int irq, void *data)
+{
+	struct gpadc_info *mgi = data;
+	struct intel_msic *msic = dev_get_drvdata(mgi->dev->parent);
+	int ret;
+
+	ret = intel_msic_irq_read(msic, INTEL_MSIC_ADC1INT, &mgi->irq_status);
+	if (ret < 0)
+		dev_warn(mgi->dev, "failed to read IRQ status\n");
+
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t msic_gpadc_irq(int irq, void *data)
+{
+	struct gpadc_info *mgi = data;
+
+	if (mgi->irq_status & ADC1INT_GSM) {
+		mgi->gsmpulse_done = 1;
+		wake_up(&mgi->wait);
+	} else if (mgi->irq_status & ADC1INT_RND) {
+		mgi->rnd_done = 1;
+		wake_up(&mgi->wait);
+	} else if (mgi->irq_status & ADC1INT_ADC1CAL) {
+		mgi->conv_done = 1;
+		wake_up(&mgi->wait);
+	} else {
+		/* coulomb counter should be handled by firmware. Ignore it */
+		dev_dbg(mgi->dev, "coulomb counter is not support\n");
+	}
+	return IRQ_HANDLED;
+}
+
+static int alloc_channel_addr(struct gpadc_info *mgi, int ch)
+{
+	int i;
+	int addr = -EBUSY;
+	int last = 0;
+
+	for (i = 0; i < GPADC_CH_MAX; i++)
+		if (mgi->addr_mask & (1 << i))
+			last = i;
+
+	for (i = 0; i < GPADC_CH_MAX; i++) {
+		if (!(mgi->addr_mask & (1 << i))) {
+			addr = i;
+			mgi->addr_mask |= 1 << i;
+			if (addr > last) {
+				gpadc_clear_bits(INTEL_MSIC_ADC1ADDR0+last,
+						 MSIC_STOPCH);
+				gpadc_write(INTEL_MSIC_ADC1ADDR0+addr,
+					    ch|MSIC_STOPCH);
+			} else {
+				gpadc_write(INTEL_MSIC_ADC1ADDR0+addr, ch);
+			}
+			break;
+		}
+	}
+	return addr;
+}
+
+static void free_channel_addr(struct gpadc_info *mgi, int addr)
+{
+	int last = 0;
+	int i;
+
+	mgi->addr_mask &= ~(1 << addr);
+	for (i = 0; i < GPADC_CH_MAX; i++)
+		if (mgi->addr_mask & (1 << i))
+			last = i;
+	if (addr > last)
+		gpadc_set_bits(INTEL_MSIC_ADC1ADDR0+last, MSIC_STOPCH);
+}
+
+/**
+ * intel_mid_gpadc_gsmpulse_sample - do gpadc sample during gsm pulse.
+ * @val: return the voltage value. caller should not access it before return.
+ * @cur: return the current value. caller should not access it before return.
+ *
+ * Returns 0 on success or an error code.
+ *
+ * This function may sleep.
+ */
+int intel_mid_gpadc_gsmpulse_sample(int *vol, int *cur)
+{
+	struct gpadc_info *mgi = &gpadc_info;
+	int i;
+	u8 data;
+	int tmp;
+	int ret = 0;
+
+	if (!mgi->initialized)
+		return -ENODEV;
+
+	mutex_lock(&mgi->lock);
+	pm_qos_add_request(&mgi->pm_qos_request,
+			   PM_QOS_CPU_DMA_LATENCY, PM_QOS_ADC_DRV_VALUE);
+	gpadc_write(INTEL_MSIC_ADC1CNTL2, ADC1CNTL2_DEF);
+	gpadc_set_bits(INTEL_MSIC_ADC1CNTL2, ADC1CNTL2_ADCGSMEN);
+
+	if (wait_event_timeout(mgi->wait, mgi->gsmpulse_done, HZ) == 0) {
+		gpadc_dump(mgi);
+		dev_err(mgi->dev, "gsmpulse sample timeout\n");
+		ret = -ETIMEDOUT;
+		goto fail;
+	}
+	gpadc_clear_bits(INTEL_MSIC_ADC1CNTL1, ADC1CNTL1_ADEN);
+	gpadc_set_bits(INTEL_MSIC_ADC1CNTL3, ADC1CNTL3_GSMDATARD);
+
+	*vol = 0;
+	*cur = 0;
+	for (i = 0; i < 4; i++) {
+		gpadc_read(INTEL_MSIC_ADC1BV0H + i * 2, &data);
+		tmp = data << 2;
+		gpadc_read(INTEL_MSIC_ADC1BV0H + i * 2 + 1, &data);
+		tmp += data & 0x3;
+		if (tmp > *vol)
+			*vol = tmp;
+
+		gpadc_read(INTEL_MSIC_ADC1BI0H + i * 2, &data);
+		tmp = data << 2;
+		gpadc_read(INTEL_MSIC_ADC1BI0H + i * 2 + 1, &data);
+		tmp += data & 0x3;
+		if (tmp > *cur)
+			*cur = tmp;
+	}
+
+	/**
+	 * Using the calibration data, we have the voltage and current
+	 * after calibration correction as below:
+	 * V_CAL_CODE = V_RAW_CODE - (VZSE + (VGE)* VRAW_CODE/1023)
+	 * I_CAL_CODE = I_RAW_CODE - (IZSE + (IGE)* IRAW_CODE/1023)
+	*/
+	*vol -= mgi->vzse + mgi->vge * (*vol) / 1023;
+	*cur -= mgi->izse + mgi->ige * (*cur) / 1023;
+
+	gpadc_set_bits(INTEL_MSIC_ADC1INT, ADC1INT_GSM);
+	gpadc_clear_bits(INTEL_MSIC_ADC1CNTL3, ADC1CNTL3_GSMDATARD);
+fail:
+	gpadc_clear_bits(INTEL_MSIC_ADC1CNTL2, ADC1CNTL2_ADCGSMEN);
+	pm_qos_remove_request(&mgi->pm_qos_request);
+	mutex_unlock(&mgi->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(intel_mid_gpadc_gsmpulse_sample);
+
+/**
+ * intel_mid_gpadc_sample - do gpadc sample.
+ * @handle: the gpadc handle
+ * @sample_count: do sample serveral times and get the average value.
+ * @...: sampling resulting arguments of all channels. Caller should not
+ *	 access it before return.
+ *
+ * Returns 0 on success or an error code.
+ *
+ * This function may sleep.
+ */
+int intel_mid_gpadc_sample(void *handle, int sample_count, ...)
+{
+
+	struct gpadc_request *rq = handle;
+	struct gpadc_info *mgi = &gpadc_info;
+	int i;
+	u8 data;
+	int ret = 0;
+	int count;
+	int tmp;
+	int *val[GPADC_CH_MAX];
+	va_list args;
+
+	if (!mgi->initialized)
+		return -ENODEV;
+
+	mutex_lock(&mgi->lock);
+	va_start(args, sample_count);
+	for (i = 0; i < rq->count; i++) {
+		val[i] = va_arg(args, int*);
+		*val[i] = 0;
+	}
+	va_end(args);
+
+	pm_qos_add_request(&mgi->pm_qos_request,
+			   PM_QOS_CPU_DMA_LATENCY, PM_QOS_ADC_DRV_VALUE);
+	gpadc_poweron(mgi, rq->vref);
+	gpadc_clear_bits(INTEL_MSIC_ADC1CNTL1, ADC1CNTL1_AD1OFFSETEN);
+	gpadc_read(INTEL_MSIC_ADC1CNTL1, &data);
+	data = (data & ~ADC1CNTL1_ADSLP) + ADC1CNTL1_ADSLP_DEF;
+	gpadc_write(INTEL_MSIC_ADC1CNTL1, data);
+	mgi->rnd_done = 0;
+	gpadc_set_bits(INTEL_MSIC_ADC1CNTL1, ADC1CNTL1_ADSTRT);
+	for (count = 0; count < sample_count; count++) {
+		if (wait_event_timeout(mgi->wait, mgi->rnd_done, HZ) == 0) {
+			gpadc_dump(mgi);
+			dev_err(mgi->dev, "sample timeout\n");
+			ret = -ETIMEDOUT;
+			goto fail;
+		}
+		gpadc_set_bits(INTEL_MSIC_ADC1CNTL3, ADC1CNTL3_RRDATARD);
+		for (i = 0; i < rq->count; ++i) {
+			tmp = 0;
+			gpadc_read(INTEL_MSIC_ADC1SNS0H + 2 * rq->addr[i],
+				   &data);
+			tmp += data << 2;
+			gpadc_read(INTEL_MSIC_ADC1SNS0H + 2 * rq->addr[i] + 1,
+				   &data);
+			tmp += data & 0x3;
+
+			/**
+			 * Using the calibration data, we have the voltage and
+			 * current after calibration correction as below:
+			 * V_CAL_CODE = V_RAW_CODE - (VZSE+(VGE)*VRAW_CODE/1023)
+			 * I_CAL_CODE = I_RAW_CODE - (IZSE+(IGE)*IRAW_CODE/1023)
+			 */
+			if (rq->ch[i] & CH_NEED_VCALIB)
+				tmp -= mgi->vzse + mgi->vge * tmp / 1023;
+			if (rq->ch[i] & CH_NEED_ICALIB)
+				tmp -= mgi->izse + mgi->ige * tmp / 1023;
+			*val[i] += tmp;
+		}
+		gpadc_clear_bits(INTEL_MSIC_ADC1CNTL3, ADC1CNTL3_RRDATARD);
+		mgi->rnd_done = 0;
+	}
+
+	for (i = 0; i < rq->count; ++i)
+		*val[i] /= sample_count;
+
+fail:
+	gpadc_clear_bits(INTEL_MSIC_ADC1CNTL1, ADC1CNTL1_ADSTRT);
+	gpadc_poweroff(mgi);
+	pm_qos_remove_request(&mgi->pm_qos_request);
+	mutex_unlock(&mgi->lock);
+	return ret;
+}
+EXPORT_SYMBOL(intel_mid_gpadc_sample);
+
+/**
+ * intel_mid_gpadc_free - free gpadc
+ * @handle: the gpadc handle
+ *
+ * This function may sleep.
+ */
+void intel_mid_gpadc_free(void *handle)
+{
+	struct gpadc_request *rq = handle;
+	struct gpadc_info *mgi = &gpadc_info;
+	int i;
+
+	mutex_lock(&mgi->lock);
+	for (i = 0; i < rq->count; i++)
+		free_channel_addr(mgi, rq->addr[i]);
+	mutex_unlock(&mgi->lock);
+	kfree(rq);
+}
+EXPORT_SYMBOL(intel_mid_gpadc_free);
+
+/**
+ * intel_mid_gpadc_alloc - allocate gpadc for channels
+ * @count: the count of channels
+ * @...: the channel parameters. (channel idx | flags)
+ *       flags:
+ *             CH_NEED_VCALIB   it needs voltage calibration
+ *             CH_NEED_ICALIB   it needs current calibration
+ *
+ * Returns gpadc handle on success or NULL on fail.
+ *
+ * This function may sleep.
+ */
+void *intel_mid_gpadc_alloc(int count, ...)
+{
+	struct gpadc_request *rq;
+	struct gpadc_info *mgi = &gpadc_info;
+	va_list args;
+	int ch;
+	int i;
+
+	if (!mgi->initialized)
+		return NULL;
+
+	rq = kzalloc(sizeof(struct gpadc_request), GFP_KERNEL);
+	if (rq == NULL)
+		return NULL;
+
+	va_start(args, count);
+	mutex_lock(&mgi->lock);
+	rq->count = count;
+	for (i = 0; i < count; i++) {
+		ch = va_arg(args, int);
+		rq->ch[i] = ch;
+		if (ch & CH_NEED_VREF)
+			rq->vref = 1;
+		ch &= 0xf;
+		rq->addr[i] = alloc_channel_addr(mgi, ch);
+		if (rq->addr[i] < 0) {
+			dev_err(mgi->dev, "alloc addr failed\n");
+			while (i-- > 0)
+				free_channel_addr(mgi, rq->addr[i]);
+			kfree(rq);
+			rq = NULL;
+			break;
+		}
+	}
+	mutex_unlock(&mgi->lock);
+	va_end(args);
+
+	return rq;
+}
+EXPORT_SYMBOL(intel_mid_gpadc_alloc);
+
+static int __devinit msic_gpadc_probe(struct platform_device *pdev)
+{
+	struct gpadc_info *mgi = &gpadc_info;
+
+	mutex_init(&mgi->lock);
+	init_waitqueue_head(&mgi->wait);
+	init_waitqueue_head(&mgi->trimming_wait);
+	mgi->workq = create_singlethread_workqueue(dev_name(&pdev->dev));
+	if (mgi->workq == NULL)
+		return -ENOMEM;
+
+	mgi->dev = &pdev->dev;
+	mgi->irq = platform_get_irq(pdev, 0);
+
+	gpadc_clear_bits(INTEL_MSIC_IRQLVL1MSK, IRQLVL1MSK_ADCM);
+	if (request_threaded_irq(mgi->irq, msic_gpadc_isr, msic_gpadc_irq,
+					IRQF_ONESHOT, "msic_adc", mgi)) {
+		dev_err(&pdev->dev, "unable to register irq %d\n", mgi->irq);
+		return -ENODEV;
+	}
+
+	gpadc_write(INTEL_MSIC_ADC1ADDR0, MSIC_STOPCH);
+	INIT_WORK(&mgi->trimming_work, gpadc_trimming);
+	queue_work(mgi->workq, &mgi->trimming_work);
+	wait_event(mgi->trimming_wait, mgi->trimming_start);
+	mgi->initialized = 1;
+
+	return 0;
+}
+
+static int __devexit msic_gpadc_remove(struct platform_device *pdev)
+{
+	struct gpadc_info *mgi = &gpadc_info;
+
+	free_irq(mgi->irq, mgi);
+	flush_workqueue(mgi->workq);
+	destroy_workqueue(mgi->workq);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int msic_gpadc_suspend_noirq(struct device *dev)
+{
+	struct gpadc_info *mgi = &gpadc_info;
+
+	/* If the gpadc is locked, it means gpadc is still in active mode. */
+	if (mutex_trylock(&mgi->lock))
+		return 0;
+	else
+		return -EBUSY;
+}
+
+static int msic_gpadc_resume_noirq(struct device *dev)
+{
+	struct gpadc_info *mgi = &gpadc_info;
+
+	mutex_unlock(&mgi->lock);
+	return 0;
+}
+#else
+#define msic_gpadc_suspend_noirq    NULL
+#define msic_gpadc_resume_noirq     NULL
+#endif
+
+static const struct dev_pm_ops msic_gpadc_driver_pm_ops = {
+	.suspend_noirq	= msic_gpadc_suspend_noirq,
+	.resume_noirq	= msic_gpadc_resume_noirq,
+};
+
+static struct platform_driver msic_gpadc_driver = {
+	.driver = {
+		   .name = "msic_adc",
+		   .owner = THIS_MODULE,
+		   .pm = &msic_gpadc_driver_pm_ops,
+		   },
+	.probe = msic_gpadc_probe,
+	.remove = __devexit_p(msic_gpadc_remove),
+};
+
+static int __init msic_gpadc_module_init(void)
+{
+	return platform_driver_register(&msic_gpadc_driver);
+}
+
+static void __exit msic_gpadc_module_exit(void)
+{
+	platform_driver_unregister(&msic_gpadc_driver);
+}
+
+module_init(msic_gpadc_module_init);
+module_exit(msic_gpadc_module_exit);
+
+MODULE_AUTHOR("Jenny TC <jenny.tc@intel.com>");
+MODULE_DESCRIPTION("Intel Medfield MSIC GPADC Driver");
+MODULE_LICENSE("GPL");
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index a810696..8cefd1b 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -792,6 +792,11 @@ static void *msic_generic_platform_data(void *info, enum intel_msic_block block)
 	return no_platform_data(info);
 }
 
+static void *msic_adc_platform_data(void *info)
+{
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_ADC);
+}
+
 static void *msic_battery_platform_data(void *info)
 {
 	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_BATTERY);
@@ -880,6 +885,7 @@ static const struct devs_id __initconst device_ids[] = {
 	{"smb347", SFI_DEV_TYPE_I2C, 0, &smb347_platform_data},
 
 	/* MSIC subdevices */
+	{"msic_adc", SFI_DEV_TYPE_IPC, 1, &msic_adc_platform_data},
 	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data},
 	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data},
 	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data},

