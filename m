Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab0ETRzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:55:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51191 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab0ETRzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:55:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rRfRFm40Y6LfE9osUI1trMdWWMYRIZaxDZ9B3Y3LgKTnpG3Yw8l+L5yYHyZa4Quv/j
         fdpvyK//2AgHbnZW2VL74eP+Nv0/o3DyjMqiWj8Sb7Qcf6hlVNTBKucwbnRZaByJF/US
         kLJ2q//HvUDbl04J10Ow988vWxEfFO/xQodSY=
MIME-Version: 1.0
In-Reply-To: <3495EC08FA53E94AAA00CC4743D5BA7E010C20EF@pandora.diasemi.com>
References: <3495EC08FA53E94AAA00CC4743D5BA7E010C20EF@pandora.diasemi.com>
Date: Thu, 20 May 2010 19:55:09 +0200
Message-ID: <AANLkTilA7jz3B3s0BdiQK4RcE-q0UQWNLCGJu30LV-A3@mail.gmail.com>
Subject: Re: [PATCH] GPIO of DA9052 Linux device drivers (2/9)
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: David Dajun Chen <Dajun.Chen@diasemi.com>
Cc: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 11:28 AM, David Dajun Chen
<Dajun.Chen@diasemi.com> wrote:
> Dear sir/madam,
>
> The attached is the GPIO part of the device drivers newly developed for DA9052 Power Management IC from Dialog Semiconductor.

A couple of things I saw fast-forwarding my reading.

>
> Regards
>
> Dr. David Dajun Chen
> Dialog Semiconductor Ltd.
> Delta 200, Welton Road
> Delta Business Park
> Swindon
> Wiltshire SN5 7XB
> UK
> Telephone: (+44) 01793-757714
> Mobile:         (+44) 07917015477
> Fax:               (+44) 01793-758000
> ============================================================================
>
> diff -Naur linux-2.6.33.2_bk/drivers/gpio/da9052_gpio.c linux-2.6.33.2_patch/drivers/gpio/da9052_gpio.c
> --- linux-2.6.33.2_bk/drivers/gpio/da9052_gpio.c        1970-01-01 05:00:00.000000000 +0500
> +++ linux-2.6.33.2_patch/drivers/gpio/da9052_gpio.c     2010-05-18 18:09:37.000000000 +0500
> @@ -0,0 +1,1460 @@
> +/*
> + * Copyright(c) 2009 Dialog Semiconductor Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * da9052_gpio.c : Driver for GPIO peripheral on DA9052 chip.
> + *
> + * History:
> + *
> + * (21/04/2009):       Created first draft

It is not important.

> + *
> + * (27/04/2010):       Created initial draft for Linux community release

Put this in the changelog and keep here just "Linux community release"
and keep the date updated in the following.

> + * Best Viewed with TabSize=8 and ColumnWidth=80

All code is supposed to be viewed like that.

> + */
> +
> +/*--------------------------------------------------------------------------*/
> +/* System wide include files                                                */
> +/*--------------------------------------------------------------------------*/
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <asm/uaccess.h>
> +#include <linux/platform_device.h>
> +
> +#ifndef CONFIG_ARCH_S3C64XX
> +#include <linux/syscalls.h>
> +#endif
> +
> +/*--------------------------------------------------------------------------*/
> +/* Module specific include files                                            */
> +/*--------------------------------------------------------------------------*/
> +#include <linux/mfd/da9052/da9052_reg.h>
> +#include <linux/mfd/da9052/da9052_lib.h>
> +#include <linux/mfd/da9052/da9052_eh.h>
> +#include <linux/mfd/da9052/da9052_gpio.h>
> +
> +/*--------------------------------------------------------------------------*/
> +/* Local Type Definitions                                                   */
> +/*--------------------------------------------------------------------------*/
> +
> +/*--------------------------------------------------------------------------*/
> +/* Local Constant Definitions                                               */
> +/*--------------------------------------------------------------------------*/
> +/* Display message during Initialization */
> +static u8 banner[] __initdata = "DA9052 GPIO Driver, v1.0\n";
> +/* Array for registration of the events */
> +static u8 event_registration[16];
> +/* typedef of the call back functions */
> +typedef void ( *gpio_callbacks_t)(u32);
> +/* Array of the Callback functions */
> +gpio_callbacks_t gpio_callback[16];
> +
> +
> +/*--------------------------------------------------------------------------*/
> +/* Local Macro Definitions                                                  */
> +/*--------------------------------------------------------------------------*/

Not needed.

> +
> +/*--------------------------------------------------------------------------*/
> +/* Global Variables                                                         */
> +/*--------------------------------------------------------------------------*/
> +/* unsigned char to check the device already open */
> +static u8 gpio_device_open = 0;
> +/* GPIO device number */
> +static s32 major_number = 0;
> +/* Structure of async queue */
> +static struct fasync_struct *gpio_fasync_queue;
> +/* structure for the device details */
> +static struct platform_device *da9052_gpio_platform_device;
> +/* mutex for events */
> +struct mutex da9052_gpio_event_lock;
> +/* Stores last occured event */
> +static u16 gpio_event;
> +
> +/* array of EH structures */
> +da9052_eh_nb eh_nb[16];
> +
> +
> +/*--------------------------------------------------------------------------*/
> +/* Local Functions                                                          */
> +/*--------------------------------------------------------------------------*/
> +/**
> + * da9052_gpio_signal_to_user: This function signal to the library to call
> + *                             the callback function for the event.
> + *
> + * @param event                        event for which library need to be signalled

Misspelled.

> + * @return int                 Error status 0:SUCCESS, Non Zero: Error
> + */
> +s32 da9052_gpio_signal_to_user(u16 event)
> +{
> +       /* Changed the following statement to implement multiple Events */

? You don't need to track all changes if they are not "do not patch
this because ..." comments.

> +       /* gpio_event = event; */
> +       mutex_lock(&da9052_gpio_event_lock);
> +       gpio_event |= event;
> +       mutex_unlock(&da9052_gpio_event_lock);
> +       DA9052_DEBUG("%s: event status: %d \n", __FUNCTION__, event);
> +       kill_fasync(&gpio_fasync_queue, SIGIO, POLL_IN);
> +
> +       return(SUCCESS);
> +}
> +
> +
> +/**
> + * da9052_gpio0_handler : EH callback function for GPI 0 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio0_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 0 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_0_EVENT);
> +}
> +
> +/**
> + * da9052_gpio1_handler : EH callback function for GPI 1 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio1_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 1 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_1_EVENT);
> +}
> +
> +/**
> + * da9052_gpio2_handler : EH callback function for GPI 2 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio2_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 2 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_2_EVENT);
> +}
> +
> +/**
> + * da9052_gpio3_handler : EH callback function for GPI 3 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio3_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 3 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_3_EVENT);
> +}
> +
> +/**
> + * da9052_gpio4_handler : EH callback function for GPI 4 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio4_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 4 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_4_EVENT);
> +}
> +
> +/**
> + * da9052_gpio5_handler : EH callback function for GPI 5 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio5_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 5 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_5_EVENT);
> +}
> +
> +/**
> + * da9052_gpio6_handler : EH callback function for GPI 6 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio6_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 6 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_6_EVENT);
> +}
> +
> +/**
> + * da9052_gpio7_handler : EH callback function for GPI 7 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio7_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 7 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_7_EVENT);
> +}
> +
> +/**
> + * da9052_gpio8_handler : EH callback function for GPI 8 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio8_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 8 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_8_EVENT);
> +}
> +
> +/**
> + * da9052_gpio9_handler : EH callback function for GPI 9 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio9_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 9 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_9_EVENT);
> +}
> +
> +/**
> + * da9052_gpio10_handler : EH callback function for GPI 10 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio10_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 10 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_10_EVENT);
> +}
> +
> +/**
> + * da9052_gpio11_handler : EH callback function for GPI 11 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio11_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 11 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_11_EVENT);
> +}
> +
> +/**
> + * da9052_gpio12_handler : EH callback function for GPI 12 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio12_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 12 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_12_EVENT);
> +}
> +
> +/**
> + * da9052_gpio13_handler : EH callback function for GPI 13 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio13_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 13 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_13_EVENT);
> +}
> +
> +/**
> + * da9052_gpio14_handler : EH callback function for GPI 14 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio14_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 14 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_14_EVENT);
> +}
> +
> +/**
> + * da9052_gpio15_handler : EH callback function for GPI 15 event
> + *
> + * @param u32 event    complete event status
> + * @return void
> + */
> +void da9052_gpio15_handler(u32 event)
> +{
> +       DA9052_DEBUG("In gpio 15 Event: %d\n",event);
> +       da9052_gpio_signal_to_user(GPI_15_EVENT);
> +}
> +
> +/**
> + * register_with_eh : Registers with EH for given interrupt
> + *
> + * @param is_registered_flag   Tells whether already registered
> + * @param eh_data              EH data to be filled up
> + * @param event                        Event to be registered
> + * @param call_back_fn         Callback function for the event
> + * @return void
> + */
> +s32 register_with_eh(u8 is_registered_flag, da9052_eh_nb *eh_data, u8 event,
> +                                               void (*call_back_fn)(u32))
> +{
> +       /* Set the EH data structure to register GPI event */
> +       eh_data->eve_type = event;
> +       eh_data->call_back = call_back_fn;
> +
> +       /* Register to the EH for the requested event */
> +       if (SUCCESS == da9052_eh_register_nb(eh_data)) {
> +               DA9052_DEBUG("\tEvent is registered\n");
> +       } else {
> +               return (EVENT_REGISTRATION_FAILED);
> +       }
> +       return (SUCCESS);
> +}
> +
> +/**
> + * create_gpio_config_value: Forms the GPIO value from given configuration
> + *
> + * @param gpio_function        GPIO PIN FUNCTION
> + * @param gpio_type    GPIO PIN TYPE
> + * @param gpio_mode    GPIO PIN MODE
> + * @return int   Error Code, zero: no error
> + */
> +u8 create_gpio_config_value(u8 gpio_function, u8 gpio_type, u8 gpio_mode)
> +{
> +       /* The format is -
> +               function - 2 bits
> +               type - 1 bit
> +               mode - 1 bit */
> +       return (gpio_function | (gpio_type << 2) | (gpio_mode << 3));
> +}
> +
> +/**
> + * write_default_gpio_values: Initialize the GPIO registers to default
> + *
> + * @param void
> + * @return int   Error Code, zero: no error
> + */
> +s32 write_default_gpio_values(void)
> +{
> +       /* SSC read/write structure */
> +       da9052_ssc_msg msg;
> +       /* receiving formed values */
> +       u8 created_val = 0;
> +       /* Default configuration of GPIO 0-15 */
> +       /* Even GPIOs (e.g. 0,2,4 ..) are placed in lower nibble */
> +       /* Odd GPIOs (e.g. 1,3,4 ..) are placed in upper nibble */
> +
> +       /* GPIO 0-1*/
> +       #if (DA9052_GPIO_PIN_0 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO0001_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 0 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO0_FUNCTION,
> +                               DEFAULT_GPIO0_TYPE, DEFAULT_GPIO0_MODE);
> +               msg.data &= MASK_UPPER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 0 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       #if (DA9052_GPIO_PIN_1 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO0001_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 1 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO1_FUNCTION,
> +                               DEFAULT_GPIO1_TYPE, DEFAULT_GPIO1_MODE);
> +               created_val = created_val << NIBBLE_SHIFT;
> +               msg.data &= MASK_LOWER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 1 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       /* GPIO 2-3*/
> +       #if (DA9052_GPIO_PIN_2 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO0203_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 2 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO2_FUNCTION,
> +                               DEFAULT_GPIO2_TYPE, DEFAULT_GPIO2_MODE);
> +               msg.data &= MASK_UPPER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 2 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       #if (DA9052_GPIO_PIN_3 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO0203_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 3 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO3_FUNCTION,
> +                               DEFAULT_GPIO3_TYPE, DEFAULT_GPIO3_MODE);
> +               created_val = created_val << NIBBLE_SHIFT;
> +               msg.data &= MASK_LOWER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 3 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       /* GPIO 4-5*/
> +       #if (DA9052_GPIO_PIN_4 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO0405_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 4 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO4_FUNCTION,
> +                               DEFAULT_GPIO4_TYPE, DEFAULT_GPIO4_MODE);
> +               msg.data &= MASK_UPPER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 4 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       #if (DA9052_GPIO_PIN_5 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO0405_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 5 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO5_FUNCTION,
> +                               DEFAULT_GPIO5_TYPE, DEFAULT_GPIO5_MODE);
> +               created_val = created_val << NIBBLE_SHIFT;
> +               msg.data &= MASK_LOWER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 5 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       /* GPIO 6-7*/
> +       #if (DA9052_GPIO_PIN_6 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO0607_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 6 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO6_FUNCTION,
> +                               DEFAULT_GPIO6_TYPE, DEFAULT_GPIO6_MODE);
> +               msg.data &= MASK_UPPER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 6 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       #if (DA9052_GPIO_PIN_7 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO0607_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 7 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO7_FUNCTION,
> +                               DEFAULT_GPIO7_TYPE, DEFAULT_GPIO7_MODE);
> +               created_val = created_val << NIBBLE_SHIFT;
> +               msg.data &= MASK_LOWER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 7 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       /* GPIO 8-9*/
> +       #if (DA9052_GPIO_PIN_8 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO0809_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 8 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO8_FUNCTION,
> +                               DEFAULT_GPIO8_TYPE, DEFAULT_GPIO8_MODE);
> +               msg.data &= MASK_UPPER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 8 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       #if (DA9052_GPIO_PIN_9 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO0809_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 9 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO9_FUNCTION,
> +                               DEFAULT_GPIO9_TYPE, DEFAULT_GPIO9_MODE);
> +               created_val = created_val << NIBBLE_SHIFT;
> +               msg.data &= MASK_LOWER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 9 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       /* GPIO 10-11*/
> +       #if (DA9052_GPIO_PIN_10 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO1011_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 10 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO10_FUNCTION,
> +                               DEFAULT_GPIO10_TYPE, DEFAULT_GPIO10_MODE);
> +               msg.data &= MASK_UPPER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 10 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       #if (DA9052_GPIO_PIN_11 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO1011_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 11 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO11_FUNCTION,
> +                               DEFAULT_GPIO11_TYPE, DEFAULT_GPIO11_MODE);
> +               created_val = created_val << NIBBLE_SHIFT;
> +               msg.data &= MASK_LOWER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 11 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       /* GPIO 12-13*/
> +       #if (DA9052_GPIO_PIN_12 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO1213_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 12 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO12_FUNCTION,
> +                               DEFAULT_GPIO12_TYPE, DEFAULT_GPIO12_MODE);
> +               msg.data &= MASK_UPPER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 12 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       #if (DA9052_GPIO_PIN_13 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO1213_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 13 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO13_FUNCTION,
> +                               DEFAULT_GPIO13_TYPE, DEFAULT_GPIO13_MODE);
> +               created_val = created_val << NIBBLE_SHIFT;
> +               msg.data &= MASK_LOWER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 13 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       /* GPIO 14-15*/
> +       #if (DA9052_GPIO_PIN_14 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO1415_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 14 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO14_FUNCTION,
> +                               DEFAULT_GPIO14_TYPE, DEFAULT_GPIO14_MODE);
> +               msg.data &= MASK_UPPER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 14 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       #if (DA9052_GPIO_PIN_15 == DA9052_GPIO_CONFIG)
> +               msg.addr = DA9052_GPIO1415_REG;
> +               msg.data = 0;
> +               if (da9052_ssc_read(&msg) != SUCCESS)   {
> +                       DA9052_DEBUG("GPIO 15 read default failed \n");
> +                       return (FAILURE);
> +               }
> +               created_val = create_gpio_config_value(DEFAULT_GPIO15_FUNCTION,
> +                               DEFAULT_GPIO15_TYPE, DEFAULT_GPIO15_MODE);
> +               created_val = created_val << NIBBLE_SHIFT;
> +               msg.data &= MASK_LOWER_NIBBLE;
> +               msg.data |= created_val;
> +
> +               if (da9052_ssc_write(&msg) != SUCCESS)  {
> +                       DA9052_DEBUG("GPIO 15 write default failed \n");
> +                       return (FAILURE);
> +               }
> +       #endif
> +       return (SUCCESS);
> +}
> +
> +/**
> + * da9052_gpio_hw_init: Initializes hardware with default settings
> + *
> + * @param void
> + * @return s32   Error Code, zero: no error
> + */
> +s32 da9052_gpio_hw_init(void)
> +{
> +       /* index of the for loop */

There is no for loop ; )

Also, indexes are represented by i

> +       u8 index = 0;
> +       /* Write default GPIO Values */
> +       if (SUCCESS != write_default_gpio_values()) {
> +               DA9052_DEBUG("GPIO Hardware initialization failed\n");
> +               return (FAILURE);
> +       }
> +       /* Initialize the Callback Function Array  and */
> +       /* Set EH registration flag to 0 */
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio0_handler;
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio1_handler;
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio2_handler;
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio3_handler;
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio4_handler;
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio5_handler;
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio6_handler;
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio7_handler;
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio8_handler;
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio9_handler;
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio10_handler;
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio11_handler;
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio12_handler;
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio13_handler;
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio14_handler;
> +       event_registration[index] = CLEAR;
> +       gpio_callback[index++] = da9052_gpio15_handler;
> +
> +       /* Initialize mutex required for Gpio Events read */
> +       mutex_init(&da9052_gpio_event_lock);
> +       return (SUCCESS);
> +}
> +
> +/**
> + * da9052_gpio_hw_exit: Un-register events with EH
> + *
> + * @param void
> + * @return void
> + */
> +static void da9052_gpio_hw_exit(void)
> +{
> +       /* unsigned char for int */

Weird comment.

> +       u8 index =0;
> +       DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
> +
> +       /* Before exiting - unregister events with EH */
> +       /* While exiting set EH registration flag to 0 */
> +       for (index = 0; index < sizeof(event_registration);index++)
> +       {
> +               /* check if the event is registered
> +               If registered then unregister the corresponding notifier
> +               block */
> +               if (event_registration[index])
> +                       da9052_eh_unregister_nb(&eh_nb[index]);
> +               event_registration[index] = CLEAR;
> +       }
> +       /* Delete Mutex */

Unnecessary.

> +       mutex_destroy(&da9052_gpio_event_lock);
> +}
> +
> +/*--------------------------------------------------------------------------*/
> +/* Global Functions                                                         */
> +/*--------------------------------------------------------------------------*/
> +
> +/**
> + * da9052_gpio_read_port: Reads the specified GPIO port
> + *
> + * @param read_port   GPIO Port to be read
> + * @return int   Error Code, zero: no error
> + */
> +s32 da9052_gpio_read_port(da9052_gpio_read_write_t *read_port)
> +{
> +       /* SSC struture variable */
> +       da9052_ssc_msg msg;
> +       /* u8 for the Shifted 8 bit value */
> +       u8 shift_value = 0;
> +       /* variable for the current pin function */
> +       u8 port_functionality = 0;
> +
> +       /* Find out the register to modify */
> +       msg.addr = (read_port->port_number / 2) + DA9052_GPIO0001_REG;
> +       msg.data = 0;
> +       if (da9052_ssc_read(&msg) != SUCCESS)
> +               return (FAILURE);
> +
> +       /* Even GPIOs (e.g. 0,2,4 ..) are placed in lower nibble */
> +       /* Odd GPIOs (e.g. 1,3,4 ..) are placed in upper nibble */
> +       /* Check whether to read the upper nibble or lower */
> +       port_functionality =
> +                       (read_port->port_number % 2) ?
> +                       ((msg.data & ODD_PORT_FUNCTIONALITY) >> NIBBLE_SHIFT):
> +                       (msg.data & EVEN_PORT_FUNCTIONALITY);
> +
> +       /* Check if the port is not configured for Input functionality */
> +       if (port_functionality != INPUT)
> +               return (INVALID_PORTNUMBER);
> +
> +
> +       /* Check if Port Number greater than MAX_PORTNUMBER */
> +       if (read_port->port_number >= (MAX_PORTNUMBER)) {
> +               return (INVALID_PORTNUMBER);
> +       }

Delete { }

> +       /* Check if Port Number greater than the no of ports in the register */
> +       if (read_port->port_number < MAX_PORTS_PER_REGISTER)
> +               msg.addr = DA9052_STATUSC_REG;
> +       else
> +       msg.addr = DA9052_STATUSD_REG;
> +       msg.data = 0;
> +
> +       /* Read the corresponding register through ssc */
> +       if (SUCCESS != da9052_ssc_read (&msg)) {
> +               DA9052_DEBUG(" SSC READ FAILED in %s()\n",__FUNCTION__);
> +               return (FAILURE);
> +       }
> +
> +       /* Get the value of the required bit corresponding to the port number*/
> +       shift_value = msg.data & (1 << SHIFT_COUNT(read_port->port_number));
> +       read_port->read_write_value = (shift_value >>
> +                                       SHIFT_COUNT(read_port->port_number));

Use tabs?

> +
> +       return (SUCCESS);

No need for ( ) in return.

> +}
> +
> +/**
> + * da9052_gpio_multiple_read: Reads all the GPIO ports
> + *
> + * @param multiple_port   Array of Signals to be read
> + * @return int   Error Code, zero: no error
> + */
> +s32 da9052_gpio_multiple_read(da9052_gpio_multiple_read_t *multiple_port)
> +{
> +       /* SSC data structure Vareiable */
> +       da9052_ssc_msg msg[2];
> +       /* Variable to hold the POrt Number */

Misspelled.

> +       u8 port_number =0;
> +       /* Unsigned Char to check array indexing */

I think it isn't necessary to say the type in the comment.

> +       u8 loop_index = 0;
> +
> +
> +       /* Read Status C register */
> +       msg[loop_index++].addr = DA9052_STATUSC_REG;
> +       /* Read Status D register */
> +       msg[loop_index++].addr = DA9052_STATUSD_REG;
> +
> +       /* Use SSC read Many function */
> +       if (SUCCESS != da9052_ssc_read_many(msg,loop_index)) {
> +               DA9052_DEBUG(" SSC READ MANY FAILED in %s()\n",__FUNCTION__);
> +               return (FAILURE);
> +       }
> +       /* Return the Status Reg values */
> +       loop_index = 0;
> +       for (port_number =0; port_number < MAX_PORTS_PER_REGISTER;port_number++) {
> +               multiple_port->signal_value[port_number] =
> +                       msg[loop_index].data & 1;
> +        msg[loop_index].data = msg[loop_index].data >> 1;
> +       }
> +       loop_index++;
> +       for (port_number =MAX_PORTS_PER_REGISTER; port_number < MAX_PORTNUMBER;
> +               port_number++) {
> +               multiple_port->signal_value[port_number] =
> +                       msg[loop_index].data & 1;
> +               msg[loop_index].data = msg[loop_index].data >> 1;
> +       }
> +       return (SUCCESS);
> +}
> +
> +/**
> + * da9052_gpio_write_port: Writes to specified GPIO port
> + *
> + * @param write_port   GPIO Port to be written
> + * @return int   Error Code, zero: no error
> + */
> +s32 da9052_gpio_write_port(da9052_gpio_read_write_t *write_port)
> +{
> +       /*SSC Communication Structure */
> +       da9052_ssc_msg msg;
> +       /* variable to find the Currently used Functionality */
> +       u8 port_functionality  = 0;
> +       /*variable to get the Bit position for setting the mode */
> +       u8 bit_pos = 0;
> +
> +       /* Check if the port is an output port */
> +       msg.addr = DA9052_GPIO0001_REG + (write_port->port_number / 2);
> +       msg.data = 0;
> +       if (da9052_ssc_read (&msg) != SUCCESS) {
> +               DA9052_DEBUG(" SSC READ FAILED in %s()\n",__FUNCTION__);
> +               return (FAILURE);
> +       }
> +       port_functionality =
> +                       (write_port->port_number % 2) ?
> +                       ((msg.data & ODD_PORT_FUNCTIONALITY) >> NIBBLE_SHIFT):
> +                       (msg.data & EVEN_PORT_FUNCTIONALITY);
> +
> +       if (port_functionality < 2)
> +               return (INVALID_PORTNUMBER);
> +
> +       /* Bit position is the highest bit in a nibble */
> +       /* Even GPIOs (e.g. 0,2,4 ..) are placed in lower nibble */
> +       /* Odd GPIOs (e.g. 1,3,4 ..) are placed in upper nibble */
> +       bit_pos = (write_port->port_number % 2) ? ODD_PORT_WRITE_MODE :
> +                               EVEN_PORT_WRITE_MODE;
> +
> +       /* Set the Corresponding Write port signal with the value
> +               from the user */
> +       msg.data = write_port->read_write_value ? set_bits(msg.data, bit_pos) :
> +                                               clear_bits(msg.data, bit_pos);
> +
> +       /* Write register */
> +       if (da9052_ssc_write(&msg) != SUCCESS) {
> +               return (FAILURE);
> +       }
> +       return (SUCCESS);
> +}
> +
> +/**
> + * da9052_gpio_configure_port: Configures the GPIO port
> + *
> + * @param gpio_data   GPIO Port to be configured
> + * @return int   Error Code, zero: no error
> + */
> +s32 da9052_gpio_configure_port(da9052_gpio_t *gpio_data)
> +{
> +       /* SSC data type variable*/
> +       da9052_ssc_msg msg;
> +       /* variable for the configure value */
> +       u8 register_value = 0;
> +       /* variable for the input pin function */
> +       u8 function = 0;
> +       /* variable for the current pin function */
> +       u8 port_functionality = 0;
> +
> +       /* Find out the register to modify */
> +       msg.addr = (gpio_data->port_number / 2) + DA9052_GPIO0001_REG;
> +       msg.data = 0;
> +       if (da9052_ssc_read(&msg) != SUCCESS)
> +               return (FAILURE);
> +
> +       /* Even GPIOs (e.g. 0,2,4 ..) are placed in lower nibble */
> +       /* Odd GPIOs (e.g. 1,3,4 ..) are placed in upper nibble */
> +       /* Check whether to read the upper nibble or lower */
> +       port_functionality =
> +                       (gpio_data->port_number % 2) ?
> +                       ((msg.data & ODD_PORT_FUNCTIONALITY) >> NIBBLE_SHIFT):
> +                       (msg.data & EVEN_PORT_FUNCTIONALITY);
> +
> +       /* Check if the port is not configured for Altenate functionality */
> +       if (port_functionality < INPUT)
> +               return (INVALID_PORTNUMBER);
> +       /* Check  GPIO type */
> +       if (gpio_data->gpio_config.input.type > ACTIVE_HIGH)
> +               return (INVALID_TYPE);
> +       /* Check Input GPIO mode */
> +       if (gpio_data->gpio_config.input.mode > DEBOUNCING_ON)
> +               return (INVALID_MODE);
> +       /* Check Input GPIO function */
> +       function = gpio_data->gpio_function;
> +       switch (function) {
> +       case INPUT:
> +               register_value = create_gpio_config_value(function,
> +                                       gpio_data->gpio_config.input.type,
> +                                       gpio_data->gpio_config.input.mode);
> +               break;
> +       case OUTPUT_OPENDRAIN:
> +       case OUTPUT_PUSHPULL:
> +               register_value = create_gpio_config_value(function,
> +                                       gpio_data->gpio_config.input.type,
> +                                       gpio_data->gpio_config.input.mode);
> +               break;
> +       default:
> +               return (DA9052_GPIO_INVALID_FUNCTION);
> +               break;
> +       }
> +
> +       /* Even GPIOs (e.g. 0,2,4 ..) are placed in lower nibble */
> +       /* Odd GPIOs (e.g. 1,3,4 ..) are placed in upper nibble */
> +       /* Check whether to modify the upper nibble or lower */
> +       if (gpio_data->port_number % 2) {
> +               /* It is upper nibble */
> +               /* Clear the Upper Nibble and Configure it with the new value */
> +               msg.data = (clear_bits(msg.data, MASK_UPPER_NIBBLE)) |
> +                               (register_value << NIBBLE_SHIFT);
> +       } else {
> +               /* It is lower nibble */
> +               /* Clear the lower Nibble and Configure it with the new value */
> +               msg.data = (clear_bits(msg.data, MASK_LOWER_NIBBLE)) |
> +                               register_value;
> +       }
> +
> +       /* Write the register */
> +       if (da9052_ssc_write(&msg) != SUCCESS)
> +               printk ("Write failed in configure\n");
> +       return (SUCCESS);
> +}
> +
> +/**
> + * da9052_gpio_register_event : Register gpio event with EH
> + *
> + * @param u8 event_type        GPI Event Type
> + * @return s32         Error status 0:SUCCESS, Non Zero: Error
> + */
> +s32 da9052_gpio_register_event(u8 event_type)
> +{
> +       da9052_ssc_msg msg;
> +       u8 port_functionality = 0;
> +       s32 ret = 0;
> +       DA9052_DEBUG("I am in function: %s \n", __FUNCTION__);
> +
> +       /* Check if the port is an output port by reading the register
> +       Contenets*/
> +       msg.addr = DA9052_GPIO0001_REG + (event_type/2);
> +       msg.data = 0;
> +       if (SUCCESS != da9052_ssc_read (&msg)) {
> +               DA9052_DEBUG(" SSC READ FAILED in %s()\n",__FUNCTION__);
> +               return (FAILURE);
> +       }
> +       port_functionality =
> +                       (event_type % 2) ?
> +                       ((msg.data & ODD_PORT_FUNCTIONALITY) >> NIBBLE_SHIFT):
> +                       (msg.data & EVEN_PORT_FUNCTIONALITY);
> +
> +       if (INPUT != port_functionality)
> +               return (INVALID_PORTNUMBER);
> +
> +       /* Check event type is already registered */
> +       if (event_registration[event_type])
> +               return (EVENT_ALREADY_REGISTERED);
> +       /* IF unregistered register it with EH */
> +       ret = register_with_eh(event_registration[event_type],
> +                                       &eh_nb[event_type],
> +                                       GPI0_EVE + event_type,
> +                                       gpio_callback[event_type]);
> +
> +       if (SUCCESS == ret) {
> +               /* Set the event variable to 1 */
> +               event_registration[event_type] = SET;
> +       } else {
> +               /* Return Failure cause */
> +               return (ret);
> +       }
> +       return (SUCCESS);
> +}
> +
> +/**
> + * da9052_gpio_unregister_event : Un-register gpio event with EH
> + *
> + * @param u8 event_type        Event Number
> + * @return s32         Error status 0:SUCCESS, Non Zero: Error
> + */
> +s32 da9052_gpio_unregister_event(u8 event_type)
> +{
> +       DA9052_DEBUG("I am in function: %s \n", __FUNCTION__);
> +       /* Check if the Event is not Registerd for the Corresponding Pin*/
> +       if (!event_registration[event_type])
> +               return (EVENT_UNREGISTERED);
> +       /* Else Unregister the Evant from EH */
> +       if (SUCCESS != da9052_eh_unregister_nb(&eh_nb[event_type]))
> +               return (EVENT_UNREGISTRATION_FAILED);
> +       /* Set flag to 0 */
> +       event_registration[event_type] = CLEAR;
> +       return (SUCCESS);
> +}
> +
> +/**
> + * da9052_gpio_read : Read Gpio status
> + *
> + * @param gc           Gpio chip structure
> + * @param offset       Gpio Number offset from base Gpio number
> + * @return s32         Error status 0:SUCCESS, Non Zero: Error
> + */
> +static s32 da9052_gpio_read (struct gpio_chip *gc, u32 offset)
> +{
> +       da9052_gpio_chip_t * gpio;
> +       gpio = container_of(gc, da9052_gpio_chip_t, gp);
> +       gpio->read_write.port_number            = offset;
> +       da9052_gpio_read_port (&gpio->read_write);
> +       return (gpio->read_write.read_write_value);
> +}
> +
> +/**
> + * da9052_gpio_write : Write Gpio level
> + *
> + * @param gc           Gpio chip structure
> + * @param offset       Gpio Number offset from base Gpio number
> + * @param value                Level for Gpio
> + * @return void
> + */
> +static void da9052_gpio_write (struct gpio_chip *gc, u32 offset, s32 value)
> +{
> +       da9052_gpio_chip_t * gpio;
> +       gpio = container_of(gc, da9052_gpio_chip_t, gp);
> +       gpio->read_write.port_number            = offset;
> +       gpio->read_write.read_write_value       = (u8)value;
> +       da9052_gpio_write_port (&gpio->read_write);
> +}
> +
> +/**
> + * da9052_gpio_ip : Read Gpio level
> + *
> + * @param gc           Gpio chip structure
> + * @param offset       Gpio Number offset from base Gpio number
> + * @return s32         Error status 0:SUCCESS, Non Zero: Error
> + */
> +static s32 da9052_gpio_ip (struct gpio_chip *gc, u32 offset)
> +{
> +       s32 ret = 0;
> +       da9052_gpio_chip_t * gpio;
> +       gpio = container_of(gc, da9052_gpio_chip_t, gp);
> +       gpio->gpio.gpio_function                        = INPUT;
> +       gpio->gpio.gpio_config.input.type       = ACTIVE_LOW;
> +       gpio->gpio.gpio_config.input.mode       = DEBOUNCING_ON;
> +       gpio->gpio.port_number                          = offset;
> +       ret                                                                     = da9052_gpio_configure_port (&gpio->gpio);
> +       return (ret);
> +}
> +
> +/**
> + * da9052_gpio_op : Read Gpio level
> + *
> + * @param gc           Gpio chip structure
> + * @param offset       Gpio Number offset from base Gpio number
> + * @param value                Level for Gpio
> + * @return s32         Error status 0:SUCCESS, Non Zero: Error
> + */
> +static s32 da9052_gpio_op (struct gpio_chip *gc, u32 offset, s32 value)
> +{
> +       s32 ret = 0;
> +       da9052_gpio_chip_t * gpio;
> +       gpio = container_of(gc, da9052_gpio_chip_t, gp);
> +       gpio->gpio.gpio_function                        = OUTPUT_PUSHPULL;
> +       gpio->gpio.gpio_config.output.type      = SUPPLY_VDD_IO2;
> +       gpio->gpio.gpio_config.output.mode      = value;
> +       gpio->gpio.port_number                          = offset;
> +       ret                                                                     = da9052_gpio_configure_port (&gpio->gpio);
> +       return(ret);
> +}
> +
> +/*--------------------------------------------------------------------------*/
> +/* Infrastructure Functions                                                */
> +/*--------------------------------------------------------------------------*/
> +
> +/**
> + * da9052_gpio_open:
> + *
> + * @param *inode pointer to device inode
> + * @param *file  file pointer
> + * @return int   Error Code, zero: no error
> + */
> +s32 da9052_gpio_open(struct inode *inode, struct file *file)
> +{
> +       /* Check if device is already open */
> +       if(gpio_device_open == OPEN) {
> +               DA9052_DEBUG("DA9052: gpio device already open.\n");
> +               return (-EBUSY);
> +       } else {
> +               gpio_device_open++;
> +               return SUCCESS;
> +       }
> +}
> +
> +/**
> + * da9052_gpio_release:
> + *
> + * @param *inode pointer to device inode
> + * @param *file  file pointer
> + * @return int   Error Code, zero: no error
> + */
> +s32 da9052_gpio_release(struct inode *inode, struct file *file)
> +{
> +       gpio_device_open--;
> +       DA9052_DEBUG("DA9052: GPIO device closed.\n");
> +       return SUCCESS;
> +}
> +
> +/**
> + * da9052_gpio_suspend: Power Management support function
> + *
> + * @param *dev   pointer to platform device
> + * @param state  pm state
> + * @return 0
> + */
> +static s32 da9052_gpio_suspend(struct platform_device *dev, pm_message_t state)
> +{
> +       /* Put your suspend related operations here */
> +       printk(KERN_INFO "%s: called\n", __FUNCTION__);
> +    return (0);
> +}
> +
> +/**
> + * da9052_gpio_resume: Power Management support function
> + *
> + * @param *dev   pointer to platform device
> + * @return 0
> + */
> +static s32 da9052_gpio_resume(struct platform_device *dev)
> +{
> +       /* Put your resume related operations here */
> +       printk(KERN_INFO "%s: called\n", __FUNCTION__);
> +    return (0);
> +}
> +
> +/**
> + * da9052_gpio_ioctl: Provides the IOCTL interface
> + *
> + * @param *inode   pointer to device inode
> + * @param *file   file pointer
> + * @param cmd   command to be executed
> + * @param arg   argument to command
> + * @return int   Error Code, zero: no error
> + */
> +s32 da9052_gpio_ioctl(struct inode *inode, struct file *file,
> +        unsigned int cmd, unsigned long arg)
> +{
> +       da9052_gpio_read_write_t read_write_params;
> +       da9052_gpio_multiple_read_t multiple_read;
> +       da9052_gpio_t config_port;
> +       u8 input;
> +       u16 copy_event = 0;
> +       s32 return_value;
> +
> +       /* Check the IOCTL command */
> +       switch(cmd) {
> +       case DA9052_GPIO_IOCTL_READ_PORT:
> +                DA9052_DEBUG("%s():DA9052_GPIO_IOCTL_READ_PORT \
> +                called\n", __FUNCTION__);
> +               /* Copy parameters from user space */
> +               if (copy_from_user(&read_write_params,
> +                                       (da9052_gpio_read_write_t *) arg,
> +                                       sizeof(da9052_gpio_read_write_t)))
> +                       return (COPY_FROM_USER_FAILED);
> +               /* In/Out Parameter - da9052_gpio_read_write_t* */
> +               return_value = da9052_gpio_read_port(&read_write_params);
> +               if (return_value != SUCCESS)
> +                       return(return_value);
> +
> +               /* Copy parameters to user space */
> +               if(copy_to_user((da9052_gpio_read_write_t *)arg,
> +                       &read_write_params, sizeof(da9052_gpio_read_write_t)))
> +                       return (COPY_TO_USER_FAILED);
> +               break;
> +       case DA9052_GPIO_IOCTL_WRITE_PORT:
> +               DA9052_DEBUG("%s():DA9052_GPIO_IOCTL_WRITE_PORT \
> +               called\n", __FUNCTION__);
> +               /* Copy parameters from user space */
> +               if (copy_from_user(&read_write_params,
> +               (da9052_gpio_read_write_t *) arg,
> +               sizeof(da9052_gpio_read_write_t)))
> +                       return (COPY_FROM_USER_FAILED);
> +               /* In Parameter - da9052_gpio_read_write_t* */
> +               return_value = da9052_gpio_write_port(&read_write_params);
> +               if (return_value != SUCCESS)
> +                       return (return_value);
> +               break;
> +       case DA9052_GPIO_IOCTL_CONFIGURE_PORT:
> +               DA9052_DEBUG("%s():DA9052_GPIO_IOCTL_CONFIGURE_PORT \
> +               called\n", __FUNCTION__);
> +               /* Copy parameters from user space */
> +               if (copy_from_user( &config_port,
> +               (da9052_gpio_t *) arg, sizeof(da9052_gpio_t)))
> +                       return(COPY_FROM_USER_FAILED);
> +               /* In Parameter - da9052_gpio_t* */
> +               return_value = da9052_gpio_configure_port(&config_port);
> +               if (return_value != SUCCESS)
> +                       return (return_value);
> +                break;
> +       case DA9052_GPIO_IOCTL_READ_ALL_PORTS:
> +               DA9052_DEBUG("%s():DA9052_GPIO_IOCTL_READ_ALL_PORTS \
> +               called\n", __FUNCTION__);
> +               /* In/Out Parameter - da9052_gpio_multiple_read_t* */
> +               return_value = da9052_gpio_multiple_read (&multiple_read);
> +               if (return_value != SUCCESS)
> +                       return (return_value);
> +
> +               /* Copy parameters to user space */
> +               if(copy_to_user((da9052_gpio_multiple_read_t *) arg,
> +               & multiple_read,
> +               sizeof(da9052_gpio_multiple_read_t)))
> +                       return (COPY_TO_USER_FAILED);
> +               break;
> +       case DA9052_GPIO_IOCTL_GET_EVENT:
> +               /* Out Parameter - unsigned char* */
> +               /* Acquire the the Mutex */
> +               mutex_lock(&da9052_gpio_event_lock);
> +               /* Copy event status into the variable */
> +               copy_event = gpio_event;
> +               /* Clear the global variable */
> +               gpio_event =0;
> +               /*Unlock the mutex */
> +               mutex_unlock(&da9052_gpio_event_lock);
> +               DA9052_DEBUG ("Event = %d\n",copy_event);
> +               if(copy_to_user((u16 *)arg, &copy_event, sizeof(u16)))
> +                       return (FAILURE);
> +               break;
> +       case DA9052_GPIO_IOCTL_REGISTER_EVENT:
> +               if (copy_from_user(&input, (u8*) arg, sizeof(input)))
> +                       return (FAILURE);
> +               /* Input Parameter - unsigned char* */
> +               return (da9052_gpio_register_event(input));
> +               break;
> +       case DA9052_GPIO_IOCTL_UNREGISTER_EVENT:
> +               if (copy_from_user(&input, (u8*) arg, sizeof(input)))
> +                       return (FAILURE);
> +               /* Input Parameter - unsigned char* */
> +               return (da9052_gpio_unregister_event(input));
> +               break;
> +       default:
> +               DA9052_DEBUG ("Invalid ioctl command\n");
> +               return (DA9052_GPIO_INVALID_IOCTL);
> +               break;
> +       }
> +       return (SUCCESS);
> +}
> +
> +/**
> + * da9052_gpio_fasync: Register file descriptor asynchronous notification
> + *                     for events
> + *
> + * @param s32 fd               File descriptor
> + * @param strcut file *filp    File structure
> + * @param s32 on               fasync state
> + * @return s32                 Error status 0:SUCCESS, Non Zero: Error
> + */
> +s32 da9052_gpio_fasync(s32 fd, struct file *filp, s32 on)
> +{
> +       s32 ret;
> +       DA9052_DEBUG("__%s__\n", __FUNCTION__);
> +       DA9052_DEBUG ("In %s: %s\n",__FILE__, __FUNCTION__);
> +       ret = fasync_helper(fd, filp, on, &gpio_fasync_queue);
> +       DA9052_DEBUG("Ret from fasync_helper = %d \n", ret);
> +       return (ret);
> +}
> +
> +/**
> + * static struct file_operations da9052_wl_fops -
> + * This structure definition has to be defined here as an exception.
> + * @owner: member description
> + * @open : member description
> + * @release: member description
> + * @ioctl: member description
> + *
> + */
> +static const struct file_operations da9052_gpio_fops = {
> +        .owner          = THIS_MODULE,
> +        .open           = da9052_gpio_open,
> +        .release        = da9052_gpio_release,
> +        .ioctl          = da9052_gpio_ioctl,
> +       .fasync         = da9052_gpio_fasync
> +};
> +
> +/**
> + * da9052_gpio_probe: Called when a device gets attached to driver
> + *
> + * @param *dev   pointer to platform device
> + * @return int   Error Code, zero: no error
> + */
> +static int __devinit da9052_gpio_probe(struct platform_device *dev)
> +{
> +       s32 ret;
> +       da9052_gpio_chip_t *gpio;
> +       /* Register the device */
> +       ret = register_chrdev(major_number, DA9052_GPIO_DEVICE_NAME,
> +                                                       &da9052_gpio_fops);
> +       if (ret < 0) {
> +               printk("DA9052: Unable to get major number.\n");
> +               return (-EFAULT);
> +       } else {
> +               major_number = ret;
> +               printk(KERN_INFO "%s: Major number is: %d.\n",
> +                               DA9052_GPIO_DEVICE_NAME, major_number);
> +
> +               if (da9052_gpio_hw_init()) {
> +                       printk(KERN_INFO"DA9052: Failed to initialize \
> +                                                       DA9052 Device.\n");
> +                       unregister_chrdev(major_number, DA9052_GPIO_DEVICE_NAME);
> +                       return (-EFAULT);
> +               } else {
> +                       gpio = kzalloc(sizeof(da9052_gpio_chip_t), GFP_KERNEL);
> +                       if (gpio == NULL)
> +                               return (-ENOMEM);
> +                       gpio->gp.get                            = da9052_gpio_read;
> +                       gpio->gp.direction_input        = da9052_gpio_ip;
> +                       gpio->gp.direction_output       = da9052_gpio_op;
> +                       gpio->gp.set                            = da9052_gpio_write;
> +
> +                       gpio->gp.base                           = 0;
> +                       gpio->gp.ngpio                          = MAX_PORTNUMBER;
> +                       gpio->gp.can_sleep                      = 1;
> +                       gpio->gp.dev                            = &dev->dev;
> +                       gpio->gp.owner                          = THIS_MODULE;
> +
> +                       return (SUCCESS);
> +               }
> +       }
> +}
> +
> +/**
> + * da9052_gpio_remove: Called when detaching device from driver
> + * @param *dev   pointer to platform device
> + * @return int   Error Code, zero: no error
> + */
> +static int __devexit da9052_gpio_remove(struct platform_device *dev)
> +{
> +       DA9052_DEBUG(KERN_DEBUG "Removing %s \n", DA9052_GPIO_DEVICE_NAME);
> +       return (SUCCESS);
> +}
> +
> +/**
> + * static struct platform_driver da9052_gpio_driver -
> + * This structure definition has to be defined here as an exception.
> + * @probe: Probe function for this device.
> + * @remove: Function to be called when removing this device from platform
> + * @suspend: Function to be called in suspend mode
> + * @resume: Function to be called in resume mode
> + * @driver: Contains glue logic to bind platform device and plarform driver
> + */
> +static struct platform_driver da9052_gpio_driver = {
> +       .probe          = da9052_gpio_probe,
> +       .remove         = __devexit_p(da9052_gpio_remove),
> +       .suspend        = da9052_gpio_suspend,
> +       .resume         = da9052_gpio_resume,
> +       .driver         = {
> +               .name   = DA9052_GPIO_DEVICE_NAME,
> +               .owner  = THIS_MODULE,
> +       },
> +};
> +
> +/**
> + * da9052_gpio_init: Initiates the driver
> + *
> + * @param void
> + * @return int   Error Code, zero: no error
> + */
> +static int __init da9052_gpio_init(void)
> +{
> +       int retval;
> +       printk(banner);
> +
> +       /* Create a platform device object */
> +       da9052_gpio_platform_device =
> +                       platform_device_alloc(DA9052_GPIO_DEVICE_NAME, 0);
> +       if (!da9052_gpio_platform_device)
> +               return (-ENOMEM);
> +
> +       /* Add platform device to device hierarchy */
> +       retval = platform_device_add(da9052_gpio_platform_device);
> +       if (retval < 0) {
> +               /* Free all memory associated with a platform device */
> +               platform_device_put(da9052_gpio_platform_device);
> +               return (retval);
> +       }
> +
> +       retval = platform_driver_register(&da9052_gpio_driver);
> +       if (retval < 0)
> +               /* Unregister the platform level device */
> +               platform_device_unregister(da9052_gpio_platform_device);
> +       return (retval);
> +}
> +
> +/**
> + * da9052_gpio_exit: Closes the driver
> + *
> + * @param void
> + * @return void
> + */
> +static void __exit da9052_gpio_exit(void)
> +{
> +       printk("DA9052: Unregistering gpio device.\n");
> +
> +       /* De-initializes */
> +       da9052_gpio_hw_exit();
> +
> +       /* Unregister the driver */
> +       unregister_chrdev(major_number, DA9052_GPIO_DEVICE_NAME);
> +
> +       platform_driver_unregister(&da9052_gpio_driver);
> +       /* Unregister the platform level device */
> +       platform_device_unregister(da9052_gpio_platform_device);
> +}
> +
> +module_init(da9052_gpio_init);
> +module_exit(da9052_gpio_exit);
> +
> +MODULE_AUTHOR("Dialog Semiconductor Ltd");
> +MODULE_DESCRIPTION("DA9052 GPIO Device Driver");
> +MODULE_LICENSE("GPL");
> +/*--------------------------------------------------------------------------*/
> +/* Exports                                                                  */
> +/*--------------------------------------------------------------------------*/

Not needed.

> +
> +/* All functions accessible from other drivers */
> +EXPORT_SYMBOL(da9052_gpio_read_port);
> +EXPORT_SYMBOL(da9052_gpio_write_port);
> +EXPORT_SYMBOL(da9052_gpio_configure_port);
> +EXPORT_SYMBOL(da9052_gpio_multiple_read);
> +/* END OF FILE */

Not needed.

> diff -Naur linux-2.6.33.2_bk/drivers/gpio/Makefile linux-2.6.33.2_patch/drivers/gpio/Makefile
> --- linux-2.6.33.2_bk/drivers/gpio/Makefile     2010-04-02 04:02:33.000000000 +0500
> +++ linux-2.6.33.2_patch/drivers/gpio/Makefile  2010-05-18 18:09:37.000000000 +0500
> @@ -22,3 +22,4 @@
>  obj-$(CONFIG_GPIO_BT8XX)       += bt8xxgpio.o
>  obj-$(CONFIG_GPIO_VR41XX)      += vr41xx_giu.o
>  obj-$(CONFIG_GPIO_WM831X)      += wm831x-gpio.o
> +obj-$(CONFIG_DA9052_GPIO_ENABLE)       += da9052_gpio.o
> diff -Naur linux-2.6.33.2_bk/drivers/mfd/Kconfig linux-2.6.33.2_patch/drivers/mfd/Kconfig
> --- linux-2.6.33.2_bk/drivers/mfd/Kconfig       2010-05-18 17:54:30.000000000 +0500
> +++ linux-2.6.33.2_patch/drivers/mfd/Kconfig    2010-05-18 18:09:37.000000000 +0500
> @@ -377,6 +377,13 @@
>        help
>          Say Y  to enable the ADC driver for the DA9052 chip
>
> +config DA9052_GPIO_ENABLE
> +       bool "Dialog Semiconductor DA9052 GPIO Driver"
> +       depends on MFD_DA9052
> +       select GPIOLIB
> +       help
> +         Say Y  to enable the GPIO driver for the DA9052 chip
> +
>  endmenu
>
>  menu "Multimedia Capabilities Port drivers"
> diff -Naur linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_gpio.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_gpio.h
> --- linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_gpio.h    1970-01-01 05:00:00.000000000 +0500
> +++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_gpio.h 2010-05-18 18:09:37.000000000 +0500
> @@ -0,0 +1,529 @@
> +/*
> + * Copyright(c) 2009 Dialog Semiconductor Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * da9052_gpio.h: GPIO driver file for DA9052
> + *
> + * History:
> + *
> + * (05/05/2009)                Unit tested Code
> + *
> + * (27/04/2010):       Updated for Linux Community release
> + *
> + * Best Viewed with TabSize=8 and ColumnWidth=80
> + */
> +
> +
> +#ifndef _DA9052_GPIO_H
> +#define _DA9052_GPIO_H
> +
> +/*--------------------------------------------------------------------------*/
> +/* System wide include files                                                */
> +/*--------------------------------------------------------------------------*/
> +#include <linux/gpio.h>
> +/*--------------------------------------------------------------------------*/
> +/* Module specific include files                                            */
> +/*--------------------------------------------------------------------------*/
> +
> +/*--------------------------------------------------------------------------*/
> +/* Type Definitions                                                         */
> +/*--------------------------------------------------------------------------*/
> +
> +/*--------------------------------------------------------------------------*/
> +/* Constant Definitions                                                     */
> +/*--------------------------------------------------------------------------*/
> +
> +/* String for the Identification */
> +#define DA9052_GPIO_DEVICE_NAME                "da9052_gpio"
> +
> +/* Calculate the size of the variable */
> +#define len_array(arr) (sizeof(arr)/sizeof(arr[0]))

Use the kernel's one.

> +
> +/*--------------------------------------------------------------------------*/
> +/* Error Codes */
> +/*--------------------------------------------------------------------------*/
> +/* Failed Copy from User */
> +#define COPY_FROM_USER_FAILED                  (3)
> +
> +/* Failed Copy to User */
> +#define COPY_TO_USER_FAILED                    (4)
> +
> +/* Invalid Ioctl */
> +#define DA9052_GPIO_INVALID_IOCTL              (5)
> +
> +//#define INVALID_SIGNAL_LEVEL                 (6)
> +/* Invalid functionality code for the
> +       corresponding pin */
> +#define DA9052_GPIO_INVALID_FUNCTION           (7)
> +
> +/* Invalid event for the corresponding pin */
> +#define INVALID_EVENT                          (8)
> +
> +/* Event Registration with EH failed */
> +#define EVENT_REGISTRATION_FAILED              (9)
> +
> +/* Event Unregistration with EH failed */
> +#define EVENT_UNREGISTRATION_FAILED            (10)
> +
> +/* Invalid Signal level in case of Input */
> +/* Invalid Voltage source in case of Output */
> +#define INVALID_TYPE                           (11)
> +
> +/* Invalid Debouncing in case of Input */
> +/* Invalid Signal level in case of Output */
> +#define INVALID_MODE                           (12)
> +
> +/* Invalid Port Number */
> +#define INVALID_PORTNUMBER                     (13)
> +
> +/* Corresponding Pin has Already
> +       been registered with EH */
> +#define EVENT_ALREADY_REGISTERED               (14)
> +
> +/* Corresponding Pin has Already
> +       been Unregistered with EH */
> +#define EVENT_UNREGISTERED                     (15)
> +
> +/* --------------------------------------------------------------------------*/
> +/* IOCTL calls that are permitted to the /dev/gpio interface, if */
> +/* any of the drivers are enabled. */
> +/*--------------------------------------------------------------------------*/
> +/* Read GPIO port */
> +#define DA9052_GPIO_IOCTL_READ_PORT            (1)
> +
> +/* Write GPIO port */
> +#define DA9052_GPIO_IOCTL_WRITE_PORT           (2)
> +
> +/* Configure GPIO port */
> +#define DA9052_GPIO_IOCTL_CONFIGURE_PORT       (3)
> +
> +/* Read multiple GPIO ports */
> +#define DA9052_GPIO_IOCTL_READ_ALL_PORTS       (4)
> +
> +/* Get last event occured */
> +#define DA9052_GPIO_IOCTL_GET_EVENT            (5)
> +
> +/* Register for an event */
> +#define DA9052_GPIO_IOCTL_REGISTER_EVENT       (6)
> +
> +/* Unregister for an event */
> +#define DA9052_GPIO_IOCTL_UNREGISTER_EVENT     (7)
> +
> +
> +/*--------------------------------------------------------------------------*/
> +/* Defines for Various Pin Configurations of the Gpio pins */
> +/*--------------------------------------------------------------------------*/
> +/* ADC pin Configuration */
> +#define DA9052_GPIO_CONFIG_ADC                 (1)
> +
> +/* TSI pin Configuration */
> +#define DA9052_GPIO_CONFIG_TSI                 (2)
> +
> +/* Power Manager pin Configuration */
> +#define DA9052_GPIO_CONFIG_PM                  (3)
> +
> +/* USB ID detect pin Configuration */
> +#define DA9052_GPIO_CONFIG_ACC_ID_DET          (4)
> +
> +/* General Purpose FB1 Configuration */
> +#define DA9052_GPIO_CONFIG_GP_FB1              (5)
> +
> +/* VDD fault Configuration */
> +#define DA9052_GPIO_CONFIG_VDD_FAULT           (6)
> +
> +/* I2C Pin configuration */
> +#define DA9052_GPIO_CONFIG_I2C                 (7)
> +
> +/* Input/Output Pin Configuration */
> +#define DA9052_GPIO_CONFIG                     (8)
> +
> +/*--------------------------------------------------------------------------*/
> +/* Currently used defines for GPIO PINs  */
> +/*--------------------------------------------------------------------------*/
> +
> +/* ADC pin Configuration */
> +#define DA9052_GPIO_PIN_0      DA9052_GPIO_CONFIG_ADC
> +#define DA9052_GPIO_PIN_1      DA9052_GPIO_CONFIG_ADC
> +#define DA9052_GPIO_PIN_2      DA9052_GPIO_CONFIG_ADC
> +
> +/* TSI pin Configuration */
> +#define DA9052_GPIO_PIN_3      DA9052_GPIO_CONFIG_TSI
> +#define DA9052_GPIO_PIN_4      DA9052_GPIO_CONFIG_TSI
> +#define DA9052_GPIO_PIN_5      DA9052_GPIO_CONFIG_TSI
> +#define DA9052_GPIO_PIN_6      DA9052_GPIO_CONFIG_TSI
> +#define DA9052_GPIO_PIN_7      DA9052_GPIO_CONFIG_TSI
> +
> +/* Input Pin Configuration */
> +#define DA9052_GPIO_PIN_8      DA9052_GPIO_CONFIG
> +#define DA9052_GPIO_PIN_9      DA9052_GPIO_CONFIG
> +#define DA9052_GPIO_PIN_10     DA9052_GPIO_CONFIG
> +#define DA9052_GPIO_PIN_11     DA9052_GPIO_CONFIG
> +
> +/* Output Pin Configuration */
> +#define DA9052_GPIO_PIN_12     DA9052_GPIO_CONFIG
> +#define DA9052_GPIO_PIN_13     DA9052_GPIO_CONFIG
> +
> +/* Configuring for High Speed I2C */
> +#define DA9052_GPIO_PIN_14     DA9052_GPIO_CONFIG_I2C
> +#define DA9052_GPIO_PIN_15     DA9052_GPIO_CONFIG_I2C
> +
> +/*--------------------------------------------------------------------------*/
> +/* To enable debug output, set this to 1 */
> +/*--------------------------------------------------------------------------*/
> +#define        DA9052_GPIO_DEBUG                       (0)
> +
> +#undef DA9052_DEBUG
> +#if DA9052_GPIO_DEBUG
> +#define DA9052_DEBUG( fmt, args... ) printk( KERN_CRIT "" fmt, ##args )
> +#else
> +#define DA9052_DEBUG( fmt, args... )
> +#endif
> +
> +/**
> + * enum ip_op_type - GPIO pin functionality
> + * @ALTERNATE_FUNCTIONALITY: configured as alternate functionality
> + * @INPUT: configured as GPI
> + * @OUTPUT_OPENDRAIN: configured as GPO open-drain
> + * @OUTPUT_PUSHPULL: configured as GPO push-pull
> + *
> + */
> +enum ip_op_type {
> +       ALTERNATE_FUNCTIONALITY = 0,
> +       INPUT,
> +       OUTPUT_OPENDRAIN,
> +       OUTPUT_PUSHPULL
> +};
> +
> +
> +/**
> + * enum ip_type - GPI type
> + * @ACTIVE_LOW: active low
> + * @ACTIVE_HIGH: active high
> + *
> + */
> +enum ip_type {
> +       ACTIVE_LOW = 0,
> +       ACTIVE_HIGH
> +};
> +
> +/**
> + * enum op_type - GPO type
> + * @SUPPLY_VDD_IO1: supplied from VDDIO1/ internal pull-up
> + * @SUPPLY_VDD_IO2: supplied from VDDIO2/ external pull-up
> + *
> + */
> +enum op_type {
> +       SUPPLY_VDD_IO1 = 0,
> +       SUPPLY_VDD_IO2
> +};
> +
> +/**
> + * enum op_mode - GPO mode
> + * @OUTPUT_LOWLEVEL: low
> + * @OUTPUT_HIGHLEVEL: high
> + *
> + */
> +enum op_mode {
> +       OUTPUT_LOWLEVEL = 0,
> +       OUTPUT_HIGHLEVEL
> +};
> +
> +/**
> + * enum ip_mode - GPI mode
> + * @DEBOUNCING_OFF: debouncing off
> + * @DEBOUNCING_ON: debouncing on
> + *
> + */
> +enum ip_mode {
> +       DEBOUNCING_OFF = 0,
> +       DEBOUNCING_ON
> +};
> +
> +/**
> + * enum da9052_gpi_event_type - GPI event types
> + * @GPI_0_EVENT: Event for GPI port 0
> + * @GPI_1_EVENT: Event for GPI port 1
> + * ...
> + * @GPI_15_EVENT: Event for GPI port 15
> + *
> + */
> +enum da9052_gpi_event_type {
> +       GPI_0_EVENT = (1<<0),
> +       GPI_1_EVENT = (1<<1),
> +       GPI_2_EVENT = (1<<2),
> +       GPI_3_EVENT = (1<<3),
> +       GPI_4_EVENT = (1<<4),
> +       GPI_5_EVENT = (1<<5),
> +       GPI_6_EVENT = (1<<6),
> +       GPI_7_EVENT = (1<<7),
> +       GPI_8_EVENT = (1<<8),
> +       GPI_9_EVENT = (1<<9),
> +       GPI_10_EVENT = (1<<10),
> +       GPI_11_EVENT = (1<<11),
> +       GPI_12_EVENT = (1<<12),
> +       GPI_13_EVENT = (1<<13),
> +       GPI_14_EVENT = (1<<14),
> +       GPI_15_EVENT = (1<<15),
> +};
> +
> +
> +
> +/*--------------------------------------------------------------------------*/
> +/* Default used defines for GPIO PINs  */
> +/*--------------------------------------------------------------------------*/
> +
> +/*DEFAULT CONFIG FOR GPIO 0*/
> +
> +#if (DA9052_GPIO_PIN_0 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO0_FUNCTION INPUT
> +#define DEFAULT_GPIO0_TYPE     ACTIVE_LOW
> +#define DEFAULT_GPIO0_MODE     DEBOUNCING_ON
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 1*/
> +#if (DA9052_GPIO_PIN_1 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO1_FUNCTION INPUT
> +#define DEFAULT_GPIO1_TYPE     ACTIVE_LOW
> +#define DEFAULT_GPIO1_MODE     DEBOUNCING_ON
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 2*/
> +#if (DA9052_GPIO_PIN_2 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO2_FUNCTION INPUT
> +#define DEFAULT_GPIO2_TYPE     ACTIVE_LOW
> +#define DEFAULT_GPIO2_MODE     DEBOUNCING_ON
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 3*/
> +#if (DA9052_GPIO_PIN_3 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO3_FUNCTION INPUT
> +#define DEFAULT_GPIO3_TYPE     ACTIVE_LOW
> +#define DEFAULT_GPIO3_MODE     DEBOUNCING_ON
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 4*/
> +#if (DA9052_GPIO_PIN_4 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO4_FUNCTION OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO4_TYPE     SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO4_MODE     OUTPUT_LOWLEVEL
> +#endif
> +/*DEFAULT CONFIG FOR GPIO 5*/
> +#if (DA9052_GPIO_PIN_5 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO5_FUNCTION OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO5_TYPE     SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO5_MODE     OUTPUT_LOWLEVEL
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 6*/
> +#if (DA9052_GPIO_PIN_6 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO6_FUNCTION OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO6_TYPE     SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO6_MODE     OUTPUT_LOWLEVEL
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 7*/
> +#if (DA9052_GPIO_PIN_7 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO7_FUNCTION OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO7_TYPE     SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO7_MODE     OUTPUT_LOWLEVEL
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 8*/
> +#if (DA9052_GPIO_PIN_8 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO8_FUNCTION INPUT
> +#define DEFAULT_GPIO8_TYPE     ACTIVE_LOW
> +#define DEFAULT_GPIO8_MODE     DEBOUNCING_ON
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 9*/
> +#if (DA9052_GPIO_PIN_9 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO9_FUNCTION INPUT
> +#define DEFAULT_GPIO9_TYPE     ACTIVE_LOW
> +#define DEFAULT_GPIO9_MODE     DEBOUNCING_ON
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 10 - for RTC blinking LED */
> +#if (DA9052_GPIO_PIN_10 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO10_FUNCTION        OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO10_TYPE    SUPPLY_VDD_IO2
> +#define DEFAULT_GPIO10_MODE    OUTPUT_HIGHLEVEL
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 11 - for RTC blinking LED */
> +#if (DA9052_GPIO_PIN_11 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO11_FUNCTION        OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO11_TYPE    SUPPLY_VDD_IO2
> +#define DEFAULT_GPIO11_MODE    OUTPUT_HIGHLEVEL
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 12*/
> +#if (DA9052_GPIO_PIN_12 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO12_FUNCTION        OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO12_TYPE    SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO12_MODE    OUTPUT_LOWLEVEL
> +#endif
> +/*DEFAULT CONFIG FOR GPIO 13*/
> +#if (DA9052_GPIO_PIN_13 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO13_FUNCTION        OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO13_TYPE    SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO13_MODE    OUTPUT_LOWLEVEL
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 14 - for LED4 */
> +#if (DA9052_GPIO_PIN_14 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO14_FUNCTION        OUTPUT_OPENDRAIN
> +#define DEFAULT_GPIO14_TYPE    SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO14_MODE    OUTPUT_HIGHLEVEL
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 15 - for LED5 */
> +#if (DA9052_GPIO_PIN_15 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO15_FUNCTION        OUTPUT_OPENDRAIN
> +#define DEFAULT_GPIO15_TYPE    SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO15_MODE    OUTPUT_HIGHLEVEL
> +#endif
> +
> +
> +/* Maximum number of Gpio Ports */
> +#define MAX_PORTNUMBER                         (16)
> +
> +/* Maximum number of ports per register */
> +#define MAX_PORTS_PER_REGISTER                 (8)
> +
> +/* No of shift operations to performed */
> +#define SHIFT_COUNT(no)                                ((no)%8)
> +
> +/* Mask of even numbered port */
> +#define EVEN_PORT_FUNCTIONALITY                (0x03)
> +
> +/* Mask of odd numbered port */
> +#define ODD_PORT_FUNCTIONALITY                         (0x30)
> +
> +/* Mask Upper nibble */
> +#define MASK_UPPER_NIBBLE                      (0xF0)
> +
> +/* Mask Lower nibble */
> +#define MASK_LOWER_NIBBLE                      (0x0F)
> +
> +/* Nibble Shift */
> +#define NIBBLE_SHIFT                           (4)
> +
> +/* Mode setting for Even Port number Write */
> +#define EVEN_PORT_WRITE_MODE                   (1 << 3)
> +
> +/* Mode setting for ODD Port number Write */
> +#define ODD_PORT_WRITE_MODE                    (1 << 7)
> +/*--------------------------------------------------------------------------*/
> +/* Global Variables                                                         */
> +/*--------------------------------------------------------------------------*/
> +
> +
> +/*--------------------------------------------------------------------------*/
> +/* Structure Definitions                                                    */
> +/*--------------------------------------------------------------------------*/
> +
> +/**
> + * struct da9052_gpio_read_write_t - Contains the i/p or o/p value for a GPIO
> + * @port_number: gpio ports
> + * @read_write_value: gpio value
> + *
> + */
> +typedef struct {
> +       u8 port_number:4;
> +       u8 read_write_value:1;
> +} da9052_gpio_read_write_t;
> +
> +/**
> + * struct da9052_gpio_multiple_read_t - Contains the signal level at each port
> + * @port_number: all gpio ports
> + *
> + */
> +typedef struct {
> +       u8 signal_value[16];
> +} da9052_gpio_multiple_read_t;
> +
> +
> +/**
> + * struct da9052_gpi_config_t - GPI configuration
> + * @type: GPI Type
> + * @mode: GPI mode
> + *
> + */
> +typedef struct {
> +       enum ip_type type;
> +       enum ip_mode mode;
> +} da9052_gpi_config_t;
> +
> +/**
> + * struct da9052_gpo_config_t - GPO configuration
> + * @type: GPO Type
> + * @mode: GPO mode
> + *
> + */
> +typedef struct {
> +       enum op_type type;
> +       enum op_mode mode;
> +} da9052_gpo_config_t;
> +
> +/**
> + * union da9052_gpio_config_t - GPIO configuration either input or output
> + * @input: GPI configuration
> + * @output: GPO configuration
> + *
> + */
> +typedef union {
> +       da9052_gpi_config_t input;
> +       da9052_gpo_config_t output;
> +} da9052_gpio_config_t;
> +
> +/**
> + * struct da9052_gpio_t - GPIO information
> + * @gpio_config: GPIO configuration either input or output
> + * @gpio_function: GPIO function
> + * @port_number: GPIO port number
> + *
> + */
> +typedef struct {
> +       da9052_gpio_config_t gpio_config;
> +       enum ip_op_type gpio_function;
> +       u8 port_number:4;
> +} da9052_gpio_t;
> +
> +/**
> + * struct da9052_gpio_chip_t - GPIO information
> + * @gpio: GPIO Information
> + * @gp: GPIO Chip Information
> + */
> +typedef struct {
> +       da9052_gpio_t gpio;
> +       da9052_gpio_read_write_t read_write;

Missing comment?

> +       struct gpio_chip gp;
> +} da9052_gpio_chip_t;
> +
> +/*--------------------------------------------------------------------------*/
> +/* Global Variables                                                         */
> +/*--------------------------------------------------------------------------*/
> +
> +/*--------------------------------------------------------------------------*/
> +/* Inline Functions                                                         */
> +/*--------------------------------------------------------------------------*/
> +
> +/*--------------------------------------------------------------------------*/
> +/* External Functions                                                       */
> +/*--------------------------------------------------------------------------*/
> +
> +/*--------------------------------------------------------------------------*/
> +/* Other Functions                                                          */
> +/*--------------------------------------------------------------------------*/
> +s32 da9052_gpio_read_port(da9052_gpio_read_write_t *read_port);
> +s32 da9052_gpio_multiple_read(da9052_gpio_multiple_read_t *multiple_port);
> +s32 da9052_gpio_write_port(da9052_gpio_read_write_t *write_port);
> +s32 da9052_gpio_configure_port(da9052_gpio_t *gpio_data);
> +s32 da9052_gpio_register_event(u8 event_type);
> +s32 da9052_gpio_unregister_event(u8 event_type);

Maybe a couple of these could be static.

> +
> +#endif /* _DA9052_GPIO_H */
> Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information,
> some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
> is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure,
> copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
