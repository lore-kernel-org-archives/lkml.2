Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab0GTKm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 06:42:56 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:59508 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab0GTKmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 06:42:55 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C457D65.2050000@cam.ac.uk>
Date: Tue, 20 Jul 2010 11:41:41 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100709 Thunderbird/3.1
MIME-Version: 1.0
To: dd diasemi <dd.diasemi@gmail.com>
CC: linux-kernel@vger.kernel.org, jic23@cam.ac.uk
Subject: Re: [PATCHv3 2/11] GPIO: GPIO Driver for DA9052 PMIC
References: <AANLkTimaml4sINBBSJUS7hu5sgkGZP0ZR4ugpdgN5iH7@mail.gmail.com>
In-Reply-To: <AANLkTimaml4sINBBSJUS7hu5sgkGZP0ZR4ugpdgN5iH7@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/10 11:14, dd diasemi wrote:
> GPIO module of the device driver for DA9052 PMIC device from Dialog
> Semiconductor.
> 
> Changes made since last submission:
> . code has been reorganised as per the standard linux kernel driver framework
> . removal of redundant printk and comments
> . removal of test framework
> 
Mostly fine, but all of the configuration that is currently
done via macros in the header needs to be converted to
platform data.
> Linux Kernel Version: 2.6.34
> 
> Signed-off-by: D. Chen <dchen@diasemi.com>
> ---
> diff -urpN linux-2.6.34/drivers/gpio/da9052_gpio.c
> linux-2.6.34_test/drivers/gpio/da9052_gpio.c
> --- linux-2.6.34/drivers/gpio/da9052_gpio.c	1970-01-01 05:00:00.000000000 +0500
> +++ linux-2.6.34_test/drivers/gpio/da9052_gpio.c	2010-07-14
> 18:59:46.000000000 +0500
> @@ -0,0 +1,664 @@
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <linux/uaccess.h>
> +#include <linux/platform_device.h>
> +#include <linux/syscalls.h>
> +#include <linux/seq_file.h>
> +#include <linux/gpio.h>
> +
> +#include <linux/mfd/da9052/da9052.h>
> +#include <linux/mfd/da9052/reg.h>
> +#include <linux/mfd/da9052/gpio.h>
> +
> +#define DRIVER_NAME "da9052_gpio"
> +static inline struct da9052_gpio_chip *to_da9052_gpio(struct gpio_chip *chip)
> +{
> +	return container_of(chip, struct da9052_gpio_chip, gp);
> +}
> +
> +static u8 create_gpio_config_value(u8 gpio_function, u8 gpio_type, u8
> gpio_mode)
> +{
> +	/* The format is -
> +		function - 2 bits
> +		type - 1 bit
> +		mode - 1 bit */
> +	return gpio_function | (gpio_type << 2) | (gpio_mode << 3);
> +}
> +
> +static s32 write_default_gpio_values(struct da9052 *da9052)
> +{
> +	struct da9052_ssc_msg msg;
> +	u8 created_val = 0;
> +	da9052_lock(da9052);
> +
This whole set of macros should not be here.  This restricts
your driver to use in only one board.  Platform data is the
right way to handle this sort of thing.  
> +#if (DA9052_GPIO_PIN_0 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO0001_REG;
> +	msg.data = 0;
> +
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO0_FUNCTION,
> +			DEFAULT_GPIO0_TYPE, DEFAULT_GPIO0_MODE);
> +	msg.data &= DA9052_GPIO_MASK_UPPER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +#endif
> +#if (DA9052_GPIO_PIN_1 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO0001_REG;
> +	msg.data = 0;
> +
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO1_FUNCTION,
> +			DEFAULT_GPIO1_TYPE, DEFAULT_GPIO1_MODE);
> +	created_val = created_val << DA9052_GPIO_NIBBLE_SHIFT;
> +	msg.data &= DA9052_GPIO_MASK_LOWER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +#endif
> +/* GPIO 2-3*/
> +#if (DA9052_GPIO_PIN_2 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO0203_REG;
> +	msg.data = 0;
> +
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO2_FUNCTION,
> +			DEFAULT_GPIO2_TYPE, DEFAULT_GPIO2_MODE);
> +	msg.data &= DA9052_GPIO_MASK_UPPER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +#endif
> +#if (DA9052_GPIO_PIN_3 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO0203_REG;
> +	msg.data = 0;
> +
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO3_FUNCTION,
> +			DEFAULT_GPIO3_TYPE, DEFAULT_GPIO3_MODE);
> +	created_val = created_val << DA9052_GPIO_NIBBLE_SHIFT;
> +	msg.data &= DA9052_GPIO_MASK_LOWER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +#endif
> +/* GPIO 4-5*/
> +#if (DA9052_GPIO_PIN_4 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO0405_REG;
> +	msg.data = 0;
> +
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO4_FUNCTION,
> +			DEFAULT_GPIO4_TYPE, DEFAULT_GPIO4_MODE);
> +	msg.data &= DA9052_GPIO_MASK_UPPER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +#endif
> +#if (DA9052_GPIO_PIN_5 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO0405_REG;
> +	msg.data = 0;
> +
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO5_FUNCTION,
> +			DEFAULT_GPIO5_TYPE, DEFAULT_GPIO5_MODE);
> +	created_val = created_val << DA9052_GPIO_NIBBLE_SHIFT;
> +	msg.data &= DA9052_GPIO_MASK_LOWER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +#endif
> +/* GPIO 6-7*/
> +#if (DA9052_GPIO_PIN_6 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO0607_REG;
> +	msg.data = 0;
> +
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO6_FUNCTION,
> +			DEFAULT_GPIO6_TYPE, DEFAULT_GPIO6_MODE);
> +	msg.data &= DA9052_GPIO_MASK_UPPER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +#endif
> +#if (DA9052_GPIO_PIN_7 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO0607_REG;
> +	msg.data = 0;
> +
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO7_FUNCTION,
> +			DEFAULT_GPIO7_TYPE, DEFAULT_GPIO7_MODE);
> +	created_val = created_val << DA9052_GPIO_NIBBLE_SHIFT;
> +	msg.data &= DA9052_GPIO_MASK_LOWER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +#endif
> +/* GPIO 8-9*/
> +#if (DA9052_GPIO_PIN_8 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO0809_REG;
> +	msg.data = 0;
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO8_FUNCTION,
> +			DEFAULT_GPIO8_TYPE, DEFAULT_GPIO8_MODE);
> +	msg.data &= DA9052_GPIO_MASK_UPPER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +#endif
> +#if (DA9052_GPIO_PIN_9 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO0809_REG;
> +	msg.data = 0;
> +
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO9_FUNCTION,
> +			DEFAULT_GPIO9_TYPE, DEFAULT_GPIO9_MODE);
> +	created_val = created_val << DA9052_GPIO_NIBBLE_SHIFT;
> +	msg.data &= DA9052_GPIO_MASK_LOWER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +#endif
> +/* GPIO 10-11*/
> +#if (DA9052_GPIO_PIN_10 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO1011_REG;
> +	msg.data = 0;
> +
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO10_FUNCTION,
> +			DEFAULT_GPIO10_TYPE, DEFAULT_GPIO10_MODE);
> +	msg.data &= DA9052_GPIO_MASK_UPPER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +#endif
> +#if (DA9052_GPIO_PIN_11 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO1011_REG;
> +	msg.data = 0;
> +
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO11_FUNCTION,
> +			DEFAULT_GPIO11_TYPE, DEFAULT_GPIO11_MODE);
> +	created_val = created_val << DA9052_GPIO_NIBBLE_SHIFT;
> +	msg.data &= DA9052_GPIO_MASK_LOWER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +#endif
> +/* GPIO 12-13*/
> +#if (DA9052_GPIO_PIN_12 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO1213_REG;
> +	msg.data = 0;
> +
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO12_FUNCTION,
> +			DEFAULT_GPIO12_TYPE, DEFAULT_GPIO12_MODE);
> +	msg.data &= DA9052_GPIO_MASK_UPPER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +#endif
> +#if (DA9052_GPIO_PIN_13 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO1213_REG;
> +	msg.data = 0;
> +
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO13_FUNCTION,
> +			DEFAULT_GPIO13_TYPE, DEFAULT_GPIO13_MODE);
> +	created_val = created_val << DA9052_GPIO_NIBBLE_SHIFT;
> +	msg.data &= DA9052_GPIO_MASK_LOWER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +#endif
> +/* GPIO 14-15*/
> +#if (DA9052_GPIO_PIN_14 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO1415_REG;
> +	msg.data = 0;
> +
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO14_FUNCTION,
> +			DEFAULT_GPIO14_TYPE, DEFAULT_GPIO14_MODE);
> +	msg.data &= DA9052_GPIO_MASK_UPPER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +#endif
> +#if (DA9052_GPIO_PIN_15 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO1415_REG;
> +	msg.data = 0;
> +
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +
> +	created_val = create_gpio_config_value(DEFAULT_GPIO15_FUNCTION,
> +			DEFAULT_GPIO15_TYPE, DEFAULT_GPIO15_MODE);
> +	created_val = created_val << DA9052_GPIO_NIBBLE_SHIFT;
> +	msg.data &= DA9052_GPIO_MASK_LOWER_NIBBLE;
> +	msg.data |= created_val;
> +
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +#endif
> +	da9052_unlock(da9052);
> +	return 0;
> +}
> +
> +s32 da9052_gpio_read_port(struct da9052_gpio_read_write *read_port,
> +				struct da9052 *da9052)
> +{
> +	struct da9052_ssc_msg msg;
> +	u8 shift_value = 0;
> +	u8 port_functionality = 0;
> +
> +	msg.addr = (read_port->port_number / 2) + DA9052_GPIO0001_REG;
> +	msg.data = 0;
> +	da9052_lock(da9052);
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +	da9052_unlock(da9052);
> +	port_functionality =
> +			(read_port->port_number % 2) ?
> +			((msg.data & DA9052_GPIO_ODD_PORT_FUNCTIONALITY) >>
> +					DA9052_GPIO_NIBBLE_SHIFT) :
> +			(msg.data & DA9052_GPIO_EVEN_PORT_FUNCTIONALITY);
> +
> +	if (port_functionality != INPUT)
> +		return DA9052_GPIO_INVALID_PORTNUMBER;
> +
> +	if (read_port->port_number >= (DA9052_GPIO_MAX_PORTNUMBER))
> +		return DA9052_GPIO_INVALID_PORTNUMBER;
> +
> +	if (read_port->port_number < DA9052_GPIO_MAX_PORTS_PER_REGISTER)
> +		msg.addr = DA9052_STATUSC_REG;
> +	else
> +		msg.addr = DA9052_STATUSD_REG;
> +	msg.data = 0;
> +
> +	da9052_lock(da9052);
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +	da9052_unlock(da9052);
> +
> +	shift_value = msg.data &
> +		(1 << DA9052_GPIO_SHIFT_COUNT(read_port->port_number));
> +	read_port->read_write_value = (shift_value >>
> +			DA9052_GPIO_SHIFT_COUNT(read_port->port_number));
> +
> +	return 0;
> +}
> +
> +s32 da9052_gpio_multiple_read(struct da9052_gpio_multiple_read *multiple_port,
> +				struct da9052 *da9052)
> +{
> +	struct da9052_ssc_msg msg[2];
> +	u8 port_number = 0;
> +	u8 loop_index = 0;
> +	msg[loop_index++].addr = DA9052_STATUSC_REG;
> +	msg[loop_index++].addr = DA9052_STATUSD_REG;
> +
> +	da9052_lock(da9052);
> +	if (da9052_ssc_read_many(da9052, msg, loop_index)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +	da9052_unlock(da9052);
> +	loop_index = 0;
> +	for (port_number = 0; port_number < DA9052_GPIO_MAX_PORTS_PER_REGISTER;
> +							port_number++) {
> +		multiple_port->signal_value[port_number] =
> +			msg[loop_index].data & 1;
> +		msg[loop_index].data = msg[loop_index].data >> 1;
> +	}
> +	loop_index++;
> +	for (port_number = DA9052_GPIO_MAX_PORTS_PER_REGISTER;
> +		port_number < DA9052_GPIO_MAX_PORTNUMBER; port_number++) {
> +		multiple_port->signal_value[port_number] =
> +			msg[loop_index].data & 1;
> +		msg[loop_index].data = msg[loop_index].data >> 1;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(da9052_gpio_multiple_read);
> +
> +s32 da9052_gpio_write_port(struct da9052_gpio_read_write *write_port,
> +				struct da9052 *da9052)
> +{
> +	struct da9052_ssc_msg msg;
> +	u8 port_functionality  = 0;
> +	u8 bit_pos = 0;
> +	msg.addr = DA9052_GPIO0001_REG + (write_port->port_number / 2);
> +	msg.data = 0;
> +
> +	da9052_lock(da9052);
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +	da9052_unlock(da9052);
> +
> +	port_functionality =
> +			(write_port->port_number % 2) ?
> +			((msg.data & DA9052_GPIO_ODD_PORT_FUNCTIONALITY) >>
> +						DA9052_GPIO_NIBBLE_SHIFT) :
> +			(msg.data & DA9052_GPIO_EVEN_PORT_FUNCTIONALITY);
> +
> +	if (port_functionality < 2)
> +		return DA9052_GPIO_INVALID_PORTNUMBER;
> +
> +	bit_pos = (write_port->port_number % 2) ?
> +			DA9052_GPIO_ODD_PORT_WRITE_MODE :
> +				DA9052_GPIO_EVEN_PORT_WRITE_MODE;
> +
> +	if (write_port->read_write_value)
> +		msg.data = msg.data | bit_pos;
> +	else
> +		msg.data = (msg.data & ~(bit_pos));
> +
> +	da9052_lock(da9052);
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +	da9052_unlock(da9052);
> +	return 0;
> +}
> +
> +s32 da9052_gpio_configure_port(struct da9052_gpio *gpio_data,
> +				struct da9052 *da9052)
> +{
> +	struct da9052_ssc_msg msg;
> +	u8 register_value = 0;
> +	u8 function = 0;
> +	u8 port_functionality = 0;
> +	msg.addr = (gpio_data->port_number / 2) + DA9052_GPIO0001_REG;
> +	msg.data = 0;
> +
> +	da9052_lock(da9052);
> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +	da9052_unlock(da9052);
> +
> +	port_functionality =
> +			(gpio_data->port_number % 2) ?
> +			((msg.data & DA9052_GPIO_ODD_PORT_FUNCTIONALITY) >>
> +					DA9052_GPIO_NIBBLE_SHIFT) :
> +			(msg.data & DA9052_GPIO_EVEN_PORT_FUNCTIONALITY);
> +	if (port_functionality < INPUT)
> +		return DA9052_GPIO_INVALID_PORTNUMBER;
> +	if (gpio_data->gpio_config.input.type > ACTIVE_HIGH)
> +		return DA9052_GPIO_INVALID_TYPE;
> +	if (gpio_data->gpio_config.input.mode > DEBOUNCING_ON)
> +		return DA9052_GPIO_INVALID_MODE;
> +	function = gpio_data->gpio_function;
> +	switch (function) {
> +	case INPUT:
> +		register_value = create_gpio_config_value(function,
> +					gpio_data->gpio_config.input.type,
> +					gpio_data->gpio_config.input.mode);
> +		break;
> +	case OUTPUT_OPENDRAIN:
> +	case OUTPUT_PUSHPULL:
> +		register_value = create_gpio_config_value(function,
> +					gpio_data->gpio_config.input.type,
> +					gpio_data->gpio_config.input.mode);
> +		break;
> +	default:
> +		return DA9052_GPIO_INVALID_FUNCTION;
> +		break;
> +	}
> +
> +	if (gpio_data->port_number % 2) {
> +		msg.data = (msg.data & ~(DA9052_GPIO_MASK_UPPER_NIBBLE)) |
> +				(register_value << DA9052_GPIO_NIBBLE_SHIFT);
> +	} else {
> +		msg.data = (msg.data & ~(DA9052_GPIO_MASK_LOWER_NIBBLE)) |
> +				register_value;
> +	}
> +	da9052_lock(da9052);
> +	if (da9052->write(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;
> +	}
> +	da9052_unlock(da9052);
> +	return 0;
> +}
> +
> +static s32 da9052_gpio_read(struct gpio_chip *gc, u32 offset)
> +{
> +	struct da9052_gpio_chip *gpio;
> +	gpio = to_da9052_gpio(gc);
> +	gpio->read_write.port_number		= offset;
> +	da9052_gpio_read_port(&gpio->read_write, gpio->da9052);
> +	return gpio->read_write.read_write_value;
> +}
> +
> +static void da9052_gpio_write(struct gpio_chip *gc, u32 offset, s32 value)
> +{
> +	struct da9052_gpio_chip *gpio;
> +	gpio = to_da9052_gpio(gc);
> +	gpio->read_write.port_number		= offset;
> +	gpio->read_write.read_write_value	= (u8)value;
> +	da9052_gpio_write_port(&gpio->read_write, gpio->da9052);
> +}
> +
> +static s32 da9052_gpio_ip(struct gpio_chip *gc, u32 offset)
> +{
> +	struct da9052_gpio_chip *gpio;
> +	gpio = to_da9052_gpio(gc);
> +	gpio->gpio.gpio_function			= INPUT;
> +	gpio->gpio.gpio_config.input.type	= ACTIVE_LOW;
> +	gpio->gpio.gpio_config.input.mode	= DEBOUNCING_ON;
> +	gpio->gpio.port_number				= offset;
> +	return da9052_gpio_configure_port(&gpio->gpio, gpio->da9052);
> +}
> +
> +static s32 da9052_gpio_op(struct gpio_chip *gc, u32 offset, s32 value)
> +{
> +	struct da9052_gpio_chip *gpio;
> +	gpio = to_da9052_gpio(gc);
> +	gpio->gpio.gpio_function		= OUTPUT_PUSHPULL;
> +	gpio->gpio.gpio_config.output.type	= SUPPLY_VDD_IO2;
> +	gpio->gpio.gpio_config.output.mode	= value;
> +	gpio->gpio.port_number			= offset;
> +	return da9052_gpio_configure_port(&gpio->gpio, gpio->da9052);
> +}
> +
> +static int __devinit da9052_gpio_probe(struct platform_device *pdev)
> +{
> +	struct da9052_gpio_chip *gpio;
> +	s32 ret;
> +
> +	gpio = kzalloc(sizeof(*gpio), GFP_KERNEL);
> +	if (gpio == NULL)
> +		return -ENOMEM;
> +
> +	gpio->da9052 = dev_get_drvdata(pdev->dev.parent);
> +	gpio->gp.get			= da9052_gpio_read;
> +	gpio->gp.direction_input	= da9052_gpio_ip;
> +	gpio->gp.direction_output	= da9052_gpio_op;
> +	gpio->gp.set			= da9052_gpio_write;
> +
> +	gpio->gp.base				= -1;
> +	gpio->gp.ngpio				= DA9052_GPIO_MAX_PORTNUMBER;
> +	gpio->gp.can_sleep			= 1;
> +	gpio->gp.dev				= &pdev->dev;
> +	gpio->gp.owner				= THIS_MODULE;
> +	gpio->gp.label				= "da9052-gpio";
> +
> +	ret = write_default_gpio_values(gpio->da9052);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "GPIO initial config failed, %d\n",
> +			ret);
> +		goto ret;
> +	}
> +	ret = gpiochip_add(&gpio->gp);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Could not register gpiochip, %d\n",
> +			ret);
> +		goto ret;
> +	}
> +
> +	platform_set_drvdata(pdev, gpio);
> +
> +	return ret;
> +
> +ret:
> +	kfree(gpio);
> +	return ret;
> +
> +}
> +
> +static int __devexit da9052_gpio_remove(struct platform_device *pdev)
> +{
> +	struct da9052_gpio_chip *gpio = platform_get_drvdata(pdev);
> +	int ret;
> +
> +	ret = gpiochip_remove(&gpio->gp);
> +	if (ret == 0)
> +		kfree(gpio);
> +	return 0;
> +}
> +
> +static struct platform_driver da9052_gpio_driver = {
> +	.probe		= da9052_gpio_probe,
> +	.remove		= __devexit_p(da9052_gpio_remove),
> +	.driver		= {
> +		.name	= DRIVER_NAME,
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int __init da9052_gpio_init(void)
> +{
> +	return platform_driver_register(&da9052_gpio_driver);
> +}
> +
> +static void __exit da9052_gpio_exit(void)
> +{
> +	return platform_driver_unregister(&da9052_gpio_driver);
> +}
> +
> +module_init(da9052_gpio_init);
> +module_exit(da9052_gpio_exit);
> +
> +MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
> +MODULE_DESCRIPTION("DA9052 GPIO Device Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:" DRIVER_NAME);
> diff -urpN linux-2.6.34/drivers/gpio/Kconfig
> linux-2.6.34_test/drivers/gpio/Kconfig
> --- linux-2.6.34/drivers/gpio/Kconfig	2010-05-17 02:17:36.000000000 +0500
> +++ linux-2.6.34_test/drivers/gpio/Kconfig	2010-07-14 18:59:54.000000000 +0500
> @@ -310,4 +310,10 @@ config GPIO_UCB1400
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called ucb1400_gpio.
> 
> +config DA9052_GPIO_ENABLE
> +	bool "Dialog Semiconductor DA9052 GPIO Driver"
> +	depends on PMIC_DA9052
> +	help
> +	  Say Y  to enable the GPIO driver for the DA9052 chip
> +
>  endif
> diff -urpN linux-2.6.34/drivers/gpio/Makefile
> linux-2.6.34_test/drivers/gpio/Makefile
> --- linux-2.6.34/drivers/gpio/Makefile	2010-05-17 02:17:36.000000000 +0500
> +++ linux-2.6.34_test/drivers/gpio/Makefile	2010-07-14 18:59:59.000000000 +0500
> @@ -27,4 +27,5 @@ obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.
>  obj-$(CONFIG_GPIO_WM831X)	+= wm831x-gpio.o
>  obj-$(CONFIG_GPIO_WM8350)	+= wm8350-gpiolib.o
>  obj-$(CONFIG_GPIO_WM8994)	+= wm8994-gpio.o
> -obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
> \ No newline at end of file
> +obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
> +obj-$(CONFIG_DA9052_GPIO_ENABLE)+= da9052_gpio.o
> \ No newline at end of file
> diff -urpN linux-2.6.34/include/linux/mfd/da9052/gpio.h
> linux-2.6.34_test/include/linux/mfd/da9052/gpio.h
> --- linux-2.6.34/include/linux/mfd/da9052/gpio.h	1970-01-01
> 05:00:00.000000000 +0500
> +++ linux-2.6.34_test/include/linux/mfd/da9052/gpio.h	2010-07-14
> 19:00:46.000000000 +0500
> @@ -0,0 +1,240 @@
> +#ifndef _DA9052_GPIO_H
> +#define _DA9052_GPIO_H
> +
> +#include <linux/gpio.h>
> +#define DA9052_GPIO_DEVICE_NAME		"da9052_gpio"
> +
> +#define DA9052_GPIO_INVALID_TYPE		(1)
> +#define DA9052_GPIO_INVALID_MODE		(2)
> +#define DA9052_GPIO_INVALID_PORTNUMBER		(3)
> +#define DA9052_GPIO_INVALID_FUNCTION		(4)
> +
> +#define DA9052_GPIO_CONFIG_ADC			(1)
> +#define DA9052_GPIO_CONFIG_TSI			(2)
> +#define DA9052_GPIO_CONFIG_PM			(3)
> +#define DA9052_GPIO_CONFIG_ACC_ID_DET		(4)
> +#define DA9052_GPIO_CONFIG_GP_FB1		(5)
> +#define DA9052_GPIO_CONFIG_VDD_FAULT		(6)
> +#define DA9052_GPIO_CONFIG_I2C			(7)
> +#define DA9052_GPIO_CONFIG			(8)
> +
> +/*--------------------------------------------------------------------------*/
> +/* Currently used defines for GPIO PINs  */
> +/*--------------------------------------------------------------------------*/
This should all be handled via platform data, not a set of defines
like this that are specific to a particular configuration.
It would probably be preferable to simply not support the other
options in driver rather than having a whole load of code
that never builds protected by macros.

> +#define DA9052_GPIO_PIN_0	DA9052_GPIO_CONFIG_ADC
> +#define DA9052_GPIO_PIN_1	DA9052_GPIO_CONFIG_ADC
> +#define DA9052_GPIO_PIN_2	DA9052_GPIO_CONFIG_ADC
> +
> +#define DA9052_GPIO_PIN_3	DA9052_GPIO_CONFIG_TSI
> +#define DA9052_GPIO_PIN_4	DA9052_GPIO_CONFIG_TSI
> +#define DA9052_GPIO_PIN_5	DA9052_GPIO_CONFIG_TSI
> +#define DA9052_GPIO_PIN_6	DA9052_GPIO_CONFIG_TSI
> +#define DA9052_GPIO_PIN_7	DA9052_GPIO_CONFIG_TSI
> +
> +#define DA9052_GPIO_PIN_8	DA9052_GPIO_CONFIG
> +#define DA9052_GPIO_PIN_9	DA9052_GPIO_CONFIG
> +#define DA9052_GPIO_PIN_10	DA9052_GPIO_CONFIG
> +#define DA9052_GPIO_PIN_11	DA9052_GPIO_CONFIG
> +
> +#define DA9052_GPIO_PIN_12	DA9052_GPIO_CONFIG
> +#define DA9052_GPIO_PIN_13	DA9052_GPIO_CONFIG
> +
> +#define DA9052_GPIO_PIN_14	DA9052_GPIO_CONFIG_I2C
> +#define DA9052_GPIO_PIN_15	DA9052_GPIO_CONFIG_I2C
> +
> +enum ip_op_type {
> +	ALTERNATE_FUNCTIONALITY = 0,
> +	INPUT,
> +	OUTPUT_OPENDRAIN,
> +	OUTPUT_PUSHPULL
> +};
> +
> +enum ip_type {
> +	ACTIVE_LOW = 0,
> +	ACTIVE_HIGH
> +};
> +
> +enum op_type {
> +	SUPPLY_VDD_IO1 = 0,
> +	SUPPLY_VDD_IO2
> +};
> +
> +
> +enum op_mode {
> +	OUTPUT_LOWLEVEL = 0,
> +	OUTPUT_HIGHLEVEL
> +};
> +
> +
> +enum ip_mode {
> +	DEBOUNCING_OFF = 0,
> +	DEBOUNCING_ON
> +};
> +
> +
> +/*--------------------------------------------------------------------------*/
> +/* Default used defines for GPIO PINs  */
> +/*--------------------------------------------------------------------------*/
> +
> +/*DEFAULT CONFIG FOR GPIO 0*/
> +
This is not a valid way of handling options.  Platform data is the right
way to do this sort of thing, or just leave them as chip defaults
then rely on a user deliberately setting these via the gpio subsystem
calls.

> +#if (DA9052_GPIO_PIN_0 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO0_FUNCTION	INPUT
> +#define DEFAULT_GPIO0_TYPE	ACTIVE_LOW
> +#define DEFAULT_GPIO0_MODE	DEBOUNCING_ON
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 1*/
> +#if (DA9052_GPIO_PIN_1 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO1_FUNCTION	INPUT
> +#define DEFAULT_GPIO1_TYPE	ACTIVE_LOW
> +#define DEFAULT_GPIO1_MODE	DEBOUNCING_ON
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 2*/
> +#if (DA9052_GPIO_PIN_2 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO2_FUNCTION	INPUT
> +#define DEFAULT_GPIO2_TYPE	ACTIVE_LOW
> +#define DEFAULT_GPIO2_MODE	DEBOUNCING_ON
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 3*/
> +#if (DA9052_GPIO_PIN_3 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO3_FUNCTION	INPUT
> +#define DEFAULT_GPIO3_TYPE	ACTIVE_LOW
> +#define DEFAULT_GPIO3_MODE	DEBOUNCING_ON
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 4*/
> +#if (DA9052_GPIO_PIN_4 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO4_FUNCTION	OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO4_TYPE	SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO4_MODE	OUTPUT_LOWLEVEL
> +#endif
> +/*DEFAULT CONFIG FOR GPIO 5*/
> +#if (DA9052_GPIO_PIN_5 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO5_FUNCTION	OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO5_TYPE	SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO5_MODE	OUTPUT_LOWLEVEL
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 6*/
> +#if (DA9052_GPIO_PIN_6 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO6_FUNCTION	OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO6_TYPE	SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO6_MODE	OUTPUT_LOWLEVEL
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 7*/
> +#if (DA9052_GPIO_PIN_7 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO7_FUNCTION	OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO7_TYPE	SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO7_MODE	OUTPUT_LOWLEVEL
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 8*/
> +#if (DA9052_GPIO_PIN_8 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO8_FUNCTION	INPUT
> +#define DEFAULT_GPIO8_TYPE	ACTIVE_LOW
> +#define DEFAULT_GPIO8_MODE	DEBOUNCING_ON
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 9*/
> +#if (DA9052_GPIO_PIN_9 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO9_FUNCTION	INPUT
> +#define DEFAULT_GPIO9_TYPE	ACTIVE_LOW
> +#define DEFAULT_GPIO9_MODE	DEBOUNCING_ON
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 10 - for RTC blinking LED */
> +#if (DA9052_GPIO_PIN_10 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO10_FUNCTION	OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO10_TYPE	SUPPLY_VDD_IO2
> +#define DEFAULT_GPIO10_MODE	OUTPUT_HIGHLEVEL
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 11 - for RTC blinking LED */
> +#if (DA9052_GPIO_PIN_11 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO11_FUNCTION	OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO11_TYPE	SUPPLY_VDD_IO2
> +#define DEFAULT_GPIO11_MODE	OUTPUT_HIGHLEVEL
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 12*/
> +#if (DA9052_GPIO_PIN_12 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO12_FUNCTION	OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO12_TYPE	SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO12_MODE	OUTPUT_LOWLEVEL
> +#endif
> +/*DEFAULT CONFIG FOR GPIO 13*/
> +#if (DA9052_GPIO_PIN_13 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO13_FUNCTION	OUTPUT_PUSHPULL
> +#define DEFAULT_GPIO13_TYPE	SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO13_MODE	OUTPUT_LOWLEVEL
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 14 - for LED4 */
> +#if (DA9052_GPIO_PIN_14 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO14_FUNCTION	OUTPUT_OPENDRAIN
> +#define DEFAULT_GPIO14_TYPE	SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO14_MODE	OUTPUT_HIGHLEVEL
> +#endif
> +
> +/*DEFAULT CONFIG FOR GPIO 15 - for LED5 */
> +#if (DA9052_GPIO_PIN_15 == DA9052_GPIO_CONFIG)
> +#define DEFAULT_GPIO15_FUNCTION	OUTPUT_OPENDRAIN
> +#define DEFAULT_GPIO15_TYPE	SUPPLY_VDD_IO1
> +#define DEFAULT_GPIO15_MODE	OUTPUT_HIGHLEVEL
> +#endif
> +
> +
> +#define DA9052_GPIO_MAX_PORTNUMBER		(16)
> +#define DA9052_GPIO_MAX_PORTS_PER_REGISTER	(8)
> +#define DA9052_GPIO_SHIFT_COUNT(no)		((no)%8)
> +#define DA9052_GPIO_EVEN_PORT_FUNCTIONALITY	(0x03)
> +#define DA9052_GPIO_ODD_PORT_FUNCTIONALITY	(0x30)
> +#define DA9052_GPIO_MASK_UPPER_NIBBLE		(0xF0)
> +#define DA9052_GPIO_MASK_LOWER_NIBBLE		(0x0F)
> +#define DA9052_GPIO_NIBBLE_SHIFT		(4)
> +#define DA9052_GPIO_EVEN_PORT_WRITE_MODE	(1 << 3)
> +#define DA9052_GPIO_ODD_PORT_WRITE_MODE		(1 << 7)
> +
> +
> +struct da9052_gpio_read_write {
> +	u8 port_number:4;
> +	u8 read_write_value:1;
> +} ;
> +
> +struct da9052_gpio_multiple_read {
> +	u8 signal_value[16];
> +};
> +
> +struct da9052_gpi_config {
> +	enum ip_type type;
> +	enum ip_mode mode;
> +};
> +
> +struct da9052_gpo_config {
> +	enum op_type type;
> +	enum op_mode mode;
> +} ;
> +
> +union da9052_gpio_config {
> +	struct da9052_gpi_config input;
> +	struct da9052_gpo_config output;
> +};
> +
> +struct da9052_gpio {
> +	union da9052_gpio_config gpio_config;
> +	enum ip_op_type gpio_function;
> +	u8 port_number:4;
> +};
> +
> +struct da9052_gpio_chip {
> +	struct da9052_gpio gpio;
> +	struct da9052_gpio_read_write read_write;
> +	struct da9052 *da9052;
> +	struct gpio_chip gp;
> +};
> +
> +#endif /* _DA9052_GPIO_H */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

