Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0ESJQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:16:28 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:36498 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab0ESJQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:16:22 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] MFD of DA9052 Linux device drivers (1/9)
Date: Wed, 19 May 2010 10:16:10 +0100
Message-ID: <3495EC08FA53E94AAA00CC4743D5BA7E010C20EB@pandora.diasemi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] MFD of DA9052 Linux device drivers (1/9)
Thread-Index: Acr3M+u75qeFStVUQ9CwD+2uqhXGjA==
From: "David Dajun Chen" <Dajun.Chen@diasemi.com>
To: <linux-kernel@vger.kernel.org>
Cc: <sameo@linux.intel.com>
X-OriginalArrivalTime: 19 May 2010 09:16:15.0029 (UTC) FILETIME=[EE80C650:01CAF733]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear sir/madam,

The attached is the MFD part of the device drivers newly developed for DA9052 Power Management IC from Dialog Semiconductor.

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

diff -Naur linux-2.6.33.2/drivers/mfd/da9052_adc.c linux-2.6.33.2_patch/drivers/mfd/da9052_adc.c
--- linux-2.6.33.2/drivers/mfd/da9052_adc.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/mfd/da9052_adc.c	2010-05-18 15:29:36.000000000 +0500
@@ -0,0 +1,1810 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_adc.c: ADC driver for DA9052
+ *
+ * History:
+ *
+ * (05/08/2009):	Initial version
+ * (05/22/2009):	Changes as per code review done
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
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <asm/uaccess.h>
+#include <linux/platform_device.h>
+
+#ifndef CONFIG_ARCH_S3C64XX
+#include <linux/syscalls.h>
+#endif
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+#include <linux/mfd/da9052/da9052_reg.h>
+#include <linux/mfd/da9052/da9052_lib.h>
+#include <linux/mfd/da9052/da9052_adc.h>
+#include <linux/mfd/da9052/da9052_eh.h>
+
+/*--------------------------------------------------------------------------*/
+/* Local Type Definitions                                                   */
+/*--------------------------------------------------------------------------*/
+
+
+/*--------------------------------------------------------------------------*/
+/* Local Constant Definitions                                               */
+/*--------------------------------------------------------------------------*/
+static u8 banner[] __initdata = "DA9052 ADC Driver, v1.0\n";
+
+
+/*--------------------------------------------------------------------------*/
+/* Local Macro Definitions                                                  */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Local Structure Definitions                                              */
+/*--------------------------------------------------------------------------*/
+ 
+/**
+ * struct adc_mode_status_t - Stores the status of mode selected for the ADC 
+ *			    channel.
+ * @adc_vddout	: Mode status for channel 0 VDDOUT.
+ * @adc_ich	: Mode status for channel 1 ICH.
+ * @adc_tbat	: Mode status for channel 2 TBAT.
+ * @adc_vbat	: Mode status for channel 3 VBAT.
+ * @adc_in4	: Mode status for channel 4 ADC_IN4.
+ * @adc_in5	: Mode status for channel 5 ADC_IN5.
+ * @adc_in6	: Mode status for channel 6 ADC_IN6.
+ * @adc_tsi	: Mode status for channel 7 XY– TSI
+ * @adc_tsense	: Mode status for channel 8 Internal Tjunc.
+ * @adc_vbbat	: Mode status for channel 9 VBBAT.
+ */
+ 
+typedef struct {
+	u32 adc_vddout	:1;
+	u32 adc_ich	:1;
+	u32 adc_tbat	:1;
+	u32 adc_vbat	:1;
+	u32 adc_in4	:1;
+	u32 adc_in5	:1;
+	u32 adc_in6	:1;
+	u32 adc_tsi	:1;
+	u32 adc_tsense	:1;
+	u32 adc_vbbat	:1;
+	u32 dummy	:22;
+} adc_mode_status_t;
+
+/**
+ * struct eh_registration_status_t - Interrupt registration status with EH
+ * @adc4_event		: States whether ADC4 interrupt is registered with EH
+ * @adc5_event		: States whether ADC5 interrupt is registered with EH
+ * @adc6_event		: States whether ADC6 interrupt is registered with EH
+ * @comp_1v2_event	: States whether COMP1V2 interrupt is registered with EH
+ *
+ */
+typedef struct {
+	u8 adc4_event		:1;
+	u8 adc5_event		:1;
+	u8 adc6_event		:1;
+	u8 comp_1v2_event	:1;
+	u8 dummy		:4; 
+} eh_registration_status_t;
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+/* Stores the state of ADC driver */
+static u8 adc_device_open = 0;
+/* Major number for ADC driver */
+static s32 adc_major_number = 0;
+/* Mutex for ADC manual conversion */
+struct mutex da9052_adc_manconv_lock;
+/* Structure to store the mode status */
+static adc_mode_status_t adc_mode_status;
+static struct platform_device *da9052_adc_platform_device;
+static struct fasync_struct *adc_fasync_queue;
+
+/* States whether a particular event is registered with EH */
+static eh_registration_status_t is_eh_registered;
+
+/* EH structures for all possible events */
+da9052_eh_nb adc4_eh_data;
+da9052_eh_nb adc5_eh_data;
+da9052_eh_nb adc6_eh_data;
+da9052_eh_nb comp_1v2_eh_data;
+
+/* Storing the event status for multiple event handling */
+static adc_event_occ_status_t adc_event_occ_status;
+
+/* Mutex erquired for protecting the access to the event occurance status */
+struct mutex adc_event_occ_lock;
+
+/*--------------------------------------------------------------------------*/
+/* Local Functions                                                          */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * da9052_manual_read	:
+ *			This function is local to ADC module and it reads the
+ * 			data from ADC manual conversion registers. Manual 
+ *			conversion register is also accessed by TSI module, so
+ *			mutex is used to make sure that no unathorised access 
+ *			to this register is made.
+ * 
+ * @param channel 	- This parameter gives the channel number to be read
+ * @param *data		- This is pointer to location where data is to written
+ *
+ * @return status:  
+ *	ADC_SSC_BUS_ERROR - If there is an error on the SSC bus.
+ *	SUCCESS		  - On successful completion of the call.
+ */  
+static s32 da9052_manual_read(u8 channel, u16 *data)
+{
+	u8 man_timeout_cnt = MAX_MANCONV_RETRY_COUNT;
+	da9052_ssc_msg msg;
+	u16 calc_data;
+	/* lock mutex */
+	mutex_lock(&da9052_adc_manconv_lock);
+	
+	msg.addr = DA9052_ADCMAN_REG;
+	msg.data = channel;
+	msg.data = set_bits(msg.data, DA9052_ADCMAN_MANCONV);
+	/* Write data to start manual conversion */
+	if (SUCCESS != da9052_ssc_write(&msg)){
+		mutex_unlock(&da9052_adc_manconv_lock);
+		return (ADC_SSC_BUS_ERROR);
+	}
+
+	/* Wait for the event */
+	do {
+		/* Read Sampling interval timer */
+		msg.addr = DA9052_ADCCONT_REG;
+		if (SUCCESS != da9052_ssc_read(&msg)){
+			mutex_unlock(&da9052_adc_manconv_lock);
+			return (ADC_SSC_BUS_ERROR);
+		}
+		
+		if (DA9052_ADCCONT_ADCMODE & msg.data) {
+			/* ADC sampling interval time is 1msec */
+			msleep (1);
+		} else {
+			/* ADC sampling interval time is 10msec */
+			msleep (10);
+		}
+
+		msg.addr = DA9052_ADCMAN_REG;
+		/* read data to start manual conversion */
+		if (SUCCESS != da9052_ssc_read(&msg)){
+			mutex_unlock(&da9052_adc_manconv_lock);
+			return (ADC_SSC_BUS_ERROR);
+		}
+		
+		/* Counter to avoid endless while loop */
+		man_timeout_cnt --;
+		if(man_timeout_cnt == 1){
+			if (!(msg.data & DA9052_ADCMAN_MANCONV)) {
+				break;
+			} else {
+				mutex_unlock(&da9052_adc_manconv_lock);
+				return (ADC_MANCONV_TIMEOUT_ERROR);
+			}
+		}
+	/* Wait until the MAN_CONV bit is cleared to zero */
+	} while(msg.data & DA9052_ADCMAN_MANCONV);
+	
+	msg.addr = DA9052_ADCRESH_REG; /* Read MSB data */
+	if (SUCCESS != da9052_ssc_read(&msg)){
+		mutex_unlock(&da9052_adc_manconv_lock);
+		return (ADC_SSC_BUS_ERROR);
+	}
+	calc_data = (u16)msg.data;
+	*data = (calc_data << 2);
+
+	DA9052_DEBUG("ADCRESH_REG data = %x\n", *data);
+	DA9052_DEBUG("ADCRESH_REG msg.data = %x\n", msg.data);
+	
+	msg.addr = DA9052_ADCRESL_REG; /* Read LSB data */
+	if (SUCCESS != da9052_ssc_read(&msg)){
+		mutex_unlock(&da9052_adc_manconv_lock);
+		return (ADC_SSC_BUS_ERROR);
+	}
+	/* Clear first 14 bits before ORing */
+	calc_data = (u16)msg.data & 0x0003;
+	*data |= calc_data;
+
+	DA9052_DEBUG("ADCRESL_REG data = %x\n", *data);
+	DA9052_DEBUG("ADCRESL_REG msg.data = %x\n", msg.data);
+	/* unlock mutex */
+	mutex_unlock(&da9052_adc_manconv_lock);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_adc_hw_init: This function initializes the hardware for ADC module/
+ * 
+ * @param void
+ * @return 
+ *	ADC_SSC_BUS_ERROR - If there is an error on the SSC bus.
+ *	SUCCESS		  - On successful completion of the call.
+ */
+static s32 da9052_adc_hw_init(void)
+{
+	da9052_ssc_msg msg;
+
+	/* Initialize the ADC pins */
+	/* ADC channel 4 and 5 are by default enabled */
+#if (ADC_CONF_ADC4)
+	/* For channel 4 */
+	msg.addr = DA9052_GPIO0001_REG;
+	/* Read previous contents of the GPIO_0-1 register */
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (ADC_SSC_BUS_ERROR);
+	/* Set the Pin functionality */
+	msg.data = clear_bits(msg.data, DA9052_GPIO0001_GPIO0PIN);
+	/* Write back the GPIO_0-1 register data */
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (ADC_SSC_BUS_ERROR);
+#endif /* ADC_CONF_ADC4 */
+#if (ADC_CONF_ADC5)
+	/* For channel 5 */
+	msg.addr = DA9052_GPIO0001_REG;
+	/* Read previous contents of the GPIO_0-1 register */
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (ADC_SSC_BUS_ERROR);
+	/* Set the Pin functionality */
+	msg.data = clear_bits(msg.data, DA9052_GPIO0001_GPIO1PIN);
+	/* Write back the GPIO_0-1 register data */
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (ADC_SSC_BUS_ERROR);
+#endif /* ADC_CONF_ADC5 */
+#if (ADC_CONF_ADC6)
+	/* For channel 6 */
+	msg.addr = DA9052_GPIO0203_REG;
+	/* Read previous contents of the GPIO_0-1 register */
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (ADC_SSC_BUS_ERROR);
+	/* Set the Pin functionality */
+	msg.data = clear_bits(msg.data, DA9052_GPIO0203_GPIO2PIN);
+	/* Write back the GPIO_0-1 register data */
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (ADC_SSC_BUS_ERROR);
+#endif /* ADC_CONF_ADC6 */
+
+	/* By default configure the Measurement sequence interval to 1ms */
+	msg.addr = DA9052_ADCCONT_REG; 
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (ADC_SSC_BUS_ERROR);
+	/* Set the ADC MODE bit for 1msec sampling timer */
+	msg.data = set_bits(msg.data, DA9052_ADCCONT_ADCMODE);
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (ADC_SSC_BUS_ERROR);
+
+	/* By default configure ADC channel to auto mode */
+	adc_mode_status.adc_vddout 	= AUTO_MODE;
+	adc_mode_status.adc_ich 	= AUTO_MODE;
+	adc_mode_status.adc_tbat 	= AUTO_MODE; 
+	adc_mode_status.adc_vbat 	= MANUAL_MODE;
+	adc_mode_status.adc_in4 	= AUTO_MODE;
+	adc_mode_status.adc_in5 	= AUTO_MODE;
+	adc_mode_status.adc_in6 	= AUTO_MODE;
+	adc_mode_status.adc_tsense 	= AUTO_MODE;
+	adc_mode_status.adc_vbbat 	= MANUAL_MODE;
+
+	/* Initialize mutex required for ADC Manual read */
+	mutex_init(&da9052_adc_manconv_lock);
+
+	/* Initialize mutex for ADC event occurance status */
+	mutex_init(&adc_event_occ_lock);
+	
+	/* Init the status variable for event occurance */
+	adc_event_occ_status.adc_event_status = FALSE;
+
+	/* Set EH registration flag to 0 */
+	is_eh_registered.adc4_event 	= FALSE;
+	is_eh_registered.adc5_event 	= FALSE;
+	is_eh_registered.adc6_event 	= FALSE;
+	is_eh_registered.comp_1v2_event = FALSE;
+
+	DA9052_DEBUG("Finished hardware initialization\n");
+	return (SUCCESS);
+}
+
+/**
+ * da9052_adc_hw_deinit: This function deinitializes the hardware.
+ * 
+ * @param void
+ * @return s32
+ *	SUCCESS	- On successful completion of the call.
+ */
+static s32 da9052_adc_hw_deinit(void)
+{
+	/* Before exiting - unregister events with EH */
+	if (is_eh_registered.adc4_event)
+		da9052_eh_unregister_nb(&adc4_eh_data);
+	if (is_eh_registered.adc5_event)
+		da9052_eh_unregister_nb(&adc5_eh_data);
+	if (is_eh_registered.adc6_event)
+		da9052_eh_unregister_nb(&adc6_eh_data);
+	if (is_eh_registered.comp_1v2_event)
+		da9052_eh_unregister_nb(&comp_1v2_eh_data);
+
+	/* Delete Mutex */
+	mutex_destroy(&da9052_adc_manconv_lock);
+
+	/* Delete mutex for ADC event occurance status */
+	mutex_destroy(&adc_event_occ_lock);
+	
+	DA9052_DEBUG("Finished hardware de-initialization\n");
+	return (SUCCESS);
+}
+
+/**
+ * da9052_adc_signal_to_user; 
+ * This function signal to the library to call the call back function.
+ * 
+ * @param event
+ * @return s32
+ */
+static s32 da9052_adc_signal_to_user(u8 event)
+{
+	DA9052_DEBUG("%s: event status: %d \n", __FUNCTION__, event);
+	kill_fasync(&adc_fasync_queue, SIGIO, POLL_IN);
+
+	return(SUCCESS);
+}
+
+/*--------------------------------------------------------------------------*/
+/* Global Functions                                                         */
+/*--------------------------------------------------------------------------*/
+/**
+ * da9052_set_adc_mode:	This function sets the mode for which the ADC channel
+ *			is to be read. all channels can be configured in both 
+ *			modes. Except for the following conditions
+ *			1. TSI channel cannot be configured in any mode.
+ *			2. VBAT and VBBAT cannot be configured in AUTO mode.
+ * 
+ * @param channel 	- This parameter selects the channel to be read.
+ * @param mode 		- This parameter selects the mode for the ADC channel
+ *			  selected.
+ * @return status:
+ *	ADC_INVALID_CHANNEL_ERROR - If the selected channel is out of range 
+ *				    A0-A10
+ *	MODE 	- If the selected mode is other then AUTO or MANUAL
+ *	SUCCESS	- On successful completion of the call.
+ */
+s32 da9052_set_adc_mode(u8 channel, u8 mode)
+{
+	/* TSI channel cannot be read by ADC */
+	if (channel == ADC_TSI)
+		return (ADC_INVALID_CHANNEL_ERROR);
+
+	/* Check for Illegal mode set */
+	if ((mode != AUTO_MODE) && (mode != MANUAL_MODE))
+		return (ADC_INVALID_MODE_ERROR);
+	/* Check for Illegal channel set */
+	if((mode == AUTO_MODE) && ((channel == ADC_VBAT) || 
+		(channel == ADC_VBBAT)))
+		return (ADC_INVALID_CHANNEL_ERROR);
+
+	switch (channel) {
+	case ADC_VDDOUT:
+		adc_mode_status.adc_vddout = mode;
+		break;
+	case ADC_ICH:
+		adc_mode_status.adc_ich = mode;
+		break;
+	case ADC_TBAT:
+		adc_mode_status.adc_tbat = mode;
+		break;
+	case ADC_VBAT:
+		adc_mode_status.adc_vbat = mode;
+		break;
+	case ADC_ADCIN4:
+		adc_mode_status.adc_in4 = mode;
+		break;
+	case ADC_ADCIN5:
+		adc_mode_status.adc_in5 = mode;
+		break;
+	case ADC_ADCIN6:
+		adc_mode_status.adc_in6 = mode;
+		break;
+	case ADC_TSI:
+		adc_mode_status.adc_tsi = mode;
+		break;
+	case ADC_TJUNC:
+		adc_mode_status.adc_tsense = mode;
+		break;
+	case ADC_VBBAT:
+		adc_mode_status.adc_vbbat = mode;
+		break;
+	default :
+		/* Illegal Channel set */
+		return (ADC_INVALID_CHANNEL_ERROR);
+	}
+
+	DA9052_DEBUG("vddout 	= %d\n",adc_mode_status.adc_vddout);
+	DA9052_DEBUG("adc_ich 	= %d\n",adc_mode_status.adc_ich);
+	DA9052_DEBUG("adc_tbat 	= %d\n",adc_mode_status.adc_tbat);
+	DA9052_DEBUG("adc_vbat 	= %d\n",adc_mode_status.adc_vbat);
+	DA9052_DEBUG("adc_in4 	= %d\n",adc_mode_status.adc_in4);
+	DA9052_DEBUG("adc_in5 	= %d\n",adc_mode_status.adc_in5);
+	DA9052_DEBUG("adc_in6 	= %d\n",adc_mode_status.adc_in6);
+	DA9052_DEBUG("adc_tsi 	= %d\n",adc_mode_status.adc_tsi);
+	DA9052_DEBUG("adc_tsense= %d\n",adc_mode_status.adc_tsense);
+	DA9052_DEBUG("adc_vbbat = %d\n",adc_mode_status.adc_vbbat);
+	
+	return (SUCCESS);
+}
+
+/**
+ * da9052_adc_set_sampling_interval	:
+ *			This function sets the measurement sequence interval. 
+ *			Only two measurement sequence interval setting is 
+ *			possible 10 ms and 1 ms.
+ * 
+ * @param interval 	- This parameter selects the sampling speed.
+ *
+ * @return status:  
+ *	ADC_INVALID_TIME_ERROR - If time is set to some other value other than 
+ * 				1ms or 10ms.
+ *	ADC_SSC_BUS_ERROR	- If there is an error on the SSC bus.
+ *	SUCCESS			- On successful completion of the call.
+ */ 
+s32 da9052_adc_set_sampling_interval(u8 interval)
+{
+	da9052_ssc_msg msg;
+	
+	/* Read existing data in the register */
+	msg.addr = DA9052_ADCCONT_REG;
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (ADC_SSC_BUS_ERROR);
+	/* Modify the data to be written */
+	if (interval == ADC_INTERVAL_10MS) {
+		msg.data = clear_bits(msg.data, DA9052_ADCCONT_ADCMODE);
+	} else if (interval == ADC_INTERVAL_1MS) {
+		msg.data = set_bits(msg.data, DA9052_ADCCONT_ADCMODE);
+	} else {
+		return (ADC_INVALID_TIME_ERROR);
+	}
+	/* Write the data */
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (ADC_SSC_BUS_ERROR);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_adc_read_vddout	:
+ *			This function reads the value from ADC
+ *			channel 0. If the vddout channel is disabled, this
+ *			function enables it and read the value and again
+ * 			disables the channel. If vddout channel is already
+ *			enabled this function directly reads the value from
+ *			the ADC register.
+ * 
+ * @param *data 	- This parameter is pointer to u16 where data can be
+ *			  written.
+ *
+ * @return status:
+ *	ADC_SSC_BUS_ERROR - If there is an error on the SSC bus.
+ *	SUCCESS		  - On successful completion of the call.
+ */
+s32 da9052_adc_read_vddout(u16 *data)
+{
+	da9052_ssc_msg msg;
+
+	/* Check ADC (VDDOUT) status enabled/disabled */
+	msg.addr = DA9052_ADCCONT_REG;
+	if(SUCCESS != da9052_ssc_read(&msg))
+		return(ADC_SSC_BUS_ERROR);
+	
+	if (!(msg.data & DA9052_ADCCONT_AUTOVDDEN)) {
+		/* If disabled, enable it and then read the value */
+		msg.data = set_bits(msg.data, DA9052_ADCCONT_AUTOVDDEN);
+		if (SUCCESS != da9052_ssc_write(&msg))
+			return (ADC_SSC_BUS_ERROR);
+
+		/* Wait for the conversion time period */
+		/* Read sampling interval set in the ADC_CONT register */
+		if (SUCCESS != da9052_ssc_read(&msg))
+			return (ADC_SSC_BUS_ERROR);
+
+		if (msg.data & DA9052_ADCCONT_ADCMODE) {
+			/* If sampling interval is 1ms */
+			msleep (1);
+		} else {
+			/* If sampling interval is 10ms */
+			msleep (10);
+		}
+		
+		/* Read the ADC converted value */
+		msg.addr = DA9052_VDDRES_REG;
+		if (SUCCESS != da9052_ssc_read(&msg))
+			return (ADC_SSC_BUS_ERROR);
+
+		*data = (u16)msg.data;
+		DA9052_DEBUG(
+	       "In function: %s, VDDCONT_RES value read (1)= 0x%X \n", 
+							__FUNCTION__, msg.data);
+		/* Disable the VDDOUT ADC again */
+		msg.addr = DA9052_ADCCONT_REG;
+		if (SUCCESS != da9052_ssc_read(&msg))
+			return (ADC_SSC_BUS_ERROR);
+
+		msg.data = clear_bits(msg.data, DA9052_ADCCONT_AUTOVDDEN);
+		if (SUCCESS != da9052_ssc_write(&msg))
+			return (ADC_SSC_BUS_ERROR);
+	} else {
+		/* Read the ADC converted value */
+		msg.addr = DA9052_VDDRES_REG;
+		if (SUCCESS != da9052_ssc_read(&msg))
+			return (ADC_SSC_BUS_ERROR);
+
+		*data = (u16)msg.data;
+		DA9052_DEBUG(
+	       "In function: %s, VDDCONT_RES value read (1)= 0x%X \n", 
+							__FUNCTION__, msg.data);
+	}
+	return (SUCCESS);
+}
+
+/**
+ * da9052_adc_read_ich	:
+ *			This function reads the value from ADC 
+ *			channel 1. There is no need to call the channel mode,
+ *			start and read functions. 
+ * 
+ * @param data 	- This parameter is pointer to u16 where data can be
+ *			  written.
+ *
+ * @return status:  
+ *	ADC_SSC_BUS_ERROR - If there is an error on the SSC bus.
+ *	SUCCESS		  - On successful completion of the call.
+ */ 
+s32 da9052_adc_read_ich(u16 *data)
+{
+	da9052_ssc_msg msg;
+	/* Read charging conversion register */
+	msg.addr = DA9052_ICHGAV_REG;
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (ADC_SSC_BUS_ERROR);
+
+	*data = (u16)msg.data;
+	DA9052_DEBUG(
+       "In function: %s, ICHGAV_REG value read (1)= 0x%X \n", 
+							__FUNCTION__, msg.data);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_adc_read_tbat	:
+ *			This function reads the value from ADC 
+ *			channel 2. There is no need to call the channel mode,
+ *			start and read functions. 
+ * 
+ * @param data 	- This parameter is pointer to u9 where data can be 
+ *			  written.
+ *
+ * @return status:  
+ *	ADC_SSC_BUS_ERROR - If there is an error on the SSC bus.
+ *	SUCCESS		  - On successful completion of the call.
+ */ 
+s32 da9052_adc_read_tbat(u16 *data)
+{
+	da9052_ssc_msg msg;
+	/* Read TBAT conversion result */
+	msg.addr = DA9052_TBATRES_REG;
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (ADC_SSC_BUS_ERROR);
+
+	*data = (u16)msg.data;
+	DA9052_DEBUG(
+       "In function: %s, TBATRES_REG value read (1)= 0x%X \n", 
+							__FUNCTION__, msg.data);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_adc_read_vbat	:
+ *			This function reads the value from ADC 
+ *			channel 3. There is no need to call the channel mode,
+ *			start and read functions. This function reads the 
+ *			value by manual conversion (hardware limitation). 
+ * 
+ * @param *data		- This is pointer to location where data is to written
+ *
+ * @return status:  
+ *	ADC_SSC_BUS_ERROR - If there is an error on the SSC bus.
+ *	SUCCESS		  - On successful completion of the call.
+ */ 
+s32 da9052_adc_read_vbat(u16 *data)
+{
+	s32 error;
+	u16 temp;
+
+	error = da9052_manual_read(ADC_VBAT, &temp);
+	DA9052_DEBUG(
+       "In function: %s, VBAT value read (1)= 0x%X \n", 
+							__FUNCTION__, temp);
+	if(SUCCESS == error){
+		*data = temp;
+		return (SUCCESS);
+	} else {
+		return(error);
+	}
+}
+
+/**
+ * da9052_adc_read_tjunc	:
+ *			This function reads the value from ADC 
+ *			channel 8. There is no need to call the channel mode,
+ *			start and read functions.
+ *
+ * @param *data		- This is pointer to location where data is to written
+ *
+ * @return status:  
+ *	ADC_SSC_BUS_ERROR - If there is an error on the SSC bus.
+ *	SUCCESS		  - On successful completion of the call.
+ */ 
+s32 da9052_adc_read_tjunc(u16 *data)
+{
+	da9052_ssc_msg msg;
+	u16 temp;
+	/* Read TJunction conversion result */
+	msg.addr = DA9052_TJUNCRES_REG;
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (ADC_SSC_BUS_ERROR);
+	temp = msg.data;
+	/* Read calibration for junction temperature */
+	msg.addr = DA9052_TOFFSET_REG;
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (ADC_SSC_BUS_ERROR);
+	/* Calculate Junction temperature */
+	*data = temp - (u16)msg.data;
+	DA9052_DEBUG(
+       "In function: %s, Calc JUNC TEMP value (1)= 0x%X \n", 
+							__FUNCTION__, *data);
+	return(SUCCESS);
+}
+
+
+/**
+ * da9052_adc_read_vbbat	:
+ *			This function reads the value from ADC 
+ *			channel 9. There is no need to call the channel mode,
+ *			start and read functions. This function reads the 
+ *			value by manual conversion (hardware limitation). 
+ * 
+ * @param *data		- This is pointer to location where data is to written
+ *
+ * @return status:
+ *	ADC_SSC_BUS_ERROR - If there is an error on the SSC bus.
+ *	SUCCESS		  - On successful completion of the call.
+ */
+s32 da9052_adc_read_vbbat(u16 *data)
+{
+	s32 error;
+	u16 temp;
+
+	error = da9052_manual_read(ADC_VBBAT, &temp);
+	DA9052_DEBUG(
+       "In function: %s, VBBAT value read (1)= 0x%X \n", 
+							__FUNCTION__, temp);
+	if(SUCCESS == error){
+		*data = temp;
+		return (SUCCESS);
+	} else {
+		return(error);
+	}
+}
+
+/**
+ * da9052_configure_thresholds	:
+ *			This function sets the threshold value of the ADCIN4, 
+ *			ADCIN5 and ADCIN6 channels. If value for any of the 
+ *			channel is wrong this function will return error 
+ *			without writing any value in the registers.
+ * 
+ * @param threshold_res thresholds (structure containing threshold settings) 
+ *			  
+ *
+ * @return status:  
+ *	ADC_INVALID_VALUE - Error in the high and low value.
+ *	ADC_SSC_BUS_ERROR - If there is an error on the SSC bus.
+ *	SUCCESS		  - On successful completion of the call.
+ */  
+s32 da9052_configure_thresholds(threshold_res thresholds)
+{
+	da9052_ssc_msg msg;
+
+	DA9052_DEBUG("In function: %s \n", __FUNCTION__);
+	DA9052_DEBUG("auto4_high	: %d \n", thresholds.auto4_high);
+	DA9052_DEBUG("auto4_low		: %d \n", thresholds.auto4_low);
+	DA9052_DEBUG("auto5_high	: %d \n", thresholds.auto5_high);
+	DA9052_DEBUG("auto5_low		: %d \n", thresholds.auto5_low);
+	DA9052_DEBUG("auto6_high	: %d \n", thresholds.auto6_high);
+	DA9052_DEBUG("auto6_low		: %d \n", thresholds.auto6_low);
+
+	/* Check if the High value is higher then Low value */
+	if (thresholds.auto4_high <= thresholds.auto4_low)
+		return (ADC_INVALID_VALUE);
+	if (thresholds.auto5_high <= thresholds.auto5_low)
+		return (ADC_INVALID_VALUE);
+	if (thresholds.auto6_high <= thresholds.auto6_low)
+		return (ADC_INVALID_VALUE);
+
+	/* Write threshold value to the register */
+	/* ADCIN4 */
+	msg.addr = DA9052_AUTO4HIGH_REG;
+	msg.data = thresholds.auto4_high;
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (ADC_SSC_BUS_ERROR);
+
+	msg.addr = DA9052_AUTO4LOW_REG;
+	msg.data = thresholds.auto4_low;
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (ADC_SSC_BUS_ERROR);
+	
+	/* ADCIN5 */
+	msg.addr = DA9052_AUTO5HIGH_REG;
+	msg.data = thresholds.auto5_high;
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (ADC_SSC_BUS_ERROR);
+
+	msg.addr = DA9052_AUTO5LOW_REG;
+	msg.data = thresholds.auto5_low;
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (ADC_SSC_BUS_ERROR);
+		
+	/* ADCIN6 */
+	msg.addr = DA9052_AUTO6HIGH_REG;
+	msg.data = thresholds.auto6_high;
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (ADC_SSC_BUS_ERROR);
+
+	msg.addr = DA9052_AUTO6LOW_REG;
+	msg.data = thresholds.auto6_low;
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (ADC_SSC_BUS_ERROR);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_set_adcin5_comparator	:
+ *			This function enables/disables the comparator for
+ *			ADCIN5.
+ * 
+ * @param action 	-Enable or Disable action to be performed.
+ *
+ * @return status:  
+ *	ADC_INVALID_VALUE - If the parameter passed is wrong.
+ *	ADC_SSC_BUS_ERROR - If there is an error on the SSC bus.
+ *	SUCCESS		  - On successful completion of the call.
+ */  
+s32 da9052_set_adcin5_comparator(u8 action)
+{
+	da9052_ssc_msg msg;
+	
+	msg.addr = DA9052_ADCCONT_REG;
+	msg.data = 0;
+	/* Read previous contents of the register */
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (ADC_SSC_BUS_ERROR);
+	/* Modify the bit */
+	if (action == ENABLE) {
+		msg.data = set_bits(msg.data,DA9052_ADCCONT_COMP1V2EN);
+	} else if (action == DISABLE) {
+		msg.data = clear_bits(msg.data,DA9052_ADCCONT_COMP1V2EN);
+	} else {
+		return (ADC_INVALID_VALUE);
+	}
+	/* Write back the value to the register */
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return(ADC_SSC_BUS_ERROR);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_set_tbat_source_current	:
+ *			This function enables the 50uA current source for 
+ *			TBAT permanently or only for two slots of auto mode 
+ *			ADC.
+ * 
+ * @param action 	- Two slots OR premanently.
+ *
+ * @return status:  
+ *	ADC_INVALID_VALUE - If the parameter passed is wrong.
+ *	ADC_SSC_BUS_ERROR - If there is an error on the SSC bus.
+ *	SUCCESS		  - On successful completion of the call.
+ */
+s32 da9052_set_tbat_source_current(u8 action)
+{
+	da9052_ssc_msg msg;
+	
+	msg.addr = DA9052_ADCCONT_REG;
+	msg.data = 0;
+	/* Read previous contents of the register */
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (ADC_SSC_BUS_ERROR);
+	/* Modify the bit value */
+	if (action == TBAT_50UA_PREMANENTLY) {
+		msg.data = set_bits(msg.data, DA9052_ADCCONT_TBATISRCEN);
+	} else if (action == TBAT_50UA_ONE_SLOT) {
+		msg.data = clear_bits(msg.data, DA9052_ADCCONT_TBATISRCEN);
+	} else {
+		return (ADC_INVALID_VALUE);
+	}
+	/* Write back to the register */
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return(ADC_SSC_BUS_ERROR);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_set_ad4_isrc_source_current	:
+ *			This function enables the 15uA current source for
+ *			ADCIN4.
+ * 
+ * @param action 	- Enable or Disable.
+ *
+ * @return status:  
+ *	ADC_INVALID_VALUE - If the parameter passed is wrong.
+ *	ADC_SSC_BUS_ERROR - If there is an error on the SSC bus.
+ *	SUCCESS		  - On successful completion of the call.
+ */
+s32 da9052_set_ad4_isrc_source_current(u8 action)
+{
+	da9052_ssc_msg msg;
+	
+	msg.addr = DA9052_ADCCONT_REG;
+	msg.data = 0;
+	/* Read previous contents of the register */
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (ADC_SSC_BUS_ERROR);
+	/* Modify the bit value */
+	if (action == ENABLE) {
+		msg.data = set_bits(msg.data, DA9052_ADCCONT_AD4ISRCEN);
+	} else if (action == DISABLE) {
+		msg.data = clear_bits(msg.data, DA9052_ADCCONT_AD4ISRCEN);
+	} else {
+		return (ADC_INVALID_VALUE);
+	}
+	/* Write back to the register */
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (ADC_SSC_BUS_ERROR);
+	return (SUCCESS);
+}
+ /**
+ * da9052_start_adc	:
+ *			This function starts the ADC channel in AUTO mode.
+ * 
+ * @param channel 	- Channel No. to be started.
+ *
+ * @return status:  
+ *	CHANNEL	- If the channel value passed to this functions is 
+ *			  wrong.
+ *	ADC_SSC_BUS_ERROR - If there is an error on the SSC bus.
+ *	SUCCESS		  - On successful completion of the call.
+ */  
+s32 da9052_start_adc (u8 channel)
+{
+	da9052_ssc_msg msg;
+
+	msg.addr = DA9052_ADCCONT_REG;
+	msg.data = 0;
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (ADC_SSC_BUS_ERROR);
+
+	/* Set the bit for corresponding channel in ADC_CONT register */
+	if (channel == ADC_VDDOUT) { 
+		msg.data = set_bits(msg.data, DA9052_ADCCONT_AUTOVDDEN);
+	} else if (channel == ADC_ADCIN4) {
+		msg.data = set_bits(msg.data, DA9052_ADCCONT_AUTOAD4EN);
+	} else if (channel == ADC_ADCIN5) {
+		msg.data = set_bits(msg.data, DA9052_ADCCONT_AUTOAD5EN);
+	} else if (channel == ADC_ADCIN6) {
+		msg.data = set_bits(msg.data, DA9052_ADCCONT_AUTOAD6EN);
+	} else {
+		return (ADC_INVALID_CHANNEL_ERROR);
+	}
+	/* Write the value in the register */
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (ADC_SSC_BUS_ERROR);
+	return (SUCCESS);
+}
+
+ /**
+ * da9052_stop_adc	:
+ *			This function stops the ADC channel in AUTO mode.
+ * 
+ * @param channel 	- Channel No. to be stopped.
+ *
+ * @return status:  
+ *	CHANNEL	- If the channel value passed to this functions is 
+ *			  wrong.
+ *	ADC_SSC_BUS_ERROR - If there is an error on the SSC bus.
+ *	SUCCESS		  - On successful completion of the call.
+ */  
+s32 da9052_stop_adc (u8 channel)
+{
+	da9052_ssc_msg msg;
+
+	msg.addr = DA9052_ADCCONT_REG;
+	msg.data = 0;
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (ADC_SSC_BUS_ERROR);
+
+	/* Clear the data in the ADC_CONT register */
+	if (channel == ADC_VDDOUT) {
+		msg.data = clear_bits(msg.data, DA9052_ADCCONT_AUTOVDDEN);
+	} else if (channel == ADC_ADCIN4) {
+		msg.data = clear_bits(msg.data, DA9052_ADCCONT_AUTOAD4EN);
+	} else if (channel == ADC_ADCIN5) {
+		msg.data = clear_bits(msg.data, DA9052_ADCCONT_AUTOAD5EN);
+	} else if (channel == ADC_ADCIN6) {
+		msg.data = clear_bits(msg.data, DA9052_ADCCONT_AUTOAD6EN);
+	} else {
+		return (ADC_INVALID_CHANNEL_ERROR);
+	}
+	/* Write the data */
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (ADC_SSC_BUS_ERROR);
+
+	return (SUCCESS);
+}
+ 
+ /**
+ * da9052_read_adc	:
+ *			This function reads the ADC value for the channel 
+ *			specified in the parameter.
+ * 
+ * @param channel 	- Channel No. to be read.
+ * @param data		- Pointer to the location where data is to be copied.
+ *
+ * @return status:
+ *	CHANNEL	- If the channel value passed to this functions is 
+ *			  wrong.
+ *	ADC_CH4_NOT_CONF	- If ADCIN4 pins not configured for ADC.
+ *	ADC_CH5_NOT_CONF	- If ADCIN5 pins not configured for ADC.
+ *	ADC_CH6_NOT_CONF	- If ADCIN6 pins not configured for ADC.
+ *	ADC_CHANNEL_NOT_STARTED_ERROR - If the channel is not started in Auto 
+ *					mode.
+ *	ADC_SSC_BUS_ERROR	- If there is an error on the SSC bus.
+ *	SUCCESS			- On successful completion of the call.
+ */  
+s32 da9052_read_adc (u8 channel, u16 *data)
+{
+	da9052_ssc_msg msg;
+	s32 error;
+	u16 calc_data;
+	
+	switch(channel){
+	/* VDD_OUT channel */
+	case ADC_VDDOUT:{
+		/* If manual mode do manual read */
+		if(adc_mode_status.adc_vddout == MANUAL_MODE){
+			error = da9052_manual_read(channel, &calc_data);
+			if (error != SUCCESS) {
+				return (error);
+			} else {
+				/* 8 bit data in manual mode */
+				*data = calc_data >> 2;
+			}
+		/* Check Auto mode */
+		} else {
+			/* Check if channel is enabled */
+			msg.addr = DA9052_ADCCONT_REG;
+			if (SUCCESS != da9052_ssc_read(&msg))
+				return (ADC_SSC_BUS_ERROR);
+			if(msg.data & DA9052_ADCCONT_AUTOVDDEN) {
+				msg.addr = DA9052_VDDRES_REG;
+				if (SUCCESS != da9052_ssc_read(&msg))
+					return (ADC_SSC_BUS_ERROR);
+				*data = (u16)msg.data;
+			} else {
+				return (ADC_CHANNEL_NOT_STARTED_ERROR);
+			}
+		}
+		return (SUCCESS);
+	}
+	case ADC_ICH:{ 
+		/* If manual mode do manual read */
+		if(adc_mode_status.adc_ich == MANUAL_MODE) {
+			error = da9052_manual_read(channel, &calc_data);
+			if (error != SUCCESS) {
+				return (error);
+			} else {
+				/* 8 bit data in manual mode */
+				*data = calc_data >> 2;
+			}
+		} else {
+			/* Read data in AUTO mode */
+			msg.addr = DA9052_ICHGAV_REG;
+			if (SUCCESS != da9052_ssc_read(&msg))
+				return (ADC_SSC_BUS_ERROR);
+			*data = (u16)msg.data;
+		}
+		return (SUCCESS);
+	}
+	case ADC_TBAT:{
+		/* If manual mode do manual read */
+		if(adc_mode_status.adc_tbat == MANUAL_MODE){
+			error = da9052_manual_read(channel, &calc_data);
+			if (error != SUCCESS) {
+				return (error);
+			} else {
+				/* 8 bit data in manual mode */
+				*data = calc_data >> 2;
+			}
+		} else {
+			/* Read data in AUTO mode */
+			msg.addr = DA9052_TBATRES_REG;
+			if (SUCCESS != da9052_ssc_read(&msg))
+				return (ADC_SSC_BUS_ERROR);
+			*data = (u16)msg.data;
+		}
+		return (SUCCESS);
+	}
+	case ADC_VBAT:{
+		if(adc_mode_status.adc_vbat == MANUAL_MODE) {
+			return (da9052_manual_read(channel, data));
+		} else {
+			return (ADC_INVALID_CHANNEL_ERROR);
+		}
+		return (SUCCESS);
+	}
+	case ADC_ADCIN4:{
+#if (ADC_CONF_ADC4)
+		/* If manual mode do manual read */
+		if(adc_mode_status.adc_in4 == MANUAL_MODE){
+			error = da9052_manual_read(channel, &calc_data);
+			if (error != SUCCESS) {
+				return (error);
+			} else {
+				/* 8 bit data in manual mode */
+				*data = calc_data >> 2;
+			}
+		/* Check Auto mode */
+		} else {
+			/* Check if channel is enabled */
+			msg.addr = DA9052_ADCCONT_REG;
+			if (SUCCESS != da9052_ssc_read(&msg))
+				return (ADC_SSC_BUS_ERROR);
+			if(msg.data & DA9052_ADCCONT_AUTOAD4EN) {
+				msg.addr = DA9052_ADCIN4RES_REG;
+				if (SUCCESS != da9052_ssc_read(&msg))
+					return (ADC_SSC_BUS_ERROR);
+				*data = (u16)msg.data;
+			} else {
+				return (ADC_CHANNEL_NOT_STARTED_ERROR);
+			}
+		}
+		return (SUCCESS);
+#else
+		/* If the ADCIN4 pin not configured for ADC */
+		return (ADC_CH4_NOT_CONF);
+#endif
+	}
+	case ADC_ADCIN5:{/* ADCIN5 */
+#if (ADC_CONF_ADC5)
+		/* If manual mode do manual read */
+		if(adc_mode_status.adc_in5 == MANUAL_MODE){
+			error = da9052_manual_read(channel, &calc_data);
+			if (error != SUCCESS) {
+				return (error);
+			} else {
+				/* 8 bit data in manual mode */
+				*data = calc_data >> 2;
+			}
+		/* Check Auto mode */
+		} else {
+			/* Check if channel is enabled */
+			msg.addr = DA9052_ADCCONT_REG;
+			if (SUCCESS != da9052_ssc_read(&msg))
+				return (ADC_SSC_BUS_ERROR);
+			if(msg.data & DA9052_ADCCONT_AUTOAD5EN) {
+				msg.addr = DA9052_ADCIN5RES_REG;
+				if (SUCCESS != da9052_ssc_read(&msg))
+					return (ADC_SSC_BUS_ERROR);
+				*data = (u16)msg.data;
+			} else {
+				return (ADC_CHANNEL_NOT_STARTED_ERROR);
+			}
+		}
+		return (SUCCESS);
+#else
+		/* If the ADCIN5 pin not configured for ADC */
+		return (ADC_CH5_NOT_CONF);
+#endif
+	}
+	case ADC_ADCIN6:{/* ADCIN6 */
+#if (ADC_CONF_ADC6)
+		/* If manual mode do manual read */
+		if(adc_mode_status.adc_in6 == MANUAL_MODE){
+			error = da9052_manual_read(channel, &calc_data);
+			if (error != SUCCESS) {
+				return (error);
+			} else {
+				/* 8 bit data in manual mode */
+				*data = calc_data >> 2;
+			}
+		/* Check Auto mode */
+		} else {
+			/* Check if channel is enabled */
+			msg.addr = DA9052_ADCCONT_REG;
+			if (SUCCESS != da9052_ssc_read(&msg))
+				return (ADC_SSC_BUS_ERROR);
+			if(msg.data & DA9052_ADCCONT_AUTOAD6EN) {
+				msg.addr = DA9052_ADCIN6RES_REG;
+				if (SUCCESS != da9052_ssc_read(&msg))
+					return (ADC_SSC_BUS_ERROR);
+				*data = (u16)msg.data;
+			} else {
+				return (ADC_CHANNEL_NOT_STARTED_ERROR);
+			}
+		}
+		return (SUCCESS);
+#else
+		/* If the ADCIN6 pin not configured for ADC */
+		return (ADC_CH6_NOT_CONF);
+#endif
+	}
+	case ADC_TSI:{
+		return (ADC_INVALID_CHANNEL_ERROR);
+	}
+	case ADC_TJUNC:{
+		if (adc_mode_status.adc_tsense == MANUAL_MODE) {
+			error = da9052_manual_read(channel, &calc_data);
+			if (error != SUCCESS) {
+				return (error);
+			} else {
+				/* 8 bit data in manual mode */
+				*data = calc_data >> 2;
+			}
+		} else {
+			/* Read data in AUTO mode */
+			msg.addr = DA9052_TJUNCRES_REG;
+			if (SUCCESS != da9052_ssc_read(&msg))
+				return (ADC_SSC_BUS_ERROR);
+			*data = (u16)msg.data;
+		}
+		return (SUCCESS);
+	}
+	case ADC_VBBAT:{
+		if (adc_mode_status.adc_vbbat == MANUAL_MODE) {
+			return (da9052_manual_read(channel, data));
+		} else {
+			return (ADC_INVALID_CHANNEL_ERROR);
+		}
+		return (SUCCESS);
+	}
+	/* Check Illegal Channel */
+	default :
+		return (ADC_INVALID_CHANNEL_ERROR);
+	}
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_adc_adcin4_handler : register the event
+ * 
+ * @param void
+ * 
+ * @return s32   Error Code, zero: no error
+ */
+void da9052_adc_adcin4_handler(u32 data)
+{
+	/* Acquire lock before accessing the status variable */
+	mutex_lock(&adc_event_occ_lock);
+	/* Store the status of the event in the variable */
+	adc_event_occ_status.event_bits_t.adc_adcin4_e_occ = TRUE;
+	/* Release the lock */
+	mutex_unlock(&adc_event_occ_lock);
+	/* Signal to the user space */
+	da9052_adc_signal_to_user(GPI0_EVE);
+}
+
+/**
+ * da9052_adc_adcin5_handler : register the event
+ * 
+ * @param void
+ * 
+ * @return s32   Error Code, zero: no error
+ */
+void da9052_adc_adcin5_handler(u32 data)
+{
+	/* Acquire lock before accessing the status variable */
+	mutex_lock(&adc_event_occ_lock);
+	/* Store the status of the event in the variable */
+	adc_event_occ_status.event_bits_t.adc_adcin5_e_occ = TRUE;
+	/* Release the lock */
+	mutex_unlock(&adc_event_occ_lock);
+	/* Signal to the user space */
+	da9052_adc_signal_to_user(GPI1_EVE);
+}
+
+/**
+ * da9052_adc_adcin6_handler : register the event
+ * 
+ * @param void
+ * 
+ * @return s32   Error Code, zero: no error
+ */
+void da9052_adc_adcin6_handler(u32 data)
+{
+	/* Acquire lock before accessing the status variable */
+	mutex_lock(&adc_event_occ_lock);
+	/* Store the status of the event in the variable */
+	adc_event_occ_status.event_bits_t.adc_adcin6_e_occ = TRUE;
+	/* Release the lock */
+	mutex_unlock(&adc_event_occ_lock);
+	/* Signal to the user space */
+	da9052_adc_signal_to_user(GPI2_EVE);
+}
+
+
+/**
+ * da9052_1v2_comp_handler : register the event
+ * 
+ * @param void
+ * 
+ * @return s32   Error Code, zero: no error
+ */
+void da9052_1v2_comp_handler(u32 data)
+{
+	/* Acquire lock before accessing the status variable */
+	mutex_lock(&adc_event_occ_lock);
+	/* Store the status of the event in the variable */
+	adc_event_occ_status.event_bits_t.adc_comp1v2_e_occ = TRUE;
+	/* Release the lock */
+	mutex_unlock(&adc_event_occ_lock);
+	/* Signal to the user space */
+	da9052_adc_signal_to_user(COMP_1V2);
+}
+
+/**
+ * da9052_adc_register_event : register the event
+ * 
+ * @param u8 event_type	event type
+ * 
+ * @return s32   Error Code, zero: no error
+ */
+s32 da9052_adc_register_event(u8 event_type)
+{
+	/* Register the callback function with event handler */
+	switch(event_type) {
+	case GPI0_EVE:
+#if ADC_CONF_ADC4
+		/* Check if event is already registered */
+		if (!is_eh_registered.adc4_event) {
+			/* Set the EH structure */
+			adc4_eh_data.call_back = da9052_adc_adcin4_handler;
+			adc4_eh_data.eve_type = event_type;
+			/* Register the event with EH */
+			if (da9052_eh_register_nb(&adc4_eh_data))
+				return (ADC_EVENT_REGISTRATION_FAILED);
+			/* Set the registration flag to 1 */
+			is_eh_registered.adc4_event = TRUE;
+		}
+#else
+		return (ADC_CH4_NOT_CONF);
+#endif
+		break;
+	case GPI1_EVE:
+#if ADC_CONF_ADC5
+		/* Check if event is already registered */
+		if (!is_eh_registered.adc5_event) {
+			/* Set the EH structure */
+			adc5_eh_data.call_back = da9052_adc_adcin5_handler;
+			adc5_eh_data.eve_type = event_type;
+			/* Register the event with EH */
+			if (da9052_eh_register_nb(&adc5_eh_data))
+				return (ADC_EVENT_REGISTRATION_FAILED);
+			/* Set the registration flag to 1 */
+			is_eh_registered.adc5_event = TRUE;
+		}
+#else
+		return (ADC_CH5_NOT_CONF);
+#endif
+		break;
+	case GPI2_EVE:
+#if ADC_CONF_ADC6
+		/* Check if event is already registered */
+		if (!is_eh_registered.adc6_event) {
+			/* Set the EH structure */
+			adc6_eh_data.call_back = da9052_adc_adcin6_handler;
+			adc6_eh_data.eve_type = event_type;
+			/* Register the event with EH */
+			if (da9052_eh_register_nb(&adc6_eh_data))
+				return (ADC_EVENT_REGISTRATION_FAILED);
+			/* Set the registration flag to 1 */
+			is_eh_registered.adc6_event = TRUE;
+		}
+#else
+		return (ADC_CH6_NOT_CONF);
+#endif
+		break;
+	case COMP_1V2:
+		/* Check if event is already registered */
+		if (!is_eh_registered.comp_1v2_event) {
+			/* Set the EH structure */
+			comp_1v2_eh_data.call_back = da9052_1v2_comp_handler;
+			comp_1v2_eh_data.eve_type = event_type;
+			/* Register the event with EH */
+			if (da9052_eh_register_nb(&comp_1v2_eh_data))
+				return (ADC_EVENT_REGISTRATION_FAILED);
+			/* Set the registration flag to 1 */
+			is_eh_registered.comp_1v2_event = TRUE;
+		}		
+		break;
+	default:
+		return (ADC_INVALID_EVENT);
+	}
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_adc_get_event : Get the status of the events occured. Required by the 
+ *							user space application
+ * 
+ * @param void
+ * 
+ * @return status
+ */
+s32 da9052_adc_get_event(unsigned long *argument)
+{
+	u8 events;
+	/* Acquire lock */
+	mutex_lock(&adc_event_occ_lock);
+	/* Read the value to the local variable */
+	events = adc_event_occ_status.adc_event_status;
+	/* Clear the Global variable */
+	adc_event_occ_status.adc_event_status = FALSE;
+	/* Release the lock */
+	mutex_unlock(&adc_event_occ_lock);
+	/* Copy the event to the user space */
+	return(copy_to_user((u8 *)(*argument), (void *)&events, sizeof(u8)));
+}
+ 
+/**
+ * da9052_adc_unregister_event : register the event
+ * 
+ * @param u8 event_type	event type
+ * 
+ * @return s32   Error Code, zero: no error
+ */
+s32 da9052_adc_unregister_event(u8 event_type)
+{
+	/* Check event type */
+	switch (event_type) {
+	case GPI0_EVE:
+#if ADC_CONF_ADC4
+		/* Unregister event */
+		if (is_eh_registered.adc4_event) {
+			if (da9052_eh_unregister_nb(&adc4_eh_data)) {
+				return (ADC_EVENT_UNREGISTRATION_FAILED);
+			}
+			/* Set flag to 0 */
+			is_eh_registered.adc4_event = FALSE;
+		}
+#else
+		return (ADC_CH4_NOT_CONF);
+#endif
+		break;
+	case GPI1_EVE:
+#if ADC_CONF_ADC5
+		/* Unregister event */
+		if (is_eh_registered.adc5_event) {
+			if (da9052_eh_unregister_nb(&adc5_eh_data)) {
+				return (ADC_EVENT_UNREGISTRATION_FAILED);
+			}
+			/* Set flag to 0 */
+			is_eh_registered.adc5_event = FALSE;
+		}
+#else
+		return (ADC_CH5_NOT_CONF);
+#endif
+		break;
+	case GPI2_EVE:
+#if ADC_CONF_ADC6
+		/* Unregister event */
+		if (is_eh_registered.adc6_event) {
+			if (da9052_eh_unregister_nb(&adc6_eh_data)) {
+				return (ADC_EVENT_UNREGISTRATION_FAILED);
+			}
+			/* Set flag to 0 */
+			is_eh_registered.adc6_event = FALSE;
+		}
+#else
+		return (ADC_CH6_NOT_CONF);
+#endif
+		break;
+	case COMP_1V2:
+		/* Unregister event */
+		if (is_eh_registered.comp_1v2_event) {
+			if (da9052_eh_unregister_nb(&comp_1v2_eh_data)) {
+				return (ADC_EVENT_UNREGISTRATION_FAILED);
+			}
+			/* Set flag to 0 */
+			is_eh_registered.comp_1v2_event = FALSE;
+		}
+		break;
+	default:
+		return (ADC_INVALID_EVENT);
+		break;
+	}
+	return (SUCCESS);
+}
+/*--------------------------------------------------------------------------*/
+/* Infrastructure Functions                                                 */
+/*--------------------------------------------------------------------------*/
+/**
+ * da9052_adc_open: 
+ * 
+ * @param *inode pointer to device inode
+ * @param *file  file pointer
+ * @return s32   Error Code, zero: no error
+ */
+s32 da9052_adc_open(struct inode *inode, struct file *file)
+{
+	/* Check if device is already open */
+	if(adc_device_open) {
+		printk("DA9052: ADC device already open.\n");
+		return (-EBUSY);
+	} else {
+		adc_device_open++;
+		return (SUCCESS);
+	}
+}
+
+/**
+ * da9052_adc_release:
+ * 
+ * @param *inode pointer to device inode
+ * @param *file  file pointer
+ * @return s32   Error Code, zero: no error
+ */
+s32 da9052_adc_release(struct inode *inode, struct file *file)
+{
+	adc_device_open--;
+	printk("DA9052: ADC device closed.\n");
+	return (SUCCESS);
+}
+
+/**
+ * da9052_adc_suspend: Power Management support function
+ * 
+ * @param *dev   pointer to platform device
+ * @param state  pm state
+ * @return s32 status of suspend operation
+ */
+static s32 da9052_adc_suspend(struct platform_device *dev, pm_message_t state)
+{
+     /* Put your suspend related operations here */
+     printk(KERN_INFO "%s: called\n", __FUNCTION__);
+     return (0);
+}
+
+/**
+ * da9052_adc_resume: Power Management support function
+ * 
+ * @param *dev   pointer to platform device
+ * @return s32 status of resume operation
+ */
+static s32 da9052_adc_resume(struct platform_device *dev)
+{
+     /* Put your resume related operations here */
+     printk(KERN_INFO "%s: called\n", __FUNCTION__);
+     return (0);
+}
+
+/**
+ * da9052_adc_ioctl: 
+ * 
+ * @param *inode   pointer to device inode
+ * @param *file   file pointer
+ * @param cmd   command to be executed
+ * @param arg   argument to command
+ * @return s32   Error Code, zero: no error
+ */
+s32 da9052_adc_ioctl(struct inode *inode, struct file *file, 
+					u32 cmd, unsigned long arg)
+{
+	s32 error = SUCCESS;
+	u8 event_data, *event_ptr;
+	da9052_adc_data_t usr_param, *ptr;
+#if DA9052_ADC_DEBUG
+	u16 data;
+#endif /* DA9052_UNIT_TESTING_ADC */
+
+	
+	ptr = (da9052_adc_data_t *) arg;
+
+	/* Switch as per the command requested */
+	switch(cmd) {
+	case DA9052_ADC_IOCTL_SET_ADC_MODE:
+		if (copy_from_user(&usr_param, ptr, sizeof(da9052_adc_data_t)))
+			return (FAILURE);
+		error = da9052_set_adc_mode(usr_param.channel, usr_param.mode);
+		break;
+	case DA9052_ADC_IOCTL_SET_SAMPLING_INTERVAL:
+		if (copy_from_user(&usr_param, ptr, sizeof(da9052_adc_data_t)))
+			return (FAILURE);
+		error = da9052_adc_set_sampling_interval(usr_param.interval);
+		break;
+	case DA9052_ADC_IOCTL_CONFIGURE_THRESHOLDS:
+		if (copy_from_user(&usr_param, ptr, sizeof(da9052_adc_data_t)))
+			return (FAILURE);
+		error = da9052_configure_thresholds (usr_param.threshold);
+		break;
+	case DA9052_ADC_IOCTL_SET_ADCIN5_COMPARATOR:
+		if (copy_from_user(&usr_param, ptr, sizeof(da9052_adc_data_t)))
+			return (FAILURE);
+		error = da9052_set_adcin5_comparator(usr_param.action);
+		break;
+	case DA9052_ADC_IOCTL_SET_TBAT_SOURCE_CURRENT:
+		if (copy_from_user(&usr_param, ptr, sizeof(da9052_adc_data_t)))
+			return (FAILURE);
+		error = da9052_set_tbat_source_current(usr_param.action);
+		break;
+	case DA9052_ADC_IOCTL_SET_ADCIN4_SOURCE_CURRENT:
+		if (copy_from_user(&usr_param, ptr, sizeof(da9052_adc_data_t)))
+			return (FAILURE);
+		error = da9052_set_ad4_isrc_source_current(usr_param.action);
+		break;
+	case DA9052_ADC_IOCTL_START_ADC:
+		if (copy_from_user(&usr_param, ptr, sizeof(da9052_adc_data_t)))
+			return (FAILURE);
+		error = da9052_start_adc(usr_param.channel);
+		break;
+	case DA9052_ADC_IOCTL_STOP_ADC:
+		if (copy_from_user(&usr_param, ptr, sizeof(da9052_adc_data_t)))
+			return (FAILURE);
+		error = da9052_stop_adc(usr_param.channel);
+		break;
+	case DA9052_ADC_IOCTL_READ_ADC:
+		if (copy_from_user(&usr_param, ptr, sizeof(da9052_adc_data_t)))
+			return (FAILURE);
+		error = da9052_read_adc(usr_param.channel, usr_param.data);
+		if (copy_to_user((u16 *)arg, (void *)&usr_param, 
+						sizeof(da9052_adc_data_t)))
+			return (FAILURE);
+		break;
+	case DA9052_ADC_IOCTL_REGISTER_EVENT:
+		event_ptr = (u8 *) arg;
+		if (copy_from_user(&event_data, event_ptr, sizeof(u8)))
+			return (FAILURE);
+		error = da9052_adc_register_event(event_data);
+		break;
+	case DA9052_ADC_IOCTL_UNREGISTER_EVENT:
+		event_ptr = (u8 *) arg;
+		if (copy_from_user(&event_data, event_ptr, sizeof(u8)))
+			return (FAILURE);
+		error = da9052_adc_unregister_event(event_data);			
+		break;
+	case DA9052_ADC_IOCTL_GET_EVENT:
+		if (da9052_adc_get_event(&arg))
+			return (FAILURE);
+		break;
+#if DA9052_ADC_DEBUG
+	case DA9052_ADC_IOCTL_UT_VDDOUT:
+		error = da9052_adc_read_vddout(&data);
+		if (copy_to_user((u16 *)arg, (void *)&data, sizeof(u16)))
+			return (FAILURE);
+		break;
+	case DA9052_ADC_IOCTL_UT_ICH:
+		error = da9052_adc_read_ich(&data);
+		if (copy_to_user((u16 *)arg, (void *)&data, sizeof(u16)))
+			return (FAILURE);
+		break;
+	case DA9052_ADC_IOCTL_UT_TBAT:
+		error = da9052_adc_read_tbat(&data);
+		if (copy_to_user((u16 *)arg, (void *)&data, sizeof(u16)))
+			return (FAILURE);
+		break;
+	case DA9052_ADC_IOCTL_UT_VBAT:
+		error = da9052_adc_read_vbat(&data);
+		if (copy_to_user((u16 *)arg, (void *)&data, sizeof(u16)))
+			return (FAILURE);
+		break;
+	case DA9050_ADC_IOCTL_UT_TJUNC:
+		error = da9052_adc_read_tjunc(&data);
+		if (copy_to_user((u16 *)arg, (void *)&data, sizeof(u16)))
+			return (FAILURE);
+		break;
+	case DA9052_ADC_IOCTL_UT_VBBAT:
+		error = da9052_adc_read_vbbat(&data);
+		if (copy_to_user((u16 *)arg, (void *)&data, sizeof(u16)))
+			return (FAILURE);
+		break;
+#endif /* DA9052_ADC_DEBUG */
+	default:
+		DA9052_DEBUG("Invalid ioctl command\n");
+		return (ADC_NO_IOCTL_CMD);	
+	}
+	return (error);
+}
+
+/**
+ * da9052_bat_fasync: 
+ * 
+ * @param void 	 <Direction> <Description>
+ * @return s32   <Description>
+ */
+s32 da9052_adc_fasync (s32 fd, struct file *filp, s32 on)
+{
+  DA9052_DEBUG ("In %s: %s\n",__FILE__, __FUNCTION__);
+  return(fasync_helper(fd, filp, on, &adc_fasync_queue));
+}
+
+/**
+ * static struct file_operations da9052_adc_fops -  
+ * This structure definition has to be defined here as an exception. 
+ * @owner: member description
+ * @open : member description
+ * @release: member description
+ * @read: member description
+ * @write: member description
+ * @ioctl: member description
+ *
+ */
+static const struct file_operations da9052_adc_fops = {
+        .owner          = THIS_MODULE,
+        .open           = da9052_adc_open,
+        .release        = da9052_adc_release,
+        .ioctl          = da9052_adc_ioctl,
+	.fasync		= da9052_adc_fasync
+};
+
+/**
+ * da9052_adc_probe: Called when a device gets attached to driver 
+ * @param *dev   pointer to platform device
+ * @return s32   Error Code, zero: no error
+ */
+static s32 __devinit da9052_adc_probe(struct platform_device *dev)
+{
+	s32 ret;
+	
+	/* Register the device */
+	ret = register_chrdev(adc_major_number,
+				DA9052_ADC_DEVICE_NAME, &da9052_adc_fops);
+	if (ret <  0) {
+		printk(KERN_ERR "Unable to register %s\n",
+						DA9052_ADC_DEVICE_NAME);
+		return (-EFAULT);	
+	} else {
+		/* Dyanmic major no allocation */
+		adc_major_number =  ret;
+		printk(KERN_INFO "%s: Major number is: %d \n", 
+				DA9052_ADC_DEVICE_NAME, adc_major_number);
+		
+		if (da9052_adc_hw_init()) {
+			/* Error in hw initialization */
+			unregister_chrdev(adc_major_number, 		\
+						DA9052_ADC_DEVICE_NAME);
+			return (-EFAULT);
+		} else {
+			return (SUCCESS);
+		}
+	}
+	return(SUCCESS);
+}
+
+/**
+ * da9052_adc_remove: Called when ditaching device from driver
+ * @param void
+ * @return void
+ */
+static s32 __devexit da9052_adc_remove(struct platform_device *dev)
+{
+	DA9052_DEBUG(KERN_DEBUG "Removing %s \n", DA9052_ADC_DEVICE_NAME);
+	return (SUCCESS);
+}
+
+/**
+ * static struct platform_driver da9052_adc_driver -
+ * This structure definition has to be defined here as an exception.
+ * @probe: Probe function for this device. 
+ * @remove: Function to be called when removing this device from platform
+ * @driver: Contains glue logic to bind platform device and plarform driver
+ */
+static struct platform_driver da9052_adc_driver = {
+	.probe		= da9052_adc_probe,
+	.remove		= __devexit_p(da9052_adc_remove),
+	.suspend	= da9052_adc_suspend,
+	.resume		= da9052_adc_resume,
+	.driver		= {
+		.name	= DA9052_ADC_DEVICE_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+/**
+ * da9052_adc_init: Initiales the driver
+ * 
+ * @param void
+ * @return s32   Error Code, zero: no error
+ */
+static s32 __init da9052_adc_init(void)
+{
+	s32 retval;
+	printk(banner);
+
+	da9052_adc_platform_device = platform_device_alloc("da9052_adc", 0);
+	if (!da9052_adc_platform_device)
+		return (-ENOMEM);
+
+	retval = platform_device_add(da9052_adc_platform_device);
+	if (retval < 0) {
+		platform_device_put(da9052_adc_platform_device);
+		return (retval);
+	}
+
+	retval = platform_driver_register(&da9052_adc_driver);
+	if (retval < 0)
+		platform_device_unregister(da9052_adc_platform_device);
+
+	return (retval);
+}
+/**
+ * da9052_adc_exit: 
+ * 
+ * @param void
+ * @return void
+ */
+static void __exit da9052_adc_exit(void)
+{
+	da9052_adc_hw_deinit();
+	printk("DA9052: Unregistering ADC device.\n");
+	unregister_chrdev(adc_major_number, DA9052_ADC_DEVICE_NAME);
+
+	/* Platform_Device */
+	platform_driver_unregister(&da9052_adc_driver);
+	platform_device_unregister(da9052_adc_platform_device);
+}
+
+
+module_init(da9052_adc_init);
+module_exit(da9052_adc_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd");
+MODULE_DESCRIPTION("DA9052 ADC Device Driver");
+MODULE_LICENSE("GPL");
+
+/*--------------------------------------------------------------------------*/
+/* Exports                                                                  */
+/*--------------------------------------------------------------------------*/
+
+EXPORT_SYMBOL(da9052_set_adc_mode);
+EXPORT_SYMBOL(da9052_configure_thresholds);
+EXPORT_SYMBOL(da9052_set_adcin5_comparator);
+EXPORT_SYMBOL(da9052_set_tbat_source_current);
+EXPORT_SYMBOL(da9052_set_ad4_isrc_source_current);
+EXPORT_SYMBOL(da9052_start_adc);
+EXPORT_SYMBOL(da9052_stop_adc);
+EXPORT_SYMBOL(da9052_read_adc);
+EXPORT_SYMBOL(da9052_adc_set_sampling_interval);
+EXPORT_SYMBOL(da9052_adc_read_vddout);
+EXPORT_SYMBOL(da9052_adc_read_ich);
+EXPORT_SYMBOL(da9052_adc_read_tbat);
+EXPORT_SYMBOL(da9052_adc_read_vbat);
+EXPORT_SYMBOL(da9052_adc_read_tjunc);
+EXPORT_SYMBOL(da9052_adc_read_vbbat);
+/* Mutex structure required for TSI */
+EXPORT_SYMBOL(da9052_adc_manconv_lock);
diff -Naur linux-2.6.33.2/drivers/mfd/da9052_eh.c linux-2.6.33.2_patch/drivers/mfd/da9052_eh.c
--- linux-2.6.33.2/drivers/mfd/da9052_eh.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/mfd/da9052_eh.c	2010-05-18 15:29:36.000000000 +0500
@@ -0,0 +1,926 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_eh.c: Event Handler module for DA9052 PM IC
+ *
+ * DA9052 has a single IRQ line which can be used to indicate 32 various events.
+ * Event Handler (EH) module has following primary functions.
+ *
+ * (1) To receive and acknowledge interrupts from DA9052.
+ * (2) Extract all events form DA9052 event registers after receiving interrupt.
+ * (3) To provide a mechanism to register call back for specific events of
+ *     their interest, and call these call backs when corresponding event occurs.
+ * (4) To retrive, store and provide TSI data whenever requested by TSI module.
+ * 
+ * History:
+ *
+ * 12/05/2009:	Initial version
+ * 19/05/2009:	First unit tested version
+ *
+ * 27/04/2010	Created initial draft for Linux community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+/*--------------------------------------------------------------------------*/
+/* System wide include files                                                */
+/*--------------------------------------------------------------------------*/
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <asm/gpio.h>
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+#include <linux/mfd/da9052/da9052_reg.h>
+#include <linux/mfd/da9052/da9052_lib.h>
+#include <linux/mfd/da9052/da9052_eh.h>
+
+#if(ARCH_DEPENDENT_DA9052)
+#include <asm/mach/irq.h>
+#include <asm/delay.h>
+#include <plat/gpio-cfg.h>
+#endif
+
+/*--------------------------------------------------------------------------*/
+/* Local Type Definitions                                                   */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Local Constant Definitions                                               */
+/*--------------------------------------------------------------------------*/
+static u8 banner[] __initdata = "DA9052 Event Handler (EH) Driver, v1.0\n";
+
+/*--------------------------------------------------------------------------*/
+/* Local Macro Definitions                                                  */
+/*--------------------------------------------------------------------------*/
+
+/* Increment with wrap operation for TSI FIFO */
+#define incr_with_wrap(x)	\
+		if(++x >= TSI_FIFO_SIZE)	\
+			x = 0
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+da9052_eh_info eh_info;
+da9052_tsi tsi_info;
+
+/* Master function to process events */
+static s32 process_events(s32 events_sts);
+
+/* Function to process TSI related events */
+static s32 process_tsi_event(u8 event);
+
+/* Work queue function, heart of EH! */
+void eh_workqueue_isr(struct work_struct* work);
+
+/*--------------------------------------------------------------------------*/
+/* Local Functions                                                          */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * da9052_eh_setup_irq:	Function to setup IRQ line which is connected to DA9052 
+ * @param void	
+ * @return void
+ */
+static void da9052_eh_setup_irq(void)
+{
+	/* Put your platform and board specific code here */
+#if (ARCH_DEPENDENT_DA9052)	
+	/* Set up GPI which is connected to nIRQ of DA9052 */
+	s3c_gpio_setpull(DA9052_IRQ_PIN, S3C_GPIO_PULL_UP);
+	
+	/* Set GPI as LOW LEVEL interrupt source */ 
+	set_irq_type(DA9052_IRQ, IRQ_TYPE_LEVEL_LOW);
+#else
+	printk(KERN_CRIT "Configure the interrupt for DA9052 as per the target x86 platform \n");
+#endif	
+}
+
+/**
+ * da9052_eh_restore_irq:Function to free IRQ line which is connected to DA9052 
+ * @param void	
+ * @return void
+ */
+static void da9052_eh_restore_irq(void)
+{
+	/* Put your platform and board specific code here */
+	free_irq(DA9052_IRQ, NULL);
+}
+
+/**
+ * da9052_eh_isr: ISR to handle interrupts from DA9052
+ * 
+ * @param irq	IRQ number
+ * @param *dev_id Accociated device id
+ * @return irqreturn_t
+ */
+static irqreturn_t da9052_eh_isr(int irq, void *dev_id)
+{	
+	/* Schedule work to be done */
+	schedule_work(&eh_info.eh_isr_work);
+	
+#if (ARCH_DEPENDENT_DA9052)	
+	/* Disable IRQ */
+	disable_irq_nosync(DA9052_IRQ);
+	
+	return (IRQ_HANDLED);
+#else
+	return (IRQ_NONE);
+#endif	
+}
+
+/**
+ * da9052_eh_init_eve_prio_map:	Initialize mapping of EVENTS with their PRIORITIES
+ * @param void	
+ * @return void
+ */
+static void da9052_eh_init_eve_prio_map(void)
+{
+	/*
+	 * Initialize priority array by assigning corresponding event for each
+	 * priotiry
+	*/
+	eh_info.eve_prio_map[PRIO_0] = PRIO_0_EVE;
+	eh_info.eve_prio_map[PRIO_1] = PRIO_1_EVE;
+	eh_info.eve_prio_map[PRIO_2] = PRIO_2_EVE;
+	eh_info.eve_prio_map[PRIO_3] = PRIO_3_EVE;
+	eh_info.eve_prio_map[PRIO_4] = PRIO_4_EVE;
+	eh_info.eve_prio_map[PRIO_5] = PRIO_5_EVE;
+	eh_info.eve_prio_map[PRIO_6] = PRIO_6_EVE;
+	eh_info.eve_prio_map[PRIO_7] = PRIO_7_EVE;
+	eh_info.eve_prio_map[PRIO_8] = PRIO_8_EVE;
+	eh_info.eve_prio_map[PRIO_9] = PRIO_9_EVE;
+	eh_info.eve_prio_map[PRIO_10] = PRIO_10_EVE;
+	eh_info.eve_prio_map[PRIO_11] = PRIO_11_EVE;
+	eh_info.eve_prio_map[PRIO_12] = PRIO_12_EVE;
+	eh_info.eve_prio_map[PRIO_13] = PRIO_13_EVE;
+	eh_info.eve_prio_map[PRIO_14] = PRIO_14_EVE;
+	eh_info.eve_prio_map[PRIO_15] = PRIO_15_EVE;
+	eh_info.eve_prio_map[PRIO_16] = PRIO_16_EVE;
+	eh_info.eve_prio_map[PRIO_17] = PRIO_17_EVE;
+	eh_info.eve_prio_map[PRIO_18] = PRIO_18_EVE;
+	eh_info.eve_prio_map[PRIO_19] = PRIO_19_EVE;
+	eh_info.eve_prio_map[PRIO_20] = PRIO_20_EVE;
+	eh_info.eve_prio_map[PRIO_21] = PRIO_21_EVE;
+	eh_info.eve_prio_map[PRIO_22] = PRIO_22_EVE;
+	eh_info.eve_prio_map[PRIO_23] = PRIO_23_EVE;
+	eh_info.eve_prio_map[PRIO_24] = PRIO_24_EVE;
+	eh_info.eve_prio_map[PRIO_25] = PRIO_25_EVE;
+	eh_info.eve_prio_map[PRIO_26] = PRIO_26_EVE;
+	eh_info.eve_prio_map[PRIO_27] = PRIO_27_EVE;
+	eh_info.eve_prio_map[PRIO_28] = PRIO_28_EVE;
+	eh_info.eve_prio_map[PRIO_29] = PRIO_29_EVE;
+	eh_info.eve_prio_map[PRIO_30] = PRIO_30_EVE;
+	eh_info.eve_prio_map[PRIO_31] = PRIO_31_EVE;
+}
+
+/*--------------------------------------------------------------------------*/
+/* Global Functions                                                         */
+/*--------------------------------------------------------------------------*/
+/**
+ * da9052_eh_register_nb:	Function to register a notifier block
+ * @param nb	: Notifier block to register
+ * @return s32	: Status of registration
+ */
+s32 da9052_eh_register_nb(da9052_eh_nb* nb){
+	
+	if(nb == NULL){
+		/* Invalid notifier block */
+		return (INVALID_NB);
+	}
+	
+	if(nb->eve_type >= EVE_CNT){
+		/* Invalid event type */
+		return (INVALID_EVE);
+	}
+		
+	DA9052_DEBUG("%s() called for event %d \n", __FUNCTION__, nb->eve_type);
+
+	/* Initialize list head inside notifier block */
+	INIT_LIST_HEAD(&nb->nb_list);
+	
+	/* Acqurie NB array lock */
+	if(down_interruptible(&eh_info.eve_nb_array_lock))
+		return (FAILURE);
+	
+	/* Add passed NB to corresponsing EVENT list */
+	list_add_tail(&nb->nb_list, &(eh_info.eve_nb_array[nb->eve_type].nb_list));
+	
+	/* Release NB array lock */
+	up(&eh_info.eve_nb_array_lock);
+	
+	return (SUCCESS);
+}
+
+/**
+ * da9052_eh_unregister_nb:	Function to de-register a notifier block
+ *
+ * Caller must not pass any non-existing notifier block or notifiler block
+ * that has already been de-registered. Its caller's responsibility to 
+ * allocate/deallocate memory associated with notifier block. EH will only 
+ * Link/De-Link passed notifier blocks.
+ *
+ * @param nb	: Notifier block to unregister
+ * @return s32	: Status of unregistration
+ */
+s32 da9052_eh_unregister_nb(da9052_eh_nb* nb){
+	
+	if(nb == NULL)
+		return (INVALID_NB);
+	
+	DA9052_DEBUG("%s() called for event %d \n", __FUNCTION__, nb->eve_type);
+	
+	/* Acqurie nb array lock */
+	if(down_interruptible(&eh_info.eve_nb_array_lock))
+		return (FAILURE);
+	
+	/* Remove passed NB from list */
+	list_del_init(&(nb->nb_list));
+	
+	/* Release NB array lock */
+	up(&eh_info.eve_nb_array_lock);
+	
+	return (SUCCESS);
+}
+
+/**
+ * da9052_tsi_start_sampling:	Called by TSI driver to indicate start of data
+ * sampling
+ * @param void
+ * @return int status
+ */
+s32 da9052_tsi_start_sampling(void){
+	
+	/* This request is only valid when we are waiting for one */
+	if(tsi_info.tsi_state == WAIT_FOR_SAMPLING){
+		DA9052_DEBUG("__%s__ \n", __FUNCTION__);
+		tsi_info.tsi_state =  SAMPLING_ACTIVE;
+		return (SUCCESS);
+	}
+	else{
+		DA9052_DEBUG("Invalid request for da9052_tsi_start_sampling() \n");
+		return (FAILURE);
+	}	
+}
+
+/**
+ * da9052_tsi_stop_sampling:	Called by TSI driver to indicate end of data
+ * sampling
+ * @param void
+ * @return int status
+ */
+s32 da9052_tsi_stop_sampling(void){
+	
+	/* Irrespective of current state, move to initial state */
+	DA9052_DEBUG("__%s__ \n", __FUNCTION__);
+	tsi_info.tsi_state =  WAIT_FOR_PEN_DOWN;
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_tsi_get_data:	Called by TSI driver to fetch sampled data
+ *
+ * This function tries to copy cnt number of samples into tsi fifo.
+ * If available samples are less than cnt, then it copies all available
+ * samples and returns number of samples copied.
+ *
+ * @param buf pointer tsi fifo
+ * @param cnt number of samples to be copied
+ * @return int number of samples copied in to tsi fifo
+ */
+s32 da9052_tsi_get_data(da9052_tsi_reg *buf, u8 cnt){
+	
+	u32 data_cnt = 0;
+	u32 rem_data_cnt = 0;
+	
+	/* Acquire TSI FIFO lock */
+	if(down_interruptible(&tsi_info.tsi_fifo_lock))
+		return (0);
+
+	if(tsi_info.tsi_fifo_start < tsi_info.tsi_fifo_end){
+		/* FIFO partly or completely full but NOT overflown */
+		
+		/* Get available data count */
+		data_cnt = (tsi_info.tsi_fifo_end - tsi_info.tsi_fifo_start);
+		
+		/* Now see how much data is requested */
+		if(cnt < data_cnt)
+			data_cnt = cnt;
+		
+		/* Copy requested (or available in case if not enough data) data */
+		memcpy(buf, &tsi_info.tsi_fifo[tsi_info.tsi_fifo_start], sizeof(da9052_tsi_reg)*data_cnt);
+		
+		/* update start pointer */
+		tsi_info.tsi_fifo_start += data_cnt;
+		
+		/* Reset both pointers if fifo in empty */
+		if(tsi_info.tsi_fifo_start == tsi_info.tsi_fifo_end){
+			//DA9052_DEBUG("1:FIFO Empty after copying \n");
+			tsi_info.tsi_fifo_start = 0;
+			tsi_info.tsi_fifo_end = 0;
+		}
+	}
+	else if(tsi_info.tsi_fifo_start > tsi_info.tsi_fifo_end){
+		/* 
+		 * Overflow occured, FIFO may be full 
+		 * Data is devided in to two parts in fifo
+		 */
+		
+		/* Get available data count */
+		data_cnt = ((TSI_FIFO_SIZE - tsi_info.tsi_fifo_start) + tsi_info.tsi_fifo_end);
+		
+		/* Now see how much data is requested */
+		if(cnt < data_cnt)
+			data_cnt = cnt;
+	
+		/* Check if we need to copy data from both parts or only one part */
+		if(data_cnt <= (TSI_FIFO_SIZE - tsi_info.tsi_fifo_start)){
+			/* We only need to copy data from first part */
+			/* Copy from start ptr till required lenght */
+			memcpy(buf, &tsi_info.tsi_fifo[tsi_info.tsi_fifo_start], 
+					sizeof(da9052_tsi_reg)*data_cnt);
+			
+			/* update start pointer */
+			tsi_info.tsi_fifo_start += data_cnt;
+			if(tsi_info.tsi_fifo_start >= TSI_FIFO_SIZE)
+				tsi_info.tsi_fifo_start = 0;
+		}else{
+			/* We need to copy data from both parts */
+			
+			/* First copy from start ptr till end of fifo */
+			memcpy(buf, &tsi_info.tsi_fifo[tsi_info.tsi_fifo_start], 
+					sizeof(da9052_tsi_reg)*(TSI_FIFO_SIZE - tsi_info.tsi_fifo_start));
+			
+			rem_data_cnt = (data_cnt - (TSI_FIFO_SIZE - tsi_info.tsi_fifo_start));
+			 
+			/* Then copy from start of fifo till required length */
+			memcpy(buf, &tsi_info.tsi_fifo[0], sizeof(da9052_tsi_reg) * rem_data_cnt);
+			
+			/* update start pointer */
+			tsi_info.tsi_fifo_start = rem_data_cnt;
+		}
+		
+		/* Reset both pointers if fifo in empty */
+		if(tsi_info.tsi_fifo_start == tsi_info.tsi_fifo_end){
+			//DA9052_DEBUG("2:FIFO Empty after copying \n");
+			tsi_info.tsi_fifo_start = 0;
+			tsi_info.tsi_fifo_end = 0;
+		}
+	}
+	else{
+		/* FIFO empty */
+		data_cnt = 0;
+	}
+	
+	/* Release TSI FIFO lock */
+	up(&tsi_info.tsi_fifo_lock);
+	
+	//DA9052_DEBUG("Copy Cnt - %d \n", data_cnt);
+	return (data_cnt);
+}
+
+/**
+ * eh_workqueue_isr:	Function to perform actual work of EH 
+ * @param
+ * @return int
+ */
+void eh_workqueue_isr(struct work_struct* work){
+	
+	da9052_ssc_msg eve_data[4];
+	s32 events_sts, ret;
+	u8 cnt = 0;
+	
+	//unsigned long start = 0;
+	
+	/* nIRQ is asserted, read event registeres to know what happered */
+	events_sts = 0;
+	
+	/* Prepare ssc message to read all four event registers */
+	for(cnt=0; cnt < 4; cnt++){
+		eve_data[cnt].addr = (DA9052_EVENTA_REG + cnt);
+		eve_data[cnt].data = 0;
+	}
+	
+	/* Now read all event registers */
+	ret = da9052_ssc_read_many(eve_data, 4);
+	if(ret != SUCCESS) {
+		DA9052_DEBUG("da9052_ssc_read_many failed in %s \n", __FUNCTION__);
+		
+		enable_irq(DA9052_IRQ);
+		return;
+	}
+	
+	/* Collect all events */
+	for(cnt=0; cnt < 4; cnt++){
+		events_sts |= (eve_data[cnt].data << (8 * cnt));
+	}
+	
+	/*
+	 * Check if we really got any event. If we haven't got any event then this 
+	 * may be a fake interrupt. Just ignore it and come out of this function
+	 * without wasting any time in processing
+	 */
+	if(events_sts == 0){
+        //printk(KERN_CRIT "Fake   Interrupt!!! \n");
+		enable_irq(DA9052_IRQ);
+		return;
+	}
+	
+	//DA9052_DEBUG("Events = 0x%8.8x \n", events_sts);
+	
+	/* Process all events occured */
+	process_events(events_sts);
+
+	/* Now clear EVENT registers */
+    for(cnt=0; cnt < 4; cnt++){
+		/* Here we clear only those registers which have some event(s) set */
+		if(eve_data[cnt].data){
+            ret = da9052_ssc_write(&eve_data[cnt]);
+			if(ret != SUCCESS) {
+				DA9052_DEBUG("da9052_ssc_write_many failed in %s \n", __FUNCTION__);
+				enable_irq(DA9052_IRQ);
+				return;
+			}
+		}
+    }
+	/*
+	 * This delay is necessary to avoid hardware fake interrupts from DA9052.
+	 * Because of the 33 us internal delay in sync operation of DA9052, nIRQ line
+	 * changes state from LOW to HIGH after max. 33 us of clearing event register.
+	 * If we don't wait for this time (by adding udelay()) before re-enabling the
+	 * IRQ, we will immediately get another interrupt, as it is configured as 
+	 * LOW LEVEL triggered. Experiments showed that delay of 50 us seems to be
+	 * safe enough to get rid of fake interrupts.
+	 */
+	udelay(50);
+	
+	//printk(KERN_CRIT "T=%d ", (jiffies - start));
+	
+	/* Enable HOST interrupt */
+	enable_irq(DA9052_IRQ);
+}
+
+/**
+ * process_events: Function to process all events occured
+ * @param
+ * @return int
+ */
+static s32 process_events(s32 events_sts){
+	
+	s32 cnt = 0;
+	s32 tmp_events_sts = 0;
+	u8 event = 0;
+		
+	struct list_head *ptr;
+	da9052_eh_nb *nb_ptr;
+	
+	//DA9052_DEBUG("__%s__\n", __FUNCTION__);
+
+	/* Now we have retrieved all events, process them one by one */
+	for(cnt = 0; cnt < PRIO_CNT; cnt++){
+		
+		/* Starting with highest priority event,traverse through all event */
+		
+		tmp_events_sts = events_sts;
+		
+		/* Find the event associted with higher priority */
+		event = eh_info.eve_prio_map[cnt];
+		
+		/* Check if interrupt is received for this event */
+		if(!((tmp_events_sts >> event) & 0x1)) {
+			
+			/* Event bit is not set for this event */
+			/* Move to next priority event */
+			continue;
+		}
+		
+		//DA9052_DEBUG("Event - %d occured \n", event);
+		
+		/*
+		 * PEN DOWN event has to be handled in a special way. It should be
+		 * ignored in following cases.
+		 * (1)	If we are in a state other than WAIT_FOR_PEN_DOWN, i.e.
+		 *	we have already received PEN DOWN
+		 * (2)	If TSI hasn't registered (or deregistered) call back for
+		 *	PEN DOWN, i.e. One possible case when TSI does this is
+		 *	while shifting from AUTO to MANUAL mode 
+		 */
+		if(event == PEN_DOWN_EVE){
+			if((tsi_info.tsi_state != WAIT_FOR_PEN_DOWN) || 
+				list_empty(&(eh_info.eve_nb_array[event].nb_list)))
+				continue;
+		}
+		
+		/* Valid TSI event, process it */
+		if((event == TSI_READY_EVE) || (event == PEN_DOWN_EVE))
+			process_tsi_event(event);
+
+		/* Event bit is set, execute all registered call backs */
+		if(down_interruptible(&eh_info.eve_nb_array_lock)){
+			printk(KERN_CRIT "Can't acquire eve_nb_array_lock \n");
+			return (FAILURE);
+		}
+		
+		list_for_each(ptr, &(eh_info.eve_nb_array[event].nb_list)){
+			
+			/*
+			 * nb_ptr will point to the structure in which nb_list
+			 * is embedded
+			 */
+			nb_ptr = list_entry(ptr, da9052_eh_nb, nb_list);
+			
+			//DA9052_DEBUG("Executing call back @ 0x%8.8x \n", nb_ptr->call_back);
+			nb_ptr->call_back(events_sts);
+		}		
+		up(&eh_info.eve_nb_array_lock);
+	}
+	return (SUCCESS);
+}
+
+
+/**
+ * process_tsi_event: Function to process all TSI related events
+ * @param 
+ * @return int
+ */
+static s32 process_tsi_event(u8 event){
+	
+	s32 ret = 0;
+	da9052_ssc_msg tsi_data[4];
+	
+	//DA9052_DEBUG("__%s__\n", __FUNCTION__);
+	
+	switch(tsi_info.tsi_state){
+		case WAIT_FOR_PEN_DOWN:
+			if(event == PEN_DOWN_EVE){
+				DA9052_DEBUG("PEN DOWN Detected \n");
+				/* Move to WAIT_FOR_SAMPLING state */
+				tsi_info.tsi_state = WAIT_FOR_SAMPLING;
+			}
+			break;
+				
+		case WAIT_FOR_SAMPLING:
+			/* Do nothing */
+			break;
+				
+		case SAMPLING_ACTIVE:
+			if(event == TSI_READY_EVE){
+				/* Read TSI registers */
+				/*Read 107, 108, 109 & 110 */
+				tsi_data[0].addr  = DA9052_TSIXMSB_REG;
+				tsi_data[1].addr  = DA9052_TSIYMSB_REG;
+				tsi_data[2].addr  = DA9052_TSILSB_REG;
+				tsi_data[3].addr  = DA9052_TSIZMSB_REG;
+					
+				tsi_data[0].data  = 0;
+				tsi_data[1].data  = 0;
+				tsi_data[2].data  = 0;
+				tsi_data[3].data  = 0;
+				
+				//ret = da9052_ssc_read_many(tsi_data, 4);
+				ret = da9052_ssc_read_many(tsi_data, 4);
+				if(ret != SUCCESS) {
+					DA9052_DEBUG("Error in reading TSI data \n" );
+					return (FAILURE);
+				}
+				/* Put this sample in TSI FIFO */
+				/* Acqurie TSI FIFO lock */
+				if(down_interruptible(&tsi_info.tsi_fifo_lock))
+					break;
+				tsi_info.tsi_fifo[tsi_info.tsi_fifo_end].x_msb = tsi_data[0].data;
+				tsi_info.tsi_fifo[tsi_info.tsi_fifo_end].y_msb = tsi_data[1].data;
+				tsi_info.tsi_fifo[tsi_info.tsi_fifo_end].lsb   = tsi_data[2].data;
+				tsi_info.tsi_fifo[tsi_info.tsi_fifo_end].z_msb = tsi_data[3].data;
+				incr_with_wrap(tsi_info.tsi_fifo_end);
+				
+				//DA9052_DEBUG("X_MSB = 0x%8.8x \n", tsi_data[0].data); 
+				
+				/* Check if we have reached at the end of fifo */
+				if(tsi_info.tsi_fifo_end == tsi_info.tsi_fifo_start)
+					tsi_info.tsi_fifo_start++;
+				/* Release TSI FIFO lock */
+				up(&tsi_info.tsi_fifo_lock);
+			}
+			break;
+		default:
+			break;
+	}
+	return (SUCCESS);
+}
+
+
+/**
+ * dump_nb_tree: Prints NB tree for all events on console.
+ * This function is purely for DEBUG purpose
+ * @param
+ * @return void
+ */
+void dump_nb_tree(void){
+	
+	da9052_eh_nb *nb_ptr;
+	struct list_head *ptr;
+	u8 cnt = 0;
+	
+	/* Now we have retrieved all events, process them one by one */
+	for(cnt = 0; cnt < EVE_CNT; cnt++){
+
+		printk(KERN_CRIT "NB_LIST[%2.2d]--> ", cnt);
+		/* Check if it's nb list contains atleast one nb for this event */
+
+		/* Event bit is set and there are registered nbs for this event */
+		/* Execute all registered call backs */
+		
+		list_for_each(ptr, &(eh_info.eve_nb_array[cnt].nb_list)){			
+			/*
+			 * nb_ptr will point to the structure in which nb_list
+			 * is embedded
+			 */
+			nb_ptr = list_entry(ptr, da9052_eh_nb, nb_list);
+			printk(" [%d] ", nb_ptr->eve_type);
+		}
+		printk(KERN_CRIT " \n");
+	}
+	if(cnt == EVE_CNT)
+		printk(KERN_CRIT " \n");
+}
+
+/*--------------------------------------------------------------------------*/
+/* Infrastructure Functions                                                 */
+/*--------------------------------------------------------------------------*/
+/**
+ * da9052_eh_open: Function that is called when some one opens EH device node
+ * 
+ * @param *inode pointer to device inode
+ * @param *file  file pointer
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_eh_open(struct inode *inode, struct file *file)
+{
+	/* Check if device is already open */
+	if(eh_info.device_open) {
+		printk( KERN_INFO "DA9052: EH device already open.\n");
+		return (-EBUSY);
+	} else {
+		eh_info.device_open++;
+		return (SUCCESS);
+	}
+}
+
+/**
+ * da9052_eh_release:	Function that is called when some one closes EH device node
+ * 
+ * @param *inode pointer to device inode
+ * @param *file  file pointer
+ * @return s32   Error Code, zero: no error
+ */
+s32 da9052_eh_release(struct inode *inode, struct file *file)
+{
+	eh_info.device_open--;
+	printk( KERN_INFO "DA9052: EH device closed.\n");
+	return (SUCCESS);
+}
+
+/**
+ * da9052_eh_suspend: Power Management support function
+ * 
+ * @param *dev   pointer to platform device
+ * @param state  pm state
+ * @return s32 status of suspend operation
+ */
+static s32 da9052_eh_suspend(struct platform_device *dev, pm_message_t state)
+{
+	/* Put your suspend related operations here */
+	printk(KERN_INFO "%s: called\n", __FUNCTION__);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_eh_resume: Power Management support function
+ * 
+ * @param *dev   pointer to platform device
+ * @return s32 status of resume operation
+ */
+static s32 da9052_eh_resume(struct platform_device *dev)
+{
+	/* Put your resume related operations here */
+	printk(KERN_INFO "%s: called\n", __FUNCTION__);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_eh_ioctl: Function that is called when some one calls ioctl() on SSC device node
+ * 
+ * @param *inode Inode number of device node
+ * @param *file  File pointer
+ * @param cmd	ioctl command to be executed
+ * @param arg	arguments for cmd
+ * @return s32	status of executing cmd
+ */
+s32 da9052_eh_ioctl(struct inode *inode, struct file *file, 
+					unsigned int cmd, unsigned long arg)
+{	
+	DA9052_DEBUG("IOCTL - %d \n", cmd);
+	
+	switch(cmd) {
+		
+		case DA9052_IOCTL_EH_DUMP_TREE:
+			DA9052_DEBUG("IOCTL - %d \n", cmd);
+			dump_nb_tree();
+			break;
+		default:
+			DA9052_DEBUG("INVALID IOCTL - %d \n", cmd);
+			break;
+	}
+	
+	return (SUCCESS);
+}
+
+/**
+ * static struct file_operations da9052_eh_fops  
+ * This structure definition has to be defined here as an exception. 
+ * @owner: Owner of this module
+ * @open : open() function for this module
+ * @release: release() function for this module
+ * @ioctl: ioctl() function for this module
+ */
+static const struct file_operations da9052_eh_fops = {
+        .owner          = THIS_MODULE,
+        .open           = da9052_eh_open,
+        .release        = da9052_eh_release,
+        .ioctl          = da9052_eh_ioctl
+};
+
+
+/**
+ * da9052_eh_probe: Called when a device gets attached to driver 
+ * 
+ * @param *dev   pointer to platform device
+ * @return int   Error Code, zero: no error
+ */
+static s32 __devinit da9052_eh_probe(struct platform_device *dev)
+{
+	s32 result, cnt;
+	
+	printk(KERN_INFO "IN DA9052 EH driver: Probe function \n");
+
+	/* Register the device */
+	result = register_chrdev(eh_info.major_number, 
+				 DA9052_EH_DEVICE_NAME, &da9052_eh_fops);
+	if(result < 0) {
+		printk(KERN_ERR "Unable to register %s\n", 
+		       DA9052_EH_DEVICE_NAME);
+		return (-EFAULT);	
+	} else {
+		eh_info.major_number = result;
+		printk(KERN_INFO "%s: Major number is: %d \n",
+		       DA9052_EH_DEVICE_NAME, eh_info.major_number);
+	}
+	
+	/* Initialize priority map with statically defined priorities */
+	da9052_eh_init_eve_prio_map();
+	
+	/* Initialize eve_nb_array */
+	for(cnt = 0; cnt < EVE_CNT; cnt++)
+		INIT_LIST_HEAD(&(eh_info.eve_nb_array[cnt].nb_list));
+	
+	/* Initialize NB array lock */
+	init_MUTEX(&eh_info.eve_nb_array_lock);
+
+	/* Initialize TSI FIFO lock */
+	init_MUTEX(&tsi_info.tsi_fifo_lock);
+
+	/* Setup IRQ line */
+	da9052_eh_setup_irq();
+	
+	/* Set state of TSI state machine */
+	tsi_info.tsi_state = WAIT_FOR_PEN_DOWN;
+		
+	INIT_WORK(&eh_info.eh_isr_work, eh_workqueue_isr);
+	
+	if (request_irq(DA9052_IRQ, da9052_eh_isr, IRQ_TYPE_LEVEL_LOW, DA9052_EH_DEVICE_NAME, NULL)) {
+		unregister_chrdev(eh_info.major_number, DA9052_EH_DEVICE_NAME);
+		printk(KERN_ERR "Can't register IRQ - %d for da9052_eh_isr!\n", DA9052_IRQ);
+		return (-EIO);
+	}else{
+		printk(KERN_INFO "DA9052 IRQ - %d registered successfully \n", DA9052_IRQ);
+	}
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_eh_remove: Called when detaching device from driver
+ * @param *dev   pointer to platform device
+ * @return int   Error Code, zero: no error
+ */
+static int __devexit da9052_eh_remove(struct platform_device *dev)
+{
+	DA9052_DEBUG(KERN_DEBUG "Removing %s \n", DA9052_EH_DEVICE_NAME);
+	return (SUCCESS);
+}
+
+/**
+ * static struct platform_driver da9052_eh_driver -
+ * @probe: Probe function for this device. 
+ * @remove: Function to be called when removing this device from platform
+ * @suspend: Function to be called in suspend mode
+ * @resume: Function to be called in resume mode
+ * @driver: Contains glue logic to bind platform device and plarform driver
+ */
+static struct platform_driver da9052_eh_driver = {
+	.probe		= da9052_eh_probe,
+	.remove		= __devexit_p(da9052_eh_remove),
+	.suspend	= da9052_eh_suspend,
+	.resume		= da9052_eh_resume,
+	.driver		= {
+		.name	= DA9052_EH_DEVICE_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+
+/**
+ * da9052_eh_init:	Function that gets called at the time of module loading
+ * @param void
+ * @return int status of module initialization
+ */
+static s32 __init da9052_eh_init(void)
+{
+	s32 ret;
+	
+	printk(banner);
+
+	/* Initialize the parameters of the global eh structure */
+	eh_info.device_open = 0;
+	eh_info.major_number = 0;
+	
+	/* Initialize the parameters of the global tsi structure */
+	tsi_info.tsi_sampling = INACTIVE;
+	tsi_info.tsi_state = WAIT_FOR_PEN_DOWN;
+	tsi_info.tsi_fifo_start = 0;
+	tsi_info.tsi_fifo_end = 0;
+	
+	eh_info.da9052_eh_platform_device = platform_device_alloc("da9052_eh", 0);
+	if (!eh_info.da9052_eh_platform_device)
+		return (-ENOMEM);
+
+	/* Add platform device to device hierarchy */
+	ret = platform_device_add(eh_info.da9052_eh_platform_device);
+	if (ret < 0) {
+		/* Free all memory associated with a platform device */
+		platform_device_put(eh_info.da9052_eh_platform_device);
+		return (ret);
+	}
+
+	ret = platform_driver_register(&da9052_eh_driver);
+	if (ret < 0)
+		/* Unregister the platform level device */
+		platform_device_unregister(eh_info.da9052_eh_platform_device);
+
+	return (ret);
+}
+
+/**
+ * da9052_eh_exit:	Function that gets called at the time of module unloading
+ * @param void
+ * @return void
+ */
+static void __exit da9052_eh_exit(void)
+{
+	printk(KERN_INFO "DA9052: Unregistering EH device.\n");
+	
+	unregister_chrdev(eh_info.major_number, DA9052_EH_DEVICE_NAME);
+		
+	/* Restore IRQ line */
+	da9052_eh_restore_irq();
+	
+	platform_driver_unregister(&da9052_eh_driver);
+	
+	/* Unregister the platform level device */
+	platform_device_unregister(eh_info.da9052_eh_platform_device);
+}
+
+module_init(da9052_eh_init);
+module_exit(da9052_eh_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd");
+MODULE_DESCRIPTION("DA9052 EH Device Driver");
+MODULE_LICENSE("GPL");
+
+/*--------------------------------------------------------------------------*/
+/* Exports                                                                  */
+/*--------------------------------------------------------------------------*/
+EXPORT_SYMBOL(da9052_eh_register_nb);
+EXPORT_SYMBOL(da9052_eh_unregister_nb);
+EXPORT_SYMBOL(da9052_tsi_start_sampling);
+EXPORT_SYMBOL(da9052_tsi_stop_sampling);
+EXPORT_SYMBOL(da9052_tsi_get_data);
diff -Naur linux-2.6.33.2/drivers/mfd/da9052_ssc.c linux-2.6.33.2_patch/drivers/mfd/da9052_ssc.c
--- linux-2.6.33.2/drivers/mfd/da9052_ssc.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/mfd/da9052_ssc.c	2010-05-18 15:29:36.000000000 +0500
@@ -0,0 +1,1434 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_ssc.h: SSC (Synchronous Serial Communication) driver for DA9052
+ *
+ * This driver provides DA9052 specific wrappers around SPI and I2C host -
+ * drivers.
+ *
+ *
+ * History:
+ *
+ * 05/05/2009:	Initial version.
+ *		This version supports only SPI communication.
+ *		Hooks to underlying host SPI driver are very specific to -
+ *		SMDK-6410 host driver and some what non standard.
+ *		Curent version only supports SPI communication.
+ *		Support for I2C will be added in later versions.
+ *
+ * 27/06/2009:	Added caching feature for DA9052 Non-volatile registers
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
+#include <linux/fs.h>
+#include <asm/uaccess.h>
+#include <linux/device.h>
+#include <linux/jiffies.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+
+/* SPI specific include files */
+#if defined (CONFIG_MFD_DA9052_SPI)
+#include <linux/spi/spi.h>
+/* I2C specific include files */
+#elif defined (CONFIG_MFD_DA9052_I2C)
+#include <linux/i2c.h>
+#endif
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+#include <linux/mfd/da9052/da9052_reg.h>
+#include <linux/mfd/da9052/da9052_lib.h>
+#include <linux/mfd/da9052/da9052_ssc.h>
+
+/*--------------------------------------------------------------------------*/
+/* Local Type Definitions                                                   */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Local Constant Definitions                                               */
+/*--------------------------------------------------------------------------*/
+static u8 banner[] __initdata = "DA9052 SSC Driver, v1.0\n";
+
+/*--------------------------------------------------------------------------*/
+/* Local Macro Definitions                                                  */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+da9052_ssc_info ssc_info;
+
+/*--------------------------------------------------------------------------*/
+/* Local Functions                                                          */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * da9052_init_ssc_cache: Initializes SSC regsiter cache
+ * Here we define which DA9052 regiters are Volatile and which are not
+ * Current definitions are according to 14th May 2009 data sheet of DA9052.
+ * This also sets cache status as invalid for all entries to enable reading -
+ * values from hardware for first read request.
+ * @param
+ * @return void
+ */
+static void da9052_init_ssc_cache(void)
+{
+	u8 cnt;
+
+	/* First initialize all registers as Non-volatile */
+	for(cnt = 0; cnt < DA9052_REG_CNT; cnt++){
+		ssc_info.ssc_cache[cnt].type = NON_VOLATILE;
+		ssc_info.ssc_cache[cnt].status = INVALID;
+		ssc_info.ssc_cache[cnt].val = 0;
+	}
+	
+	/* Now selectively set type for all Volatile registers */
+	ssc_info.ssc_cache[DA9052_STATUSA_REG].type	= VOLATILE;	// Reg - 1
+	ssc_info.ssc_cache[DA9052_STATUSB_REG].type	= VOLATILE;	// Reg - 2
+	ssc_info.ssc_cache[DA9052_STATUSC_REG].type	= VOLATILE;	// Reg - 3
+	ssc_info.ssc_cache[DA9052_STATUSD_REG].type	= VOLATILE;	// Reg - 4
+	ssc_info.ssc_cache[DA9052_EVENTA_REG].type	= VOLATILE;	// Reg - 5
+	ssc_info.ssc_cache[DA9052_EVENTB_REG].type	= VOLATILE;	// Reg - 6
+	ssc_info.ssc_cache[DA9052_EVENTC_REG].type	= VOLATILE;	// Reg - 7
+	ssc_info.ssc_cache[DA9052_EVENTD_REG].type	= VOLATILE;	// Reg - 8
+	ssc_info.ssc_cache[DA9052_FAULTLOG_REG].type	= VOLATILE;	// Reg - 9
+
+	ssc_info.ssc_cache[DA9052_CONTROLB_REG].type	= VOLATILE;	// Reg - 15
+
+	ssc_info.ssc_cache[DA9052_CONTROLD_REG].type	= VOLATILE;	// Reg - 17
+
+	ssc_info.ssc_cache[DA9052_SUPPLY_REG].type	= VOLATILE;	// Reg - 60
+
+	ssc_info.ssc_cache[DA9052_CHGBUCK_REG].type	= VOLATILE;	// Reg - 62
+
+	ssc_info.ssc_cache[DA9052_INPUTCONT_REG].type	= VOLATILE;	// Reg - 67
+	ssc_info.ssc_cache[DA9052_CHGTIME_REG].type	= VOLATILE;	// Reg - 68
+
+	ssc_info.ssc_cache[DA9052_BOOST_REG].type	= VOLATILE;	// Reg - 70
+
+	ssc_info.ssc_cache[DA9052_ADCMAN_REG].type	= VOLATILE;	// Reg - 81
+
+	ssc_info.ssc_cache[DA9052_ADCRESL_REG].type	= VOLATILE;	// Reg - 83
+	ssc_info.ssc_cache[DA9052_ADCRESH_REG].type	= VOLATILE;	// Reg - 84
+	ssc_info.ssc_cache[DA9052_VDDRES_REG].type	= VOLATILE;	// Reg - 85
+
+	ssc_info.ssc_cache[DA9052_ICHGAV_REG].type	= VOLATILE;	// Reg - 87
+
+	ssc_info.ssc_cache[DA9052_TBATRES_REG].type	= VOLATILE;	// Reg - 90
+
+	ssc_info.ssc_cache[DA9052_ADCIN4RES_REG].type	= VOLATILE;	// Reg - 95
+
+	ssc_info.ssc_cache[DA9052_ADCIN5RES_REG].type	= VOLATILE;	// Reg - 98
+
+	ssc_info.ssc_cache[DA9052_ADCIN6RES_REG].type	= VOLATILE;	// Reg - 101
+
+	ssc_info.ssc_cache[DA9052_TJUNCRES_REG].type	= VOLATILE;	// Reg - 104
+
+	ssc_info.ssc_cache[DA9052_TSICONTB_REG].type	= VOLATILE;	// Reg - 106
+	ssc_info.ssc_cache[DA9052_TSIXMSB_REG].type	= VOLATILE;	// Reg - 107
+	ssc_info.ssc_cache[DA9052_TSIYMSB_REG].type	= VOLATILE;	// Reg - 108
+	ssc_info.ssc_cache[DA9052_TSILSB_REG].type	= VOLATILE;	// Reg - 109
+	ssc_info.ssc_cache[DA9052_TSIZMSB_REG].type	= VOLATILE;	// Reg - 110
+	
+	/* Uncomment follwoing lines to have full READ/WRITE test */
+	//ssc_cache[102].type 				= VOLATILE;
+	//ssc_cache[103].type 				= VOLATILE;
+	
+	ssc_info.ssc_cache[DA9052_COUNTS_REG].type	= VOLATILE;	// Reg - 111
+	ssc_info.ssc_cache[DA9052_COUNTMI_REG].type	= VOLATILE;	// Reg - 112
+	ssc_info.ssc_cache[DA9052_COUNTH_REG].type	= VOLATILE;	// Reg - 113
+	ssc_info.ssc_cache[DA9052_COUNTD_REG].type	= VOLATILE;	// Reg - 114
+	ssc_info.ssc_cache[DA9052_COUNTMO_REG].type	= VOLATILE;	// Reg - 115
+	ssc_info.ssc_cache[DA9052_COUNTY_REG].type	= VOLATILE;	// Reg - 116
+	ssc_info.ssc_cache[DA9052_ALARMMI_REG].type	= VOLATILE;	// Reg - 117
+
+	ssc_info.ssc_cache[DA9052_SECONDA_REG].type	= VOLATILE;	// Reg - 122
+	ssc_info.ssc_cache[DA9052_SECONDB_REG].type	= VOLATILE;	// Reg - 123
+	ssc_info.ssc_cache[DA9052_SECONDC_REG].type	= VOLATILE;	// Reg - 124
+	ssc_info.ssc_cache[DA9052_SECONDD_REG].type	= VOLATILE;	// Reg - 125
+	
+	/* Following addresses are not assigned to any register */
+	ssc_info.ssc_cache[126].type 			= VOLATILE;
+	ssc_info.ssc_cache[127].type 			= VOLATILE;
+}
+	
+/*--------------------------------------------------------------------------*/
+/* Global Functions                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Bus independent functions to provide uniform interface to all drivers    */
+/*--------------------------------------------------------------------------*/
+/**
+ * da9052_ssc_write: This is top most wrapper to bus specific write functions
+ * @param *ssc_msg	pointer to ssc_msg structure
+ * @return s32		status of write operation
+ */
+s32 da9052_ssc_write(da9052_ssc_msg *sscmsg)
+{
+	s32 ret;
+
+	/* Reg addr should be a valid address on PAGE0 or PAGE1 */
+	if((sscmsg->addr < DA9052_PAGE0_REG_START) || (sscmsg->addr > DA9052_PAGE1_REG_END) || 
+		   ((sscmsg->addr > DA9052_PAGE0_REG_END) && (sscmsg->addr < DA9052_PAGE1_REG_START)))
+		return (INVALID_REGISTER);
+	
+	/* Acquire ssc lock */
+//	if (down_interruptible(&ssc_sem))
+//		return (-EINTR);
+	/*
+	 * It is better to do un-interruptible sleep here. Otherwise we will get
+	 * interttupted in case of high frequency events e.g. ADC THRESHOLD.
+	 * As a result this SSC write operation will fail!
+	 */
+	down(&ssc_info.ssc_sem);
+	
+#if defined (CONFIG_MFD_DA9052_SPI)
+	/* Call SPI specific function */
+	ret = da9052_ssc_spi_write(sscmsg);
+	
+#elif defined (CONFIG_MFD_DA9052_I2C)
+	/* Call I2C specific function */
+	ret = da9052_ssc_i2c_write(sscmsg);
+#endif
+	
+	/* Update local cache if required */
+	if(ret == SUCCESS){
+		/* Check if this register is Non-volatile*/
+		if(ssc_info.ssc_cache[sscmsg->addr].type != VOLATILE){
+			/* Update value */
+			ssc_info.ssc_cache[sscmsg->addr].val = sscmsg->data;
+			/* Make this cache entry valid */
+			ssc_info.ssc_cache[sscmsg->addr].status = VALID;
+		}
+	}
+	
+	/* Release ssc lock */
+	up(&ssc_info.ssc_sem);
+	
+	return (ret);
+}
+
+/**
+ * da9052_ssc_read: This is top most wrapper to bus specific read functions
+ * @param *ssc_msg	pointer to ssc_msg structure
+ * @return s32		status of read operation
+ */
+s32 da9052_ssc_read(da9052_ssc_msg *sscmsg)
+{
+	s32 ret;
+
+	/* Reg addr should be a valid address on PAGE0 or PAGE1 */
+	if((sscmsg->addr < DA9052_PAGE0_REG_START) || (sscmsg->addr > DA9052_PAGE1_REG_END) || 
+		   ((sscmsg->addr > DA9052_PAGE0_REG_END) && (sscmsg->addr < DA9052_PAGE1_REG_START)))
+		return (INVALID_REGISTER);
+	
+	/* Acquire ssc lock */
+//	if (down_interruptible(&ssc_sem))
+//		return (-EINTR);
+	/*
+	 * It is better to do un-interruptible sleep here. Otherwise we will get
+	 * interttupted in case of high frequency events e.g. ADC THRESHOLD.
+	 * As a result this SSC read operation will fail!
+	 */
+	down(&ssc_info.ssc_sem);
+	
+	/* 
+	 * Check if this is a Non-volatile register, if yes then return value -
+	 * from cache instead of actual reading from hardware. Before reading -
+	 * cache entry, make sure that the entry is valid
+	 */
+	if(ssc_info.ssc_cache[sscmsg->addr].type != VOLATILE){
+		/* The read request is for Non-volatile register */
+		/* Check if we have valid cached value for this */
+		if(ssc_info.ssc_cache[sscmsg->addr].status == VALID){
+			/* We have valid cached value, copy this value */
+			sscmsg->data = ssc_info.ssc_cache[sscmsg->addr].val;
+			
+			/* Release ssc lock */
+			up(&ssc_info.ssc_sem);
+			return (SUCCESS);
+		}
+	}
+	
+#if defined (CONFIG_MFD_DA9052_SPI)
+	/* Call SPI specific function */
+	ret = da9052_ssc_spi_read(sscmsg);
+	
+#elif defined (CONFIG_MFD_DA9052_I2C)
+	/* Put I2C specific function here */
+	ret = da9052_ssc_i2c_read(sscmsg);
+#endif
+
+	/* Update local cache if required */
+	if(ret == SUCCESS){
+		/* Check if this register is Non-volatile*/
+		if(ssc_info.ssc_cache[sscmsg->addr].type != VOLATILE){
+			/* Update value */
+			ssc_info.ssc_cache[sscmsg->addr].val = sscmsg->data;
+			/* Make this cache entry valid */
+			ssc_info.ssc_cache[sscmsg->addr].status = VALID;
+		}
+	}
+
+	/* Release ssc lock */
+	up(&ssc_info.ssc_sem);
+	
+	return (ret);
+}
+
+/**
+ * da9052_ssc_write_many: Function to write multiple registers
+ * @param *ssc_msg	pointer to ssc_msg structure array
+ * @param *msg_no	Number of registers to be written
+ * @return s32		status of write operation
+ */
+s32 da9052_ssc_write_many(da9052_ssc_msg *sscmsg, s32 msg_no)
+{
+	s32 ret;
+
+#if defined (CONFIG_MFD_DA9052_SPI)
+	s32 cnt;
+	da9052_ssc_msg *msg;
+#endif
+
+	/* Check request size */
+	if(msg_no > MAX_READ_WRITE_CNT)
+		return (FAILURE);
+	
+#if defined (CONFIG_MFD_DA9052_SPI)
+	msg = sscmsg;
+
+	for(cnt = 0; cnt < msg_no; cnt++, msg++) {
+		ret = da9052_ssc_write(msg);
+		if(ret != SUCCESS)
+		{
+			DA9052_DEBUG("Error in %s", __FUNCTION__);
+			return (FAILURE);
+		}
+	}
+	
+#elif defined (CONFIG_MFD_DA9052_I2C)
+	ret = da9052_ssc_i2c_write_many(sscmsg, msg_no);
+#endif
+	return (ret);
+}
+
+/**
+ * da9052_ssc_read_many: Function to read multiple registers
+ * @param *ssc_msg	pointer to ssc_msg structure array
+ * @param *msg_no	Number of registers to be read
+ * @return s32		status of read operation
+ */
+s32 da9052_ssc_read_many(da9052_ssc_msg *sscmsg, s32 msg_no)
+{
+	s32 ret;
+	
+#if defined (CONFIG_MFD_DA9052_SPI)
+	s32 cnt;
+	da9052_ssc_msg *msg;
+#endif
+
+	/* Check request size */
+	if(msg_no > MAX_READ_WRITE_CNT)
+		return (FAILURE);
+	
+#if defined (CONFIG_MFD_DA9052_SPI)
+	msg = sscmsg;
+
+	for(cnt = 0; cnt < msg_no; cnt++, msg++) {
+		ret = da9052_ssc_read(msg);
+		if(ret != SUCCESS) {
+			DA9052_DEBUG("Error in %s", __FUNCTION__);
+			return (FAILURE);
+		}
+	}
+	
+#elif defined (CONFIG_MFD_DA9052_I2C)
+	ret = da9052_ssc_i2c_read_many(sscmsg, msg_no);
+#endif
+	return (ret);
+}
+
+#if defined (CONFIG_MFD_DA9052_SPI)
+/*--------------------------------------------------------------------------*/
+/* SPI Specific Functions                                                   */
+/*--------------------------------------------------------------------------*/
+/**
+ * da9052_spi_set_page: Function to set current active page in DA9052
+ * @param page	Page to set i.e. PAGECON_128 or PAGECON_0
+ * @return int	Status of this operation
+ */
+static s32 da9052_spi_set_page(u8 page)
+{
+	da9052_ssc_msg sscmsg;
+	struct spi_message message;
+	struct spi_transfer xfer;
+	s32 ret = 0;
+
+	if((page != PAGECON_0) && ((page != PAGECON_128)))
+		return (INVALID_PAGE);
+
+	/* Current configuration is PAGE-0 and write request for PAGE-1 */
+	sscmsg.addr = DA9052_PAGECON0_REG;	/* set register address */
+	sscmsg.data = page;			/* set value */
+	
+	/* Check value of R/W_POL bit of INTERFACE register */
+	if(!ssc_info.rw_pol){
+		/* We need to set 0th bit for write operation */
+		sscmsg.addr = ((sscmsg.addr << 1) | RW_POL);	
+	}else{
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
+	xfer.tx_buf = ssc_info.spi_tx_buf;
+	xfer.rx_buf = ssc_info.spi_rx_buf;
+
+	ssc_info.spi_tx_buf[0] = sscmsg.addr;
+	ssc_info.spi_tx_buf[1] = sscmsg.data;
+
+	spi_message_add_tail(&xfer, &message);
+
+	/* Now, do the i/o */
+	ret = spi_sync(ssc_info.spi_dev, &message);
+
+	//printk(KERN_CRIT "Message completion code is - %d", message.status);
+	DA9052_DEBUG("Return from Write is: %d \n", ret);
+	
+	if(ret == 0){
+		/* Active Page set successfully */
+		ssc_info.spi_active_page = page;
+		return (SUCCESS);
+	}
+	else{
+		/* Error in setting Active Page */
+		return (FAILURE);
+	}
+}
+
+/**
+ * da9052_ssc_spi_write: Function to write a DA9052 register through SPI
+ * @param *ssc_msg	pointer to da9052_ssc_msg structure
+ * @return s32	status of write operation
+ */
+static s32 da9052_ssc_spi_write(da9052_ssc_msg *msg)
+{
+	struct spi_message message;
+	struct spi_transfer xfer;
+	s32 ret;
+		
+	/* We need a seperate copy of da9052_ssc_msg so that caller's copy remains intact */
+	da9052_ssc_msg sscmsg;
+	
+	/* Copy callers data in to our local copy */
+	sscmsg.addr = msg->addr;
+	sscmsg.data = msg->data;
+	
+	DA9052_DEBUG("[%s] REG = 0x%x, DATA = 0x%x \n", __FUNCTION__, msg->addr, msg->data);
+	
+	if((sscmsg.addr > PAGE_0_END) && (ssc_info.spi_active_page == PAGECON_0)){
+		/* Current configuration is PAGE-0 and write request for PAGE-1 */
+		da9052_spi_set_page(PAGECON_128);
+		/* Set register address accordindly */
+		sscmsg.addr = (sscmsg.addr - PAGE_1_START);
+	}
+	else if((sscmsg.addr < PAGE_1_START) && (ssc_info.spi_active_page == PAGECON_128)){
+		/* Current configuration is PAGE-1 and write request for PAGE-0 */
+		da9052_spi_set_page(PAGECON_0);
+	}
+	else if(sscmsg.addr > PAGE_0_END){
+		/* Current configuration is PAGE-1 and write request for PAGE-1 */
+		/* Just need to adjust register address */
+		sscmsg.addr = (sscmsg.addr - PAGE_1_START);
+	}
+		
+	/* Check value of R/W_POL bit of INTERFACE register */
+	if(!ssc_info.rw_pol){
+		/* We need to set 0th bit for write operation */
+		sscmsg.addr = ((sscmsg.addr << 1) | RW_POL);	
+	}else{
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
+	xfer.tx_buf = ssc_info.spi_tx_buf;
+	xfer.rx_buf = ssc_info.spi_rx_buf;
+
+	ssc_info.spi_tx_buf[0] = sscmsg.addr;
+	ssc_info.spi_tx_buf[1] = sscmsg.data;
+
+	spi_message_add_tail(&xfer, &message);
+
+	/* Now, do the i/o */
+	ret = spi_sync(ssc_info.spi_dev,&message);
+
+	//printk(KERN_CRIT "Message completion code is - %d", message.status);
+	DA9052_DEBUG("Return from Write is: %d \n", ret);
+	
+	if(ret == 0)
+		return (SUCCESS);
+	else
+		return (FAILURE);
+}
+
+/**
+ * da9052_ssc_spi_read:	Function to read a DA9052 register through SPI
+ * @param *ssc_msg	pointer to da9052_ssc_msg structure
+ * @return s32	status of write operation
+ */
+static s32 da9052_ssc_spi_read(da9052_ssc_msg *msg)
+{
+	struct spi_message message;
+	struct spi_transfer xfer;
+	s32 ret;
+	
+	/* We need a seperate copy of da9052_ssc_msg so that caller's copy remains intact */
+	da9052_ssc_msg sscmsg;
+	
+	/* Copy callers data in to our local copy */
+	sscmsg.addr = msg->addr;
+	sscmsg.data = msg->data;
+	
+	if((sscmsg.addr > PAGE_0_END) && (ssc_info.spi_active_page == PAGECON_0)){
+		/* Current configuration is PAGE-0 and read request for PAGE-1 */
+		da9052_spi_set_page(PAGECON_128);
+		/* Set register address accordindly */
+		sscmsg.addr = (sscmsg.addr - PAGE_1_START);
+	}
+	else if((sscmsg.addr < PAGE_1_START) && (ssc_info.spi_active_page == PAGECON_128)){
+		/* Current configuration is PAGE-1 and write request for PAGE-0 */
+		da9052_spi_set_page(PAGECON_0);
+	}
+	else if(sscmsg.addr > PAGE_0_END){
+		/* Current configuration is PAGE-1 and write request for PAGE-1 */
+		/* Just need to adjust register address */
+		sscmsg.addr = (sscmsg.addr - PAGE_1_START);
+	}
+	
+	/* Check value of R/W_POL bit of INTERFACE register */
+	if(ssc_info.rw_pol){
+		/* We need to set 0th bit for read operation */
+		sscmsg.addr = ((sscmsg.addr << 1) | RW_POL);	
+	}else{
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
+	xfer.tx_buf = ssc_info.spi_tx_buf;
+	xfer.rx_buf = ssc_info.spi_rx_buf;
+
+	ssc_info.spi_tx_buf[0] = sscmsg.addr;
+	ssc_info.spi_tx_buf[1] = 0xff;
+	
+	ssc_info.spi_rx_buf[0] = 0;
+	ssc_info.spi_rx_buf[1] = 0;
+
+	spi_message_add_tail(&xfer, &message);
+
+	/* Now, do the i/o */
+	ret = spi_sync(ssc_info.spi_dev, &message);
+	
+	//printk(KERN_CRIT "Message completion code is - %d", message.status);
+	DA9052_DEBUG("Return from Write is: %d \n", ret);
+	
+	if(ret == 0){
+		/* Update read value in callers copy */
+		msg->data = ssc_info.spi_rx_buf[1];
+		return (SUCCESS);
+	}
+	else{
+		return (FAILURE);
+	}
+}
+
+#elif defined (CONFIG_MFD_DA9052_I2C)
+/*--------------------------------------------------------------------------*/
+/* I2C Specific Functions                                                   */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * da9052_ssc_i2c_write: Function to write a DA9052 register through I2C
+ * @param *ssc_msg	pointer to da9052_ssc_msg structure
+ * @return s32	status of write operation
+ */
+static s32 da9052_ssc_i2c_write(da9052_ssc_msg *msg)
+{
+	/*Get the da9052_i2c client details*/
+	struct i2c_msg i2cmsg;
+	u8 buf[2] = {0};
+	s32 ret = 0;
+	da9052_ssc_i2c_data *i2c = i2c_get_clientdata(ssc_info.da9052_i2c_client);
+	
+	/* Copy the ssc msg to local character buffer */
+	buf[0] = msg->addr;
+	buf[1] = msg->data;	
+	
+	/*Construct a i2c msg for a da9052 driver ssc message request */
+	i2cmsg.addr  = i2c->da9052_slave_addr ;
+	i2cmsg.len   = 2;
+	i2cmsg.buf   = buf;
+	
+	/*To write the data on I2C set flag to zero */
+	i2cmsg.flags = 0;
+	
+	/* Start the i2c transfer by calling host i2c driver function */
+	ret = i2c_transfer(ssc_info.da9052_i2c_client->adapter, &i2cmsg, 1);
+	
+	if(ret < 0){
+		DA9052_DEBUG("_%s:master_xfer Failed!!\n", __FUNCTION__);	
+		return(FAILURE);
+	}
+	
+	return (SUCCESS);
+}
+
+/**
+ * da9052_ssc_i2c_read:	Function to read a DA9052 register through I2C
+ * @param *ssc_msg	pointer to da9052_ssc_msg structure
+ * @return s32	status of write operation
+ */
+static s32 da9052_ssc_i2c_read(da9052_ssc_msg *msg)
+{
+	/*Get the da9052_i2c client details*/
+	u8 buf[2] = {0,0};
+	struct i2c_msg i2cmsg[2];
+	s32 ret = 0;
+	da9052_ssc_i2c_data *i2c = i2c_get_clientdata(ssc_info.da9052_i2c_client);
+	
+	/* Copy SSC Msg to local character buffer */
+	buf[0] = msg->addr;
+	
+	/*Construct a i2c msg for a da9052 driver ssc message request */
+	i2cmsg[0].addr  = i2c->da9052_slave_addr ;
+	i2cmsg[0].len   = 1;
+	i2cmsg[0].buf   = &buf[0];
+	
+	/*To write the data on I2C set flag to zero */
+	i2cmsg[0].flags = 0;
+
+
+	/* Read the data from da9052*/	
+	/*Construct a i2c msg for a da9052 driver ssc message request */
+	i2cmsg[1].addr  = i2c->da9052_slave_addr ;
+	i2cmsg[1].len   = 1;
+	i2cmsg[1].buf   = &buf[1];
+	
+	/*To read the data on I2C set flag to I2C_M_RD */
+	i2cmsg[1].flags = I2C_M_RD; 
+	
+	/* Start the i2c transfer by calling host i2c driver function */
+	ret = i2c_transfer(ssc_info.da9052_i2c_client->adapter, i2cmsg, 2);
+	if(ret < 0){
+		DA9052_DEBUG("2 - %s:master_xfer Failed!!\n", __FUNCTION__);
+		return(FAILURE);
+	}
+
+	msg->data = *i2cmsg[1].buf;
+	
+	return (SUCCESS);
+}
+
+
+/**
+ * da9052_ssc_i2c_write_many: Function to write multiple registers through I2C
+ * @param *ssc_msg	pointer to ssc_msg structure array
+ * @param *msg_no	Number of registers to be write
+ * @return s32		status of write operation
+ */
+static s32 da9052_ssc_i2c_write_many(da9052_ssc_msg *sscmsg, s32 msg_no)
+{
+	struct i2c_msg i2cmsg;
+	u8 data_buf[MAX_READ_WRITE_CNT+1];
+	da9052_ssc_i2c_data *i2c;
+	
+	da9052_ssc_msg ctrlb_msg;
+	da9052_ssc_msg *msg_queue = sscmsg;
+	s32 ret = 0;
+	
+	/* Flag to check if requested registers are contiguous */
+	u8 cont_data = TRUE;
+	u8 cnt = 0;
+	
+	/* Check if requested regsiters are contiguous */
+	for(cnt = 1; cnt < msg_no; cnt++){
+		if((msg_queue[cnt].addr - msg_queue[cnt-1].addr) != 1){
+			/* Difference is not 1, i.e. non-contiguous registers */
+			cont_data = FALSE;
+			break;
+		}
+	}
+	
+	if(cont_data == FALSE){
+		/* Requested registers are non-contiguous */
+		for(cnt = 0; cnt < msg_no; cnt++) {
+			ret = da9052_ssc_write(&msg_queue[cnt]);
+			if(ret != SUCCESS) {
+				DA9052_DEBUG("Error in %s", __FUNCTION__);
+				return (FAILURE);
+			}
+		}
+		return (SUCCESS);
+	}
+	
+	/* Requested registers are contiguous */
+	
+	/*
+	* We want to perform PAGE WRITE via I2C
+	* For PAGE WRITE sequence of I2C transactions is as below
+	*
+	* (slave_addr + reg_addr + data_1 + data_2 + ...)
+	*/
+	
+	/* First read current WRITE MODE via CONTROL_B register of DA9052 */
+	ctrlb_msg.addr = DA9052_CONTROLB_REG;
+	ctrlb_msg.data = 0x0;
+	ret = da9052_ssc_read(&ctrlb_msg);
+	
+	if(ret != SUCCESS){
+		DA9052_DEBUG("Error in Reading DA9052_CONTROLB_REG in %s",__FUNCTION__);
+		return (FAILURE);
+	} 
+	
+	/* Check if PAGE WRITE mode is set */
+	if(ctrlb_msg.data & DA9052_CONTROLB_WRITEMODE){
+		/* REPEAT WRITE mode is configured */
+		/* Now set DA9052 into PAGE WRITE mode */
+		ctrlb_msg.data &= ~DA9052_CONTROLB_WRITEMODE;
+		ret = da9052_ssc_write(&ctrlb_msg);
+	
+		if(ret != SUCCESS){
+			DA9052_DEBUG("1-Error in Writing to DA9052_CONTROLB_REG in %s",__FUNCTION__);
+			return (FAILURE);
+		}
+	}
+	
+	/* All set at DA9052 side, prepare for I2C transfer */
+	
+	/* Acquire ssc lock */
+//	if (down_interruptible(&ssc_sem))
+//		return (-EINTR);
+	/*
+	 * It is better to do un-interruptible sleep here. Otherwise we will get
+	 * interttupted in case of high frequency events e.g. ADC THRESHOLD.
+	 * As a result this SSC write operation will fail!
+	 */
+	down(&ssc_info.ssc_sem);
+
+	i2c = i2c_get_clientdata(ssc_info.da9052_i2c_client);
+	
+	/* Put first register address */
+	data_buf[0] = msg_queue[0].addr;
+	
+	for(cnt = 0; cnt < msg_no; cnt++){
+		data_buf[cnt+1] = msg_queue[cnt].data;
+	}
+	
+	/* Construct a i2c msg for PAGE WRITE */
+	i2cmsg.addr  = i2c->da9052_slave_addr ;
+	i2cmsg.len   = (msg_no + 1);	// First register address + all data
+	i2cmsg.buf   = data_buf;
+	
+	/*To write the data on I2C set flag to zero */
+	i2cmsg.flags = 0; 
+	
+	/* Start the i2c transfer by calling host i2c driver function */
+	ret = i2c_transfer(ssc_info.da9052_i2c_client->adapter, &i2cmsg, 1);
+	if(ret < 0){
+		up(&ssc_info.ssc_sem);
+		DA9052_DEBUG("1 - i2c_transfer function falied in [%s]!!!\n", __FUNCTION__);
+		return(FAILURE);
+	}
+	
+	/* Update local cache, if required */
+	for(cnt = 0; cnt < msg_no; cnt++){
+		/* Check if this register is Non-volatile*/
+		if(ssc_info.ssc_cache[sscmsg[cnt].addr].type != VOLATILE){
+			/* Update value */
+			ssc_info.ssc_cache[sscmsg[cnt].addr].val = sscmsg[cnt].data;
+			/* Make this cache entry valid */
+			ssc_info.ssc_cache[sscmsg[cnt].addr].status = VALID;
+		}
+	}
+	
+	/* Release ssc lock before performing single ssc write */
+	up(&ssc_info.ssc_sem);
+	
+	return (SUCCESS);
+}
+
+/**
+ * da9052_ssc_i2c_read_many: Function to read multiple registers through I2C
+ * @param *ssc_msg	pointer to ssc_msg structure array
+ * @param *msg_no	Number of registers to be read
+ * @return s32		status of read operation
+ */
+static s32 da9052_ssc_i2c_read_many(da9052_ssc_msg *sscmsg, s32 msg_no)
+{
+	struct i2c_msg i2cmsg;
+	u8 data_buf[MAX_READ_WRITE_CNT];
+	da9052_ssc_i2c_data *i2c;
+	
+	da9052_ssc_msg *msg_queue = sscmsg;
+	s32 ret = 0;
+	
+	/* Flag to check if requested registers are contiguous */
+	u8 cont_data = TRUE;
+	u8 cnt = 0;
+
+	/* Check if requested regsiters are contiguous */
+	for(cnt = 1; cnt < msg_no; cnt++){
+		if((msg_queue[cnt].addr - msg_queue[cnt-1].addr) != 1){
+			/* Difference is not 1, i.e. non-contiguous registers */
+			cont_data = FALSE;
+			break;
+		}
+	}
+	
+	if(cont_data == FALSE){
+		/* Requested registers are non-contiguous */
+		for(cnt = 0; cnt < msg_no; cnt++) {
+			ret = da9052_ssc_read(&msg_queue[cnt]);
+			if(ret != SUCCESS) {
+				DA9052_DEBUG("Error in %s", __FUNCTION__);
+				return (FAILURE);
+			}
+		}
+		return (SUCCESS);
+	}
+	
+	/* Requested registers are contiguous */
+	
+	/* Acquire ssc lock */
+//	if (down_interruptible(&ssc_sem))
+//		return (-EINTR);
+	/*
+	 * It is better to do un-interruptible sleep here. Otherwise we will get
+	 * interttupted in case of high frequency events e.g. ADC THRESHOLD.
+	 * As a result this SSC write operation will fail!
+	 */
+	down(&ssc_info.ssc_sem);
+	
+	i2c = i2c_get_clientdata(ssc_info.da9052_i2c_client);
+	
+	/*
+	 * We want to perform PAGE READ via I2C
+	 * For PAGE READ sequence of I2C transactions is as below
+	 *
+	 * (slave_addr + reg_addr) + (slave_addr + data_1 + data_2 + ...)
+	 */
+	
+	/* Copy address of first register */
+	data_buf[0] = msg_queue[0].addr;
+	
+	/* Construct a i2c msg for first transaction of PAGE READ i.e. write */
+	i2cmsg.addr  = i2c->da9052_slave_addr ;
+	i2cmsg.len   = 1;
+	i2cmsg.buf   = data_buf;
+	
+	/*To write the data on I2C set flag to zero */
+	i2cmsg.flags = 0; 
+	
+	/* Start the i2c transfer by calling host i2c driver function */
+	ret = i2c_transfer(ssc_info.da9052_i2c_client->adapter, &i2cmsg, 1);
+	if(ret < 0){
+		up(&ssc_info.ssc_sem);
+		DA9052_DEBUG("1 - i2c_transfer function falied in [%s]!!!\n", __FUNCTION__);
+		return(FAILURE);
+	}
+
+	/* Now Read the data from da9052 */
+	
+	/* Construct a i2c msg for second transaction of PAGE READ i.e. read */
+	i2cmsg.addr  = i2c->da9052_slave_addr ;
+	i2cmsg.len   = msg_no;
+	i2cmsg.buf   = data_buf;
+	
+	/*To read the data on I2C set flag to I2C_M_RD */
+	i2cmsg.flags = I2C_M_RD; 
+	
+	/* Start the i2c transfer by calling host i2c driver function */
+	ret = i2c_transfer(ssc_info.da9052_i2c_client->adapter, &i2cmsg, 1);
+	if(ret < 0){
+		up(&ssc_info.ssc_sem);
+		DA9052_DEBUG("2 - i2c_transfer function falied in [%s]!!!\n", __FUNCTION__);
+		return(FAILURE);
+	}
+	
+	/* Gather READ data */
+	for(cnt = 0; cnt < msg_no; cnt++) {
+		sscmsg[cnt].data = data_buf[cnt];
+	}
+	
+	/* Update local cache, if required */
+	for(cnt = 0; cnt < msg_no; cnt++){
+		/* Check if this register is Non-volatile*/
+		if(ssc_info.ssc_cache[sscmsg[cnt].addr].type != VOLATILE){
+			/* Update value */
+			ssc_info.ssc_cache[sscmsg[cnt].addr].val = sscmsg[cnt].data;
+			/* Make this cache entry valid */
+			ssc_info.ssc_cache[sscmsg[cnt].addr].status = VALID;
+		}
+	}
+	
+	up(&ssc_info.ssc_sem);
+
+	return (SUCCESS);
+}
+#endif /* CONFIG_MFD_DA9052_I2C */
+
+/*--------------------------------------------------------------------------*/
+/* Infrastructure Functions                                                 */
+/*--------------------------------------------------------------------------*/
+/**
+ * da9052_ssc_open: Function that is called when some one opens SSC device node
+ * 
+ * @param *inode pointer to device inode
+ * @param *file  file pointer
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_ssc_open(struct inode *inode, struct file *file)
+{
+	/* Check if device is already open */
+	if(ssc_info.device_open) {
+		printk( KERN_INFO "DA9052: SSC device already open.\n");
+		return (-EBUSY);
+	} else {
+		ssc_info.device_open++;
+		return (SUCCESS);
+	}
+}
+
+/**
+ * da9052_ssc_release:	Function that is called when some one closes SSC device node
+ * 
+ * @param *inode	pointer to device inode
+ * @param *file	file pointer
+ * @return int	Status of release operation
+ */
+s32 da9052_ssc_release(struct inode *inode, struct file *file)
+{
+	ssc_info.device_open--;
+	printk( KERN_INFO "DA9052: SSC device closed.\n");
+	return (SUCCESS);
+}
+
+/**
+ * da9052_ssc_suspend: Power Management support function
+ * 
+ * @param *dev   pointer to platform device
+ * @param state  pm state
+ * @return s32 status of suspend operation
+ */
+static s32 da9052_ssc_suspend(struct platform_device *dev, pm_message_t state)
+{
+	/* Put your suspend related operations here */
+	printk(KERN_CRIT "[%s] called! \n", __FUNCTION__);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_ssc_resume: Power Management support function
+ * 
+ * @param *dev   pointer to platform device
+ * @return s32 status of resume operation
+ */
+static s32 da9052_ssc_resume(struct platform_device *dev)
+{
+	/* Put your resume related operations here */
+	printk(KERN_CRIT "[%s] called! \n", __FUNCTION__);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_ssc_ioctl: Function that is called when some one calls ioctl() on SSC device node
+ * 
+ * @param *inode Inode number of device node
+ * @param *file  File pointer
+ * @param cmd	ioctl command to be executed
+*  @arg	arguments for cmd
+ * @return s32	status of executing cmd
+ */
+s32 da9052_ssc_ioctl(struct inode *inode, struct file *file, 
+					unsigned int cmd, unsigned long arg)
+{	
+	s32 cnt, cnt_start, cnt_end;
+	s32 ret = SUCCESS;
+	
+	da9052_ssc_msg *in_data, sscmsg, sscmsg_temp;
+	
+	in_data = (da9052_ssc_msg *) arg;
+
+	DA9052_DEBUG("I am in ____%s____\n", __FUNCTION__);
+	
+	/* Copy parameters from user space */
+	if (copy_from_user(&sscmsg, in_data, sizeof(da9052_ssc_msg)))
+		return (-EFAULT);
+
+	switch(cmd) {
+		
+		case DA9052_IOCTL_SSC_READ:
+			/* Command to read a register */
+			if(da9052_ssc_read(&sscmsg) != SUCCESS)
+				return (FAILURE);	
+			/* Read successful, pass data to user space */
+			if(copy_to_user(in_data, &sscmsg, sizeof(da9052_ssc_msg)))
+				return (-EFAULT);
+			return (SUCCESS);
+			
+		case DA9052_IOCTL_SSC_WRITE:
+			/* Command to write a register */
+			DA9052_DEBUG("sscmsg->addr = 0x%x \n", sscmsg.addr);
+			DA9052_DEBUG("sscmsg->data = 0x%x \n", sscmsg.data);
+			return (da9052_ssc_write(&sscmsg));
+			
+		case DA9052_IOCTL_SSC_TEST:
+			/*
+			 * This is a READ/WRITE test for SPI. This can be used -
+			 * to validate hardware interface between host and -
+			 * DA9052 EVAL board. We have used to isolate many -
+			 * grounding and noise related issues in SPI connection
+			 *
+			 * This test performs following operations
+			 * (1) Write a value to a DA9052 register
+			 * (2) Read back same register
+			 * (3) Compare read value
+			 * (4) If read value matches with write value, repeat test
+			 * (5) If read value doesn't match, come out, giving an error
+			 */
+			
+			/* Just for some profiling of SPI bus operations */
+			cnt_start = jiffies;
+			
+			/* R102 and R103 registes are safe to use for test */
+			sscmsg.addr = 102;
+			sscmsg_temp.addr = 102;
+			sscmsg_temp.data = 0;
+			
+			/* Start test */
+			for(cnt = 0; cnt < 10240; cnt++){
+				sscmsg.addr = 102;
+				sscmsg.data = ((u8)cnt % 127);
+				if(da9052_ssc_write(&sscmsg) != SUCCESS){
+					printk(KERN_ERR "Error in WRITE\n");
+					ret = FAILURE;
+					break;
+				}
+				
+				/*
+				 * Perform a dummy write on other register
+				 * This is requried because according to data -
+				 * sheet of DA9052, a regsiter can't be read -
+				 * immediately after performing write operation
+				 * on it.
+				 */
+				sscmsg.addr = 103;
+				sscmsg.data = 0xAA;
+				if(da9052_ssc_write(&sscmsg) != SUCCESS){
+					printk(KERN_ERR "Error in dummy WRITE\n");
+					ret = FAILURE;
+					break;
+				}
+				
+				/* Read back first written register */
+				if(da9052_ssc_read(&sscmsg_temp) != SUCCESS){
+					printk(KERN_ERR "Error in READ\n");
+					ret = FAILURE;
+					break;
+				}
+
+				/* Compare read value */
+				if(sscmsg_temp.data != ((u8)cnt % 127))
+				{
+					printk(KERN_ERR "READ/WRITE Error, data = %d, iteration = %d \n",
+					sscmsg_temp.data, cnt);
+					ret = FAILURE;
+					break;
+				}
+			}
+			cnt_end = jiffies;
+			printk("Time taken for %d Read+Write cycles is %d ms\n", (cnt+1), 
+			       jiffies_to_msecs(cnt_end - cnt_start));
+			break;
+			
+		case DA9052_IOCTL_DUMP_SPI_REG:
+			/* This is purely for debug purpose */
+			//print_spi_reg(spi_dev);
+			ret = FAILURE;
+			break;
+		default:
+			break;
+	}	
+	
+	return (ret);
+}
+
+#if defined (CONFIG_MFD_DA9052_SPI)
+/**
+ * da9052_spi_probe: Called when a device gets attached to driver 
+ * 
+ * @param struct spi_device *spi Pointer to spi device
+ * @return int Error Code, zero: no error
+ */
+static int da9052_spi_probe(struct spi_device *spi)
+{	
+	/* Store handle to spi device */
+	ssc_info.spi_dev = spi;
+	
+	/* Allocate memory for RX/TX bufferes used in single register read/write */
+	ssc_info.spi_rx_buf = kmalloc(2, GFP_KERNEL | GFP_DMA);
+	if (!ssc_info.spi_rx_buf)
+		return (-ENOMEM);
+	
+	ssc_info.spi_tx_buf = kmalloc(2, GFP_KERNEL | GFP_DMA);
+	if (!ssc_info.spi_tx_buf)
+		return (-ENOMEM);
+	
+	/* Configure SPI */
+	spi->mode = (SPI_MODE_0 | SPI_CPOL);
+	spi->bits_per_word = 8;
+	
+	spi_setup(spi);
+	
+	return (0);
+}
+
+/**
+ * da9052_spi_remove: Called when a device gets detached from driver 
+ * 
+ * @param struct spi_device *spi Pointer to I2C client
+ * @return int Error Code, zero: no error
+ */
+static int da9052_spi_remove(struct spi_device *spi)
+{
+	printk("__[%s]__ called! \n",__FUNCTION__);
+	kfree(ssc_info.spi_rx_buf);
+	kfree(ssc_info.spi_tx_buf);
+	
+	return (0);
+}
+
+/**
+ * da9052_spi_suspend: Power Management support function
+ * 
+ * @param *dev   pointer to platform device
+ * @param state  pm state
+ * @return s32 status of suspend operation
+ */
+static s32 da9052_spi_suspend(struct spi_device *dev, pm_message_t state)
+{
+	/* Put your suspend related operations here */
+	printk(KERN_CRIT "[%s] called! \n", __FUNCTION__);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_spi_resume: Power Management support function
+ * 
+ * @param *dev   pointer to platform device
+ * @return s32 status of resume operation
+ */
+static s32 da9052_spi_resume(struct spi_device *dev)
+{
+	/* Put your resume related operations here */
+	printk(KERN_CRIT "[%s] called! \n", __FUNCTION__);
+	return (SUCCESS);
+}
+
+static struct spi_driver da9052_spi_driver = {
+	.driver = {
+		.name	 = DA9052_SSC_SPI_DEVICE_NAME,
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+	},
+	.probe	 	= da9052_spi_probe,
+	.remove 	= __devexit_p(da9052_spi_remove),
+	.suspend	= da9052_spi_suspend,
+	.resume		= da9052_spi_resume,
+};
+
+#elif defined (CONFIG_MFD_DA9052_I2C)
+/**
+ * da9052_i2c_probe: Called when a device gets attached to driver 
+ * 
+ * @param i2c_client Pointer to I2C client
+ * @return int Error Code, zero: no error
+ */
+static int __devinit da9052_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{	
+	/* Get the bus driver handler */
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	da9052_ssc_i2c_data *clientdata = NULL;
+	int err = 0;
+		
+	/* Check i2c bus driver supports byte data transfer */
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)){
+		err = -ENODEV;
+		printk("Error in %s:i2c_check_functionality \n",__FUNCTION__);
+		return (err);
+	}
+	
+	/* Allocate memory for i2c structure */
+	clientdata = kzalloc(sizeof(da9052_ssc_i2c_data), GFP_KERNEL);
+	if (!clientdata) {
+		err = -ENOMEM;
+		return (err);
+	}
+	
+	/* Store handle to i2c client */
+	ssc_info.da9052_i2c_client = client;
+	
+	/*Initalize i2c data structure here*/
+	clientdata->adapter = adapter;
+	
+	/* host i2c driver looks only first 7 bits for the slave address */
+	clientdata->da9052_slave_addr = DA9052_I2C_ADDR >> 1;
+		
+	/* Store the i2c client data */
+	i2c_set_clientdata(client, clientdata);
+	
+	return (SUCCESS);
+}
+
+/**
+ * da9052_i2c_remove: Called when a device gets detached from driver 
+ * 
+ * @param i2c_client Pointer to I2C client
+ * @return int Error Code, zero: no error
+ */
+static int da9052_i2c_remove(struct i2c_client *client)
+{
+	da9052_ssc_i2c_data *clientdata = i2c_get_clientdata(client);
+	
+	printk(KERN_INFO "DA9052: Removing i2c device \n");
+	kfree(clientdata);
+	return (SUCCESS);
+}
+
+static struct i2c_device_id da9052_ssc_id[] = {
+	{ DA9052_SSC_I2C_DEVICE_NAME, 0},
+	{}
+};
+
+static struct i2c_driver da9052_i2c_driver =  {
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33)
+//	.id = 0,	// Field not defined in Linux kernel 2.6.33
+#else
+	.id = 0,
+#endif	
+	.driver = {
+		.name   = DA9052_SSC_I2C_DEVICE_NAME,
+		.owner  = THIS_MODULE,
+	},
+	.probe  = da9052_i2c_probe,
+	.remove = da9052_i2c_remove,
+	.id_table = da9052_ssc_id,
+};
+#endif		/* CONFIG_MFD_DA9052_I2C */
+
+/**
+ * static struct file_operations da9052_ssc_fops
+ * This structure definition has to be defined here as an exception. 
+ * @owner: member description
+ * @open : member description
+ * @release: member description
+ * @ioctl: member description
+ */
+static const struct file_operations da9052_ssc_fops = {
+        .owner          = THIS_MODULE,
+        .open           = da9052_ssc_open,
+        .release        = da9052_ssc_release,
+        .ioctl          = da9052_ssc_ioctl
+};
+
+/**
+ * da9052_ssc_probe: Called when a device gets attached to driver 
+ * 
+ * @param *dev   pointer to platform device
+ * @return int   Error Code, zero: no error
+ */
+static s32 __devinit da9052_ssc_probe(struct platform_device *dev)
+{
+	s32 ret;	
+	
+	/* Register the device */
+	ret = register_chrdev(ssc_info.major_number, 
+			      DA9052_SSC_DEVICE_NAME, &da9052_ssc_fops);
+	if(ret < 0) {
+		printk(KERN_ERR "Unable to register %s\n", DA9052_SSC_DEVICE_NAME);
+		return (-EFAULT);	
+	} else {
+		ssc_info.major_number = ret;
+		printk(KERN_INFO "%s: Major number is: %d \n", 
+		       DA9052_SSC_DEVICE_NAME, ssc_info.major_number);
+		
+#if defined (CONFIG_MFD_DA9052_SPI)
+		printk(KERN_INFO "DA9052 SSC-SPI Driver\n");
+		ret = spi_register_driver(&da9052_spi_driver);
+		if(ret != 0) {
+			printk(KERN_ERR "Unable to register %s\n", DA9052_SSC_SPI_DEVICE_NAME);
+			unregister_chrdev(ssc_info.major_number, DA9052_SSC_DEVICE_NAME);
+			return (-EFAULT);
+		}
+
+#elif defined (CONFIG_MFD_DA9052_I2C)
+		ret = i2c_add_driver(&da9052_i2c_driver);
+		if(ret != 0) {
+			printk(KERN_ERR "Unable to register %s\n", DA9052_SSC_I2C_DEVICE_NAME);
+			unregister_chrdev(ssc_info.major_number, DA9052_SSC_DEVICE_NAME);
+			return (-EFAULT);	
+		}
+#endif
+	}
+	/* Initialize ssc lock */
+	init_MUTEX(&ssc_info.ssc_sem);
+	
+	/* Initialize ssc cache */
+	da9052_init_ssc_cache();
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_ssc_remove: Called when detaching device from driver
+ * @param *dev   pointer to platform device
+ * @return int   Error Code, zero: no error
+ */
+static int __devexit da9052_ssc_remove(struct platform_device *dev)
+{
+	DA9052_DEBUG(KERN_DEBUG "Removing %s \n", DA9052_SSC_DEVICE_NAME);
+	return (SUCCESS);
+}
+
+/**
+ * static struct platform_driver da9052_ssc_driver -
+ * @probe: Probe function for this device. 
+ * @remove: Function to be called when removing this device from platform
+ * @suspend: Function to be called in suspend mode
+ * @resume: Function to be called in resume mode
+ * @driver: Contains glue logic to bind platform device and plarform driver
+ */
+static struct platform_driver da9052_ssc_driver = {
+	.probe		= da9052_ssc_probe,
+	.remove		= __devexit_p(da9052_ssc_remove),
+	.suspend	= da9052_ssc_suspend,
+	.resume		= da9052_ssc_resume,
+	.driver		= {
+		.name	= DA9052_SSC_DEVICE_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+/**
+ * da9052_ssc_init: Function that gets called at the time of module loading
+ * @param void
+ * @return int status of module initialization
+ */
+static s32 __init da9052_ssc_init(void)
+{
+	s32 ret;
+	
+	printk(banner);
+	
+	/* Initialize the parameters of the global ssc structure */
+	ssc_info.device_open = 0;
+	ssc_info.major_number = 0;
+#if defined (CONFIG_MFD_DA9052_SPI)
+	ssc_info.spi_active_page  = PAGECON_0;
+	ssc_info.rw_pol = 1;
+#endif	
+	
+	ssc_info.da9052_ssc_platform_device = platform_device_alloc("da9052_ssc", 0);
+	if (!ssc_info.da9052_ssc_platform_device)
+		return (-ENOMEM);
+
+	/* Add platform device to device hierarchy */
+	ret = platform_device_add(ssc_info.da9052_ssc_platform_device);
+	if (ret < 0) {
+		/* Free all memory associated with a platform device */
+		platform_device_put(ssc_info.da9052_ssc_platform_device);
+		return (ret);
+	}
+
+	ret = platform_driver_register(&da9052_ssc_driver);
+	if (ret < 0)
+		/* Unregister the platform level device */
+		platform_device_unregister(ssc_info.da9052_ssc_platform_device);
+
+	return (ret);
+}
+
+/**
+ * da9052_ssc_exit: Function that gets called at the time of module unloading
+ * @param void
+ * @return void
+ */
+static void __exit da9052_ssc_exit(void)
+{
+	printk(KERN_INFO "DA9052: Unregistering SSC device.\n");
+	
+	unregister_chrdev(ssc_info.major_number, DA9052_SSC_DEVICE_NAME);
+	
+#if defined (CONFIG_MFD_DA9052_SPI)
+	spi_unregister_driver(&da9052_spi_driver);
+#elif defined (CONFIG_MFD_DA9052_I2C)
+	i2c_del_driver(&da9052_i2c_driver);
+#endif
+
+	platform_driver_unregister(&da9052_ssc_driver);
+	/* Unregister the platform level device */
+	platform_device_unregister(ssc_info.da9052_ssc_platform_device);
+	
+	return;
+}
+
+module_init(da9052_ssc_init);
+module_exit(da9052_ssc_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd");
+MODULE_DESCRIPTION("DA9052 SSC Device Driver");
+MODULE_LICENSE("GPL");
+
+/*--------------------------------------------------------------------------*/
+/* Exports                                                                  */
+/*--------------------------------------------------------------------------*/
+EXPORT_SYMBOL(da9052_ssc_read);
+EXPORT_SYMBOL(da9052_ssc_write);
+EXPORT_SYMBOL(da9052_ssc_read_many);
+EXPORT_SYMBOL(da9052_ssc_write_many);
diff -Naur linux-2.6.33.2/drivers/mfd/Kconfig linux-2.6.33.2_patch/drivers/mfd/Kconfig
--- linux-2.6.33.2/drivers/mfd/Kconfig	2010-04-02 04:02:33.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/mfd/Kconfig	2010-05-18 15:30:37.000000000 +0500
@@ -348,6 +348,35 @@
 	  read/write functions for the devices to get access to this chip.
 	  This chip embeds various other multimedia funtionalities as well.
 
+config MFD_DA9052
+	bool "Dialog Semiconductor DA9052 PMIC Support"
+	help
+	  Say yes here to support for Dialog semiconductor Da9052, Power
+	  Management IC.This option enables the SPI/I2C, EH, and ADC
+	  features of DA9052.
+choice
+	prompt "DA9052 SSC support"
+	depends on MFD_DA9052
+config MFD_DA9052_SPI
+	bool "SPI"
+	select SPI
+	select GPIOLIB
+	help
+	  Say Y  to select SPI serial interface for DA9052 chip
+
+config MFD_DA9052_I2C
+	bool "I2C"
+	select I2C
+	help
+	  Say Y  to select I2C serial interface for DA9052 chip
+endchoice
+
+config DA9052_ADC_ENABLE
+	bool "Dialog Semiconductor DA9052 ADC Driver"
+	depends on MFD_DA9052
+	help
+	  Say Y  to enable the ADC driver for the DA9052 chip
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff -Naur linux-2.6.33.2/drivers/mfd/Makefile linux-2.6.33.2_patch/drivers/mfd/Makefile
--- linux-2.6.33.2/drivers/mfd/Makefile	2010-04-02 04:02:33.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/mfd/Makefile	2010-05-18 15:29:36.000000000 +0500
@@ -55,4 +55,8 @@
 obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
 obj-$(CONFIG_AB4500_CORE)	+= ab4500-core.o
 obj-$(CONFIG_MFD_88PM8607)	+= 88pm8607.o
-obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
\ No newline at end of file
+obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
+
+obj-$(CONFIG_MFD_DA9052)	+= da9052_ssc.o 
+obj-$(CONFIG_MFD_DA9052)	+= da9052_eh.o
+obj-$(CONFIG_DA9052_ADC_ENABLE)	+= da9052_adc.o
diff -Naur linux-2.6.33.2/include/linux/compiler-gcc4.h linux-2.6.33.2_patch/include/linux/compiler-gcc4.h
--- linux-2.6.33.2/include/linux/compiler-gcc4.h	2010-04-02 04:02:33.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/compiler-gcc4.h	2010-05-18 15:29:36.000000000 +0500
@@ -3,9 +3,19 @@
 #endif
 
 /* GCC 4.1.[01] miscompiles __weak */
+#define GCC_VERSION (__GNUC__ * 10000 \
+		     + __GNUC_MINOR__ * 100 \
+		     + __GNUC_PATCHLEVEL__)
+
 #ifdef __KERNEL__
 # if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
-#  error Your version of gcc miscompiles the __weak directive
+
+#if GCC_VERSION <= 40101
+/* #  error Your version of gcc miscompiles the __weak directive */
+#else
+#  error Your version of gcc miscompiles the __weak directive 
+#endif
+
 # endif
 #endif
 
diff -Naur linux-2.6.33.2/include/linux/mfd/da9052/da9052_adc.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_adc.h
--- linux-2.6.33.2/include/linux/mfd/da9052/da9052_adc.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_adc.h	2010-05-18 15:29:36.000000000 +0500
@@ -0,0 +1,223 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_adc.h: ADC driver header file for DA9052
+ *
+ * History:
+ *
+ *  (05/08/2009):	Initial version
+ *
+ * (27/04/2010):	Updated for Linux Community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+
+#ifndef _DA9052_ADC_H
+#define _DA9052_ADC_H
+
+/*--------------------------------------------------------------------------*/
+/* System wide include files						    */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files					    */
+/*--------------------------------------------------------------------------*/
+#include <linux/mfd/da9052/da9052_gpio.h>
+/*--------------------------------------------------------------------------*/
+/* Type Definitions							    */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Constant Definitions							    */
+/*--------------------------------------------------------------------------*/
+
+#define DA9052_ADC_DEVICE_NAME				"da9052_adc"
+
+/* To enable debug output, set this to 1 */
+#define		DA9052_ADC_DEBUG			0
+#undef DA9052_DEBUG
+#if DA9052_ADC_DEBUG
+#define DA9052_DEBUG( fmt, args... ) printk( KERN_CRIT "" fmt, ##args )
+#else
+#define DA9052_DEBUG( fmt, args... )
+#endif
+
+/* used for debugging non IOCTL functions */
+#define DA9052_UNIT_TESTING_ADC				1 
+
+/* IOCTL defines */
+#define DA9052_ADC_IOCTL_SET_ADC_MODE			2
+#define DA9052_ADC_IOCTL_SET_SAMPLING_INTERVAL		3
+#define DA9052_ADC_IOCTL_CONFIGURE_THRESHOLDS		4
+#define DA9052_ADC_IOCTL_SET_ADCIN5_COMPARATOR		5
+#define DA9052_ADC_IOCTL_SET_TBAT_SOURCE_CURRENT	6
+#define DA9052_ADC_IOCTL_SET_ADCIN4_SOURCE_CURRENT	7
+#define DA9052_ADC_IOCTL_START_ADC			8
+#define DA9052_ADC_IOCTL_STOP_ADC			9
+#define DA9052_ADC_IOCTL_READ_ADC			10
+#define DA9052_ADC_IOCTL_GET_EVENT			11
+#define DA9052_ADC_IOCTL_REGISTER_EVENT			12
+#define DA9052_ADC_IOCTL_UNREGISTER_EVENT		13
+
+#if DA9052_ADC_DEBUG
+#define DA9052_ADC_IOCTL_UT_VDDOUT			14
+#define DA9052_ADC_IOCTL_UT_ICH				15
+#define DA9052_ADC_IOCTL_UT_TBAT			16
+#define DA9052_ADC_IOCTL_UT_VBAT			17
+#define DA9050_ADC_IOCTL_UT_TJUNC			18
+#define DA9052_ADC_IOCTL_UT_VBBAT			19
+#endif
+
+/* Channel Definations */
+#define ADC_VDDOUT					0
+#define ADC_ICH						1
+#define ADC_TBAT					2
+#define ADC_VBAT					3
+#define ADC_ADCIN4					4
+#define ADC_ADCIN5					5
+#define ADC_ADCIN6					6
+#define ADC_TSI						7
+#define ADC_TJUNC					8
+#define ADC_VBBAT					9
+/* Mode selection Definations */
+#define AUTO_MODE					0
+#define MANUAL_MODE					1
+
+/* Error codes */
+#define ADC_INVALID_CHANNEL_ERROR			2
+#define ADC_INVALID_MODE_ERROR				3
+#define ADC_INVALID_TIME_ERROR				4
+#define ADC_SSC_BUS_ERROR				5
+#define ADC_INVALID_VALUE				6
+#define ADC_CHANNEL_NOT_STARTED_ERROR			7
+#define ADC_NO_IOCTL_CMD				8
+#define ADC_INVALID_EVENT				9
+#define ADC_EVENT_REGISTRATION_FAILED			10
+#define ADC_EVENT_UNREGISTRATION_FAILED			11
+#define ADC_MANCONV_TIMEOUT_ERROR			12
+#define ADC_CH4_NOT_CONF				13
+#define ADC_CH5_NOT_CONF				14
+#define ADC_CH6_NOT_CONF				15
+
+/* Parameters */
+#define TBAT_50UA_ONE_SLOT				0
+#define TBAT_50UA_PREMANENTLY				1
+
+#define ADC_INTERVAL_10MS				0
+#define ADC_INTERVAL_1MS				1
+
+/*--------------------------------------------------------------------------*/
+/* User Configurations                                                     */
+/*--------------------------------------------------------------------------*/
+
+/* Macros to configure the ADC port pins */
+#if (DA9052_GPIO_PIN_0 == DA9052_GPIO_CONFIG_ADC)
+#define ADC_CONF_ADC4					ENABLE
+#else
+#define ADC_CONF_ADC4					DISABLE
+#endif 
+#if (DA9052_GPIO_PIN_1 == DA9052_GPIO_CONFIG_ADC)
+#define ADC_CONF_ADC5					ENABLE
+#else
+#define ADC_CONF_ADC5					DISABLE
+#endif 
+#if (DA9052_GPIO_PIN_2 == DA9052_GPIO_CONFIG_ADC)
+#define ADC_CONF_ADC6					ENABLE
+#else
+#define ADC_CONF_ADC6					DISABLE
+#endif 
+
+/* Maximum retry count to check manual conversion over */
+#define MAX_MANCONV_RETRY_COUNT				8
+/*--------------------------------------------------------------------------*/
+/* Structure Definitions						    */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * struct threshold_res - 
+ *				Structure for configuring the thereshold values
+ * @auto4_high	: HIGH threshold value for ADCIN4
+ * @auto4_low	: LOW threshold value for ADCIN4
+ * @auto5_high	: HIGH threshold value for ADCIN5
+ * @auto5_low	: LOW threshold value for ADCIN5
+ * @auto6_high	: HIGH threshold value for ADCIN6
+ * @auto6_low	: LOW threshold value for ADCIN6
+ *
+ */
+typedef struct {
+	u8 auto4_high;
+	u8 auto4_low;
+	u8 auto5_high;
+	u8 auto5_low;
+	u8 auto6_high;
+	u8 auto6_low;
+}threshold_res;
+
+/**
+ * struct da9052_adc_data_t - 
+ *				Structure to hold ADC module data
+ * @channel	: Channel on which action to be done
+ * @mode	: AUTO / MANUAL mode selection
+ * @interval	: 1ms or 10ms timer selection
+ * @*data	: Pointer where data to be stored
+ * @threshold	: Threshold values of ADCIN4, ADCIN5 and ADCIN6
+ * @action	: Enable or Disable action
+ * @event_type	: For event registration
+ *
+ */ 
+ typedef struct {
+	u8 channel;
+	u8 mode;
+	u8 interval;
+	u16 *data;
+	threshold_res threshold;
+	u8 action;
+	u8 event_type;
+}da9052_adc_data_t;
+
+/**
+ * struct adc_event_occured_status - This structure stores the status of the 
+ * 		events that have been reported by the event handler through 
+ *		callback. This is required for handling multiple events occured 
+ *		same time.
+ *		adc_adcin4_e_occ	: Status of the ADCIN4 event occurance.
+ *		adc_adcin5_e_occ	: Status of the ADCIN5 event occurance.
+ *		adc_adcin6_e_occ	: Status of the ADCIN6 event occurance.
+ *		adc_comp1v2_e_occ	: Status of the COMP1V2 event occurance.
+ *
+*/
+typedef union {
+	u8 adc_event_status;
+	struct {
+		u8 adc_adcin4_e_occ 	: 1;
+		u8 adc_adcin5_e_occ 	: 1;
+		u8 adc_adcin6_e_occ 	: 1;
+		u8 adc_comp1v2_e_occ	: 1;
+		u8 dummy		: 4;
+	} event_bits_t;
+} adc_event_occ_status_t;
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables							    */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Inline Functions							    */
+/*--------------------------------------------------------------------------*/
+
+
+/*--------------------------------------------------------------------------*/
+/* External Functions							    */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Other Functions							    */
+/*--------------------------------------------------------------------------*/
+ 
+#endif /* _DA9052_ADC_H */
diff -Naur linux-2.6.33.2/include/linux/mfd/da9052/da9052_eh.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_eh.h
--- linux-2.6.33.2/include/linux/mfd/da9052/da9052_eh.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_eh.h	2010-05-18 15:29:36.000000000 +0500
@@ -0,0 +1,297 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_eh.h: Header file for Event Handler module for DA9052 PM IC
+ *
+ * DA9052 has a single IRQ line which can be used to indicate 32 various events.
+ * Event Handler (EH) module has following primary functions.
+ *
+ * (1) To receive and acknowledge interrupts from DA9052.
+ * (2) Extract all events form DA9052 event registers after receiving interrupt.
+ * (3) To provide a mechanism to register call back for specific events of
+ *     their interest, and call these call backs when corresponding event occurs.
+ * (4) To retrive, store and provide TSI data whenever requested by TSI module.
+ * 
+ * History:
+ *
+ * 12/05/2009:	Initial version
+ * 19/05/2009:	First unit tested version
+ *
+ * (27/04/2010):	Updated for Linux Community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+
+#ifndef _DA9052_EH_H
+#define _DA9052_EH_H
+
+#if defined (CONFIG_ARCH_S3C64XX)
+#define 	ARCH_DEPENDENT_DA9052			1
+#else
+#define		ARCH_DEPENDENT_DA9052			0	
+#endif
+/*--------------------------------------------------------------------------*/
+/* System wide include files                                                */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+#include <linux/workqueue.h>
+
+/*--------------------------------------------------------------------------*/
+/* Type Definitions                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Constant Definitions                                                     */
+/*--------------------------------------------------------------------------*/
+
+#define DA9052_EH_DEVICE_NAME		"da9052_eh"
+
+/* IOCTLs */
+#define DA9052_IOCTL_EH_DUMP_TREE	1
+
+/* Platform spcific defines */
+#if (ARCH_DEPENDENT_DA9052)
+#define DA9052_IRQ_PIN		S3C64XX_GPN(9)
+#define DA9052_IRQ		S3C_EINT(9)
+#else
+#define DA9052_IRQ_PIN		0
+#define DA9052_IRQ		0
+#endif
+
+/* Start and End of GPN register */
+#define GPN_REG_START		0x7F008830
+#define GPN_REG_END		0x7F008840
+
+/* Offset of GPN data register from GPN start */
+#define GPN_DAT_OFFSET		4
+#define GPN9			9
+#define DA9052_IRQ_PIN_BIT_NO	GPN9
+
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
+#define 	EVE_CNT		(GPI15_EVE+1)
+
+/* Priotirites */
+#define 	PRIO_0		0
+#define 	PRIO_1		1
+#define 	PRIO_2		2
+#define 	PRIO_3		3
+#define 	PRIO_4		4
+#define 	PRIO_5		5
+#define 	PRIO_6		6
+#define 	PRIO_7		7
+#define 	PRIO_8		8
+#define 	PRIO_9		9
+#define 	PRIO_10		10
+#define 	PRIO_11		11
+#define 	PRIO_12		12
+#define 	PRIO_13		13
+#define 	PRIO_14		14
+#define 	PRIO_15		15
+#define 	PRIO_16		16
+#define 	PRIO_17		17
+#define 	PRIO_18		18
+#define 	PRIO_19		19
+#define 	PRIO_20		20
+#define 	PRIO_21		21
+#define 	PRIO_22		22
+#define 	PRIO_23		23
+#define 	PRIO_24		24
+#define 	PRIO_25		25
+#define 	PRIO_26		26
+#define 	PRIO_27		27
+#define 	PRIO_28		28
+#define 	PRIO_29		29
+#define 	PRIO_30		30
+#define 	PRIO_31		31
+
+/* Total number of priorities */
+#define 	PRIO_CNT	(PRIO_31+1)
+
+/* Define for mapping events with their priorities */
+#define 	PRIO_0_EVE	TSI_READY_EVE
+#define 	PRIO_1_EVE	PEN_DOWN_EVE
+#define 	PRIO_2_EVE	ONKEY_EVE
+#define 	PRIO_3_EVE	VDD_LOW_EVE
+#define 	PRIO_4_EVE	ADC_EOM_EVE
+#define 	PRIO_5_EVE	ALARM_EVE
+#define 	PRIO_6_EVE	SEQ_RDY_EVE
+#define 	PRIO_7_EVE	COMP_1V2
+#define 	PRIO_8_EVE	ID_FLOAT_EVE
+#define 	PRIO_9_EVE	ID_GND_EVE
+#define 	PRIO_10_EVE	CHG_END_EVE
+#define 	PRIO_11_EVE	DCIN_DET_EVE
+#define 	PRIO_12_EVE	VBUS_DET_EVE
+#define 	PRIO_13_EVE	DCIN_REM_EVE
+#define 	PRIO_14_EVE	VBUS_REM_EVE
+#define 	PRIO_15_EVE	TBAT_EVE
+#define 	PRIO_16_EVE	GPI0_EVE
+#define 	PRIO_17_EVE	GPI1_EVE
+#define 	PRIO_18_EVE	GPI2_EVE
+#define 	PRIO_19_EVE	GPI3_EVE
+#define 	PRIO_20_EVE	GPI4_EVE
+#define 	PRIO_21_EVE	GPI5_EVE
+#define 	PRIO_22_EVE	GPI6_EVE
+#define 	PRIO_23_EVE	GPI7_EVE
+#define 	PRIO_24_EVE	GPI8_EVE
+#define 	PRIO_25_EVE	GPI9_EVE
+#define 	PRIO_26_EVE	GPI10_EVE
+#define 	PRIO_27_EVE	GPI11_EVE
+#define 	PRIO_28_EVE	GPI12_EVE
+#define 	PRIO_29_EVE	GPI13_EVE
+#define 	PRIO_30_EVE	GPI14_EVE
+#define 	PRIO_31_EVE	GPI15_EVE
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
+/* States for TSI state machine */
+#define WAIT_FOR_PEN_DOWN	0
+#define WAIT_FOR_SAMPLING	1
+#define SAMPLING_ACTIVE		2
+
+/* Number of sample to store in TSI FIFO */
+#define TSI_FIFO_SIZE		16
+
+/* Polling Frequency of EH in milliseconds */
+#define EH_POLLING_FREQ		1
+
+/* To enable debug output for your module, set this to 1 */
+#define		DA9052_EH_DEBUG		0
+
+#undef DA9052_DEBUG
+#if DA9052_EH_DEBUG
+#define DA9052_DEBUG( fmt, args... ) printk( KERN_CRIT "" fmt, ##args )
+#else
+#define DA9052_DEBUG( fmt, args... )
+#endif
+
+/*--------------------------------------------------------------------------*/
+/* Structure Definitions                                                    */
+/*--------------------------------------------------------------------------*/
+ 
+/**
+ * struct da9052_eh_nb 	- Notifier block structure
+ * @nb_list		: List head for notifier block list
+ * @eve_type		: Even type to which this notifier block is attached
+ * @call_back		: Function that should be called for this event 
+ */
+ typedef struct {
+	struct list_head nb_list;	/* list_head for nb list */
+	u8	eve_type;		/* Event type */
+	void (*call_back)(u32);		/* Call back function for this event*/
+ }da9052_eh_nb;
+
+ /**
+ * struct da9052_eh_info 	- Structure description
+ * @device_open			: Variable to store "open" status of EH device node
+ * @major_number		: Variable to store major number of EH device node
+ * @eve_prio_map		: Event priority mappings
+ * @eve_nb_array_lock		: Lock for event notifier block array
+ * @da9052_eh_platform_device	: Platform device structure for EH
+ * @eh_isr_work			:  Work queue structure
+ */
+typedef struct {
+	u8 device_open;	
+	s32 major_number;		
+	da9052_eh_nb eve_nb_array[EVE_CNT];		
+	u8 eve_prio_map[PRIO_CNT];
+	struct semaphore eve_nb_array_lock;
+	struct platform_device *da9052_eh_platform_device;
+//#if (ARCH_DEPENDENT_DA9052)
+	struct work_struct eh_isr_work;
+//#endif
+ }da9052_eh_info;
+ 
+ /**
+ * struct da9052_tsi	-  Structure description
+ * @tsi_fifo_lock	: Lock for acquiring TSI data
+ * @tsi_sampling	: TSI Sampling status
+ * @tsi_state		: State of TSI state machine
+ * @tsi_fifo		: FIFO to store TSI samples
+ * @tsi_fifo_start	: TSI FIFO queue start
+ * @tsi_fifo_end	:  TSI FIFO queue end
+ */
+typedef struct {
+	struct semaphore tsi_fifo_lock;	
+	u8 tsi_sampling;		
+	u8 tsi_state;		
+	da9052_tsi_reg tsi_fifo[TSI_FIFO_SIZE];
+	u32 tsi_fifo_start;
+	u32 tsi_fifo_end;
+}da9052_tsi;
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Inline Functions                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* External Functions                                                       */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Other Functions                                                          */
+/*--------------------------------------------------------------------------*/
+s32 da9052_eh_register_nb(da9052_eh_nb* nb);
+s32 da9052_eh_unregister_nb(da9052_eh_nb* nb);
+s32 da9052_tsi_start_sampling(void);
+s32 da9052_tsi_stop_sampling(void);
+s32 da9052_tsi_get_data(da9052_tsi_reg *buf, u8 cnt);
+
+#endif /* _DA9052_EH_H */
diff -Naur linux-2.6.33.2/include/linux/mfd/da9052/da9052_gpio.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_gpio.h
--- linux-2.6.33.2/include/linux/mfd/da9052/da9052_gpio.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_gpio.h	2010-05-18 15:29:36.000000000 +0500
@@ -0,0 +1,529 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_gpio.h: GPIO driver file for DA9052
+ *
+ * History:
+ *
+ * (05/05/2009)		Unit tested Code
+ *
+ * (27/04/2010):	Updated for Linux Community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+
+#ifndef _DA9052_GPIO_H
+#define _DA9052_GPIO_H
+
+/*--------------------------------------------------------------------------*/
+/* System wide include files                                                */
+/*--------------------------------------------------------------------------*/
+#include <linux/gpio.h>
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Type Definitions                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Constant Definitions                                                     */
+/*--------------------------------------------------------------------------*/
+
+/* String for the Identification */
+#define DA9052_GPIO_DEVICE_NAME		"da9052_gpio"
+
+/* Calculate the size of the variable */
+#define len_array(arr) (sizeof(arr)/sizeof(arr[0]))
+
+/*--------------------------------------------------------------------------*/
+/* Error Codes */
+/*--------------------------------------------------------------------------*/
+/* Failed Copy from User */
+#define COPY_FROM_USER_FAILED			(3)
+
+/* Failed Copy to User */
+#define COPY_TO_USER_FAILED			(4)
+
+/* Invalid Ioctl */
+#define DA9052_GPIO_INVALID_IOCTL		(5)
+
+//#define INVALID_SIGNAL_LEVEL			(6)
+/* Invalid functionality code for the 
+	corresponding pin */
+#define DA9052_GPIO_INVALID_FUNCTION		(7)
+
+/* Invalid event for the corresponding pin */
+#define INVALID_EVENT				(8)
+
+/* Event Registration with EH failed */
+#define EVENT_REGISTRATION_FAILED		(9)
+
+/* Event Unregistration with EH failed */
+#define EVENT_UNREGISTRATION_FAILED		(10)
+
+/* Invalid Signal level in case of Input */
+/* Invalid Voltage source in case of Output */
+#define INVALID_TYPE				(11)
+
+/* Invalid Debouncing in case of Input */
+/* Invalid Signal level in case of Output */
+#define INVALID_MODE				(12)
+
+/* Invalid Port Number */
+#define INVALID_PORTNUMBER			(13)
+
+/* Corresponding Pin has Already 
+	been registered with EH */
+#define EVENT_ALREADY_REGISTERED		(14)
+
+/* Corresponding Pin has Already 
+	been Unregistered with EH */
+#define EVENT_UNREGISTERED			(15)
+
+/* --------------------------------------------------------------------------*/
+/* IOCTL calls that are permitted to the /dev/gpio interface, if */
+/* any of the drivers are enabled. */
+/*--------------------------------------------------------------------------*/
+/* Read GPIO port */
+#define DA9052_GPIO_IOCTL_READ_PORT		(1)
+
+/* Write GPIO port */
+#define DA9052_GPIO_IOCTL_WRITE_PORT		(2)
+
+/* Configure GPIO port */
+#define DA9052_GPIO_IOCTL_CONFIGURE_PORT	(3)
+
+/* Read multiple GPIO ports */
+#define DA9052_GPIO_IOCTL_READ_ALL_PORTS	(4)
+
+/* Get last event occured */
+#define DA9052_GPIO_IOCTL_GET_EVENT		(5)
+
+/* Register for an event */
+#define DA9052_GPIO_IOCTL_REGISTER_EVENT	(6)
+
+/* Unregister for an event */
+#define DA9052_GPIO_IOCTL_UNREGISTER_EVENT	(7)
+
+
+/*--------------------------------------------------------------------------*/
+/* Defines for Various Pin Configurations of the Gpio pins */
+/*--------------------------------------------------------------------------*/
+/* ADC pin Configuration */
+#define DA9052_GPIO_CONFIG_ADC			(1)
+
+/* TSI pin Configuration */
+#define DA9052_GPIO_CONFIG_TSI			(2)
+
+/* Power Manager pin Configuration */
+#define DA9052_GPIO_CONFIG_PM			(3)
+
+/* USB ID detect pin Configuration */
+#define DA9052_GPIO_CONFIG_ACC_ID_DET		(4)
+
+/* General Purpose FB1 Configuration */
+#define DA9052_GPIO_CONFIG_GP_FB1		(5)
+
+/* VDD fault Configuration */
+#define DA9052_GPIO_CONFIG_VDD_FAULT		(6)
+
+/* I2C Pin configuration */
+#define DA9052_GPIO_CONFIG_I2C			(7)	
+
+/* Input/Output Pin Configuration */
+#define DA9052_GPIO_CONFIG			(8)
+
+/*--------------------------------------------------------------------------*/
+/* Currently used defines for GPIO PINs  */
+/*--------------------------------------------------------------------------*/
+
+/* ADC pin Configuration */
+#define DA9052_GPIO_PIN_0 	DA9052_GPIO_CONFIG_ADC
+#define DA9052_GPIO_PIN_1 	DA9052_GPIO_CONFIG_ADC
+#define DA9052_GPIO_PIN_2 	DA9052_GPIO_CONFIG_ADC
+
+/* TSI pin Configuration */
+#define DA9052_GPIO_PIN_3 	DA9052_GPIO_CONFIG_TSI
+#define DA9052_GPIO_PIN_4 	DA9052_GPIO_CONFIG_TSI
+#define DA9052_GPIO_PIN_5 	DA9052_GPIO_CONFIG_TSI
+#define DA9052_GPIO_PIN_6 	DA9052_GPIO_CONFIG_TSI
+#define DA9052_GPIO_PIN_7 	DA9052_GPIO_CONFIG_TSI
+
+/* Input Pin Configuration */
+#define DA9052_GPIO_PIN_8 	DA9052_GPIO_CONFIG
+#define DA9052_GPIO_PIN_9 	DA9052_GPIO_CONFIG
+#define DA9052_GPIO_PIN_10 	DA9052_GPIO_CONFIG
+#define DA9052_GPIO_PIN_11 	DA9052_GPIO_CONFIG
+
+/* Output Pin Configuration */
+#define DA9052_GPIO_PIN_12 	DA9052_GPIO_CONFIG
+#define DA9052_GPIO_PIN_13 	DA9052_GPIO_CONFIG
+
+/* Configuring for High Speed I2C */
+#define DA9052_GPIO_PIN_14 	DA9052_GPIO_CONFIG_I2C
+#define DA9052_GPIO_PIN_15 	DA9052_GPIO_CONFIG_I2C
+
+/*--------------------------------------------------------------------------*/
+/* To enable debug output, set this to 1 */
+/*--------------------------------------------------------------------------*/
+#define	DA9052_GPIO_DEBUG			(0)
+
+#undef DA9052_DEBUG
+#if DA9052_GPIO_DEBUG
+#define DA9052_DEBUG( fmt, args... ) printk( KERN_CRIT "" fmt, ##args )
+#else
+#define DA9052_DEBUG( fmt, args... )
+#endif
+
+/**
+ * enum ip_op_type - GPIO pin functionality
+ * @ALTERNATE_FUNCTIONALITY: configured as alternate functionality
+ * @INPUT: configured as GPI
+ * @OUTPUT_OPENDRAIN: configured as GPO open-drain
+ * @OUTPUT_PUSHPULL: configured as GPO push-pull
+ *
+ */
+enum ip_op_type {
+	ALTERNATE_FUNCTIONALITY = 0,
+	INPUT,
+	OUTPUT_OPENDRAIN,
+	OUTPUT_PUSHPULL
+};
+
+
+/**
+ * enum ip_type - GPI type
+ * @ACTIVE_LOW: active low
+ * @ACTIVE_HIGH: active high
+ *
+ */
+enum ip_type {
+	ACTIVE_LOW = 0,
+	ACTIVE_HIGH
+};
+
+/**
+ * enum op_type - GPO type
+ * @SUPPLY_VDD_IO1: supplied from VDDIO1/ internal pull-up
+ * @SUPPLY_VDD_IO2: supplied from VDDIO2/ external pull-up
+ *
+ */
+enum op_type {
+	SUPPLY_VDD_IO1 = 0,
+	SUPPLY_VDD_IO2
+};
+
+/**
+ * enum op_mode - GPO mode
+ * @OUTPUT_LOWLEVEL: low
+ * @OUTPUT_HIGHLEVEL: high
+ *
+ */
+enum op_mode {
+	OUTPUT_LOWLEVEL = 0,
+	OUTPUT_HIGHLEVEL
+};
+
+/**
+ * enum ip_mode - GPI mode
+ * @DEBOUNCING_OFF: debouncing off
+ * @DEBOUNCING_ON: debouncing on
+ *
+ */
+enum ip_mode {
+	DEBOUNCING_OFF = 0,
+	DEBOUNCING_ON
+};
+
+/**
+ * enum da9052_gpi_event_type - GPI event types
+ * @GPI_0_EVENT: Event for GPI port 0
+ * @GPI_1_EVENT: Event for GPI port 1
+ * ...
+ * @GPI_15_EVENT: Event for GPI port 15
+ *
+ */
+enum da9052_gpi_event_type {
+	GPI_0_EVENT = (1<<0),
+	GPI_1_EVENT = (1<<1),
+	GPI_2_EVENT = (1<<2),
+	GPI_3_EVENT = (1<<3),
+	GPI_4_EVENT = (1<<4),
+	GPI_5_EVENT = (1<<5),
+	GPI_6_EVENT = (1<<6),
+	GPI_7_EVENT = (1<<7),
+	GPI_8_EVENT = (1<<8),
+	GPI_9_EVENT = (1<<9),
+	GPI_10_EVENT = (1<<10),
+	GPI_11_EVENT = (1<<11),
+	GPI_12_EVENT = (1<<12),
+	GPI_13_EVENT = (1<<13),
+	GPI_14_EVENT = (1<<14),
+	GPI_15_EVENT = (1<<15),
+};
+
+
+
+/*--------------------------------------------------------------------------*/
+/* Default used defines for GPIO PINs  */
+/*--------------------------------------------------------------------------*/
+
+/*DEFAULT CONFIG FOR GPIO 0*/
+
+#if (DA9052_GPIO_PIN_0 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO0_FUNCTION	INPUT
+#define DEFAULT_GPIO0_TYPE	ACTIVE_LOW
+#define DEFAULT_GPIO0_MODE	DEBOUNCING_ON
+#endif
+
+/*DEFAULT CONFIG FOR GPIO 1*/
+#if (DA9052_GPIO_PIN_1 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO1_FUNCTION	INPUT
+#define DEFAULT_GPIO1_TYPE	ACTIVE_LOW
+#define DEFAULT_GPIO1_MODE	DEBOUNCING_ON
+#endif
+
+/*DEFAULT CONFIG FOR GPIO 2*/
+#if (DA9052_GPIO_PIN_2 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO2_FUNCTION	INPUT
+#define DEFAULT_GPIO2_TYPE	ACTIVE_LOW
+#define DEFAULT_GPIO2_MODE	DEBOUNCING_ON
+#endif
+
+/*DEFAULT CONFIG FOR GPIO 3*/
+#if (DA9052_GPIO_PIN_3 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO3_FUNCTION	INPUT
+#define DEFAULT_GPIO3_TYPE	ACTIVE_LOW
+#define DEFAULT_GPIO3_MODE	DEBOUNCING_ON
+#endif
+
+/*DEFAULT CONFIG FOR GPIO 4*/
+#if (DA9052_GPIO_PIN_4 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO4_FUNCTION	OUTPUT_PUSHPULL
+#define DEFAULT_GPIO4_TYPE	SUPPLY_VDD_IO1
+#define DEFAULT_GPIO4_MODE	OUTPUT_LOWLEVEL
+#endif
+/*DEFAULT CONFIG FOR GPIO 5*/
+#if (DA9052_GPIO_PIN_5 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO5_FUNCTION	OUTPUT_PUSHPULL
+#define DEFAULT_GPIO5_TYPE	SUPPLY_VDD_IO1
+#define DEFAULT_GPIO5_MODE	OUTPUT_LOWLEVEL
+#endif
+
+/*DEFAULT CONFIG FOR GPIO 6*/
+#if (DA9052_GPIO_PIN_6 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO6_FUNCTION	OUTPUT_PUSHPULL
+#define DEFAULT_GPIO6_TYPE	SUPPLY_VDD_IO1
+#define DEFAULT_GPIO6_MODE	OUTPUT_LOWLEVEL
+#endif
+
+/*DEFAULT CONFIG FOR GPIO 7*/
+#if (DA9052_GPIO_PIN_7 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO7_FUNCTION	OUTPUT_PUSHPULL
+#define DEFAULT_GPIO7_TYPE	SUPPLY_VDD_IO1
+#define DEFAULT_GPIO7_MODE	OUTPUT_LOWLEVEL
+#endif
+
+/*DEFAULT CONFIG FOR GPIO 8*/
+#if (DA9052_GPIO_PIN_8 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO8_FUNCTION	INPUT
+#define DEFAULT_GPIO8_TYPE	ACTIVE_LOW
+#define DEFAULT_GPIO8_MODE	DEBOUNCING_ON
+#endif
+
+/*DEFAULT CONFIG FOR GPIO 9*/
+#if (DA9052_GPIO_PIN_9 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO9_FUNCTION	INPUT
+#define DEFAULT_GPIO9_TYPE	ACTIVE_LOW
+#define DEFAULT_GPIO9_MODE	DEBOUNCING_ON
+#endif
+
+/*DEFAULT CONFIG FOR GPIO 10 - for RTC blinking LED */
+#if (DA9052_GPIO_PIN_10 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO10_FUNCTION	OUTPUT_PUSHPULL
+#define DEFAULT_GPIO10_TYPE	SUPPLY_VDD_IO2
+#define DEFAULT_GPIO10_MODE	OUTPUT_HIGHLEVEL
+#endif
+
+/*DEFAULT CONFIG FOR GPIO 11 - for RTC blinking LED */
+#if (DA9052_GPIO_PIN_11 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO11_FUNCTION	OUTPUT_PUSHPULL
+#define DEFAULT_GPIO11_TYPE	SUPPLY_VDD_IO2
+#define DEFAULT_GPIO11_MODE	OUTPUT_HIGHLEVEL
+#endif
+
+/*DEFAULT CONFIG FOR GPIO 12*/
+#if (DA9052_GPIO_PIN_12 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO12_FUNCTION	OUTPUT_PUSHPULL
+#define DEFAULT_GPIO12_TYPE	SUPPLY_VDD_IO1
+#define DEFAULT_GPIO12_MODE	OUTPUT_LOWLEVEL
+#endif
+/*DEFAULT CONFIG FOR GPIO 13*/
+#if (DA9052_GPIO_PIN_13 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO13_FUNCTION	OUTPUT_PUSHPULL
+#define DEFAULT_GPIO13_TYPE	SUPPLY_VDD_IO1
+#define DEFAULT_GPIO13_MODE	OUTPUT_LOWLEVEL
+#endif
+
+/*DEFAULT CONFIG FOR GPIO 14 - for LED4 */
+#if (DA9052_GPIO_PIN_14 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO14_FUNCTION	OUTPUT_OPENDRAIN
+#define DEFAULT_GPIO14_TYPE	SUPPLY_VDD_IO1
+#define DEFAULT_GPIO14_MODE	OUTPUT_HIGHLEVEL
+#endif
+
+/*DEFAULT CONFIG FOR GPIO 15 - for LED5 */
+#if (DA9052_GPIO_PIN_15 == DA9052_GPIO_CONFIG)
+#define DEFAULT_GPIO15_FUNCTION	OUTPUT_OPENDRAIN
+#define DEFAULT_GPIO15_TYPE	SUPPLY_VDD_IO1
+#define DEFAULT_GPIO15_MODE	OUTPUT_HIGHLEVEL
+#endif
+
+
+/* Maximum number of Gpio Ports */
+#define MAX_PORTNUMBER				(16)
+
+/* Maximum number of ports per register */
+#define MAX_PORTS_PER_REGISTER			(8)
+
+/* No of shift operations to performed */
+#define SHIFT_COUNT(no)				((no)%8)
+
+/* Mask of even numbered port */
+#define EVEN_PORT_FUNCTIONALITY 		(0x03)
+
+/* Mask of odd numbered port */
+#define ODD_PORT_FUNCTIONALITY 			(0x30)
+
+/* Mask Upper nibble */
+#define MASK_UPPER_NIBBLE 			(0xF0)
+
+/* Mask Lower nibble */
+#define MASK_LOWER_NIBBLE 			(0x0F)
+
+/* Nibble Shift */
+#define NIBBLE_SHIFT 				(4)
+
+/* Mode setting for Even Port number Write */
+#define EVEN_PORT_WRITE_MODE 			(1 << 3)
+
+/* Mode setting for ODD Port number Write */
+#define ODD_PORT_WRITE_MODE 			(1 << 7)
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+
+
+/*--------------------------------------------------------------------------*/
+/* Structure Definitions                                                    */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * struct da9052_gpio_read_write_t - Contains the i/p or o/p value for a GPIO
+ * @port_number: gpio ports
+ * @read_write_value: gpio value
+ *
+ */
+typedef struct {
+	u8 port_number:4;
+	u8 read_write_value:1;
+} da9052_gpio_read_write_t;
+
+/**
+ * struct da9052_gpio_multiple_read_t - Contains the signal level at each port
+ * @port_number: all gpio ports
+ *
+ */
+typedef struct {
+	u8 signal_value[16];
+} da9052_gpio_multiple_read_t;
+
+
+/**
+ * struct da9052_gpi_config_t - GPI configuration
+ * @type: GPI Type
+ * @mode: GPI mode
+ *
+ */
+typedef struct {
+	enum ip_type type;
+	enum ip_mode mode;
+} da9052_gpi_config_t;
+
+/**
+ * struct da9052_gpo_config_t - GPO configuration
+ * @type: GPO Type
+ * @mode: GPO mode
+ *
+ */
+typedef struct {
+	enum op_type type;
+	enum op_mode mode;
+} da9052_gpo_config_t; 
+
+/**
+ * union da9052_gpio_config_t - GPIO configuration either input or output
+ * @input: GPI configuration
+ * @output: GPO configuration
+ *
+ */
+typedef union {
+	da9052_gpi_config_t input;
+	da9052_gpo_config_t output;
+} da9052_gpio_config_t;
+
+/**
+ * struct da9052_gpio_t - GPIO information
+ * @gpio_config: GPIO configuration either input or output
+ * @gpio_function: GPIO function
+ * @port_number: GPIO port number
+ *
+ */
+typedef struct {
+	da9052_gpio_config_t gpio_config;
+	enum ip_op_type gpio_function;
+	u8 port_number:4;
+} da9052_gpio_t;
+
+/**
+ * struct da9052_gpio_chip_t - GPIO information
+ * @gpio: GPIO Information
+ * @gp: GPIO Chip Information
+ */
+typedef struct {
+	da9052_gpio_t gpio;
+	da9052_gpio_read_write_t read_write;
+	struct gpio_chip gp;
+} da9052_gpio_chip_t;
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Inline Functions                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* External Functions                                                       */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Other Functions                                                          */
+/*--------------------------------------------------------------------------*/
+s32 da9052_gpio_read_port(da9052_gpio_read_write_t *read_port);
+s32 da9052_gpio_multiple_read(da9052_gpio_multiple_read_t *multiple_port);
+s32 da9052_gpio_write_port(da9052_gpio_read_write_t *write_port);
+s32 da9052_gpio_configure_port(da9052_gpio_t *gpio_data);
+s32 da9052_gpio_register_event(u8 event_type);
+s32 da9052_gpio_unregister_event(u8 event_type);
+
+#endif /* _DA9052_GPIO_H */
diff -Naur linux-2.6.33.2/include/linux/mfd/da9052/da9052_lib.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_lib.h
--- linux-2.6.33.2/include/linux/mfd/da9052/da9052_lib.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_lib.h	2010-05-18 15:29:36.000000000 +0500
@@ -0,0 +1,112 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_lib.h: helper function for DA9052 drivers
+ *
+ * History:
+ *
+ * (28/04/2009):	Created the first draft
+ *
+ * (<DD/MM/YYYY>):	<Description of change>
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+
+#ifndef _DA9052_LIB_H
+#define _DA9052_LIB_H
+
+/*--------------------------------------------------------------------------*/
+/* System wide include files                                                */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Type Definitions                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Constant Definitions                                                     */
+/*--------------------------------------------------------------------------*/
+
+#define set_bits(value, mask)		(value | mask)
+#define clear_bits(value, mask)		(value & ~(mask))
+
+#define SUCCESS		0
+#define FAILURE		1
+
+#define OPEN 		1
+#define CLOSE 		0
+
+#define ENABLE		1
+#define DISABLE		0
+
+#define TRUE		1
+#define FALSE		0
+
+#define SET		1
+#define	RESET		0
+#define	CLEAR		0
+
+/*--------------------------------------------------------------------------*/
+/* Structure Definitions                                                    */
+/*--------------------------------------------------------------------------*/ 
+/**
+ * struct da9052_ssc_msg - Structure description
+ * @reg_addr	: DA9052 Register address
+ * @data	: For Write: Data to be written on given register
+		  For Read : Data has read from given register
+ *
+ */
+typedef struct {
+	u8 data;	/* For write/read data to/from register */
+	u8 addr;	/* DA9052 Register Address */	
+} da9052_ssc_msg;
+
+
+/**
+  * struct da9052_ts_reg - 
+  * This structure holds TSi co-ordinate data in same format as that in
+  * TSI control registers. Hence EH will be using this structure to buffer TSI
+  * data
+  * @x_msb 		8 MSB's of X co-ordinate
+  * @y_msb 		8 MSB of Y co-ordinate
+  * @z_msb 		8 MSB of Z co-ordinate
+  * @lsb 		2 LSB's of X, Y & Z co-ordinates
+ */ 
+ typedef struct {
+ 	u8	x_msb;
+	u8	y_msb;
+	u8	z_msb;
+	u8	lsb;
+ }da9052_tsi_reg;
+ 
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+extern s32 da9052_ssc_write(da9052_ssc_msg*);
+extern s32 da9052_ssc_read(da9052_ssc_msg*);
+extern s32 da9052_ssc_write_many(da9052_ssc_msg *sscmsg, s32 cnt);
+extern s32 da9052_ssc_read_many(da9052_ssc_msg *sscmsg, s32 cnt);
+
+/*--------------------------------------------------------------------------*/
+/* Inline Functions                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* External Functions                                                       */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Other Functions                                                          */
+/*--------------------------------------------------------------------------*/
+ 
+#endif /* _DA9052_LIB_H */
diff -Naur linux-2.6.33.2/include/linux/mfd/da9052/da9052_reg.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_reg.h
--- linux-2.6.33.2/include/linux/mfd/da9052/da9052_reg.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_reg.h	2010-05-18 15:29:36.000000000 +0500
@@ -0,0 +1,961 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_reg.h:	Register definition for DA9052
+ *
+ * History:
+ *
+ * (18/04/2009):	Defined all register & bit patterns
+ *
+ *(27/04/2010):	Updated for Linux Community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+#ifndef __DA9052_REG_H
+#define __DA9052_REG_H
+
+/*--------------------------------------------------------------------------*/
+/* System wide include files                                                */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Type Definitions                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Constant Definitions                                                     */
+/*--------------------------------------------------------------------------*/
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
+/************************PAGE CONFIGURATION ***************************/
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
+#define DA9052_CONTROLA_PMOV		(1<<4
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
+#define DA9052_GPIO0001_GPIO1MODE  	(1<<7)
+#define DA9052_GPIO0001_GPIO1TYPE  	(1<<6)
+#define DA9052_GPIO0001_GPIO1PIN  	(3<<4)
+#define DA9052_GPIO0001_GPIO0MODE  	(1<<3)
+#define DA9052_GPIO0001_GPIO0TYPE  	(1<<2)
+#define DA9052_GPIO0001_GPIO0PIN  	(3<<0)
+
+/* GPIO control register for PIN 2 and 3 */
+#define DA9052_GPIO0203_GPIO3MODE  	(1<<7)
+#define DA9052_GPIO0203_GPIO3TYPE  	(1<<6)
+#define DA9052_GPIO0203_GPIO3PIN  	(3<<4)
+#define DA9052_GPIO0203_GPIO2MODE  	(1<<3)
+#define DA9052_GPIO0203_GPIO2TYPE  	(1<<2)
+#define DA9052_GPIO0203_GPIO2PIN  	(3<<0)
+
+/* GPIO control register for PIN 4 and 5 */
+#define DA9052_GPIO0405_GPIO5MODE  	(1<<7)
+#define DA9052_GPIO0405_GPIO5TYPE  	(1<<6)
+#define DA9052_GPIO0405_GPIO5PIN  	(3<<4)
+#define DA9052_GPIO0405_GPIO4MODE  	(1<<3)
+#define DA9052_GPIO0405_GPIO4TYPE  	(1<<2)
+#define DA9052_GPIO0405_GPIO4PIN  	(3<<0)
+
+/* GPIO control register for PIN 6 and 7 */
+#define DA9052_GPIO0607_GPIO7MODE  	(1<<7)
+#define DA9052_GPIO0607_GPIO7TYPE  	(1<<6)
+#define DA9052_GPIO0607_GPIO7PIN  	(3<<4)
+#define DA9052_GPIO0607_GPIO6MODE  	(1<<3)
+#define DA9052_GPIO0607_GPIO6TYPE  	(1<<2)
+#define DA9052_GPIO0607_GPIO6PIN  	(3<<0)
+
+/* GPIO control register for PIN 8 and 9 */
+#define DA9052_GPIO0809_GPIO9MODE  	(1<<7)
+#define DA9052_GPIO0809_GPIO9TYPE  	(1<<6)
+#define DA9052_GPIO0809_GPIO9PIN  	(3<<4)
+#define DA9052_GPIO0809_GPIO8MODE  	(1<<3)
+#define DA9052_GPIO0809_GPIO8TYPE  	(1<<2)
+#define DA9052_GPIO0809_GPIO8PIN  	(3<<0)
+
+/* GPIO control register for PIN 10 and 11 */
+#define DA9052_GPIO1011_GPIO11MODE  	(1<<7)
+#define DA9052_GPIO1011_GPIO11TYPE  	(1<<6)
+#define DA9052_GPIO1011_GPIO11PIN  	(3<<4)
+#define DA9052_GPIO1011_GPIO10MODE 	(1<<3)
+#define DA9052_GPIO1011_GPIO10TYPE  	(1<<2)
+#define DA9052_GPIO1011_GPIO10PIN  	(3<<0)
+
+/* GPIO control register for PIN 12 and 13 */
+#define DA9052_GPIO1213_GPIO13MODE  	(1<<7)
+#define DA9052_GPIO1213_GPIO13TYPE  	(1<<6)
+#define DA9052_GPIO1213_GPIO13PIN  	(3<<4)
+#define DA9052_GPIO1213_GPIO12MODE  	(1<<3)
+#define DA9052_GPIO1213_GPIO12TYPE  	(1<<2)
+#define DA9052_GPIO1213_GPIO12PIN  	(3<<0)
+
+/* GPIO control register for PIN 14 and 15 */
+#define DA9052_GPIO1415_GPIO15MODE  	(1<<7)
+#define DA9052_GPIO1415_GPIO15TYPE  	(1<<6)
+#define DA9052_GPIO1415_GPIO15PIN  	(3<<4)
+#define DA9052_GPIO1415_GPIO14MODE  	(1<<3)
+#define DA9052_GPIO1415_GPIO14TYPE  	(1<<2)
+#define DA9052_GPIO1415_GPIO14PIN  	(3<<0)
+
+/*****************POWER SEQUENCER REGISTER*********************/
+
+/* SEQ control register for ID 0 and 1 */
+#define DA9052_ID01_LDO1STEP  		(15<<4)
+#define DA9052_ID01_SYSPRE  		(1<<2)
+#define DA9052_ID01_DEFSUPPLY  		(1<<1)
+#define DA9052_ID01_nRESMODE  		(1<<0)
+
+/* SEQ control register for ID 2 and 3 */
+#define DA9052_ID23_LDO3STEP  		(15<<4)
+#define DA9052_ID23_LDO2STEP  		(15<<0)
+
+/* SEQ control register for ID 4 and 5 */
+#define DA9052_ID45_LDO5STEP  		(15<<4)
+#define DA9052_ID45_LDO4STEP  		(15<<0)
+
+/* SEQ control register for ID 6 and 7 */
+#define DA9052_ID67_LDO7STEP  		(15<<4)
+#define DA9052_ID67_LDO6STEP  		(15<<0)
+
+/* SEQ control register for ID 8 and 9 */
+#define DA9052_ID89_LDO9STEP  		(15<<4)
+#define DA9052_ID89_LDO8STEP  		(15<<0)
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
+#define DA9052_CHGCONT_VCHGDROP		(3<<6)
+#define DA9052_CHGCONT_VCHGBAT		(3<<4)
+#define DA9052_CHGCONT_TCTR		(15<<0)
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
+/* ADC MAN regsisters */
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
+/* ADC 10 BIT MANUAL CONVERSION RESULT LOW regsister */
+#define DA9052_ADCRESL_ADCRESLSB	(3<<0)
+
+/* ADC 10 BIT MANUAL CONVERSION RESULT HIGH regsister */
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
+#define DA9052_TSICONTA_TSIDELAY  	(3<<6)
+#define DA9052_TSICONTA_TSISKIP  	(7<<3)
+#define DA9052_TSICONTA_TSIMODE  	(1<<2)
+#define DA9052_TSICONTA_PENDETEN  	(1<<1)
+#define DA9052_TSICONTA_AUTOTSIEN  	(1<<0)
+
+/* TSI Control Register B */
+#define DA9052_TSICONTB_ADCREF  	(1<<7)
+#define DA9052_TSICONTB_TSIMAN  	(1<<6)
+#define DA9052_TSICONTB_TSIMUX  	(3<<4)
+#define DA9052_TSICONTB_TSISEL3  	(1<<3)
+#define DA9052_TSICONTB_TSISEL2  	(1<<2)
+#define DA9052_TSICONTB_TSISEL1  	(1<<1)
+#define DA9052_TSICONTB_TSISEL0  	(1<<0)
+
+/* TSI X Co-ordinate MSB Result register */
+#define DA9052_TSIXMSB_TSIXM  		(255<<0)
+
+/* TSI Y Co-ordinate MSB Result register */
+#define DA9052_TSIYMSB_TSIYM  		(255<<0)
+
+/* TSI Co-ordinate LSB Result register */
+#define DA9052_TSILSB_PENDOWN  		(1<<6)
+#define DA9052_TSILSB_TSIZL		(3<<4)
+#define DA9052_TSILSB_TSIYL		(3<<2)
+#define DA9052_TSILSB_TSIXL		(3<<0)
+
+/* TSI Z Measurement MSB Result register */
+#define DA9052_TSIZMSB_TSIZM 		(255<<0)
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
+
+/*--------------------------------------------------------------------------*/
+/* Structure Definitions                                                    */
+/*--------------------------------------------------------------------------*/
+ 
+
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+
+
+/*--------------------------------------------------------------------------*/
+/* Inline Functions                                                         */
+/*--------------------------------------------------------------------------*/
+
+
+/*--------------------------------------------------------------------------*/
+/* External Functions                                                       */
+/*--------------------------------------------------------------------------*/
+
+
+/*--------------------------------------------------------------------------*/
+/* Other Functions                                                          */
+/*--------------------------------------------------------------------------*/
+
+#endif /* __DA9052_REG_H */
diff -Naur linux-2.6.33.2/include/linux/mfd/da9052/da9052_ssc.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_ssc.h
--- linux-2.6.33.2/include/linux/mfd/da9052/da9052_ssc.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_ssc.h	2010-05-18 15:29:36.000000000 +0500
@@ -0,0 +1,251 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_ssc.h: SSC (Synchronous Serial Communication) driver for DA9052
+ *
+ * This driver provides DA9052 specific wrappers around SPI and I2C host -
+ * drivers.
+ *
+ *
+ * History:
+ *
+ * 05/05/2009:	Initial version.
+ *		This version supports only SPI communication.
+ *		Hooks to underlying host SPI driver are very specific to -
+ *		SMDK-6410 host driver and some what non standard.
+ *		Curent version only supports SPI communication.
+ *		Support for I2C will be added in later versions.
+ *
+ * (27/06/2009):	Added caching feature for DA9052 Non-volatile registers
+ *
+ * (27/04/2010):	Updated for Linux Community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+#ifndef _DA9052_SSC_H
+#define _DA9052_SSC_H
+
+/*--------------------------------------------------------------------------*/
+/* System wide include files                                                */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Type Definitions                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Constant Definitions                                                     */
+/*--------------------------------------------------------------------------*/
+
+/* SSC device node name in /dev directory */
+#define DA9052_SSC_DEVICE_NAME		"da9052_ssc"
+
+/* Set one of the following according to your hardware interface with DA9052 */
+//#define CONFIG_MFD_DA9052_SPI		1		
+//#define CONFIG_MFD_DA9052_I2C		0
+
+/* Supported IOCTLs */
+#define DA9052_IOCTL_SSC_READ		0
+#define DA9052_IOCTL_SSC_WRITE		1
+#define DA9052_IOCTL_SSC_TEST		2
+#define DA9052_IOCTL_DUMP_SPI_REG	3
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
+/* Maximum number of registers that can be read/written by a singe request */
+#define	MAX_READ_WRITE_CNT		16
+
+/* To enable debug output for your module, set this to 1 */
+#define		DA9052_SSC_DEBUG	0
+
+#undef DA9052_DEBUG
+#if DA9052_SSC_DEBUG
+#define DA9052_DEBUG( fmt, args... ) printk( KERN_CRIT "" fmt, ##args )
+#else
+#define DA9052_DEBUG( fmt, args... )
+#endif
+
+/*--------------------------------------------------------------------------*/
+/* SPI Specific defines */
+/*--------------------------------------------------------------------------*/
+
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
+
+/*--------------------------------------------------------------------------*/
+/* I2C Specific defines */
+/*--------------------------------------------------------------------------*/
+#if defined (CONFIG_MFD_DA9052_I2C)
+/* I2C device name as defined in board info */
+#define DA9052_SSC_I2C_DEVICE_NAME		"da9052_ssc_i2c"
+
+/* Device slave address */
+#define	DA9052_I2C_ADDR				0x92
+
+/* I2C write modes */
+#define	DA9052_SSC_I2C_PAGE_WRITE_MODE		0
+#define DA9052_SSC_I2C_REPEAT_WRITE_MODE 	1
+
+/* Default write mode */
+#define DA9052_SSC_I2C_WRITE_MODE  		DA9052_SSC_I2C_REPEAT_WRITE_MODE
+#endif
+
+/*--------------------------------------------------------------------------*/
+/* Structure Definitions                                                    */
+/*--------------------------------------------------------------------------*/
+ /**
+ * struct da9052_ssc_cache_entry - Structure to hold parameters for a single - 
+ * entry of ssc register cache
+ * @type: Type of register i.e. Volatile or Non-volatile
+ * @status: Status of current cached value - Valid/Invalid
+ * @val: Value of register
+ */
+ typedef struct {
+	 u8 val;
+	 u8	type:4;
+	 u8	status:4;
+	// u8	val;
+}da9052_ssc_cache_entry;
+
+#if defined (CONFIG_MFD_DA9052_I2C)
+ /**
+  * struct da9052_ssc_i2c_data - Structure to hold I2C specific data
+  * @ adapter: I2C Adapter for this device
+  * @ da9052_slave_addr: DA9052 I2C device address
+  */
+ typedef struct {
+	 
+	 struct	i2c_adapter 	*adapter;
+	 u8			da9052_slave_addr;
+ }da9052_ssc_i2c_data;
+#endif
+ 
+ /**
+ * \struct da9052_ssc_info - Structure description
+ * @device_open:		To prevent multiple opens
+ * @major_number:		Major number for SSC device
+ * @ssc_sem:			ssc lock
+ * @ssc_cache:			SSC cache for non-volatile registers.
+ * 				Each entry has three parameters for each register of DA9052
+ * 				(1) Type of register i.e. Volatile or Non-volatile
+ * 				(2) Status of current cached value - Valid/Invalid
+ * 				(3) Value of register in case if it is non-volatile
+ *
+ * 				Volatile Register: A regsiter whose value can be updated 
+ *				by hardware. This - type of registers must be read every 
+ *				time from hardware and can't be cached
+ *
+ * 				Non-volatile Register: A register whose value can never 
+ *				be updated by - hardware automatically. 
+ *				i.e. the value gets changed only after a write - operation 
+ *				is performed. This type of registers can be cached. 
+ * SPI specific data field
+ * @spi_active_page		Current active page
+ * @rw_pol			Value of R/W_POL bit of INTERFACE REG (R19) of DA9052. 
+ *				Here we have used it's default value. If you change it 
+ *				through OTP or some other way, you need to set this variable accordingly
+ 
+ * @spi_dev			Handle to global spi_dev
+ * @spi_rx_buf			Buffer used for single register read function
+ * @spi_tx_buf			Buffer used for single register read function
+ * I2C specific data field
+ * @da9052_i2c_client		Handle for i2c client
+ * @da9052_ssc_platform_device	Platform device structure for SSC
+ */
+ typedef struct {
+	u8 			device_open;
+	s32 			major_number;
+	struct semaphore	ssc_sem;
+	da9052_ssc_cache_entry	ssc_cache[DA9052_REG_CNT];
+#if defined (CONFIG_MFD_DA9052_SPI)
+	u32 			spi_active_page;
+	u8 			rw_pol;
+	struct 			spi_device *spi_dev;
+	u8			*spi_rx_buf;
+	u8			*spi_tx_buf;
+#elif defined (CONFIG_MFD_DA9052_I2C)
+	struct i2c_client	*da9052_i2c_client;
+#endif
+	struct platform_device	*da9052_ssc_platform_device;
+}da9052_ssc_info; 
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Inline Functions                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* External Functions                                                       */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Other Functions                                                          */
+/*--------------------------------------------------------------------------*/
+ /* Generic Functions */
+s32 da9052_ssc_write(da9052_ssc_msg *sscmsg);
+s32 da9052_ssc_read(da9052_ssc_msg *sscmsg);
+
+s32 da9052_ssc_write_many(da9052_ssc_msg *sscmsg, s32 cnt);
+s32 da9052_ssc_read_many(da9052_ssc_msg *sscmsg, s32 cnt);
+
+#if defined (CONFIG_MFD_DA9052_SPI)
+
+/* SPI specific Functions */
+static s32 da9052_ssc_spi_read(da9052_ssc_msg *msg);
+static s32 da9052_ssc_spi_write(da9052_ssc_msg *msg);
+
+#elif defined (CONFIG_MFD_DA9052_I2C)
+
+/* I2C specific Functions */
+static s32 da9052_ssc_i2c_read(da9052_ssc_msg *msg);
+static s32 da9052_ssc_i2c_write(da9052_ssc_msg *msg);
+
+static s32 da9052_ssc_i2c_write_many(da9052_ssc_msg *sscmsg, s32 msg_no);
+static s32 da9052_ssc_i2c_read_many(da9052_ssc_msg *sscmsg, s32 msg_no);
+
+#endif	/* DA9052_SSC_CONFIG_SPI */
+
+#endif /* _DA9052_SSC_H */
Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.
