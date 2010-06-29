Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab0F2NNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:13:06 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:26539 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab0F2NNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:13:01 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv3 1/11] MFD: Reformatting of files and removal of testing framework
Date: Tue, 29 Jun 2010 14:12:54 +0100
Message-ID: <3495EC08FA53E94AAA00CC4743D5BA7E013FA7EA@pandora.diasemi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv3 1/11] MFD: Reformatting of files and removal of testing framework
Thread-Index: AcsXjMkhesxUE4rESYqxDOnocaODIg==
From: "David Dajun Chen" <Dajun.Chen@diasemi.com>
To: <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Jun 2010 13:12:56.0370 (UTC) FILETIME=[CA193120:01CB178C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MFD module of the device driver for DA9052 PMIC device from Dialog
Semiconductor.

Changes made since last submission:
. Following review comments, da9052_ssc.c and da9052_eh.c have now been
replaced
by 3 files: da9052-core, da9052-spi.cand da9052-i2c.c;
. Testing framework has been removed;
. The MFD core registers platform driver instances of all the DA9052
modules.

Linux Kernel Version: 2.6.34

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -uprN linux-2.6.34/drivers/mfd/da9052-core.c
linux-2.6.34_test/drivers/mfd/da9052-core.c
--- linux-2.6.34/drivers/mfd/da9052-core.c	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/drivers/mfd/da9052-core.c	2010-06-28
19:36:17.000000000 +0500
@@ -0,0 +1,591 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052-core.c: MFD core driver for DA9052
+ */
+
+#include <linux/device.h>
+#include <linux/jiffies.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/irq.h>
+#include <linux/list.h>
+#include <linux/mfd/core.h>
+#if defined(CONFIG_MFD_DA9052_SPI)
+#include <linux/spi/spi.h>
+#endif
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/eh.h>
+
+struct ssc_cache_entry	ssc_cache[DA9052_REG_CNT];
+struct da9052_eh_nb eve_nb_array[EVE_CNT];
+
+static struct da9052_ssc_ops ssc_ops = {
+#if defined(CONFIG_MFD_DA9052_SPI)
+	.write = da9052_spi_write,
+	.read = da9052_spi_read,
+	.write_many = NULL,
+	.read_many = NULL,
+	.device_register = da9052_spi_register,
+	.device_unregister = da9052_spi_unregister,
+#elif defined(CONFIG_MFD_DA9052_I2C)
+	.write = da9052_i2c_write,
+	.read = da9052_i2c_read,
+	.write_many = da9052_i2c_write_many,
+	.read_many = da9052_i2c_read_many,
+	.device_register = da9052_i2c_register,
+	.device_unregister = da9052_i2c_unregister,
+#endif
+};
+
+static unsigned char eve_prio_map[PRIO_CNT] = {
+					PRIO_0_EVE, PRIO_1_EVE,
PRIO_2_EVE,
+					PRIO_3_EVE, PRIO_4_EVE,
PRIO_5_EVE,
+					PRIO_6_EVE, PRIO_7_EVE,
PRIO_8_EVE,
+					PRIO_9_EVE, PRIO_10_EVE,
PRIO_11_EVE,
+					PRIO_12_EVE, PRIO_13_EVE,
PRIO_14_EVE,
+					PRIO_15_EVE, PRIO_16_EVE,
PRIO_17_EVE,
+					PRIO_18_EVE, PRIO_19_EVE,
PRIO_20_EVE,
+					PRIO_21_EVE, PRIO_22_EVE,
PRIO_23_EVE,
+					PRIO_24_EVE, PRIO_25_EVE,
PRIO_26_EVE,
+					PRIO_27_EVE, PRIO_28_EVE,
PRIO_29_EVE,
+					PRIO_30_EVE, PRIO_31_EVE
+					};
+
+static void da9052_init_ssc_cache(void)
+{
+	unsigned char cnt;
+
+	/* First initialize all registers as Non-volatile */
+	for (cnt = 0; cnt < DA9052_REG_CNT; cnt++) {
+		ssc_cache[cnt].type = NON_VOLATILE;
+		ssc_cache[cnt].status = INVALID;
+		ssc_cache[cnt].val = 0;
+	}
+
+	/* Now selectively set type for all Volatile registers */
+	/* Reg 1 - 9 */
+	ssc_cache[DA9052_STATUSA_REG].type = VOLATILE;
+	ssc_cache[DA9052_STATUSB_REG].type = VOLATILE;
+	ssc_cache[DA9052_STATUSC_REG].type = VOLATILE;
+	ssc_cache[DA9052_STATUSD_REG].type = VOLATILE;
+	ssc_cache[DA9052_EVENTA_REG].type = VOLATILE;
+	ssc_cache[DA9052_EVENTB_REG].type = VOLATILE;
+	ssc_cache[DA9052_EVENTC_REG].type = VOLATILE;
+	ssc_cache[DA9052_EVENTD_REG].type = VOLATILE;
+	ssc_cache[DA9052_FAULTLOG_REG].type = VOLATILE;
+
+	/* Reg 15 */
+	ssc_cache[DA9052_CONTROLB_REG].type = VOLATILE;
+	/* Reg - 17 */
+	ssc_cache[DA9052_CONTROLD_REG].type = VOLATILE;
+	/* Reg - 60 */
+	ssc_cache[DA9052_SUPPLY_REG].type = VOLATILE;
+	/* Reg - 62 */
+	ssc_cache[DA9052_CHGBUCK_REG].type = VOLATILE;
+
+	/* Reg 67 - 68 */
+	ssc_cache[DA9052_INPUTCONT_REG].type = VOLATILE;
+	ssc_cache[DA9052_CHGTIME_REG].type = VOLATILE;
+
+	/* Reg - 70 */
+	ssc_cache[DA9052_BOOST_REG].type = VOLATILE;
+
+	/* Reg - 81 */
+	ssc_cache[DA9052_ADCMAN_REG].type = VOLATILE;
+
+	/* Reg - 83 - 85 */
+	ssc_cache[DA9052_ADCRESL_REG].type = VOLATILE;
+	ssc_cache[DA9052_ADCRESH_REG].type = VOLATILE;
+	ssc_cache[DA9052_VDDRES_REG].type = VOLATILE;
+
+	/* Reg - 87 */
+	ssc_cache[DA9052_ICHGAV_REG].type = VOLATILE;
+
+	/* Reg - 90 */
+	ssc_cache[DA9052_TBATRES_REG].type = VOLATILE;
+
+	/* Reg - 95 */
+	ssc_cache[DA9052_ADCIN4RES_REG].type = VOLATILE;
+
+	/* Reg - 98 */
+	ssc_cache[DA9052_ADCIN5RES_REG].type = VOLATILE;
+
+	/* Reg - 101 */
+	ssc_cache[DA9052_ADCIN6RES_REG].type = VOLATILE;
+
+	/* Reg - 104 */
+	ssc_cache[DA9052_TJUNCRES_REG].type = VOLATILE;
+
+	/* Reg 106 - 110 */
+	ssc_cache[DA9052_TSICONTB_REG].type	= VOLATILE;
+	ssc_cache[DA9052_TSIXMSB_REG].type	= VOLATILE;
+	ssc_cache[DA9052_TSIYMSB_REG].type	= VOLATILE;
+	ssc_cache[DA9052_TSILSB_REG].type	= VOLATILE;
+	ssc_cache[DA9052_TSIZMSB_REG].type	= VOLATILE;
+
+	/* Reg 111 - 117 */
+	ssc_cache[DA9052_COUNTS_REG].type	= VOLATILE;
+	ssc_cache[DA9052_COUNTMI_REG].type	= VOLATILE;
+	ssc_cache[DA9052_COUNTH_REG].type	= VOLATILE;
+	ssc_cache[DA9052_COUNTD_REG].type	= VOLATILE;
+	ssc_cache[DA9052_COUNTMO_REG].type	= VOLATILE;
+	ssc_cache[DA9052_COUNTY_REG].type	= VOLATILE;
+	ssc_cache[DA9052_ALARMMI_REG].type	= VOLATILE;
+
+	/* Reg 122 - 125 */
+	ssc_cache[DA9052_SECONDA_REG].type	= VOLATILE;
+	ssc_cache[DA9052_SECONDB_REG].type	= VOLATILE;
+	ssc_cache[DA9052_SECONDC_REG].type	= VOLATILE;
+	ssc_cache[DA9052_SECONDD_REG].type	= VOLATILE;
+
+	/* Following addresses are not assigned to any register */
+	ssc_cache[126].type			= VOLATILE;
+	ssc_cache[127].type			= VOLATILE;
+}
+
+void da9052_lock(struct da9052 *da9052)
+{
+	if (!mutex_trylock(&da9052->ssc_lock))
+		mutex_lock(&da9052->ssc_lock);
+}
+EXPORT_SYMBOL(da9052_lock);
+
+void da9052_unlock(struct da9052 *da9052)
+{
+	mutex_unlock(&da9052->ssc_lock);
+}
+EXPORT_SYMBOL(da9052_unlock);
+
+int da9052_ssc_write(struct da9052 *da9052, struct da9052_ssc_msg
*sscmsg)
+{
+	int ret = 0;
+
+	/* Reg address should be a valid address on PAGE0 or PAGE1 */
+	if ((sscmsg->addr < DA9052_PAGE0_REG_START) ||
+	(sscmsg->addr > DA9052_PAGE1_REG_END) ||
+	((sscmsg->addr > DA9052_PAGE0_REG_END) &&
+	(sscmsg->addr < DA9052_PAGE1_REG_START)))
+		return INVALID_REGISTER;
+
+	da9052_lock(da9052);
+
+	ret = ssc_ops.write(da9052, sscmsg);
+
+	/* Update local cache if required */
+	if (!ret) {
+		/* Check if this register is Non-volatile*/
+		if (ssc_cache[sscmsg->addr].type != VOLATILE) {
+			/* Update value */
+			ssc_cache[sscmsg->addr].val = sscmsg->data;
+			/* Make this cache entry valid */
+			ssc_cache[sscmsg->addr].status = VALID;
+		}
+	}
+
+	/* Release ssc lock */
+	da9052_unlock(da9052);
+
+	return ret;
+}
+
+int da9052_ssc_read(struct da9052 *da9052, struct da9052_ssc_msg
*sscmsg)
+{
+	int ret = 0;
+
+	/* Reg addr should be a valid address on PAGE0 or PAGE1 */
+	if ((sscmsg->addr < DA9052_PAGE0_REG_START) ||
+	(sscmsg->addr > DA9052_PAGE1_REG_END) ||
+	((sscmsg->addr > DA9052_PAGE0_REG_END) &&
+	(sscmsg->addr < DA9052_PAGE1_REG_START)))
+		return INVALID_REGISTER;
+
+	/* Acquire ssc lock */
+	da9052_lock(da9052);
+
+	/*
+	 * Check if this is a Non-volatile register, if yes then return
value -
+	 * from cache instead of actual reading from hardware. Before
reading -
+	 * cache entry, make sure that the entry is valid
+	 */
+	/* The read request is for Non-volatile register */
+	/* Check if we have valid cached value for this */
+	if (ssc_cache[sscmsg->addr].status == VALID) {
+		/* We have valid cached value, copy this value */
+		sscmsg->data = ssc_cache[sscmsg->addr].val;
+
+		/* Release ssc lock */
+		da9052_unlock(da9052);
+
+		return 0;
+	}
+
+	ret = ssc_ops.read(da9052, sscmsg);
+
+	/* Update local cache if required */
+	if (!ret) {
+		/* Check if this register is Non-volatile*/
+		if (ssc_cache[sscmsg->addr].type != VOLATILE) {
+			/* Update value */
+			ssc_cache[sscmsg->addr].val = sscmsg->data;
+			/* Make this cache entry valid */
+			ssc_cache[sscmsg->addr].status = VALID;
+		}
+	}
+
+	/* Release ssc lock */
+	da9052_unlock(da9052);
+
+	return ret;
+}
+
+int da9052_ssc_write_many(struct da9052 *da9052, struct da9052_ssc_msg
*sscmsg,
+			int msg_no)
+{
+	int ret = 0;
+	int cnt;
+#if defined(CONFIG_MFD_DA9052_SPI)
+	struct da9052_ssc_msg *msg;
+#endif
+
+	/* Check request size */
+	if (msg_no > MAX_READ_WRITE_CNT)
+		return -EIO;
+
+#if defined(CONFIG_MFD_DA9052_SPI)
+	msg = sscmsg;
+
+	for (cnt = 0; cnt < msg_no; cnt++, msg++) {
+		ret = da9052_ssc_write(da9052, msg);
+		if (!ret)
+			return -EIO;
+	}
+#elif defined(CONFIG_MFD_DA9052_I2C)
+	ret = ssc_ops.write_many(da9052, sscmsg, msg_no);
+	/* Update local cache, if required */
+	for (cnt = 0; cnt < msg_no; cnt++) {
+		/* Check if this register is Non-volatile*/
+		if (ssc_cache[sscmsg[cnt].addr].type != VOLATILE) {
+			/* Update value */
+			ssc_cache[sscmsg[cnt].addr].val =
+			sscmsg[cnt].data;
+			/* Make this cache entry valid */
+			ssc_cache[sscmsg[cnt].addr].status = VALID;
+		}
+	}
+#endif
+
+	return ret;
+}
+
+int da9052_ssc_read_many(struct da9052 *da9052, struct da9052_ssc_msg
*sscmsg,
+			int msg_no)
+{
+	int ret = 0;
+	int cnt;
+#if defined(CONFIG_MFD_DA9052_SPI)
+	struct da9052_ssc_msg *msg;
+#endif
+
+	/* Check request size */
+	if (msg_no > MAX_READ_WRITE_CNT)
+		return -EIO;
+
+#if defined(CONFIG_MFD_DA9052_SPI)
+	msg = sscmsg;
+
+	for (cnt = 0; cnt < msg_no; cnt++, msg++) {
+		ret = da9052_ssc_read(da9052, msg);
+		if (!ret)
+			return -EIO;
+	}
+#elif defined(CONFIG_MFD_DA9052_I2C)
+	ret = ssc_ops.read_many(da9052, sscmsg, msg_no);
+	/* Update local cache, if required */
+	for (cnt = 0; cnt < msg_no; cnt++) {
+		/* Check if this register is Non-volatile*/
+		if (ssc_cache[sscmsg[cnt].addr].type
+			!= VOLATILE) {
+			/* Update value */
+			ssc_cache[sscmsg[cnt].addr].val =
+			sscmsg[cnt].data;
+			/* Make this cache entry valid */
+			ssc_cache[sscmsg[cnt].addr].status = VALID;
+		}
+	}
+#endif
+
+	return ret;
+}
+
+static int da9052_add_subdevice_pdata(struct da9052 *da9052,
+		const char *name, void *pdata, size_t pdata_size)
+{
+	struct mfd_cell cell = {
+		.name = name,
+		.platform_data = pdata,
+		.data_size = pdata_size,
+	};
+#if defined(CONFIG_MFD_DA9052_SPI)
+	return mfd_add_devices(&da9052->spi_dev->dev, -1, &cell, 1,
NULL, 0);
+#elif defined(CONFIG_MFD_DA9052_I2C)
+	return mfd_add_devices(da9052->dev, -1, &cell, 1, NULL, 0);
+#endif
+}
+
+static int da9052_add_subdevice(struct da9052 *da9052, const char
*name)
+{
+	return da9052_add_subdevice_pdata(da9052, name, NULL, 0);
+}
+
+static int da9052_register(struct da9052 *da9052)
+{
+	return ssc_ops.device_register(da9052);
+}
+
+static void da9052_unregister(void)
+{
+	return ssc_ops.device_unregister();
+}
+
+static irqreturn_t da9052_eh_isr(int irq, void *dev_id)
+{
+	unsigned int handled = 0;
+
+	struct da9052 *da9052 = dev_id;
+
+	/* Schedule work to be done */
+	schedule_work(&da9052->eh_isr_work);
+
+	/* Disable IRQ */
+	disable_irq_nosync(DA9052_IRQ);
+
+	return IRQ_RETVAL(handled);
+}
+
+int eh_register_nb(struct da9052 *da9052, struct da9052_eh_nb *nb)
+{
+
+	if (nb == NULL) {
+		printk(KERN_INFO "EH REGISTER FUNCTION FAILED\n");
+		return -EINVAL;
+	}
+
+	if (nb->eve_type >= EVE_CNT) {
+		printk(KERN_INFO "Invalid DA9052 Event Type\n");
+		return -EINVAL;
+	}
+
+	/* Initialize list head inside notifier block */
+	INIT_LIST_HEAD(&nb->nb_list);
+
+	/* Acquire NB array lock */
+	if (mutex_lock_interruptible(&da9052->eve_nb_lock))
+		return -EAGAIN;
+
+	/* Add passed NB to corresponding EVENT list */
+	list_add_tail(&nb->nb_list,
&(eve_nb_array[nb->eve_type].nb_list));
+
+	/* Release NB array lock */
+	mutex_unlock(&da9052->eve_nb_lock);
+
+	return 0;
+}
+
+int eh_unregister_nb(struct da9052 *da9052, struct da9052_eh_nb *nb)
+{
+
+	if (nb == NULL)
+		return -EINVAL;
+
+	/* Acquire nb array lock */
+	if (mutex_lock_interruptible(&da9052->eve_nb_lock))
+		return -EAGAIN;
+
+	/* Remove passed NB from list */
+	list_del_init(&(nb->nb_list));
+
+	/* Release NB array lock */
+	mutex_unlock(&da9052->eve_nb_lock);
+
+	return 0;
+}
+
+static int process_events(struct da9052 *da9052, int events_sts)
+{
+
+	int cnt = 0;
+	int tmp_events_sts = 0;
+	unsigned char event = 0;
+
+	struct list_head *ptr;
+	struct da9052_eh_nb *nb_ptr;
+
+	/* Now we have retrieved all events, process them one by one */
+	for (cnt = 0; cnt < PRIO_CNT; cnt++) {
+
+		/*
+		 * Starting with highest priority event,
+		 * traverse through all event
+		 */
+		tmp_events_sts = events_sts;
+
+		/* Find the event associated with higher priority */
+		event = eve_prio_map[cnt];
+
+		/* Check if interrupt is received for this event */
+		if (!((tmp_events_sts >> event) & 0x1)) {
+
+			/* Event bit is not set for this event */
+			/* Move to next priority event */
+			continue;
+		}
+
+		/* Event bit is set, execute all registered call backs
*/
+		if (mutex_lock_interruptible(&da9052->eve_nb_lock))
+			return -EAGAIN;
+
+		list_for_each(ptr, &(eve_nb_array[event].nb_list)) {
+
+			/*
+			 * nb_ptr will point to the structure in which
+			 * nb_list is embedded
+			 */
+			nb_ptr = list_entry(ptr, struct da9052_eh_nb,
nb_list);
+			nb_ptr->call_back(nb_ptr, events_sts);
+		}
+
+		mutex_unlock(&da9052->eve_nb_lock);
+	}
+	return 0;
+}
+
+void eh_workqueue_isr(struct work_struct *work)
+{
+	struct da9052 *da9052 =
+		container_of(work, struct da9052, eh_isr_work);
+
+	struct da9052_ssc_msg eve_data[4];
+	int events_sts, ret;
+	unsigned char cnt = 0;
+
+	/* nIRQ is asserted, read event registeres to know what happened
*/
+	events_sts = 0;
+
+	/* Prepare ssc message to read all four event registers */
+	for (cnt = 0; cnt < 4; cnt++) {
+		eve_data[cnt].addr = (DA9052_EVENTA_REG + cnt);
+		eve_data[cnt].data = 0;
+	}
+
+	/* Now read all event registers */
+	ret = da9052_ssc_read_many(da9052, eve_data, 4);
+	ret = da9052_ssc_read_many(da9052, eve_data, 4);
+	if (ret) {
+		enable_irq(DA9052_IRQ);
+		return;
+	}
+
+	/* Collect all events */
+	for (cnt = 0; cnt < 4; cnt++)
+		events_sts |= (eve_data[cnt].data << (8 * cnt));
+
+	/* Check if we really got any event */
+	if (events_sts == 0) {
+		enable_irq(DA9052_IRQ);
+		return;
+	}
+
+	/* Process all events occurred */
+	process_events(da9052, events_sts);
+
+	/* Now clear EVENT registers */
+	for (cnt = 0; cnt < 4; cnt++) {
+		if (eve_data[cnt].data) {
+			ret = da9052_ssc_write(da9052, &eve_data[cnt]);
+			if (ret) {
+				enable_irq(DA9052_IRQ);
+				return;
+			}
+		}
+    }
+	/*
+	 * This delay is necessary to avoid hardware fake interrupts
+	 * from DA9052.
+	 */
+	udelay(50);
+
+	/* Enable HOST interrupt */
+	enable_irq(DA9052_IRQ);
+}
+
+static int __init da9052_ssc_init(void)
+{
+	int ret, cnt;
+	struct da9052 *da9052;
+	struct da9052_platform_data *pdata;
+
+	da9052 = kzalloc(sizeof(*da9052), GFP_KERNEL);
+	if (!da9052)
+		return -ENOMEM;
+
+	/* Initialize ssc lock */
+	mutex_init(&da9052->ssc_lock);
+
+	/* Assign the read-write function pointers */
+	da9052->read = da9052_ssc_read;
+	da9052->write = da9052_ssc_write;
+	da9052->read_many = da9052_ssc_read_many;
+	da9052->write_many = da9052_ssc_write_many;
+
+	/* Assign the EH notifier block register/de-register functions
*/
+	da9052->register_event_notifier = eh_register_nb;
+	da9052->unregister_event_notifier = eh_unregister_nb;
+
+	ret = da9052_register(da9052);
+	if (ret)
+		return -EIO;
+
+	/* Initialize ssc cache */
+	da9052_init_ssc_cache();
+
+	/* Initialize eve_nb_array */
+	for (cnt = 0; cnt < EVE_CNT; cnt++)
+		INIT_LIST_HEAD(&(eve_nb_array[cnt].nb_list));
+
+	/* Set interrupt as LOW LEVEL interrupt source */
+	set_irq_type(DA9052_IRQ, IRQ_TYPE_LEVEL_LOW);
+
+	INIT_WORK(&da9052->eh_isr_work, eh_workqueue_isr);
+
+	if (request_irq(DA9052_IRQ, da9052_eh_isr, IRQ_TYPE_LEVEL_LOW,
+			DA9052_EH_DEVICE_NAME, da9052))
+		return -EIO;
+
+	/* Initialize NB array lock */
+	mutex_init(&da9052->eve_nb_lock);
+
+	return ret;
+}
+subsys_initcall(da9052_ssc_init);
+
+static void __exit da9052_ssc_exit(void)
+{
+	free_irq(DA9052_IRQ, NULL);
+	da9052_unregister();
+	return;
+}
+module_exit(da9052_ssc_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("DA9052 MFD Core");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DA9052_SSC_DEVICE_NAME);
diff -uprN linux-2.6.34/drivers/mfd/da9052-i2c.c
linux-2.6.34_test/drivers/mfd/da9052-i2c.c
--- linux-2.6.34/drivers/mfd/da9052-i2c.c	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/drivers/mfd/da9052-i2c.c	2010-06-28
19:10:52.000000000 +0500
@@ -0,0 +1,324 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052-i2c.c: I2C SSC (Synchronous Serial Communication) driver for
DA9052
+ */
+
+#include <linux/device.h>
+#include <linux/mfd/core.h>
+#include <linux/i2c.h>
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+static struct da9052 *da9052_i2c;
+
+static int __devinit da9052_i2c_probe(struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	/* Get the bus driver handler */
+	struct i2c_adapter *adapter =
to_i2c_adapter(client->dev.parent);
+
+	/* Check i2c bus driver supports byte data transfer */
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
{
+		dev_info(&client->dev,\
+		"Error in %s:i2c_check_functionality\n", __func__);
+		return -ENODEV;;
+	}
+
+	/* Store handle to i2c client */
+	da9052_i2c->i2c_client = client;
+
+	da9052_i2c->dev = &client->dev;
+
+	/* Initialize i2c data structure here*/
+	da9052_i2c->adapter = adapter;
+
+	/* host i2c driver looks only first 7 bits for the slave address
*/
+	da9052_i2c->slave_addr = DA9052_I2C_ADDR >> 1;
+
+	/* Store the i2c client data */
+	i2c_set_clientdata(client, da9052_i2c);
+
+	return 0;
+}
+
+static int da9052_i2c_remove(struct i2c_client *client)
+{
+
+	struct da9052 *da9052 = i2c_get_clientdata(client);
+
+	mfd_remove_devices(da9052->dev);
+	kfree(da9052);
+	return 0;
+}
+
+int da9052_i2c_write(struct da9052 *da9052, struct da9052_ssc_msg *msg)
+{
+	struct i2c_msg i2cmsg;
+	unsigned char buf[2] = {0};
+	int ret = 0;
+
+	/* Copy the ssc msg to local character buffer */
+	buf[0] = msg->addr;
+	buf[1] = msg->data;
+
+	/*Construct a i2c msg for a da9052 driver ssc message request */
+	i2cmsg.addr  = da9052->slave_addr;
+	i2cmsg.len   = 2;
+	i2cmsg.buf   = buf;
+
+	/* To write the data on I2C set flag to zero */
+	i2cmsg.flags = 0;
+
+	/* Start the i2c transfer by calling host i2c driver function */
+	ret = i2c_transfer(da9052->adapter, &i2cmsg, 1);
+
+	if (ret < 0) {
+		dev_info(&da9052->i2c_client->dev,\
+		"_%s:master_xfer Failed!!\n", __func__);
+		return ret;
+	}
+
+	return 0;
+}
+
+int da9052_i2c_read(struct da9052 *da9052, struct da9052_ssc_msg *msg)
+{
+
+	/*Get the da9052_i2c client details*/
+	unsigned char buf[2] = {0, 0};
+	struct i2c_msg i2cmsg[2];
+	int ret = 0;
+
+	/* Copy SSC Msg to local character buffer */
+	buf[0] = msg->addr;
+
+	/*Construct a i2c msg for a da9052 driver ssc message request */
+	i2cmsg[0].addr  = da9052->slave_addr ;
+	i2cmsg[0].len   = 1;
+	i2cmsg[0].buf   = &buf[0];
+
+	/*To write the data on I2C set flag to zero */
+	i2cmsg[0].flags = 0;
+
+	/* Read the data from da9052*/
+	/*Construct a i2c msg for a da9052 driver ssc message request */
+	i2cmsg[1].addr  = da9052->slave_addr ;
+	i2cmsg[1].len   = 1;
+	i2cmsg[1].buf   = &buf[1];
+
+	/*To read the data on I2C set flag to I2C_M_RD */
+	i2cmsg[1].flags = I2C_M_RD;
+
+	/* Start the i2c transfer by calling host i2c driver function */
+	ret = i2c_transfer(da9052->adapter, i2cmsg, 2);
+	if (ret < 0) {
+		dev_info(&da9052->i2c_client->dev,\
+		"2 - %s:master_xfer Failed!!\n", __func__);
+		return ret;
+	}
+
+	msg->data = *i2cmsg[1].buf;
+
+	return 0;
+}
+
+int da9052_i2c_write_many(struct da9052 *da9052,
+	struct da9052_ssc_msg *sscmsg, unsigned int msg_no)
+{
+
+	struct i2c_msg i2cmsg;
+	unsigned char data_buf[MAX_READ_WRITE_CNT+1];
+	struct da9052_ssc_msg ctrlb_msg;
+	struct da9052_ssc_msg *msg_queue = sscmsg;
+	int ret = 0;
+	/* Flag to check if requested registers are contiguous */
+	unsigned char cont_data = 1;
+	unsigned char cnt = 0;
+
+	/* Check if requested regsiters are contiguous */
+	for (cnt = 1; cnt < msg_no; cnt++) {
+		if ((msg_queue[cnt].addr - msg_queue[cnt-1].addr) != 1)
{
+			/* Difference is not 1, i.e. non-contiguous
registers */
+			cont_data = 0;
+			break;
+		}
+	}
+
+	if (cont_data == 0) {
+		/* Requested registers are non-contiguous */
+		for (cnt = 0; cnt < msg_no; cnt++) {
+			ret = da9052->write(da9052, &msg_queue[cnt]);
+			if (ret != 0)
+				return ret;
+		}
+		return 0;
+	}
+	/*
+	*  Requested registers are contiguous
+	* or PAGE WRITE sequence of I2C transactions is as below
+	* (slave_addr + reg_addr + data_1 + data_2 + ...)
+	* First read current WRITE MODE via CONTROL_B register of DA9052
+	*/
+	ctrlb_msg.addr = DA9052_CONTROLB_REG;
+	ctrlb_msg.data = 0x0;
+	ret = da9052->read(da9052, &ctrlb_msg);
+
+	if (ret != 0)
+		return ret;
+
+	/* Check if PAGE WRITE mode is set */
+	if (ctrlb_msg.data & DA9052_CONTROLB_WRITEMODE) {
+		/* REPEAT WRITE mode is configured */
+		/* Now set DA9052 into PAGE WRITE mode */
+		ctrlb_msg.data &= ~DA9052_CONTROLB_WRITEMODE;
+		ret = da9052->write(da9052, &ctrlb_msg);
+
+		if (ret != 0)
+			return ret;
+	}
+
+	 /* Put first register address */
+	data_buf[0] = msg_queue[0].addr;
+
+	for (cnt = 0; cnt < msg_no; cnt++)
+		data_buf[cnt+1] = msg_queue[cnt].data;
+
+	/* Construct a i2c msg for PAGE WRITE */
+	i2cmsg.addr  = da9052->slave_addr ;
+	/* First register address + all data*/
+	i2cmsg.len   = (msg_no + 1);
+	i2cmsg.buf   = data_buf;
+
+	/*To write the data on I2C set flag to zero */
+	i2cmsg.flags = 0;
+
+	/* Start the i2c transfer by calling host i2c driver function */
+	ret = i2c_transfer(da9052->adapter, &i2cmsg, 1);
+	if (ret < 0) {
+		dev_info(&da9052->i2c_client->dev,\
+		"1 - i2c_transfer function falied in [%s]!!!\n",
__func__);
+		return ret;
+	}
+
+	return 0;
+}
+
+int da9052_i2c_read_many(struct da9052 *da9052,
+	struct da9052_ssc_msg *sscmsg, unsigned int msg_no)
+{
+
+	struct i2c_msg i2cmsg;
+	unsigned char data_buf[MAX_READ_WRITE_CNT];
+	struct da9052_ssc_msg *msg_queue = sscmsg;
+	int ret = 0;
+	/* Flag to check if requested registers are contiguous */
+	unsigned char cont_data = 1;
+	unsigned char cnt = 0;
+
+	/* Check if requested regsiters are contiguous */
+	for (cnt = 1; cnt < msg_no; cnt++) {
+		if ((msg_queue[cnt].addr - msg_queue[cnt-1].addr) != 1)
{
+			/* Difference is not 1, i.e. non-contiguous
registers */
+			cont_data = 0;
+			break;
+		}
+	}
+
+	if (cont_data == 0) {
+		/* Requested registers are non-contiguous */
+		for (cnt = 0; cnt < msg_no; cnt++) {
+			ret = da9052->read(da9052, &msg_queue[cnt]);
+			if (ret != 0) {
+				dev_info(&da9052->i2c_client->dev,\
+				"Error in %s", __func__);
+				return ret;
+			}
+		}
+		return 0;
+	}
+
+	/*
+	* We want to perform PAGE READ via I2C
+	* For PAGE READ sequence of I2C transactions is as below
+	* (slave_addr + reg_addr) + (slave_addr + data_1 + data_2 + ...)
+	*/
+	/* Copy address of first register */
+	data_buf[0] = msg_queue[0].addr;
+
+	/* Construct a i2c msg for first transaction of PAGE READ i.e.
write */
+	i2cmsg.addr  = da9052->slave_addr ;
+	i2cmsg.len   = 1;
+	i2cmsg.buf   = data_buf;
+
+	/*To write the data on I2C set flag to zero */
+	i2cmsg.flags = 0;
+
+	/* Start the i2c transfer by calling host i2c driver function */
+	ret = i2c_transfer(da9052->adapter, &i2cmsg, 1);
+	if (ret < 0) {
+		dev_info(&da9052->i2c_client->dev,\
+		"1 - i2c_transfer function falied in [%s]!!!\n",
__func__);
+		return ret;
+	}
+
+	/* Now Read the data from da9052 */
+	/* Construct a i2c msg for second transaction of PAGE READ i.e.
read */
+	i2cmsg.addr  = da9052->slave_addr ;
+	i2cmsg.len   = msg_no;
+	i2cmsg.buf   = data_buf;
+
+	/*To read the data on I2C set flag to I2C_M_RD */
+	i2cmsg.flags = I2C_M_RD;
+
+	/* Start the i2c transfer by calling host i2c driver function */
+	ret = i2c_transfer(da9052->adapter,
+		&i2cmsg, 1);
+	if (ret < 0) {
+		dev_info(&da9052->i2c_client->dev,\
+		"2 - i2c_transfer function falied in [%s]!!!\n",
__func__);
+		return ret;
+	}
+
+	/* Gather READ data */
+	for (cnt = 0; cnt < msg_no; cnt++)
+		sscmsg[cnt].data = data_buf[cnt];
+
+	return 0;
+}
+
+static struct i2c_device_id da9052_ssc_id[] = {
+	{ DA9052_SSC_I2C_DEVICE_NAME, 0},
+	{}
+};
+
+static struct i2c_driver da9052_i2c_driver =  {
+/* Field not defined in Linux kernel 2.6.33*/
+/*	.id = 0,*/
+	.driver = {
+		.name	= DA9052_SSC_I2C_DEVICE_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe	= da9052_i2c_probe,
+	.remove	= da9052_i2c_remove,
+	.id_table	= da9052_ssc_id,
+};
+
+int da9052_i2c_register(struct da9052 *da9052)
+{
+	da9052_i2c = da9052;
+	return i2c_add_driver(&da9052_i2c_driver);;
+}
+void da9052_i2c_unregister()
+{
+	i2c_del_driver(&da9052_i2c_driver);
+}
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("I2C driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DA9052_SSC_I2C_DEVICE_NAME);
diff -uprN linux-2.6.34/drivers/mfd/da9052-spi.c
linux-2.6.34_test/drivers/mfd/da9052-spi.c
--- linux-2.6.34/drivers/mfd/da9052-spi.c	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/drivers/mfd/da9052-spi.c	2010-06-28
19:10:52.000000000 +0500
@@ -0,0 +1,294 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052-spi.c: SPI SSC (Synchronous Serial Communication) driver for
DA9052
+ */
+
+#include <linux/device.h>
+#include <linux/mfd/core.h>
+#include <linux/spi/spi.h>
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+static struct da9052 *da9052_spi;
+
+static int da9052_spi_probe(struct spi_device *spi)
+{
+
+	dev_set_drvdata(&spi->dev, da9052_spi);
+	spi->mode = SPI_MODE_0 | SPI_CPOL;
+	spi->bits_per_word = 8;
+	spi_setup(spi);
+
+	da9052_spi->spi_dev = spi;
+
+	/*
+	 * Allocate memory for RX/TX bufferes used in single register
read/write
+	 */
+	da9052_spi->spi_rx_buf = kmalloc(2, GFP_KERNEL | GFP_DMA);
+	if (!da9052_spi->spi_rx_buf)
+		return -ENOMEM;
+
+	da9052_spi->spi_tx_buf = kmalloc(2, GFP_KERNEL | GFP_DMA);
+	if (!da9052_spi->spi_tx_buf)
+		return -ENOMEM;
+
+	da9052_spi->spi_active_page  = PAGECON_0;
+	da9052_spi->rw_pol = 1;
+
+	return 0;
+}
+
+static int da9052_spi_remove(struct spi_device *spi)
+{
+	struct da9052 *da9052 = dev_get_drvdata(&spi->dev);
+
+	mfd_remove_devices(&spi->dev);
+	kfree(da9052->spi_rx_buf);
+	kfree(da9052->spi_tx_buf);
+	kfree(da9052);
+	return 0;
+}
+
+static struct spi_driver da9052_spi_driver = {
+	.driver = {
+		.name	 = DA9052_SSC_SPI_DEVICE_NAME,
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= da9052_spi_probe,
+	.remove		= __devexit_p(da9052_spi_remove),
+};
+
+static int da9052_spi_set_page(struct da9052 *da9052, unsigned char
page)
+{
+
+	struct da9052_ssc_msg sscmsg;
+	struct spi_message message;
+	struct spi_transfer xfer;
+	int ret = 0;
+
+	if ((page != PAGECON_0) && ((page != PAGECON_128)))
+		return INVALID_PAGE;
+
+	/* Current configuration is PAGE-0 and write request for PAGE-1
*/
+	/* set register address */
+	sscmsg.addr = DA9052_PAGECON0_REG;
+	/* set value */
+	sscmsg.data = page;
+
+	/* Check value of R/W_POL bit of INTERFACE register */
+	if (!da9052->rw_pol) {
+		/* We need to set 0th bit for write operation */
+		sscmsg.addr = ((sscmsg.addr << 1) | RW_POL);
+	} else {
+		/* We need to reset 0th bit for write operation */
+		sscmsg.addr = (sscmsg.addr << 1);
+	}
+
+	/* SMDK-6410 host SPI driver specific stuff */
+
+	/* Build our spi message */
+	spi_message_init(&message);
+	memset(&xfer, 0, sizeof(xfer));
+
+	xfer.len = 2;
+	xfer.tx_buf = da9052->spi_tx_buf;
+	xfer.rx_buf = da9052->spi_rx_buf;
+
+	da9052->spi_tx_buf[0] = sscmsg.addr;
+	da9052->spi_tx_buf[1] = sscmsg.data;
+
+	spi_message_add_tail(&xfer, &message);
+
+	/* Now, do the i/o */
+	ret = spi_sync(da9052->spi_dev, &message);
+
+	if (ret == 0) {
+		/* Active Page set successfully */
+		da9052->spi_active_page = page;
+		return 0;
+	} else {
+		/* Error in setting Active Page */
+		return ret;
+	}
+
+	return 0;
+}
+
+int da9052_spi_write(struct da9052 *da9052, struct da9052_ssc_msg *msg)
+{
+
+	struct spi_message message;
+	struct spi_transfer xfer;
+	int ret;
+
+	/*
+	 * We need a seperate copy of da9052_ssc_msg so that caller's
+	 * copy remains intact
+	*/
+	struct da9052_ssc_msg sscmsg;
+
+	/* Copy callers data in to our local copy */
+	sscmsg.addr = msg->addr;
+	sscmsg.data = msg->data;
+
+	if ((sscmsg.addr > PAGE_0_END) &&
+		(da9052->spi_active_page == PAGECON_0)) {
+		/*
+		* Current configuration is PAGE-0 and write request
+		* for PAGE-1
+		*/
+		da9052_spi_set_page(da9052, PAGECON_128);
+		/* Set register address accordindly */
+		sscmsg.addr = (sscmsg.addr - PAGE_1_START);
+	} else if ((sscmsg.addr < PAGE_1_START) &&
+		(da9052->spi_active_page == PAGECON_128)) {
+		/*
+		* Current configuration is PAGE-1 and write request
+		* for PAGE-0
+		*/
+		da9052_spi_set_page(da9052, PAGECON_0);
+	} else if (sscmsg.addr > PAGE_0_END) {
+		/*
+		* Current configuration is PAGE-1 and write request
+		* for PAGE-1. Just need to adjust register address
+		*/
+		sscmsg.addr = (sscmsg.addr - PAGE_1_START);
+	}
+
+	/* Check value of R/W_POL bit of INTERFACE register */
+	if (!da9052->rw_pol) {
+		/* We need to set 0th bit for write operation */
+		sscmsg.addr = ((sscmsg.addr << 1) | RW_POL);
+	} else {
+		/* We need to reset 0th bit for write operation */
+		sscmsg.addr = (sscmsg.addr << 1);
+	}
+
+	/* SMDK-6410 host SPI driver specific stuff */
+
+	/* Build our spi message */
+	spi_message_init(&message);
+	memset(&xfer, 0, sizeof(xfer));
+
+	xfer.len = 2;
+	xfer.tx_buf = da9052->spi_tx_buf;
+	xfer.rx_buf = da9052->spi_rx_buf;
+
+	da9052->spi_tx_buf[0] = sscmsg.addr;
+	da9052->spi_tx_buf[1] = sscmsg.data;
+
+	spi_message_add_tail(&xfer, &message);
+
+	/* Now, do the i/o */
+	ret = spi_sync(da9052->spi_dev, &message);
+
+	if (ret == 0)
+		return 0;
+	else
+		return ret;
+}
+
+int da9052_spi_read(struct da9052 *da9052, struct da9052_ssc_msg *msg)
+{
+
+	struct spi_message message;
+	struct spi_transfer xfer;
+	int ret;
+
+	/*
+	* We need a seperate copy of da9052_ssc_msg so that
+	* caller's copy remains intact
+	*/
+	struct da9052_ssc_msg sscmsg;
+
+	/* Copy callers data in to our local copy */
+	sscmsg.addr = msg->addr;
+	sscmsg.data = msg->data;
+
+	if ((sscmsg.addr > PAGE_0_END) &&
+		(da9052->spi_active_page == PAGECON_0)) {
+		/*
+		* Current configuration is PAGE-0 and
+		* read request for PAGE-1
+		*/
+		da9052_spi_set_page(da9052, PAGECON_128);
+		/* Set register address accordindly */
+		sscmsg.addr = (sscmsg.addr - PAGE_1_START);
+	} else if ((sscmsg.addr < PAGE_1_START) &&
+		(da9052->spi_active_page == PAGECON_128)) {
+		/*
+		* Current configuration is PAGE-1 and
+		* write request for PAGE-0
+		*/
+		da9052_spi_set_page(da9052, PAGECON_0);
+	} else if (sscmsg.addr > PAGE_0_END) {
+		/*
+		* Current configuration is PAGE-1 and write
+		* request for PAGE-1
+		* Just need to adjust register address
+		*/
+		sscmsg.addr = (sscmsg.addr - PAGE_1_START);
+	}
+
+	/* Check value of R/W_POL bit of INTERFACE register */
+	if (da9052->rw_pol) {
+		/* We need to set 0th bit for read operation */
+		sscmsg.addr = ((sscmsg.addr << 1) | RW_POL);
+	} else {
+		/* We need to reset 0th bit for write operation */
+		sscmsg.addr = (sscmsg.addr << 1);
+	}
+
+	/* SMDK-6410 host SPI driver specific stuff */
+
+	/* Build our spi message */
+	spi_message_init(&message);
+	memset(&xfer, 0, sizeof(xfer));
+
+	xfer.len = 2;
+	xfer.tx_buf = da9052->spi_tx_buf;
+	xfer.rx_buf = da9052->spi_rx_buf;
+
+	da9052->spi_tx_buf[0] = sscmsg.addr;
+	da9052->spi_tx_buf[1] = 0xff;
+
+	da9052->spi_rx_buf[0] = 0;
+	da9052->spi_rx_buf[1] = 0;
+
+	spi_message_add_tail(&xfer, &message);
+
+	/* Now, do the i/o */
+	ret = spi_sync(da9052->spi_dev, &message);
+
+	if (ret == 0) {
+		/* Update read value in callers copy */
+		msg->data = da9052->spi_rx_buf[1];
+		return 0;
+	} else {
+		return ret;
+	}
+
+	return 0;
+}
+
+int da9052_spi_register(struct da9052 *da9052)
+{
+	da9052_spi = da9052;
+	return spi_register_driver(&da9052_spi_driver);
+}
+void da9052_spi_unregister()
+{
+	spi_unregister_driver(&da9052_spi_driver);
+}
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("SPI driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DA9052_SSC_SPI_DEVICE_NAME);
diff -uprN linux-2.6.34/drivers/mfd/Kconfig
linux-2.6.34_test/drivers/mfd/Kconfig
--- linux-2.6.34/drivers/mfd/Kconfig	2010-05-17 02:17:36.000000000
+0500
+++ linux-2.6.34_test/drivers/mfd/Kconfig	2010-06-28
19:11:42.000000000 +0500
@@ -399,6 +399,31 @@ config LPC_SCH
 	  LPC bridge function of the Intel SCH provides support for
 	  System Management Bus and General Purpose I/O.
 
+config MFD_DA9052_SPI
+	tristate "Dialog Semiconductor DA9052 PMIC SPI Support"
+	depends on SPI_MASTER=y
+	select MFD_CORE
+	select PMIC_DA9052
+	help
+	 SPI Support for the  Dialog semiconductor DA9052 PMIC.
+         This driver provides common support for accessing  the device,
+         additional drivers must be enabled in order to use the
+         functionality of the device.
+
+config MFD_DA9052_I2C
+	tristate "Dialog Semiconductor DA9052 PMIC I2C Support"
+	depends on I2C=y
+	select MFD_CORE
+	select PMIC_DA9052
+	help
+	 I2C Support for the  Dialog semiconductor DA9052 PMIC.
+         This driver provides common support for accessing  the device,
+         additional drivers must be enabled in order to use the
+         functionality of the device.
+
+config PMIC_DA9052
+	bool
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff -uprN linux-2.6.34/drivers/mfd/Makefile
linux-2.6.34_test/drivers/mfd/Makefile
--- linux-2.6.34/drivers/mfd/Makefile	2010-05-17 02:17:36.000000000
+0500
+++ linux-2.6.34_test/drivers/mfd/Makefile	2010-06-28
19:11:29.000000000 +0500
@@ -62,4 +62,14 @@ obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
 obj-$(CONFIG_AB4500_CORE)	+= ab4500-core.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
-obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
\ No newline at end of file
+obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
+
+ifeq ($(CONFIG_MFD_DA9052_SPI),y)
+da9052-objs			:= da9052-spi.o da9052-core.o
+obj-$(CONFIG_PMIC_DA9052)	+= da9052.o
+endif
+
+ifeq ($(CONFIG_MFD_DA9052_I2C),y)
+da9052-objs			:= da9052-i2c.o da9052-core.o
+obj-$(CONFIG_PMIC_DA9052)	+= da9052.o
+endif
\ No newline at end of file
diff -uprN linux-2.6.34/include/linux/mfd/da9052/da9052.h
linux-2.6.34_test/include/linux/mfd/da9052/da9052.h
--- linux-2.6.34/include/linux/mfd/da9052/da9052.h	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/include/linux/mfd/da9052/da9052.h	2010-06-28
19:08:50.000000000 +0500
@@ -0,0 +1,185 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052.h: DA9052 Core Header file
+ *
+ * This driver provides DA9052 specific wrappers around SPI and I2C
host -
+ * drivers and the functions to register/un-register with MFD core
+ * for DA9052 interrupt events.
+ */
+
+#ifndef _DA9052_H
+#define _DA9052_H
+
+#include <linux/slab.h>
+#include <linux/mfd/da9052/eh.h>
+
+#define DA9052_SSC_DEVICE_NAME		"da9052_ssc"
+#define DA9052_EH_DEVICE_NAME		"da9052_eh"
+
+/* Module specific error codes */
+#define INVALID_REGISTER		2
+#define INVALID_READ			3
+#define INVALID_PAGE			4
+
+/* Defines for Volatile and Non Volatile register types */
+#define VOLATILE			0
+#define NON_VOLATILE			1
+
+/* Defines for cache state */
+#define VALID				0
+#define INVALID				1
+
+/* Total number of registers in DA9057 */
+#define DA9052_REG_CNT			DA9052_PAGE1_REG_END
+
+/* Maximum number of registers that can be read/written by a singe
request */
+#define	MAX_READ_WRITE_CNT		16
+
+
+#if defined(CONFIG_MFD_DA9052_SPI)
+/* SPI device name as defined in board info */
+#define DA9052_SSC_SPI_DEVICE_NAME		"da9052_ssc_spi"
+
+/* Address of first and last registers on PAGE-0 */
+#define PAGE_0_START		1
+#define PAGE_0_END		127
+
+/* Address of first and last registers on PAGE-1 */
+#define PAGE_1_START		128
+#define PAGE_1_END		255
+
+#define ACTIVE_PAGE_0		0
+#define ACTIVE_PAGE_1		1
+
+#define PAGECON_0		0
+#define PAGECON_128		128
+
+#define RW_POL			1
+#elif defined(CONFIG_MFD_DA9052_I2C)
+/* I2C device name as defined in board info */
+#define DA9052_SSC_I2C_DEVICE_NAME		"da9052_ssc_i2c"
+
+/* Device slave address */
+#define	DA9052_I2C_ADDR				0x92
+
+/* I2C write modes */
+#define	DA9052_SSC_I2C_PAGE_WRITE_MODE		0
+#define DA9052_SSC_I2C_REPEAT_WRITE_MODE	1
+
+/* Default write mode */
+#define DA9052_SSC_I2C_WRITE_MODE
DA9052_SSC_I2C_REPEAT_WRITE_MODE
+#endif
+
+struct da9052_ssc_msg {
+	unsigned char data;
+	unsigned char addr;
+};
+
+struct ssc_cache_entry{
+	 unsigned char val;
+	 unsigned char	type:4;
+	 unsigned char	status:4;
+};
+
+struct da9052_eh_nb{
+	struct list_head nb_list;
+	unsigned char	eve_type;
+	void (*call_back)(struct da9052_eh_nb *nb_ptr, unsigned int);
+};
+
+struct regulator_init_data;
+
+struct da9052_regulator_init_data {
+	int id;
+	struct regulator_init_data *init_data;
+};
+
+struct da9052_regulator_platform_data {
+	int num_regulators;
+	struct da9052_regulator_init_data *regulators;
+};
+
+struct da9052_platform_data {
+	int num_regulators;
+	struct da9052_regulator_init_data *regulators;
+};
+
+struct da9052 {
+	struct mutex ssc_lock;
+	struct mutex eve_nb_lock;
+	struct work_struct eh_isr_work;
+	/* XXX these should go as platform data to the regulator sub
device */
+	struct da9052_regulator_init_data *regulators;
+	int num_regulators;
+	int (*read) (struct da9052 *da9052, struct da9052_ssc_msg
*sscmsg);
+	int (*write) (struct da9052 *da9052, struct da9052_ssc_msg
*sscmsg);
+	int (*read_many) (struct da9052 *da9052,
+		struct da9052_ssc_msg *sscmsg, int cnt);
+	int (*write_many)(struct da9052 *da9052,
+		struct da9052_ssc_msg *sscmsg, int cnt);
+	int (*register_event_notifier)(struct da9052 *da9052,
+					struct da9052_eh_nb *nb);
+	int (*unregister_event_notifier)(struct da9052 *da9052,
+					struct da9052_eh_nb *nb);
+#if defined(CONFIG_MFD_DA9052_SPI)
+	struct	spi_device *spi_dev;
+	unsigned int	spi_active_page;
+	unsigned char	rw_pol;
+	unsigned char	*spi_rx_buf;
+	unsigned char	*spi_tx_buf;
+#elif defined(CONFIG_MFD_DA9052_I2C)
+	struct i2c_client	*i2c_client;
+	struct device		*dev;
+	struct	i2c_adapter	*adapter;
+	unsigned char		slave_addr;
+#endif
+};
+
+struct da9052_ssc_ops {
+	int (*write)(struct da9052 *da9052, struct da9052_ssc_msg *msg);
+	int (*read)(struct da9052 *da9052, struct da9052_ssc_msg *msg);
+	int (*write_many)(struct da9052 *da9052,
+		struct da9052_ssc_msg *sscmsg, unsigned int msg_no);
+	int (*read_many)(struct da9052 *da9052,
+		struct da9052_ssc_msg *sscmsg, unsigned int msg_no);
+	int (*device_register)(struct da9052 *da9052);
+	void (*device_unregister)(void);
+};
+
+
+int da9052_ssc_write(struct da9052 *da9052, struct da9052_ssc_msg
*sscmsg);
+int da9052_ssc_read(struct da9052 *da9052, struct da9052_ssc_msg
*sscmsg);
+int da9052_ssc_write_many(struct da9052 *da9052,
+			struct da9052_ssc_msg *sscmsg, int cnt);
+int da9052_ssc_read_many(struct da9052 *da9052,
+			struct da9052_ssc_msg *sscmsg, int cnt);
+
+#if defined(CONFIG_MFD_DA9052_SPI)
+int da9052_spi_write(struct da9052 *da9052, struct da9052_ssc_msg
*msg);
+int da9052_spi_read(struct da9052 *da9052, struct da9052_ssc_msg *msg);
+int da9052_spi_register(struct da9052 *da9052);
+void da9052_spi_unregister(void);
+#elif defined(CONFIG_MFD_DA9052_I2C)
+/* I2C specific Functions */
+int da9052_i2c_write(struct da9052 *da9052, struct da9052_ssc_msg
*msg);
+int da9052_i2c_read(struct da9052 *da9052, struct da9052_ssc_msg *msg);
+int da9052_i2c_write_many(struct da9052 *da9052,
+	struct da9052_ssc_msg *sscmsg, unsigned int msg_no);
+int da9052_i2c_read_many(struct da9052 *da9052,
+	struct da9052_ssc_msg *sscmsg, unsigned int msg_no);
+int da9052_i2c_register(struct da9052 *da9052);
+void da9052_i2c_unregister(void);
+#endif
+
+void da9052_lock(struct da9052 *da9052);
+void da9052_unlock(struct da9052 *da9052);
+int eh_register_nb(struct da9052 *da9052, struct da9052_eh_nb *nb);
+int eh_unregister_nb(struct da9052 *da9052, struct da9052_eh_nb *nb);
+
+#endif /* _DA9052_H */
diff -uprN linux-2.6.34/include/linux/mfd/da9052/eh.h
linux-2.6.34_test/include/linux/mfd/da9052/eh.h
--- linux-2.6.34/include/linux/mfd/da9052/eh.h	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/include/linux/mfd/da9052/eh.h	2010-06-28
19:08:50.000000000 +0500
@@ -0,0 +1,148 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * eh.h: Header file for Event Handler module for DA9052 PM IC
+ *
+ * DA9052 has a single IRQ line which can be used to indicate 32
various events.
+ * Event Handler (EH) module has following primary functions.
+ *
+ * (1) To receive and acknowledge interrupts from DA9052.
+ * (2) Extract all events form DA9052 event registers after receiving
interrupt.
+ * (3) To provide a mechanism to register call back for specific events
of
+ *     their interest, and call these call backs when corresponding
+ *     event occurs.
+ * (4) To retrieve, store and provide TSI data whenever requested by
TSI module.
+ */
+
+#ifndef _EH_H
+#define _EH_H
+
+/* Platform specific defines */
+#define DA9052_IRQ		9
+
+/* Define for all possible events */
+#define		DCIN_DET_EVE	0
+#define		VBUS_DET_EVE	1
+#define		DCIN_REM_EVE	2
+#define		VBUS_REM_EVE	3
+#define		VDD_LOW_EVE	4
+#define		ALARM_EVE	5
+#define		SEQ_RDY_EVE	6
+#define		COMP_1V2	7
+#define		ONKEY_EVE	8
+#define		ID_FLOAT_EVE	9
+#define		ID_GND_EVE	10
+#define		CHG_END_EVE	11
+#define		TBAT_EVE	12
+#define		ADC_EOM_EVE	13
+#define		PEN_DOWN_EVE	14
+#define		TSI_READY_EVE	15
+#define		GPI0_EVE	16
+#define		GPI1_EVE	17
+#define		GPI2_EVE	18
+#define		GPI3_EVE	19
+#define		GPI4_EVE	20
+#define		GPI5_EVE	21
+#define		GPI6_EVE	22
+#define		GPI7_EVE	23
+#define		GPI8_EVE	24
+#define		GPI9_EVE	25
+#define		GPI10_EVE	26
+#define		GPI11_EVE	27
+#define		GPI12_EVE	28
+#define		GPI13_EVE	29
+#define		GPI14_EVE	30
+#define		GPI15_EVE	31
+
+/* Total number of events */
+#define		EVE_CNT		(GPI15_EVE+1)
+
+/* Priorities */
+#define		PRIO_0		0
+#define		PRIO_1		1
+#define		PRIO_2		2
+#define		PRIO_3		3
+#define		PRIO_4		4
+#define		PRIO_5		5
+#define		PRIO_6		6
+#define		PRIO_7		7
+#define		PRIO_8		8
+#define		PRIO_9		9
+#define		PRIO_10		10
+#define		PRIO_11		11
+#define		PRIO_12		12
+#define		PRIO_13		13
+#define		PRIO_14		14
+#define		PRIO_15		15
+#define		PRIO_16		16
+#define		PRIO_17		17
+#define		PRIO_18		18
+#define		PRIO_19		19
+#define		PRIO_20		20
+#define		PRIO_21		21
+#define		PRIO_22		22
+#define		PRIO_23		23
+#define		PRIO_24		24
+#define		PRIO_25		25
+#define		PRIO_26		26
+#define		PRIO_27		27
+#define		PRIO_28		28
+#define		PRIO_29		29
+#define		PRIO_30		30
+#define		PRIO_31		31
+
+/* Total number of priorities */
+#define		PRIO_CNT	(PRIO_31+1)
+
+/* Define for mapping events with their priorities */
+#define		PRIO_0_EVE	TSI_READY_EVE
+#define		PRIO_1_EVE	PEN_DOWN_EVE
+#define		PRIO_2_EVE	ONKEY_EVE
+#define		PRIO_3_EVE	VDD_LOW_EVE
+#define		PRIO_4_EVE	ADC_EOM_EVE
+#define		PRIO_5_EVE	ALARM_EVE
+#define		PRIO_6_EVE	SEQ_RDY_EVE
+#define		PRIO_7_EVE	COMP_1V2
+#define		PRIO_8_EVE	ID_FLOAT_EVE
+#define		PRIO_9_EVE	ID_GND_EVE
+#define		PRIO_10_EVE	CHG_END_EVE
+#define		PRIO_11_EVE	DCIN_DET_EVE
+#define		PRIO_12_EVE	VBUS_DET_EVE
+#define		PRIO_13_EVE	DCIN_REM_EVE
+#define		PRIO_14_EVE	VBUS_REM_EVE
+#define		PRIO_15_EVE	TBAT_EVE
+#define		PRIO_16_EVE	GPI0_EVE
+#define		PRIO_17_EVE	GPI1_EVE
+#define		PRIO_18_EVE	GPI2_EVE
+#define		PRIO_19_EVE	GPI3_EVE
+#define		PRIO_20_EVE	GPI4_EVE
+#define		PRIO_21_EVE	GPI5_EVE
+#define		PRIO_22_EVE	GPI6_EVE
+#define		PRIO_23_EVE	GPI7_EVE
+#define		PRIO_24_EVE	GPI8_EVE
+#define		PRIO_25_EVE	GPI9_EVE
+#define		PRIO_26_EVE	GPI10_EVE
+#define		PRIO_27_EVE	GPI11_EVE
+#define		PRIO_28_EVE	GPI12_EVE
+#define		PRIO_29_EVE	GPI13_EVE
+#define		PRIO_30_EVE	GPI14_EVE
+#define		PRIO_31_EVE	GPI15_EVE
+
+/* Error code for register/unregister functions */
+#define INVALID_NB	2
+#define INVALID_EVE	3
+
+/* State for EH thread */
+#define	ACTIVE		0
+#define	INACTIVE	1
+
+/* Status of nIRQ line */
+#define IRQ_HIGH	0
+#define IRQ_LOW		1
+
+#endif /* _EH_H */
diff -uprN linux-2.6.34/include/linux/mfd/da9052/reg.h
linux-2.6.34_test/include/linux/mfd/da9052/reg.h
--- linux-2.6.34/include/linux/mfd/da9052/reg.h	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/include/linux/mfd/da9052/reg.h	2010-06-28
19:08:50.000000000 +0500
@@ -0,0 +1,911 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * reg.h:	Register definition for DA9052
+ *
+*/
+
+#ifndef _REG_H
+#define _REG_H
+
+#define DA9052_PAGECON0_REG		(0)
+#define DA9052_STATUSA_REG		(1)
+#define DA9052_STATUSB_REG		(2)
+#define DA9052_STATUSC_REG		(3)
+#define DA9052_STATUSD_REG		(4)
+#define DA9052_EVENTA_REG		(5)
+#define DA9052_EVENTB_REG		(6)
+#define DA9052_EVENTC_REG		(7)
+#define DA9052_EVENTD_REG		(8)
+#define DA9052_FAULTLOG_REG		(9)
+#define DA9052_IRQMASKA_REG		(10)
+#define DA9052_IRQMASKB_REG		(11)
+#define DA9052_IRQMASKC_REG		(12)
+#define DA9052_IRQMASKD_REG		(13)
+#define DA9052_CONTROLA_REG		(14)
+#define DA9052_CONTROLB_REG		(15)
+#define DA9052_CONTROLC_REG		(16)
+#define DA9052_CONTROLD_REG		(17)
+#define DA9052_PDDIS_REG		(18)
+#define DA9052_INTERFACE_REG		(19)
+#define DA9052_RESET_REG		(20)
+#define DA9052_GPIO0001_REG		(21)
+#define DA9052_GPIO0203_REG		(22)
+#define DA9052_GPIO0405_REG		(23)
+#define DA9052_GPIO0607_REG		(24)
+#define DA9052_GPIO0809_REG		(25)
+#define DA9052_GPIO1011_REG		(26)
+#define DA9052_GPIO1213_REG		(27)
+#define DA9052_GPIO1415_REG		(28)
+#define DA9052_ID01_REG			(29)
+#define DA9052_ID23_REG			(30)
+#define DA9052_ID45_REG			(31)
+#define DA9052_ID67_REG			(32)
+#define DA9052_ID89_REG			(33)
+#define DA9052_ID1011_REG		(34)
+#define DA9052_ID1213_REG		(35)
+#define DA9052_ID1415_REG		(36)
+#define DA9052_ID1617_REG		(37)
+#define DA9052_ID1819_REG		(38)
+#define DA9052_ID2021_REG		(39)
+#define DA9052_SEQSTATUS_REG		(40)
+#define DA9052_SEQA_REG			(41)
+#define DA9052_SEQB_REG			(42)
+#define DA9052_SEQTIMER_REG		(43)
+#define DA9052_BUCKA_REG		(44)
+#define DA9052_BUCKB_REG		(45)
+#define DA9052_BUCKCORE_REG		(46)
+#define DA9052_BUCKPRO_REG		(47)
+#define DA9052_BUCKMEM_REG		(48)
+#define DA9052_BUCKPERI_REG		(49)
+#define DA9052_LDO1_REG			(50)
+#define DA9052_LDO2_REG			(51)
+#define DA9052_LDO3_REG			(52)
+#define DA9052_LDO4_REG			(53)
+#define DA9052_LDO5_REG			(54)
+#define DA9052_LDO6_REG			(55)
+#define DA9052_LDO7_REG			(56)
+#define DA9052_LDO8_REG			(57)
+#define DA9052_LDO9_REG			(58)
+#define DA9052_LDO10_REG		(59)
+#define DA9052_SUPPLY_REG		(60)
+#define DA9052_PULLDOWN_REG		(61)
+#define DA9052_CHGBUCK_REG		(62)
+#define DA9052_WAITCONT_REG		(63)
+#define DA9052_ISET_REG			(64)
+#define DA9052_BATCHG_REG		(65)
+#define DA9052_CHGCONT_REG		(66)
+#define DA9052_INPUTCONT_REG		(67)
+#define DA9052_CHGTIME_REG		(68)
+#define DA9052_BBATCONT_REG		(69)
+#define DA9052_BOOST_REG		(70)
+#define DA9052_LEDCONT_REG		(71)
+#define DA9052_LEDMIN123_REG		(72)
+#define DA9052_LED1CONF_REG		(73)
+#define DA9052_LED2CONF_REG		(74)
+#define DA9052_LED3CONF_REG		(75)
+#define DA9052_LED1CONT_REG		(76)
+#define DA9052_LED2CONT_REG		(77)
+#define DA9052_LED3CONT_REG		(78)
+#define DA9052_LED4CONT_REG		(79)
+#define DA9052_LED5CONT_REG		(80)
+#define DA9052_ADCMAN_REG		(81)
+#define DA9052_ADCCONT_REG		(82)
+#define DA9052_ADCRESL_REG		(83)
+#define DA9052_ADCRESH_REG		(84)
+#define DA9052_VDDRES_REG		(85)
+#define DA9052_VDDMON_REG		(86)
+#define DA9052_ICHGAV_REG		(87)
+#define DA9052_ICHGTHD_REG		(88)
+#define DA9052_ICHGEND_REG		(89)
+#define DA9052_TBATRES_REG		(90)
+#define DA9052_TBATHIGHP_REG		(91)
+#define DA9052_TBATHIGHIN_REG		(92)
+#define DA9052_TBATLOW_REG		(93)
+#define DA9052_TOFFSET_REG		(94)
+#define DA9052_ADCIN4RES_REG		(95)
+#define DA9052_AUTO4HIGH_REG		(96)
+#define DA9052_AUTO4LOW_REG		(97)
+#define DA9052_ADCIN5RES_REG		(98)
+#define DA9052_AUTO5HIGH_REG		(99)
+#define DA9052_AUTO5LOW_REG		(100)
+#define DA9052_ADCIN6RES_REG		(101)
+#define DA9052_AUTO6HIGH_REG		(102)
+#define DA9052_AUTO6LOW_REG		(103)
+#define DA9052_TJUNCRES_REG		(104)
+#define DA9052_TSICONTA_REG		(105)
+#define DA9052_TSICONTB_REG		(106)
+#define DA9052_TSIXMSB_REG		(107)
+#define DA9052_TSIYMSB_REG		(108)
+#define DA9052_TSILSB_REG		(109)
+#define DA9052_TSIZMSB_REG		(110)
+#define DA9052_COUNTS_REG		(111)
+#define DA9052_COUNTMI_REG		(112)
+#define DA9052_COUNTH_REG		(113)
+#define DA9052_COUNTD_REG		(114)
+#define DA9052_COUNTMO_REG		(115)
+#define DA9052_COUNTY_REG		(116)
+#define DA9052_ALARMMI_REG		(117)
+#define DA9052_ALARMH_REG		(118)
+#define DA9052_ALARMD_REG		(119)
+#define DA9052_ALARMMO_REG		(120)
+#define DA9052_ALARMY_REG		(121)
+#define DA9052_SECONDA_REG		(122)
+#define DA9052_SECONDB_REG		(123)
+#define DA9052_SECONDC_REG		(124)
+#define DA9052_SECONDD_REG		(125)
+#define DA9052_PAGECON128_REG		(128)
+#define DA9052_CHIPID_REG		(129)
+#define DA9052_CONFIGID_REG		(130)
+#define DA9052_OTPCONT_REG		(131)
+#define DA9052_OSCTRIM_REG		(132)
+#define DA9052_GPID0_REG		(133)
+#define DA9052_GPID1_REG		(134)
+#define DA9052_GPID2_REG		(135)
+#define DA9052_GPID3_REG		(136)
+#define DA9052_GPID4_REG		(137)
+#define DA9052_GPID5_REG		(138)
+#define DA9052_GPID6_REG		(139)
+#define DA9052_GPID7_REG		(140)
+#define DA9052_GPID8_REG		(141)
+#define DA9052_GPID9_REG		(142)
+
+#define DA9052_PAGE0_REG_START	(DA9052_STATUSA_REG)
+#define DA9052_PAGE0_REG_END	(DA9052_SECONDD_REG)
+
+#define DA9052_PAGE1_REG_START	(DA9052_CHIPID_REG)
+#define DA9052_PAGE1_REG_END	(DA9052_GPID9_REG)
+
+/************************PAGE CONFIGURATION
***************************/
+
+/* Reg Page Configuration */
+#define DA9052_PAGECON0_REGPAGE		(1<<7)
+
+/* PAGE CONFIGURATION 128 REGISTER */
+#define DA9052_PAGECON128_REGPAGE	(1<<7)
+
+/************************SYSTEM REGISTER ***************************/
+
+/* STATUS REGISTER A */
+#define DA9052_STATUSA_VDATDET		(1<<7)
+#define DA9052_STATUSA_VBUSSEL		(1<<6)
+#define DA9052_STATUSA_DCINSEL		(1<<5)
+#define DA9052_STATUSA_VBUSDET		(1<<4)
+#define DA9052_STATUSA_DCINDET		(1<<3)
+#define DA9052_STATUSA_IDGND		(1<<2)
+#define DA9052_STATUSA_IDFLOAT		(1<<1)
+#define DA9052_STATUSA_NONKEY		(1<<0)
+
+
+/* STATUS REGISTER B */
+#define DA9052_STATUSB_COMPDET		(1<<7)
+#define DA9052_STATUSB_SEQUENCING	(1<<6)
+#define DA9052_STATUSB_GPFB2		(1<<5)
+#define DA9052_STATUSB_CHGTO		(1<<4)
+#define DA9052_STATUSB_CHGEND		(1<<3)
+#define DA9052_STATUSB_CHGLIM		(1<<2)
+#define DA9052_STATUSB_CHGPRE		(1<<1)
+#define DA9052_STATUSB_CHGATT		(1<<0)
+
+
+/* STATUS REGISTER C */
+#define DA9052_STATUSC_GPI7		(1<<7)
+#define DA9052_STATUSC_GPI6		(1<<6)
+#define DA9052_STATUSC_GPI5		(1<<5)
+#define DA9052_STATUSC_GPI4		(1<<4)
+#define DA9052_STATUSC_GPI3		(1<<3)
+#define DA9052_STATUSC_GPI2		(1<<2)
+#define DA9052_STATUSC_GPI1		(1<<1)
+#define DA9052_STATUSC_GPI0		(1<<0)
+
+
+/* STATUS REGISTER D */
+#define DA9052_STATUSD_GPI15		(1<<7)
+#define DA9052_STATUSD_GPI14		(1<<6)
+#define DA9052_STATUSD_GPI13		(1<<5)
+#define DA9052_STATUSD_GPI12		(1<<4)
+#define DA9052_STATUSD_GPI11		(1<<3)
+#define DA9052_STATUSD_GPI10		(1<<2)
+#define DA9052_STATUSD_GPI9		(1<<1)
+#define DA9052_STATUSD_GPI8		(1<<0)
+
+
+/* EVENT REGISTER A */
+#define DA9052_EVENTA_ECOMP1V2		(1<<7)
+#define DA9052_EVENTA_ESEQRDY		(1<<6)
+#define DA9052_EVENTA_EALRAM		(1<<5)
+#define DA9052_EVENTA_EVDDLOW		(1<<4)
+#define DA9052_EVENTA_EVBUSREM		(1<<3)
+#define DA9052_EVENTA_EDCINREM		(1<<2)
+#define DA9052_EVENTA_EVBUSDET		(1<<1)
+#define DA9052_EVENTA_EDCINDET		(1<<0)
+
+/* EVENT REGISTER B */
+#define DA9052_EVENTB_ETSIREADY		(1<<7)
+#define DA9052_EVENTB_EPENDOWN		(1<<6)
+#define DA9052_EVENTB_EADCEOM		(1<<5)
+#define DA9052_EVENTB_ETBAT		(1<<4)
+#define DA9052_EVENTB_ECHGEND		(1<<3)
+#define DA9052_EVENTB_EIDGND		(1<<2)
+#define DA9052_EVENTB_EIDFLOAT		(1<<1)
+#define DA9052_EVENTB_ENONKEY		(1<<0)
+
+/* EVENT REGISTER C */
+#define DA9052_EVENTC_EGPI7		(1<<7)
+#define DA9052_EVENTC_EGPI6		(1<<6)
+#define DA9052_EVENTC_EGPI5		(1<<5)
+#define DA9052_EVENTC_EGPI4		(1<<4)
+#define DA9052_EVENTC_EGPI3		(1<<3)
+#define DA9052_EVENTC_EGPI2		(1<<2)
+#define DA9052_EVENTC_EGPI1		(1<<1)
+#define DA9052_EVENTC_EGPI0		(1<<0)
+
+/* EVENT REGISTER D */
+#define DA9052_EVENTC_EGPI15		(1<<7)
+#define DA9052_EVENTC_EGPI14		(1<<6)
+#define DA9052_EVENTC_EGPI13		(1<<5)
+#define DA9052_EVENTC_EGPI12		(1<<4)
+#define DA9052_EVENTC_EGPI11		(1<<3)
+#define DA9052_EVENTC_EGPI10		(1<<2)
+#define DA9052_EVENTC_EGPI9		(1<<1)
+#define DA9052_EVENTC_EGPI8		(1<<0)
+
+
+/* FAULT LOG REGISTER */
+#define DA9052_FAULTLOG_WAITSET		(1<<7)
+#define DA9052_FAULTLOG_NSDSET		(1<<6)
+#define DA9052_FAULTLOG_KEYSHUT		(1<<5)
+#define DA9052_FAULTLOG_TEMPOVER	(1<<3)
+#define DA9052_FAULTLOG_VDDSTART	(1<<2)
+#define DA9052_FAULTLOG_VDDFAULT	(1<<1)
+#define DA9052_FAULTLOG_TWDERROR	(1<<0)
+
+/* IRQ_MASK REGISTER A */
+#define DA9052_IRQMASKA_MCOMP1V2	(1<<7)
+#define DA9052_IRQMASKA_MSEQRDY		(1<<6)
+#define DA9052_IRQMASKA_MALRAM		(1<<5)
+#define DA9052_IRQMASKA_MVDDLOW		(1<<4)
+#define DA9052_IRQMASKA_MVBUSREM	(1<<3)
+#define DA9052_IRQMASKA_MDCINREM	(1<<2)
+#define DA9052_IRQMASKA_MVBUSVLD	(1<<1)
+#define DA9052_IRQMASKA_MDCINVLD	(1<<0)
+
+/* IRQ_MASK REGISTER B */
+#define DA9052_IRQMASKB_MTSIREADY	(1<<7)
+#define DA9052_IRQMASKB_MPENDOWN	(1<<6)
+#define DA9052_IRQMASKB_MADCEOM		(1<<5)
+#define DA9052_IRQMASKB_MTBAT		(1<<4)
+#define DA9052_IRQMASKB_MCHGEND		(1<<3)
+#define DA9052_IRQMASKB_MIDGND		(1<<2)
+#define DA9052_IRQMASKB_MIDFLOAT	(1<<1)
+#define DA9052_IRQMASKB_MNONKEY		(1<<0)
+
+/* IRQ_MASK REGISTER C */
+#define DA9052_IRQMASKC_MGPI7		(1<<7)
+#define DA9052_IRQMASKC_MGPI6		(1<<6)
+#define DA9052_IRQMASKC_MGPI5		(1<<5)
+#define DA9052_IRQMASKC_MGPI4		(1<<4)
+#define DA9052_IRQMASKC_MGPI3		(1<<3)
+#define DA9052_IRQMASKC_MGPI2		(1<<2)
+#define DA9052_IRQMASKC_MGPI1		(1<<1)
+#define DA9052_IRQMASKC_MGPI0		(1<<0)
+
+/* IRQ_MASK REGISTER D */
+#define DA9052_IRQMASKD_MGPI15		(1<<7)
+#define DA9052_IRQMASKD_MGPI14		(1<<6)
+#define DA9052_IRQMASKD_MGPI13		(1<<5)
+#define DA9052_IRQMASKD_MGPI12		(1<<4)
+#define DA9052_IRQMASKD_MGPI11		(1<<3)
+#define DA9052_IRQMASKD_MGPI10		(1<<2)
+#define DA9052_IRQMASKD_MGPI9		(1<<1)
+#define DA9052_IRQMASKD_MGPI8		(1<<0)
+
+/* CONTROL REGISTER A */
+#define DA9052_CONTROLA_GPIV		(1<<7)
+#define DA9052_CONTROLA_PMOTYPE		(1<<5)
+#define DA9052_CONTROLA_PMOV		(1<<4)
+#define DA9052_CONTROLA_PMIV		(1<<3)
+#define DA9052_CONTROLA_PMIFV		(1<<3)
+#define DA9052_CONTROLA_PWR1EN		(1<<2)
+#define DA9052_CONTROLA_PWREN		(1<<1)
+#define DA9052_CONTROLA_SYSEN		(1<<0)
+
+/* CONTROL REGISTER B */
+#define DA9052_CONTROLB_SHUTDOWN	(1<<7)
+#define DA9052_CONTROLB_DEEPSLEEP	(1<<6)
+#define DA9052_CONTROLB_WRITEMODE	(1<<5)
+#define DA9052_CONTROLB_BBATEN		(1<<4)
+#define DA9052_CONTROLB_OTPREADEN	(1<<3)
+#define DA9052_CONTROLB_AUTOBOOT	(1<<2)
+#define DA9052_CONTROLB_ACTDIODE	(1<<1)
+#define DA9052_CONTROLB_BUCKMERGE	(1<<0)
+
+/* CONTROL REGISTER C */
+#define DA9052_CONTROLC_BLINKDUR	(1<<7)
+#define DA9052_CONTROLC_BLINKFRQ	(3<<5)
+#define DA9052_CONTROLC_DEBOUNCING	(7<<2)
+#define DA9052_CONTROLC_PMFB2PIN	(1<<1)
+#define DA9052_CONTROLC_PMFB1PIN	(1<<0)
+
+/* CONTROL REGISTER D */
+#define DA9052_CONTROLD_WATCHDOG	(1<<7)
+#define DA9052_CONTROLD_ACCDETEN	(1<<6)
+#define DA9052_CONTROLD_GPI1415SD	(1<<5)
+#define DA9052_CONTROLD_NONKEYSD	(1<<4)
+#define DA9052_CONTROLD_KEEPACTEN	(1<<3)
+#define DA9052_CONTROLD_TWDSCALE	(7<<0)
+
+/* POWER DOWN DISABLE REGISTER */
+#define DA9052_PDDIS_PMCONTPD		(1<<7)
+#define DA9052_PDDIS_OUT32KPD		(1<<6)
+#define DA9052_PDDIS_CHGBBATPD		(1<<5)
+#define DA9052_PDDIS_CHGPD		(1<<4)
+#define DA9052_PDDIS_HS2WIREPD		(1<<3)
+#define DA9052_PDDIS_PMIFPD		(1<<2)
+#define DA9052_PDDIS_GPADCPD		(1<<1)
+#define DA9052_PDDIS_GPIOPD		(1<<0)
+
+/* CONTROL REGISTER D */
+#define DA9052_INTERFACE_IFBASEADDR	(7<<5)
+#define DA9052_INTERFACE_NCSPOL		(1<<4)
+#define DA9052_INTERFACE_RWPOL		(1<<3)
+#define DA9052_INTERFACE_CPHA		(1<<2)
+#define DA9052_INTERFACE_CPOL		(1<<1)
+#define DA9052_INTERFACE_IFTYPE		(1<<0)
+
+/* CONTROL REGISTER D */
+#define DA9052_RESET_RESETEVENT		(3<<6)
+#define DA9052_RESET_RESETTIMER		(63<<0)
+
+/************************GPIO REGISTERS***************************/
+
+/* GPIO control register for PIN 0 and 1 */
+#define DA9052_GPIO0001_GPIO1MODE	(1<<7)
+#define DA9052_GPIO0001_GPIO1TYPE	(1<<6)
+#define DA9052_GPIO0001_GPIO1PIN	(3<<4)
+#define DA9052_GPIO0001_GPIO0MODE	(1<<3)
+#define DA9052_GPIO0001_GPIO0TYPE	(1<<2)
+#define DA9052_GPIO0001_GPIO0PIN	(3<<0)
+
+/* GPIO control register for PIN 2 and 3 */
+#define DA9052_GPIO0203_GPIO3MODE	(1<<7)
+#define DA9052_GPIO0203_GPIO3TYPE	(1<<6)
+#define DA9052_GPIO0203_GPIO3PIN	(3<<4)
+#define DA9052_GPIO0203_GPIO2MODE	(1<<3)
+#define DA9052_GPIO0203_GPIO2TYPE	(1<<2)
+#define DA9052_GPIO0203_GPIO2PIN	(3<<0)
+
+/* GPIO control register for PIN 4 and 5 */
+#define DA9052_GPIO0405_GPIO5MODE	(1<<7)
+#define DA9052_GPIO0405_GPIO5TYPE	(1<<6)
+#define DA9052_GPIO0405_GPIO5PIN	(3<<4)
+#define DA9052_GPIO0405_GPIO4MODE	(1<<3)
+#define DA9052_GPIO0405_GPIO4TYPE	(1<<2)
+#define DA9052_GPIO0405_GPIO4PIN	(3<<0)
+
+/* GPIO control register for PIN 6 and 7 */
+#define DA9052_GPIO0607_GPIO7MODE	(1<<7)
+#define DA9052_GPIO0607_GPIO7TYPE	(1<<6)
+#define DA9052_GPIO0607_GPIO7PIN	(3<<4)
+#define DA9052_GPIO0607_GPIO6MODE	(1<<3)
+#define DA9052_GPIO0607_GPIO6TYPE	(1<<2)
+#define DA9052_GPIO0607_GPIO6PIN	(3<<0)
+
+/* GPIO control register for PIN 8 and 9 */
+#define DA9052_GPIO0809_GPIO9MODE	(1<<7)
+#define DA9052_GPIO0809_GPIO9TYPE	(1<<6)
+#define DA9052_GPIO0809_GPIO9PIN	(3<<4)
+#define DA9052_GPIO0809_GPIO8MODE	(1<<3)
+#define DA9052_GPIO0809_GPIO8TYPE	(1<<2)
+#define DA9052_GPIO0809_GPIO8PIN	(3<<0)
+
+/* GPIO control register for PIN 10 and 11 */
+#define DA9052_GPIO1011_GPIO11MODE	(1<<7)
+#define DA9052_GPIO1011_GPIO11TYPE	(1<<6)
+#define DA9052_GPIO1011_GPIO11PIN	(3<<4)
+#define DA9052_GPIO1011_GPIO10MODE	(1<<3)
+#define DA9052_GPIO1011_GPIO10TYPE	(1<<2)
+#define DA9052_GPIO1011_GPIO10PIN	(3<<0)
+
+/* GPIO control register for PIN 12 and 13 */
+#define DA9052_GPIO1213_GPIO13MODE	(1<<7)
+#define DA9052_GPIO1213_GPIO13TYPE	(1<<6)
+#define DA9052_GPIO1213_GPIO13PIN	(3<<4)
+#define DA9052_GPIO1213_GPIO12MODE	(1<<3)
+#define DA9052_GPIO1213_GPIO12TYPE	(1<<2)
+#define DA9052_GPIO1213_GPIO12PIN	(3<<0)
+
+/* GPIO control register for PIN 14 and 15 */
+#define DA9052_GPIO1415_GPIO15MODE	(1<<7)
+#define DA9052_GPIO1415_GPIO15TYPE	(1<<6)
+#define DA9052_GPIO1415_GPIO15PIN	(3<<4)
+#define DA9052_GPIO1415_GPIO14MODE	(1<<3)
+#define DA9052_GPIO1415_GPIO14TYPE	(1<<2)
+#define DA9052_GPIO1415_GPIO14PIN	(3<<0)
+
+/*****************POWER SEQUENCER REGISTER*********************/
+
+/* SEQ control register for ID 0 and 1 */
+#define DA9052_ID01_LDO1STEP		(15<<4)
+#define DA9052_ID01_SYSPRE		(1<<2)
+#define DA9052_ID01_DEFSUPPLY		(1<<1)
+#define DA9052_ID01_nRESMODE		(1<<0)
+
+/* SEQ control register for ID 2 and 3 */
+#define DA9052_ID23_LDO3STEP		(15<<4)
+#define DA9052_ID23_LDO2STEP		(15<<0)
+
+/* SEQ control register for ID 4 and 5 */
+#define DA9052_ID45_LDO5STEP		(15<<4)
+#define DA9052_ID45_LDO4STEP		(15<<0)
+
+/* SEQ control register for ID 6 and 7 */
+#define DA9052_ID67_LDO7STEP		(15<<4)
+#define DA9052_ID67_LDO6STEP		(15<<0)
+
+/* SEQ control register for ID 8 and 9 */
+#define DA9052_ID89_LDO9STEP		(15<<4)
+#define DA9052_ID89_LDO8STEP		(15<<0)
+
+/* SEQ control register for ID 10 and 11 */
+#define DA9052_ID1011_PDDISSTEP		(15<<4)
+#define DA9052_ID1011_LDO10STEP		(15<<0)
+
+/* SEQ control register for ID 12 and 13 */
+#define DA9052_ID1213_VMEMSWSTEP	(15<<4)
+#define DA9052_ID1213_VPERISWSTEP	(15<<0)
+
+/* SEQ control register for ID 14 and 15 */
+#define DA9052_ID1415_BUCKPROSTEP	(15<<4)
+#define DA9052_ID1415_BUCKCORESTEP	(15<<0)
+
+/* SEQ control register for ID 16 and 17 */
+#define DA9052_ID1617_BUCKPERISTEP	(15<<4)
+#define DA9052_ID1617_BUCKMEMSTEP	(15<<0)
+
+/* SEQ control register for ID 18 and 19 */
+#define DA9052_ID1819_GPRISE2STEP	(15<<4)
+#define DA9052_ID1819_GPRISE1STEP	(15<<0)
+
+/* SEQ control register for ID 20 and 21 */
+#define DA9052_ID2021_GPFALL2STEP	(15<<4)
+#define DA9052_ID2021_GPFALL1STEP	(15<<0)
+
+/* Power SEQ Status register */
+#define DA9052_SEQSTATUS_SEQPOINTER	(15<<4)
+#define DA9052_SEQSTATUS_WAITSTEP	(15<<0)
+
+/* Power SEQ A register */
+#define DA9052_SEQA_POWEREND		(15<<4)
+#define DA9052_SEQA_SYSTEMEND		(15<<0)
+
+/* Power SEQ B register */
+#define DA9052_SEQB_PARTDOWN		(15<<4)
+#define DA9052_SEQB_MAXCOUNT		(15<<0)
+
+/* Power SEQ TIMER register */
+#define DA9052_SEQTIMER_SEQDUMMY	(15<<4)
+#define DA9052_SEQTIMER_SEQTIME		(15<<0)
+
+/*****************POWER SUPPLY CONTROL REGISTER*********************/
+
+/* BUCK REGISTER A */
+#define DA9052_BUCKA_BPROILIM		(3<<6)
+#define DA9052_BUCKA_BPROMODE		(3<<4)
+#define DA9052_BUCKA_BCOREILIM		(3<<2)
+#define DA9052_BUCKA_BCOREMODE		(3<<0)
+
+/* BUCK REGISTER B */
+#define DA9052_BUCKB_BERIILIM		(3<<6)
+#define DA9052_BUCKB_BPERIMODE		(3<<4)
+#define DA9052_BUCKB_BMEMILIM		(3<<2)
+#define DA9052_BUCKB_BMEMMODE		(3<<0)
+
+/* BUCKCORE REGISTER */
+#define DA9052_BUCKCORE_BCORECONF	(1<<7)
+#define DA9052_BUCKCORE_BCOREEN		(1<<6)
+#define DA9052_BUCKCORE_VBCORE		(63<<0)
+
+/* BUCKPRO REGISTER */
+#define DA9052_BUCKPRO_BPROCONF		(1<<7)
+#define DA9052_BUCKPRO_BPROEN		(1<<6)
+#define DA9052_BUCKPRO_VBPRO		(63<<0)
+
+/* BUCKMEM REGISTER */
+#define DA9052_BUCKMEM_BMEMCONF		(1<<7)
+#define DA9052_BUCKMEM_BMEMEN		(1<<6)
+#define DA9052_BUCKMEM_VBMEM		(63<<0)
+
+/* BUCKPERI REGISTER */
+#define DA9052_BUCKPERI_BPERICONF	(1<<7)
+#define DA9052_BUCKPERI_BPERIEN		(1<<6)
+#define DA9052_BUCKPERI_BPERIHS		(1<<5)
+#define DA9052_BUCKPERI_VBPERI		(31<<0)
+
+/* LDO1 REGISTER */
+#define DA9052_LDO1_LDO1CONF		(1<<7)
+#define DA9052_LDO1_LDO1EN		(1<<6)
+#define DA9052_LDO1_VLDO1		(31<<0)
+
+/* LDO2 REGISTER */
+#define DA9052_LDO2_LDO2CONF		(1<<7)
+#define DA9052_LDO2_LDO2EN		(1<<6)
+#define DA9052_LDO2_VLDO2		(63<<0)
+
+/* LDO3 REGISTER */
+#define DA9052_LDO3_LDO3CONF		(1<<7)
+#define DA9052_LDO3_LDO3EN		(1<<6)
+#define DA9052_LDO3_VLDO3		(63<<0)
+
+/* LDO4 REGISTER */
+#define DA9052_LDO4_LDO4CONF		(1<<7)
+#define DA9052_LDO4_LDO4EN		(1<<6)
+#define DA9052_LDO4_VLDO4		(63<<0)
+
+/* LDO5 REGISTER */
+#define DA9052_LDO5_LDO5CONF		(1<<7)
+#define DA9052_LDO5_LDO5EN		(1<<6)
+#define DA9052_LDO5_VLDO5		(63<<0)
+
+/* LDO6 REGISTER */
+#define DA9052_LDO6_LDO6CONF		(1<<7)
+#define DA9052_LDO6_LDO6EN		(1<<6)
+#define DA9052_LDO6_VLDO6		(63<<0)
+
+/* LDO7 REGISTER */
+#define DA9052_LDO7_LDO7CONF		(1<<7)
+#define DA9052_LDO7_LDO7EN		(1<<6)
+#define DA9052_LDO7_VLDO7		(63<<0)
+
+/* LDO8 REGISTER */
+#define DA9052_LDO8_LDO8CONF		(1<<7)
+#define DA9052_LDO8_LDO8EN		(1<<6)
+#define DA9052_LDO8_VLDO8		(63<<0)
+
+/* LDO9 REGISTER */
+#define DA9052_LDO9_LDO9CONF		(1<<7)
+#define DA9052_LDO9_LDO9EN		(1<<6)
+#define DA9052_LDO9_VLDO9		(63<<0)
+
+/* LDO10 REGISTER */
+#define DA9052_LDO10_LDO10CONF		(1<<7)
+#define DA9052_LDO10_LDO10EN		(1<<6)
+#define DA9052_LDO10_VLDO10		(63<<0)
+
+/* SUPPLY REGISTER */
+#define DA9052_SUPPLY_VLOCK		(1<<7)
+#define DA9052_SUPPLY_VMEMSWEN		(1<<6)
+#define DA9052_SUPPLY_VPERISWEN		(1<<5)
+#define DA9052_SUPPLY_VLDO3GO		(1<<4)
+#define DA9052_SUPPLY_VLDO2GO		(1<<3)
+#define DA9052_SUPPLY_VBMEMGO		(1<<2)
+#define DA9052_SUPPLY_VBPROGO		(1<<1)
+#define DA9052_SUPPLY_VBCOREGO		(1<<0)
+
+/* PULLDOWN REGISTER */
+#define DA9052_PULLDOWN_LDO5PDDIS	(1<<5)
+#define DA9052_PULLDOWN_LDO2PDDIS	(1<<4)
+#define DA9052_PULLDOWN_LDO1PDDIS	(1<<3)
+#define DA9052_PULLDOWN_MEMPDDIS	(1<<2)
+#define DA9052_PULLDOWN_PROPDDIS	(1<<1)
+#define DA9052_PULLDOWN_COREPDDIS	(1<<0)
+
+/*****************BAT CHARGER REGISTER *********************/
+
+/* CHARGER BUCK REGISTER */
+#define DA9052_CHGBUCK_CHGTEMP		(1<<7)
+#define DA9052_CHGBUCK_CHGUSBILIM	(1<<6)
+#define DA9052_CHGBUCK_CHGBUCKLP	(1<<5)
+#define DA9052_CHGBUCK_CHGBUCKEN	(1<<4)
+#define DA9052_CHGBUCK_ISETBUCK		(15<<0)
+
+/* WAIT COUNTER REGISTER */
+#define DA9052_WAITCONT_WAITDIR		(1<<7)
+#define DA9052_WAITCONT_RTCCLOCK	(1<<6)
+#define DA9052_WAITCONT_WAITMODE	(1<<5)
+#define DA9052_WAITCONT_EN32KOUT	(1<<4)
+#define DA9052_WAITCONT_DELAYTIME	(15<<0)
+
+/* ISET CONTROL REGISTER */
+#define DA9052_ISET_ISETDCIN		(15<<4)
+#define DA9052_ISET_ISETVBUS		(15<<0)
+
+/* BATTERY CHARGER CONTROL REGISTER */
+#define DA9052_BATCHG_ICHGPRE		(3<<6)
+#define DA9052_BATCHG_ICHGBAT		(63<<0)
+
+/* CHARGER COUNTER REGISTER */
+#define DA9052_CHGCONT_VCHGBAT		(31<<3)
+#define DA9052_CHGCONT_TCTR		(7<<0)
+
+/* INPUT CONTROL REGISTER */
+#define DA9052_INPUTCONT_TCTRMODE	(1<<7)
+#define DA9052_INPUTCONT_ICHGLOW	(1<<5)
+#define DA9052_INPUTCONT_VBUSSUSP	(1<<4)
+#define DA9052_INPUTCONT_DCINSUSP	(1<<3)
+#define DA9052_INPUTCONT_VCHGTHR	(7<<0)
+
+/* CHARGING TIME REGISTER */
+#define DA9052_CHGTIME_CHGTIME		(255<<0)
+
+/* BACKUP BATTERY CONTROL REGISTER */
+#define DA9052_BBATCONT_BCHARGERISET	(15<<4)
+#define DA9052_BBATCONT_BCHARGERVSET	(15<<0)
+
+/*****************LED REGISTERS********************/
+
+/* LED BOOST REGISTER */
+#define DA9052_BOOST_EBFAULT		(1<<7)
+#define DA9052_BOOST_MBFAULT		(1<<6)
+#define DA9052_BOOST_BOOSTFRQ		(1<<5)
+#define DA9052_BOOST_BOOSTILIM		(1<<4)
+#define DA9052_BOOST_LED3INEN		(1<<3)
+#define DA9052_BOOST_LED2INEN		(1<<2)
+#define DA9052_BOOST_LED1INEN		(1<<1)
+#define DA9052_BOOST_BOOSTEN		(1<<0)
+
+/* LED COUNT REGISTER */
+#define DA9052_LEDCONT_LED3ICONT	(1<<6)
+#define DA9052_LEDCONT_LED3RAMP		(1<<5)
+#define DA9052_LEDCONT_LED3EN		(1<<4)
+#define DA9052_LEDCONT_LED2RAMP		(1<<3)
+#define DA9052_LEDCONT_LED2EN		(1<<2)
+#define DA9052_LEDCONT_LED1RAMP		(1<<1)
+#define DA9052_LEDCONT_LED1EN		(1<<0)
+
+/* LEDMIN123  REGISTER */
+#define DA9052_LEDMIN123_LEDMINCURRENT	(255<<0)
+
+/* LED1CONF  REGISTER */
+#define DA9052_LED1CONF_LED1CURRENT	(255<<0)
+
+/* LED2CONF  REGISTER */
+#define DA9052_LED2CONF_LED2CURRENT	(255<<0)
+
+/* LED3CONF  REGISTER */
+#define DA9052_LED3CONF_LED3CURRENT	(255<<0)
+
+/* LED1 COUNT  REGISTER */
+#define DA9052_LED1CONT_LED1DIM		(1<<7)
+#define DA9052_LED1CONT_LED1PWM		(127<<0)
+
+/* LED2 COUNT  REGISTER */
+#define DA9052_LED2CONT_LED2DIM		(1<<7)
+#define DA9052_LED2CONT_LED2PWM		(127<<0)
+
+/* LED3 COUNT  REGISTER */
+#define DA9052_LED3CONT_LED3DIM		(1<<7)
+#define DA9052_LED3CONT_LED3PWM		(127<<0)
+
+/* LED4 COUNT  REGISTER */
+#define DA9052_LED4CONT_LED4DIM		(1<<7)
+#define DA9052_LED4CONT_LED4PWM		(127<<0)
+
+/* LED5 COUNT  REGISTER */
+#define DA9052_LED5CONT_LED5DIM		(1<<7)
+#define DA9052_LED5CONT_LED5PWM		(127<<0)
+
+/*****************ADC REGISTERS********************/
+
+/* ADC MAN registers */
+#define DA9052_ADCMAN_MANCONV		(1<<4)
+#define DA9052_ADCMAN_MUXSEL		(15<<0)
+
+/* ADC COUNT regsisters */
+#define DA9052_ADCCONT_COMP1V2EN	(1<<7)
+#define DA9052_ADCCONT_ADCMODE		(1<<6)
+#define DA9052_ADCCONT_TBATISRCEN	(1<<5)
+#define DA9052_ADCCONT_AD4ISRCEN	(1<<4)
+#define DA9052_ADCCONT_AUTOAD6EN	(1<<3)
+#define DA9052_ADCCONT_AUTOAD5EN	(1<<2)
+#define DA9052_ADCCONT_AUTOAD4EN	(1<<1)
+#define DA9052_ADCCONT_AUTOVDDEN	(1<<0)
+
+/* ADC 10 BIT MANUAL CONVERSION RESULT LOW register */
+#define DA9052_ADCRESL_ADCRESLSB	(3<<0)
+
+/* ADC 10 BIT MANUAL CONVERSION RESULT HIGH register */
+#define DA9052_ADCRESH_ADCRESMSB	(255<<0)
+
+/* VDD RES regsister*/
+#define DA9052_VDDRES_VDDOUTRES		(255<<0)
+
+/* VDD MON regsister*/
+#define DA9052_VDDMON_VDDOUTMON		(255<<0)
+
+/* ICHG_AV regsister*/
+#define DA9052_ICHGAV_ICHGAV		(255<<0)
+
+/* ICHG_THD regsister*/
+#define DA9052_ICHGTHD_ICHGTHD		(255<<0)
+
+/* ICHG_END regsister*/
+#define DA9052_ICHGEND_ICHGEND		(255<<0)
+
+/* TBAT_RES regsister*/
+#define DA9052_TBATRES_TBATRES		(255<<0)
+
+/* TBAT_HIGHP regsister*/
+#define DA9052_TBATHIGHP_TBATHIGHP	(255<<0)
+
+/* TBAT_HIGHN regsister*/
+#define DA9052_TBATHIGHN_TBATHIGHN	(255<<0)
+
+/* TBAT_LOW regsister*/
+#define DA9052_TBATLOW_TBATLOW		(255<<0)
+
+/* T_OFFSET regsister*/
+#define DA9052_TOFFSET_TOFFSET		(255<<0)
+
+/* ADCIN4_RES regsister*/
+#define DA9052_ADCIN4RES_ADCIN4RES	(255<<0)
+
+/* ADCIN4_HIGH regsister*/
+#define DA9052_AUTO4HIGH_AUTO4HIGH	(255<<0)
+
+/* ADCIN4_LOW regsister*/
+#define DA9052_AUTO4LOW_AUTO4LOW	(255<<0)
+
+/* ADCIN5_RES regsister*/
+#define DA9052_ADCIN5RES_ADCIN5RES	(255<<0)
+
+/* ADCIN5_HIGH regsister*/
+#define DA9052_AUTO5HIGH_AUTOHIGH	(255<<0)
+
+/* ADCIN5_LOW regsister*/
+#define DA9052_AUTO5LOW_AUTO5LOW	(255<<0)
+
+/* ADCIN6_RES regsister*/
+#define DA9052_ADCIN6RES_ADCIN6RES	(255<<0)
+
+/* ADCIN6_HIGH regsister*/
+#define DA9052_AUTO6HIGH_AUTO6HIGH	(255<<0)
+
+/* ADCIN6_LOW regsister*/
+#define DA9052_AUTO6LOW_AUTO6LOW	(255<<0)
+
+/* TJUNC_RES regsister*/
+#define DA9052_TJUNCRES_TJUNCRES	(255<<0)
+
+/*****************TSI REGISTER*********************/
+
+/* TSI Control Register A */
+#define DA9052_TSICONTA_TSIDELAY	(3<<6)
+#define DA9052_TSICONTA_TSISKIP		(7<<3)
+#define DA9052_TSICONTA_TSIMODE		(1<<2)
+#define DA9052_TSICONTA_PENDETEN	(1<<1)
+#define DA9052_TSICONTA_AUTOTSIEN	(1<<0)
+
+/* TSI Control Register B */
+#define DA9052_TSICONTB_ADCREF		(1<<7)
+#define DA9052_TSICONTB_TSIMAN		(1<<6)
+#define DA9052_TSICONTB_TSIMUX		(3<<4)
+#define DA9052_TSICONTB_TSISEL3		(1<<3)
+#define DA9052_TSICONTB_TSISEL2		(1<<2)
+#define DA9052_TSICONTB_TSISEL1		(1<<1)
+#define DA9052_TSICONTB_TSISEL0		(1<<0)
+
+/* TSI X Co-ordinate MSB Result register */
+#define DA9052_TSIXMSB_TSIXM		(255<<0)
+
+/* TSI Y Co-ordinate MSB Result register */
+#define DA9052_TSIYMSB_TSIYM		(255<<0)
+
+/* TSI Co-ordinate LSB Result register */
+#define DA9052_TSILSB_PENDOWN		(1<<6)
+#define DA9052_TSILSB_TSIZL		(3<<4)
+#define DA9052_TSILSB_TSIYL		(3<<2)
+#define DA9052_TSILSB_TSIXL		(3<<0)
+
+/* TSI Z Measurement MSB Result register */
+#define DA9052_TSIZMSB_TSIZM		(255<<0)
+
+/*****************RTC REGISTER*********************/
+
+/* RTC TIMER SECONDS REGISTER */
+#define DA9052_COUNTS_MONITOR		(1<<6)
+#define DA9052_COUNTS_COUNTSEC		(63<<0)
+
+/* RTC TIMER MINUTES REGISTER */
+#define DA9052_COUNTMI_COUNTMIN		(63<<0)
+
+/* RTC TIMER HOUR REGISTER */
+#define DA9052_COUNTH_COUNTHOUR		(31<<0)
+
+/* RTC TIMER DAYS REGISTER */
+#define DA9052_COUNTD_COUNTDAY		(31<<0)
+
+/* RTC TIMER MONTHS REGISTER */
+#define DA9052_COUNTMO_COUNTMONTH	(15<<0)
+
+/* RTC TIMER YEARS REGISTER */
+#define DA9052_COUNTY_COUNTYEAR		(63<<0)
+
+/* RTC ALARM MINUTES REGISTER */
+#define DA9052_ALARMMI_TICKTYPE		(1<<7)
+#define DA9052_ALARMMI_ALARMTYPE	(1<<6)
+#define DA9052_ALARMMI_ALARMMIN		(63<<0)
+
+/* RTC ALARM HOURS REGISTER */
+#define DA9052_ALARMH_ALARMHOUR		(31<<0)
+
+/* RTC ALARM DAYS REGISTER */
+#define DA9052_ALARMD_ALARMDAY		(31<<0)
+
+/* RTC ALARM MONTHS REGISTER */
+#define DA9052_ALARMMO_ALARMMONTH	(15<<0)
+
+/* RTC ALARM YEARS REGISTER */
+#define DA9052_ALARMY_TICKON		(1<<7)
+#define DA9052_ALARMY_ALARMON		(1<<6)
+#define DA9052_ALARMY_ALARMYEAR		(63<<0)
+
+/* RTC SECONDS REGISTER  A*/
+#define DA9052_SECONDA_SECONDSA		(255<<0)
+
+/* RTC SECONDS REGISTER  B*/
+#define DA9052_SECONDB_SECONDSB		(255<<0)
+
+/* RTC SECONDS REGISTER  C*/
+#define DA9052_SECONDC_SECONDSC		(255<<0)
+
+/* RTC SECONDS REGISTER  D*/
+#define DA9052_SECONDD_SECONDSD		(255<<0)
+
+/*****************OTP REGISTER*********************/
+/* CHIP IDENTIFICATION REGISTER */
+#define DA9052_CHIPID_MRC		(15<<4)
+#define DA9052_CHIPID_TRC		(15<<0)
+
+/* CONFIGURATION IDENTIFICATION REGISTER */
+#define DA9052_CONFIGID_CUSTOMERID	(31<<3)
+#define DA9052_CONFIGID_CONFID		(7<<0)
+
+/* OTP CONTROL REGISTER */
+#define DA9052_OTPCONT_GPWRITEDIS	(1<<7)
+#define DA9052_OTPCONT_OTPCONFLOCK	(1<<6)
+#define DA9052_OTPCONT_OTPGPLOCK	(1<<5)
+#define DA9052_OTPCONT_OTPCONFG		(1<<3)
+#define DA9052_OTPCONT_OTPGP		(1<<2)
+#define DA9052_OTPCONT_OTPRP		(1<<1)
+#define DA9052_OTPCONT_OTPTRANSFER	(1<<0)
+
+/* RTC OSCILLATOR TRIM REGISTER */
+#define DA9052_OSCTRIM_TRIM32K		(255<<0)
+
+/* GP ID REGISTER 0 */
+#define DA9052_GPID0_GP0		(255<<0)
+
+/* GP ID REGISTER 1 */
+#define DA9052_GPID1_GP1		(255<<0)
+
+/* GP ID REGISTER 2 */
+#define DA9052_GPID2_GP2		(255<<0)
+
+/* GP ID REGISTER 3 */
+#define DA9052_GPID3_GP3		(255<<0)
+
+/* GP ID REGISTER 4 */
+#define DA9052_GPID4_GP4		(255<<0)
+
+/* GP ID REGISTER 5 */
+#define DA9052_GPID5_GP5		(255<<0)
+
+/* GP ID REGISTER 6 */
+#define DA9052_GPID6_GP6		(255<<0)
+
+/* GP ID REGISTER 7 */
+#define DA9052_GPID7_GP7		(255<<0)
+
+/* GP ID REGISTER 8 */
+#define DA9052_GPID8_GP8		(255<<0)
+
+/* GP ID REGISTER 9 */
+#define DA9052_GPID9_GP9		(255<<0)
+
+#endif /* __REG_H */
Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.
