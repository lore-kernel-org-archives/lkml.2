Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab0FCIpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:45:21 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:22042 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138Ab0FCIpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:45:15 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE:  [PATCH] TOUCHSCREEN of DA9052 Linux device drivers (8/9)
Date: Thu, 3 Jun 2010 09:45:04 +0100
Message-ID: <3495EC08FA53E94AAA00CC4743D5BA7E010C241C@pandora.diasemi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] TOUCHSCREEN of DA9052 Linux device drivers (8/9)
Thread-Index: Acr3OjJrL27IIF6GT4u1E2H0CnufiAAABX6AAu+QcoA=
From: "David Dajun Chen" <Dajun.Chen@diasemi.com>
To: "David Dajun Chen" <Dajun.Chen@diasemi.com>,
       <linux-kernel@vger.kernel.org>
Cc: <dmitry.torokhov@gmail.com>, <dtor@mail.ru>
X-OriginalArrivalTime: 03 Jun 2010 08:45:09.0371 (UTC) FILETIME=[12AE34B0:01CB02F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear sirs,

Following the LKML instructions, a patch file was sent to you for review two weeks ago. 

Please would you kindly provide your comments in your earliest convenience? 

Regards

David

Dr. David Dajun Chen
Dialog Semiconductor Ltd.
Delta 200, Welton Road
Delta Business Park
Swindon
Wiltshire SN5 7XB
UK
Telephone: (+44) 01793-757714
Mobile:         (+44) 07917015477
Fax:               (+44) 01793-758000

-----Original Message-----
From: David Dajun Chen 
Sent: 19 May 2010 11:08
To: 'linux-kernel@vger.kernel.org'
Cc: 'dmitry.torokhov@gmail.com'; 'dtor@mail.ru'
Subject: [PATCH] TOUCHSCREEN of DA9052 Linux device drivers (8/9)

Dear sir/madam,

The attached is the TOUCHSCREEN part of the device drivers newly developed for DA9052 Power Management IC from Dialog Semiconductor.

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
===========================================================================

diff -Naur linux-2.6.33.2_bk/drivers/input/touchscreen/da9052_tsi.c linux-2.6.33.2_patch/drivers/input/touchscreen/da9052_tsi.c
--- linux-2.6.33.2_bk/drivers/input/touchscreen/da9052_tsi.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/input/touchscreen/da9052_tsi.c	2010-05-18 18:27:40.000000000 +0500
@@ -0,0 +1,2425 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_tsi.c: Driver for Touch Screen interface on DA9052 chip.
+ *
+ *
+ * History:
+ *
+ * (05/05/2009): Released with basic TSI functionality with out filter
+ *
+ * (12/05/2009): Released with following functions 
+ *		 (1) window & Average filter implemented
+ *		 (2) Calibration function has supported.
+ *		 (3) EH interface functions are appropriately implmented and 
+ *		     called
+ *
+ * (11/06/2009): Following are the major changes for this version:
+ *		(1) Added thread to poll event handler(EH) periodically
+ *		    for data.
+ *		(2) The data read from EH is in the same format as that stored 
+ *		    on DA9052 registers. This register format data or 
+ *		    REG data is then converted to coordinate format.
+ *		(3) This thread also implements pen-up detection mechanism.
+ *		(4) This version also supports Manual measurement of TSI data.
+ *		(5) Additional configuration functions have also been added 
+ *		    to this release.
+ *
+ * (27/04/2010): 	Created initial draft for Linux community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+/*--------------------------------------------------------------------------*/
+/* System wide include files                                                */
+/*--------------------------------------------------------------------------*/
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/freezer.h>
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+#include <linux/mfd/da9052/da9052_reg.h>
+#include <linux/mfd/da9052/da9052_lib.h>
+#include <linux/mfd/da9052/da9052_tsi_filter.h>
+#include <linux/mfd/da9052/da9052_tsi_calibrate.h>
+#include <linux/mfd/da9052/da9052_eh.h>
+#include <linux/mfd/da9052/da9052_gpio.h>
+#include <linux/mfd/da9052/da9052_adc.h>	//for ADC_MAN_TSI & sampling interval
+#include <linux/mfd/da9052/da9052_pm.h>
+#include <linux/mfd/da9052/da9052_tsi_cfg.h>
+#include <linux/mfd/da9052/da9052_tsi.h>
+
+#include "da9052_tsi_filter.c"
+#include "da9052_tsi_calibrate.c"
+
+
+/*--------------------------------------------------------------------------*/
+/* Local Constant Definitions                                               */
+/*--------------------------------------------------------------------------*/
+static u8 banner[] __initdata = "DA9052 TSI Device Driver, v1.0\n";
+/*--------------------------------------------------------------------------*/
+/* Local Macro Definitions                                                  */
+/*--------------------------------------------------------------------------*/
+/* TSI driver vrsion */
+#define TSI_VERSION 0x0101
+
+/* Bit position of TSI_DELAY bits in contral A register of DA9052 */
+#define TSI_DELAY_BIT_SHIFT			6
+
+/* Bit position of TSI_SKIP bits in contral A register of DA9052 */
+#define TSI_SKIP_BIT_SHIFT			3
+
+/* Number of TSI result registers */
+#define NUM_TSI_RESULT_REGISTERS		4
+
+/* Number of GPIO registers for TSI */
+#define NUM_GPIO_TSI_REGISTERS			3
+
+/* polling interval to check for manual conversion (in msecs) */
+#define MANUAL_CONVERSION_SLEEP			15
+
+/* time out count for manual conversion of TSI data */
+#define MANUAL_CONVERSION_TIME_OUT_CNT		\
+		((MANUAL_CONVERSION_TIME_OUT) / MANUAL_CONVERSION_SLEEP)
+
+/* Supply voltage required for TSI conversion, in mVolt */
+#define DA9052_TSI_SUPPLY_VOLTAGE		2500
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+/* store number of instances of the driver open */
+static u8 tsi_device_open = 0;
+
+/* Variable to store major number of DA9052 TSI device */
+static s32 tsi_major_number = 0;
+
+/* TSI Platform device for power management */
+static struct platform_device *da9052_tsi_platform_device;
+
+/* Time period (in msecs) for processing of REG FIFO */
+u32 tsi_reg_data_poll_interval;
+
+/* Lock for input channel of DA9052 adc manual multiplexer */
+extern struct mutex da9052_adc_manconv_lock;
+
+
+/*--------------------------------------------------------------------------*/
+/* Local Function Prototype                                                 */
+/*--------------------------------------------------------------------------*/
+static ssize_t __init da9052_tsi_create_input_dev(struct input_dev** ip_dev, 
+									u8 n);
+
+static ssize_t read_da9052_reg(u8 reg_addr);
+
+static ssize_t write_da9052_reg(u8 reg_addr, u8 data);
+
+static void da9052_tsi_reg_pendwn_event(void);
+
+static ssize_t da9052_tsi_config_pen_detect(u8 flag);
+
+static ssize_t da9052_tsi_disable_irq(enum TSI_IRQ tsi_irq);
+
+static ssize_t da9052_tsi_enable_irq(enum TSI_IRQ tsi_irq);
+
+static ssize_t da9052_tsi_config_manual_coord(enum TSI_COORDINATE coord);
+
+static ssize_t da9052_tsi_config_manual_mode(u8 coordinate);
+
+static ssize_t da9052_tsi_config_auto_mode(u8 state);
+
+static ssize_t da9052_tsi_config_gpio(void);
+
+static ssize_t da9052_tsi_read_manual_data(s16* data, 
+						enum TSI_COORDINATE coord);
+
+static ssize_t da9052_tsi_config_power_supply(u8 state);
+
+static da9052_tsi_info *get_tsi_drvdata(void);
+
+void da9052_tsi_penup_event(void);
+
+void da9052_tsi_pen_down_handler(u32 event);
+
+static ssize_t da9052_tsi_reg_proc_thread (void *ptr);
+
+static ssize_t da9052_tsi_resume(struct platform_device *dev);
+
+static ssize_t da9052_tsi_suspend(struct platform_device *dev, 
+							pm_message_t state);
+/*--------------------------------------------------------------------------*/
+/* Global Functions                                                         */
+/*--------------------------------------------------------------------------*/
+/**
+ * da9052_tsi_config_measure_seq: 
+ * Description: this function configures tsi measurement 
+ *		sequence to XP or XYZP mode. Driver's status is not updated 
+ *		in this call.
+ *		
+ * @param seq		TSI Measurement sequence. 0:XYP, 1:XP.
+ * @return ssize_t      Returns Success or Failure
+ */
+ssize_t da9052_tsi_config_measure_seq(enum TSI_MEASURE_SEQ seq)
+{
+	ssize_t ret = 0;
+	u8 data = 0;
+	da9052_tsi_info *ts = get_tsi_drvdata();
+
+	if (seq > 1)
+		return (-EINVAL);
+
+	/*Get the latest value from the device*/
+	/* Read manual mode control A register */
+	ret = read_da9052_reg(DA9052_TSICONTA_REG);
+	if(ret < 0) {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG("read_da9052_reg Failed \n" );
+			return (ret);
+	}
+
+	/* set state */
+	data = (u8)ret;
+
+	if (seq == XYZP_MODE)
+		data = enable_xyzp_mode(data);
+	else if (seq == XP_MODE)
+		data = enable_xp_mode(data);
+	else {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG("Invalid Value passed \n" );
+		return (-EINVAL);
+	}
+
+	/*Write value into register*/
+	ret = write_da9052_reg(DA9052_TSICONTA_REG, data);
+	if(ret) {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG(" write_da9052_reg Failed \n" );
+		return (ret);
+	}
+
+	/* update driver's status */
+	ts->tsi_conf.auto_cont.da9052_tsi_cont_a = data;
+
+	return(SUCCESS);
+}
+
+/**
+ * da9052_tsi_set_sampling_mode: 
+ * Description: This is the function to select the 
+ *		sampling intervel of ADC to measure the 
+ *		TSI co-ordinates either 1ms or 10ms.
+ *		
+ * @param  mode		the mode to be configured, fast or economy mode. 
+ * @return ssize_t	Returns Success or Failure
+ */
+ssize_t da9052_tsi_set_sampling_mode(u8 mode)
+{
+	u8 data = 0;
+	ssize_t ret=0;
+	da9052_tsi_info *ts = get_tsi_drvdata();
+
+	/* Read ADC Control register to get the current configuration */
+	ret = read_da9052_reg(DA9052_ADCCONT_REG );
+	if(ret < 0) {
+		DA9052_DEBUG("DA9052_TSI:%s:", __FUNCTION__);
+		DA9052_DEBUG("read_da9052_reg Failed \n" );
+		return (ret);
+	}
+	data = (u8)ret;
+
+	/* configure ADC mode as per required sampling mode */
+	if (mode == ECONOMY_MODE) {
+		data = adc_mode_economy_mode(data);
+
+	} else if (mode == FAST_MODE) {
+		data = adc_mode_fast_mode(data);
+
+	} else {
+		DA9052_DEBUG("DA9052_TSI:%s:", __FUNCTION__);
+		DA9052_DEBUG("Invalid interval passed \n" );
+		return (-EINVAL);
+	}
+
+	/*Write into ADC control register*/
+	ret = write_da9052_reg(DA9052_ADCCONT_REG, data );
+	if(ret) {
+		DA9052_DEBUG("DA9052_TSI:%s:", __FUNCTION__);
+		DA9052_DEBUG("write_da9052_reg Failed \n" );
+		return (ret);
+	}
+
+	/* configure driver as per required sampling mode */
+	switch(mode)
+	{
+	case ECONOMY_MODE:
+		tsi_reg_data_poll_interval = 
+			TSI_ECO_MODE_REG_DATA_PROCESSING_INTERVAL;
+		tsi_raw_data_poll_interval = 
+			TSI_ECO_MODE_RAW_DATA_PROCESSING_INTERVAL;
+		break;
+	case FAST_MODE:
+		tsi_reg_data_poll_interval = 
+			TSI_FAST_MODE_REG_DATA_PROCESSING_INTERVAL;
+		tsi_raw_data_poll_interval = 
+			TSI_FAST_MODE_RAW_DATA_PROCESSING_INTERVAL;
+		break;
+	default:
+		DA9052_DEBUG("DA9052_TSI:%s:", __FUNCTION__);
+		DA9052_DEBUG("Invalid interval passed \n" );
+		return (-EINVAL);
+	}
+
+	/* Calculate number of zero data count cycles to */
+	/* declare penup in TS_PENUP_DETECT_INTERVEL */
+	ts->tsi_penup_count = 
+		(u32)TS_PENUP_DETECT_INTERVEL / tsi_reg_data_poll_interval; 
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_tsi_config_delay: 
+ * Description: The TSI delay between measurments are 
+ *	        configured from this function
+ *		
+ * @param delay   	Its a enum variable represents number of slots to be 
+ *			delayed for each TSI new measurment
+ * @return ssize_t	Returns Success or Failure
+ */
+ssize_t da9052_tsi_config_delay(enum TSI_DELAY delay)
+{
+	ssize_t ret = 0;
+	u8 data = 0;
+	da9052_tsi_info *ts = get_tsi_drvdata();
+
+	if (delay > MAX_TSI_DELAY)
+	{
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG(" invalid value for tsi delay!!!\n" );
+
+		return (-EINVAL);
+	}
+
+	/* Get the latest value from the device */
+	/* Read manual mode control A register */
+	ret = read_da9052_reg(DA9052_TSICONTA_REG);
+	if(ret < 0) {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG("read_da9052_reg Failed \n" );
+			return (ret);
+	}
+
+	/* clear out 2 bits corresponding to TSI_DELAY */
+	data = clear_bits( (u8)ret, DA9052_TSICONTA_TSIDELAY);
+
+	/* store new delay value to register */
+	data = set_bits(data, (delay << TSI_DELAY_BIT_SHIFT));
+
+	/* Write value into register */
+	ret = write_da9052_reg(DA9052_TSICONTA_REG, data);
+	if(ret)
+	{
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG(" write_da9052_reg Failed \n" );
+
+		return (ret);
+	}
+
+	/* update s/w state */
+	ts->tsi_conf.auto_cont.da9052_tsi_cont_a = data;
+
+	return(SUCCESS);
+}
+
+/**
+ * da9052_tsi_config_skip_slots: 
+ * Description: The TSI number of slots to be skiped between
+ *		TSI measurments are configured from this function
+ *		
+ * @param delay		Its a enum variable represents number of slots to be 
+ *			skipped for each TSI new measurment
+ * @return ssize_t      Returns Success or Failure
+ */
+ssize_t da9052_tsi_config_skip_slots(enum TSI_SLOT_SKIP skip)
+{
+	ssize_t ret = 0;
+	u8 data = 0;
+	da9052_tsi_info *ts = get_tsi_drvdata();
+
+	if (skip > MAX_TSI_SKIP_SLOT)
+	{
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG(" invalid value for tsi skip slots!!!\n" );
+		return (-EINVAL);
+	}
+
+	/*Get the latest value from the device*/
+	/* Read manual mode control register */
+	ret = read_da9052_reg(DA9052_TSICONTA_REG);
+	if(ret < 0) {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG("read_da9052_reg Failed \n" );
+			return (ret);
+	}
+
+	/* clear out 3 bits corresponding to TSI_SKIP */
+	data = clear_bits( (u8)ret, DA9052_TSICONTA_TSISKIP);
+
+	/* store new skip value to register */
+	data = set_bits(data, (skip << TSI_SKIP_BIT_SHIFT));
+
+	/*Write value into register*/
+	ret = write_da9052_reg(DA9052_TSICONTA_REG, data);
+	if(ret) {
+		DA9052_DEBUG("DA9052_TSI:da9052_tsi_config_skip_slots:");
+		DA9052_DEBUG(" write_da9052_reg Failed \n" );
+
+		return (ret);
+	}
+
+	/* update s/w state */
+	ts->tsi_conf.auto_cont.da9052_tsi_cont_a = data;
+
+	return(SUCCESS);
+}
+
+/**
+ * da9052_tsi_config_state:
+ * Description: This function sets the measurement state
+ *		of TSI device to one of the following:
+ *	0. TSI_AUTO_MODE 		continuously measure coordinate data.
+ * 	1. TSI_MANUAL_COORD_X		Manually Measure coordinate along X axis
+ * 	2. TSI_MANUAL_COORD_Y		Manually Measure coordinate along Y axis
+ * 	3. TSI_MANUAL_COORD_Z		Manually Measure coordinate along Z axis
+ * 	4. TSI_MANUAL_SET		Measure one set of x, y & z coordinates
+ * 	5. TSI_IDLE			TSI disabled
+ *
+ * @param  state	state to which TSI has to be configured.
+ * @return ssize_t	Returns Success or Failure
+ */
+ssize_t da9052_tsi_config_state(enum TSI_STATE state)
+{
+	s32 ret;
+	da9052_tsi_info *ts = get_tsi_drvdata();
+
+	if (ts->tsi_conf.state == state)
+		return (SUCCESS);
+
+	switch (state) {
+	case TSI_AUTO_MODE:
+		/* Reset zero data counter & early data flag */
+		ts->tsi_zero_data_cnt = 0;
+		early_data_flag = TRUE;
+		debounce_over = FALSE;
+		win_reference_valid = FALSE;
+
+		/* Clean REG & RAW FIFOs */ 
+		clean_tsi_fifos();
+
+		/* Enable auto TSI mode */
+		ret = da9052_tsi_config_auto_mode(DISABLE);
+		if (ret)
+			return (ret);
+		/* Disable TSI manual measurement mode */
+		ret = da9052_tsi_config_manual_mode(DISABLE);
+		if (ret)
+			return (ret);
+
+		/* Disable TSI power supply */
+		ret = da9052_tsi_config_power_supply(DISABLE);
+		if (ret)
+			return (ret);
+
+		/* enable TSI_PEN_DWN interrupt notification */
+		ret = da9052_tsi_enable_irq(TSI_PEN_DWN);
+		if (ret)
+			return (ret);
+		ts->tsi_conf.tsi_pendown_irq_mask = RESET;
+
+		/* disable TSI_READY irq */
+		ret = da9052_tsi_disable_irq(TSI_DATA_RDY);
+		if (ret)
+			return (ret);
+		ts->tsi_conf.tsi_ready_irq_mask	  = SET;
+
+		/* register with EH */
+		da9052_tsi_reg_pendwn_event();
+
+		/* Enable pen down detect */
+		ret = da9052_tsi_config_pen_detect(ENABLE);
+		if (ret)
+			return (ret);
+		break;
+
+
+	case TSI_MANUAL_COORD_X:
+		/* Reset pen down flag */
+		ts->pen_dwn_event = RESET;
+
+		/* Disable auto TSI mode */
+		ret = da9052_tsi_config_auto_mode(DISABLE);
+		if (ret)
+			return (ret);
+
+		/* configure the axis along which measurement's to be made */
+		ret = da9052_tsi_config_manual_coord(X_COORDINATE);
+		if (ret)
+			return (ret);
+
+		/* Enable TSI manual measurement mode */
+		ret = da9052_tsi_config_manual_mode(ENABLE);
+		if (ret)
+			return (ret);
+
+		/* In manual mode, TSI should NOT be in XP mode */
+		da9052_tsi_config_measure_seq(XYZP_MODE);
+
+		/* Enable TSI power supply */
+		ret = da9052_tsi_config_power_supply(ENABLE);
+		if (ret)
+			return (ret);
+
+		/* unregister from EH */
+		if (ts->pd_reg_status) {
+			da9052_eh_unregister_nb(&ts->pd_nb);
+			ts->pd_reg_status = RESET;
+		}
+
+		/* Tell EH to stop sampling TSI data from h/w */
+		da9052_tsi_stop_sampling();
+
+		/* Enable pen down detect */
+		ret = da9052_tsi_config_pen_detect(ENABLE);
+		if (ret)
+			return (ret);
+
+		break;
+
+
+	case TSI_MANUAL_COORD_Y:
+		/* Reset pen down flag */
+		ts->pen_dwn_event = RESET;
+
+		/* Disable auto TSI mode */
+		ret = da9052_tsi_config_auto_mode(DISABLE);
+		if (ret)
+			return (ret);
+
+		/* configure the axis along which measurement's to be made */
+		ret = da9052_tsi_config_manual_coord(Y_COORDINATE);
+		if (ret)
+			return (ret);
+
+		/* Enable TSI manual measurement mode */
+		ret = da9052_tsi_config_manual_mode(ENABLE);
+		if (ret)
+			return (ret);
+
+		/* In manual mode, TSI should NOT be in XP mode */
+		da9052_tsi_config_measure_seq(XYZP_MODE);
+
+		/* Enable TSI power supply */
+		ret = da9052_tsi_config_power_supply(ENABLE);
+		if (ret)
+			return (ret);
+
+		/* unregister from EH */
+		if (ts->pd_reg_status) {
+			da9052_eh_unregister_nb(&ts->pd_nb);
+			ts->pd_reg_status = RESET;
+		}
+
+		/* Tell EH to stop sampling TSI data from h/w */
+		da9052_tsi_stop_sampling();
+
+		/* Enable pen down detect */
+		ret = da9052_tsi_config_pen_detect(ENABLE);
+		if (ret)
+			return (ret);
+		break;
+
+
+	case TSI_MANUAL_COORD_Z:
+		/* Reset pen down flag */
+		ts->pen_dwn_event = RESET;
+
+		/* Disable auto TSI mode */
+		ret = da9052_tsi_config_auto_mode(DISABLE);
+		if (ret)
+			return (ret);
+
+		/* configure the axis along which measurement's to be made */
+		ret = da9052_tsi_config_manual_coord(Z_COORDINATE);
+		if (ret)
+			return (ret);
+
+		/* Enable TSI manual measurement mode */
+		ret = da9052_tsi_config_manual_mode(ENABLE);
+		if (ret)
+			return (ret);
+
+		/* In manual mode, TSI should NOT be in XP mode */
+		da9052_tsi_config_measure_seq(XYZP_MODE);
+
+		/* Enable TSI power supply */
+		ret = da9052_tsi_config_power_supply(ENABLE);
+		if (ret)
+			return (ret);
+
+		/* unregister from EH */
+		if (ts->pd_reg_status) {
+			da9052_eh_unregister_nb(&ts->pd_nb);
+			ts->pd_reg_status = RESET;
+		}
+
+		/* Tell EH to stop sampling TSI data from h/w */
+		da9052_tsi_stop_sampling();
+
+		/* Enable pen down detect */
+		ret = da9052_tsi_config_pen_detect(ENABLE);
+		if (ret)
+			return (ret);
+
+		break;
+
+
+	case TSI_MANUAL_SET:
+		/* Reset pen down flag */
+		ts->pen_dwn_event = RESET;
+
+		/* Enable auto TSI mode */
+		ret = da9052_tsi_config_auto_mode(ENABLE);
+		if (ret)
+			return (ret);
+
+		/* Enable TSI manual measurement mode */
+		ret = da9052_tsi_config_manual_mode(ENABLE);
+		if (ret)
+			return (ret);
+
+		/* In manual mode, TSI should NOT be in XP mode */
+		da9052_tsi_config_measure_seq(XYZP_MODE);
+
+		/* Enable TSI power supply */
+		ret = da9052_tsi_config_power_supply(ENABLE);
+		if (ret)
+			return (ret);
+
+		/* unregister from EH */
+		if (ts->pd_reg_status) {
+			da9052_eh_unregister_nb(&ts->pd_nb);
+			ts->pd_reg_status = RESET;
+		}
+
+		/* Tell EH to stop sampling TSI data from h/w */
+		da9052_tsi_stop_sampling();
+
+		/* Enable pen down detect */
+		ret = da9052_tsi_config_pen_detect(ENABLE);
+		if (ret)
+			return (ret);
+		break;
+
+
+	case TSI_IDLE:
+		/* Reset pen down flag */
+		ts->pen_dwn_event = RESET;
+
+		/* disable PEN_DOWN_DET mechanism of DA9052 */
+		ret = da9052_tsi_config_pen_detect(DISABLE);
+		if (ret)
+			return (ret);
+
+		/* Disable auto TSI mode */
+		ret = da9052_tsi_config_auto_mode(DISABLE);
+		if (ret)
+			return (ret);
+
+		/* Disable TSI manual measurement mode */
+		ret = da9052_tsi_config_manual_mode(DISABLE);
+		if (ret)
+			return (ret);
+
+		/* Disable TSI power supply */
+		ret = da9052_tsi_config_power_supply(DISABLE);
+		if (ret)
+			return (ret);
+
+		/* unregister from EH */
+		if (ts->pd_reg_status) {
+			da9052_eh_unregister_nb(&ts->pd_nb);
+			ts->pd_reg_status = RESET;
+		}
+		break;
+
+
+	default:
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG(" Invalid state passed");
+		return (-EINVAL);
+	}
+
+	/* update device state */
+	ts->tsi_conf.state = state;
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_tsi_get_manual_measurement: 
+ * Description: This function is used to read manual conversion data.
+ *		The following are the functionalities of this subroutine
+ *		1. Verifies the mode of TSI driver.
+ *		2. Enables TSI power supply.
+ *		3. Configures the da9052 for Manual measurement
+ *		4. Starts the manual conversion and reads the data.
+ *		5. After conversion disables TSI power supply.
+ *
+ * @param tsi_data	Pointer to buffer to store manual data.
+ * @return ssize_t   	Returns Success or Failure
+ */
+ssize_t da9052_tsi_get_manual_measurement(da9052_tsi_data* tsi_data)
+{
+	da9052_tsi_info *ts = get_tsi_drvdata();
+	u32 time_out;
+	s16 data;
+	ssize_t ret;
+
+	/* Initialize mutex required for ADC Manual read */
+	//mutex_init(&da9052_adc_manconv_lock);
+
+	/* If TSI state is either Auto or Idle mode */
+	/* then return with error */
+	if ((ts->tsi_conf.state == TSI_AUTO_MODE) || 
+				(ts->tsi_conf.state == TSI_IDLE)) {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG(" Configure TSI to either of the ");
+		DA9052_DEBUG("three manual modes.\n");
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG(" Then call this API.\n" );
+		return (-FAILURE);
+	}
+
+	if (!tsi_data)
+		return (-EINVAL);
+
+	data = 0;
+	time_out = 0;
+
+	/* Enable TSI power supply */
+	da9052_tsi_config_power_supply(ENABLE);
+
+	/* acquire lock for ADC multiplexer */
+	mutex_lock(&da9052_adc_manconv_lock);
+
+	/* configure TSI to manual mode, this starts manual conversion */
+	if ((ret=da9052_tsi_config_manual_mode(ENABLE)) != SUCCESS)
+		return (ret);
+
+	/* wait till conversion is finished */
+	do {
+		/*Check whether manual conversion is over or not*/
+		/* sleep between iterations */
+		msleep(MANUAL_CONVERSION_SLEEP);
+
+		/* wait max 5 sec for manual input */
+		time_out++;
+
+		/* read manual conversion register */
+		data = read_da9052_reg(DA9052_TSICONTB_REG);
+		if(data < 0) {
+			DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+			DA9052_DEBUG(" Failed to verify manual conversion\n" );
+			return (ret);
+		}
+
+	} while((data & DA9052_TSICONTB_TSIMAN) &&
+				(time_out < MANUAL_CONVERSION_TIME_OUT_CNT));
+
+	/* Release ADC multiplexer lock */
+	mutex_unlock(&da9052_adc_manconv_lock);
+
+	if (time_out == MANUAL_CONVERSION_TIME_OUT_CNT) {
+		/* Polling timed out */
+		da9052_tsi_config_power_supply(DISABLE);
+		return (-FAILURE);
+	}
+
+	ts->tsi_conf.man_cont.tsi_cont_b.tsi_man = RESET;
+
+	switch(ts->tsi_conf.state) {
+	case TSI_MANUAL_COORD_X:
+		da9052_tsi_read_manual_data(&tsi_data->x, X_COORDINATE);
+		break;
+	case TSI_MANUAL_COORD_Y:
+		da9052_tsi_read_manual_data(&tsi_data->y, Y_COORDINATE);
+		break;
+	case TSI_MANUAL_COORD_Z:
+		/* Note: Manual conversion result for z-coordinate */
+		/* is stored in either X or Y result register by DA9052*/
+		/* DA9052 TSI driver uses X result register to read */
+		/* manual conversion result for z coordinate */
+		da9052_tsi_read_manual_data(&tsi_data->z, X_COORDINATE);
+		break;
+	case TSI_MANUAL_SET:
+		da9052_tsi_read_manual_data(&tsi_data->x, X_COORDINATE);
+		da9052_tsi_read_manual_data(&tsi_data->y, Y_COORDINATE);
+		da9052_tsi_read_manual_data(&tsi_data->z, Z_COORDINATE);
+		break;
+	default:
+		da9052_tsi_config_power_supply(DISABLE);
+		return (-FAILURE);
+	}
+
+	/* conversion over, switch off TSI power supply */
+	da9052_tsi_config_power_supply(DISABLE);
+
+	return(SUCCESS);
+}
+
+/**
+ * da9052_tsi_get_drv_state: 
+ * Description: This function returns the state of TSI driver.
+ *
+ * @param  void
+ * @return TSI_STATE   	Returns the state of DA9052 TSI driver.
+ */
+enum TSI_STATE da9052_tsi_get_drv_state(void)
+{
+	da9052_tsi_info *ts = get_tsi_drvdata();
+	return (ts->tsi_conf.state);
+}
+
+/*--------------------------------------------------------------------------*/
+/* Local Functions                                                          */
+/*--------------------------------------------------------------------------*/
+/**
+ * get_tsi_drvdata: 
+ * Description:	The TSI Driver has a common structure called da9052_tsi_info
+ *		which will be used across the driver code. 
+ *		This function returns the address of the 
+ *		da9052_tsi_info global object.
+ *
+ * @param  void
+ * @return da9052_tsi_info *	Returns the global object address of  
+ *				da9052_tsi_info 
+ */
+static da9052_tsi_info *get_tsi_drvdata(void)
+{
+	return &gda9052_tsi_info;
+}
+
+/**
+ * write_da9052_reg: 
+ * Description : This is a wrapper function to da9052_ssc_write to TSI driver
+ *		 This function takes the da9052 register address and the data
+ *		 to be written and populates the input details into
+ *		 ssc_msg local sturcture and calls the da9052_ssc_write 
+ *
+ * @param  reg_addr 	DA9052 Register address to be written
+ * @param  data 	Data to be written
+ * @return ssize_t   	Returns Success or Failure
+ */
+static ssize_t write_da9052_reg(u8 reg_addr, u8 data)
+{
+	ssize_t ret=0;
+	da9052_ssc_msg ssc_msg;
+	
+	/* Populate the SSC message structure */
+	/* range checks on this data shall be performed by SSC */
+	ssc_msg.addr =  reg_addr;
+	ssc_msg.data =  data;
+	ret = da9052_ssc_write(&ssc_msg);
+	if(ret) {
+		DA9052_DEBUG("%s: ",__FUNCTION__);
+		DA9052_DEBUG("da9052_ssc_write Failed %d\n",ret );
+	}
+
+	return ret;
+}
+
+/**
+ * read_da9052_reg: 
+ * Description : This is a wrapper function to da9052_ssc_read to TSI driver
+ *		 This function takes the da9052 register address to be read
+ *		 and populates the input details into ssc_msg local sturcture
+ *		 and calls the da9052_ssc_read
+ *
+ * @param  reg_addr 	DA9052 Register Address 
+ * @return ssize_t   	On successful read, this function returns the register 
+ *			value read, otherwise it returns failure.
+ */
+static ssize_t read_da9052_reg(u8 reg_addr)
+{
+	 ssize_t ret = 0;
+	 da9052_ssc_msg ssc_msg;
+	
+	/* Populate the SSC message structure */
+	/* range checks on this data shall be performed by SSC */
+	ssc_msg.addr =  reg_addr;
+	ssc_msg.data =  0;
+	ret = da9052_ssc_read(&ssc_msg);
+	if(ret)
+	{
+		DA9052_DEBUG("%s: ",__FUNCTION__);
+		DA9052_DEBUG("da9052_ssc_read Failed => %d\n" ,ret);
+		return (-ret);
+	}
+	return ssc_msg.data;
+}
+
+/**
+ * da9052_tsi_reg_pendwn_event: 
+ * Description:	The pendown handler function will be registered
+ *		with EH Module
+ *
+ * @param  void			None
+ * @return void
+ */
+static void da9052_tsi_reg_pendwn_event(void)
+{
+	ssize_t ret = 0;
+	da9052_tsi_info  *ts = get_tsi_drvdata();
+	
+	/* If already registered with EH then return. Duplication is avoided */
+	if(ts->pd_reg_status)
+	{
+		DA9052_DEBUG("%s: Pen down ",__FUNCTION__);
+		DA9052_DEBUG("Registeration is already done \n");
+		return;
+	}
+
+	/* Set the EH data structure to notify for Pen down event*/
+	ts->pd_nb.eve_type = PEN_DOWN_EVE;
+	ts->pd_nb.call_back = da9052_tsi_pen_down_handler;
+	
+	/* Register to the EH for the requested event */
+	ret = da9052_eh_register_nb(&ts->pd_nb);
+	
+	if(ret)
+	{
+		DA9052_DEBUG("%s: EH Registeration",__FUNCTION__);
+		DA9052_DEBUG(" Failed: ret = %d\n",ret );
+		ts->pd_reg_status = RESET;
+	
+	}else{
+		/* Update the eh registeration state */
+		ts->pd_reg_status = SET;
+	}
+
+	return;
+}
+
+/**
+ * da9052_tsi_create_input_dev:
+ * Description:This function performs initialization of 
+ *	       TSI driver dtata structures allocates requisite
+ *
+ * @param  ip_dev 	pointer to array of input devices.
+ * @param  n	 	number of input devices.
+ * @return ssize_t   	Returns Success or Failure
+ */
+static ssize_t __init da9052_tsi_create_input_dev(struct input_dev** ip_dev, 
+									u8 n)
+{
+	u8 i;
+	s32 ret;
+	struct input_dev *dev = NULL;
+
+	/* Input device ip_dev will be initialized here only */ 
+	/* So the pointer will be NULL. Null pointer check is not done */	
+	if (!n)
+		return (-EINVAL);
+
+	for (i = 0; i < n; i++) {
+		dev = input_allocate_device();		
+		if (!dev) {
+			DA9052_DEBUG(KERN_ERR "%s:%s():memory allocation for \
+					inputdevice failed\n", __FILE__, 
+								__FUNCTION__);
+			return (-ENOMEM);
+		}
+
+		ip_dev[i] = dev;
+		switch(i) {
+		case TSI_INPUT_DEVICE_OFF:	
+			dev->name = DA9052_TSI_INPUT_DEV;
+			dev->phys = "input(tsi)";
+			break;
+		default:
+			break;
+		}
+	}
+        dev->id.vendor = DA9052_VENDOR_ID;
+        dev->id.product = DA9052_PRODUCT_ID;
+        dev->id.bustype = BUS_RS232;
+        dev->id.version = TSI_VERSION;
+	dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
+	dev->evbit[0] = (BIT_MASK(EV_SYN) | 
+					BIT_MASK(EV_KEY) | 
+						BIT_MASK(EV_ABS));
+
+	input_set_abs_params(dev, ABS_X, 0, 0x3FF, 0, 0);
+        input_set_abs_params(dev, ABS_Y, 0, 0x3FF, 0, 0);
+	input_set_abs_params(dev, ABS_PRESSURE, 0, 0x3FF, 0, 0);
+
+        /* register with input device sub-system of kernel */
+        ret = input_register_device(dev);
+        if(ret) {
+                DA9052_DEBUG(KERN_ERR "%s: Could ", __FUNCTION__);
+		DA9052_DEBUG("not register input device(touchscreen)!\n");
+                ret = -EIO;
+                goto fail;
+        }
+	return (SUCCESS);
+
+fail:
+	/*Removes allocted input devices incase of any failure*/
+	for(;i--!=0;)	
+		input_free_device(ip_dev[i]);
+	return(-FAILURE);	
+}
+
+/**
+ * da9052_tsi_init_drv:
+ * Description:This function performs initialization of 
+ *	       TSI driver dtata structures allocates requisite
+ *	       memory, and commits the TSI configuration to 
+ *	       H/W control registers.
+ * @param  void 	None
+ * @return ssize_t   	Returns Success or Failure
+ */
+static ssize_t __init da9052_tsi_init_drv(void)
+{
+	u8 cnt = 0;
+	ssize_t ret = 0;
+	da9052_tsi_info  *ts = get_tsi_drvdata();
+
+	if ((DA9052_GPIO_PIN_3 != DA9052_GPIO_CONFIG_TSI) ||
+		(DA9052_GPIO_PIN_4 != DA9052_GPIO_CONFIG_TSI) ||
+		(DA9052_GPIO_PIN_5 != DA9052_GPIO_CONFIG_TSI) ||
+		(DA9052_GPIO_PIN_6 != DA9052_GPIO_CONFIG_TSI) ||
+		(DA9052_GPIO_PIN_7 != DA9052_GPIO_CONFIG_TSI)) {
+		printk(KERN_ERR"DA9052_TSI: Configure DA9052 GPIO ");
+		printk(KERN_ERR"pins for TSI\n");
+		return (-FAILURE);
+	}
+
+	/* Initialize GPIO pins for TSI functionality */
+	ret = da9052_tsi_config_gpio();
+
+	/* Initialize TSI state to idle */
+	ret = da9052_tsi_config_state(TSI_IDLE);
+	ts->tsi_conf.state = TSI_IDLE;
+
+	/* configure TSI measurement sequence */
+	da9052_tsi_config_measure_seq(TSI_MODE_VALUE);
+
+	/* Initialize default skip slots */
+	da9052_tsi_config_skip_slots(TSI_SLOT_SKIP_VALUE);
+
+	/* Initialize default delay value */
+	da9052_tsi_config_delay(TSI_DELAY_VALUE);
+
+	/* sets the Sampling intervel ADC module */
+	da9052_tsi_set_sampling_mode(DEFAULT_TSI_SAMPLING_MODE);
+
+	/* Initialize pointer to TSI calibration configuration */
+	ts->tsi_calib = get_calib_config();
+
+	/* Allocate & initialize kernel Input device */
+	ret = da9052_tsi_create_input_dev(ts->input_devs, NUM_INPUT_DEVS);
+	if(ret) {
+		DA9052_DEBUG("DA9052_TSI: %s: ", __FUNCTION__);
+		DA9052_DEBUG("da9052_tsi_create_input_dev Failed \n" );
+		return (ret);
+	}
+
+	/* Initialize data FIFO pointers & locks */
+	da9052_init_tsi_fifos();
+
+	/* Initialize REG processing thread */
+	init_completion(&tsi_reg_proc_thread.notifier);
+	tsi_reg_proc_thread.state = ACTIVE;
+	tsi_reg_proc_thread.pid = kernel_thread(da9052_tsi_reg_proc_thread,
+						NULL, 
+						CLONE_KERNEL | SIGCHLD);
+
+	/* Initialize RAW processing thread */
+	init_completion(&tsi_raw_proc_thread.notifier);
+	tsi_raw_proc_thread.state = ACTIVE;
+	tsi_raw_proc_thread.pid = kernel_thread(da9052_tsi_raw_proc_thread, 
+						NULL, 
+						CLONE_KERNEL | SIGCHLD);
+
+	/* Set default state for TSI module */
+	ret = da9052_tsi_config_state(DEFAULT_TSI_STATE);
+	if (ret) {
+		/* Failed to initialize TSI state */
+		/* Remove input device allocation */
+		for(cnt = 0; cnt < NUM_INPUT_DEVS; cnt++ ) {
+
+			/* Allocated input devices are free at */
+			/* initialization failure */
+			if( ts->input_devs[cnt] != NULL )
+				input_free_device(ts->input_devs[cnt]);
+		}
+	}
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_tsi_get_input_dev: 
+ * Description:	This function returns pointer to input device.
+ *
+ * @param  off	offset of input device in array. 		
+ * @return u32	Pointer to input device structure.
+ */
+u32 da9052_tsi_get_input_dev(u8 off)
+{
+	da9052_tsi_info   *ts = get_tsi_drvdata();
+
+	if(off > NUM_INPUT_DEVS-1)
+		return (-EINVAL);
+
+	return ((u32)ts->input_devs[off]);
+}
+
+/**
+ * da9052_tsi_config_pen_detect: 
+ * Description: This functions enables or disables pen detect mechanism of 
+ *		TSI.
+ *
+ * @param  flag		pen detect ENABLE / DISABLE setting.
+ * @return ssize_t   	Returns Success or Failure
+ */
+static ssize_t da9052_tsi_config_pen_detect(u8 flag)
+{
+	u8 data;
+	u32 ret;
+	da9052_tsi_info  *ts = get_tsi_drvdata();
+
+	/* read TSI control A register */
+	ret = read_da9052_reg(DA9052_TSICONTA_REG);
+	if(ret < 0) {
+		DA9052_DEBUG("%s:", __FUNCTION__);
+		DA9052_DEBUG(" read_da9052_reg	Failed\n" );
+		return (ret);
+	}
+
+	/* update as per flag */
+	if(flag == ENABLE)
+		data = set_bits((u8)ret,DA9052_TSICONTA_PENDETEN);
+	else if(flag == DISABLE)
+		data = clear_bits((u8)ret,DA9052_TSICONTA_PENDETEN);
+	else {
+		DA9052_DEBUG("%s:", __FUNCTION__);
+		DA9052_DEBUG(" Invalid flag passed \n" );
+		return (-EINVAL);
+	}
+
+	/* send to SSC */
+	write_da9052_reg(DA9052_TSICONTA_REG, data);
+
+	/* update s/w structure */
+	ts->tsi_conf.auto_cont.da9052_tsi_cont_a = data;
+	return (SUCCESS);
+}
+
+/**
+ * da9052_tsi_disable_irq: 
+ * Description: Function to disable the given PEN DWN or TSI_READY 
+ *		IRQ pins
+ *
+ * @enum tsi_irq     Type of IRQ to be masked is given as input 
+ * @return ssize_t   Returns Success or Failure
+ */
+ static ssize_t da9052_tsi_disable_irq(enum TSI_IRQ tsi_irq)
+ {
+	u8 data =0;
+	ssize_t ret =0;
+	da9052_tsi_info  *ts = get_tsi_drvdata();
+
+	ret = read_da9052_reg(DA9052_IRQMASKB_REG);
+	if(ret < 0)
+	{
+		DA9052_DEBUG("DA9052_TSI:da9052_tsi_disable_irq:");
+		DA9052_DEBUG("read_da9052_reg Failed \n" );
+		return (ret);			
+	}
+	/*Get the latest IRQ configuration*/
+	data = ret;
+	switch(tsi_irq)
+	{
+		case TSI_PEN_DWN:
+			data = mask_pendwn_irq(data);
+		break;
+		case TSI_DATA_RDY:
+			data = mask_tsi_rdy_irq(data);
+		break;
+		default:
+			DA9052_DEBUG("DA9052_TSI:da9052_tsi_disable_irq:");
+			DA9052_DEBUG("Invalid IRQ passed \n" );
+			return (-EINVAL);			
+	}
+	ret = write_da9052_reg(DA9052_IRQMASKB_REG, data);
+	if(ret)
+	{
+		DA9052_DEBUG("DA9052_TSI:da9052_tsi_disable_irq:");
+		DA9052_DEBUG("write_da9052_reg Failed \n" );
+		return (ret);			
+	}
+
+	/* if SSC write doesn't fail, then update s/w structure */
+	switch(tsi_irq)
+	{
+		case TSI_PEN_DWN:
+			ts->tsi_conf.tsi_pendown_irq_mask = SET;
+		break;
+		case TSI_DATA_RDY:
+			ts->tsi_conf.tsi_ready_irq_mask = SET;
+		break;
+	}
+
+	return (SUCCESS); 
+ }
+
+/**
+ * da9052_tsi_enable_irq: 
+ * Description: Function to enable the PEN DWN and TSI_READY 
+ *		IRQ pins
+ *
+ * @enum tsi_irq     Type of IRQ to be enabled is given as input 
+ * @return ssize_t   Returns Success or Failure
+ */
+ static ssize_t da9052_tsi_enable_irq(enum TSI_IRQ tsi_irq)
+ {
+	u8 data =0;
+	ssize_t ret =0;
+	da9052_tsi_info  *ts = get_tsi_drvdata();
+
+	ret = read_da9052_reg(DA9052_IRQMASKB_REG);
+	if(ret < 0)
+	{
+		DA9052_DEBUG("DA9052_TSI:da9052_tsi_enable_irq:");
+		DA9052_DEBUG("read_da9052_reg Failed \n" );
+		return (ret);			
+	}
+	/*Get the latest IRQ configuration*/
+	data = ret;
+	switch(tsi_irq)
+	{
+		case TSI_PEN_DWN:
+			data = unmask_pendwn_irq(data);
+		break;
+		case TSI_DATA_RDY:
+			data = unmask_tsi_rdy_irq(data);
+		break;	
+		default:
+			DA9052_DEBUG("DA9052_TSI:da9052_tsi_enable_irq:");
+			DA9052_DEBUG("Invalid IRQ passed \n" );
+			return (-EINVAL);			
+	}
+	ret = write_da9052_reg(DA9052_IRQMASKB_REG, data);
+	if(ret) {
+		DA9052_DEBUG("DA9052_TSI:da9052_tsi_enable_irq:");
+		DA9052_DEBUG("write_da9052_reg Failed \n" );
+		return (ret);			
+	}	
+
+	switch(tsi_irq)
+	{
+		case TSI_PEN_DWN:
+			ts->tsi_conf.tsi_pendown_irq_mask = RESET;
+		break;
+		case TSI_DATA_RDY:
+			ts->tsi_conf.tsi_ready_irq_mask = RESET;
+		break;
+	}
+
+	return (SUCCESS); 
+ }
+
+/**
+ * da9052_tsi_config_gpio:
+ * Description: This functions configures DA9052 GPIO pins for TSI 
+ *		functionality.
+ *
+ * @param  void
+ * @return ssize_t   Returns Success or Failure
+ */
+static ssize_t da9052_tsi_config_gpio(void)
+{
+	u8 idx = 0;
+	ssize_t ret = 0;
+	da9052_ssc_msg ssc_msg[NUM_GPIO_TSI_REGISTERS];
+
+	/* Read GPIO pins */
+	ssc_msg[idx++].addr  = DA9052_GPIO0203_REG;
+	ssc_msg[idx++].addr  = DA9052_GPIO0405_REG;
+	ssc_msg[idx++].addr  = DA9052_GPIO0607_REG;
+
+	/* Perform a hardware read */
+	ret = da9052_ssc_read_many(ssc_msg,idx);
+	if(ret) {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG("da9052_ssc_read_many Failed\n" );
+		return (ret);
+	}
+
+	/* Set the Pin functionality to TSI */
+	idx = 0;
+	ssc_msg[idx].data = clear_bits(ssc_msg[idx].data, 
+						DA9052_GPIO0203_GPIO3PIN);
+	idx++;
+	ssc_msg[idx].data = clear_bits(ssc_msg[idx].data,
+		(DA9052_GPIO0405_GPIO4PIN | DA9052_GPIO0405_GPIO5PIN));
+	idx++;
+	ssc_msg[idx].data = clear_bits(ssc_msg[idx].data,
+		(DA9052_GPIO0607_GPIO6PIN | DA9052_GPIO0607_GPIO7PIN));
+	idx++;
+
+	/* Perform a hardware write */
+	ret = da9052_ssc_write_many(ssc_msg,idx);
+	if(ret) {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG("da9052_ssc_read_many Failed\n" );
+		return (ret);
+	}
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_tsi_config_power_supply: 
+ * Description: This functions enables or disables power supply of DA9052 
+ *		TSI.
+ *
+ * @param  state	power supply ENABLE / DISABLE setting.
+ * @return ssize_t   	Returns Success or Failure
+ */
+static ssize_t da9052_tsi_config_power_supply(u8 state)
+{
+	da9052_ldo_config ldo_config;
+	da9052_tsi_info *ts = get_tsi_drvdata();
+
+	if (state != ENABLE && state != DISABLE) {
+		DA9052_DEBUG("DA9052_TSI: %s: ", __FUNCTION__);
+		DA9052_DEBUG("Invalid state Passed\n" );
+		return (-EINVAL);
+	}
+
+	/* LDO configuration */
+	ldo_config.ldo_volt = DA9052_TSI_SUPPLY_VOLTAGE;
+	ldo_config.ldo_num = DA9052_TSI_REF_SOURCE;
+	ldo_config.ldo_conf = RESET;
+
+	/* configure TSI's LDO */
+	if (da9052_pm_configure_ldo(ldo_config))
+		return (-FAILURE);
+
+	/* Enable or disable TSI supply */
+	if (da9052_pm_set_ldo(DA9052_TSI_REF_SOURCE, state))
+		return (-FAILURE);
+
+	if (state == ENABLE)
+		ts->tsi_conf.ldo9_en = SET;
+	else
+		ts->tsi_conf.ldo9_en = RESET;
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_tsi_config_manual_coord: 
+ * Description: This function configures TSI control registers to measure 
+ *		along desired coordinate axis.
+ *
+ * @enum  coord		coordinate axis along which manual coordinate is to 
+ *			be measured.
+ * @return ssize_t   	Returns Success or Failure
+ */
+static ssize_t da9052_tsi_config_manual_coord(enum TSI_COORDINATE coord)
+{
+	u8 data;
+	s32 ret;
+	da9052_tsi_info *ts = get_tsi_drvdata();
+
+	switch(coord) {
+	case X_COORDINATE:
+		/*TSI Reference is selected*/
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_adc_ref = SET;
+		/*Configure TSI_MUX to X+*/
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_mux = TSI_MUX_XPLUS;
+		/*Configure TSI SEL to Y+ and Y- Closed*/
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_sel_0 = RESET;
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_sel_1 = RESET;
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_sel_2 = SET;
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_sel_3 = SET;
+
+		data = ts->tsi_conf.man_cont.da9052_tsi_cont_b;
+		break;
+
+	case Y_COORDINATE:
+		/*TSI Reference is selected*/
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_adc_ref = SET;
+		/*Configure TSI_MUX to Y+*/
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_mux = TSI_MUX_YPLUS;
+		/*Configure TSI SEL to X+ and X- Closed*/
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_sel_0 = SET;
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_sel_1 = SET;
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_sel_2 = RESET;
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_sel_3 = RESET;
+
+		data = ts->tsi_conf.man_cont.da9052_tsi_cont_b;	
+		break;
+
+	case Z_COORDINATE:
+		/*TSI Reference is selected*/
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_adc_ref = SET;
+		/*Configure TSI_MUX to Y+*/
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_mux = TSI_MUX_XPLUS;
+		/*Configure TSI SEL to X+ and X- Closed*/
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_sel_0 = RESET;
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_sel_1 = SET;
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_sel_2 = SET;
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_sel_3 = RESET;
+
+		data = ts->tsi_conf.man_cont.da9052_tsi_cont_b;
+		break;
+
+		default:
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG("Invalid coordinate passed \n" );
+		return (-EINVAL);
+	}
+
+	/* write to hardware */
+	ret = write_da9052_reg(DA9052_TSICONTB_REG, data);
+	if(ret)
+	{
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG("write_da9052_reg Failed \n" );
+			return (ret);
+	}
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_tsi_config_auto_mode: 
+ * Description: Auto TSI enable or diabling is done by this function
+ *		
+ * @param state   	TSI auto mode Enable or Disable setting.
+ * @return ssize_t      Returns Success or Failure
+ */
+static ssize_t da9052_tsi_config_auto_mode(u8 state)
+{
+	u8 data;
+	s32 ret = 0;
+	da9052_tsi_info *ts = get_tsi_drvdata();
+
+	if (state != ENABLE && state != DISABLE)
+		return (-EINVAL);
+
+	/*Get the latest value from the device*/
+	/* Read manual mode control A register */
+	ret = read_da9052_reg(DA9052_TSICONTA_REG);
+	if(ret < 0) {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG("read_da9052_reg Failed \n" );
+			return (ret);
+	}
+
+	/* set state */
+	data = (u8)ret;
+
+	if (state == ENABLE)
+		data = set_auto_tsi_en(data);
+	else if (state == DISABLE)
+		data = reset_auto_tsi_en(data);
+	else {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG("Invalid Parameter Passed \n" );
+		return (-EINVAL);
+	}
+
+	/*Write value to register*/
+	ret = write_da9052_reg(DA9052_TSICONTA_REG, data);
+	if(ret) {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG(" Failed to configure Auto TSI mode\n" );
+		return (ret);
+	}
+
+	ts->tsi_conf.auto_cont.da9052_tsi_cont_a = data;
+	return(SUCCESS);
+}
+
+/**
+ * da9052_tsi_config_manual_mode: 
+ * Description: This function is used to enable or disable manual TSI mode.
+ *		It performs following features:
+ *		1. Changes state of TSI_MAN bit to the one desired.
+ *		2. Configures TSI_MUX and TSI_SEL values 
+ *
+ * @param  state 	TSI manual mode Enable or Disable setting.
+ * @return ssize_t   	Returns Success or Failure
+ */
+static ssize_t da9052_tsi_config_manual_mode(u8 state)
+{
+	u8 data=0;
+	ssize_t ret=0;
+	da9052_tsi_info *ts = get_tsi_drvdata();
+
+	if (state != ENABLE && state != DISABLE) {
+		DA9052_DEBUG("DA9052_TSI: %s: ", __FUNCTION__);
+		DA9052_DEBUG("Invalid state Passed\n" );
+		return (-EINVAL);
+	}
+
+
+	/* Read manual mode control register */
+	ret = read_da9052_reg(DA9052_TSICONTB_REG);
+	if(ret < 0) {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG("read_da9052_reg Failed \n" );
+			return (ret);
+	}
+
+	/* set state */
+	data = (u8)ret;
+	if (state == DISABLE) {
+		data = disable_tsi_manual_mode(data);
+	} else {
+		data = enable_tsi_manual_mode(data);
+	}
+
+	/* write to hardware */
+	ret = write_da9052_reg(DA9052_TSICONTB_REG, data);
+	if(ret) {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG("write_da9052_reg Failed \n" );
+			return (ret);
+	}
+
+	/* update software data structure */
+	if (state == DISABLE) {
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_man = RESET;
+	} else {
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_man = SET;
+	}
+
+	/* make TSI as ADC channel input */
+	data = 0;
+	data = set_bits(data, ADC_TSI);
+
+	/* Write to Hardware */
+	ret = write_da9052_reg(DA9052_ADCMAN_REG, data);
+	if(ret) {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG("ADC write Failed \n" );
+		return (ret);
+	}
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_tsi_read_manual_data: 
+ * Description: The TSI X,Y co-ordinates are read by this function
+ *		based on the coordinates requested.
+ *
+ * @param tsi_data	Pointer to store the read data 
+ * @param coord		coordinate axis along which samples are to be taken.
+ * @return ssize_t   	Returns Success or Failure
+ */
+static ssize_t da9052_tsi_read_manual_data(s16* tsi_data, 
+						enum TSI_COORDINATE coord)
+{
+	u8 idx = 0;
+	u8 lsb;
+	s16 data = 0;
+	ssize_t ret = 0;
+	da9052_ssc_msg ssc_msg[NUM_TSI_RESULT_REGISTERS];
+
+	if (!tsi_data)
+		return (-EINVAL);
+
+	if (coord == X_COORDINATE) {
+		/*Read X coordinate */
+		ssc_msg[idx++].addr  = DA9052_TSIXMSB_REG;
+	}
+
+	else if (coord == Y_COORDINATE) {
+		/*Read Y coordinate */
+		ssc_msg[idx++].addr  = DA9052_TSIYMSB_REG;
+	}
+
+	else if (coord == Z_COORDINATE) {
+		/*Read Z coordinate */
+		ssc_msg[idx++].addr  = DA9052_TSIZMSB_REG;
+	}
+	
+	else {
+		DA9052_DEBUG("DA9052_TSI: %s", __FUNCTION__);
+		DA9052_DEBUG("Invalid Parameter Passed\n");
+		return (-EINVAL);
+	}
+		
+	/*Read lsb value */
+	ssc_msg[idx++].addr  = DA9052_TSILSB_REG;
+
+	ret = da9052_ssc_read_many(ssc_msg,idx);
+	if(ret) {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG("da9052_ssc_read_many Failed\n" );
+		return (ret);
+	}
+
+
+	/* Read data from ssc message */
+	lsb =  ssc_msg[--idx].data;
+
+	/*Construct 10bit value*/
+	switch (coord) {
+	case X_COORDINATE:
+		data = (ssc_msg[--idx].data << X_MSB_SHIFT);
+		data |= (lsb & X_LSB_MASK) >> X_LSB_SHIFT;
+		break;
+
+	case Y_COORDINATE:
+		data = (ssc_msg[--idx].data << Y_MSB_SHIFT);
+		data |= (lsb & Y_LSB_MASK) >> Y_LSB_SHIFT;
+		break;
+
+	case Z_COORDINATE:
+		data = (ssc_msg[--idx].data << Z_MSB_SHIFT);
+		data |= (lsb & X_LSB_MASK) >> Z_LSB_SHIFT;
+		break;
+	}
+
+	(*tsi_data) = data;
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_tsi_get_calib_data: 
+ * Description: This function reads calibration samples from user space & 
+ *		sets the calibration factors accordingly.
+ *
+ * @param calib_arr	Pointer to array of display & corresponding touchscreen 
+ *		 	point coordinates.
+ * @return ssize_t   	Returns Success or Failure
+ */
+static ssize_t da9052_tsi_get_calib_data(da9052_tsi_data* calib_arr)
+{
+	u8 num;
+	s32 ret;
+	u8 *src, *dst;
+	u8 bytes_remaining;
+	da9052_tsi_data calib_array[NUM_OF_SAMPLE_TYPES][NUM_CALIB_SAMPLES];
+
+	dst = (u8* ) &calib_array[0][0];
+	src = (u8* ) calib_arr;
+
+	/* Update calibration matrix */
+	/* This matrix holds the displacement between */
+	/* display screen  &  touch screen */
+
+	/* calculate the size of data in bytes */
+	num = sizeof(da9052_tsi_data) * NUM_OF_SAMPLE_TYPES * 
+							NUM_CALIB_SAMPLES;
+
+	do {
+		/* copy data from user space in a loop */
+		/* till required number of bytes are read */
+		bytes_remaining = copy_from_user(dst, src, num);
+
+		/* update source & destination pointers as */
+		/* per remaining data */
+		src = (u8* ) ((u32)src + (u32)(num - bytes_remaining));
+		dst = (u8* ) ((u32)dst + (u32)(num - bytes_remaining));
+
+		num = bytes_remaining;
+	} while (bytes_remaining);
+
+	/* call to initialize calibration factors */
+	ret = da9052_tsi_set_calib_matrix(calib_array[DISPLAY_DATA_OFFSET],
+						calib_array[TS_DATA_OFFSET]);
+	return (ret);
+}
+
+/** da9052_tsi_get_reg_data: 
+ * Description:	This function reads touchscreen coordinate values from EH FIFO. 
+ *	       	EH API expects a linear buffer to write data in to.
+ *		So this function takes care to request samples only 
+ *		in linear segments of REG data FIFO.
+ *
+ * @param  void		N.A.
+ * @return u32		Number of bytes copied from event handler.
+ */
+static u32 da9052_tsi_get_reg_data(void)
+{
+	u32 free_cnt, copy_cnt, cnt;
+
+	/* Lock Reg data FIFO */
+	if(down_interruptible(&tsi_reg_fifo.lock)) {
+		return (SUCCESS);
+	}
+
+	/* Call EH function to copy data from h/w */
+	/* It returns the number of bytes copied */
+	/* Note: This function assumes a linear buffer */
+
+	copy_cnt = 0;
+
+	/* Has data in REG FIFO wrapped around the last index of array */
+	if ((tsi_reg_fifo.head - tsi_reg_fifo.tail) > 1) {
+
+		/* Data has wrapped around circular FIFO, */
+		/* we have a linear free buffer space  */
+		
+		/* Get free space available in REG FIFO */
+		free_cnt = get_reg_free_space_cnt();
+		if (free_cnt > TSI_POLL_SAMPLE_CNT)
+			free_cnt = TSI_POLL_SAMPLE_CNT;
+
+		/* copy data from EH */
+		cnt = da9052_tsi_get_data( 
+					&tsi_reg_fifo.data[tsi_reg_fifo.tail], 
+					free_cnt 
+					);
+		if (cnt > free_cnt) {
+			DA9052_DEBUG("EH copied more data");
+			return(-FAILURE);
+		}
+		
+		copy_cnt = cnt;
+
+		/* Update REG FIFO tail index as per copied data */
+		while(cnt--)
+			incr_with_wrap_reg_fifo(tsi_reg_fifo.tail);
+
+	} else if ((tsi_reg_fifo.head - tsi_reg_fifo.tail) <= 0) {
+
+		/* we have free space in 2 linear buffers. */
+		
+		/* Get free space available in first linear segment */
+		free_cnt = (TSI_REG_DATA_BUF_SIZE - tsi_reg_fifo.tail);
+		
+		if (free_cnt > TSI_POLL_SAMPLE_CNT) {
+			/* We have enough free space in first segment */
+			free_cnt = TSI_POLL_SAMPLE_CNT;
+
+			/* copy data from EH */
+			cnt = da9052_tsi_get_data(
+					&tsi_reg_fifo.data[tsi_reg_fifo.tail], 
+					free_cnt 
+					);
+			if (cnt > free_cnt) {
+				DA9052_DEBUG("EH copied more data");
+				return(-FAILURE);
+			}
+			copy_cnt = cnt;
+
+			/* Update REG FIFO tail index as per copied data */
+			while(cnt--)
+				incr_with_wrap_reg_fifo(tsi_reg_fifo.tail);
+		} else {
+		
+			/* we have free space in 2 linear buffers. */
+	
+			if (free_cnt) {
+				/* We have free space in first segment */
+				/* copy data from EH */
+				cnt = da9052_tsi_get_data(
+						&tsi_reg_fifo.data[
+							tsi_reg_fifo.tail], 
+						free_cnt 
+						);
+				if (cnt > free_cnt) {
+					DA9052_DEBUG("EH copied more data");
+					return(-FAILURE);
+				}
+				copy_cnt = cnt;
+	
+				/* Update REG FIFO tail index */
+				/* as per copied data */
+				while(cnt--)
+					incr_with_wrap_reg_fifo(
+							tsi_reg_fifo.tail);
+			}
+			
+			/* Get free space available in second linear segment */
+			free_cnt = tsi_reg_fifo.head;
+			
+			if (free_cnt > TSI_POLL_SAMPLE_CNT - copy_cnt) {
+				/* Available space is more than what we need */
+				free_cnt = TSI_POLL_SAMPLE_CNT - copy_cnt;
+			}
+
+			if (free_cnt) {
+				/* We have free space in second segment */
+				/* copy data from EH */
+				cnt = da9052_tsi_get_data( 
+						&tsi_reg_fifo.data[
+							tsi_reg_fifo.tail], 
+						free_cnt 
+						);
+				if (cnt > free_cnt) {
+					DA9052_DEBUG("EH copied more data");
+					return(-FAILURE);
+				}
+
+				copy_cnt += cnt;
+
+				/* Update REG FIFO tail index as */
+				/* per copied data */
+				while(cnt--)
+					incr_with_wrap_reg_fifo(
+							tsi_reg_fifo.tail);
+			}
+		}
+
+	} else {
+		/* REG FIFO is full, new data was not requested */
+		copy_cnt = 0;
+	}
+
+	/* Release REG FIFO */
+	up(&tsi_reg_fifo.lock);
+
+	/* Return num of samples copied from EH. */
+	return (copy_cnt);
+}
+
+/** da9052_tsi_reg_proc_thread: 
+ * Description:	This function is executed as a thread. It polls EH 
+ *		periodically & copies TSI data for processing. 
+ *		While it's state is active it performs following operations:
+ *		1. sleeps for TSI_REG_DATA_READ_INTERVAL msecs.
+ *		2. copies data from EH.
+ *		3. processes this data and.
+ *		4. checks if Pen-Up has occured.
+ *
+ * @param  ptr		Not Used. Provided for compatibility with 
+ *			prototype of thread.
+ * @return ssize_t	Returns Success or Failure
+ */
+static ssize_t da9052_tsi_reg_proc_thread (void *ptr)
+{
+	u32 data_cnt;
+	da9052_tsi_info *ts;
+
+	set_freezable();
+
+	while(tsi_reg_proc_thread.state == ACTIVE) {
+
+		/* make our thread friendly to system suspend */
+		try_to_freeze();
+
+		/* set how we want to sleep & go for it */
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(msecs_to_jiffies(tsi_reg_data_poll_interval));
+
+		ts = get_tsi_drvdata();
+
+		if(!ts->pen_dwn_event) {
+			/* Data without pen down is invalid */
+			continue;
+		}
+
+		/* In every timer elapse if pen down has already happened */
+		/*  then poll EH for TSI data */
+		data_cnt = da9052_tsi_get_reg_data();
+		
+		/* process the data read from EH 
+		 * Note: This function should be called even if data read 
+		 * from EH is zero so that any residual data 
+		 * in the FIFO gets processed 
+		 */
+		da9052_tsi_process_reg_data();
+
+		if (data_cnt) {
+			/*Reset the penup timer count*/
+			ts->tsi_zero_data_cnt = 0;
+		} else {
+			/* zero samples were read from EH, */
+			/* increment the zero data counter */
+			if ((++(ts->tsi_zero_data_cnt)) > 
+						     ts->tsi_penup_count) {
+				/* waited enough for any data from EH */
+				/* declare pen up */
+				ts->pen_dwn_event = RESET;
+				da9052_tsi_penup_event();
+			}
+		}
+	}
+
+	/* Indicate termination of this thread */
+	complete_and_exit(&tsi_reg_proc_thread.notifier, 0);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_tsi_penup_event: 
+ * Description:This function is called when PEN_UP is detected.
+ * 	       it puts TSI to idle mode and disables power 
+ *	       supplied to it.
+ *	       This function informs to eh to stop the 
+ *	       TSI data reading.
+ *
+ * @param  void
+ * @return ssize_t   	Returns Success or Failure
+ */
+void da9052_tsi_penup_event(void)
+{
+
+	da9052_tsi_info *ts = get_tsi_drvdata();
+
+	/* Disable auto TSI measurement mode */
+	/* Enable TSI auto measurement mode */
+	if (da9052_tsi_config_auto_mode(DISABLE))
+		goto exit;
+
+	ts->tsi_conf.auto_cont.tsi_cont_a.auto_tsi_en = RESET;
+
+
+	/* disable touchscreen's power supply */
+	if (da9052_tsi_config_power_supply(ENABLE))
+		goto exit;
+
+	ts->tsi_conf.ldo9_en = RESET;
+
+
+	/* enable TSI_PEN_DWN interrupt notification */
+	if (da9052_tsi_enable_irq(TSI_PEN_DWN))
+		goto exit;
+
+	ts->tsi_conf.tsi_pendown_irq_mask = RESET;
+
+
+	/*Call EH function to terminate the data reading*/
+	da9052_tsi_stop_sampling();
+
+	/* Reset zero data counter & flags */
+	ts->tsi_zero_data_cnt = 0;
+	early_data_flag = TRUE;
+	debounce_over = FALSE;
+	win_reference_valid = FALSE;
+
+exit:
+	/* Clean REG & RAW FIFOs */ 
+	clean_tsi_fifos();
+	return;
+}
+
+/**
+ * da9052_tsi_pen_down_handler
+ * Description:	This function is called when pen touches the touchscreen very 
+ * 	       	first time after driver's PEN_UP status.
+ *		There are no return error statements, since it'll be 
+ *		called from EH. So status can't be returned.
+ *
+ * @param  u32 event 	DA9052 Event B Register value
+ * @return None
+ *
+ * This function is called if
+ * 	- Pen_Down event has occured
+ *	- But TS_READY event has not yet occured
+ */
+void da9052_tsi_pen_down_handler(u32 event)
+{
+	ssize_t ret =0;
+	da9052_tsi_info *ts = get_tsi_drvdata();
+
+	/* Get the input device handler to report Pen down to */
+	/* input infrastructure */ 
+	struct input_dev* ip_dev = 
+		(struct input_dev*)da9052_tsi_get_input_dev(
+						(u8)TSI_INPUT_DEVICE_OFF);
+
+	DA9052_DEBUG("EH notified the pendown event 0x%x\n", event);
+
+	/* If TSI state is not Auto mode */
+	/* then return with error */
+	if (ts->tsi_conf.state != TSI_AUTO_MODE) {
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG(" Configure TSI to auto mode.\n" );
+		DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+		DA9052_DEBUG(" Then call this API.\n" );
+		goto fail;
+	}
+
+	/* enable touchscreen's power supply */
+	if (da9052_tsi_config_power_supply(ENABLE))
+		goto fail;
+
+
+	/* disable PEN_DOWN interrupt notification */
+	if (da9052_tsi_disable_irq(TSI_PEN_DWN))
+		goto fail;
+
+
+	/* enable TSI_RDY interrupt notification */
+	if (da9052_tsi_enable_irq(TSI_DATA_RDY))
+		goto fail;
+
+
+	/* Enable TSI auto measurement mode */
+	if (da9052_tsi_config_auto_mode(ENABLE))
+		goto fail;
+	ts->tsi_conf.auto_cont.tsi_cont_a.auto_tsi_en = SET;
+
+
+	/* Report Pen down to OS */
+	input_report_abs(ip_dev, BTN_TOUCH, 1);
+	input_sync(ip_dev);		
+		
+	/* update s/w data structure after reporting to OS */
+	ts->tsi_rdy_event = (DA9052_EVENTB_ETSIREADY & (event>>8));
+	ts->pen_dwn_event = (DA9052_EVENTB_EPENDOWN & (event>>8));
+
+	/*Add EH function to start sampling*/
+	da9052_tsi_start_sampling();
+	
+	goto success;
+
+
+fail:
+	/* Error occured, */
+	/* workaround to get next pen down interrupt from EH */
+	if (ts->pd_reg_status) {
+		/* Unregister from EH */
+		da9052_eh_unregister_nb(&ts->pd_nb);
+		ts->pd_reg_status = RESET;
+
+		/* register with EH */
+		da9052_tsi_reg_pendwn_event();
+	}
+
+success:
+	/* Dummy statement for label */
+	ret = SUCCESS;
+}
+
+/**
+ * da9052_tsi_open: 
+ * Description:	This function is called when opening DA9052 TSI device.
+ * 	       	It checks if device has already been opened. If yes, then 
+ * 		it returns with error.
+ *
+ * @param *inode pointer to device inode
+ * @param *file  file pointer
+ * @return int   Error Code, zero: no error
+ */
+static ssize_t da9052_tsi_open(struct inode *inode, struct file *file)
+{
+	/* Check if touchscreen device has already been opened */
+	if(tsi_device_open) {
+		printk(KERN_INFO"da9052: TouchScreen already opened \n");
+		return(-EBUSY);
+	} else {
+		/* Touchscreen's opened the first time. */
+		/* use tsi_device_open variable as */
+		/* a flag to denote touchscreen's */
+		/* Open / Close status */
+		tsi_device_open++;
+		return(SUCCESS);
+	}
+}
+
+/**
+ * da9052_tsi_release: 
+ *Description: This function is called when closing DA9052 TSI device.
+ *
+ * @param *inode pointer to device inode
+ * @param *file  file pointer
+ * @return int   Error Code, zero: no error
+ */
+static ssize_t da9052_tsi_release(struct inode *inode, struct file *file)
+{
+	/* Resetting tsi_device_open flag so that */
+	/* next user can  open the device  */
+	tsi_device_open--;
+	return(SUCCESS);
+}
+
+/**
+ *da9052_tsi_remove: 
+ *Description: This function is called when detatching DA9052 TSI
+ *	       device from the driver.
+ * @param void
+ * @return void
+ */
+static int __devexit da9052_tsi_remove(struct platform_device *dev)
+{
+
+	DA9052_DEBUG(KERN_DEBUG "Removing %s \n", DA9052_TSI_DEVICE_NAME);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_tsi_suspend:
+ *Description:	Power Management support function. Puts TSI to idle mode.
+ * 
+ * @param *dev   pointer to platform device
+ * @param state  pm state
+ * @return s32 status of suspend operation
+ */
+static ssize_t da9052_tsi_suspend(struct platform_device *dev, 
+							pm_message_t state)
+{
+	/* Put your suspend related operations here */
+	printk(KERN_INFO "%s: called\n", __FUNCTION__);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_tsi_resume: 
+ *Description:	Power Management support function. Brings TSI to default state.
+ * 
+ * @param *dev   pointer to platform device
+ * @return s32 status of resume operation
+ */
+static ssize_t da9052_tsi_resume(struct platform_device *dev)
+{
+	/* Put your resume related operations here */
+	printk(KERN_INFO "%s: called\n", __FUNCTION__);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_tsi_ioctl: 
+ * Description:	It provides the user interface functionality to check the 
+ *		da9052 TSI supported functions. 
+ * @param *inode 	pointer to device inode.
+ * @param *file 	file pointer.
+ * @param cmd  		ioctl command to be executed.
+ * @param arg  		any argument to be passed.
+ * @return int   	operation status SUCCESS/FAILURE.
+ */
+static ssize_t da9052_tsi_ioctl(struct inode *inode, struct file *file,
+					unsigned int cmd, unsigned long arg)
+{
+	ssize_t ret;
+	da9052_tsi_ioctl_data usr;
+	da9052_tsi_data tsi_data;
+	enum TSI_STATE	tsi_state;
+	da9052_tsi_info *ts = get_tsi_drvdata();
+	
+	ret = SUCCESS;
+	/* Copy argument data from user space */
+	if(copy_from_user(&usr, (da9052_tsi_ioctl_data *)arg, 
+					sizeof(da9052_tsi_ioctl_data)))
+		return (-EFAULT);
+
+	switch(cmd) {
+	case DA9052_TSI_SET_SAMPLING_MODE:
+		ret = da9052_tsi_set_sampling_mode(usr.interval);
+		break;
+
+	case DA9052_TSI_CONFIG_DELAY:
+		ret = da9052_tsi_config_delay(usr.delay);
+		break;
+
+	case DA9052_TSI_CONFIG_SLOT_SKIP:
+		ret = da9052_tsi_config_skip_slots(usr.skip);
+		break;
+
+	case DA9052_TSI_MEASURE_MANUAL_DATA:
+		/*Start Manual conversion*/
+		ret = da9052_tsi_get_manual_measurement(&tsi_data);
+
+		/* copy this sample to user space */
+		if(copy_to_user(usr.tsi_data, &tsi_data, 
+						sizeof(da9052_tsi_data))) {
+			DA9052_DEBUG("DA9052_TSI: %s:", __FUNCTION__);
+			DA9052_DEBUG(" Copy to user Failed\n" );
+			return (-FAILURE);
+		}
+		break;
+
+	case DA9052_TSI_MEASURE_SEQ:
+		ret = da9052_tsi_config_measure_seq(usr.seq);
+		break;
+
+	case DA9052_TSI_SET_CALIB_MATRIX:
+		ret = da9052_tsi_get_calib_data(usr.calib_arr);
+		break;
+
+	case DA9052_TSI_GET_TSI_CONFIG:
+		if(copy_to_user(usr.tsi_conf,
+					&ts->tsi_conf,
+					sizeof(da9052_tsi_conf))) {
+			ret = -EFAULT;
+		}
+		break;
+
+	case DA9052_TSI_GET_CALIB_CONFIG:
+		ts->tsi_calib = get_calib_config();
+		if(copy_to_user(usr.calib,
+					ts->tsi_calib,
+					sizeof(calib_cfg_t))) {
+			ret = -EFAULT;
+		}
+		break;
+
+	case DA9052_TSI_SET_CALIB_CONFIG:
+		ts->tsi_calib = get_calib_config();
+		if(copy_from_user(ts->tsi_calib,
+					usr.calib,
+					sizeof(calib_cfg_t))) {
+			ret = -EFAULT;
+		}
+		break;
+
+	case DA9052_TSI_SET_DEVICE_STATE:
+		/* set TSI device state to auto or manual mode */
+		ret = da9052_tsi_config_state(usr.tsi_state);
+		break;
+
+	case DA9052_TSI_CONFIG_PEN_DET:
+		/* enable / disable PEN_DOWN_DET mechanism of DA9052 */
+		ret = da9052_tsi_config_pen_detect(usr.pen_det);
+		break;
+
+	case DA9052_TSI_REG_PENDWN_EH:
+		/*Register pendwn event with EH*/
+		da9052_tsi_reg_pendwn_event();
+		break;
+
+	case DA9052_TSI_UNREG_PENDWN_EH:
+		/* Un-register from the EH for the requested event */
+		da9052_eh_unregister_nb(&ts->pd_nb);
+		/* Modify the status to un registered */ 
+		ts->pd_reg_status = RESET;
+		break;
+
+	case DA9052_TSI_DISABLE_IRQ:
+		ret = da9052_tsi_disable_irq(usr.tsi_irq);
+		break;
+
+	case DA9052_TSI_ENABLE_IRQ:
+		ret = da9052_tsi_enable_irq(usr.tsi_irq);
+		break;
+
+	case DA9052_TSI_POWER_CONTROL:
+		/* Enable / Disable TSI power supply */
+		ret = da9052_tsi_config_power_supply(usr.pwr);
+		break;
+
+	case DA9052_TSI_SET_MANUAL_AXIS:
+		/* configure the coordinate axis for manual measurement */
+		ret = da9052_tsi_config_manual_coord(usr.axis);
+		break;
+
+	case DA9052_TSI_GET_DEVICE_STATE:
+		/* set TSI device state to auto or manual mode */
+		tsi_state = da9052_tsi_get_drv_state();
+		if(copy_to_user(usr.get_tsi_state,
+					&tsi_state,
+					sizeof(enum TSI_STATE))) {
+			ret = -EFAULT;
+		}
+		break;
+
+	case DA9052_TSI_SET_GPIO_PINS:
+		/* configure DA9052 GPIO pins for TSI */
+		ret = da9052_tsi_config_gpio();
+		break;
+
+	default:
+		/*Return faliure to IOCTL call*/
+		ret = -FAILURE;
+	}
+	return (ret);
+}
+
+/**
+ * static struct file_operations da9052_ts_fops -  
+ * This structure definition is used by kernel to map it's generic operations
+ * to device specific operations. 
+ * @owner: 	Points to the owner of this module.
+ * @open : 	function pointer to TSI's open method.
+ * @release: 	function pointer to TSI's release device method.
+ * @ioctl: 	function pointer to TSI's I/O control method.
+ */
+static const struct file_operations da9052_tsi_fops = {
+	.owner		= THIS_MODULE,
+	.open		= da9052_tsi_open,
+	.release	= da9052_tsi_release,
+	.ioctl		= da9052_tsi_ioctl
+};
+
+/**
+ * da9052_tsi_probe:
+ *Description: Called when a device gets attached to driver 
+ *
+ * @param dev	reference to platform device object
+ * @return s32  Error Code, zero: no error
+ */
+static s32 __devinit da9052_tsi_probe(struct platform_device *dev)
+{
+	s32 ret;
+
+	/* Register the TSI device driver & it's API's with kernel */
+	ret = register_chrdev(tsi_major_number, DA9052_TSI_DEVICE_NAME, 
+							&da9052_tsi_fops);
+	if (ret < 0) {
+		printk(KERN_ERR "Unable to register %s\n",
+						DA9052_TSI_DEVICE_NAME);
+		return (ret);	
+	} else {
+		tsi_major_number = ret;
+		printk(KERN_INFO "%s: Major number is: %d \n", 
+				DA9052_TSI_DEVICE_NAME, tsi_major_number);
+
+		/* Perform DA9052 specific H/W initializations */
+		if (da9052_tsi_init_drv()) {
+			/* Error in hw initialization */
+			unregister_chrdev(tsi_major_number, 
+						DA9052_TSI_DEVICE_NAME);
+			return (-EFAULT);
+		}
+
+		printk(KERN_INFO "TSI Drv Successfully Inserted %s\n", 
+						DA9052_TSI_DEVICE_NAME);
+		return (SUCCESS);
+	}
+}
+
+/**
+ * static struct platform_driver da9052_tsi_driver -
+ * This structure definition has to be defined here as an exception.
+ * @probe: Probe function for this device. 
+ * @remove: Function to be called when removing this device from platform
+ * @suspend: Function to be called in suspend mode
+ * @resume: Function to be called in resume mode
+ * @driver: Contains glue logic to bind platform device and plarform driver
+ */
+static struct platform_driver da9052_tsi_driver = {
+	.probe		= da9052_tsi_probe,
+	.remove		= __devexit_p(da9052_tsi_remove),
+	.suspend	= da9052_tsi_suspend,
+	.resume		= da9052_tsi_resume,
+	.driver		= {
+				.name	= DA9052_TSI_DEVICE_NAME,
+				.owner	= THIS_MODULE,
+			},
+};
+/**
+ * da9052_tsi_init: 
+ * Description:	This function registers DA9052 TSI platform 
+ *	       	device with kernel.
+ * 
+ * @param void 	None
+ * @return int  Returns Success or Failure
+ */
+static int __init da9052_tsi_init(void)
+{
+	int retval;
+	printk(banner);
+	/* Allocate memory for a platform device object for TSI */
+	da9052_tsi_platform_device = platform_device_alloc("da9052_tsi", 0);
+	if (!da9052_tsi_platform_device)
+		return (-ENOMEM);
+
+	/* Add TSI platform device to kernel's list of devices */
+	retval = platform_device_add(da9052_tsi_platform_device);
+	if (retval < 0) {
+		platform_device_put(da9052_tsi_platform_device);
+		return (retval);
+	}
+
+	/* Register the TSI as a platform device with the kernel */
+	retval = platform_driver_register(&da9052_tsi_driver);
+	if (retval < 0)
+		platform_device_unregister(da9052_tsi_platform_device);
+	return (retval);
+}
+
+/**
+ * da9052_tsi_exit: 
+ * Description: This function release the resources and unregisters 
+ *		TSI driver from the platform device
+ * @param void
+ * @return void
+ */
+static void __exit da9052_tsi_exit(void)
+{
+	int i;
+	da9052_tsi_info *ts = get_tsi_drvdata();
+	ssize_t ret = 0;
+
+	/* Disable the TSI on DA9052  */
+	ret = da9052_tsi_config_state(TSI_IDLE);
+	if(ret == SUCCESS) {
+		DA9052_DEBUG(KERN_ERR "TSI Device Successfully Disabled \n");
+	}
+
+	/* Checks registration with EH for pendown is done or not */
+	if(ts->pd_reg_status){
+		/* Un-register from the EH for the requested event */	
+		da9052_eh_unregister_nb(&ts->pd_nb);
+		ts->pd_reg_status = RESET;
+	}	
+
+	/* stop processing thread */
+	tsi_raw_proc_thread.state = INACTIVE;
+	tsi_reg_proc_thread.state = INACTIVE;
+
+	/* wait for threads to exit */
+	wait_for_completion(&tsi_raw_proc_thread.notifier);
+	wait_for_completion(&tsi_reg_proc_thread.notifier);
+
+	/*Unregister the input device*/
+	for (i=0; i < NUM_INPUT_DEVS; i++)
+	{
+		input_unregister_device(ts->input_devs[i]);
+	}	
+	
+	/*Unregister the char device*/
+	unregister_chrdev(tsi_major_number, DA9052_TSI_DEVICE_NAME);
+
+	/*Unregister the platform device*/
+	platform_driver_unregister(&da9052_tsi_driver);
+	platform_device_unregister(da9052_tsi_platform_device);
+
+	printk(KERN_ERR "TSI Driver %s Successfully Removed \n", 
+					DA9052_TSI_DEVICE_NAME);
+}
+
+
+module_init(da9052_tsi_init);
+module_exit(da9052_tsi_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd");
+MODULE_DESCRIPTION("DA9052 Touch Screen Device Driver");
+MODULE_LICENSE("GPL");
+/*--------------------------------------------------------------------------*/
+/* Exports                                                                  */
+/*--------------------------------------------------------------------------*/
+EXPORT_SYMBOL(da9052_tsi_set_sampling_mode);
+EXPORT_SYMBOL(da9052_tsi_config_skip_slots);
+EXPORT_SYMBOL(da9052_tsi_config_delay);
+EXPORT_SYMBOL(da9052_tsi_config_measure_seq);
+
+EXPORT_SYMBOL(da9052_tsi_config_state);
+EXPORT_SYMBOL(da9052_tsi_get_manual_measurement);
+EXPORT_SYMBOL(da9052_tsi_get_drv_state);
diff -Naur linux-2.6.33.2_bk/drivers/input/touchscreen/da9052_tsi_calibrate.c linux-2.6.33.2_patch/drivers/input/touchscreen/da9052_tsi_calibrate.c
--- linux-2.6.33.2_bk/drivers/input/touchscreen/da9052_tsi_calibrate.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/input/touchscreen/da9052_tsi_calibrate.c	2010-05-18 18:27:40.000000000 +0500
@@ -0,0 +1,193 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_tsi_calibrate.c: 	File to hold calibration functins for TSI 
+ *				driver.
+ *
+ *
+ * History:
+ *
+ * (08/05/2009):	- Moved calibration functions to this file.
+ *
+ * (27/04/2010): 	Created initial draft for Linux community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+#include <linux/mfd/da9052/da9052_tsi.h>
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+
+/* This default init is for perfect alignment */
+/* between  display & touch screen */
+static Calib_xform_matrix_t xform = {
+		.An = 1,
+		.Bn = 0,
+		.Cn = 0,
+		.Dn = 0,
+		.En = 1,
+		.Fn = 0,
+		.Divider = 1
+};
+
+static calib_cfg_t calib = {
+	.calibrate_flag = TSI_USE_CALIBRATION,
+};
+
+/*--------------------------------------------------------------------------*/
+/* Global Functions                                                         */
+/*--------------------------------------------------------------------------*/
+/**
+ * get_calib_matrix:	returns pointer to calibration data.
+ * @param void	
+ * @return Calib_xform_matrix_t* 
+ */
+calib_cfg_t* get_calib_config(void)
+{
+	return (&calib);
+}
+
+/**
+ *  Function: da9052_tsi_set_calib_matrix()
+ *
+ *  Description:	Calling this function with valid input data
+ *			in the display and screen input arguments 
+ *			causes the calibration factors between the
+ *			screen and display points to be calculated,
+ *			and the output argument - matrixPtr - to be 
+ *			populated.
+ *
+ *			This function needs to be called only when new
+ *			calibration factors are desired.
+ *
+ *
+ *  @param  displayPtr (input) -	Pointer to an array of three 
+ *					sample, reference points.
+ *  @param  screenPtr (input) -		Pointer to the array of touch 
+ *					screen points corresponding 
+ *					to the reference display points.
+ *
+ * @return SUCCESS - 	the calibration matrix was correctly 
+ *			calculated and its value is in the 
+ *			output argument.
+ *         -FAILURE - 	an error was detected and the function failed to 
+ *			return a valid set of matrix values. The only 
+ *			time this sample code returns -FAILURE is when 
+ *			Divider is equal to 0.
+ */
+ssize_t da9052_tsi_set_calib_matrix(da9052_tsi_data *displayPtr,
+                          da9052_tsi_data *screenPtr)
+{
+
+	int  retValue = SUCCESS ;
+
+	xform.Divider = ((screenPtr[0].x - screenPtr[1].x) 
+					* (screenPtr[1].y - screenPtr[2].y)) 
+		 			- ((screenPtr[1].x - screenPtr[2].x) 
+					* (screenPtr[0].y - screenPtr[1].y)); 
+
+	if( xform.Divider == 0 )
+	{
+		retValue = -FAILURE ;
+	}
+	else
+	{
+		xform.An = ( (displayPtr[0].x - displayPtr[1].x) 
+					* (screenPtr[1].y - screenPtr[2].y) ) 
+			 		- ( (displayPtr[1].x - displayPtr[2].x) 
+						* (screenPtr[0].y - screenPtr[1].y) ); 
+
+		xform.Bn = ( (displayPtr[1].x - displayPtr[2].x) 
+					* (screenPtr[0].x - screenPtr[1].x) ) 
+			 		- ( (screenPtr[1].x - screenPtr[2].x) 
+						* (displayPtr[0].x - displayPtr[1].x) );
+
+		 xform.Cn = (displayPtr[0].x * xform.Divider) 
+				 		- (screenPtr[0].x * xform.An) 
+						- (screenPtr[0].y * xform.Bn);
+		 
+		xform.Dn = ( (displayPtr[0].y - displayPtr[1].y) 
+					* (screenPtr[1].y - screenPtr[2].y) ) 
+					- ( (displayPtr[1].y - displayPtr[2].y) 
+						* (screenPtr[0].y - screenPtr[1].y) );
+
+	        xform.En = ( (displayPtr[1].y - displayPtr[2].y) 
+					* (screenPtr[0].x - screenPtr[1].x) ) 
+						- ( (screenPtr[1].x - screenPtr[2].x) 
+						* (displayPtr[0].y - displayPtr[1].y) );
+
+		xform.Fn = (displayPtr[0].y * xform.Divider) 
+						- (screenPtr[0].x * xform.Dn) 
+						- (screenPtr[0].y * xform.En);
+	}
+ 
+    return( retValue ) ;
+}
+
+
+/**
+ *  Function: da9052_tsi_get_calib_display_point()
+ *
+ *  Description: Given a valid set of calibration factors and a point
+ *                value reported by the touch screen, this function
+ *                calculates and returns the true (or closest to true)
+ *                display point below the spot where the touch screen 
+ *                was touched.
+ * 
+ *  @param displayPtr (output) - Pointer to the calculated (true) display point.
+ *
+ * @return 	SUCCESS - the display point was correctly calculated 
+ *              	       and its value is in the output argument.
+ * 		-FAILURE - an error was detected and the function
+ *                      	   failed to return a valid point.
+ */
+ssize_t da9052_tsi_get_calib_display_point( da9052_tsi_data * displayPtr )
+{
+    int  retValue = TRUE;
+    da9052_tsi_data screen_coord;
+    
+    screen_coord = *displayPtr;
+    if( xform.Divider != 0 )
+    {
+	/*
+	* Operation order is important since we are doing integer 
+	*  math. We add all terms together before      
+	*  dividing, so that the remainder is not rounded off     
+	*  prematurely.                                         
+	*/
+	displayPtr->x = ( (xform.An * screen_coord.x) + 
+                          (xform.Bn * screen_coord.y) + 
+                           xform.Cn 
+                        ) / xform.Divider ;
+
+	displayPtr->y = ( (xform.Dn * screen_coord.x) + 
+                          (xform.En * screen_coord.y) + 
+                           xform.Fn 
+                        ) / xform.Divider ;
+    }
+    else
+        /* Error */
+	retValue = FALSE;
+
+#if DA9052_TSI_CALIB_DATA_PROFILING
+	/* Print calibrated coordinate */
+	printk("C\tX\t%4d\tY\t%4d\n",
+					displayPtr->x,
+					displayPtr->y);
+#endif
+    return( retValue ) ;
+}
+
+EXPORT_SYMBOL(da9052_tsi_get_calib_display_point);
+EXPORT_SYMBOL(da9052_tsi_set_calib_matrix);
diff -Naur linux-2.6.33.2_bk/drivers/input/touchscreen/da9052_tsi_filter.c linux-2.6.33.2_patch/drivers/input/touchscreen/da9052_tsi_filter.c
--- linux-2.6.33.2_bk/drivers/input/touchscreen/da9052_tsi_filter.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/input/touchscreen/da9052_tsi_filter.c	2010-05-18 18:27:40.000000000 +0500
@@ -0,0 +1,835 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_tsi_filter.c: Driver for Touch Screen interface filter
+ *			on DA9052 chip.
+ *
+ *
+ * History:
+ *
+ * (07/05/2009):	- Moved Average filter to this file.
+ *			- Added window filter infrastructure.
+ *
+ * (25/05/2009):	- Added FIFO design to process data.
+ *
+ * (11/06/2009):	- Added thread to process touchscreen coordinates
+ *			  read from event handler buffer. These unprocessed
+ *			  or RAW coordinates are then passed through average
+ *			  filter, calibration mechanism and reported OS.
+ *
+ * (27/04/2010): 	Created initial draft for Linux community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+#include <linux/mfd/da9052/da9052_tsi.h>
+
+/*--------------------------------------------------------------------------*/
+/* Local Macro Definitions                                                  */
+/*--------------------------------------------------------------------------*/
+
+/* This macro returns the absolute value of input value */
+#define get_abs(x)	(x < 0 ? ((-1) * x) : (x))
+
+/* Macro to check if coordinate lies within the configured window size */
+#define WITHIN_WINDOW(x,y)	((get_abs(x) <= TSI_X_WINDOW_SIZE) && \
+					(get_abs(y) <= TSI_Y_WINDOW_SIZE))
+
+
+/* Macro define for first sample's index in FIFO */
+#define FIRST_SAMPLE		0
+
+/* Increment with wrap operation for ring buffer */
+#define incr_with_wrap_raw_fifo(x)			\
+		if(++x >= TSI_RAW_DATA_BUF_SIZE)	\
+			x = 0
+
+/* Decrement with wrap operation for ring buffer */
+#define decr_with_wrap_raw_fifo(x)			\
+		if(--x < 0)				\
+			x = (TSI_RAW_DATA_BUF_SIZE-1)
+
+/* Increment with wrap operation for ring buffer */
+#define incr_with_wrap_reg_fifo(x)			\
+		if(++x >= TSI_REG_DATA_BUF_SIZE)	\
+			x = 0
+
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+
+/* Flag to indicate if processing of early data is over or not */
+/* so RAW FIFO processing thread could process data */
+u8 early_data_flag;
+
+/* Flag to indicate if debouncing has finished or not */
+u8 debounce_over;
+
+/* Flag to indicate if reference sample for window filter is valid or not */
+u8 win_reference_valid;
+
+/* REG data processing thread */
+tsi_thread_type 		tsi_reg_proc_thread;
+
+/* FIFO to hold RAW data */
+da9052_tsi_raw_fifo 		tsi_raw_fifo;
+
+/* RAW data processing thread */
+da9052_tsi_reg_fifo		tsi_reg_fifo;
+
+/* FIFO to hold REG data */
+tsi_thread_type 		tsi_raw_proc_thread;
+
+/* Time period (in msecs) for processing of RAW FIFO */
+u32 tsi_raw_data_poll_interval;
+
+
+/*--------------------------------------------------------------------------*/
+/* Local Function Prototypes                                                */
+/*--------------------------------------------------------------------------*/
+static u32 get_raw_data_cnt (void);
+
+static void da9052_tsi_convert_reg_to_coord (da9052_tsi_data* raw_data);
+
+
+static s32 da9052_tsi_raw_proc_thread (void *ptr);
+
+static inline void clean_tsi_reg_fifo(void);
+
+static inline void clean_tsi_raw_fifo(void);
+
+#if (ENABLE_AVERAGE_FILTER)
+static void da9052_tsi_avrg_filter(da9052_tsi_data* tsi_avg_data);
+
+#endif
+
+#if (ENABLE_TSI_DEBOUNCE)
+static s32 da9052_tsi_calc_debounce_data(da9052_tsi_data* raw_data);
+
+#endif
+
+# if (ENABLE_WINDOW_FILTER)
+static s32 diff_within_window(da9052_tsi_data* prev_raw_data, 
+			      da9052_tsi_data* cur_raw_data);
+
+static s32 da9052_tsi_window_filter(da9052_tsi_data* raw_data);
+
+#endif
+/*--------------------------------------------------------------------------*/
+/* Global Functions                                                         */
+/*--------------------------------------------------------------------------*/
+/**
+ * clean_tsi_fifos: 
+ * Description: 	This function changes the FIFO state to empty by
+ *			re-initializing head & tail pointers.
+ *
+ * @param  void 	
+ * @return void
+ */
+void clean_tsi_fifos(void)
+{
+	clean_tsi_raw_fifo();
+	clean_tsi_reg_fifo();
+}
+
+/**
+ * da9052_init_tsi_fifos: 
+ * Description: 	This function initializes the REG & RAW data
+ *			processing FIFOs.
+ *
+ * @param  void 	
+ * @return void
+ */
+void __init da9052_init_tsi_fifos (void)
+{
+	/* Initialize TSI FIFO locks */
+	init_MUTEX(&tsi_raw_fifo.lock);
+	init_MUTEX(&tsi_reg_fifo.lock);
+
+	/* Initialize FIFO state variables */
+	clean_tsi_raw_fifo();
+	clean_tsi_reg_fifo();
+}
+
+/**
+ * get_reg_data_cnt: 
+ * Description: 	This function returns the number of raw coordinate 
+ *			samples present in REG data processing FIFO.
+ *
+ * @param  void 	
+ * @return u32   	Returns Success or Failure
+ */
+u32 get_reg_data_cnt (void)
+{
+	u8 reg_data_cnt;
+
+	/* First find available data in REG FIFO */
+	if (tsi_reg_fifo.head <= tsi_reg_fifo.tail) {
+		/* no overflow occured */
+		reg_data_cnt = (tsi_reg_fifo.tail - tsi_reg_fifo.head);
+	} else {
+		/* overflow occured, calculate valid data */
+		reg_data_cnt = (tsi_reg_fifo.tail + (TSI_REG_DATA_BUF_SIZE - 
+							tsi_reg_fifo.head));
+	}
+
+	return (reg_data_cnt);
+}
+
+/**
+ * get_reg_free_space_cnt: 
+ * Description: 	This function returns the free space present 
+ *			in REG data processing FIFO.
+ *
+ * @param  void 	
+ * @return u32   	Returns Success or Failure
+ */
+u32 get_reg_free_space_cnt(void)
+{
+	u32 free_cnt;
+
+	/* First find available space in TSI FIFO */
+	if (tsi_reg_fifo.head <= tsi_reg_fifo.tail) {
+		/* no overflow occured */
+		free_cnt = ((TSI_REG_DATA_BUF_SIZE - 1) - 
+				(tsi_reg_fifo.tail - tsi_reg_fifo.head));
+	} else {
+		/* overflow occured, valid data is divided to two parts. */
+		/* first count data at rear end */
+		free_cnt = ((tsi_reg_fifo.head - tsi_reg_fifo.tail) - 1);
+	}
+
+	return (free_cnt);
+}
+
+/**
+ * da9052_tsi_process_reg_data
+ * Description:	This function processes REG data FIFO one sample at a time 
+ *		- It pops a sample from REG data FIFO, converts it 
+ *		  to coordinate format.
+ *		- Checks if sample lies within TS dimensions.
+ *		- Applies debouncing, if debouncing is enabled.
+ *		- If window filter is enabled, it passes this sample 
+ *		  through window filter.
+ *		- If the sample's valid then moves it to RAW data FIFO.
+ *
+ * @param void
+ * @return void
+ */
+void da9052_tsi_process_reg_data(void)
+{
+	s32 ret;
+	da9052_tsi_data tmp_raw_data;
+	u32 reg_data_cnt;
+
+	/* Lock Reg data FIFO */
+	if(down_interruptible(&tsi_reg_fifo.lock)) {
+		return;
+	}
+
+	/* Find available data in REG FIFO */
+	reg_data_cnt = get_reg_data_cnt();
+
+	while (reg_data_cnt-- > 0) {
+
+		/* we have sample to be processed */
+		ret = SUCCESS;
+
+		/* check if raw FIFO is full */
+		if (get_raw_data_cnt() >= (TSI_RAW_DATA_BUF_SIZE - 1)) {
+			/* FIFO is full */
+			DA9052_DEBUG("%s: RAW data FIFO is full\n",
+							__FUNCTION__);
+			break;
+		}
+
+		/* convert & copy available sample from */
+		/* REG format to co-ordinate format  */
+		da9052_tsi_convert_reg_to_coord(&tmp_raw_data);
+
+		/* Is data within touchscreen panel dimensions? */
+		if ((tmp_raw_data.x < TS_X_MIN) ||
+				   (tmp_raw_data.x > TS_X_MAX) ||
+				   (tmp_raw_data.y < TS_Y_MIN) ||
+				   (tmp_raw_data.y > TS_Y_MAX)) {
+			/* Data beyond touchscreen boundries */
+			/* reject this sample & continue with next one */
+			DA9052_DEBUG("%s: ", __FUNCTION__);
+			DA9052_DEBUG("sample beyond touchscreen panel ");
+			DA9052_DEBUG("dimensions\n");
+			continue;
+		}
+
+#if (ENABLE_TSI_DEBOUNCE)
+		if(debounce_over == FALSE) {
+			/* Debounce */
+			ret = da9052_tsi_calc_debounce_data (&tmp_raw_data);
+			if (ret != SUCCESS) {
+				/* Don't start filtering till */
+				/* debouncing is over */
+				continue;
+			}
+		}
+#endif
+
+# if (ENABLE_WINDOW_FILTER)
+		/* Apply Window Filter */
+		ret = da9052_tsi_window_filter(&tmp_raw_data);
+		if (ret != SUCCESS) {
+			/* Sample was rejected by window filter */
+			continue;
+		}
+#endif
+
+		/* Early data processing is over now */
+		early_data_flag = FALSE;
+
+		/* We have valid data with us */
+
+		/* Lock Raw data FIFO */
+		if(down_interruptible(&tsi_raw_fifo.lock)) {
+			/* RAW FIFO lock could not be acquired */
+			DA9052_DEBUG("%s: Failed to ", __FUNCTION__);
+			DA9052_DEBUG("acquire RAW FIFO Lock!\n");
+
+			/* Release REG FIFO lock before error exit */
+			up(&tsi_reg_fifo.lock);
+			return;
+		}
+
+		/* update RAW data FIFO */
+		tsi_raw_fifo.data[tsi_raw_fifo.tail] = tmp_raw_data;
+		incr_with_wrap_raw_fifo(tsi_raw_fifo.tail);
+
+		/* Release raw FIFO */
+		up(&tsi_raw_fifo.lock);
+	}
+
+
+	/* Release reg FIFO */
+	up(&tsi_reg_fifo.lock);
+
+	return;
+}
+
+/*--------------------------------------------------------------------------*/
+/* Local Functions                                                          */
+/*--------------------------------------------------------------------------*/
+/**
+ * get_raw_data_cnt: 
+ * Description: 	This function returns the number of raw coordinate 
+ *			samples present in RAW data processing FIFO.
+ *
+ * @param  void 	
+ * @return u32   	Returns Success or Failure
+ */
+static u32 get_raw_data_cnt (void)
+{
+	u32 raw_data_cnt;
+
+	/* First find available data in RAW FIFO */
+	if (tsi_raw_fifo.head <= tsi_raw_fifo.tail) {
+		/* no overflow occured */
+		raw_data_cnt = (tsi_raw_fifo.tail - tsi_raw_fifo.head);
+	} else {
+		/* overflow occured, calculate valid data */
+		raw_data_cnt = (tsi_raw_fifo.tail + (TSI_RAW_DATA_BUF_SIZE - 
+							tsi_raw_fifo.head));
+	}
+
+	return (raw_data_cnt);
+}
+
+#if 0
+
+/* This function is not used in current implementation */
+/* It can be uncommented if it has to be used */
+/**
+ * get_raw_free_space_cnt: 
+ * Description: 	This function returns the free space present 
+ *			in RAW data processing FIFO.
+ *
+ * @param  void 	
+ * @return u32   	Returns Success or Failure
+ */
+static u32 get_raw_free_space_cnt(void)
+{
+	u32 free_cnt;
+
+	/* First find available space in TSI FIFO */
+	if (tsi_raw_fifo.head <= tsi_raw_fifo.tail) {
+		/* no overflow occured */
+		free_cnt = ((TSI_REG_DATA_BUF_SIZE - 1) - 
+				(tsi_raw_fifo.tail - tsi_raw_fifo.head));
+	} else {
+		/* overflow occured, valid data is divided to two parts. */
+		/* first count data at rear end */
+		free_cnt = ((tsi_raw_fifo.head - tsi_raw_fifo.tail) - 1);
+	}
+
+	return (free_cnt);
+}
+#endif
+
+/**
+ * convert_reg_to_coord
+ * Description: This function pops one sample in register format 
+ *		from REG_FIFO converts it to co-ordinate format and stores 
+ *		it to RAW FIFO.
+ *
+ * @param  raw_data	return pointer to store result.
+ * @return void
+ */
+static void da9052_tsi_convert_reg_to_coord (da9052_tsi_data* raw_data)
+{
+
+	/* update raw data FIFO till free space is available */
+	da9052_tsi_reg* src;
+	da9052_tsi_data* dst = raw_data;
+
+	src = &tsi_reg_fifo.data[tsi_reg_fifo.head];
+
+	/* Convert data from REG format to co-ordinate format */
+	dst->x = (src->x_msb << X_MSB_SHIFT);
+	dst->x |= (src->lsb & X_LSB_MASK) >> X_LSB_SHIFT;
+
+	dst->y = (src->y_msb << Y_MSB_SHIFT);
+	dst->y |= (src->lsb & Y_LSB_MASK) >> Y_LSB_SHIFT;
+
+	dst->z = (src->z_msb << Z_MSB_SHIFT);
+	dst->z |=(src->lsb & Z_LSB_MASK) >> Z_LSB_SHIFT;
+
+#if DA9052_TSI_RAW_DATA_PROFILING
+	/* Print raw co-ordinate data */
+	printk("R\tX\t%4d\tY\t%4d\tZ\t%4d\n",	
+					(u16)dst->x,
+					(u16)dst->y,
+					(u16)dst->z);
+#endif
+	/* Wrap FIFO indices if they exceed FIFO length */
+	incr_with_wrap_reg_fifo(tsi_reg_fifo.head);
+}
+
+#if (ENABLE_AVERAGE_FILTER)
+/**
+ * da9052_tsi_avrg_filter: 
+ * Description:	This function pops out 'size' number of samples starting 
+ *		from head of RAW data processing FIFO, calculates average &
+ *		stores the result in out parameter 'tsi_avg_data'.
+ *
+ * @param tsi_avg_data	Return pointer for averaged out co-ordinate.
+ * @param size		number of samples over which averaging is to 
+ *			be performed.
+ * @return void
+ */
+static void da9052_tsi_avrg_filter(da9052_tsi_data* tsi_avg_data)
+{
+	u8 cnt;
+
+	/* acquire lock for RAW FIFO */
+	if(down_interruptible(&tsi_raw_fifo.lock)) {
+		printk("%s: No RAW Lock !\n", __FUNCTION__);
+		return;
+	}
+
+	/* Assign first data */
+	(*tsi_avg_data) = tsi_raw_fifo.data[tsi_raw_fifo.head];
+	incr_with_wrap_raw_fifo(tsi_raw_fifo.head);
+
+	/* Sum X,Y and Z data for average filter size */
+	for (cnt=2; cnt <= TSI_AVERAGE_FILTER_SIZE; cnt++) {
+
+		tsi_avg_data->x += tsi_raw_fifo.data[tsi_raw_fifo.head].x;
+		tsi_avg_data->y += tsi_raw_fifo.data[tsi_raw_fifo.head].y;
+		tsi_avg_data->z += tsi_raw_fifo.data[tsi_raw_fifo.head].z;
+
+		incr_with_wrap_raw_fifo(tsi_raw_fifo.head);
+	}
+
+	/* Release lock for RAW FIFO */
+	up(&tsi_raw_fifo.lock);
+
+	/* Find the averaged X,Y and Z value by */ 
+	/* dividing by number of co-ordinate samples */
+	tsi_avg_data->x /= TSI_AVERAGE_FILTER_SIZE;
+	tsi_avg_data->y /= TSI_AVERAGE_FILTER_SIZE;
+	tsi_avg_data->z /= TSI_AVERAGE_FILTER_SIZE;
+
+#if DA9052_TSI_AVG_FLT_DATA_PROFILING
+	/* the refined/averaged X, Y & Z co-ordinates */
+	printk("A\tX\t%4d\tY\t%4d\tZ\t%4d\n", 
+	      			 (u16)tsi_avg_data->x,
+				 (u16)tsi_avg_data->y,
+				 (u16)tsi_avg_data->z);
+#endif
+
+	return;
+}
+#endif
+
+/**
+ * da9052_tsi_raw_proc_thread: 
+ * Description:	This function is executed as a thread. It polls RAW data 
+ *		FIFO periodically to check if data is available for processing. 
+ *		As long as this thread's state is active, it performs 
+ *		following operations:
+ *		1. sleeps for TSI_RAW_DATA_PROCESSING_INTERVAL msecs.
+ *		2. checks if RAW data FIFO has data to be processed.
+ *		3. if average filter has been enabled, 
+ *		   applies it to the RAW FIFO data.
+ *		4. calibrates the final coordinate sample & checks it's range.
+ *		5. reports this sample to the kernel.
+ *
+ * @param  ptr	Not Used. Provided for compatibility with prototype of thread.
+ * @return s32	SUCCESS / FAILURE
+ */
+static s32 da9052_tsi_raw_proc_thread (void *ptr)
+{
+	da9052_tsi_data coord;
+	u8 calib_ok, range_ok;
+	calib_cfg_t *tsi_calib = get_calib_config();
+	struct input_dev* ip_dev = (struct input_dev*)
+				da9052_tsi_get_input_dev(
+						(u8)TSI_INPUT_DEVICE_OFF);
+
+	set_freezable();
+
+	while(tsi_raw_proc_thread.state == ACTIVE) {
+
+		/* make our thread friendly to system suspend */
+		try_to_freeze();
+
+		/* set how we want to sleep & go for it */
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(msecs_to_jiffies(tsi_raw_data_poll_interval));
+
+		/* We're awake */
+		/* Check for availibility of data */
+		if (early_data_flag || (get_raw_data_cnt() == 0)) {
+			/* not enough data, continue the loop */
+			continue;
+		}
+
+		/* Values checked for every iteration */
+		calib_ok = TRUE;
+		range_ok = TRUE;
+
+#if (ENABLE_AVERAGE_FILTER)
+
+		/* Average Filter */
+		if (get_raw_data_cnt() < TSI_AVERAGE_FILTER_SIZE) {
+			/* Not enough data to perform average */
+			continue;
+		}
+		da9052_tsi_avrg_filter (&coord);
+
+#else
+
+		/* No filter's used */
+		/* acquire lock for RAW FIFO */
+		if(down_interruptible(&tsi_raw_fifo.lock)) {
+			continue;
+		}
+
+		/* update RAW FIFO */
+		coord = tsi_raw_fifo.data[tsi_raw_fifo.head];
+		incr_with_wrap_raw_fifo(tsi_raw_fifo.head);
+
+		/* Release lock for RAW FIFO */
+		up(&tsi_raw_fifo.lock);
+
+#endif
+
+		/* All data processing over */
+		/* Check if calibration is to be used. */
+		if (tsi_calib->calibrate_flag) {
+			calib_ok = da9052_tsi_get_calib_display_point(&coord);
+
+			/* Is final data within display panel dimensions ? */
+			if ((coord.x < DISPLAY_X_MIN) || 
+				(coord.x > DISPLAY_X_MAX) || 
+				(coord.y < DISPLAY_Y_MIN) || 
+						(coord.y > DISPLAY_Y_MAX))
+				range_ok = FALSE;
+		}
+
+		if (calib_ok && range_ok) {
+			/* Report data to input dev infrastructure. */
+			input_report_abs(ip_dev, ABS_X, coord.x);
+			input_report_abs(ip_dev, ABS_Y, coord.y);
+			input_report_abs(ip_dev, ABS_Z, coord.z);
+			input_sync(ip_dev);
+
+#if DA9052_TSI_OS_DATA_PROFILING
+			printk("O\tX\t%4d\tY\t%4d\tZ\t%4d\n",  (u16)coord.x,
+								(u16)coord.y,
+								(u16)coord.z);
+#endif
+		} else {
+			if (!calib_ok) {
+				DA9052_DEBUG("%s: ", __FUNCTION__);
+				DA9052_DEBUG("calibration Failed\n");
+			}
+			if (!range_ok) {
+				DA9052_DEBUG("%s: ", __FUNCTION__);
+				DA9052_DEBUG("sample beyond display ");
+				DA9052_DEBUG("panel dimension\n");
+			}
+		}
+	}
+
+	/* Indicate termination of this thread */
+	complete_and_exit(&tsi_raw_proc_thread.notifier, 0);
+	return (SUCCESS);
+}
+
+#if (ENABLE_TSI_DEBOUNCE)
+/**
+ * da9052_tsi_calc_debounce_data: 
+ * Description:	This function calculates debounce over initial set of 
+ *		samples after change to a pen-down state. The number of 
+ *		samples over which debounce is calculated is configurable.
+ *
+ * @param  raw_data	reference of data sample which has to be debounced.
+ * @return s32		SUCCESS / FAILURE
+ */
+static s32 da9052_tsi_calc_debounce_data(da9052_tsi_data* raw_data)
+{
+#if (TSI_DEBOUNCE_DATA_CNT)
+	u8 cnt;
+	da9052_tsi_data	temp = {.x=0, .y=0, .z=0};
+
+	/* store raw data to FIFO */
+	tsi_raw_fifo.data[tsi_raw_fifo.tail] = (*raw_data);
+	incr_with_wrap_raw_fifo(tsi_raw_fifo.tail);
+
+	if (get_raw_data_cnt() <= TSI_DEBOUNCE_DATA_CNT) {
+		/* Not enough data for debounce to process */
+		return (-FAILURE);
+	}
+
+	/* Debounce: sum initial samples & average them */
+	for (cnt = 1; cnt <= TSI_DEBOUNCE_DATA_CNT; cnt++) {
+		temp.x += tsi_raw_fifo.data[tsi_raw_fifo.head].x;
+		temp.y += tsi_raw_fifo.data[tsi_raw_fifo.head].y;
+		temp.z += tsi_raw_fifo.data[tsi_raw_fifo.head].z;
+
+		incr_with_wrap_raw_fifo(tsi_raw_fifo.head);
+	}
+
+	temp.x /= TSI_DEBOUNCE_DATA_CNT;
+	temp.y /= TSI_DEBOUNCE_DATA_CNT;
+	temp.z /= TSI_DEBOUNCE_DATA_CNT;
+
+	/* clear out FIFO */
+	tsi_raw_fifo.tail = tsi_raw_fifo.head;
+	/* insert debounced sample */
+	tsi_raw_fifo.data[tsi_raw_fifo.tail] = temp;
+	incr_with_wrap_raw_fifo(tsi_raw_fifo.tail);
+
+#if DA9052_TSI_PRINT_DEBOUNCED_DATA
+	/* This print should be enabled in order */
+	/* to observe the debounced value */
+	printk("D: X: %d Y: %d Z: %d\n",
+	       (u16)temp.x,
+	       (u16)temp.y,
+	       (u16)temp.z);
+#endif
+
+#endif //(TSI_DEBOUNCE_DATA_CNT) ends
+
+	/* debouncing completed */
+	debounce_over = TRUE;
+
+	return (SUCCESS);
+}
+#endif
+
+# if (ENABLE_WINDOW_FILTER)
+/**
+ * diff_within_window
+ * Description:	This function takes as its input, pointers to two 
+ *		TSI coordinates. It then checks if these lie
+ *		within configured window filter size.
+ *
+ * @param prev_raw_data		pointer to previous valid coordinate.
+ * @param cur_raw_data		pointer to current sample.
+ * @return ssize_t		SUCCESS: current sample lies within window  
+ *						range w.r.t. previous sample.
+ *				-FAILURE: current sample lies beyond window  
+ *						range w.r.t. previous sample.
+ */
+static s32 diff_within_window(da9052_tsi_data* prev_raw_data, 
+					da9052_tsi_data* cur_raw_data)
+{
+
+	s32 ret = -FAILURE;
+	s32 x, y;
+
+	/* Find difference between current */
+	/* and previous co-ordinate */
+	x = ((cur_raw_data->x) - (prev_raw_data->x));
+	y = ((cur_raw_data->y) - (prev_raw_data->y));
+
+	if (WITHIN_WINDOW(x,y)) {
+
+#if DA9052_TSI_WIN_FLT_DATA_PROFILING
+		/* Print window filtered data */
+		printk("W\tX\t%4d\tY\t%4d\tZ\t%4d\n",	
+					(u16)cur_raw_data->x,
+					(u16)cur_raw_data->y,
+					(u16)cur_raw_data->z);
+#endif
+		/* sample lies within configured window size */
+		ret = SUCCESS;
+	}
+	return (ret);
+}
+
+/**
+ * da9052_tsi_window_filter
+ * Description:	This function has the main window filter mechanism.
+ *		It calculates & sets first sample for reference.
+ *
+ * @param raw_data	pointer to TSI coordinate data.
+ * @return ssize_t	SUCCESS: current sample successfully passed through 
+ *				window filter.
+ *			-FAILURE: current sample rejected by window filter.
+ */
+static s32 da9052_tsi_window_filter(da9052_tsi_data* raw_data)
+{
+	u8 ref_found;
+	u32 cur, next;
+	s32 ret = -FAILURE;
+	static da9052_tsi_data prev_raw_data;
+
+	if (win_reference_valid == TRUE) {
+
+#if DA9052_TSI_PRINT_PREVIOUS_DATA
+		/* Debug print to be enabled if value previous */
+		/* to current sample needs to be observed */
+		printk("P: X: %d Y: %d Z: %d\n",
+					(u16)prev_raw_data.x,
+					(u16)prev_raw_data.y,
+					(u16)prev_raw_data.z);
+#endif
+		/* Apply window filter on current sample */
+		ret = diff_within_window(&prev_raw_data, raw_data);
+		if (ret == SUCCESS) {
+			/* update previous RAW data */
+			prev_raw_data = (*raw_data);
+		}
+
+	} else {
+		/* Reference sample for window filter */
+		/* was not calculated  */
+
+		/* store raw data to FIFO */
+		tsi_raw_fifo.data[tsi_raw_fifo.tail] = (*raw_data);
+		incr_with_wrap_raw_fifo(tsi_raw_fifo.tail);
+
+		if (get_raw_data_cnt() == SAMPLE_CNT_FOR_WIN_REF) {
+
+			/* We have enough samples to calculate */
+			/* reference sample for window filter */
+			ref_found = FALSE;
+
+			next = cur = tsi_raw_fifo.head;
+			incr_with_wrap_raw_fifo(next);
+
+			while (next <= tsi_raw_fifo.tail) {
+				/* Find if samples lie within */
+				/* configured window size  */
+				ret = diff_within_window(
+						&tsi_raw_fifo.data[cur],
+						&tsi_raw_fifo.data[next]
+						);
+				if (ret == SUCCESS) {
+					/* Valid samples found from which */
+					/* reference sample can be */
+					/* calculated */
+					ref_found = TRUE;
+					break;
+				}
+				/* Increment indices */
+				incr_with_wrap_raw_fifo(cur);
+				incr_with_wrap_raw_fifo(next);
+
+				/* If we haven't reached end-of-FIFO */
+				/*  then loop again */
+			}
+
+			if (ref_found == FALSE) {
+				/* Clear FIFO and wait  for  */
+				/* next set of samples */
+				tsi_raw_fifo.tail = tsi_raw_fifo.head;
+			} else {
+				/* Calculating reference sample */
+				prev_raw_data = tsi_raw_fifo.data[cur];
+
+				prev_raw_data.x += tsi_raw_fifo.data[next].x;
+				prev_raw_data.y += tsi_raw_fifo.data[next].y;
+				prev_raw_data.z += tsi_raw_fifo.data[next].z;
+
+				prev_raw_data.x = prev_raw_data.x /2;
+				prev_raw_data.y = prev_raw_data.y /2;
+				prev_raw_data.z = prev_raw_data.z /2;
+
+				/* Put reference sample in return pointer */
+				(*raw_data) = prev_raw_data;
+
+				/* Clear FIFO off remaining samples */
+				tsi_raw_fifo.tail = tsi_raw_fifo.head;
+
+				/* Release the flag & return SUCCESS */
+				win_reference_valid = TRUE;
+				ret = SUCCESS;
+			}
+		}
+	}
+
+	return (ret);
+}
+#endif //ENABLE_WINDOW_FILTER ends
+
+/**
+ * clean_tsi_reg_fifo: 
+ * Description: 	This function changes the REG FIFO state to empty by
+ *			re-initializing head & tail pointers to first sample 
+ *			of the FIFO.
+ *
+ * @param  void 	
+ * @return void
+ */
+static inline void clean_tsi_reg_fifo(void)
+{
+	/* clean buffer state variables */
+	tsi_reg_fifo.head = FIRST_SAMPLE;
+	tsi_reg_fifo.tail = FIRST_SAMPLE;
+}
+
+/**
+ * clean_tsi_raw_fifo: 
+ * Description: 	This function changes the RAW FIFO state to empty by
+ *			re-initializing head & tail pointers to first sample 
+ *			of the FIFO.
+ *
+ * @param  void 	
+ * @return void
+ */
+static inline void clean_tsi_raw_fifo(void)
+{
+	/* clean buffer state variables */
+	tsi_raw_fifo.head = FIRST_SAMPLE;
+	tsi_raw_fifo.tail = FIRST_SAMPLE;
+}
+
diff -Naur linux-2.6.33.2_bk/drivers/input/touchscreen/Makefile linux-2.6.33.2_patch/drivers/input/touchscreen/Makefile
--- linux-2.6.33.2_bk/drivers/input/touchscreen/Makefile	2010-04-02 04:02:33.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/input/touchscreen/Makefile	2010-05-18 18:27:40.000000000 +0500
@@ -45,3 +45,4 @@
 obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
+obj-$(CONFIG_DA9052_TSI_ENABLE)         += da9052_tsi.o
diff -Naur linux-2.6.33.2_bk/drivers/mfd/Kconfig linux-2.6.33.2_patch/drivers/mfd/Kconfig
--- linux-2.6.33.2_bk/drivers/mfd/Kconfig	2010-05-18 17:54:30.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/mfd/Kconfig	2010-05-18 18:27:40.000000000 +0500
@@ -377,6 +377,17 @@
 	help
 	  Say Y  to enable the ADC driver for the DA9052 chip
 
+config DA9052_TSI_ENABLE
+	bool "Dialog Semiconductor DA9052 Touch Driver"
+	depends on MFD_DA9052
+	select DA9052_ADC_ENABLE
+	select DA9052_PM_ENABLE
+
+	help
+	  Depends on DA9052 ADC driver
+	  Depends on DA9052 PM reglator driver	 	
+	  Say Y  to enable the TSI driver for the DA9052 chip
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff -Naur linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_tsi_calibrate.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_tsi_calibrate.h
--- linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_tsi_calibrate.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_tsi_calibrate.h	2010-05-18 18:27:40.000000000 +0500
@@ -0,0 +1,96 @@
+#ifndef DA9052_TSI_CALIBRATE_H
+#define DA9052_TSI_CALIBRATE_H
+
+/**
+ * Calibration -
+ *
+ *  The following set of matrix equations represent a valid display 
+ *  point given a corresponding set of touch screen points:
+ *
+ *
+ *              |      |     |              |   |   Xs  |
+ *              |  Xd  |     | A    B    C  |   |       |
+ *              |      |  =  |              | * |   Ys  |
+ *              |  Yd  |     | D    E    F  |   |       |
+ *              |      |     |              |   |   1   |
+ *
+ * 
+ *    where:
+ *
+ *           (Xd,Yd) represents the desired display point coordinates
+ *                   on LCD /TFT screen,
+ *
+ *           (Xs,Ys) represents the available touch screen coordinates,
+ *                   and the matrix
+ *
+ *           |A,B,C|
+ *           |D,E,F| represents the transformation factors used to translate
+ *                   available touch screen point values into the 
+ *                   corresponding display coordinates.
+ *
+ *
+ *    Note that for practical considerations, the utilitities 
+ *     within this file do not use the matrix coefficients as
+ *     defined above, but instead use the following 
+ *     equivalents, since floating point math is not used:
+ *
+ *            A = An/Divider 
+ *            B = Bn/Divider 
+ *            C = Cn/Divider 
+ *            D = Dn/Divider 
+ *            E = En/Divider 
+ *            F = Fn/Divider 
+ *
+ *
+ *  Note: 
+ *  digitizer resolution should not exceed 10 bits (1024 values).  
+ *  Higher resolutions may cause the integer operations to overflow
+ *  and return incorrect values. 
+ *
+ */
+
+/*--------------------------------------------------------------------------*/
+/* Global Typedefs                                                          */
+/*--------------------------------------------------------------------------*/
+/**
+ * \struct Matrix - Structure description
+ * \var An:		A = An/Divider 
+ * \var Bn:		B = Bn/Divider
+ * \var Cn:		C = Cn/Divider
+ * \var Dn:		D = Dn/Divider
+ * \var En:		E = En/Divider
+ * \var Fn:		F = Fn/Divider
+ * \var Divider:	common divider
+ */
+typedef struct Matrix {
+	s32    An;
+ 	s32    Bn;
+ 	s32    Cn;
+ 	s32    Dn;
+ 	s32    En;
+ 	s32    Fn;
+ 	s32    Divider;
+} Calib_xform_matrix_t ;
+
+ /**
+ * \struct calib_cfg_t - 
+ * \var u8 calibrate_flag:	flag to indicate if calibration is to be used.
+ */
+ typedef struct {
+	u8 calibrate_flag;
+}calib_cfg_t;
+
+/*--------------------------------------------------------------------------*/
+/* Global Functions                                                         */
+/*--------------------------------------------------------------------------*/
+ssize_t da9052_tsi_get_calib_display_point(da9052_tsi_data* displayPtr);
+				
+
+ssize_t da9052_tsi_set_calib_matrix(da9052_tsi_data *displayPtr,
+					da9052_tsi_data *screenPtr);
+
+
+u8 configure_tsi_calib(calib_cfg_t *tsi_calib);
+
+calib_cfg_t* get_calib_config(void);
+#endif	//#ifndef DA9052_TSI_CALIBRATE_H
diff -Naur linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_tsi_cfg.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_tsi_cfg.h
--- linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_tsi_cfg.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_tsi_cfg.h	2010-05-18 18:27:40.000000000 +0500
@@ -0,0 +1,173 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_tsi_cfg.h: tsi driver configuration file for DA9052
+ *
+ * This file defines configurations used for DA9052 TSI driver.
+ *
+ * History:
+ *
+ * (11/06/2009):	This file has all the configuration options 
+ *			supported by DA9052 TSI driver.
+ *
+ * (27/04/2010):	Updated for Linux Community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+#ifndef _DA9052_TSI_CFG_H
+#define _DA9052_TSI_CFG_H
+
+/*--------------------------------------------------------------------------*/
+/* User Configurable parameters 					    */
+/*--------------------------------------------------------------------------*/
+/* To enable debug output for your module, set this to 1 */
+#define		DA9052_TSI_DEBUG	0
+
+/* DEFAULT_TSI_STATE:
+ * 0. TSI_AUTO_MODE 		continuosly measure coordinate data.
+ * 1. TSI_MANUAL_COORD_X	Manually Measure coordinate along X axis
+ * 2. TSI_MANUAL_COORD_Y	Manually Measure coordinate along Y axis
+ * 3. TSI_MANUAL_COORD_Z	Manually Measure coordinate along Z axis
+ * 4. TSI_MANUAL_SET		Measure one set of x, y & z coordinates
+ * 5. TSI_IDLE			TSI disabled
+ */
+#define AUTO_MODE		0
+#define MANUAL_COORD_X		1
+#define MANUAL_COORD_Y		2
+#define MANUAL_COORD_Z		3
+#define MANUAL_SET		4
+#define IDLE			5
+/* Assign a value to this macro from above defined TSI states */
+#define DEFAULT_TSI_STATE		AUTO_MODE
+
+/* da9052 TSI static configuration */
+/* TSI slot skip possible configurations are [0, 2, 5, 10, 30, 80, 130, 330]*/
+/* the TSI_SLOT_SKIP equal value [0, 1, 2, 3, 4, 5, 6, 7] */
+#define TSI_SLOT_SKIP_VALUE		0
+
+/* TSI delay possible configurations are [0, 1, 2, 4] */
+/* TSI_DELAY value is [0, 1, 2, 3] */
+#define TSI_DELAY_VALUE			3
+
+/* TSI Mode XYZP Mode = 0 and XP mode is 1 */
+#define TSI_MODE_VALUE			0
+
+/* 1: Enable average filtering, 0: Disable average filtering */
+#define ENABLE_AVERAGE_FILTER		1
+
+/* Default value for size of average filter */
+#define DEFAULT_AVERAGE_FILTER_SIZE	3
+
+/* 1: Enable window filtering, 0: Disable window filtering */
+#define ENABLE_WINDOW_FILTER		1
+
+/* Window Filter */ 
+#define TSI_X_WINDOW_SIZE		50
+#define TSI_Y_WINDOW_SIZE		50
+
+/* Number of raw data samples to be considered for */
+/* identifying first reference sample for window filter */
+/* Note: This macro cannot be assigned value less than or equal to 1 */
+#define SAMPLE_CNT_FOR_WIN_REF		3
+
+/* TSI sampling mode Economy mode = 0; Fast mode =1*/
+#define TSI_ECONOMY_MODE		0
+#define TSI_FAST_MODE			1
+/* set default TSI mode from above two modes */
+#define DEFAULT_TSI_SAMPLING_MODE	TSI_FAST_MODE
+
+/* TSI penup detecting interval in msec*/
+#define TS_PENUP_DETECT_INTERVEL	50
+
+/* Calibartion  Enable(1) / Disable(0) */
+#define TSI_USE_CALIBRATION   		1
+
+/* Touchscreen panel dimensions */
+#define TS_X_MIN	(0)
+#define TS_X_MAX	(1023)
+#define TS_Y_MIN	(0)
+#define TS_Y_MAX	(1023)
+
+/* Display panel dimensions */
+#define DISPLAY_X_MIN	(0)
+#define DISPLAY_X_MAX	(1023)
+#define DISPLAY_Y_MIN	(0)
+#define DISPLAY_Y_MAX	(1023)
+
+/* Use debounce */
+#define ENABLE_TSI_DEBOUNCE		0
+
+/* The number of samples to be considered for debouncing */
+#define TSI_DEBOUNCE_DATA_CNT		3
+
+/* manual conversion time out period in msec*/
+#define MANUAL_CONVERSION_TIME_OUT	5000
+
+/*--------------------------------------------------------------------------*/
+/* Internal Static configuration parameters                                 */
+/*--------------------------------------------------------------------------*/
+#define RELEASE
+
+/* Switch to enable or disable the profiling debug */
+#define DA9052_TSI_RAW_DATA_PROFILING		0
+#define DA9052_TSI_WIN_FLT_DATA_PROFILING  	0
+#define DA9052_TSI_AVG_FLT_DATA_PROFILING 	0
+#define DA9052_TSI_CALIB_DATA_PROFILING 	0
+#define DA9052_TSI_OS_DATA_PROFILING 		1
+
+/* Enable this macro to print debounced data */
+#define DA9052_TSI_PRINT_DEBOUNCED_DATA		0
+
+/* Enable this macro to print value  of last */
+/* processed valid window filter coordinate */
+#define DA9052_TSI_PRINT_PREVIOUS_DATA		0
+
+
+#if ENABLE_AVERAGE_FILTER
+#define TSI_AVERAGE_FILTER_SIZE		DEFAULT_AVERAGE_FILTER_SIZE
+#else
+#define TSI_AVERAGE_FILTER_SIZE			1
+#endif
+
+/* max number of samples in 1 sec. specific to DA9052. */
+#define TSI_FAST_MODE_SAMPLE_CNT		1000
+#define TSI_ECO_MODE_SAMPLE_CNT			100
+
+/* The number of samples to be read in one polling cycle */
+#define TSI_POLL_SAMPLE_CNT			10
+
+/*polling frequency for reading TSI data in Economy mode / Fast mode in ms*/
+#define TSI_FAST_MODE_REG_DATA_PROCESSING_INTERVAL	((1000 / TSI_FAST_MODE_SAMPLE_CNT)* TSI_POLL_SAMPLE_CNT)
+#define TSI_ECO_MODE_REG_DATA_PROCESSING_INTERVAL	((1000 / TSI_ECO_MODE_SAMPLE_CNT)* TSI_POLL_SAMPLE_CNT)
+
+/* Macro holds value to be assigned for reg data processing interval in msec */
+#if DEFAULT_TSI_SAMPLING_MODE
+#define DEFAULT_REG_DATA_PROCESSING_INTERVAL	TSI_FAST_MODE_REG_DATA_PROCESSING_INTERVAL
+#else
+#define DEFAULT_REG_DATA_PROCESSING_INTERVAL	TSI_ECO_MODE_REG_DATA_PROCESSING_INTERVAL
+#endif
+
+/* Size of buffer containing co-ordinates in REG format. */
+#define TSI_REG_DATA_BUF_SIZE 	(2 * TSI_POLL_SAMPLE_CNT)
+
+/* interval at which raw data is processed in msec */
+#define TSI_FAST_MODE_RAW_DATA_PROCESSING_INTERVAL		((1000 / TSI_FAST_MODE_SAMPLE_CNT) * (TSI_AVERAGE_FILTER_SIZE))
+#define TSI_ECO_MODE_RAW_DATA_PROCESSING_INTERVAL		((1000 / TSI_ECO_MODE_SAMPLE_CNT) * (TSI_AVERAGE_FILTER_SIZE))
+
+/* Macro holds value to be assigned for raw data processing interval */
+#if DEFAULT_TSI_SAMPLING_MODE
+#define DEFAULT_RAW_DATA_PROCESSING_INTERVAL	TSI_FAST_MODE_RAW_DATA_PROCESSING_INTERVAL
+#else
+#define DEFAULT_RAW_DATA_PROCESSING_INTERVAL	TSI_ECO_MODE_RAW_DATA_PROCESSING_INTERVAL
+#endif
+
+/* Size of buffer containing RAW data co-ordinates. */
+#define TSI_RAW_DATA_BUF_SIZE 	(TSI_REG_DATA_BUF_SIZE * ( (TSI_AVERAGE_FILTER_SIZE / TSI_POLL_SAMPLE_CNT) + 1))
+
+#endif //#ifndef _DA9052_TSI_CFG_H
diff -Naur linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_tsi_filter.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_tsi_filter.h
--- linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_tsi_filter.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_tsi_filter.h	2010-05-18 18:27:40.000000000 +0500
@@ -0,0 +1,108 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_tsi_filter.h: tsi driver configuration file for DA9052
+ *
+ * This file defines tsi filter related structures.
+ *
+ * History:
+ *
+ * (11/06/2009):	This file contains the tsi filter related definitions.
+ *
+ * (27/04/2010):	Updated for Linux Community release.
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+#ifndef __TS_FILTER_H__
+#define __TS_FILTER_H__
+
+/*
+ * Touchscreen filter.
+ *
+ * 
+ */
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+#include <linux/mfd/da9052/da9052_tsi_cfg.h>
+
+/*--------------------------------------------------------------------------*/
+/* Local Macro Definitions                                                  */
+/*--------------------------------------------------------------------------*/
+/*--------------------------------------------------------------------------*/
+/* Type Definitions                                                         */
+/*--------------------------------------------------------------------------*/
+/**
+ * \struct da9052_tsi_data - Structure description
+ * @var x:		X co-ordinate
+ * @var y:		Y co-ordinate
+ * @var z:		Z co-ordinate
+ */
+ typedef struct {
+ 	s16	x;
+	s16	y;
+	s16	z;
+}da9052_tsi_data;
+
+/**
+ * \struct da9052_tsi_raw_fifo - Structure description
+ * Description: This structure comprises of elements relevant to data
+ *		 FIFO that stores data from EH. This data is in the same 
+ *		format as that read from the DA9052 hardware.
+ *
+ * @lock:	semaphore to serialise FIFO access.
+ * @head:	Index of head of the FIFO.
+ * @tail:	Index of tail of the FIFO.
+ * @data:	array to store data.
+ */
+typedef struct {
+	struct semaphore 	lock;
+	s32		 	head;
+	s32 			tail;
+	da9052_tsi_data		data[TSI_RAW_DATA_BUF_SIZE];
+}da9052_tsi_raw_fifo;
+
+/**
+ * \struct tsi_thread_type - Structure description
+ *
+ * @pid:	process id of this thread.
+ * @state:	state of the thread, ACTIVE or INACTIVE.
+ * @notifier:	Thread notifier for the OS.
+ */
+typedef struct {
+	u8 			pid;
+	u8 			state;
+	struct completion 	notifier;
+} tsi_thread_type;
+
+/* State for TSI thread */
+#define	ACTIVE		0
+#define	INACTIVE	1
+
+
+/*--------------------------------------------------------------------------*/
+/* Global Functions                                                          */
+/*--------------------------------------------------------------------------*/
+void __init da9052_init_tsi_fifos (void);
+
+void clean_tsi_fifos(void);
+
+u32 get_reg_data_cnt (void);
+
+u32 get_reg_free_space_cnt(void);
+
+void da9052_tsi_process_reg_data(void);
+
+/*--------------------------------------------------------------------------*/
+/* Other Functions                                                          */
+/*--------------------------------------------------------------------------*/
+extern u32 da9052_tsi_get_input_dev(u8 off);
+
+
+#endif	//__TS_FILTER_H__
diff -Naur linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_tsi.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_tsi.h
--- linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_tsi.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_tsi.h	2010-05-18 18:27:40.000000000 +0500
@@ -0,0 +1,551 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_tsi.h: tsi driver file for DA9052
+ *
+ * This file declares global functions and defines macros 
+ * used for DA9052 TSI driver.
+ *
+ * History:
+ *
+ * (11/06/2009):	This file holds all the data types & macro definitions 
+ *			related to the DA9052 TSI driver.
+ *
+ * (27/04/2010):	Updated for Linux Community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+
+#ifndef _DA9052_TSI_H
+#define _DA9052_TSI_H
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Local Macro Definitions                                                  */
+/*--------------------------------------------------------------------------*/
+#define TSI_INPUT_DEVICE_OFF		0
+#define NUM_INPUT_DEVS			1
+
+#define DA9052_VENDOR_ID		0xAAAA
+#define DA9052_PRODUCT_ID		0x5555
+
+#define DA9052_TSI_DEVICE_NAME		"da9052_tsi"
+#define DA9052_TSI_INPUT_DEV		DA9052_TSI_DEVICE_NAME
+
+
+
+/* LDO to which TSI_REF is connected, LDO is defined in Power Manager */
+#define DA9052_TSI_REF_SOURCE		LDO_9
+
+
+/* Following macros define TSI control regsiter bit values */
+#define DA9052_TCA_AUTO_TSI_ENABLE		(1<<0)
+#define DA9052_TCA_PEN_DET_ENABLE		(1<<1)
+#define DA9052_TCA_TSI_XP_MODE_ENABLE		(1<<2)
+
+#define DA9052_TCA_TSI_DELAY_0SLOTS		(0<<6)
+#define DA9052_TCA_TSI_DELAY_2SLOTS		(2<<6)
+#define DA9052_TCA_TSI_DELAY_4SLOTS		(3<<6)
+
+#define DA9052_TCA_TSI_SEL_XPLUS		(1<<0)
+#define DA9052_TCA_TSI_SEL_XMINUS		(1<<1)
+#define DA9052_TCA_TSI_SEL_YPLUS		(1<<2)
+#define DA9052_TCA_TSI_SEL_YMINUS		(1<<3)
+
+#define DA9052_TCA_TSI_MUX_XPLUS_ROUTED_ADCIN7		(0<<4)
+#define DA9052_TCA_TSI_MUX_YPLUS_ROUTED_ADCIN7		(1<<4)
+#define DA9052_TCA_TSI_MUX_XMINUS_ROUTED_ADCIN7		(2<<4)
+#define DA9052_TCA_TSI_MUX_YMINUS_ROUTED_ADCIN7		(3<<4)
+
+#define DA9052_TCA_TSI_MAN_ENABLE		(1<<6)
+#define DA9052_TCA_TSI_SET_TSIREF		(0<<7)
+#define DA9052_TCA_TSI_SET_XY_REF		(1<<7)
+
+#define DA9052_EVETN_B_E_PEN_DOWN		(1<<6)
+#define DA9052_EVENT_B_E_TSI_READY		(1<<7)
+
+#define DA9052_IRQMASK_B_PENDOWN_MASK   	(1<<6)
+#define DA9052_IRQMASK_B_TSI_READY_MASK 	(1<<7)
+
+#define X_LSB_SHIFT 	(0)
+#define Y_LSB_SHIFT 	(2)
+#define Z_LSB_SHIFT 	(4)
+#define PEN_DET_SHIFT 	(6)
+#define X_MSB_SHIFT	(2)
+#define Y_MSB_SHIFT	(2)
+#define Z_MSB_SHIFT	(2)
+#define  X_LSB_MASK	(11 << X_LSB_SHIFT)
+#define  Y_LSB_MASK	(11 << Y_LSB_SHIFT)
+#define  Z_LSB_MASK	(11 << Z_LSB_SHIFT)
+#define  PEN_DET_MASK	(11 << PEN_DET_SHIFT)
+
+#define MAX_SSC_MSG_SIZE	10
+
+#undef DA9052_DEBUG
+#if DA9052_TSI_DEBUG
+#define DA9052_DEBUG( fmt, args... ) printk( KERN_CRIT "" fmt, ##args )
+#else
+#define DA9052_DEBUG( fmt, args... )
+#endif
+
+/* IOCTL commands for TSI */
+#define DA9052_TSI_SET_SAMPLING_MODE		(1)
+#define DA9052_TSI_CONFIG_DELAY		   	(2)
+#define DA9052_TSI_CONFIG_SLOT_SKIP	   	(3)
+#define DA9052_TSI_MEASURE_MANUAL_DATA	   	(4)
+#define DA9052_TSI_SET_CALIB_MATRIX	   	(5)
+#define DA9052_TSI_GET_TSI_CONFIG		(6)
+#define DA9052_TSI_GET_CALIB_CONFIG		(7)
+#define DA9052_TSI_SET_CALIB_CONFIG		(8)
+#define DA9052_TSI_MEASURE_SEQ			(9)
+#define DA9052_TSI_SET_DEVICE_STATE		(10)
+
+#define DA9052_TSI_CONFIG_PEN_DET		(11)
+#define DA9052_TSI_REG_PENDWN_EH	   	(12)
+#define DA9052_TSI_UNREG_PENDWN_EH	   	(13)
+#define DA9052_TSI_DISABLE_IRQ			(14)
+#define DA9052_TSI_ENABLE_IRQ			(15)
+#define DA9052_TSI_POWER_CONTROL		(16)
+#define DA9052_TSI_SET_MANUAL_AXIS		(17)
+#define DA9052_TSI_GET_DEVICE_STATE		(18)
+#define DA9052_TSI_SET_GPIO_PINS		(19)
+
+
+/* Calibration */
+/* Number of points over which data was gathered */
+#define NUM_CALIB_SAMPLES		3
+
+/* Offsets in calibration array of respective co-ordinates */
+#define DISPLAY_DATA_OFFSET		0
+#define TS_DATA_OFFSET			1
+
+/* Types of co-ordinate samples, */
+/* 2 in this case: display co-ordinates & TS co-ordinates */
+#define	NUM_OF_SAMPLE_TYPES			2
+
+/* Maximum value tsi delay can have */
+#define MAX_TSI_DELAY			TSI_DELAY_4SLOTS
+
+/* Maximum value tsi skip can have */
+#define MAX_TSI_SKIP_SLOT		TSI_SKIP_330SLOTS
+
+/*--------------------------------------------------------------------------*/
+/* Type Definitions                                                         */
+/*--------------------------------------------------------------------------*/
+/* ADC_MODE: Sampling rate for ADC module */
+/* ECONOMY_MODE = 1 sample / 10msec */
+/* FAST_MODE = 1 sample / msec */
+enum ADC_MODE {
+
+	ECONOMY_MODE = 0,
+	FAST_MODE = 1
+};
+
+/* TSI_DELAY: delay between TSI coordinate measurements, in slots */
+enum TSI_DELAY {
+	TSI_DELAY_0SLOTS = 0,
+	TSI_DELAY_1SLOTS = 1,
+	TSI_DELAY_2SLOTS = 2,
+	TSI_DELAY_4SLOTS = 3
+};
+
+/* TSI_SLOT_SKIP: Number of slots to be skipped between */
+/*  			measurements of TSI coordinate sets */
+enum TSI_SLOT_SKIP{
+	TSI_SKIP_0SLOTS = 0,
+	TSI_SKIP_2SLOTS = 1,
+	TSI_SKIP_5SLOTS = 2,
+	TSI_SKIP_10SLOTS = 3,
+	TSI_SKIP_30SLOTS = 4,
+	TSI_SKIP_80SLOTS = 5,
+	TSI_SKIP_130SLOTS = 6, 
+	TSI_SKIP_330SLOTS = 7 
+};
+
+/* TSI_MUX_SEL: Input lines to TSI multiplexer. */
+enum TSI_MUX_SEL
+{
+	TSI_MUX_XPLUS	= 0,
+	TSI_MUX_YPLUS 	= 1,
+	TSI_MUX_XMINUS	= 2,
+	TSI_MUX_YMINUS	= 3
+};
+
+/* TSI_IRQ: DA9052 interrupts for TSI */
+/* TSI_PEN_DWN: Pen down Interrupt. */
+/* TSI_DATA_RDY: TSI Coordinates ready to be read Interrupt. */
+enum TSI_IRQ{
+	TSI_PEN_DWN,
+	TSI_DATA_RDY
+};
+
+/* TSI_COORDINATE: TSI coordinate axes */
+enum TSI_COORDINATE{
+	X_COORDINATE,
+	Y_COORDINATE,
+	Z_COORDINATE
+};
+
+/* TSI_MODE: TSI conversion sequence */
+/* XYZP_MODE = X, Y & Z coordinates are measured */
+/* XP_MODE = Only X coordinate is measured */
+enum TSI_MEASURE_SEQ{
+	XYZP_MODE,
+	XP_MODE
+};
+
+/**
+ * \enum TSI_STATE
+ * 0. TSI_AUTO_MODE 		continuosly measure coordinate data.
+ * 1. TSI_MANUAL_COORD_X	Manually Measure coordinate along X axis.
+ * 2. TSI_MANUAL_COORD_Y	Manually Measure coordinate along Y axis.
+ * 3. TSI_MANUAL_COORD_Z	Manually Measure coordinate along Z axis.
+ * 4. TSI_MANUAL_SET		Measure one set of x, y & z coordinates.
+ * 5. TSI_IDLE			TSI disabled
+ */
+enum TSI_STATE {
+	TSI_AUTO_MODE,
+	TSI_MANUAL_COORD_X,
+	TSI_MANUAL_COORD_Y,
+	TSI_MANUAL_COORD_Z,
+	TSI_MANUAL_SET,
+	TSI_IDLE
+};
+
+/**
+ * \union da9052_tsi_cont_reg - Structure description
+ * @var da9052_tsi_cont_a: 	Byte access for TSI control reg A
+ * @var tsi_cont_a:		Bitwise access for TSI control reg A
+ * 	- \var auto_tsi_en	enable or disable auto TSI Measurement
+ *	- \var pen_det_en	enable or disable pen detection mechanism
+ *	- \var tsi_mode	 	Automatic measure sequence: XP, XYZP mode
+ *	- \var tsi_skip		Delay between Two tsi measurments
+ *	- \var tsi_delay	Settling Delay before new measuremnt
+ */
+ typedef union{
+	u8 da9052_tsi_cont_a;
+	struct{
+		u8 auto_tsi_en:1;
+		u8 pen_det_en:1;
+		u8 tsi_mode:1;
+		u8 tsi_skip:3;
+		u8 tsi_delay:2;
+	}tsi_cont_a;
+	
+ }da9052_tsi_cont_reg; 
+
+/**
+ * \union da9052_tsi_man_cont_reg - Structure description
+ * @var da9052_tsi_cont_b:		Byte access for TSI control reg B
+ * @var tsi_cont_b:		Bitwise access for TSI control reg B
+ *	- \var tsi_sel_0		 X+ switch open / close
+ *	- \var tsi_sel_1		 X- switch open / close
+ *	- \var tsi_sel_2		 Y+ switch open / close
+ *	- \var tsi_sel_3		 Y- switch open / close
+ *	- \var tsi_mux		 XY Routing Select
+ *	- \var tsi_man		 Start / stop Man conf
+ *	- \var tsi_adc_ref	adc reference selection
+ */
+typedef union{
+	u8 da9052_tsi_cont_b;
+	struct{
+		u8 tsi_sel_0:1;
+		u8 tsi_sel_1:1;
+		u8 tsi_sel_2:1;
+		u8 tsi_sel_3:1;
+		u8 tsi_mux:2;
+		u8 tsi_man:1;
+		u8 tsi_adc_ref:1;
+	}tsi_cont_b;
+ }da9052_tsi_man_cont_reg;
+
+ /**
+ *\struct da9052_tsi_conf - Structure description
+ * \var auto_cont:		DA9052 TSI control Register A
+ * \var man_cont:		DA9052 TSI control Register B
+ * \var tsi_adc_sample_intervel	tsi sample mode: 0- Ecnomy, 1- SPEED mode
+ * \var tsi_status		Enable / Disable
+ * \var ldo9_en			Enable / Disable
+ * \var ldo9_conf		Power immediate change
+ * \var tsi_ready_irq_mask	interrupt mask: 0: irq_enable, 1: irq_disable
+ * \var tsi_pendown_irq_mask	interrupt mask: 0: irq_enable, 1: irq_disable
+ */
+ typedef struct{
+	da9052_tsi_cont_reg		auto_cont;
+	da9052_tsi_man_cont_reg		man_cont;
+	u8 				tsi_adc_sample_intervel:1;
+	enum TSI_STATE 			state;
+	u8 				ldo9_en:1;
+	u8 				ldo9_conf:1;
+	u8 				tsi_ready_irq_mask:1;
+	u8 				tsi_pendown_irq_mask:1;
+ }da9052_tsi_conf;
+ 
+/**
+ * \struct da9052_tsi_ioctl_data - Structure description
+ * da9052_tsi_conf *tsi_conf	TSI configuaration pointer
+ * da9052_tsi_data *tsi_data	return pointer for manually measured data
+ * calib_cfg_t *calib		pointer to calibration configuration
+ * da9052_tsi_data **calib_arr	array of pointers to 
+ *				calibration data.
+ * u8	pen_det			pen detection flag.
+ * u8	seq			TSI measurement sequence.
+ * u8	interval		sampling interval.
+ * u8   pwr			State of TSI power supply: ENABLE or DISABLE.
+ * enum TSI_MEASURE_SEQ	seq	TSI measurement sequence.
+ * enum TSI_DELAY delay		TSI delay info.
+ * enum TSI_SLOT_SKIP skip	TSI skip info.
+ * enum TSI_IRQ tsi_irq		TSI interrupts id.
+ * enum TSI_STATE		TSI measurement state
+ * enum TSI_COORDINATE		Coordinate axis along which manual 
+ *				measurements are to be made.
+ */
+ typedef struct {
+	da9052_tsi_conf 		*tsi_conf;
+	da9052_tsi_data 		*tsi_data;
+	calib_cfg_t 			*calib;
+	da9052_tsi_data 		*calib_arr;
+	u8				pen_det;
+	u8				interval;
+	u8				pwr;
+	enum TSI_MEASURE_SEQ		seq;
+	enum TSI_DELAY 			delay;
+	enum TSI_SLOT_SKIP 		skip;
+	enum TSI_IRQ 			tsi_irq;
+	enum TSI_STATE			tsi_state;
+	enum TSI_STATE*			get_tsi_state;
+	enum TSI_COORDINATE		axis;
+} da9052_tsi_ioctl_data;
+
+/**
+ * \struct da9052_tsi_reg_fifo - Structure description
+ * Description: This structure comprises of elements relevant to data
+ *		 FIFO that stores data from EH. This data is in the same 
+ *		format as that read from the DA9052 hardware.
+ *
+ * @lock:	semaphore to serialise FIFO access.
+ * @head:	Index of head of the FIFO.
+ * @tail:	Index of tail of the FIFO.
+ * @data:	array to store data.
+ */
+typedef struct {
+	struct semaphore	lock;
+	s32			head;
+	s32 			tail;
+	da9052_tsi_reg		data[TSI_REG_DATA_BUF_SIZE];
+} da9052_tsi_reg_fifo;
+ 
+ /**
+ * \struct da9052_tsi_info - Structure description
+ * @input_dev:		To Register with Linux infrastructure as input device
+ * @completion:		To get the kernel thread completion status
+ * @tsi_conf:		Configuration details for da9052 TSI
+ * @tsi_calib		Calibration details for TSI
+ * @timer			Handler to Timer
+ * @tsi_data_poll_interval	Timer interval to poll EH module for data in ms  
+ * @tsi_penup_count		Number of zero data counts required to declare the penup.
+ * @tsi_zero_data_cnt		Number of times we receive zero data from EH.
+ * @pen_dwn_event		TSI Pen Down event status
+ * @tsi_rdy_event		TSI Ready Event
+ * @pd_nb		EH notifier block to register TSI pen down handler
+ * @pd_reg_status	status of Pen down handler registeration.
+ */
+ typedef struct {
+	struct input_dev*	input_devs[NUM_INPUT_DEVS];
+	da9052_tsi_conf  	tsi_conf;
+	calib_cfg_t*		tsi_calib;
+	u32 			tsi_data_poll_interval;
+	u32			tsi_penup_count;
+	u32			tsi_zero_data_cnt;
+	u8			pen_dwn_event;
+	u8			tsi_rdy_event;
+	da9052_eh_nb 		pd_nb;
+	u8			pd_reg_status;	
+ }da9052_tsi_info; 
+ 
+ 
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+da9052_tsi_info gda9052_tsi_info;
+
+/*--------------------------------------------------------------------------*/
+/* Inline Functions                                                         */
+/*--------------------------------------------------------------------------*/
+static inline u8  mask_pendwn_irq(u8 val)
+{ 
+	return (val |= DA9052_IRQMASKB_MPENDOWN);
+}
+
+static inline u8  unmask_pendwn_irq(u8 val)
+{ 
+	return (val &= ~DA9052_IRQMASKB_MPENDOWN);
+}
+
+static inline u8  mask_tsi_rdy_irq(u8 val) 
+{
+	return (val |=DA9052_IRQMASKB_MTSIREADY);
+}
+
+static inline u8  unmask_tsi_rdy_irq(u8 val)
+{ 
+	return (val &= ~DA9052_IRQMASKB_MTSIREADY);
+}
+
+static inline u8  enable_ldo9(u8 val) 
+{
+	return (val |=DA9052_LDO9_LDO9EN);
+}
+
+static inline u8  disable_ldo9(u8 val)
+{
+	return (val &= ~DA9052_LDO9_LDO9EN);
+} 
+
+static inline u8  set_auto_tsi_en(u8 val)
+{
+	return (val |=DA9052_TSICONTA_AUTOTSIEN);
+}
+
+static inline u8  reset_auto_tsi_en(u8 val)
+{
+	return (val &=~DA9052_TSICONTA_AUTOTSIEN);
+}
+
+static inline u8  enable_pen_detect(u8 val)
+{
+	return (val |=DA9052_TSICONTA_PENDETEN);
+}
+
+static inline u8  disable_pen_detect(u8 val) 
+{
+	return (val &=~DA9052_TSICONTA_PENDETEN);
+}
+
+static inline u8  enable_xyzp_mode(u8 val)
+{
+	return (val &= ~DA9052_TSICONTA_TSIMODE);
+}
+
+static inline u8  enable_xp_mode(u8 val)
+{
+	return(val |= DA9052_TSICONTA_TSIMODE);
+}
+
+static inline u8  enable_tsi_manual_mode(u8 val)
+{
+	return(val |= DA9052_TSICONTB_TSIMAN);
+}
+
+static inline u8  disable_tsi_manual_mode(u8 val)
+{
+	return(val &= ~DA9052_TSICONTB_TSIMAN);
+}
+
+static inline u8 tsi_sel_xplus_close(u8 val)
+{
+	return(val |= DA9052_TSICONTB_TSISEL0);
+}
+
+static inline u8 tsi_sel_xplus_open(u8 val)
+{
+	return(val &= ~DA9052_TSICONTB_TSISEL0);
+}
+
+static inline u8 tsi_sel_xminus_close(u8 val)
+{
+	return(val |= DA9052_TSICONTB_TSISEL1);
+}
+
+static inline u8 tsi_sel_xminus_open(u8 val)
+{
+	return(val &= ~DA9052_TSICONTB_TSISEL1);
+}
+
+static inline u8 tsi_sel_yplus_close(u8 val)
+{
+	return(val |= DA9052_TSICONTB_TSISEL2);
+}
+
+static inline u8 tsi_sel_yplus_open(u8 val)
+{
+	return(val &= ~DA9052_TSICONTB_TSISEL2);
+}
+
+static inline u8 tsi_sel_yminus_close(u8 val)
+{
+	return(val |= DA9052_TSICONTB_TSISEL3);
+}
+
+static inline u8 tsi_sel_yminus_open(u8 val)
+{
+	return(val &= ~DA9052_TSICONTB_TSISEL3);
+}
+
+static inline u8 adc_mode_economy_mode(u8 val)
+{
+	return(val &= ~DA9052_ADCCONT_ADCMODE);
+}
+
+static inline u8 adc_mode_fast_mode(u8 val)
+{
+	return(val |= DA9052_ADCCONT_ADCMODE);
+}
+
+/*--------------------------------------------------------------------------*/
+/* Other Functions                                                          */
+/*--------------------------------------------------------------------------*/
+ssize_t da9052_tsi_config_delay(enum TSI_DELAY delay);
+
+ssize_t da9052_tsi_config_measure_seq(enum TSI_MEASURE_SEQ seq);
+
+ssize_t da9052_tsi_config_state(enum TSI_STATE state);
+
+ssize_t da9052_tsi_set_sampling_mode(u8 interval);
+
+ssize_t da9052_tsi_config_skip_slots(enum TSI_SLOT_SKIP skip);
+
+ssize_t da9052_config_tsi_delay(enum TSI_DELAY delay);
+
+ssize_t da9052_tsi_get_manual_measurement(da9052_tsi_data* data_buf);
+
+int da9052_tsi_get_calib_display_point( da9052_tsi_data* display);
+
+enum TSI_STATE da9052_tsi_get_drv_state(void);
+
+
+/*--------------------------------------------------------------------------*/
+/* Compile time error checks                                                */
+/*--------------------------------------------------------------------------*/
+#if (SAMPLE_CNT_FOR_WIN_REF <= 1)
+#error "SAMPLE_CNT_FOR_WIN_REF cannot be less than or equal to 1"
+#endif
+
+#if (DEFAULT_TSI_STATE > 5)
+#error "DEFAULT_TSI_STATE cannot be assigned value greater than 5"
+#endif
+
+#if (TSI_SLOT_SKIP_VALUE > 7)
+#error "TSI_SLOT_SKIP_VALUE cannot be assigned value greater than 7"
+#endif
+
+#if (TSI_DELAY_VALUE > 3)
+#error "TSI_DELAY_VALUE cannot be assigned value greater than 3"
+#endif
+
+#if (TSI_MODE_VALUE > 1)
+#error "TSI_DELAY_VALUE cannot be assigned value greater than 1"
+#endif
+
+
+#endif /* _DA9052_TSI_H */
+
Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.
