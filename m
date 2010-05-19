Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab0ESJcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:32:35 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:15576 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab0ESJcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:32:33 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] LEDs of DA9052 Linux device drivers (3/9)
Date: Wed, 19 May 2010 10:32:28 +0100
Message-ID: <3495EC08FA53E94AAA00CC4743D5BA7E010C20F0@pandora.diasemi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] LEDs of DA9052 Linux device drivers (3/9)
Thread-Index: Acr3NjJxUcchdvhhSzaQfmkLAa9DdA==
From: "David Dajun Chen" <Dajun.Chen@diasemi.com>
To: <linux-kernel@vger.kernel.org>
Cc: <rpurdie@rpsys.net>
X-OriginalArrivalTime: 19 May 2010 09:32:30.0704 (UTC) FILETIME=[340CF700:01CAF736]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear sir/madam,

The attached is the LED part of the device drivers newly developed for DA9052 Power Management IC from Dialog Semiconductor.

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
========================================================================

diff -Naur linux-2.6.33.2_bk/drivers/leds/da9052_led.c linux-2.6.33.2_patch/drivers/leds/da9052_led.c
--- linux-2.6.33.2_bk/drivers/leds/da9052_led.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/leds/da9052_led.c	2010-05-18 18:17:46.000000000 +0500
@@ -0,0 +1,783 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_led.c: White LED driver file for DA9052
+ *
+ * History:
+ *
+ * (28/04/2009):	Created first draft
+ *
+ * (04/05/2009):	Added power management support
+ *
+ * (07/05/2009):	Added dynamic configuration as an IOCTL command
+ *
+ * (22/06/2009):	Used macros for hard-coded numbers
+ *
+ * (26/06/2009):	Changed IOCTL names
+ *
+ * (29/06/2009):	Removed DA9052 READ/WRITE error codes
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
+#include <linux/leds.h>
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files					    */
+/*--------------------------------------------------------------------------*/
+#include <linux/mfd/da9052/da9052_reg.h>
+#include <linux/mfd/da9052/da9052_lib.h>
+#include <linux/mfd/da9052/da9052_led.h>
+
+/*--------------------------------------------------------------------------*/
+/* Local Type Definitions						    */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Local Constant Definitions						    */
+/*--------------------------------------------------------------------------*/
+static u8 banner[] __initdata = "DA9052 White LED Driver, v1.0\n";
+
+/*--------------------------------------------------------------------------*/
+/* Local Macro Definitions						    */
+/*--------------------------------------------------------------------------*/
+#define MAXIMUM_PWM		95
+/* Mask to obtain GPIO14 settings */
+#define MASK_GPIO14		0x0F
+/* Mask to obtain GPIO15 settings */
+#define MASK_GPIO15		0xF0
+/* "GPIO 15 Pin" position in GPIO_14_15 register */
+#define GPIO15_PIN_BIT_POSITION	4
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables							    */
+/*--------------------------------------------------------------------------*/
+static u8 wl_device_open = 0;
+static s32 wl_major_number = 0;
+static struct platform_device *da9052_wl_platform_device;
+
+static void da9052_wled_set(struct led_classdev *led_cdev,
+							enum led_brightness value)
+{
+	da9052_led_control_t led_control;
+	
+	da9052_wl_set_LED_intensity(led_control);
+}
+
+static struct led_classdev da9052_wled = {
+	.name		= "da9052:wled",
+	.brightness_set	= da9052_wled_set,
+};
+
+/*--------------------------------------------------------------------------*/
+/* Local Functions							    */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * da9052_wl_hw_init: Initializes the hardware with default settings
+ * 
+ * @param void
+ * @return int   Error Code, zero: no error
+ */
+static s32 da9052_wl_hw_init(void)
+{
+	da9052_ssc_msg msg;
+
+	/* Configure BOOST */
+	/* BOOST_ILIM: 0 = 710 mA, 1 = 1000 mA */
+	/* BOOST_FRQ: 0 = 1 MHz, 1 = 2 MHz */
+	msg.data = (BOOST_ENABLE ? DA9052_BOOST_BOOSTEN : DISABLE) |
+		(LED1_CONNECTED_TO_BOOST ? DA9052_BOOST_LED1INEN : DISABLE) |
+		(LED2_CONNECTED_TO_BOOST ? DA9052_BOOST_LED2INEN : DISABLE) |
+		(LED3_CONNECTED_TO_BOOST ? DA9052_BOOST_LED3INEN : DISABLE) |
+		(BOOST_ILIM ? DA9052_BOOST_BOOSTILIM : 0) |
+		(BOOST_FRQ ? DA9052_BOOST_BOOSTFRQ : 0) |
+		(BOOST_M_B_FAULT ? DA9052_BOOST_MBFAULT : DISABLE);
+
+	msg.addr = DA9052_BOOST_REG;
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	/* Configure LED_CONT */
+	/* LED3_CONTROL_MODE: 0 = PWM Controlled, 1 = Current Controlled */
+	msg.data = (LED1_CURRENT_SINK ? DA9052_LEDCONT_LED1EN : DISABLE) |
+		(LED1_CURRENT_RAMP ? DA9052_LEDCONT_LED1RAMP : DISABLE) |
+		(LED2_CURRENT_SINK ? DA9052_LEDCONT_LED2EN : DISABLE) |
+		(LED2_CURRENT_RAMP ? DA9052_LEDCONT_LED2RAMP : DISABLE) |
+		(LED3_CURRENT_SINK ? DA9052_LEDCONT_LED3EN : DISABLE) |
+		(LED3_CURRENT_RAMP ? DA9052_LEDCONT_LED3RAMP : DISABLE) |
+		(LED3_CONTROL_MODE ? DA9052_LEDCONT_LED3ICONT : 0);
+
+	msg.addr = DA9052_LEDCONT_REG;
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	/* Configure LED Currents */
+	msg.addr = DA9052_LEDMIN123_REG;
+	msg.data = LED_MINCURRENT;
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	msg.addr = DA9052_LED1CONF_REG;
+	msg.data = LED1_CURRENT;
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	msg.addr = DA9052_LED2CONF_REG;
+	msg.data = LED2_CURRENT;
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	msg.addr = DA9052_LED3CONF_REG;
+	msg.data = LED3_CURRENT;
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	/* Configure LED intensity */
+	msg.addr = DA9052_LED1CONT_REG;
+	msg.data = LED1_INTENSITY | (LED1_DIM ? DA9052_LED1CONT_LED1DIM :
+								DISABLE);
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	msg.addr = DA9052_LED2CONT_REG;
+	msg.data = LED2_INTENSITY | (LED2_DIM ? DA9052_LED2CONT_LED2DIM :
+								DISABLE);
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	msg.addr = DA9052_LED3CONT_REG;
+	msg.data = LED3_INTENSITY | (LED3_DIM ? DA9052_LED3CONT_LED3DIM :
+								DISABLE);
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	msg.addr = DA9052_LED4CONT_REG;
+	msg.data = LED4_INTENSITY | (LED4_DIM ? DA9052_LED4CONT_LED4DIM :
+								DISABLE);
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	msg.addr = DA9052_LED5CONT_REG;
+	msg.data = LED5_INTENSITY | (LED5_DIM ? DA9052_LED5CONT_LED5DIM :
+								DISABLE);
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	/* Check if LED4 is connected to GPIO14 */
+	#if LED4_CONNECTED_GPIO14
+	msg.addr = DA9052_GPIO1415_REG;
+	msg.data = 0;
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+	/* Set GPIO14 bits only - lower nibble of the register */
+	msg.data = clear_bits(msg.data, MASK_GPIO14);
+	/* Set the lower nibble - GPIO14 configuration */
+	/* Check if GPIO14_TYPE and GPIO14_MODE are 1 and set the respective
+	   bits */
+	msg.data = set_bits(msg.data, 
+			GPIO14_PIN | 
+			(GPIO14_TYPE ? DA9052_GPIO1415_GPIO14TYPE : 0) |
+			(GPIO14_MODE ? DA9052_GPIO1415_GPIO14MODE : 0));
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+	#endif
+
+	/* Check if LED5 is connected to GPIO15 */
+	#if LED5_CONNECTED_GPIO15
+	msg.addr = DA9052_GPIO1415_REG;
+	msg.data = 0;
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+	/* Set GPIO15 bits only - upper nibble of the register */
+	msg.data = clear_bits(msg.data, MASK_GPIO15);
+	/* Set the upper nibble - GPIO15 configuration */
+	/* Check if GPIO15_TYPE and GPIO15_MODE are 1 and set the respective
+	   bits */
+	msg.data = set_bits(msg.data, 
+			((GPIO15_PIN << GPIO15_PIN_BIT_POSITION) |
+			(GPIO15_TYPE ? DA9052_GPIO1415_GPIO15TYPE : 0) |
+			(GPIO15_MODE ? DA9052_GPIO1415_GPIO15MODE : 0))
+			);
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+	#endif
+
+	DA9052_DEBUG("Finished hardware initialization\n");
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_wl_hw_exit: Switches off the BOOST
+ * 
+ * @param void
+ * @return void
+ */
+static void da9052_wl_hw_exit(void)
+{
+	da9052_ssc_msg msg;
+
+	DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
+	/* Before exiting - switch off the Boost */
+	msg.addr = DA9052_BOOST_REG;
+	msg.data = 0;
+	da9052_ssc_write(&msg); 
+}
+
+/*--------------------------------------------------------------------------*/
+/* Global Functions							    */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * da9052_wl_set_boost_configuration: Sets the Boost attributes as per input
+ * 
+ * @param boost_config   Boost configuration settings
+ * @return int   Error Code, zero: no error
+ */
+s8 da9052_wl_set_boost_configuration(da9052_boost_config_t boost_config)
+{
+	da9052_ssc_msg msg;
+	u8 value = 0;
+
+	DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
+
+	msg.addr = DA9052_BOOST_REG;
+	/* Read boost register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+	value = msg.data;
+
+	/* Check the Boost parameter to be configured */
+
+	/* Check if Boost_Enable parameter */
+	value = boost_config.boost_enable ?
+		set_bits(value, DA9052_BOOST_BOOSTEN) : 
+		clear_bits(value, DA9052_BOOST_BOOSTEN);
+
+	/* Check if LED1_Boost_Enable parameter */
+	if (boost_config.led1_boost_enable)
+		value = set_bits(value, DA9052_BOOST_LED1INEN);
+	else
+		value = clear_bits(value, DA9052_BOOST_LED1INEN);
+
+	/* Check if LED2_Boost_Enable parameter */
+	if (boost_config.led2_boost_enable)
+		value = set_bits(value, DA9052_BOOST_LED2INEN);
+	else
+		value = clear_bits(value, DA9052_BOOST_LED2INEN);
+
+	/* Check if LED3_Boost_Enable parameter */
+	if (boost_config.led3_boost_enable)
+		value = set_bits(value, DA9052_BOOST_LED3INEN);
+	else
+		value = clear_bits(value, DA9052_BOOST_LED3INEN);
+
+	/* Check if Boost_Current_Limit parameter */
+	if (CURRENT_1000MA == boost_config.current_limit)
+		value = set_bits(value, DA9052_BOOST_BOOSTILIM);
+	else if (CURRENT_710MA == boost_config.current_limit)
+		value = clear_bits(value, DA9052_BOOST_BOOSTILIM);
+	else
+		return (INVALID_BOOST_CUR_LIMIT);
+
+	/* Check if Boost_Switching_Frequency parameter */
+	if (FREQUENCY_2MHZ == boost_config.switching_frequency)
+		value = set_bits(value, DA9052_BOOST_BOOSTFRQ);
+	else if (FREQUENCY_1MHZ == boost_config.switching_frequency)
+		value = clear_bits(value, DA9052_BOOST_BOOSTFRQ);
+	else
+		return (INVALID_BOOST_SWITCH_FRE);
+
+	msg.data = value;
+	/* Write boost register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_wl_set_led_configuration: Sets the LED configuration as per input
+ * 
+ * @param led_config   LED configuration settings
+ * @return int   Error Code, zero: no error
+ */
+s8 da9052_wl_set_led_configuration(da9052_led_config_t led_config)
+{
+	da9052_ssc_msg msg;
+	u8 led_ramp_bit;
+	u8 led_current_register;
+
+	DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
+
+	/* Check LED number */
+	switch (led_config.led_number) {
+	case LED1:
+		led_ramp_bit = DA9052_LEDCONT_LED1RAMP;
+		led_current_register = DA9052_LED1CONF_REG;
+		break;
+	case LED2:
+		led_ramp_bit = DA9052_LEDCONT_LED2RAMP;
+		led_current_register = DA9052_LED2CONF_REG;
+		break;
+	case LED3:
+		led_ramp_bit = DA9052_LEDCONT_LED3RAMP;
+		led_current_register = DA9052_LED3CONF_REG;
+		break;
+	default:
+		return (INVALID_LED_NUMBER);
+		break;
+	}
+
+	msg.addr = DA9052_LEDCONT_REG;
+	msg.data = 0;
+	/* Read LED_CONT register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Set/Clear the ramp bit */
+	msg.data = led_config.led_current_ramp_enable ?
+			set_bits(msg.data, led_ramp_bit) :
+			clear_bits(msg.data, led_ramp_bit);
+	/* Write LED_CONT register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	/* Set LED current */
+	msg.addr = led_current_register;
+	msg.data = led_config.led_current;
+	/* Write LED_CONF register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_wl_set_LED: Switches ON/OFF LED 
+ * 
+ * @param led_control   LED control settings
+ * @return int   Error Code, zero: no error
+ */
+s8 da9052_wl_set_LED(da9052_led_control_t led_control)
+{
+	da9052_ssc_msg msg;
+	u8 led_current_sink_bit;
+
+	DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
+
+	/* Check LED number */
+	switch (led_control.led_number) {
+	case LED1:
+		led_current_sink_bit = DA9052_LEDCONT_LED1EN;
+		break;
+	case LED2:
+		led_current_sink_bit = DA9052_LEDCONT_LED2EN;
+		break;
+	case LED3:
+		led_current_sink_bit = DA9052_LEDCONT_LED3EN;
+		break;
+	default:
+		DA9052_DEBUG("Invalied LED number: %d\n", 
+							led_control.led_number);
+		return (INVALID_LED_NUMBER);
+		break;
+	}
+
+	msg.addr = DA9052_LEDCONT_REG;
+	msg.data = 0;
+	/* Read LED_CONT register */
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* Set/Clear the LED current sink bit */
+	msg.data = led_control.led_current_sink_control ?
+			set_bits(msg.data, led_current_sink_bit) :
+			clear_bits(msg.data, led_current_sink_bit);
+	/* Write LED_CONT register */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_wl_set_LED_intensity: Sets LED intensity and DIM flag for a given LED 
+ * 
+ * @param led_control   LED control settings
+ * @return int   Error Code, zero: no error
+ */
+s8 da9052_wl_set_LED_intensity(da9052_led_control_t led_control)
+{
+	da9052_ssc_msg msg;
+	u8 led_dim_bit;
+	u8 led_pwm_register;
+
+	DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
+
+	/* Check LED number */
+	switch (led_control.led_number) {
+	case LED1:
+		led_dim_bit = DA9052_LED1CONT_LED1DIM;
+		led_pwm_register = DA9052_LED1CONT_REG;
+		break;
+	case LED2:
+		led_dim_bit = DA9052_LED2CONT_LED2DIM;
+		led_pwm_register = DA9052_LED2CONT_REG;
+		break;
+	case LED3:
+		led_dim_bit = DA9052_LED3CONT_LED3DIM;
+		led_pwm_register = DA9052_LED3CONT_REG;
+		break;
+	case LED4:
+		led_dim_bit = DA9052_LED4CONT_LED4DIM;
+		led_pwm_register = DA9052_LED4CONT_REG;
+		break;
+	case LED5:
+		led_dim_bit = DA9052_LED5CONT_LED5DIM;
+		led_pwm_register = DA9052_LED5CONT_REG;
+		break;
+	default:
+		return (INVALID_LED_NUMBER);
+		break;
+	}
+
+	/* Check if intensity to be set is greater than maximum */
+	if (led_control.led_intensity_value > MAXIMUM_PWM)
+		led_control.led_intensity_value = MAXIMUM_PWM;
+
+	msg.data = led_control.led_intensity_value |
+		(led_control.led_dim_control ? led_dim_bit : DISABLE);
+
+	msg.addr = led_pwm_register;
+	/* Write LED register */
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
+ * da9052_wl_open: Opens the device
+ * 
+ * @param *inode   pointer to device inode
+ * @param *file   file pointer
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_wl_open(struct inode *inode, struct file *file)
+{
+	/* Check if device is already open */
+	if (wl_device_open) {
+		DA9052_DEBUG(KERN_INFO "DA9052: LED device already open.\n");
+		return (-EBUSY);
+	} else {
+		wl_device_open++;
+		return (SUCCESS);
+	}
+}
+
+/**
+ * da9052_wl_release: Releases the device
+ * 
+ * @param *inode   pointer to device inode
+ * @param *file   file pointer
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_wl_release(struct inode *inode, struct file *file)
+{
+	wl_device_open--;
+	DA9052_DEBUG(KERN_INFO "DA9052: White LED device closed.\n");
+	return (SUCCESS);
+}
+
+#ifdef CONFIG_PM
+/**
+ * da9052_wl_suspend: Power Management support function
+ * 
+ * @param *dev   pointer to platform device
+ * @param state  pm state
+ * @return s32 status of suspend operation
+ */
+static s32 da9052_wl_suspend(struct platform_device *dev, pm_message_t state)
+{
+	/* Put your suspend related operations here */
+	printk(KERN_INFO "%s: called\n", __FUNCTION__);
+	
+	led_classdev_suspend(&da9052_wled);
+	
+	return (SUCCESS);
+}
+
+/**
+ * da9052_wl_resume: Power Management support function
+ * 
+ * @param *dev   pointer to platform device
+ * @return s32 status of resume operation
+ */
+static s32 da9052_wl_resume(struct platform_device *dev)
+{
+	/* Put your resume related operations here */
+	printk(KERN_INFO "%s: called\n", __FUNCTION__);
+	
+	led_classdev_resume(&da9052_wled);
+	
+	return (SUCCESS);
+}
+#else
+#define da9052_wl_suspend NULL
+#define da9052_wl_resume NULL
+#endif
+/**
+ * da9052_wl_ioctl: Provides the IOCTL interface
+ * 
+ * @param *inode   pointer to device inode
+ * @param *file   file pointer
+ * @param cmd   command to be executed
+ * @param arg   argument to command
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_wl_ioctl(struct inode *inode, struct file *file, 
+					unsigned int cmd, unsigned long arg)
+{
+	s32 ret_status = SUCCESS;
+	da9052_led_control_t led_ctrl_param;
+	da9052_led_config_t led_config_param;
+	da9052_boost_config_t boost_config_param;
+
+	DA9052_DEBUG(KERN_INFO "DA9052: White LED device IOCTL.\n");
+
+	/* Check command to be executed */
+	switch (cmd) {
+	case DA9052_IOCTL_LED_SET_LED:
+		/* Copy parameters from user space */
+		if (copy_from_user(&led_ctrl_param, (da9052_led_control_t *)arg, 
+							sizeof(led_ctrl_param)))
+			return (FAILURE);
+
+		DA9052_DEBUG(KERN_DEBUG "%s():da9052_wl_set_LED called\n",
+								__FUNCTION__);
+		ret_status = da9052_wl_set_LED(led_ctrl_param);
+		break;
+	case DA9052_IOCTL_LED_SET_INTENSITY:
+		/* Copy parameters from user space */
+		if (copy_from_user(&led_ctrl_param, (da9052_led_control_t *)arg, 
+							sizeof(led_ctrl_param)))
+			return (FAILURE);
+
+		DA9052_DEBUG(
+			KERN_DEBUG "%s():da9052_wl_set_LED_intensity called\n",
+								__FUNCTION__);
+		ret_status = da9052_wl_set_LED_intensity(led_ctrl_param);
+		break;
+	case DA9052_IOCTL_LED_CONFIG_LED:
+		/* Copy parameters from user space */
+		if (copy_from_user(&led_config_param, 
+			(da9052_led_config_t *)arg, sizeof(led_config_param)))
+			return (FAILURE);
+
+		DA9052_DEBUG(
+		KERN_DEBUG "%s():da9052_wl_set_led_configuration called\n",
+								__FUNCTION__);
+		ret_status = da9052_wl_set_led_configuration(led_config_param);
+		break;
+	case DA9052_IOCTL_LED_CONFIG_BOOST:
+		/* Copy parameters from user space */
+		if (copy_from_user(&boost_config_param, 
+		(da9052_boost_config_t *)arg, sizeof(boost_config_param)))
+			return (FAILURE);
+
+		DA9052_DEBUG(
+		KERN_DEBUG "%s():da9052_wl_set_boost_configuration called\n",
+								__FUNCTION__);
+		ret_status = 
+			da9052_wl_set_boost_configuration(boost_config_param);
+		break;
+	default:
+		DA9052_DEBUG(KERN_DEBUG "Invalid ioctl command\n");
+		return (INVALID_LEDIOCTLCMD);
+	}
+	return (ret_status);
+}
+
+/**
+ * static struct file_operations da9052_wl_fops -
+ * This structure definition has to be defined here as an exception.
+ * @owner: 
+ * @open : pointer to function providing "open" interface
+ * @release: pointer to function providing "release" interface
+ * @ioctl: pointer to function providing "ioctl" interface
+ *
+ */
+static const struct file_operations da9052_wl_fops = {
+	.owner		= THIS_MODULE,
+	.open		= da9052_wl_open,
+	.release	= da9052_wl_release,
+	.ioctl		= da9052_wl_ioctl
+};
+
+/**
+ * da9052_wl_probe: Called when a device gets attached to driver 
+ * 
+ * @param *dev   pointer to platform device
+ * @return int   Error Code, zero: no error
+ */
+static s32 __devinit da9052_wl_probe(struct platform_device *dev)
+{
+	s32 ret;
+
+	/* Register the device as led register class device */
+	ret =  led_classdev_register(dev->dev.parent, &da9052_wled);
+	if (ret < 0) {
+		printk(KERN_INFO "Unable to register DA9052 LED as LED Class device \n");
+		led_classdev_unregister(&da9052_wled);
+		return (-EFAULT);	
+	}
+
+	/* Register the device */
+	ret = register_chrdev(wl_major_number,
+				DA9052_LED_DEVICE_NAME, &da9052_wl_fops);
+	if (ret < 0) {
+		printk(KERN_ERR "Unable to register %s\n",
+						DA9052_LED_DEVICE_NAME);
+		return (-EFAULT);	
+	} else {
+		wl_major_number = ret;
+		printk(KERN_INFO "%s: Major number is: %d \n",
+				DA9052_LED_DEVICE_NAME, wl_major_number);
+
+		/* Initialize the hardware */
+		if (da9052_wl_hw_init()) {
+			/* Error in hw initialization */
+			unregister_chrdev(wl_major_number,
+							DA9052_LED_DEVICE_NAME);
+			return (-EFAULT);
+		} else
+		
+		return (SUCCESS);
+	}
+	
+	printk(KERN_INFO "Exiting DA9052 wl_led probe function. \n");
+}
+
+/**
+ * da9052_wl_remove: Called when detaching device from driver
+ * @param *dev   pointer to platform device
+ * @return int   Error Code, zero: no error
+ */
+static int __devexit da9052_wl_remove(struct platform_device *dev)
+{
+	
+	DA9052_DEBUG(KERN_DEBUG "Removing %s \n", DA9052_LED_DEVICE_NAME);
+	
+	led_classdev_unregister(&da9052_wled);
+
+	return (SUCCESS);
+}
+
+/**
+ * static struct platform_driver da9052_wl_driver -
+ * This structure definition has to be defined here as an exception.
+ * @probe: Probe function for this device. 
+ * @remove: Function to be called when removing this device from platform
+ * @suspend: Function to be called in suspend mode
+ * @resume: Function to be called in resume mode
+ * @driver: Contains glue logic to bind platform device and plarform driver
+ */
+static struct platform_driver da9052_wl_driver = {
+	.probe		= da9052_wl_probe,
+	.remove		= __devexit_p(da9052_wl_remove),
+	.suspend	= da9052_wl_suspend,
+	.resume		= da9052_wl_resume,
+	.driver		= {
+		.name	= DA9052_LED_DEVICE_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+/**
+ * da9052_wl_init: Initiates the driver
+ * 
+ * @param void
+ * @return int   Error Code, zero: no error
+ */
+static s32 __init da9052_wl_init(void)
+{
+	int retval;
+	printk(banner);
+	
+	/* Create a platform device object */
+	da9052_wl_platform_device = platform_device_alloc("da9052_led", 0);
+	if (!da9052_wl_platform_device)
+		return (-ENOMEM);
+
+	/* Add platform device to device hierarchy */
+	retval = platform_device_add(da9052_wl_platform_device);
+	if (retval < 0) {
+		/* Free all memory associated with a platform device */
+		platform_device_put(da9052_wl_platform_device);
+		return (retval);
+	}
+
+	retval = platform_driver_register(&da9052_wl_driver);
+	if (retval < 0)
+		/* Unregister the platform level device */
+		platform_device_unregister(da9052_wl_platform_device);
+		
+	return (retval);
+}
+
+/**
+ * da9052_wl_exit: Closes the driver
+ * 
+ * @param void
+ * @return void
+ */
+static void __exit da9052_wl_exit(void)
+{
+	printk("DA9052: Unregistering White LED device.\n");
+	
+	/* De-initializes hardware */
+	da9052_wl_hw_exit();
+
+	/* Unregister the driver */
+	unregister_chrdev(wl_major_number, DA9052_LED_DEVICE_NAME);
+
+	platform_driver_unregister(&da9052_wl_driver);
+	/* Unregister the platform level device */
+	platform_device_unregister(da9052_wl_platform_device);
+}
+
+module_init(da9052_wl_init);
+module_exit(da9052_wl_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd");
+MODULE_DESCRIPTION("DA9052 White LED Device Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9052_led");
+
+/*--------------------------------------------------------------------------*/
+/* Exports								    */
+/*--------------------------------------------------------------------------*/
+/* All functions accessible from other drivers */
+EXPORT_SYMBOL(da9052_wl_set_boost_configuration);
+EXPORT_SYMBOL(da9052_wl_set_led_configuration);
+EXPORT_SYMBOL(da9052_wl_set_LED);
+EXPORT_SYMBOL(da9052_wl_set_LED_intensity);
diff -Naur linux-2.6.33.2_bk/drivers/leds/Makefile linux-2.6.33.2_patch/drivers/leds/Makefile
--- linux-2.6.33.2_bk/drivers/leds/Makefile	2010-04-02 04:02:33.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/leds/Makefile	2010-05-18 18:17:46.000000000 +0500
@@ -33,6 +33,7 @@
 obj-$(CONFIG_LEDS_INTEL_SS4200)		+= leds-ss4200.o
 obj-$(CONFIG_LEDS_LT3593)		+= leds-lt3593.o
 obj-$(CONFIG_LEDS_ADP5520)		+= leds-adp5520.o
+obj-$(CONFIG_DA9052_LED_ENABLE)		+= da9052_led.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff -Naur linux-2.6.33.2_bk/drivers/mfd/Kconfig linux-2.6.33.2_patch/drivers/mfd/Kconfig
--- linux-2.6.33.2_bk/drivers/mfd/Kconfig	2010-05-18 17:54:30.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/mfd/Kconfig	2010-05-18 18:17:46.000000000 +0500
@@ -377,6 +377,13 @@
 	help
 	  Say Y  to enable the ADC driver for the DA9052 chip
 
+config DA9052_LED_ENABLE
+	bool "Dialog Semiconductor DA9052 LED Driver"
+	depends on MFD_DA9052
+	select LEDS_CLASS
+	help
+	  Say Y  to enable the LED driver for the DA9052 chip
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff -Naur linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_led.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_led.h
--- linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_led.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_led.h	2010-05-18 18:17:46.000000000 +0500
@@ -0,0 +1,533 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_led.h: White LED driver file for DA9052
+ *
+ * History:
+ *
+ * (28/04/2009):	Created first draft
+ *
+ * (04/05/2009):	Defined MAJOR Number for LED device driver
+ *
+ * (08/05/2009):	Added dynamic configuration as an IOCTL command
+ *
+ * (26/06/2009):	Changed IOCTL names
+ *
+ * (29/06/2009):	Removed DA9052 READ/WRITE error codes
+ *
+ * (27/04/2010):	Updated for Linux Community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+#ifndef _DA9052_LED_H
+#define _DA9052_LED_H
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
+#define DA9052_LED_DEVICE_NAME		"da9052_led"
+
+/* System Configuration */
+/* This section describes the following: */
+/* 1. system build time configuration E.g. system defaults */
+/* 2. hardware configuration E.g. whether LEDs are connected or not */
+/* E.g. If LED4 is connected to GPIO14, */
+/* then LED4_CONNECTED_GPIO14 macro should be set to 1 */
+
+/* Tells whether LED4 and LED5 are connected */
+/* 0 - Not Connected, 1 - Connected*/
+#define LED4_CONNECTED_GPIO14	0
+#define LED5_CONNECTED_GPIO15	0
+
+/* Boost configuration */
+/* 0 - Enable/Set, 1 - Disable/Clear */
+#define BOOST_ENABLE		1
+#define LED1_CONNECTED_TO_BOOST	1 /* Tells whether LED1 connected to Boost */
+#define LED2_CONNECTED_TO_BOOST	1 /* Tells whether LED1 connected to Boost */
+#define LED3_CONNECTED_TO_BOOST	1 /* Tells whether LED1 connected to Boost */
+#define BOOST_ILIM		0
+#define BOOST_FRQ		1
+#define BOOST_M_B_FAULT		0
+
+/* LED Configuration */
+/* 0 - Enable/Set, 1 - Disable/Clear */
+#define LED1_CURRENT_SINK	0
+#define LED1_CURRENT_RAMP	1
+#define LED2_CURRENT_SINK	0
+#define LED2_CURRENT_RAMP	1
+#define LED3_CURRENT_SINK	0
+#define LED3_CURRENT_RAMP	1
+#define LED3_CONTROL_MODE	1 /* Tells whether LED3 is
+				     1 = current-controlled OR
+				     0 = PWM-controlled */
+
+/* LED CURRENT */
+/* Refer "enum da9052_led_current_value" defined in this file */
+/* This macro can take values from 0 to 255 */
+#define LED_MINCURRENT		0  /* 50 uA value */
+#define LED1_CURRENT		33 /* 111.8 uA value */
+#define LED2_CURRENT		33 /* 111.8 uA value */
+#define LED3_CURRENT		33 /* 111.8 uA value */
+
+/* LED Intensity */
+#define LED1_INTENSITY		0 /* Default intensity 0% */
+#define LED1_DIM		0 /* Disabled */
+#define LED2_INTENSITY		0 /* Default intensity 0% */
+#define LED2_DIM		0 /* Disabled */
+#define LED3_INTENSITY		0 /* Default intensity 0% */
+#define LED3_DIM		0 /* Disabled */
+#define LED4_INTENSITY		0 /* Default intensity 0% */
+#define LED4_DIM		0 /* Disabled */
+#define LED5_INTENSITY		0 /* Default intensity 0% */
+#define LED5_DIM		0 /* Disabled */
+
+/* GPIO 14 Configuration */
+#define GPIO14_PIN		2 /* GPO Open Drain */
+#define GPIO14_TYPE		0 /* VDD_IO1 */
+#define GPIO14_MODE		1 /* Output High */
+
+/* GPIO 15 Configuration */
+#define GPIO15_PIN		2 /* GPO Open Drain */
+#define GPIO15_TYPE		0 /* VDD_IO1 */
+#define GPIO15_MODE		1 /* Output High */
+/* Finished system build time configuration */
+
+/* Enum definitions */
+/**
+ * enum da9052_led_boost_current_limit - 
+ *				Enum to represent the boost current limit
+ * @CURRENT_710MA: Boost current limit = 710mA
+ * @CURRENT_1000MA: Boost current limit = 1000mA
+ * 
+ */
+enum da9052_led_boost_current_limit {
+	CURRENT_710MA = 0,
+	CURRENT_1000MA,
+};
+
+/**
+ * enum da9052_led_boost_switching_frequency - 
+ *				Enum to represent the boost switching frequency
+ * @FREQUENCY_1MHZ: Boost switching frequency = 1MHz
+ * @FREQUENCY_2MHZ: Boost switching frequency = 2MHz
+ * 
+ */
+enum da9052_led_boost_switching_frequency {
+	FREQUENCY_1MHZ = 0,
+	FREQUENCY_2MHZ,
+};
+
+/**
+ * enum da9052_led_number - 
+ *		Enum to represent the LED number to perform the operation
+ * @LED1: LED1
+ * @LED2: LED2
+ * @LED3: LED3
+ * @LED4: LED4
+ * @LED5: LED5
+ *
+ */
+enum da9052_led_number {
+	LED1 = 1,
+	LED2,
+	LED3,
+	LED4,
+	LED5,
+};
+
+/**
+ * enum da9052_led_current_value - Enum for current values of LED
+ * DA9052_LED_CURRENT_50_0UA: represents 50.0 uA current value
+ */
+enum da9052_led_current_value {
+/* Current Value for LEDMIN, LED1_CONF, LED2_CONF, LED3_CONF Registers */
+	DA9052_LED_CURRENT_50_0UA = 0,
+	DA9052_LED_CURRENT_51_2UA,
+	DA9052_LED_CURRENT_52_5UA,
+	DA9052_LED_CURRENT_53_7UA,
+	DA9052_LED_CURRENT_55_1UA,
+	DA9052_LED_CURRENT_56_4UA,
+	DA9052_LED_CURRENT_57_8UA,
+	DA9052_LED_CURRENT_59_3UA,
+	DA9052_LED_CURRENT_60_7UA,
+	DA9052_LED_CURRENT_62_2UA,
+	DA9052_LED_CURRENT_63_8UA,
+	DA9052_LED_CURRENT_65_3UA,
+	DA9052_LED_CURRENT_67_0UA,
+	DA9052_LED_CURRENT_68_6UA,
+	DA9052_LED_CURRENT_70_3UA,
+	DA9052_LED_CURRENT_72_0UA,
+	DA9052_LED_CURRENT_73_8UA,
+	DA9052_LED_CURRENT_75_7UA,
+	DA9052_LED_CURRENT_77_5UA,
+	DA9052_LED_CURRENT_79_4UA,
+	DA9052_LED_CURRENT_81_4UA,
+	DA9052_LED_CURRENT_83_4UA,
+	DA9052_LED_CURRENT_85_5UA,
+	DA9052_LED_CURRENT_87_6UA,
+	DA9052_LED_CURRENT_89_8UA,
+	DA9052_LED_CURRENT_92_0UA,
+	DA9052_LED_CURRENT_94_2UA,
+	DA9052_LED_CURRENT_96_6UA,
+	DA9052_LED_CURRENT_99_0UA,
+	DA9052_LED_CURRENT_101_4UA,
+	DA9052_LED_CURRENT_103_9UA,
+	DA9052_LED_CURRENT_106_5UA,
+	DA9052_LED_CURRENT_109_1UA,
+	DA9052_LED_CURRENT_111_8UA,
+	DA9052_LED_CURRENT_114_6UA,
+	DA9052_LED_CURRENT_117_4UA,
+	DA9052_LED_CURRENT_120_6UA,
+	DA9052_LED_CURRENT_123_3UA,
+	DA9052_LED_CURRENT_126_3UA,
+	DA9052_LED_CURRENT_129_4UA,
+	DA9052_LED_CURRENT_132_6UA,
+	DA9052_LED_CURRENT_135_9UA,
+	DA9052_LED_CURRENT_139_3UA,
+	DA9052_LED_CURRENT_142_7UA,
+	DA9052_LED_CURRENT_146_2UA,
+	DA9052_LED_CURRENT_149_9UA,
+	DA9052_LED_CURRENT_153_6UA,
+	DA9052_LED_CURRENT_157_4UA,
+	DA9052_LED_CURRENT_161_2UA,
+	DA9052_LED_CURRENT_165_2UA,
+	DA9052_LED_CURRENT_169_3UA,
+	DA9052_LED_CURRENT_173_5UA,
+	DA9052_LED_CURRENT_177_8UA,
+	DA9052_LED_CURRENT_182_2UA,
+	DA9052_LED_CURRENT_186_7UA,
+	DA9052_LED_CURRENT_191_3UA,
+	DA9052_LED_CURRENT_196_0UA,
+	DA9052_LED_CURRENT_200_9UA,
+	DA9052_LED_CURRENT_205_8UA,
+	DA9052_LED_CURRENT_210_9UA,
+	DA9052_LED_CURRENT_216_1UA,
+	DA9052_LED_CURRENT_221_4UA,
+	DA9052_LED_CURRENT_226_9UA,
+	DA9052_LED_CURRENT_232_5UA,
+	DA9052_LED_CURRENT_238_3UA,
+	DA9052_LED_CURRENT_244_2UA,
+	DA9052_LED_CURRENT_250_2UA,
+	DA9052_LED_CURRENT_256_4UA,
+	DA9052_LED_CURRENT_262_7UA,
+	DA9052_LED_CURRENT_269_2UA,
+	DA9052_LED_CURRENT_275_8UA,
+	DA9052_LED_CURRENT_282_7UA,
+	DA9052_LED_CURRENT_289_6UA,
+	DA9052_LED_CURRENT_296_8UA,
+	DA9052_LED_CURRENT_304_1UA,
+	DA9052_LED_CURRENT_311_6UA,
+	DA9052_LED_CURRENT_319_3UA,
+	DA9052_LED_CURRENT_327_2UA,
+	DA9052_LED_CURRENT_335_3UA,
+	DA9052_LED_CURRENT_343_6UA,
+	DA9052_LED_CURRENT_352_1UA,
+	DA9052_LED_CURRENT_360_8UA,
+	DA9052_LED_CURRENT_369_7UA,
+	DA9052_LED_CURRENT_378_8UA,
+	DA9052_LED_CURRENT_388_2UA,
+	DA9052_LED_CURRENT_397_8UA,
+	DA9052_LED_CURRENT_407_6UA,
+	DA9052_LED_CURRENT_417_7UA,
+	DA9052_LED_CURRENT_428_0UA,
+	DA9052_LED_CURRENT_438_6UA,
+	DA9052_LED_CURRENT_449_4UA,
+	DA9052_LED_CURRENT_460_5UA,
+	DA9052_LED_CURRENT_471_9UA,
+	DA9052_LED_CURRENT_483_5UA,
+	DA9052_LED_CURRENT_495_5UA,
+	DA9052_LED_CURRENT_507_7UA,
+	DA9052_LED_CURRENT_520_3UA,
+	DA9052_LED_CURRENT_533_1UA,
+	DA9052_LED_CURRENT_546_3UA,
+	DA9052_LED_CURRENT_559_8UA,
+	DA9052_LED_CURRENT_573_6UA,
+	DA9052_LED_CURRENT_587_8UA,
+	DA9052_LED_CURRENT_602_3UA,
+	DA9052_LED_CURRENT_617_2UA,
+	DA9052_LED_CURRENT_632_4UA,
+	DA9052_LED_CURRENT_648_0UA,
+	DA9052_LED_CURRENT_664_0UA,
+	DA9052_LED_CURRENT_680_4UA,
+	DA9052_LED_CURRENT_697_2UA,
+	DA9052_LED_CURRENT_714_5UA,
+	DA9052_LED_CURRENT_732_1UA,
+	DA9052_LED_CURRENT_750_2UA,
+	DA9052_LED_CURRENT_768_7UA,
+	DA9052_LED_CURRENT_787_7UA,
+	DA9052_LED_CURRENT_807_2UA,
+	DA9052_LED_CURRENT_827_1UA,
+	DA9052_LED_CURRENT_847_6UA,
+	DA9052_LED_CURRENT_868_5UA,
+	DA9052_LED_CURRENT_889_9UA,
+	DA9052_LED_CURRENT_911_9UA,
+	DA9052_LED_CURRENT_934_4UA,
+	DA9052_LED_CURRENT_957_5UA,
+	DA9052_LED_CURRENT_981_2UA,
+	DA9052_LED_CURRENT_1005_4UA,
+	DA9052_LED_CURRENT_1030_3UA,
+	DA9052_LED_CURRENT_1055_7UA,
+	DA9052_LED_CURRENT_1081_8UA,
+	DA9052_LED_CURRENT_1108_5UA,
+	DA9052_LED_CURRENT_1135_9UA,
+	DA9052_LED_CURRENT_1163_9UA,
+	DA9052_LED_CURRENT_1192_7UA,
+	DA9052_LED_CURRENT_1222_2UA,
+	DA9052_LED_CURRENT_1252_3UA,
+	DA9052_LED_CURRENT_1283_3UA,
+	DA9052_LED_CURRENT_1315_0UA,
+	DA9052_LED_CURRENT_1347_5UA,
+	DA9052_LED_CURRENT_1380_7UA,
+	DA9052_LED_CURRENT_1414_8UA,
+	DA9052_LED_CURRENT_1449_8UA,
+	DA9052_LED_CURRENT_1485_6UA,
+	DA9052_LED_CURRENT_1522_3UA,
+	DA9052_LED_CURRENT_1559_9UA,
+	DA9052_LED_CURRENT_1598_4UA,
+	DA9052_LED_CURRENT_1637_9UA,
+	DA9052_LED_CURRENT_1678_4UA,
+	DA9052_LED_CURRENT_1719_8UA,
+	DA9052_LED_CURRENT_1762_3UA,
+	DA9052_LED_CURRENT_1805_8UA,
+	DA9052_LED_CURRENT_1850_4UA,
+	DA9052_LED_CURRENT_1896_1UA,
+	DA9052_LED_CURRENT_1943_0UA,
+	DA9052_LED_CURRENT_1991_0UA,
+	DA9052_LED_CURRENT_2040_2UA,
+	DA9052_LED_CURRENT_2090_5UA,
+	DA9052_LED_CURRENT_2142_2UA,
+	DA9052_LED_CURRENT_2195_1UA,
+	DA9052_LED_CURRENT_2249_3UA,
+	DA9052_LED_CURRENT_2304_9UA,
+	DA9052_LED_CURRENT_2361_8UA,
+	DA9052_LED_CURRENT_2420_1UA,
+	DA9052_LED_CURRENT_2479_9UA,
+	DA9052_LED_CURRENT_2541_2UA,
+	DA9052_LED_CURRENT_2604_0UA,
+	DA9052_LED_CURRENT_2668_3UA,
+	DA9052_LED_CURRENT_2734_2UA,
+	DA9052_LED_CURRENT_2801_7UA,
+	DA9052_LED_CURRENT_2870_9UA,
+	DA9052_LED_CURRENT_2941_8UA,
+	DA9052_LED_CURRENT_3014_5UA,
+	DA9052_LED_CURRENT_3089_0UA,
+	DA9052_LED_CURRENT_3165_3UA,
+	DA9052_LED_CURRENT_3243_4UA,
+	DA9052_LED_CURRENT_3323_5UA,
+	DA9052_LED_CURRENT_3405_6UA,
+	DA9052_LED_CURRENT_3489_8UA,
+	DA9052_LED_CURRENT_3576_0UA,
+	DA9052_LED_CURRENT_3664_3UA,
+	DA9052_LED_CURRENT_3754_8UA,
+	DA9052_LED_CURRENT_3847_5UA,
+	DA9052_LED_CURRENT_3942_6UA,
+	DA9052_LED_CURRENT_4040_0UA,
+	DA9052_LED_CURRENT_4139_7UA,
+	DA9052_LED_CURRENT_4242_0UA,
+	DA9052_LED_CURRENT_4346_8UA,
+	DA9052_LED_CURRENT_4454_1UA,
+	DA9052_LED_CURRENT_4564_2UA,
+	DA9052_LED_CURRENT_4676_9UA,
+	DA9052_LED_CURRENT_4792_4UA,
+	DA9052_LED_CURRENT_4910_8UA,
+	DA9052_LED_CURRENT_5032_1UA,
+	DA9052_LED_CURRENT_5156_4UA,
+	DA9052_LED_CURRENT_5283_7UA,
+	DA9052_LED_CURRENT_5414_3UA,
+	DA9052_LED_CURRENT_5548_0UA,
+	DA9052_LED_CURRENT_5685_0UA,
+	DA9052_LED_CURRENT_5825_5UA,
+	DA9052_LED_CURRENT_5969_3UA,
+	DA9052_LED_CURRENT_6116_8UA,
+	DA9052_LED_CURRENT_6267_9UA,
+	DA9052_LED_CURRENT_6422_7UA,
+	DA9052_LED_CURRENT_6581_3UA,
+	DA9052_LED_CURRENT_6743_9UA,
+	DA9052_LED_CURRENT_6910_5UA,
+	DA9052_LED_CURRENT_7081_2UA,
+	DA9052_LED_CURRENT_7256_1UA,
+	DA9052_LED_CURRENT_7435_3UA,
+	DA9052_LED_CURRENT_7618_9UA,
+	DA9052_LED_CURRENT_7807_1UA,
+	DA9052_LED_CURRENT_8000_0UA,
+	DA9052_LED_CURRENT_8197_6UA,
+	DA9052_LED_CURRENT_8400_0UA,
+	DA9052_LED_CURRENT_8607_5UA,
+	DA9052_LED_CURRENT_8820_1UA,
+	DA9052_LED_CURRENT_9038_0UA,
+	DA9052_LED_CURRENT_9261_2UA,
+	DA9052_LED_CURRENT_9490_0UA,
+	DA9052_LED_CURRENT_9724_4UA,
+	DA9052_LED_CURRENT_9964_6UA,
+	DA9052_LED_CURRENT_10210_7UA,
+	DA9052_LED_CURRENT_10462_9UA,
+	DA9052_LED_CURRENT_10721_4UA,
+	DA9052_LED_CURRENT_10986_4UA,
+	DA9052_LED_CURRENT_11257_5UA,
+	DA9052_LED_CURRENT_11535_6UA,
+	DA9052_LED_CURRENT_11820_5UA,
+	DA9052_LED_CURRENT_12112_5UA,
+	DA9052_LED_CURRENT_12411_7UA,
+	DA9052_LED_CURRENT_12718_2UA,
+	DA9052_LED_CURRENT_13032_4UA,
+	DA9052_LED_CURRENT_13354_3UA,
+	DA9052_LED_CURRENT_13684_1UA,
+	DA9052_LED_CURRENT_14022_1UA,
+	DA9052_LED_CURRENT_14368_5UA,
+	DA9052_LED_CURRENT_14723_4UA,
+	DA9052_LED_CURRENT_15087_1UA,
+	DA9052_LED_CURRENT_15459_7UA,
+	DA9052_LED_CURRENT_15841_6UA,
+	DA9052_LED_CURRENT_16232_9UA,
+	DA9052_LED_CURRENT_16633_8UA,
+	DA9052_LED_CURRENT_17044_7UA,
+	DA9052_LED_CURRENT_17465_7UA,
+	DA9052_LED_CURRENT_17897_1UA,
+	DA9052_LED_CURRENT_18339_1UA,
+	DA9052_LED_CURRENT_18792_1UA,
+	DA9052_LED_CURRENT_19256_3UA,
+	DA9052_LED_CURRENT_19731_9UA,
+	DA9052_LED_CURRENT_20219_3UA,
+	DA9052_LED_CURRENT_20718_7UA,
+	DA9052_LED_CURRENT_21230_5UA,
+	DA9052_LED_CURRENT_21754_8UA,
+	DA9052_LED_CURRENT_22292_2UA,
+	DA9052_LED_CURRENT_22842_8UA,
+	DA9052_LED_CURRENT_23407_0UA,
+	DA9052_LED_CURRENT_23985_2UA,
+	DA9052_LED_CURRENT_24577_6UA,
+	DA9052_LED_CURRENT_25000_0UA,
+};
+
+/* Error codes */
+/* Start error code definition from 2 */
+/* Error code 1 is assigned to "FAILURE" */
+#define INVALID_BOOST_CUR_LIMIT		2
+#define INVALID_BOOST_SWITCH_FRE	3
+#define INVALID_LED_NUMBER		4
+#define INVALID_LEDIOCTLCMD		5
+
+/* To enable debug output, set this to 1 */
+#define DA9052_WL_DEBUG		0
+
+#undef DA9052_DEBUG
+#if DA9052_WL_DEBUG
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
+ * struct da9052_boost_config_t - 
+ *				Struct to represent all the Boost contfiguration
+ * @boost_enable: enable/disable boost converter
+ * @led1_boost_enable: enable/disable LED1 for boost voltage
+ * @led2_boost_enable: enable/disable LED2 for boost voltage 
+ * @led3_boost_enable: enable/disable LED3 for boost voltage
+ * @current_limit: set boost current limit
+ * @switching_frequency: set boost switching frequency
+ *
+ */
+typedef struct {
+	u8 boost_enable:1;
+	u8 led1_boost_enable:1;
+	u8 led2_boost_enable:1;
+	u8 led3_boost_enable:1;
+	enum da9052_led_boost_current_limit current_limit;
+	enum da9052_led_boost_switching_frequency switching_frequency;
+} da9052_boost_config_t;
+
+/**
+ * struct da9052_led_config_t -
+ *				Struct to represent all the LED configuration
+ * @led_current_ramp_enable: enable/disable LED current ramping
+ * @led_current: LED current
+ * @led_number: LED to be operated
+ * 
+ */
+typedef struct {
+	u8 led_current_ramp_enable:1;
+	enum da9052_led_current_value led_current;
+	enum da9052_led_number led_number;
+} da9052_led_config_t;
+
+
+/**
+ * struct da9052_led_control_t -  
+ *			Struct to represent the controls for a single LED
+ * @led_number: LED to be operated
+ * @led_current_sink_control: LED ON/OFF control
+ * @led_intensity_value: set LED intensity value
+ * @led_dim_status: set LED dim status
+ *
+ */
+typedef struct {
+	enum da9052_led_number led_number;
+	u8 led_current_sink_control:1;
+	u8 led_intensity_value:7;
+	u8 led_dim_control:1;
+} da9052_led_control_t;
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+/*
+ * IOCTL calls that are permitted to the /dev/da9052_led interface
+ */
+
+/* Set LED ON/OFF status */
+/* Input Parameter - da9052_led_control_t* */
+#define DA9052_IOCTL_LED_SET_LED	1
+
+/* Set LED intensity and dim status */
+/* Input Parameter - da9052_led_control_t* */
+#define DA9052_IOCTL_LED_SET_INTENSITY	2
+
+/* Configure LED parameters */
+/* Input Parameter - da9052_led_config_t* */
+#define DA9052_IOCTL_LED_CONFIG_LED	3
+
+/* Configure BOOST parameters */
+/* Input Parameter - da9052_boost_config_t* */
+#define DA9052_IOCTL_LED_CONFIG_BOOST	4
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
+s8 da9052_wl_set_boost_configuration(da9052_boost_config_t boost_config);
+s8 da9052_wl_set_led_configuration(da9052_led_config_t led_config);
+s8 da9052_wl_set_LED(da9052_led_control_t led_control);
+s8 da9052_wl_set_LED_intensity(da9052_led_control_t led_control);
+
+#endif /* _DA9052_LED_H */
Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.
