Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab0ESJyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:54:08 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:46014 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab0ESJyE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:54:04 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] REGULATOR of DA9052 Linux device drivers (5/9)
Date: Wed, 19 May 2010 10:53:56 +0100
Message-ID: <3495EC08FA53E94AAA00CC4743D5BA7E010C20F5@pandora.diasemi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] REGULATOR of DA9052 Linux device drivers (5/9)
Thread-Index: Acr3OTJm/SvDhzcYQga9HBrG2FaRjQ==
From: "David Dajun Chen" <Dajun.Chen@diasemi.com>
To: <linux-kernel@vger.kernel.org>
Cc: <lrg@slimlogic.co.uk>
X-OriginalArrivalTime: 19 May 2010 09:54:00.0047 (UTC) FILETIME=[348F17F0:01CAF739]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear sir/madam,

The attached is the REGULATOR part of the device drivers newly developed for DA9052 Power Management IC from Dialog Semiconductor.

Should you have any queries or comments please feel free to contact me.

Regards

Dr. David Dajun Chen
Dialog Semiconductor Ltd.
Delta 200, Welton Road
Delta Business Park
Swindon
Wiltshire SN5 7XB
UK
Telephone: (+44) 01793-757714
Mobile:         (+44) 07917015477
Fax:               (+44) 01793-758000
============================================================================

diff -Naur linux-2.6.33.2/drivers/mfd/Kconfig linux-2.6.33.2_patch/drivers/mfd/Kconfig
--- linux-2.6.33.2/drivers/mfd/Kconfig	2010-05-18 17:54:30.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/mfd/Kconfig	2010-05-18 17:55:50.000000000 +0500
@@ -377,6 +377,13 @@
 	help
 	  Say Y  to enable the ADC driver for the DA9052 chip
 
+config DA9052_PM_ENABLE
+	bool "Dialog Semiconductor DA9052 Regulator Driver"
+	depends on MFD_DA9052
+	select REGULATOR
+	help
+	  Say Y  to enable the Regulator driver for the DA9052 chip
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff -Naur linux-2.6.33.2/drivers/regulator/da9052_pm.c linux-2.6.33.2_patch/drivers/regulator/da9052_pm.c
--- linux-2.6.33.2/drivers/regulator/da9052_pm.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/regulator/da9052_pm.c	2010-05-18 17:55:50.000000000 +0500
@@ -0,0 +1,2059 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_pm.c: Power Management driver file for DA9052
+ *
+ * History:
+ *
+ * (07/05/2009):	First release Version
+ *
+ * (23/06/2009):	Added support for multiple events occurring at the same
+ *			time
+ *
+ * (25/06/2009):	Added support to control functions in powerdown mode
+ *
+ * (29/06/2009):	Implemented review comments:
+ *			Used macros, modified function names etc.
+ *
+ * (27/04/2010): 	Created initial draft for Linux community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+/*--------------------------------------------------------------------------*/
+/* System wide include files						    */
+/*--------------------------------------------------------------------------*/
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <asm/uaccess.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/version.h>
+/*--------------------------------------------------------------------------*/
+/* Module specific include files					    */
+/*--------------------------------------------------------------------------*/
+#include <linux/mfd/da9052/da9052_reg.h>
+#include <linux/mfd/da9052/da9052_pm.h>
+#include <linux/mfd/da9052/da9052_eh.h>
+
+/*--------------------------------------------------------------------------*/
+/* Local Type Definitions						    */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Local Constant Definitions						    */
+/*--------------------------------------------------------------------------*/
+static u8 banner[] __initdata = "DA9052 Power Manager Driver, v1.0\n";
+/*--------------------------------------------------------------------------*/
+/* Local Macro Definitions						    */
+/*--------------------------------------------------------------------------*/
+
+#define DA9052_LDO(_id, max, min, step_v, reg, mbits, cbits) \
+{									\
+	.reg_desc	= {							\
+		.name		= #_id,						\
+		.ops		= &da9052_ldo_buck_ops,			\
+		.type		= REGULATOR_VOLTAGE,				\
+		.id			= _id,				\
+		.owner		= THIS_MODULE,					\
+	},								\
+	.reg_const = {							\
+		.max_uV		= (max) * 1000,					\
+		.min_uV		= (min) * 1000,					\
+	},								\
+	.step_uV		= (step_v) * 1000,				\
+	.reg_add 		= (reg),						\
+	.mask_bits 		= (mbits),						\
+	.en_bit_mask	= (cbits),						\
+}
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables							    */
+/*--------------------------------------------------------------------------*/
+static u8 pm_device_open = 0;
+static s32 pm_major_number = 0;
+static struct fasync_struct *pm_fasync_queue;
+static struct platform_device *da9052_pm_platform_device;
+static struct regulator_dev *rdev;
+
+/* Variable to store the status of event registration with EH */
+static pm_event_registration_status event_registered_status;
+
+/* Notifier blocks for individual events that can occur */
+static da9052_eh_nb seq_rdy_eh_data;
+static da9052_eh_nb nonkey_eh_data;
+static da9052_eh_nb id_float_eh_data;
+static da9052_eh_nb id_gnd_eh_data;
+static da9052_eh_nb gpi8_eh_data;
+static da9052_eh_nb gpi9_eh_data;
+static da9052_eh_nb gpi10_eh_data;
+
+/* Variable to store status of fault log register */
+static u8 fault_log;
+
+/* Variable to store the status of events occured */
+static u32 event_occurance_status;
+
+/* Semaphore to access status of events occured
+   This semaphore is used at 2 places
+   1. in callback from EH when event occurs -
+				event status is updated in the callback
+   2. in IOCTL when user requestes for status of events occured -
+				event status is returned
+*/
+static struct semaphore event_occurance_status_sem;
+
+/**
+ * struct da9052_regulator_info - 
+ *					Struct to represent regulator description and constrints
+ *
+ * @reg_desc:		Structure containing regulator description 
+ * @reg_const:		Structure containing regulator constraints
+ * @step_uV:		To hold dtep size
+ * @reg_add:		Register Address
+ * @mask_bits:		Mask for the Voltage bits
+ * @en_bit_mask:	Enable bit mask
+ */
+struct da9052_regulator_info{
+	struct regulator_desc reg_desc;
+	struct regulation_constraints reg_const;
+	s32 step_uV;
+	u8 reg_add;
+	u8 mask_bits;
+	u8 en_bit_mask;
+};
+/*--------------------------------------------------------------------------*/
+/* Local Functions							    */
+/*--------------------------------------------------------------------------*/
+/**
+ * da9052_pm_data_init: Initializes the data with default settings
+ *
+ * @param void
+ * @return int		Error status 0:SUCCESS, Non Zero: Error
+ */
+static s32 da9052_pm_data_init(void)
+{
+	/* Mark all events as not occured */
+	event_occurance_status = 0;
+
+	/* Initialize event occurance status lock */
+	init_MUTEX(&event_occurance_status_sem);
+
+	/* Initialize fault log value */
+	fault_log = 0;
+
+	DA9052_DEBUG("Finished initialization\n");
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_data_deinit: Performed when PM Driver is unloaded. It unregisters 
+ *			registered events from EH
+ * 
+ * @parasm void
+ * @return void
+ */
+static void da9052_pm_data_deinit(void)
+{
+	/* Un-register to the EH for all registered event */
+	if (event_registered_status.seq_rdy == TRUE) {
+		da9052_eh_unregister_nb(&seq_rdy_eh_data);
+		event_registered_status.seq_rdy = FALSE;
+	}
+	if (event_registered_status.nonkey == TRUE) {
+		da9052_eh_unregister_nb(&nonkey_eh_data);
+		event_registered_status.nonkey = FALSE;
+	}
+	if (event_registered_status.id_float == TRUE) {
+		da9052_eh_unregister_nb(&id_float_eh_data);
+		event_registered_status.id_float = FALSE;
+	}
+	if (event_registered_status.id_gnd == TRUE) {
+		da9052_eh_unregister_nb(&id_gnd_eh_data);
+		event_registered_status.id_gnd = FALSE;
+	}
+	if (event_registered_status.gpi8 == TRUE) {
+		da9052_eh_unregister_nb(&gpi8_eh_data);
+		event_registered_status.gpi8 = FALSE;
+	}
+	if (event_registered_status.gpi9 == TRUE) {
+		da9052_eh_unregister_nb(&gpi9_eh_data);
+		event_registered_status.gpi8 = FALSE;
+	}
+	if (event_registered_status.gpi10 == TRUE) {
+		da9052_eh_unregister_nb(&gpi10_eh_data);
+		event_registered_status.gpi10 = FALSE;
+	}
+
+	DA9052_DEBUG("Finished hardware exit\n");
+}
+
+/**
+ * da9052_pm_signal_to_user:	This function signal to the library to call 
+ *				the call back function for the event.
+ * 
+ * @param event			event for which library need to be signal.
+ * @return int			Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_signal_to_user(u8 event)
+{
+	/* Acquire semaphore to update event status */
+	if (down_interruptible(&event_occurance_status_sem))
+		return (EINTR);
+
+	/* Mark the particular event as set */
+	event_occurance_status |= event;
+
+	/* Release semaphore */
+	up(&event_occurance_status_sem);
+
+	DA9052_DEBUG("I am in function: %s, event :%d \n", __FUNCTION__,event);
+	kill_fasync (&pm_fasync_queue, SIGIO, POLL_IN);
+
+	return(SUCCESS);
+}
+
+/**
+ * da9052_pm_nonkey_handler : EH callback function for nONKEY event
+ * 
+ * @param u32 event_type	complete event status.
+ * @return void
+ */
+void da9052_pm_nonkey_handler(u32 event_type)
+{
+	da9052_pm_signal_to_user(DA9052_PM_ONKEY_EVENT);
+}
+
+/**
+ * da9052_pm_seqrdy_handler : EH callback function for SEQ_RDY event
+ * 
+ * @param u32 event_type	complete event status.
+ * @return void
+ */
+void da9052_pm_seqrdy_handler(u32 event_type)
+{
+	DA9052_DEBUG("I am in function: %s, event :%d \n", __FUNCTION__,
+								event_type);
+	da9052_pm_signal_to_user(DA9052_PM_SEQ_RDY_EVENT);
+}
+
+/**
+ * da9052_pm_idfloat_handler : EH callback function for ID_FLOAT event
+ * 
+ * @param u32 event_type	complete event status.
+ * @return void
+ */
+void da9052_pm_idfloat_handler(u32 event_type)
+{
+	da9052_pm_signal_to_user(DA9052_PM_ID_FLOAT_EVENT);
+}
+
+/**
+ * da9052_pm_idgnd_handler : EH callback function for ID_GND event
+ * 
+ * @param u32 event_type	complete event status.
+ * @return void
+ */
+void da9052_pm_idgnd_handler(u32 event_type)
+{
+	da9052_pm_signal_to_user(DA9052_PM_ID_GND_EVENT);
+}
+
+/**
+ * da9052_pm_gpi8_handler : EH callback function for GPI_8 event
+ * 
+ * @param u32 event_type	complete event status.
+ * @return void
+ */
+void da9052_pm_gpi8_handler(u32 event_type)
+{
+	da9052_pm_signal_to_user(DA9052_PM_GPI8_EVENT);
+}
+
+/**
+ * da9052_pm_gpi9_handler : EH callback function for GPI_9 event
+ * 
+ * @param u32 event_type	complete event status.
+ * @return void
+ */
+void da9052_pm_gpi9_handler(u32 event_type)
+{
+	da9052_pm_signal_to_user(DA9052_PM_GPI9_EVENT);
+}
+
+/**
+ * da9052_pm_gpi10_handler : EH callback function for GPI_10 event
+ * 
+ * @param u32 event_type	complete event status.
+ * @return void
+ */
+void da9052_pm_gpi10_handler(u32 event_type)
+{
+	da9052_pm_signal_to_user(DA9052_PM_GPI10_EVENT);
+}
+/*--------------------------------------------------------------------------*/
+/* Global Functions							    */
+/*--------------------------------------------------------------------------*/
+/**
+ * da9052_ldo_buck_enable: LDO/BUCK enable
+ * 
+ * @param struct regulator_dev *dev   Regulator device pointer
+ * @return int		Error status 0:SUCCESS, Non Zero: Error
+ */
+static s32 da9052_ldo_buck_enable(struct regulator_dev *rdev)
+{
+	struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
+	da9052_ssc_msg msg;
+
+	DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
+
+	msg.addr = info->reg_add;
+	/* Read LDO register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	msg.data = 	set_bits(msg.data, info->en_bit_mask);
+
+	/* Write LDO register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_ldo_buck_disable: LDO/BUCK disable
+ * 
+ * @param struct regulator_dev *dev   Regulator device pointer
+ * @return int		Error status 0:SUCCESS, Non Zero: Error
+ */
+static s32 da9052_ldo_buck_disable(struct regulator_dev *rdev)
+{
+	struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
+	da9052_ssc_msg msg;
+
+	DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
+
+	msg.addr = info->reg_add;
+	/* Read LDO register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	msg.data = clear_bits(msg.data, info->en_bit_mask);
+
+	/* Write LDO register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_ldo_buck_is_enabled: Check if LDO/BUCK is enabled
+ * 
+ * @param struct regulator_dev *dev   Regulator device pointer
+ * @return int		Status
+ */
+static s32 da9052_ldo_buck_is_enabled(struct regulator_dev *rdev)
+{
+	struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
+	da9052_ssc_msg msg;
+
+	DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
+
+	/* Check the LDO number and assign register and MASK */
+
+	msg.addr = info->reg_add;
+	/* Read LDO register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	return ((msg.data & info->en_bit_mask) != 0);
+}
+
+/**
+ * da9052_ldo_buck_set_voltage: Sets the LDO/Buck Voltage
+ * 
+ * @param struct regulator_dev *dev   Regulator device pointer
+ * @param int min_uV	Minimum voltage in Mili-volts to be set
+ * @param int min_uV	Maximum voltage in Mili-volts to be set
+ * @return int		Error status 0:SUCCESS, Non Zero: Error
+ */
+static s32 da9052_ldo_buck_set_voltage(struct regulator_dev *rdev,s32 min_uV, s32 max_uV)
+{
+	struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
+	da9052_ssc_msg msg;
+	s32 ldo_volt = 0;
+
+	DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
+	/* Compare voltage range */
+	if (min_uV > max_uV)
+		return (-EINVAL);
+
+	/* Check Minimum/ Maximum voltage range */
+	if (min_uV < info->reg_const.min_uV || min_uV > info->reg_const.max_uV) 
+		return (-EINVAL);
+	if (max_uV < info->reg_const.min_uV || max_uV > info->reg_const.max_uV)
+		return (-EINVAL);
+
+	/* Get the ldo register value */
+	/* Varying step size for BUCK PERI */
+	if ((info->reg_desc.id == DA9052_BUCK_PERI) && (min_uV >= BUCK_PERI_VALUES_3000)){
+
+		ldo_volt = (BUCK_PERI_VALUES_3000 - info->reg_const.min_uV)/(info->step_uV);
+		ldo_volt += (min_uV - BUCK_PERI_VALUES_3000)/(BUCK_PERI_STEP_ABOVE_3000);
+	}else{
+
+		ldo_volt = (min_uV - info->reg_const.min_uV)/(info->step_uV);
+		/* Check for maximum value */
+		if ((ldo_volt * info->step_uV) + info->reg_const.min_uV > max_uV)
+			return (-EINVAL);
+	}
+
+	/* Configure LDO Voltage, CONF bits */
+	msg.addr = info->reg_add;
+	/* Read register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	msg.data = clear_bits(msg.data, info->mask_bits);
+	msg.data |= ldo_volt;
+		/* Write register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_ldo_buck_get_voltage: Gets the LDO/Buck Voltage
+ * 
+ * @param struct regulator_dev *dev   Regulator device pointer
+ * @return int		LDO/Buck voltage
+ */
+static s32 da9052_ldo_buck_get_voltage(struct regulator_dev *rdev)
+{
+	struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
+	da9052_ssc_msg msg;
+	s32 ldo_volt =0;
+	s32 ldo_volt_uV = 0;
+	
+	msg.addr = info->reg_add;
+	/* Read register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+	ldo_volt = msg.data & info->mask_bits;
+	if (info->reg_desc.id == DA9052_BUCK_PERI) {
+		if (ldo_volt >= BUCK_PERI_VALUES_UPTO_3000) {
+			ldo_volt_uV = ((BUCK_PERI_VALUES_UPTO_3000 * info->step_uV)\
+						+ info->reg_const.min_uV);
+			ldo_volt_uV = (ldo_volt_uV + (ldo_volt- BUCK_PERI_VALUES_UPTO_3000)\
+						* (BUCK_PERI_STEP_ABOVE_3000));
+		} else {
+			ldo_volt_uV = (ldo_volt * info->step_uV) + info->reg_const.min_uV;
+		}
+	}else {
+		ldo_volt_uV = (ldo_volt * info->step_uV) + info->reg_const.min_uV;
+	}
+	return (ldo_volt_uV);
+}
+
+/**
+ * da9052_pm_configure_buck: Sets the Buck attributes as per input
+ * 
+ * @param da9052_buck_config buck_config   Buck configuration settings
+ * @return int		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_configure_buck(da9052_buck_config buck_config)
+{
+	da9052_ssc_msg msg;
+	u8 buck_volt_conf_reg;
+	u8 buck_volt;
+	u8 buck_volt_bit;
+	u8 buck_conf_bit;
+	u8 buck_en_bit;
+	u8 buck_curr_conf_reg;
+	u8 buck_mode_bit;
+	u8 buck_current_bit;
+	u8 bperi_hs_bit;
+	u8 buck_pd_bit=0;
+	u8 shift_by; /* To specify the shift for lower/upper nibble */
+
+	DA9052_DEBUG("I am in function: %s \n", __FUNCTION__);
+
+	msg.addr = DA9052_CONTROLB_REG;
+	/* Read CONTROL_B register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Check the buck number */
+	switch (buck_config.buck_num) {
+	case BUCK_CORE:
+		/* Validate the BUCK Voltage configuration */
+		if (SUCCESS != (validate_buckpro_mV(buck_config.buck_volt)))
+			return (INVALID_BUCKCORE_VOLT_VALUE);
+		/* Convert the user configuration to bit value */
+		buck_volt=buckpro_mV_to_reg(buck_config.buck_volt);
+		/* Assign register and Mask for BUCK Configuration */
+		buck_volt_conf_reg = DA9052_BUCKCORE_REG;
+		buck_volt_bit = DA9052_BUCKCORE_VBCORE;
+		buck_conf_bit = DA9052_BUCKCORE_BCORECONF;
+		buck_en_bit = DA9052_BUCKCORE_BCOREEN;
+		buck_curr_conf_reg = DA9052_BUCKA_REG;
+		buck_mode_bit = DA9052_BUCKA_BCOREMODE;
+		buck_current_bit = DA9052_BUCKA_BCOREILIM;
+		buck_pd_bit = DA9052_PULLDOWN_COREPDDIS;
+		/* Lower nibble of DA9052_BUCKA_REG */
+		shift_by = 0;
+		break;
+	case BUCK_PRO:
+		if(msg.data & DA9052_CONTROLB_BUCKMERGE)
+			return(INVALID_OPERATION_ON_MERGED_BUCK);
+		/* Validate the BUCK Voltage configuration */
+		if (SUCCESS != (validate_buckpro_mV(buck_config.buck_volt)))
+			return (INVALID_BUCKPRO_VOLT_VALUE);
+		/* Convert the user configuration to bit value */
+		buck_volt=buckpro_mV_to_reg(buck_config.buck_volt);
+		/* Assign register and Mask for BUCK Configuration */
+		buck_volt_conf_reg = DA9052_BUCKPRO_REG;
+		buck_volt_bit = DA9052_BUCKPRO_VBPRO;
+		buck_conf_bit = DA9052_BUCKPRO_BPROCONF;
+		buck_en_bit = DA9052_BUCKPRO_BPROEN;
+		buck_curr_conf_reg = DA9052_BUCKA_REG;
+		buck_mode_bit = DA9052_BUCKA_BPROMODE;
+		buck_current_bit = DA9052_BUCKA_BPROILIM;
+		buck_pd_bit = DA9052_PULLDOWN_PROPDDIS;
+		/* Upper nibble of DA9052_BUCKA_REG */
+		shift_by = 4;
+		break;
+	case BUCK_MEM:
+		/* Validate the BUCK Voltage configuration */
+		if (SUCCESS != (validate_buckmem_mV(buck_config.buck_volt)))
+			return (INVALID_BUCKMEM_VOLT_VALUE);
+		/* Convert the user configuration to bit value */
+		buck_volt=buckmem_mV_to_reg(buck_config.buck_volt);
+		/* Assign register and Mask for BUCK Configuration */
+		buck_volt_conf_reg = DA9052_BUCKMEM_REG;
+		buck_volt_bit = DA9052_BUCKMEM_VBMEM;
+		buck_conf_bit = DA9052_BUCKMEM_BMEMCONF;
+		buck_en_bit = DA9052_BUCKMEM_BMEMEN;
+		buck_curr_conf_reg = DA9052_BUCKB_REG;
+		buck_mode_bit = DA9052_BUCKB_BMEMMODE;
+		buck_current_bit = DA9052_BUCKB_BMEMILIM;
+		buck_pd_bit = DA9052_PULLDOWN_MEMPDDIS;
+		/* Lower nibble of DA9052_BUCKB_REG */
+		shift_by = 0;
+		break;
+	case BUCK_PERI:
+		/* Validate the BUCK Voltage configuration */
+		if (SUCCESS != (validate_buckperi_mV(buck_config.buck_volt)))
+			return (INVALID_BUCKPERI_VOLT_VALUE);
+		/* Convert the user configuration to bit value */
+		buck_volt=buckperi_mV_to_reg(buck_config.buck_volt);
+		/* Assign register and Mask for BUCK Configuration */
+		buck_volt_conf_reg = DA9052_BUCKPERI_REG;
+		buck_volt_bit = DA9052_BUCKPERI_VBPERI;
+		buck_conf_bit = DA9052_BUCKPERI_BPERICONF;
+		buck_en_bit = DA9052_BUCKPERI_BPERIEN;
+		bperi_hs_bit = DA9052_BUCKPERI_BPERIHS;
+		buck_curr_conf_reg = DA9052_BUCKB_REG;
+		buck_mode_bit = DA9052_BUCKB_BPERIMODE;
+		buck_current_bit = DA9052_BUCKB_BERIILIM;
+		/* Upper nibble of DA9052_BUCKB_REG */
+		shift_by = 4;
+		break;
+	default:
+		return (INVALID_BUCK_NUM);
+		break;
+	}
+
+	/* Configure BUCK Voltage, CONF bits */
+	msg.addr = buck_volt_conf_reg;
+	/* Read register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	msg.data = buck_volt | (buck_config.buck_conf ? buck_conf_bit : 0) |
+		(msg.data & buck_en_bit);
+
+	/* For BUCK_PERI, HS bit should be configured */
+	if (BUCK_PERI == buck_config.buck_num) {
+		msg.data = msg.data | (buck_config.bperi_hs ? bperi_hs_bit : 0);
+	}
+	/* Write register */
+	DA9052_DEBUG("Reg addr :%u    Reg value: %u\n",msg.addr,msg.data);
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	/* Configure BUCK PD bit */
+	/* For BUCK_PERI, this is not required */
+	if (BUCK_PERI != buck_config.buck_num) {
+		msg.addr = DA9052_PULLDOWN_REG;
+		/* Read register */
+		if (da9052_ssc_read(&msg))
+			return (FAILURE);
+
+		msg.data = (buck_config.buck_pd ?
+				set_bits(msg.data, buck_pd_bit) :
+				clear_bits(msg.data, buck_pd_bit));
+
+		/* Write register */
+		if (da9052_ssc_write(&msg))
+			return (FAILURE);
+	}
+
+	/* Configure BUCK Current, Mode bits */
+	msg.addr = buck_curr_conf_reg;
+	/* Read register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Set CURRENT and MODE bit fields with the folowing steps */
+	/* 1. Clear CURRENT and MODE bit fields */
+	/* 2. Form the bit field value by shift operation for given value */
+	/* Bit position - MODE bit (0, 1), CURRENT bit (2, 3)*/
+	msg.data = (clear_bits(msg.data, (buck_current_bit | buck_mode_bit)) |
+				(buck_config.current_level <<(shift_by+2)) | 
+				(buck_config.buck_mode << shift_by));
+
+	/* Write register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_configure_ldo: Configure LDO base on user inputs
+ * 
+ * @param da9052_ldo_config ldo_config   LDO configuration settings
+ * @return int		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_configure_ldo(da9052_ldo_config ldo_config)
+{
+	da9052_ssc_msg msg;
+	u8 reg_num;
+	u8 ldo_volt;
+	u8 ldo_volt_bit = 0;
+	u8 ldo_conf_bit = 0;
+	u8 ldo_en_bit = 0;
+	s8 ldo_pd_bit = -1; /* Set to -1 except for LDO1, LDO2 and LDO5 */
+
+	DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
+
+	/* Check the LDO number */
+	switch (ldo_config.ldo_num) {
+	case LDO_1:
+		/* Validate the LDO Voltage configuration */
+		if (SUCCESS != (validate_ldo1_mV(ldo_config.ldo_volt)))
+			return (INVALID_LDO1_VOLT_VALUE);
+		/* Convert the LDO Voltage configuration to bits value */
+		ldo_volt = ldo1_mV_to_reg(ldo_config.ldo_volt);
+		/* Assign register and Mask */
+		reg_num = DA9052_LDO1_REG;
+		ldo_volt_bit = DA9052_LDO1_VLDO1;
+		ldo_conf_bit = DA9052_LDO1_LDO1CONF;
+		ldo_en_bit = DA9052_LDO1_LDO1EN;
+		ldo_pd_bit = DA9052_PULLDOWN_LDO1PDDIS;
+		break;
+	case LDO_2:
+		/* Validate the LDO Voltage configuration */
+		if (SUCCESS != (validate_ldo2_mV(ldo_config.ldo_volt)))
+			return (INVALID_LDO2_VOLT_VALUE);
+		/* Convert the LDO Voltage configuration to bits value */
+		ldo_volt = ldo2_mV_to_reg(ldo_config.ldo_volt);
+		/* Assign register and Mask */
+		reg_num = DA9052_LDO2_REG;
+		ldo_volt_bit = DA9052_LDO2_VLDO2;
+		ldo_conf_bit = DA9052_LDO2_LDO2CONF;
+		ldo_en_bit = DA9052_LDO2_LDO2EN;
+		ldo_pd_bit = DA9052_PULLDOWN_LDO2PDDIS;
+		break;
+	case LDO_3:
+		/* Validate the LDO Voltage configuration */
+		if (SUCCESS != (validate_ldo34_mV(ldo_config.ldo_volt)))
+			return (INVALID_LDO3_VOLT_VALUE);
+		/* Convert the LDO Voltage configuration to bits value */
+		ldo_volt = ldo34_mV_to_reg(ldo_config.ldo_volt);
+		/* Assign register and Mask */
+		reg_num = DA9052_LDO3_REG;
+		ldo_volt_bit = DA9052_LDO3_VLDO3;
+		ldo_conf_bit = DA9052_LDO3_LDO3CONF;
+		ldo_en_bit = DA9052_LDO3_LDO3EN;
+		break;
+	case LDO_4:
+		/* Validate the LDO Voltage configuration */
+		if (SUCCESS != (validate_ldo34_mV(ldo_config.ldo_volt)))
+			return (INVALID_LDO4_VOLT_VALUE);
+		/* Convert the LDO Voltage configuration to bits value */
+		ldo_volt = ldo34_mV_to_reg(ldo_config.ldo_volt);
+		/* Assign register and Mask */
+		reg_num = DA9052_LDO4_REG;
+		ldo_volt_bit = DA9052_LDO4_VLDO4;
+		ldo_conf_bit = DA9052_LDO4_LDO4CONF;
+		ldo_en_bit = DA9052_LDO4_LDO4EN;
+		break;
+	case LDO_5:
+		/* Validate the LDO Voltage configuration */
+		if (SUCCESS != (validate_ldo567810_mV(ldo_config.ldo_volt)))
+			return (INVALID_LDO5_VOLT_VALUE);
+		/* Convert the LDO Voltage configuration to bits value */
+		ldo_volt = ldo567810_mV_to_reg(ldo_config.ldo_volt);
+		/* Assign register and Mask */
+		reg_num = DA9052_LDO5_REG;
+		ldo_volt_bit = DA9052_LDO5_VLDO5;
+		ldo_conf_bit = DA9052_LDO5_LDO5CONF;
+		ldo_en_bit = DA9052_LDO5_LDO5EN;
+		ldo_pd_bit = DA9052_PULLDOWN_LDO5PDDIS;
+		break;
+	case LDO_6:
+		/* Validate the LDO Voltage configuration */
+		if (SUCCESS != (validate_ldo567810_mV(ldo_config.ldo_volt)))
+			return (INVALID_LDO6_VOLT_VALUE);
+		/* Convert the LDO Voltage configuration to bits value */
+		ldo_volt = ldo567810_mV_to_reg(ldo_config.ldo_volt);
+		/* Assign register and Mask */
+		reg_num = DA9052_LDO6_REG;
+		ldo_volt_bit = DA9052_LDO6_VLDO6;
+		ldo_conf_bit = DA9052_LDO6_LDO6CONF;
+		ldo_en_bit = DA9052_LDO6_LDO6EN;
+		break;
+	case LDO_7:
+		/* Validate the LDO Voltage configuration */
+		if (SUCCESS != (validate_ldo567810_mV(ldo_config.ldo_volt)))
+			return (INVALID_LDO7_VOLT_VALUE);
+		/* Convert the LDO Voltage configuration to bits value */
+		ldo_volt = ldo567810_mV_to_reg(ldo_config.ldo_volt);
+		/* Assign register and Mask */
+		reg_num = DA9052_LDO7_REG;
+		ldo_volt_bit = DA9052_LDO7_VLDO7;
+		ldo_conf_bit = DA9052_LDO7_LDO7CONF;
+		ldo_en_bit = DA9052_LDO7_LDO7EN;
+		break;
+	case LDO_8:
+		/* Validate the LDO Voltage configuration */
+		if (SUCCESS != (validate_ldo567810_mV(ldo_config.ldo_volt)))
+			return (INVALID_LDO8_VOLT_VALUE);
+		/* Convert the LDO Voltage configuration to bits value */
+		ldo_volt = ldo567810_mV_to_reg(ldo_config.ldo_volt);
+		/* Assign register and Mask */
+		reg_num = DA9052_LDO8_REG;
+		ldo_volt_bit = DA9052_LDO8_VLDO8;
+		ldo_conf_bit = DA9052_LDO8_LDO8CONF;
+		ldo_en_bit = DA9052_LDO8_LDO8EN;
+		break;
+	case LDO_9:
+		/* Validate the LDO Voltage configuration */
+		if (SUCCESS != (validate_ldo9_mV(ldo_config.ldo_volt)))
+			return (INVALID_LDO9_VOLT_VALUE);
+		/* Convert the LDO Voltage configuration to bits value */
+		ldo_volt = ldo9_mV_to_reg(ldo_config.ldo_volt);
+		/* Assign register and Mask */
+		reg_num = DA9052_LDO9_REG;
+		ldo_volt_bit = DA9052_LDO9_VLDO9;
+		ldo_conf_bit = DA9052_LDO9_LDO9CONF;
+		ldo_en_bit = DA9052_LDO9_LDO9EN;
+		break;
+	case LDO_10:
+		/* Validate the LDO Voltage configuration */
+		if (SUCCESS != (validate_ldo567810_mV(ldo_config.ldo_volt)))
+			return (INVALID_LDO10_VOLT_VALUE);
+		/* Convert the LDO Voltage configuration to bits value */
+		ldo_volt = ldo567810_mV_to_reg(ldo_config.ldo_volt);
+		/* Assign register and Mask */
+		reg_num = DA9052_LDO10_REG;
+		ldo_volt_bit = DA9052_LDO10_VLDO10;
+		ldo_conf_bit = DA9052_LDO10_LDO10CONF;
+		ldo_en_bit = DA9052_LDO10_LDO10EN;
+		break;
+	default:
+		return (INVALID_LDO_NUM);
+		break;
+	}
+
+	/* Configure LDO Voltage, CONF bits */
+	msg.addr = reg_num;
+	/* Read register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Set voltage and configuration bits */
+	/* Keep the LDO_EN bit setting, as is */
+	msg.data = ldo_volt |
+		(ldo_config.ldo_conf ? ldo_conf_bit : 0) |
+		(msg.data & ldo_en_bit);
+
+	/* Write register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	/* Configure LDO PD bit */
+	/* For LDO1, LDO2, LDO5 only */
+	if (-1 != ldo_pd_bit) {
+		msg.addr = DA9052_PULLDOWN_REG;
+		/* Read register */
+		if (da9052_ssc_read(&msg))
+			return (FAILURE);
+
+		msg.data = (ldo_config.ldo_pd ?
+				set_bits(msg.data, ldo_pd_bit) :
+				clear_bits(msg.data, ldo_pd_bit));
+
+		/* Write register */
+		if (da9052_ssc_write(&msg))
+			return (FAILURE);
+	}
+
+	return (SUCCESS);
+}
+/**
+ * da9052_pm_go_buck :  BUCK voltage Ramp/Hold at current setting
+ * 
+ * @param u8 buck_num	BUCK Number
+ * @param u8 flag   	Hold/Ramp setting
+ * @return int		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_go_buck(u8 buck_num, u8 flag)
+{
+	da9052_ssc_msg msg;
+
+	DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
+
+	msg.addr = DA9052_SUPPLY_REG;
+	/* Read SUPPLY register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Check the buck number and respectively form the BUCK_GO value*/
+	/* Funciton is not aviable for BUCK_PPERI */
+	switch (buck_num) {
+	case BUCK_CORE:
+		msg.data = flag ?
+			set_bits(msg.data, DA9052_SUPPLY_VBCOREGO) :
+			clear_bits(msg.data, DA9052_SUPPLY_VBCOREGO);
+		break;
+	case BUCK_PRO:
+		msg.data = flag ?
+			set_bits(msg.data, DA9052_SUPPLY_VBPROGO) :
+			clear_bits(msg.data, DA9052_SUPPLY_VBPROGO);
+		break;
+	case BUCK_MEM:
+		msg.data = flag ?
+			set_bits(msg.data, DA9052_SUPPLY_VBMEMGO) :
+			clear_bits(msg.data, DA9052_SUPPLY_VBMEMGO);
+		break;
+	default:
+		return (INVALID_BUCK_NUM);
+		break;
+	}
+
+	/* Write SUPPLY register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_go_ldo : LDO voltage Ramp/Hold at current setting
+ * 
+ * @param u8 ldo_num	LDO Number
+ * @param u8 flag   	Hold/Ramp setting
+ * @return int		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_go_ldo(u8 ldo_num, u8 flag)
+{
+	da9052_ssc_msg msg;
+
+	DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
+
+	msg.addr = DA9052_SUPPLY_REG;
+	/* Read SUPPLY register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Check the buck number and respectively form the BUCK_GO value*/
+	/* Funciton is aviable for LDO2 and LDO3 only */
+	switch (ldo_num) {
+	case LDO_2:
+		msg.data = flag ?
+			set_bits(msg.data, DA9052_SUPPLY_VLDO2GO) :
+			clear_bits(msg.data, DA9052_SUPPLY_VLDO2GO);
+		break;
+	case LDO_3:
+		msg.data = flag ?
+			set_bits(msg.data, DA9052_SUPPLY_VLDO3GO) :
+			clear_bits(msg.data, DA9052_SUPPLY_VLDO3GO);
+		break;
+	default:
+		return (INVALID_LDO_NUM);
+		break;
+	}
+
+	/* Write SUPPLY register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_set_ldo : Turn ON/OFF LDO
+ * 
+ * @param u8 ldo_num	LDO Number
+ * @param u8 flag   	turn ON/OFF setting
+ * @return int		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_set_ldo(u8 ldo_num, u8 flag)
+{
+	da9052_ssc_msg msg;
+	u8 reg_num = 0;
+	u8 value = 0;
+
+	DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
+
+	/* Check the LDO number and assign register and MASK */
+	switch (ldo_num) {
+	case LDO_1:
+		reg_num = DA9052_LDO1_REG;
+		value =	DA9052_LDO1_LDO1EN;
+		break;
+	case LDO_2:
+		reg_num = DA9052_LDO2_REG;
+		value =	DA9052_LDO2_LDO2EN;
+		break;
+	case LDO_3:
+		reg_num = DA9052_LDO3_REG;
+		value =	DA9052_LDO3_LDO3EN;
+		break;
+	case LDO_4:
+		reg_num = DA9052_LDO4_REG;
+		value =	DA9052_LDO4_LDO4EN;
+		break;
+	case LDO_5:
+		reg_num = DA9052_LDO5_REG;
+		value =	DA9052_LDO5_LDO5EN;
+		break;
+	case LDO_6:
+		reg_num = DA9052_LDO6_REG;
+		value =	DA9052_LDO6_LDO6EN;
+		break;
+	case LDO_7:
+		reg_num = DA9052_LDO7_REG;
+		value =	DA9052_LDO7_LDO7EN;
+		break;
+	case LDO_8:
+		reg_num = DA9052_LDO8_REG;
+		value =	DA9052_LDO8_LDO8EN;
+		break;
+	case LDO_9:
+		reg_num = DA9052_LDO9_REG;
+		value =	DA9052_LDO9_LDO9EN;
+		break;
+	case LDO_10:
+		reg_num = DA9052_LDO10_REG;
+		value =	DA9052_LDO10_LDO10EN;
+		break;
+	default:
+		return (INVALID_LDO_NUM);
+		break;
+	}
+
+	msg.addr = reg_num;
+	/* Read LDO register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	msg.data = flag ?
+		set_bits(msg.data, value) :
+		clear_bits(msg.data, value);
+	/* Write LDO register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_set_buck : Turn ON/OFF BUCK
+ * 
+ * @param u8 buck_num	BUCK Number
+ * @param u8 flag   	turn ON/OFF setting
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_set_buck(u8 buck_num, u8 flag)
+{
+	da9052_ssc_msg msg;
+	u8 reg_num=0;
+	u8 value=0;
+
+	DA9052_DEBUG("I am in function: %s:\n", __FUNCTION__);
+
+	/* Check the BUCK number and assign register and MASK */
+	switch (buck_num) {
+	case BUCK_CORE	:
+		reg_num = DA9052_BUCKCORE_REG;
+		value =	DA9052_BUCKCORE_BCOREEN;
+		break;
+	case BUCK_PRO:
+		reg_num = DA9052_BUCKPRO_REG;
+		value =	DA9052_BUCKPRO_BPROEN;
+		break;
+	case BUCK_MEM:
+		reg_num = DA9052_BUCKMEM_REG;
+		value =	DA9052_BUCKMEM_BMEMEN;
+		break;
+	case BUCK_PERI:
+		reg_num = DA9052_BUCKPERI_REG;
+		value =	DA9052_BUCKPERI_BPERIEN;
+		break;
+	default:
+		return (INVALID_BUCK_NUM);
+		break;
+	}
+
+	msg.addr = reg_num;
+	/* Read BUCK register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+	msg.data = flag ?
+		set_bits(msg.data, value) :
+		clear_bits(msg.data, value);
+
+	/* Write BUCK register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_set_buckmerge: Enable/Disables the bcuk merge
+ * 
+ * @param flag		BUCKCORE and BUCKPRO merging enabled/Disabled
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_set_buckmerge(u8 flag)
+{
+	da9052_ssc_msg msg;
+
+	msg.addr = DA9052_CONTROLB_REG;
+	msg.data = 0;
+	/* Read CONTROLD register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Set/Clear the GPIO_14_14_SD bit */
+	msg.data = flag ?
+			set_bits(msg.data, DA9052_CONTROLB_BUCKMERGE) :
+			clear_bits(msg.data, DA9052_CONTROLB_BUCKMERGE);
+	/* Write CONTROLD register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+/**
+ * da9052_pm_set_gpio1415_reset_function: Enable/Disables the GPIO14_15 reset event.
+ * 
+ * @param flag		GPIO14_15 reset settings
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_set_gpio1415_reset_function(u8 flag)
+{
+	da9052_ssc_msg msg;
+
+	msg.addr = DA9052_CONTROLD_REG;
+	msg.data = 0;
+	/* Read CONTROLD register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Set/Clear the GPIO_14_14_SD bit */
+	msg.data = flag ?
+			set_bits(msg.data, DA9052_CONTROLD_GPI1415SD) :
+			clear_bits(msg.data, DA9052_CONTROLD_GPI1415SD);
+	/* Write CONTROLD register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_set_onkey_reset_function: Enable/Disables the nONKEY reset event.
+ * 
+ * @param flag		nONKEY reset settings
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_set_onkey_reset_function(u8 flag)
+{
+	da9052_ssc_msg msg;
+
+	msg.addr = DA9052_CONTROLD_REG;
+	msg.data = 0;
+	/* Read CONTROLD register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Set/Clear the nONKEY_SD bit */
+	msg.data = flag ?
+			set_bits(msg.data, DA9052_CONTROLD_NONKEYSD) :
+			clear_bits(msg.data, DA9052_CONTROLD_NONKEYSD);
+	/* Write CONTROLD register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_set_accdet: Enable/Disables the ACCDET.
+ * 
+ * @param flag		ACCDET Enable/Disable
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_set_accdet(u8 flag)
+{
+	da9052_ssc_msg msg;
+
+	msg.addr = DA9052_CONTROLD_REG;
+	msg.data = 0;
+	/* Read CONTROLD register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Set/Clear the ACCDETEN bit */
+	msg.data = flag ?
+			set_bits(msg.data, DA9052_CONTROLD_ACCDETEN) :
+			clear_bits(msg.data, DA9052_CONTROLD_ACCDETEN);
+	/* Write CONTROLD register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_get_faultlog: Read and clear the fault log register 
+ * 
+ * @param u8* buffer	Buffer pointer to return the read data.
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_get_faultlog(u8* buffer)
+{
+	da9052_ssc_msg msg;
+
+	msg.addr = DA9052_FAULTLOG_REG;
+	msg.data = 0;
+	/* Read FAULTLOG register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Check if fault log is not 0 */
+	if (msg.data) {
+		/* Storing the fault log on first read */
+		fault_log = msg.data;
+
+		/* Clear FAULTLOG register */
+		msg.data = 0xFF;
+		/* Write FAULTLOG register */
+		if (da9052_ssc_write(&msg))
+			return (FAILURE);
+	}
+
+	*buffer = fault_log;
+	DA9052_DEBUG("I am in function: %s  faultlog : %u\n", __FUNCTION__,
+								*buffer);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_assert_shutdown: Shutdown DA9052 through s/w.
+ * 
+ * @param void
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_assert_shutdown(void)
+{
+	da9052_ssc_msg msg;
+
+	msg.addr = DA9052_CONTROLB_REG;
+	msg.data = 0;
+	/* Read CONTROLD register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Set the SHUTDOWN bit */
+	msg.data = set_bits(msg.data, DA9052_CONTROLB_SHUTDOWN);
+
+	/* Write CONTROLB register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_assert_deepsleep: Put DA9052 in deepsleep through s/w.
+ * 
+ * @param void   
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_assert_deepsleep(void)
+{
+	da9052_ssc_msg msg;
+
+	msg.addr = DA9052_CONTROLB_REG;
+	msg.data = 0;
+	/* Read CONTROLD register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Set the DEEPSLEEP bit */
+	msg.data = set_bits(msg.data, DA9052_CONTROLB_DEEPSLEEP);
+
+	/* Write CONTROLB register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_vmem_sw: Connect/Disconnect the VMEM_SW.
+ * 
+ * @param u8 flag	VMEM_SW configuration setting   
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_vmem_sw(u8 flag)
+{
+	da9052_ssc_msg msg;
+
+	msg.addr = DA9052_SUPPLY_REG;
+	msg.data = 0;
+	/* Read SUPPLY register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Set/clear the  VMEMSWEN bit */
+	msg.data = flag ? 
+		set_bits(msg.data, DA9052_SUPPLY_VMEMSWEN):
+		clear_bits(msg.data, DA9052_SUPPLY_VMEMSWEN);
+
+	/* Write SUPPLY register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_vperi_sw: Connect/Disconnect the VPERI_SW.
+ * 
+ * @param u8 flag	VPERI_SW configuration setting   
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_vperi_sw(u8 flag)
+{
+	da9052_ssc_msg msg;
+
+	msg.addr = DA9052_SUPPLY_REG;
+	msg.data = 0;
+	/* Read SUPPLY register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Set/clear the VPERISWEN bit */
+	msg.data = flag ? 
+		set_bits(msg.data, DA9052_SUPPLY_VPERISWEN):
+		clear_bits(msg.data, DA9052_SUPPLY_VPERISWEN);
+
+	/* Write SUPPLY register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_set_lock: lock/Unlock Buck and LDO.
+ * 
+ * @param u8 flag	V_LOCK configuration setting   
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_set_lock(u8 flag)
+{
+	da9052_ssc_msg msg;
+
+	msg.addr = DA9052_SUPPLY_REG;
+	msg.data = 0;
+	/* Read SUPPLY register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Set/clear the VLOCK bit */
+	msg.data = flag ? 
+		set_bits(msg.data, DA9052_SUPPLY_VLOCK):
+		clear_bits(msg.data, DA9052_SUPPLY_VLOCK);
+
+	/* Write SUPPLY register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+
+/**
+ * da9052_pm_register_event : register PM event with EH
+ * 
+ * @param u8 event_type	Event Number
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_register_event(u8 event_type)
+{
+
+	DA9052_DEBUG("I am in function: %s  event:%d \n", __FUNCTION__,
+								event_type);
+	/* check event_type and assign callback function for EH */
+	switch(event_type) {
+	case SEQ_RDY_EVE:
+		if (TRUE != event_registered_status.seq_rdy) {
+			seq_rdy_eh_data.call_back =da9052_pm_seqrdy_handler;
+			seq_rdy_eh_data.eve_type = event_type;
+			if(da9052_eh_register_nb(&seq_rdy_eh_data))
+				return (FAILURE);
+			event_registered_status.seq_rdy = TRUE;
+		}
+		break;
+	case ONKEY_EVE:
+		if (TRUE != event_registered_status.nonkey) {
+			nonkey_eh_data.call_back =da9052_pm_nonkey_handler;
+			nonkey_eh_data.eve_type = event_type;
+			if(da9052_eh_register_nb(&nonkey_eh_data))
+				return (FAILURE);
+			event_registered_status.nonkey = TRUE;
+		}
+		break;
+	case ID_FLOAT_EVE:
+		if (TRUE != event_registered_status.id_float) {
+			id_float_eh_data.call_back =da9052_pm_idfloat_handler;
+			id_float_eh_data.eve_type = event_type;
+			if(da9052_eh_register_nb(&id_float_eh_data))
+				return (FAILURE);
+			event_registered_status.id_float = TRUE;
+		}
+		break;
+	case ID_GND_EVE:
+		if (TRUE != event_registered_status.id_gnd) {
+			id_gnd_eh_data.call_back =da9052_pm_idgnd_handler;
+			id_gnd_eh_data.eve_type = event_type;
+			if(da9052_eh_register_nb(&id_gnd_eh_data))
+				return (FAILURE);
+			event_registered_status.id_gnd = TRUE;
+		}
+		break;
+	case GPI8_EVE:
+		if (TRUE != event_registered_status.gpi8) {
+			gpi8_eh_data.call_back =da9052_pm_gpi8_handler;
+			gpi8_eh_data.eve_type = event_type;
+			if(da9052_eh_register_nb(&gpi8_eh_data))
+				return (FAILURE);
+			event_registered_status.gpi8 = TRUE;
+		}
+		break;
+	case GPI9_EVE:
+		if (TRUE != event_registered_status.gpi9) {
+			gpi9_eh_data.call_back =da9052_pm_gpi9_handler;
+			gpi9_eh_data.eve_type = event_type;
+			if(da9052_eh_register_nb(&gpi9_eh_data))
+				return (FAILURE);
+			event_registered_status.gpi8 = TRUE;
+		}
+		break;
+	case GPI10_EVE:
+		if (TRUE != event_registered_status.gpi10) {
+			gpi10_eh_data.call_back =da9052_pm_gpi10_handler;
+			gpi10_eh_data.eve_type = event_type;
+			if(da9052_eh_register_nb(&gpi10_eh_data))
+				return (FAILURE);
+			event_registered_status.gpi10 = TRUE;
+		}
+		break;
+	default:
+		return(INVALID_PM_EVENT);
+	}
+	
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_unregister_event : Un-register PM event with EH
+ * 
+ * @param u8 event_type	Event Number
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_unregister_event(u8 event_type)
+{
+	DA9052_DEBUG("I am in function: %s \n", __FUNCTION__);
+	
+	/* Un-register to the EH for the requested event */
+	switch(event_type) {
+	case SEQ_RDY_EVE:
+		if (event_registered_status.seq_rdy == TRUE) {
+			if(da9052_eh_unregister_nb(&seq_rdy_eh_data))
+				return (FAILURE);
+			event_registered_status.seq_rdy = FALSE;
+		}
+		break;
+	case ONKEY_EVE:
+		if (event_registered_status.nonkey == TRUE) {
+			if(da9052_eh_unregister_nb(&nonkey_eh_data))
+				return (FAILURE);
+			event_registered_status.nonkey = FALSE;
+		}
+		break;
+	case ID_FLOAT_EVE:
+		if (event_registered_status.id_float == TRUE) {
+			if(da9052_eh_unregister_nb(&id_float_eh_data))
+				return (FAILURE);
+			event_registered_status.id_float = FALSE;
+		}
+		break;
+	case ID_GND_EVE:
+		if (event_registered_status.id_gnd == TRUE) {
+			if(da9052_eh_unregister_nb(&id_gnd_eh_data))
+				return (FAILURE);
+			event_registered_status.id_gnd = FALSE;
+		}
+		break;
+	case GPI8_EVE:
+		if (event_registered_status.gpi8 == TRUE) {
+			if(da9052_eh_unregister_nb(&gpi8_eh_data))
+				return (FAILURE);
+			event_registered_status.gpi8 = FALSE;
+		}
+		break;
+	case GPI9_EVE:
+		if (event_registered_status.gpi9 == TRUE) {
+			if(da9052_eh_unregister_nb(&gpi9_eh_data))
+				return (FAILURE);
+			event_registered_status.gpi8 = FALSE;
+		}
+		break;
+	case GPI10_EVE:
+		if (event_registered_status.gpi10 == TRUE) {
+			if(da9052_eh_unregister_nb(&gpi10_eh_data))
+				return (FAILURE);
+			event_registered_status.gpi10 = FALSE;
+		}
+		break;
+	default:
+		return(INVALID_PM_EVENT);
+	}
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_pm_function_ctrl_in_powerdown: 
+ *		Enable/Disable given function in power down mode
+ *			0 : Enable, 1 : Disable
+ * 
+ * @param pd_func	Function to be controlled
+ * @param is_disable	Enable/disable settings for a function
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_function_ctrl_in_powerdown(u8 pd_func, u8 is_disable)
+{
+	da9052_ssc_msg msg;
+	u8 bit_pos = 0;
+
+	switch (pd_func) {
+	case DA9052_GPIO_PD: /* Check GPIO extender function */
+		bit_pos = DA9052_PDDIS_GPIOPD;
+		break;
+	case DA9052_ADC_TSI_PD: /* Check ADC/TSI measurement function */
+		bit_pos = DA9052_PDDIS_GPADCPD;
+		break;
+	case DA9052_PM_IF_PD: /* Check power manager interface function */
+		bit_pos = DA9052_PDDIS_PMIFPD;
+		break;
+	case DA9052_HS_2_WIRE_PD: /* Check HS-2-WIRE function */
+		bit_pos = DA9052_PDDIS_HS2WIREPD;
+		break;
+	case DA9052_BAT_CHG_PD: /* Check battery charger function */
+		bit_pos = DA9052_PDDIS_CHGPD;
+		break;
+	case DA9052_BKUP_BAT_CHG_PD: /* Check backup battery charger function */
+		bit_pos = DA9052_PDDIS_CHGBBATPD;
+		break;
+	case DA9052_OUT_32K_PD: /* Check OUT_32K function */
+		bit_pos = DA9052_PDDIS_OUT32KPD;
+		break;
+	case DA9052_PM_CONT_PD: /* Check SYS_EN, PWR_EN, PWR1_EN function */
+		bit_pos = DA9052_PDDIS_PMCONTPD;
+		break;
+	default:
+		return (INVALID_PD_FUNCTION);
+		break;
+	}
+
+	/* Set SSC message */
+	msg.addr = DA9052_PDDIS_REG;
+	msg.data = 0;
+
+	/* Read PD_DIS register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Check if function to be disabled */
+	/* Set 1: To disable, 0: To enable */
+	msg.data = is_disable ? set_bits(msg.data, bit_pos) :
+				clear_bits(msg.data, bit_pos);
+
+	/* Write PD_DIS register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/*--------------------------------------------------------------------------*/
+/* Infrastructure Functions						    */
+/*--------------------------------------------------------------------------*/
+/**
+ * Regular operations
+ */ 
+static struct regulator_ops da9052_ldo_buck_ops = {
+	.is_enabled = da9052_ldo_buck_is_enabled,
+	.enable = da9052_ldo_buck_enable,
+	.disable = da9052_ldo_buck_disable,
+	.get_voltage = da9052_ldo_buck_get_voltage,
+	.set_voltage = da9052_ldo_buck_set_voltage,
+};
+
+/**
+* Structure of regulator description
+*/
+struct da9052_regulator_info da9052_regulators []= {
+	/* LD01 - LDO10*/
+	DA9052_LDO (DA9052_LDO1, LDO1_VOLT_UPPER, LDO1_VOLT_LOWER,	LDO1_VOLT_STEP,\
+				DA9052_LDO1_REG, DA9052_LDO1_VLDO1,\
+				DA9052_LDO1_LDO1EN),
+
+	DA9052_LDO (DA9052_LDO2,LDO2_VOLT_UPPER, LDO2_VOLT_LOWER, LDO2_VOLT_STEP,\
+				DA9052_LDO2_REG, DA9052_LDO2_VLDO2,\
+				DA9052_LDO2_LDO2EN),
+
+	DA9052_LDO (DA9052_LDO3,LDO34_VOLT_UPPER, LDO34_VOLT_LOWER, LDO34_VOLT_STEP,\
+				DA9052_LDO3_REG, DA9052_LDO3_VLDO3,\
+				DA9052_LDO3_LDO3EN),
+
+	DA9052_LDO (DA9052_LDO4,LDO34_VOLT_UPPER, LDO34_VOLT_LOWER, LDO34_VOLT_STEP,\
+				DA9052_LDO4_REG, DA9052_LDO4_VLDO4,\
+				DA9052_LDO4_LDO4EN),
+
+	DA9052_LDO (DA9052_LDO5,LDO567810_VOLT_UPPER, LDO567810_VOLT_LOWER,\
+				LDO567810_VOLT_STEP, DA9052_LDO5_REG,\
+				DA9052_LDO5_VLDO5, DA9052_LDO5_LDO5EN),
+
+	DA9052_LDO (DA9052_LDO6,LDO567810_VOLT_UPPER, LDO567810_VOLT_LOWER,\
+				LDO567810_VOLT_STEP, DA9052_LDO6_REG,\
+				DA9052_LDO6_VLDO6, DA9052_LDO6_LDO6EN),
+
+	DA9052_LDO (DA9052_LDO7,LDO567810_VOLT_UPPER, LDO567810_VOLT_LOWER,\
+				LDO567810_VOLT_STEP, DA9052_LDO7_REG,\
+				DA9052_LDO7_VLDO7, DA9052_LDO7_LDO7EN),
+
+	DA9052_LDO (DA9052_LDO8,LDO567810_VOLT_UPPER, LDO567810_VOLT_LOWER,\
+				LDO567810_VOLT_STEP, DA9052_LDO8_REG,\
+				DA9052_LDO8_VLDO8, DA9052_LDO8_LDO8EN),
+
+	DA9052_LDO (DA9052_LDO9,LDO9_VOLT_UPPER, LDO9_VOLT_LOWER, LDO9_VOLT_STEP,\
+				DA9052_LDO9_REG, DA9052_LDO9_VLDO9,\
+				DA9052_LDO9_LDO9EN),
+
+	DA9052_LDO (DA9052_LDO10, LDO567810_VOLT_UPPER, LDO567810_VOLT_LOWER,\
+				LDO567810_VOLT_STEP, DA9052_LDO10_REG,\
+				DA9052_LDO10_VLDO10, DA9052_LDO10_LDO10EN),
+
+	/* BUCKS */
+	DA9052_LDO (DA9052_BUCK_CORE,BUCK_CORE_PRO_VOLT_UPPER, BUCK_CORE_PRO_VOLT_LOWER,\
+				BUCK_CORE_PRO_STEP, DA9052_BUCKCORE_REG,\
+				DA9052_BUCKCORE_VBCORE, DA9052_BUCKCORE_BCOREEN),
+
+	DA9052_LDO (DA9052_BUCK_PRO,BUCK_CORE_PRO_VOLT_UPPER, BUCK_CORE_PRO_VOLT_LOWER,\
+				BUCK_CORE_PRO_STEP, DA9052_BUCKPRO_REG,\
+				DA9052_BUCKPRO_VBPRO, DA9052_BUCKPRO_BPROEN),
+
+	DA9052_LDO (DA9052_BUCK_MEM,BUCK_MEM_VOLT_UPPER, BUCK_MEM_VOLT_LOWER,\
+				BUCK_MEM_STEP, DA9052_BUCKMEM_REG,\
+				DA9052_BUCKMEM_VBMEM, DA9052_BUCKMEM_BMEMEN),
+
+	/* To be done */
+	DA9052_LDO (DA9052_BUCK_PERI,BUCK_PERI_VOLT_UPPER, BUCK_PERI_VOLT_LOWER,\
+				BUCK_PERI_STEP_BELOW_3000, DA9052_BUCKPERI_REG,\
+				DA9052_BUCKPERI_VBPERI, DA9052_BUCKPERI_BPERIEN),
+};
+
+static inline struct da9052_regulator_info *find_regulator_info(s32 id){
+	struct da9052_regulator_info *ri;
+	s32 i;
+
+	for (i = 0; i < ARRAY_SIZE(da9052_regulators); i++) {
+		ri = &da9052_regulators[i];
+		if (ri->reg_desc.id == id)
+			return ri;
+	}
+	return NULL;
+}
+
+/**
+ * da9052_pm_open: Opens the device
+ * 
+ * @param *inode   	pointer to device inode
+ * @param *file   	file pointer
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_open(struct inode *inode, struct file *file)
+{
+	/* Check if device is already open */
+	DA9052_DEBUG("__%s__\n", __FUNCTION__);
+	if (pm_device_open) {
+		DA9052_DEBUG("DA9052: Power Manager device already open.\n");
+		return (-EBUSY);
+	} else {
+		pm_device_open++;
+		return (SUCCESS);
+	}
+}
+
+/**
+ * da9052_pm_release: Releases the device
+ * 
+ * @param *inode   	pointer to device inode
+ * @param *file   	file pointer
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_release(struct inode *inode, struct file *file)
+{
+	pm_device_open--;
+	DA9052_DEBUG("DA9052: Power Manager device closed.\n");
+	return (SUCCESS);
+}
+
+/**
+ * da9052_regulator_suspend: Power Management support function
+ * 
+ * @param *dev   	pointer to platform device
+ * @param state  	pm state
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+static s32 da9052_regulator_suspend(struct platform_device *dev, pm_message_t state)
+{
+	/* Put your suspend related operations here */
+	printk(KERN_INFO "%s: called\n", __FUNCTION__);
+	return (0);
+}
+
+/**
+ * da9052_regulator_resume: Power Management support function
+ * 
+ * @param *dev   	pointer to platform device
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+static s32 da9052_regulator_resume(struct platform_device *dev)
+{
+	/* Put your resume related operations here */
+	printk(KERN_INFO "%s: called\n", __FUNCTION__);
+	return (0);
+}
+
+/**
+ * da9052_pm_ioctl: Provides the IOCTL interface
+ * 
+ * @param *inode   	pointer to device inode
+ * @param *file   	file pointer
+ * @param cmd   	command to be executed
+ * @param arg   	argument to command
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_pm_ioctl(struct inode *inode, struct file *file, 
+					unsigned int cmd, unsigned long arg)
+{
+	da9052_buck_config usr_param_buck_config;
+	da9052_ldo_config usr_param_ldo_config;
+	da9052_ldo_buck_go usr_param_go;
+	da9052_ldo_buck_control usr_param_cntr;
+	u8 buffer;
+	u32 ret = 0;
+	da9052_func_ctrl_in_powerdown pd_dis_ctrl;
+
+	/* Temporary Variable to store the status of events occured */
+	u32 temp_event_occurance_status;
+
+	DA9052_DEBUG(KERN_INFO "DA9052: Power Manager device IOCTL.\n");
+
+	/* Check command to be executed */
+	switch (cmd) {
+	case DA9052_PM_IOCTL_CONFIGURE_BUCK:
+		if (copy_from_user(&usr_param_buck_config, 
+					(da9052_buck_config *) arg, 
+					sizeof(usr_param_buck_config)))
+			return (FAILURE);
+		ret = da9052_pm_configure_buck(usr_param_buck_config);
+		return (ret);
+		break;
+	case DA9052_PM_IOCTL_CONFIGURE_LDO:
+		if (copy_from_user(&usr_param_ldo_config, 
+					(da9052_ldo_config *) arg, 
+					sizeof(usr_param_ldo_config)))
+			return (FAILURE);
+		ret = da9052_pm_configure_ldo(usr_param_ldo_config);
+			return (ret);
+		break;
+	case DA9052_PM_IOCTL_BUCKMERGE:
+		if (copy_from_user(&buffer, (u8*) arg, sizeof(buffer)))
+			return (FAILURE);
+		ret = da9052_pm_set_buckmerge(buffer);
+			return(ret);
+		break;
+	case DA9052_PM_IOCTL_GO_LDO:
+		if (copy_from_user(&usr_param_go, 
+			(da9052_ldo_buck_go *) arg, sizeof(usr_param_go)))
+			return (FAILURE);
+		ret = da9052_pm_go_ldo(usr_param_go.ldo_buck_num,
+							usr_param_go.flag);
+			return (ret);
+		break;
+	case DA9052_PM_IOCTL_GO_BUCK:
+		if (copy_from_user(&usr_param_go, 
+		(da9052_ldo_buck_go *) arg, sizeof(usr_param_go)))
+			return (FAILURE);
+		ret = da9052_pm_go_buck(usr_param_go.ldo_buck_num,
+							usr_param_go.flag);
+			return (ret);
+		break;
+	case DA9052_PM_IOCTL_SET_LDO:
+		if (copy_from_user(&usr_param_cntr, 
+			(da9052_ldo_buck_control *) arg, sizeof(usr_param_cntr)))
+			return (FAILURE);
+		
+		ret = da9052_pm_set_ldo(usr_param_cntr.ldo_buck_num,
+							usr_param_cntr.flag);
+			return(ret);
+		break;
+	case DA9052_PM_IOCTL_SET_BUCK:
+		if (copy_from_user(&usr_param_cntr, (da9052_ldo_buck_control *)
+						arg, sizeof(usr_param_cntr)))
+			return (FAILURE);
+		ret = da9052_pm_set_buck(usr_param_cntr.ldo_buck_num,
+							usr_param_cntr.flag);
+			return(ret);
+		break;
+	case DA9052_PM_IOCTL_SET_GPIO1415_RESET:
+		if (copy_from_user(&buffer, (u8*) arg, sizeof(buffer)))
+			return (FAILURE);
+		ret = da9052_pm_set_gpio1415_reset_function(buffer);
+			return(ret);
+		break;
+	case DA9052_PM_IOCTL_SET_ONKEY_RESET:
+		if (copy_from_user(&buffer, (u8 *) arg, sizeof(buffer)))
+			return (FAILURE);
+		ret = da9052_pm_set_onkey_reset_function(buffer);
+			return(ret);
+		break;
+	case DA9052_PM_IOCTL_SET_ACCDET:
+		if (copy_from_user(&buffer, (u8 *) arg, sizeof(buffer)))
+			return (FAILURE);
+		ret = da9052_pm_set_accdet(buffer);
+			return(ret);
+		break;
+	case DA9052_PM_IOCTL_GET_FAULTLOG:
+		ret = da9052_pm_get_faultlog(&buffer);
+		DA9052_DEBUG("\nFault log in IOCTL : %x\n",buffer);
+		if (copy_to_user((u8 *)arg,&buffer,sizeof(buffer)))
+			return (FAILURE);
+		return(ret);
+		break;
+	case DA9052_PM_IOCTL_ASSERT_SHUTDOWN:
+		ret = da9052_pm_assert_shutdown();
+			return(ret);
+		break;
+	case DA9052_PM_IOCTL_ASSERT_DEEPSLEEP:
+		ret = da9052_pm_assert_deepsleep();
+			return(ret);
+		break;
+	case DA9052_PM_IOCTL_VMEM_SW:
+		if (copy_from_user(&buffer, (u8*) arg, sizeof(buffer)))
+			return (FAILURE);
+		ret = da9052_pm_vmem_sw(buffer);
+			return(ret);
+		break;
+	case DA9052_PM_IOCTL_VPERI_SW:
+		if (copy_from_user(&buffer, (u8*) arg, sizeof(buffer)))
+			return (FAILURE);
+		ret = da9052_pm_vperi_sw(buffer);
+			return(ret);
+		break;
+	case DA9052_PM_IOCTL_SET_LOCK:
+		if (copy_from_user(&buffer, (u8*) arg, sizeof(buffer)))
+			return (FAILURE);
+		ret = da9052_pm_set_lock(buffer);
+			return(ret);
+		break;
+	case DA9052_PM_IOCTL_GET_EVENT:
+		/* Acquire semaphore to update event status */
+		if (down_interruptible(&event_occurance_status_sem))
+			return (FAILURE);
+		/* Copy the status of event occurance into a temp variable */
+		temp_event_occurance_status = event_occurance_status;
+		/* Clear the event occurance status */
+		event_occurance_status = 0;
+		/* Release semaphore */
+		up(&event_occurance_status_sem);
+
+		/* Copy the status to user space */
+		if(copy_to_user((u32 *)arg, &temp_event_occurance_status, 
+							sizeof(u32)))
+			return (FAILURE);
+		return (SUCCESS);
+		break;
+	case DA9052_PM_IOCTL_REGISTER_EVENT:
+		if (copy_from_user(&buffer, (u8*) arg, sizeof(buffer)))
+			return (FAILURE);
+		ret = da9052_pm_register_event(buffer);
+			return(ret);
+		break;
+	case DA9052_PM_IOCTL_UNREGISTER_EVENT:
+		if (copy_from_user(&buffer, (u8*) arg, sizeof(buffer)))
+			return (FAILURE);
+		ret = da9052_pm_unregister_event(buffer);
+			return(ret);
+		break;
+	case DA9052_PM_IOCTL_FUNC_CTRL_IN_POWERDOWN:
+		if (copy_from_user(&pd_dis_ctrl, 
+			(da9052_func_ctrl_in_powerdown*) arg, 
+			sizeof(da9052_func_ctrl_in_powerdown)))
+			return (FAILURE);
+		ret = da9052_pm_function_ctrl_in_powerdown(pd_dis_ctrl.pd_func,
+						pd_dis_ctrl.is_disable);
+			return(ret);
+		break;
+	default:
+		printk(KERN_DEBUG "Invalid ioctl command\n");
+		return (INVALID_PM_IOCTL);
+	}
+	return (INVALID_PM_IOCTL);
+}
+
+s32 da9052_pm_fasync (s32 fd, struct file *filp, s32 on)
+{
+	s32 ret;
+ 	DA9052_DEBUG ("In %s: %s\n",__FILE__, __FUNCTION__);
+	ret = fasync_helper(fd, filp, on, &pm_fasync_queue);
+  	return(ret);
+}
+/**
+ * static struct file_operations da9052_pm_fops -
+ * This structure definition has to be defined here as an exception.
+ * @owner: 
+ * @open : pointer to function providing "open" interface
+ * @release: pointer to function providing "release" interface
+ * @read: pointer to function providing "read" interface
+ * @write: pointer to function providing "write" interface
+ * @ioctl: pointer to function providing "ioctl" interface
+ *
+ */
+static const struct file_operations da9052_pm_fops = {
+	.owner		= THIS_MODULE,
+	.open		= da9052_pm_open,
+	.release	= da9052_pm_release,
+	.ioctl		= da9052_pm_ioctl,
+	.fasync		= da9052_pm_fasync
+};
+
+/**
+ * da9052_pm_dummy_func:	Register file descriptor asynchronous notification 
+ *			for events
+ *
+ * @param void *voidp	void pointer
+  * @return s32			Error status 0:SUCCESS, Non Zero: Error
+ */
+static s32 da9052_pm_dummy_func( void * voidp)
+{
+	return(SUCCESS);
+}
+/**
+ * da9052_regulator_probe:	Called when a device gets attached to driver 
+ *
+ * @param struct platform_device *dev	platform device to be probe
+ * @return s32				Error status 0:SUCCESS, Non Zero: Error
+ */
+static s32 __devinit da9052_regulator_probe(struct platform_device *dev)
+{
+	s32 ret;
+	struct da9052_regulator_info *ri = NULL;
+	struct regulator_init_data init_data;
+
+
+	/* Find the required regulator */
+	ri = find_regulator_info(dev->id);
+	if (ri == NULL) {
+		DA9052_DEBUG("invalid regulator ID specified\n");
+		return (-EINVAL);
+	}
+	init_data.constraints = ri->reg_const;
+	init_data.regulator_init = &da9052_pm_dummy_func; 
+	init_data.supply_regulator_dev = NULL; 
+	init_data.num_consumer_supplies = 0;
+	dev->dev.platform_data = &init_data;
+
+	/* register the regulator */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33)
+	rdev = regulator_register(&ri->reg_desc,&dev->dev,dev->dev.platform_data,ri);
+#else
+	rdev = regulator_register(&ri->reg_desc, &dev->dev, ri);
+#endif
+	if (IS_ERR(rdev)) {
+		dev_err(&dev->dev, "failed to register %s\n",
+			ri->reg_desc.name);
+		return PTR_ERR(rdev);
+	}
+	/* Register the device */
+	ret = register_chrdev(pm_major_number,
+				DA9052_PM_DEVICE_NAME, &da9052_pm_fops);
+	if (ret < 0) {
+		DA9052_DEBUG("Unable to register %s\n",
+						DA9052_PM_DEVICE_NAME);
+		return (-EFAULT);	
+	} else {
+		pm_major_number = ret;
+		DA9052_DEBUG("%s: Major number is: %d.\n",
+				DA9052_PM_DEVICE_NAME, pm_major_number);
+
+		/* Initialize the hardware */
+		if (da9052_pm_data_init()) {
+			/* Error in hw initialization */
+			unregister_chrdev(pm_major_number,
+							DA9052_PM_DEVICE_NAME);
+			return (-EFAULT);
+		}
+		return (SUCCESS);
+	}
+}
+
+
+/**
+ * da9052_regulator_remove: Called when ditaching device from driver
+ *
+ * @param struct platform_device *dev	platform device to be removed
+ * @return x32				Error status 0:SUCCESS, Non Zero: Error
+ */
+static s32 __devexit da9052_regulator_remove(struct platform_device *dev)
+{
+	DA9052_DEBUG("Removing %s \n", DA9052_PM_DEVICE_NAME);
+	regulator_unregister(rdev);
+	return (SUCCESS);
+}
+/**
+ * static struct platform_driver da9052_regulator_driver -
+ * This structure definition has to be defined here as an exception.
+ * @probe: Probe function for this device. 
+ * @suspend: Function to be called when suspending this device from platform
+ * @remove: Function to be called when resuming this device from platform
+ * @driver: Contains glue logic to bind platform device and plarform driver
+ */
+static struct platform_driver da9052_regulator_driver = {
+	.probe		= da9052_regulator_probe,
+	.remove		= __devexit_p(da9052_regulator_remove),
+	.suspend	= da9052_regulator_suspend,
+	.resume		= da9052_regulator_resume,
+	.driver		= {
+		.name	= DA9052_PM_DEVICE_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+/**
+ * da9052_regulator_init: Initiales the driver
+ * 
+ * @param void
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+static s32 __init da9052_regulator_init(void)
+{
+	s32 retval;
+	printk(banner);
+
+	DA9052_DEBUG("DA9052: init : %d.\n",DA9052_PM_DEVICE_MAJOR_NO);
+
+	da9052_pm_platform_device = platform_device_alloc(DA9052_PM_DEVICE_NAME, DA9052_BUCK_PERI);
+	if (!da9052_pm_platform_device)
+		return (-ENOMEM);
+
+	retval = platform_device_add(da9052_pm_platform_device);
+	if (retval < 0) {
+		platform_device_put(da9052_pm_platform_device);
+		return (retval);
+	}
+	retval = platform_driver_register(&da9052_regulator_driver);
+
+	if (retval < 0)
+		platform_device_unregister(da9052_pm_platform_device);
+
+	return (retval);
+}
+/**
+ * da9052_regulator_exit: Closes the driver
+ * 
+ * @param void
+ * @return void
+ */
+static void __exit da9052_regulator_exit(void)
+{
+	printk("DA9052: Unregistering Power Manager device.\n");
+
+	/* De-initializes */
+	da9052_pm_data_deinit();
+
+	/* Unregister the driver */
+	unregister_chrdev(pm_major_number, DA9052_PM_DEVICE_NAME);
+	platform_driver_unregister(&da9052_regulator_driver);
+	platform_device_unregister(da9052_pm_platform_device);
+}
+module_init(da9052_regulator_init);
+module_exit(da9052_regulator_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd");
+MODULE_DESCRIPTION("DA9052 Power Manager Device Driver");
+MODULE_LICENSE("GPL");
+
+/*--------------------------------------------------------------------------*/
+/* Exports								    */
+/*--------------------------------------------------------------------------*/
+
+/* All functions accessible from other drivers */
+EXPORT_SYMBOL(da9052_pm_configure_buck);
+EXPORT_SYMBOL(da9052_pm_configure_ldo);
+EXPORT_SYMBOL(da9052_pm_set_buckmerge);
+EXPORT_SYMBOL(da9052_pm_go_buck);
+EXPORT_SYMBOL(da9052_pm_go_ldo);
+EXPORT_SYMBOL(da9052_pm_set_ldo);
+EXPORT_SYMBOL(da9052_pm_set_buck);
+EXPORT_SYMBOL(da9052_pm_set_gpio1415_reset_function);
+EXPORT_SYMBOL(da9052_pm_set_onkey_reset_function);
+EXPORT_SYMBOL(da9052_pm_set_accdet);
+EXPORT_SYMBOL(da9052_pm_get_faultlog);
+EXPORT_SYMBOL(da9052_pm_assert_shutdown);
+EXPORT_SYMBOL(da9052_pm_assert_deepsleep);
+EXPORT_SYMBOL(da9052_pm_vmem_sw);
+EXPORT_SYMBOL(da9052_pm_vperi_sw);
+EXPORT_SYMBOL(da9052_pm_set_lock);
+EXPORT_SYMBOL(da9052_pm_function_ctrl_in_powerdown);
diff -Naur linux-2.6.33.2/drivers/regulator/Makefile linux-2.6.33.2_patch/drivers/regulator/Makefile
--- linux-2.6.33.2/drivers/regulator/Makefile	2010-04-02 04:02:33.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/regulator/Makefile	2010-05-18 17:55:50.000000000 +0500
@@ -23,6 +23,7 @@
 obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
 obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
 obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
+obj-$(CONFIG_DA9052_PM_ENABLE)	+= da9052_pm.o
 
 obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6507X) += tps6507x-regulator.o
diff -Naur linux-2.6.33.2/include/linux/mfd/da9052/da9052_pm.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_pm.h
--- linux-2.6.33.2/include/linux/mfd/da9052/da9052_pm.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_pm.h	2010-05-18 17:55:50.000000000 +0500
@@ -0,0 +1,660 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_pm.h: Power Manager for DA9052
+ * Header file contain the structure, prototype and defines needed for 
+ * PM driver API's
+ *
+ * History:
+ *
+ * (07/05/2009):	First Release version
+ *
+ * (25/06/2009):	Added support for multiple events occurring at the same 
+ *			time
+ *			Added support to control functions in power down mode
+ *
+ * (29/06/2009):	Implemented review comments:
+ *			Used macros, modified function names etc.
+ *
+ * (27/04/2010):	Updated for Linux Community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+#ifndef _DA9052_PM_H
+#define _DA9052_PM_H
+
+/*--------------------------------------------------------------------------*/
+/* System wide include files                                                */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+#include <linux/mfd/da9052/da9052_lib.h>
+/*--------------------------------------------------------------------------*/
+/* Type Definitions                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Constant Definitions                                                     */
+/*--------------------------------------------------------------------------*/
+
+/* PM Device name and static Major number macros */
+#define DA9052_PM_DEVICE_NAME			"da9052_regulator"
+#define TRUE					1
+#define FALSE					0
+
+/* PM Device Macros */
+#define DA9052_LDO1				1
+#define DA9052_LDO2				2
+#define DA9052_LDO3				3
+#define DA9052_LDO4				4
+#define DA9052_LDO5				5
+#define DA9052_LDO6				6
+#define DA9052_LDO7				7
+#define DA9052_LDO8				8
+#define DA9052_LDO9				9
+#define DA9052_LDO10			10
+#define DA9052_BUCK_CORE		11
+#define DA9052_BUCK_PRO			12
+#define DA9052_BUCK_MEM			13
+#define DA9052_BUCK_PERI		14
+
+/* PM Device Error Codes */
+#define INVALID_BUCK_NUM			2
+#define INVALID_LDO_NUM				3
+#define INVALID_PM_EVENT			4
+#define INVALID_BUCKCORE_VOLT_VALUE		5
+#define INVALID_BUCKPRO_VOLT_VALUE		6
+#define INVALID_BUCKMEM_VOLT_VALUE		7
+#define INVALID_BUCKPERI_VOLT_VALUE		8
+#define INVALID_LDO1_VOLT_VALUE			9
+#define INVALID_LDO2_VOLT_VALUE			10
+#define INVALID_LDO3_VOLT_VALUE			11
+#define INVALID_LDO4_VOLT_VALUE			12
+#define INVALID_LDO5_VOLT_VALUE			13
+#define INVALID_LDO6_VOLT_VALUE			14
+#define INVALID_LDO7_VOLT_VALUE			15
+#define INVALID_LDO8_VOLT_VALUE			16
+#define INVALID_LDO9_VOLT_VALUE			17
+#define INVALID_LDO10_VOLT_VALUE		18
+#define INVALID_PM_IOCTL			19
+#define INVALID_OPERATION_ON_MERGED_BUCK	20
+#define INVALID_PD_FUNCTION			21
+
+/* Buck Config Validation Macros */
+#define BUCK_CORE_PRO_VOLT_UPPER	2075
+#define BUCK_CORE_PRO_VOLT_LOWER	500
+#define BUCK_CORE_PRO_STEP			25
+#define BUCK_MEM_VOLT_UPPER			2500
+#define BUCK_MEM_VOLT_LOWER			925
+#define BUCK_MEM_STEP				25
+#define BUCK_PERI_VOLT_UPPER		3600
+#define BUCK_PERI_VOLT_LOWER		1800
+#define BUCK_PERI_STEP_BELOW_3000	50
+#define BUCK_PERI_STEP_ABOVE_3000	100000
+#define BUCK_PERI_VALUES_UPTO_3000	24
+#define BUCK_PERI_VALUES_3000		3000000
+#define LDO1_VOLT_UPPER				1800
+#define LDO1_VOLT_LOWER				600
+#define LDO1_VOLT_STEP				50
+#define LDO2_VOLT_UPPER				1800
+#define LDO2_VOLT_LOWER				600
+#define LDO2_VOLT_STEP				25
+#define LDO34_VOLT_UPPER			3300
+#define LDO34_VOLT_LOWER			1725
+#define LDO34_VOLT_STEP				25
+#define LDO567810_VOLT_UPPER		3600
+#define LDO567810_VOLT_LOWER		1200
+#define LDO567810_VOLT_STEP			50
+#define LDO9_VOLT_UPPER				3650
+#define LDO9_VOLT_LOWER				1250
+#define LDO9_VOLT_STEP				50
+
+/* PM Debug Macro. To enable the Debug set 1 to the macr0 */
+#define DA9052_PM_DEBUG 			0
+
+#undef DA9052_DEBUG
+#if DA9052_PM_DEBUG
+	#define DA9052_DEBUG( fmt, args... ) printk( KERN_CRIT "" fmt, ##args )
+#else
+	#define DA9052_DEBUG( fmt, args... )
+#endif
+
+/* Enum definitions */
+/**
+ * enum buck_mode_enum -	Enum to represent the BUCK Mode
+ *
+ * @SLEEP_MODE: 		Buck Sleep Mode = 0
+ * @AUOTMATIC_MODE: 		Buck Automatic mode = 1
+ * @SYNCHRONOUS_MODE: 		Buck Synchronous Mode = 2
+ * @AUTO_SYNCHRONOUS_MODE: 	BuCk Auto-Synchronous Mode = 3 
+ */
+enum buck_mode_enum {
+	SLEEP_MODE = 0,
+	AUOTMATIC_MODE,
+	SYNCHRONOUS_MODE,
+	AUTO_SYNCHRONOUS_MODE
+};
+
+/**
+ * enum buck_cur_lim_enum -	Enum to represent the BUCK Current limit
+ *
+ * @CURRENT_LIMIT_700mA: 	Buck Current limit = 700mA
+ * @CURRENT_LIMIT_800mA: 	Buck Current limit = 800mA
+ * @CURRENT_LIMIT_1000mA: 	Buck Current limit = 1000mA
+ * @CURRENT_LIMIT_1200mA: 	BuCk Current limit = 1200mA
+ */
+enum buck_cur_lim_enum {
+	CURRENT_LIMIT_700mA = 0,
+	CURRENT_LIMIT_800mA,
+	CURRENT_LIMIT_1000mA,
+	CURRENT_LIMIT_1200mA
+};
+
+/**
+ * enum ldo_num_enum -	Enum to represent the LDO Numbeer
+ *
+ * @LDO_1: 	LDO Number = 1
+ * @LDO_2: 	LDO Number = 2
+ * ...
+ * @LDO_10: 	LDO Number = 10
+ */
+enum 	ldo_num_enum {
+	LDO_1 = 1, LDO_2, LDO_3, LDO_4, LDO_5,
+	LDO_6,	LDO_7,	LDO_8, LDO_9, LDO_10 
+};
+
+/**
+ * enum buck_num_enum -	Enum to represent the Buck Number
+ *
+ * @BUCK_CORE: 	Buck Number = 1
+ * @BUCK_PRO: 	Buck Number = 2
+ * @BUCK_MEM	Buck Number = 3
+ * @BUCK_PERI: 	Buck Number = 4
+ */
+enum buck_num_enum {
+	BUCK_CORE = 1,
+	BUCK_PRO,
+	BUCK_MEM,
+	BUCK_PERI 
+};
+
+/**
+ * enum da9052_pm_events_enum - Enum to represent events handled by PM driver
+ *
+ * @DA9052_PM_SEQ_RDY_EVENT: 	seq_rdy event = 1
+ * @DA9052_PM_ONKEY_EVENT: 	nONKEY event = 2
+ * @DA9052_PM_ID_FLOAT_EVENT	ID_FLOAT event = 4
+ * @DA9052_PM_ID_GND_EVENT: 	ID_GND event = 8
+ * @DA9052_PM_GPI8_EVENT: 	GPI8 event = 16
+ * @DA9052_PM_GPI9_EVENT: 	GPI8 event = 32
+ * @DA9052_PM_GPI10_EVENT: 	GPI8 event = 64
+ */
+enum da9052_pm_events_enum {
+	DA9052_PM_SEQ_RDY_EVENT = 1 << 0,
+	DA9052_PM_ONKEY_EVENT = 1 << 1,
+	DA9052_PM_ID_FLOAT_EVENT = 1 << 2,
+	DA9052_PM_ID_GND_EVENT = 1 << 3,
+	DA9052_PM_GPI8_EVENT = 1 << 4,
+	DA9052_PM_GPI9_EVENT = 1 << 5,
+	DA9052_PM_GPI10_EVENT = 1 << 6,
+};
+
+/**
+ * enum da9052_powerdown_function_enum -
+ *		Enum to represent functions that can be enabled/disabled in
+ *		power down mode
+ *
+ * @GPIO_PD:		GPIO extender functionality
+ * @ADC_TSI_PD:		ADC/TSI measurement
+ * @PM_IF_PD:		Power manager interface
+ * @HS_2_WIRE_PD:	HS-2-WIRE interface
+ * @BAT_CHG_PD:		Battery charging
+ * @BKUP_BAT_CHG_PD:	Backup-battery charging
+ * @OUT_32K_PD:		OUT_32K
+ * @PM_CONT_PD:		SYS_EN, PWR_EN, PWR1_EN
+ */
+enum da9052_powerdown_function_enum {
+	DA9052_GPIO_PD = 1,
+	DA9052_ADC_TSI_PD,
+	DA9052_PM_IF_PD,
+	DA9052_HS_2_WIRE_PD,
+	DA9052_BAT_CHG_PD,
+	DA9052_BKUP_BAT_CHG_PD,
+	DA9052_OUT_32K_PD,
+	DA9052_PM_CONT_PD,
+};
+
+/*--------------------------------------------------------------------------*/
+/* Structure Definitions                                                    */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * struct pm_event_registration_status - 
+ *		Struct to store registration status of PM events with EH
+ *
+ * @da9030_event_vddlow: 		VDDLOW event
+ * @da9030_event_tbat: 			TBAT Event
+ * @da9030_event_chgend: 		CHGEND Event
+ * @da9030_event_chdet: 		CHGDT Event
+ * @da9030_event_monitoring_fail: 	Monitoring fail event
+ */
+typedef struct {
+	u8	seq_rdy:1;
+	u8	nonkey:1;
+	u8	id_float:1;
+	u8	id_gnd:1;
+	u8	gpi8:1;
+	u8	gpi9:1;
+	u8	gpi10:1;
+}pm_event_registration_status;
+
+/**
+ * struct da9052_buck_config - 
+ *				Struct to represent configuration of a Buck
+ *
+ * @buck_volt: 		Buck voltage in mV
+ * @buck_num: 		Buck Number. Must be one of the buck_num_enum.
+ * @buck_mode: 		Buck Mode, Must be one of the buck_mode_enum.
+ * @current_level: 	Buck Current Level . Must be one of buck_cur_lim_enum
+ * @buck_conf: 		Buck Config mode. Must be 1/0
+ * @buck_pd: 		Buck powerdown mode. Must be 1/0
+ * @bperi_hs: 		Buck Peri HS Enable. Must be 1/0
+ */
+typedef struct {
+	u16 		buck_volt;
+	u8		buck_num;
+	u8 		buck_mode:2;
+	u8 		current_level:2;
+	u8 		buck_conf:1;
+	u8 		buck_pd:1;
+	u8		bperi_hs:1;
+}da9052_buck_config;
+
+/**
+ * struct da9052_ldo_config - 
+ *				Struct to represent configuration of a LDO
+ *
+ * @ldo_volt: 		LDO voltage in mV
+ * @ldo_num: 		LDO Number. Must be one of the buck_num_enum.
+ * @ldo_conf: 		LDO Config mode. Must be 1/0
+ * @ldo_pd: 		LDO powerdown mode. Must be 1/0
+ */
+typedef struct {
+	u16 		ldo_volt;
+	u8	 	ldo_num;
+	u8 		ldo_conf:1;
+	u8 		ldo_pd:1;
+}da9052_ldo_config;
+
+/**
+ * struct da9052_ldo_buck_control - 
+ *				Struct to represent BUCK/LDO Enable
+ *
+ * @ldo_buck_num: 	LDO/BUCK number
+ * @flag: 		Enable/Disable 
+ */
+typedef struct {
+	u8 		ldo_buck_num:4;
+	u8 		flag:1;
+}da9052_ldo_buck_control;
+
+/**
+ * struct da9052_ldo_buck_go - 
+ *				Struct to represent BUCK/LDO GO
+ *
+ * @ldo_buck_num: 	LDO/BUCK number
+ * @flag: 		Ramp/Hold
+ */
+typedef struct {
+	u8 		ldo_buck_num:4;
+	u8 		flag:1;
+}da9052_ldo_buck_go;
+
+/**
+ * struct da9052_func_ctrl_in_powerdown - 
+ *				Struct to represent function control in power down mode
+ *
+ * @pd_func:	Function to be enabled/disabled during power down 
+ * @is_disable:	Enable/Disable control, 1:Disable, 0:Enable
+ */
+typedef struct {
+	enum da9052_powerdown_function_enum pd_func;
+	u8 is_disable;
+}da9052_func_ctrl_in_powerdown;
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*
+ * IOCTL calls that are permitted to the /dev/da9052_pm interface
+ */
+
+/* Set BUCK Configuration */
+/* Input Parameter - da9052_buck_config */
+#define DA9052_PM_IOCTL_CONFIGURE_BUCK		3
+
+/* Set LDO Configuration */
+/* Input Parameter - da9052_ldo_config */
+#define DA9052_PM_IOCTL_CONFIGURE_LDO		4
+
+/* LDo GO Configuration */
+/* Input Parameter - da9052_ldo_buck_go */
+#define DA9052_PM_IOCTL_GO_LDO			5
+
+/* BUCK GO Configuration */
+/* Input Parameter - da9052_ldo_buck_go */
+#define DA9052_PM_IOCTL_GO_BUCK			6
+
+/* LDO ON/OFF Configuration */
+/* Input Parameter - da9052_ldo_buck_control */
+#define DA9052_PM_IOCTL_SET_LDO			7
+
+/* BUCK ON/OFF Configuration */
+/* Input Parameter - da9052_ldo_buck_control */
+#define DA9052_PM_IOCTL_SET_BUCK		8
+
+/* GPI 14 and 15 Reset Enable/Disable */
+/* Input Parameter - u8 flag */
+#define DA9052_PM_IOCTL_SET_GPIO1415_RESET	9
+
+/* nONKY Reset Enable/Disable */
+/* Input Parameter - u8 flag */
+#define DA9052_PM_IOCTL_SET_ONKEY_RESET		10
+
+/* ACCDET Enable/Disable */
+/* Input Parameter - u8 flag */
+#define DA9052_PM_IOCTL_SET_ACCDET		11
+
+/* Get and clear Fault Log */
+/* Input Parameter - Buffer Pointer */
+#define DA9052_PM_IOCTL_GET_FAULTLOG		12
+
+/* ShutDown DA9052 */
+#define DA9052_PM_IOCTL_ASSERT_SHUTDOWN		13
+
+/* DeepSleep DA9052 */
+#define DA9052_PM_IOCTL_ASSERT_DEEPSLEEP	14
+
+/* VMEM_SW Connect/Disconnect */
+/* Input Parameter - u8 flag */
+#define DA9052_PM_IOCTL_VMEM_SW			15
+
+/* VPERI_SW Connect/Disconnect */
+/* Input Parameter - u8 flag */
+#define DA9052_PM_IOCTL_VPERI_SW		16
+
+/* LDO/BUCK LOCK/UNLOCK */
+/* Input Parameter - u8 flag */
+#define DA9052_PM_IOCTL_SET_LOCK		17
+
+/* Get EH Event from Driver */
+/* Input Parameter - Buffer Pointer */
+#define DA9052_PM_IOCTL_GET_EVENT		18
+
+/* Register Event to PM */
+/* Input Parameter - u8 event_type */
+#define DA9052_PM_IOCTL_REGISTER_EVENT		19
+
+/* Un-Register Event to PM */
+/* Input Parameter - u8 event_type */
+#define DA9052_PM_IOCTL_UNREGISTER_EVENT	20
+
+/* Merge/UnMerge BuckCore and BuckPro */
+/* Input Parameter - u8 flag */
+#define DA9052_PM_IOCTL_BUCKMERGE		21
+
+/* Enable/disable different functions in POWER-DOWN mode */
+/* Input Parameter - da9052_func_ctrl_in_powerdown *  */
+/* Set 
+	0: To Enable
+	1: To Disable
+   a particular function in the input parameter */
+#define DA9052_PM_IOCTL_FUNC_CTRL_IN_POWERDOWN	22
+
+/*--------------------------------------------------------------------------*/
+/* Inline Functions                                                         */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * buckpro_mV_to_reg:	Convert BUCKRO voltage to reg
+ * 
+ * @param u16 value:	buckpro voltage value.
+ * @return u8:		Buckpro volt bit field value
+ */
+static inline  u8 buckpro_mV_to_reg(u16 value)
+{
+	return((value - BUCK_CORE_PRO_VOLT_LOWER)/BUCK_CORE_PRO_STEP);
+}
+
+/**
+ * validate_buckpro_mV:	Validate BUCKPRO voltage value
+ * 
+ * @param u16 value:	BUCKPRO voltage value.
+ * @return u8:		Error Status SUCCESS and FAILURE
+ */
+static inline  u8 validate_buckpro_mV(u16 value)
+{
+	/* Check the voltage range */
+	if((value >= BUCK_CORE_PRO_VOLT_LOWER) &&
+		(value <= BUCK_CORE_PRO_VOLT_UPPER))
+		return (((value - BUCK_CORE_PRO_VOLT_LOWER)%BUCK_CORE_PRO_STEP > 0) ? FAILURE : SUCCESS);
+	return (FAILURE);
+}
+
+/**
+ * buckmem_mV_to_reg:	Convert BUCKMEM pro voltage to reg
+ * 
+ * @param u16 value:	buckmem voltage value.
+ * @return u8:		Buckmem volt bit field value
+ */
+static inline  u8 buckmem_mV_to_reg(u16 value)
+{
+	return ((value - BUCK_MEM_VOLT_LOWER)/BUCK_MEM_STEP);
+}
+
+/**
+ * validate_buckmem_mV:	Validate BUCKMEM voltage value
+ * 
+ * @param u16 value:	BUCKMEM voltage value.
+ * @return u8:		Error Status SUCCESS and FAILURE
+ */
+static inline  u8 validate_buckmem_mV(u16 value)
+{
+	/* Check the voltage range */
+	if ((value >= BUCK_MEM_VOLT_LOWER) && (value <= BUCK_MEM_VOLT_UPPER)) 
+		return (((value - BUCK_MEM_VOLT_LOWER)%BUCK_MEM_STEP > 0) ? FAILURE : SUCCESS);
+	return (FAILURE);
+}
+
+/**
+ * ldo9_mV_to_reg:	Convert LDO9 voltage to reg
+ * 
+ * @param u16 value:	LDO9 voltage value.
+ * @return u8:		LDO9 volt bit field value
+ */
+static inline  u8 ldo9_mV_to_reg(u16 value)
+{
+	return ((value - LDO9_VOLT_LOWER)/LDO9_VOLT_STEP);
+}
+
+/**
+ * validate_ldo9_mV:	Validate LDO9 voltage value
+ * 
+ * @param u16 value:	LDO9 voltage value.
+ * @return u8:		Error Status SUCCESS and FAILURE
+ */
+static inline  u8 validate_ldo9_mV(u16 value)
+{
+	/* Check the voltage range */
+	if ((value >= LDO9_VOLT_LOWER) && (value <= LDO9_VOLT_UPPER))
+		return (((value - LDO9_VOLT_LOWER)%LDO9_VOLT_STEP > 0) ? FAILURE : SUCCESS);
+	return (FAILURE);
+}
+
+/**
+ * ldo567810_mV_to_reg:	Convert LDO5/LDO6/LDO7/LDO8/LDO10 voltage to reg
+ * 
+ * @param u16 value:	LDO5/LDO6/LDO7/LDO8/LDO10 voltage value.
+ * @return u8:		LDO5/LDO6/LDO7/LDO8/LDO10 volt bit field value
+ */
+static inline  u8 ldo567810_mV_to_reg(u16 value)
+{
+	return ((value - LDO567810_VOLT_LOWER)/LDO567810_VOLT_STEP);
+}
+
+/**
+ * validate_ldo567810_mV:	Validate LDO5/LDO6/LDO7/LDO8/LDO10 voltage value
+ * 
+ * @param u16 value:	LDO5/LDO6/LDO7/LDO8/LDO10 voltage value.
+ * @return u8:		Error Status SUCCESS and FAILURE
+ */
+static inline  u8 validate_ldo567810_mV(u16 value)
+{
+	/* Check the voltage range */
+	if ((value >= LDO567810_VOLT_LOWER) && (value <= LDO567810_VOLT_UPPER)) 
+		return (((value - LDO567810_VOLT_LOWER)%LDO567810_VOLT_STEP > 0) ? FAILURE : SUCCESS);
+	return (FAILURE);
+}
+
+/**
+ * ldo34_mV_to_reg:	Convert LDO3/LDO4 voltage to reg
+ * 
+ * @param u16 value:	LDO3/LDO4 voltage value.
+ * @return u8:		LDO3/LDO4 volt bit field value
+ */
+static inline  u8 ldo34_mV_to_reg(u16 value)
+{
+	return ((value - LDO34_VOLT_LOWER)/LDO34_VOLT_STEP);
+}
+
+/**
+ * validate_ldo34_mV:	Validate LDO3/LDO4 voltage value
+ * 
+ * @param u16 value:	LDO3/LDO4 voltage value.
+ * @return u8:		Error Status SUCCESS and FAILURE
+ */
+static inline  u8 validate_ldo34_mV(u16 value)
+{
+	/* Check the voltage range */
+	if ((value >= LDO34_VOLT_LOWER) && (value <= LDO34_VOLT_UPPER))
+		return (((value - LDO34_VOLT_LOWER)%LDO34_VOLT_STEP > 0) ? FAILURE : SUCCESS);
+	return (FAILURE);
+}
+
+/**
+ * ldo1_mV_to_reg:	Convert LDO1 voltage to reg
+ * 
+ * @param u16 value:	LDO1 voltage value.
+ * @return u8:		LDO1 volt bit field value
+ */
+static inline  u8 ldo1_mV_to_reg(u16 value)
+{
+	return ((value - LDO1_VOLT_LOWER)/LDO1_VOLT_STEP);
+}
+
+/**
+ * validate_ldo1_mV:	Validate LDO1 voltage value
+ * 
+ * @param u16 value:	LDO1 voltage value.
+ * @return u8:		Error Status SUCCESS and FAILURE
+ */
+static inline  u8 validate_ldo1_mV(u16 value)
+{
+	/* Check the voltage range */
+	if ((value >= LDO1_VOLT_LOWER) && (value <= LDO1_VOLT_UPPER))
+		return (((value - LDO1_VOLT_LOWER)%LDO1_VOLT_STEP > 0) ? FAILURE : SUCCESS);
+	return (FAILURE);
+}
+
+/**
+ * ldo2_mV_to_reg:	Convert LDO2 voltage to reg
+ * 
+ * @param u16 value:	LDO2 voltage value.
+ * @return u8:		LDO2 volt bit field value
+ */
+static inline  u8 ldo2_mV_to_reg(u16 value)
+{
+	return ((value - LDO2_VOLT_LOWER)/LDO2_VOLT_STEP);
+}
+
+/**
+ * validate_ldo2_mV:	Validate LDO2 voltage value
+ * 
+ * @param u16 value:	LDO2 voltage value.
+ * @return u8:		Error Status SUCCESS and FAILURE
+ */
+static inline  u8 validate_ldo2_mV(u16 value)
+{
+	/* Check the voltage range */
+	if ((value >= LDO2_VOLT_LOWER) && (value <= LDO2_VOLT_UPPER))
+		return (((value - LDO2_VOLT_LOWER)%LDO2_VOLT_STEP > 0) ? FAILURE : SUCCESS);
+	return (FAILURE);
+}
+
+/**
+ * buckperi_mV_to_reg:	Convert BUCKPERI voltage to reg
+ * 
+ * @param u16 value:	BUCKPERI voltage value.
+ * @return u8:		BUCKPERI volt bit field value
+ */
+static inline  u8 buckperi_mV_to_reg(u16 value)
+{
+	if (value <= 3000 ) 
+		return ((value - BUCK_PERI_VOLT_LOWER)/BUCK_PERI_STEP_BELOW_3000);
+	return ((value - 3000)/BUCK_PERI_STEP_ABOVE_3000 + BUCK_PERI_VALUES_UPTO_3000);
+}
+
+/**
+ * validate_buckperi_mV:	Validate BUCKPERI voltage value
+ * 
+ * @param u16 value:	BUCKPERI voltage value.
+ * @return u8:		Error Status SUCCESS and FAILURE
+ */
+static inline  u8 validate_buckperi_mV(u16 value)
+{
+	/* Check the voltage range */
+	if (!( (value >= BUCK_PERI_VOLT_LOWER) &&
+		(value <= BUCK_PERI_VOLT_UPPER) ))
+		return (FAILURE);
+
+	if (value <= 3000)
+		return (((value - BUCK_PERI_VOLT_LOWER)% BUCK_PERI_STEP_BELOW_3000 > 0) ? FAILURE : SUCCESS );
+	return (((value - 3000)%BUCK_PERI_STEP_ABOVE_3000 > 0) ? FAILURE : SUCCESS );
+}
+
+/*--------------------------------------------------------------------------*/
+/* External Functions                                                       */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Other Functions                                                          */
+/*--------------------------------------------------------------------------*/
+
+s32 da9052_pm_configure_buck(da9052_buck_config);
+s32 da9052_pm_configure_ldo(da9052_ldo_config);
+s32 da9052_pm_set_buckmerge(u8 );
+s32 da9052_pm_go_buck(u8 , u8 );
+s32 da9052_pm_set_ldo(u8 , u8 );
+s32 da9052_pm_set_buck(u8 , u8 );
+s32 da9052_pm_go_ldo(u8 , u8 );
+s32 da9052_pm_set_gpio1415_reset_function(u8 );
+s32 da9052_pm_set_onkey_reset_function(u8 );
+s32 da9052_pm_set_accdet(u8 );
+s32 da9052_pm_get_faultlog(u8* );
+s32 da9052_pm_assert_shutdown(void);
+s32 da9052_pm_assert_deepsleep(void);
+s32 da9052_pm_vmem_sw(u8);
+s32 da9052_pm_vperi_sw(u8 );
+s32 da9052_pm_set_lock(u8 );
+s32 da9052_pm_function_ctrl_in_powerdown(u8 , u8 );
+
+#endif /* _DA9052_PM_H */
Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.
