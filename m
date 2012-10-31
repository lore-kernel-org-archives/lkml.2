Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934806Ab2JaOi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:38:57 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49406 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934348Ab2JaOix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:38:53 -0400
Date: Wed, 31 Oct 2012 09:37:42 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Mathias Leblanc <mathias.leblanc@st.com>
Cc: Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Jean-Luc Blanc <jean-luc.blanc@st.com>
Subject: Re: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C
Message-ID: <20121031143741.GA10430@ennui.austin.ibm.com>
References: <1351603730-6676-1-git-send-email-mathias.leblanc@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351603730-6676-1-git-send-email-mathias.leblanc@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103114-7182-0000-0000-000003008678
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathias,

On Tue, Oct 30, 2012 at 02:28:50PM +0100, Mathias Leblanc wrote:
>  * STMicroelectronics version 1.2.0, Copyright (C) 2010
>  * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
>  * This is free software, and you are welcome to redistribute it
>  * under certain conditions.
> 
> This is the driver for TPM chip from ST Microelectronics.
> 
> If you have a TPM security chip from STMicroelectronics working with
> an I2C, in menuconfig or .config choose the tpm driver on
> device --> tpm and activate the protocol of your choice before compiling
> the kernel.
> The driver will be accessible from within Linux.
> 
> Tested on linux x86/x64 and beagleboard REV B & XM REV C
> 
> Signed-off-by: Mathias Leblanc <mathias.leblanc@st.com>
> ---
>  drivers/char/tpm/tpm_stm_st33_i2c.c  | 1106 ++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_stm_st33_i2c.h  |   72 +++
>  include/linux/i2c/tpm_stm_st33_i2c.h |   48 ++
>  3 files changed, 1226 insertions(+)
>  create mode 100644 drivers/char/tpm/tpm_stm_st33_i2c.c
>  create mode 100644 drivers/char/tpm/tpm_stm_st33_i2c.h
>  create mode 100644 include/linux/i2c/tpm_stm_st33_i2c.h
> 
> diff --git a/drivers/char/tpm/tpm_stm_st33_i2c.c b/drivers/char/tpm/tpm_stm_st33_i2c.c
> new file mode 100644
> index 0000000..c51c936
> --- /dev/null
> +++ b/drivers/char/tpm/tpm_stm_st33_i2c.c
> @@ -0,0 +1,1106 @@
> +/*
> + * STMicroelectronics TPM I2C Linux driver for TPM ST33ZP24
> + * Copyright (C) 2009, 2010  STMicroelectronics
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + *
> + * STMicroelectronics version 1.2.0, Copyright (C) 2010
> + * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
> + * This is free software, and you are welcome to redistribute it
> + * under certain conditions.
> + *
> + * @Author: Christophe RICARD tpmsupport@st.com
> + *
> + * @File: tpm_stm_st33_i2c.c
> + *
> + * @Synopsis:
> + *	09/15/2010:	First shot driver tpm_tis driver for lpc is used as model.
> + */
> +
> +#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt

  This looks unused, go ahead and take it out please.

> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/delay.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c-id.h>
> +#include <linux/wait.h>
> +#include <linux/string.h>
> +#include <linux/interrupt.h>
> +#include <linux/spinlock.h>
> +#include <linux/sysfs.h>
> +#include <linux/gpio.h>
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +#include <linux/sched.h>
> +
> +#include <linux/i2c/tpm_stm_st33_i2c.h>

  Can the stuff in here be merged into
drivers/char/tpm/tpm_stm_st33_i2c.h?

> +
> +#include "tpm.h"
> +
> +#include "tpm_stm_st33_i2c.h"
> +
> +enum stm33zp24_access {
> +	TPM_ACCESS_VALID = 0x80,
> +	TPM_ACCESS_ACTIVE_LOCALITY = 0x20,
> +	TPM_ACCESS_REQUEST_PENDING = 0x04,
> +	TPM_ACCESS_REQUEST_USE = 0x02,
> +};
> +
> +enum stm33zp24_status {
> +	TPM_STS_VALID = 0x80,
> +	TPM_STS_COMMAND_READY = 0x40,
> +	TPM_STS_GO = 0x20,
> +	TPM_STS_DATA_AVAIL = 0x10,
> +	TPM_STS_DATA_EXPECT = 0x08,
> +};
> +
> +enum stm33zp24_int_flags {
> +	TPM_GLOBAL_INT_ENABLE = 0x80,
> +	TPM_INTF_CMD_READY_INT = 0x080,
> +	TPM_INTF_FIFO_AVALAIBLE_INT = 0x040,
> +	TPM_INTF_WAKE_UP_READY_INT = 0x020,
> +	TPM_INTF_LOC4SOFTRELEASE_INT = 0x008,
> +	TPM_INTF_LOCALITY_CHANGE_INT = 0x004,
> +	TPM_INTF_STS_VALID_INT = 0x002,
> +	TPM_INTF_DATA_AVAIL_INT = 0x001,
> +};
> +
> +enum tis_defaults {
> +	TIS_SHORT_TIMEOUT = 750,
> +	TIS_LONG_TIMEOUT = 2000,
> +};
> +
> +/*
> + * write8_reg
> + * Send byte to the TIS register according to the ST33ZP24 I2C protocol.
> + * @param: tpm_register, the tpm tis register where the data should be written
> + * @param: tpm_data, the tpm_data to write inside the tpm_register
> + * @param: tpm_size, The length of the data
> + * @return: number of byte written successfully: should be one if success.
> + */

 I'm confused by the return statement. Does it return the number of
bytes written, or one?

> +static int write8_reg(struct i2c_client *client, u8 tpm_register,
> +		      u8 *tpm_data, u16 tpm_size)
> +{
> +	u8 data;
> +	int value = 0;
> +	struct st33zp24_platform_data *pin_infos;
> +
> +	pin_infos = client->dev.platform_data;
> +
> +	data = tpm_register;
> +	memcpy(pin_infos->tpm_i2c_buffer[0], &data, sizeof(data));
> +	memcpy(pin_infos->tpm_i2c_buffer[0] + 1, tpm_data, tpm_size);
> +	value = i2c_master_send(client, pin_infos->tpm_i2c_buffer[0],
> +				tpm_size + 1);
> +	return value;
> +} /* write8_reg() */
> +
> +/*
> + * read8_reg
> + * Recv byte from the TIS register according to the ST33ZP24 I2C protocol.
> + * @param: tpm_register, the tpm tis register where the data should be read
> + * @param: tpm_data, the TPM response
> + * @param: tpm_size, tpm TPM response size to read.
> + * @return: number of byte read successfully: should be one if success.
> + */
> +static int read8_reg(struct i2c_client *client, u8 tpm_register,
> +		    u8 *tpm_data, int tpm_size)
> +{
> +	u8 status = 0;
> +	u8 data;
> +	struct st33zp24_platform_data *pin_infos;
> +
> +	pin_infos = client->dev.platform_data;
> +
> +	data = TPM_DUMMY_BYTE;
> +	status = write8_reg(client, tpm_register, &data, 1);
> +	if (status == 2)
> +		status = i2c_master_recv(client, tpm_data, tpm_size);
> +	return status;
> +} /* read8_reg() */
> +
> +/*
> + * I2C_WRITE_DATA
> + * Send byte to the TIS register according to the ST33ZP24 I2C protocol.
> + * @param: tpm, the chip description
> + * @param: tpm_register, the tpm tis register where the data should be written
> + * @param: tpm_data, the tpm_data to write inside the tpm_register
> + * @param: tpm_size, The length of the data
> + * @return: number of byte written successfully: should be one if success.
> + */
> +static int I2C_WRITE_DATA(struct i2c_client *client, u8 tpm_register,
> +			 u8 *tpm_data, u16 tpm_size)
> +{
> +	u8 value = 0;
> +	value = write8_reg(client, tpm_register | TPM_WRITE_DIRECTION,
> +				tpm_data, tpm_size);
> +
> +	return value;
> +} /* I2C_WRITE_DATA() */
> +
> +/*
> + * I2C_READ_DATA
> + * Recv byte from the TIS register according to the ST33ZP24 I2C protocol.
> + * @param: tpm, the chip description

  There's no "tpm" param here or above...

> + * @param: tpm_register, the tpm tis register where the data should be read
> + * @param: tpm_data, the TPM response
> + * @param: tpm_size, tpm TPM response size to read.
> + * @return: number of byte read successfully: should be one if success.
> + */
> +static int I2C_READ_DATA(struct i2c_client *client, u8 tpm_register,
> +			 u8 *tpm_data, u16 tpm_size)
> +{
> +	u8 value = 0;
> +
> +	value = read8_reg(client, tpm_register, tpm_data, tpm_size);
> +
> +	return value;
> +} /* I2C_READ_DATA () */

  I2C_READ_DATA and I2C_WRITE_DATA look like good candidates to be
macros to me.  If not, please make them lower case, else people will
assume they're macros anyway.

> +/*
> + * clear_interruption
> + * clear the TPM interrupt register.
> + * @param: tpm, the chip description
> + */
> +static void clear_interruption(struct i2c_client *client)
> +{
> +	u8 interrupt;
> +	I2C_READ_DATA(client, TPM_INT_STATUS, &interrupt, 1);
> +	I2C_WRITE_DATA(client, TPM_INT_STATUS, &interrupt, 1);
> +	I2C_READ_DATA(client, TPM_INT_STATUS, &interrupt, 1);
> +} /* clear_interruption() */
> +
> +/*
> + * _wait_for_interrupt_serirq_timeout
> + * @param: tpm, the chip description
> + * @param: timeout, the timeout of the interrupt
> + * @return: the status of the interruption.
> + */
> +static int _wait_for_interrupt_serirq_timeout(struct tpm_chip *chip,
> +						unsigned long timeout)
> +{
> +	unsigned long status;
> +	struct i2c_client *client;
> +	struct st33zp24_platform_data *pin_infos;
> +
> +	client = (struct i2c_client *) chip->vendor.iobase;
> +	pin_infos = client->dev.platform_data;
> +
> +	status = wait_for_completion_interruptible_timeout(
> +					&pin_infos->irq_detection,
> +						timeout);

 status is unsigned long, but wait_for_completion_interruptible_timeout
returns a signed long.

> +	if (status > 0)
> +		enable_irq(gpio_to_irq(pin_infos->io_serirq));
> +	gpio_direction_input(pin_infos->io_serirq);
> +
> +	return status;
> +} /* wait_for_interrupt_serirq_timeout() */
> +
> +#define wait_for_serirq_timeout(chip, condition, timeout) \
> +({ \
> +	unsigned long status = 2; \
> +	struct i2c_client *client; \
> +	struct st33zp24_platform_data *pin_infos; \
> +\
> +	client = (struct i2c_client *) chip->vendor.iobase; \
> +	pin_infos = client->dev.platform_data;  \
> +\
> +	status = _wait_for_interrupt_serirq_timeout(chip, timeout); \
> +	if (!status) { \
> +		status = -EBUSY; \
> +		goto wait_end; \
> +	} \
> +	clear_interruption(client);     \
> +	if (condition) \
> +		status = 1; \
> +\
> +wait_end: \
> +	status;\
> +})

  This'd be better as a real function.

> +
> +/*
> + * tpm_stm_i2c_cancel, cancel is not implemented.
> + * @param: chip, the tpm_chip description as specified in driver/char/tpm/tpm.h
> + */
> +static void tpm_stm_i2c_cancel(struct tpm_chip *chip)
> +{
> +	struct i2c_client *client;
> +	u8 data;
> +
> +	client = (struct i2c_client *) chip->vendor.iobase;
> +
> +	data = TPM_STS_COMMAND_READY;
> +	I2C_WRITE_DATA(client, TPM_STS, &data, 1);
> +	if (chip->vendor.irq)
> +		wait_for_serirq_timeout(chip, 1, chip->vendor.timeout_a);
> +}	/* tpm_stm_i2c_cancel() */
> +
> +/*
> + * tpm_stm_spi_status return the TPM_STS register
> + * @param: chip, the tpm chip description
> + * @return: the TPM_STS register value.
> + */
> +static u8 tpm_stm_i2c_status(struct tpm_chip *chip)
> +{
> +	struct i2c_client *client;
> +	u8 data;
> +	client = (struct i2c_client *) chip->vendor.iobase;
> +
> +	I2C_READ_DATA(client, TPM_STS, &data, 1);
> +	return data;
> +}				/* tpm_stm_i2c_status() */
> +
> +/*
> + * responseSize return the command size
> + * @param: buffer, command buffer.
> + * @param: size, the buffer size.
> + * @return: the command size.
> + */
> +static int responseSize(const char *buffer, size_t size)
> +{
> +	size_t val = 0;
> +
> +	if (size >= TPM_HEADER_SIZE) {
> +		val = (size_t) (((unsigned)buffer[2]) << 24
> +				| ((unsigned)buffer[3]) << 16
> +				| ((unsigned)buffer[4]) << 8 | (unsigned)
> +				buffer[5]);

  This looks like be32_to_cpu() to me...

[cut]
> +/*
> + * recv_data receive data
> + * @param: chip, the tpm chip description
> + * @param: buf, the buffer where the data are received
> + * @param: count, the number of data to receive
> + * @return: the tpm status, 0 if success, -ETIME if timeout is reached.
> + */

  Looks like the return description isn't accurate on this one.

[cut]
> +/*
> + * tpm_stm_i2c_send_hash send TPM locality 4 hash datas through the I2C bus.
> + * @param: chip, the tpm_chip description as specified in driver/char/tpm/tpm.h.
> + * @param: buf,	the data buffer to send.
> + * @param: len, the number of bytes to send.
> + * @return: In case of success the number of bytes sent.
> + *			In other case, a < 0 value describing the issue.
> + */
> +static int tpm_stm_i2c_send_hash(struct tpm_chip *chip, unsigned char *buf,
> +			    size_t len)
> +{
> +	u32 ret = 0, i, size, burstcnt;
> +	u8 data;
> +
> +	struct i2c_client *client;
> +	struct st33zp24_platform_data *pin_infos;
> +
> +	if (chip == NULL)
> +		return -EBUSY;
> +
> +	client = (struct i2c_client *)chip->vendor.iobase;
> +	pin_infos = client->dev.platform_data;
> +
> +	client->flags = 0;
> +
> +	ret = request_locality(chip);
> +	if (ret < 0)
> +		goto end;
> +
> +	burstcnt = get_burstcount(chip);
> +	if (burstcnt < 0)
> +		goto end;
> +
> +	data = TPM_DUMMY_BYTE;
> +	ret = I2C_WRITE_DATA(client, TPM_HASH_START, &data, 1);
> +	if (ret < 0)
> +		goto end;
> +
> +	for (i = 0 ; i < len ;) {
> +		size = min_t(int, len - i, burstcnt);
> +		ret = I2C_WRITE_DATA(client, TPM_DATA_FIFO, buf + i, size);
> +		if (ret < 0)
> +			goto end;
> +		i += size;
> +	}
> +
> +end:
> +	I2C_WRITE_DATA(client, TPM_HASH_END, &data, 1);
> +	return ret;
> +}
> +
> +
> +/*
> + * tpm_st33_i2c_ioctl provides 2 handles:
> + * - TPMIOC_CANCEL: allow to CANCEL a TPM commands execution.
> + *   See tpm_stm_i2c_cancel description above
> + * - TPMIOC_TRANSMIT: allow to transmit a TPM commands.
> + * - TPMIOC_HASH: allow to compute a locality 4 hash
> + * - TPMIOC_CHANGELOCALITY: allow to change the current locality

  Can we get rid of the ioctl path?  cancel and transmit are available
through read/write already, but I need help understanding what hash and
change locality would be useful for. If the kernel is running you can
just use the crypto api for a hash operation, right?

  As for changing locality, what's the idea there? If you can just
switch localities at any time with an ioctl and no DRTM, why have it?

[cut]
> +static const struct file_operations tpm_st33_i2c_fops = {
> +	.owner = THIS_MODULE,
> +	.llseek = no_llseek,
> +	.read = tpm_read,
> +	.write = tpm_write,
> +	.open = tpm_open,
> +	.release = tpm_release,
> +};
> +
> +static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
> +static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
> +static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
> +static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
> +static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
> +static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
> +static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
> +static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
> +
> +static struct attribute *stm_tpm_attrs[] = {
> +	&dev_attr_pubek.attr,
> +	&dev_attr_pcrs.attr,
> +	&dev_attr_enabled.attr,
> +	&dev_attr_active.attr,
> +	&dev_attr_owned.attr,
> +	&dev_attr_temp_deactivated.attr,
> +	&dev_attr_caps.attr,
> +	&dev_attr_cancel.attr, NULL,
> +};
> +
> +static struct attribute_group stm_tpm_attr_grp = {
> +	.attrs = stm_tpm_attrs
> +};
> +
> +static struct tpm_vendor_specific st_i2c_tpm = {
> +	.send = tpm_stm_i2c_send,
> +	.recv = tpm_stm_i2c_recv,
> +	.cancel = tpm_stm_i2c_cancel,
> +	.status = tpm_stm_i2c_status,
> +	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +	.req_canceled = TPM_STS_COMMAND_READY,
> +	.attr_group = &stm_tpm_attr_grp,
> +	.miscdev = {.fops = &tpm_st33_i2c_fops,},
> +};
> +
> +static int interrupts ;
> +module_param(interrupts, bool, 0444);
> +MODULE_PARM_DESC(interrupts, "Enable interrupts");
> +
> +static int power_mgt = 1;
> +module_param(power_mgt, bool, 0444);
> +MODULE_PARM_DESC(power_mgt, "Power Management");
> +
> +/*
> + * tpm_st33_i2c_probe initialize the TPM device
> + * @param: client, the i2c_client drescription (TPM I2C description).
> + * @param: id, the i2c_device_id struct.
> + * @return: 0 in case of success.
> + *	 -1 in other case.
> + */
> +static int
> +tpm_st33_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
> +{
> +	u32 err;
> +	u8 intmask;
> +	struct tpm_chip *chip;
> +	struct st33zp24_platform_data *platform_data;
> +
> +	err = 0;
> +
> +	if (client == NULL) {
> +		pr_info("client is NULL. exiting.\n");
> +		err = -ENODEV;
> +		goto end;
> +	}
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		pr_info("client not i2c capable\n");
> +		err = -ENODEV;
> +		goto end;
> +	}
> +
> +	chip = tpm_register_hardware(&client->dev, &st_i2c_tpm);
> +	if (!chip) {
> +		pr_info("fail chip\n");

  Use dev_info(), dev_dbg(), dev_err() etc whenever possible. Seeing a
lone "fail chip" message in a log isn't too helpful. The dev_ functions
identify the driver.

> +		err = -ENODEV;
> +		goto end;
> +	}
> +
> +	platform_data = client->dev.platform_data;
> +	platform_data->tpm_i2c_buffer[0] =
> +	    kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
> +	if (platform_data->tpm_i2c_buffer[0] == NULL) {
> +		err = -ENOMEM;
> +		goto _tpm_clean_answer;
> +	}
> +	platform_data->tpm_i2c_buffer[1] =
> +	    kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
> +	if (platform_data->tpm_i2c_buffer[1] == NULL) {
> +		err = -ENOMEM;
> +		goto _tpm_clean_response;
> +	}
> +
> +	chip->vendor.iobase = client;
> +
> +	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> +	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
> +	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> +	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> +
> +	chip->vendor.locality = LOCALITY0;
> +
> +	if (power_mgt) {
> +		err = gpio_request(platform_data->io_lpcpd, "TPM IO_LPCPD");
> +		if (err)
> +			goto _gpio_init1;
> +		gpio_set_value(platform_data->io_lpcpd, 1);
> +	}
> +
> +	if (interrupts) {
> +		init_completion(&platform_data->irq_detection);
> +		if (request_locality(chip) != LOCALITY0) {
> +			err = -ENODEV;
> +			goto _tpm_clean_response;
> +		}
> +		err = gpio_request(platform_data->io_serirq, "TPM IO_SERIRQ");
> +		if (err)
> +			goto _gpio_init2;
> +
> +		clear_interruption(client);
> +		err = request_irq(gpio_to_irq(platform_data->io_serirq),
> +				&tpm_ioserirq_handler,
> +				IRQF_TRIGGER_HIGH,
> +				"TPM SERIRQ management", chip);
> +		if (err < 0) {
> +
> +			pr_info("TPM SERIRQ signals %d not available\n",
> +			gpio_to_irq(platform_data->io_serirq));
> +			goto _irq_set;
> +		}
> +
> +		err = I2C_READ_DATA(client, TPM_INT_ENABLE, &intmask, 1);
> +		if (err < 0)
> +			goto _irq_set;
> +
> +		intmask |= TPM_INTF_CMD_READY_INT
> +			|  TPM_INTF_FIFO_AVALAIBLE_INT
> +			|  TPM_INTF_WAKE_UP_READY_INT
> +			|  TPM_INTF_LOC4SOFTRELEASE_INT
> +			|  TPM_INTF_LOCALITY_CHANGE_INT
> +			|  TPM_INTF_STS_VALID_INT
> +			|  TPM_INTF_DATA_AVAIL_INT;
> +
> +		err = I2C_WRITE_DATA(client, TPM_INT_ENABLE, &intmask, 1);
> +		if (err < 0)
> +			goto _irq_set;
> +
> +		intmask = TPM_GLOBAL_INT_ENABLE;
> +		err = I2C_WRITE_DATA(client, TPM_INT_ENABLE + 3, &intmask, 1);
> +		if (err < 0)
> +			goto _irq_set;
> +
> +		err = I2C_READ_DATA(client, TPM_INT_STATUS, &intmask, 1);
> +		if (err < 0)
> +			goto _irq_set;
> +
> +		chip->vendor.irq = interrupts;
> +
> +		tpm_gen_interrupt(chip);
> +	}
> +
> +	tpm_get_timeouts(chip);
> +
> +	i2c_set_clientdata(client, chip);
> +	platform_data->bChipF = false;
> +
> +	pr_info("TPM I2C Initialized\n");
> +	return 0;
> +_irq_set:
> +	free_irq(gpio_to_irq(platform_data->io_serirq), (void *) chip);
> +_gpio_init2:
> +	if (platform_data && interrupts)
> +		gpio_free(platform_data->io_serirq);
> +_gpio_init1:
> +	if (platform_data && power_mgt)
> +		gpio_free(platform_data->io_lpcpd);
> +_tpm_clean_response:
> +	tpm_remove_hardware(chip->dev);
> +	if (platform_data->tpm_i2c_buffer[1] != NULL) {
> +		kfree(platform_data->tpm_i2c_buffer[1]);
> +		platform_data->tpm_i2c_buffer[1] = NULL;
> +	}
> +_tpm_clean_answer:
> +	if (platform_data->tpm_i2c_buffer[0] != NULL) {
> +		kfree(platform_data->tpm_i2c_buffer[0]);
> +		platform_data->tpm_i2c_buffer[0] = NULL;
> +	}
> +
> +	platform_data->bChipF = true;
> +end:
> +	pr_info("TPM I2C initialisation fail\n");
> +	return err;
> +}
> +
> +/*
> + * tpm_st33_i2c_remove remove the TPM device
> + * @param: client, the i2c_client drescription (TPM I2C description).
> +		clear_bit(0, &chip->is_open);
> + * @return: 0 in case of success.
> + */
> +static __devexit int tpm_st33_i2c_remove(struct i2c_client *client)
> +{
> +	struct tpm_chip *chip = (struct tpm_chip *)i2c_get_clientdata(client);
> +	struct st33zp24_platform_data *pin_infos =
> +		((struct i2c_client *) chip->vendor.iobase)->dev.platform_data;
> +
> +	if (pin_infos != NULL) {
> +		free_irq(pin_infos->io_serirq, chip);
> +
> +		gpio_free(pin_infos->io_serirq);
> +		gpio_free(pin_infos->io_lpcpd);
> +
> +		if (pin_infos->bChipF != true)
> +			tpm_remove_hardware(chip->dev);
> +		if (pin_infos->tpm_i2c_buffer[1] != NULL) {
> +			kfree(pin_infos->tpm_i2c_buffer[1]);
> +			pin_infos->tpm_i2c_buffer[1] = NULL;
> +		}
> +		if (pin_infos->tpm_i2c_buffer[0] != NULL) {
> +			kfree(pin_infos->tpm_i2c_buffer[0]);
> +			pin_infos->tpm_i2c_buffer[0] = NULL;
> +		}

  These two tpm_i2c_buffer elements can contain sensitive data when the device
is removed, please use kzfree.

> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * tpm_st33_i2c_pm_suspend suspend the TPM device
> + * Added: Work around when suspend and no tpm application is running, suspend
> + * may fail because chip->data_buffer is not set (only set in tpm_open in Linux
> + * TPM core)
> + * @param: client, the i2c_client drescription (TPM I2C description).
> + * @param: mesg, the power management message.
> + * @return: 0 in case of success.
> + */
> +static int tpm_st33_i2c_pm_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +	struct tpm_chip *chip =
> +	    (struct tpm_chip *)i2c_get_clientdata(client);
> +	struct st33zp24_platform_data *pin_infos =
> +		((struct i2c_client *)chip->vendor.iobase)->dev.platform_data;
> +	int ret = 0;
> +
> +	if (power_mgt)
> +		gpio_set_value(pin_infos->io_lpcpd, 0);
> +	else{
> +		if (chip->data_buffer == NULL)
> +			chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
> +		ret = tpm_pm_suspend(&client->dev, mesg);
> +	}
> +	return ret;
> +}				/* tpm_st33_i2c_suspend() */
> +
> +/*
> + * tpm_st33_i2c_pm_resume resume the TPM device
> + * @param: client, the i2c_client drescription (TPM I2C description).
> + * @return: 0 in case of success.
> + */
> +static int tpm_st33_i2c_pm_resume(struct i2c_client *client)
> +{
> +	struct tpm_chip *chip =
> +	    (struct tpm_chip *)i2c_get_clientdata(client);
> +	struct st33zp24_platform_data *pin_infos =
> +		((struct i2c_client *)chip->vendor.iobase)->dev.platform_data;
> +
> +	int ret = 0;
> +
> +	if (power_mgt) {
> +	gpio_set_value(pin_infos->io_lpcpd, 1);
> +	ret = wait_for_serirq_timeout(chip, (chip->vendor.status(chip) &&
> +					  TPM_STS_VALID) == TPM_STS_VALID,
> +					  chip->vendor.timeout_b);
> +	} else{
> +	if (chip->data_buffer == NULL)
> +		chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
> +	ret = tpm_pm_resume(&client->dev);
> +	if (!ret)
> +		tpm_continue_selftest(chip);
> +	}

  Indent issue here.  Make sure you run this through scripts/checkpatch.pl
before the next submission.

> +	return ret;
> +}				/* tpm_st33_i2c_pm_resume() */
> +
> +static const struct i2c_device_id tpm_st33_i2c_id[] = {
> +	{TPM_ST33_I2C, 0},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, tpm_st33_i2c_id);
> +
> +static struct i2c_driver tpm_st33_i2c_driver = {
> +	.driver = {
> +		   .owner = THIS_MODULE,
> +		   .name = TPM_ST33_I2C,
> +		   },
> +	.probe = tpm_st33_i2c_probe,
> +	.remove = tpm_st33_i2c_remove,
> +	.resume = tpm_st33_i2c_pm_resume,
> +	.suspend = tpm_st33_i2c_pm_suspend,
> +	.id_table = tpm_st33_i2c_id
> +};
> +
> +/*
> + * tpm_st33_i2c_init initialize driver
> + * @return: 0 if successful, else non zero value.
> + */
> +static int __init tpm_st33_i2c_init(void)
> +{
> +	return i2c_add_driver(&tpm_st33_i2c_driver);
> +}
> +
> +/*
> + * tpm_st33_i2c_exit The kernel calls this function during unloading the
> + * module or during shut down process
> + */
> +static void __exit tpm_st33_i2c_exit(void)
> +{
> +	i2c_del_driver(&tpm_st33_i2c_driver);
> +}
> +
> +module_init(tpm_st33_i2c_init);
> +module_exit(tpm_st33_i2c_exit);
> +
> +MODULE_AUTHOR("Christophe Ricard (tpmsupport@st.com)");
> +MODULE_DESCRIPTION("STM TPM I2C ST33 Driver");
> +MODULE_VERSION("1.2.0");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/char/tpm/tpm_stm_st33_i2c.h b/drivers/char/tpm/tpm_stm_st33_i2c.h
> new file mode 100644
> index 0000000..4870936
> --- /dev/null
> +++ b/drivers/char/tpm/tpm_stm_st33_i2c.h
> @@ -0,0 +1,72 @@
> +/*
> + * STMicroelectronics TPM I2C Linux driver for TPM ST33ZP24
> + * Copyright (C) 2009, 2010  STMicroelectronics
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + *
> + * STMicroelectronics version 1.2.0, Copyright (C) 2010
> + * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
> + * This is free software, and you are welcome to redistribute it
> + * under certain conditions.
> + *
> + * @Author: Christophe RICARD tpmsupport@st.com
> + *
> + * @File: stm_st33_tpm_i2c.h
> + *
> + * @Date: 09/15/2010
> + */
> +#ifndef __STM_ST33_TPM_I2C_MAIN_H__
> +#define __STM_ST33_TPM_I2C_MAIN_H__
> +
> +#include <linux/pci.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c-id.h>
> +#include <linux/fs.h>
> +#include <linux/miscdevice.h>
> +
> +#define MINOR_NUM_I2C		224
> +
> +#define TPM_ACCESS			(0x0)
> +#define TPM_STS				(0x18)
> +#define TPM_HASH_END			(0x20)
> +#define TPM_DATA_FIFO			(0x24)
> +#define TPM_HASH_DATA			(0x24)
> +#define TPM_HASH_START			(0x28)
> +#define TPM_INTF_CAPABILITY		(0x14)
> +#define TPM_INT_STATUS			(0x10)
> +#define TPM_INT_ENABLE			(0x08)
> +
> +#define TPM_DUMMY_BYTE			0xAA
> +#define TPM_WRITE_DIRECTION		0x80
> +#define TPM_HEADER_SIZE			10
> +#define TPM_BUFSIZE			2048
> +
> +/* ioctl commands */
> +#define TPMIOC_CANCEL		_IO('T', 0x00)
> +#define TPMIOC_TRANSMIT		_IO('T', 0x01)
> +#define TPMIOC_HASH		_IO('T', 0x02)
> +#define TPMIOC_CHANGELOCALITY	_IO('T', 0x03)

  These ioctl numbers are here in a header file where user-space can't
find them...  Looks like they're really not used then, right?

> +#define LOCALITY0		0
> +#define LOCALITY4		4
> +
> +typedef struct st_tpm_hash{
> +	int size;
> +	u8 *data;
> +} st_tpm_hash_t;

  No typedef's please.

  One last thing - please submit the Makefile and Kconfig updates on
next submission.

Thanks,
Kent

> +#endif /* __STM_ST33_TPM_I2C_MAIN_H__ */
> diff --git a/include/linux/i2c/tpm_stm_st33_i2c.h b/include/linux/i2c/tpm_stm_st33_i2c.h
> new file mode 100644
> index 0000000..c9a980d
> --- /dev/null
> +++ b/include/linux/i2c/tpm_stm_st33_i2c.h
> @@ -0,0 +1,48 @@
> +/*
> +* STMicroelectronics TPM I2C Linux driver for TPM ST33ZP24
> +* Copyright (C) 2009, 2010 STMicroelectronics
> +* Christophe RICARD tpmsupport@st.com
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License as published by
> +* the Free Software Foundation; either version 2 of the License, or
> +* (at your option) any later version.
> +*
> +* This program is distributed in the hope that it will be useful,
> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +* GNU General Public License for more details.
> +*
> +* You should have received a copy of the GNU General Public License along
> +* with this program; if not, write to the Free Software Foundation, Inc.,
> +* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> +*
> +* STMicroelectronics version 1.2.0, Copyright (C) 2010
> +* STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
> +* This is free software, and you are welcome to redistribute it
> +* under certain conditions.
> +*
> +* @File: stm_st33_tpm_i2c.h
> +*
> +* @Date: 06/15/2008
> +*/
> +#ifndef __STM_ST33_TPM_I2C_H__
> +#define __STM_ST33_TPM_I2C_H__
> +
> +#include <linux/i2c.h>
> +
> +#define TPM_ST33_I2C		    	"st33zp24_i2c"
> +#define TPM_I2C_ST33_ADDR_WR_LOC0	(0x26 >> 1)
> +#define TPM_I2C_ST33_ADDR_WR_LOC4	(0x36 >> 1)
> +
> +
> +struct st33zp24_platform_data {
> +	int io_serirq;
> +	int io_lpcpd;
> +	struct i2c_client *client;
> +	bool bChipF;
> +	u8 *tpm_i2c_buffer[2]; /* 0 Request 1 Response */
> +	struct completion irq_detection;
> +	struct mutex lock;
> +};
> +
> +#endif /* __STM_ST33_TPM_I2C_H__ */
> -- 
> 1.7.9.5
> 
> 

