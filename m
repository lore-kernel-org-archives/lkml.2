Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1AYDRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 22:17:09 -0500
Received: from kroah.org ([198.145.64.141]:41274 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab1AYDRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 22:17:06 -0500
Date: Tue, 25 Jan 2011 11:17:52 +0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Aaron Durbin <adurbin@google.com>, Duncan Laurie <dlaurie@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 3/6] driver: Google EFI SMI
Message-ID: <20110125031752.GA9846@kroah.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125002449.12637.35623.stgit@mike.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125002449.12637.35623.stgit@mike.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 04:24:49PM -0800, Mike Waychison wrote:
> The "gsmi" driver bridges userland with firmware specific routines for
> accessing hardware.
> 
> Currently, this driver only supports NVRAM and eventlog information.
> Deprecated functions have been removed from the driver, though their
> op-codes are left in place so that they are not re-used.
> 
> This driver works by trampolining into the firmware via the smi_command
> outlined in the FADT table.  Three protocols are used due to various
> limitations over time, but all are included herein.
> 
> Signed-off-by: Duncan Laurie <dlaurie@google.com>
> Signed-off-by: Aaron Durbin <adurbin@google.com>
> Signed-off-by: Mike Waychison <mikew@google.com>
> ---
>  drivers/firmware/google/Kconfig  |   10 
>  drivers/firmware/google/Makefile |    1 
>  drivers/firmware/google/gsmi.c   |  931 ++++++++++++++++++++++++++++++++++++++
>  fs/compat_ioctl.c                |    7 
>  include/linux/gsmi.h             |  120 +++++
>  include/linux/miscdevice.h       |    1 
>  6 files changed, 1070 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/firmware/google/gsmi.c
>  create mode 100644 include/linux/gsmi.h
> 
> diff --git a/drivers/firmware/google/Kconfig b/drivers/firmware/google/Kconfig
> index 7834729..2d2be7c 100644
> --- a/drivers/firmware/google/Kconfig
> +++ b/drivers/firmware/google/Kconfig
> @@ -11,4 +11,14 @@ config GOOGLE_FIRMWARE
>  menu "Google Firmware Drivers"
>  	depends on GOOGLE_FIRMWARE
>  
> +config GOOGLE_SMI
> +	bool "SMI interface for Google platforms"
> +	depends on ACPI
> +	default y
> +	help
> +	  Say Y here if you want to enable SMI callbacks for Google
> +	  platforms.  This provides an interface for writing to and
> +	  clearing the EFI event log and reading and writing NVRAM
> +	  variables.
> +
>  endmenu
> diff --git a/drivers/firmware/google/Makefile b/drivers/firmware/google/Makefile
> index 8b13789..fb127d7 100644
> --- a/drivers/firmware/google/Makefile
> +++ b/drivers/firmware/google/Makefile
> @@ -1 +1,2 @@
>  
> +obj-$(CONFIG_GOOGLE_SMI)		+= gsmi.o
> diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
> new file mode 100644
> index 0000000..682f594
> --- /dev/null
> +++ b/drivers/firmware/google/gsmi.c
> @@ -0,0 +1,931 @@
> +/*
> + * Copyright 2010 Google Inc. All Rights Reserved.
> + * Author: dlaurie@google.com (Duncan Laurie)
> + *
> + * EFI SMI interface for Google platforms
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <linux/errno.h>
> +#include <linux/string.h>
> +#include <linux/spinlock.h>
> +#include <linux/miscdevice.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/dmapool.h>
> +#include <linux/fs.h>
> +#include <linux/slab.h>
> +#include <linux/ioctl.h>
> +#include <linux/acpi.h>
> +#include <linux/io.h>
> +#include <linux/uaccess.h>
> +#include <linux/dmi.h>
> +#include <linux/gsmi.h>
> +#include <linux/kdebug.h>
> +#include <linux/reboot.h>
> +
> +#define GSMI_SHUTDOWN_CLEAN	0	/* Clean Shutdown */
> +#define GSMI_SHUTDOWN_NMIWDT	1	/* NMI Watchdog */
> +#define GSMI_SHUTDOWN_PANIC	2	/* Panic */
> +#define GSMI_SHUTDOWN_OOPS	3	/* Oops */
> +#define GSMI_SHUTDOWN_DIE	4	/* Die */
> +#define GSMI_SHUTDOWN_MCE	5	/* Machine Check */
> +#define GSMI_SHUTDOWN_SOFTWDT	6	/* Software Watchdog */
> +#define GSMI_SHUTDOWN_MBE	7	/* Uncorrected ECC */
> +#define GSMI_SHUTDOWN_TRIPLE	8	/* Triple Fault */
> +
> +#define DRIVER_VERSION		"1.0"
> +#define GSMI_GUID_SIZE		16
> +#define GSMI_BUF_SIZE		1024
> +#define GSMI_BUF_ALIGN		sizeof(u64)
> +#define GSMI_CALLBACK		0xef
> +
> +/* SMI return codes */
> +#define GSMI_SUCCESS		0x00
> +#define GSMI_UNSUPPORTED2	0x03
> +#define GSMI_LOG_FULL		0x0b
> +#define GSMI_VAR_NOT_FOUND	0x0e
> +#define GSMI_HANDSHAKE_SPIN	0x7d
> +#define GSMI_HANDSHAKE_CF	0x7e
> +#define GSMI_HANDSHAKE_NONE	0x7f
> +#define GSMI_INVALID_PARAMETER	0x82
> +#define GSMI_UNSUPPORTED	0x83
> +#define GSMI_BUFFER_TOO_SMALL	0x85
> +#define GSMI_NOT_READY		0x86
> +#define GSMI_DEVICE_ERROR	0x87
> +#define GSMI_NOT_FOUND		0x8e
> +
> +#define QUIRKY_BOARD_HASH 0x78a30a50
> +
> +/* SMI buffers must be in 32bit physical address space */
> +struct gsmi_buf {
> +	uint8_t *start;			/* start of buffer */
> +	size_t length;			/* length of buffer */
> +	dma_addr_t handle;		/* dma allocation handle */
> +	uint32_t address;		/* physical address of buffer */
> +};
> +
> +struct gsmi_device {
> +	struct platform_device *pdev;	/* platform device */
> +	struct gsmi_buf *name_buf;	/* variable name buffer */
> +	struct gsmi_buf *data_buf;	/* generic data buffer */
> +	struct gsmi_buf *param_buf;	/* parameter buffer */
> +	spinlock_t lock;		/* serialize access to SMIs */
> +	uint16_t smi_cmd;		/* SMI command port */
> +	int handshake_type;		/* firmware handler interlock type */
> +	struct dma_pool *dma_pool;	/* DMA buffer pool */
> +};
> +
> +struct gsmi_nvram_var_param {
> +	uint8_t  guid[GSMI_GUID_SIZE];
> +	uint32_t name_ptr;
> +	uint32_t attributes;
> +	uint32_t data_len;
> +	uint32_t data_ptr;
> +} __packed;
> +
> +struct gsmi_get_next_var_param {
> +	uint8_t  guid[GSMI_GUID_SIZE];
> +	uint32_t name_ptr;
> +	uint32_t name_len;
> +} __packed;
> +
> +struct gsmi_set_event_log_param {
> +	uint32_t data_ptr;
> +	uint32_t data_len;
> +	uint32_t type;
> +} __packed;
> +
> +static int gsmi_cmd_get_nvram_var(struct gsmi_ioctl *ctl);
> +static int gsmi_cmd_get_next_var(struct gsmi_ioctl *ctl);
> +static int gsmi_cmd_set_nvram_var(struct gsmi_ioctl *ctl);
> +static int gsmi_cmd_set_event_log(struct gsmi_ioctl *ctl);
> +static int gsmi_cmd_clear_event_log(struct gsmi_ioctl *ctl);
> +static int gsmi_cmd_clear_config(struct gsmi_ioctl *ctl);
> +static int gsmi_cmd_noop(struct gsmi_ioctl *ctl);
> +
> +/* list of ioctl command handlers */
> +static int (*gsmi_cmd_handler[])(struct gsmi_ioctl *ctl) = {
> +	[GSMI_CMD_GET_NVRAM_VAR]    = gsmi_cmd_get_nvram_var,
> +	[GSMI_CMD_GET_NEXT_VAR]	    = gsmi_cmd_get_next_var,
> +	[GSMI_CMD_SET_NVRAM_VAR]    = gsmi_cmd_set_nvram_var,
> +	[GSMI_CMD_SET_EVENT_LOG]    = gsmi_cmd_set_event_log,
> +	[GSMI_CMD_CLEAR_EVENT_LOG]  = gsmi_cmd_clear_event_log,
> +	[GSMI_CMD_CLEAR_CONFIG]     = gsmi_cmd_clear_config,
> +	[GSMI_CMD_NOOP]             = gsmi_cmd_noop,
> +};
> +
> +static long gsmi_ioctl(struct file *file, unsigned int cmd,
> +		       unsigned long arg);
> +
> +static const struct file_operations gsmi_fops = {
> +	.owner		= THIS_MODULE,
> +	.llseek		= no_llseek,
> +	.unlocked_ioctl	= gsmi_ioctl,
> +};
> +
> +static struct miscdevice gsmi_miscdev = {
> +	.minor	= GOOGLE_SMI_MINOR,
> +	.name	= "gsmi",
> +	.fops	= &gsmi_fops,
> +};
> +
> +/* global device handle */
> +static struct gsmi_device *gsmi_dev;
> +
> +/*
> + * Some platforms don't have explicit SMI handshake
> + * and need to wait for SMI to complete.
> + */
> +#define GSMI_DEFAULT_SPINCOUNT	0x10000
> +static uint32_t gsmi_spincount = GSMI_DEFAULT_SPINCOUNT;
> +
> +static int __init gsmi_setup_spincount(char *str)
> +{
> +	unsigned long res;
> +	if (!strict_strtoul(str, 0, &res))
> +		gsmi_spincount = (uint32_t)res;
> +	return 1;
> +}
> +__setup("gsmi_spincount=", gsmi_setup_spincount);
> +
> +static struct gsmi_buf *gsmi_buf_alloc(void)
> +{
> +	struct gsmi_buf *smibuf;
> +
> +	smibuf = kzalloc(sizeof(*smibuf), GFP_KERNEL);
> +	if (!smibuf) {
> +		printk(KERN_ERR "gsmi: out of memory\n");
> +		return NULL;
> +	}
> +
> +	/* allocate buffer in 32bit address space */
> +	smibuf->start = dma_pool_alloc(gsmi_dev->dma_pool, GFP_KERNEL,
> +				       &smibuf->handle);
> +	if (!smibuf->start) {
> +		printk(KERN_ERR "gsmi: failed to allocate name buffer\n");
> +		kfree(smibuf);
> +		return NULL;
> +	}
> +
> +	/* fill in the buffer handle */
> +	smibuf->length = GSMI_BUF_SIZE;
> +	smibuf->address = (uint32_t)virt_to_phys(smibuf->start);
> +	memset(smibuf->start, 0, GSMI_BUF_SIZE);
> +
> +	return smibuf;
> +}
> +
> +static void gsmi_buf_free(struct gsmi_buf *smibuf)
> +{
> +	if (smibuf) {
> +		if (smibuf->start)
> +			dma_pool_free(gsmi_dev->dma_pool, smibuf->start,
> +				      smibuf->handle);
> +		kfree(smibuf);
> +		smibuf = NULL;
> +	}
> +}
> +
> +static int gsmi_exec(uint8_t func, uint8_t sub)
> +{
> +	uint16_t cmd = (sub << 8) | func;
> +	uint16_t result = 0;
> +	int rc = 0;
> +
> +	/*
> +	 * AH  : Subfunction number
> +	 * AL  : Function number
> +	 * EBX : Parameter block address
> +	 * DX  : SMI command port
> +	 *
> +	 * Three protocols here. See also the comment in gsmi_init().
> +	 */
> +	if (gsmi_dev->handshake_type == GSMI_HANDSHAKE_CF) {
> +		/*
> +		 * If handshake_type == HANDSHAKE_CF then set CF on the
> +		 * way in and wait for the handler to clear it; this avoids
> +		 * corrupting register state on those chipsets which have
> +		 * a delay between writing the SMI trigger register and
> +		 * entering SMM.
> +		 */
> +		asm volatile (
> +			"stc\n"
> +			"outb %%al, %%dx\n"
> +		"1:      jc 1b\n"
> +			"mov %%ax, %0"
> +			: "=r" (result)
> +			: "a" (cmd),
> +			  "d" (gsmi_dev->smi_cmd),
> +			  "b" (gsmi_dev->param_buf->address)
> +			: "memory", "cc"
> +		);
> +	} else if (gsmi_dev->handshake_type == GSMI_HANDSHAKE_SPIN) {
> +		/*
> +		 * If handshake_type == HANDSHAKE_SPIN we spin a
> +		 * hundred-ish usecs to ensure the SMI has triggered.
> +		 */
> +		asm volatile (
> +			"outb %%al, %%dx\n"
> +		"1:      loop 1b\n"
> +			"mov %%ax, %0"
> +			: "=r" (result)
> +			: "a" (cmd),
> +			  "d" (gsmi_dev->smi_cmd),
> +			  "b" (gsmi_dev->param_buf->address),
> +			  "c" (gsmi_spincount)
> +			: "memory", "cc"
> +		);
> +	} else {
> +		/*
> +		 * If handshake_type == HANDSHAKE_NONE we do nothing;
> +		 * either we don't need to or it's legacy firmware that
> +		 * doesn't understand the CF protocol.
> +		 */
> +		asm volatile (
> +			"outb %%al, %%dx\n\t"
> +			"mov %%ax, %0"
> +			: "=r" (result)
> +			: "a" (cmd),
> +			  "d" (gsmi_dev->smi_cmd),
> +			  "b" (gsmi_dev->param_buf->address)
> +			: "memory", "cc"
> +		);
> +	}
> +
> +	/* check return code from SMI handler */
> +	switch (result) {
> +	case GSMI_SUCCESS:
> +		break;
> +	case GSMI_VAR_NOT_FOUND:
> +		/* not really an error, but let the caller know */
> +		rc = 1;
> +		break;
> +	case GSMI_INVALID_PARAMETER:
> +		printk(KERN_ERR "gsmi: exec 0x%04x: Invalid parameter\n", cmd);
> +		rc = -EINVAL;
> +		break;
> +	case GSMI_BUFFER_TOO_SMALL:
> +		printk(KERN_ERR "gsmi: exec 0x%04x: Buffer too small\n", cmd);
> +		rc = -ENOMEM;
> +		break;
> +	case GSMI_UNSUPPORTED:
> +	case GSMI_UNSUPPORTED2:
> +		if (sub != GSMI_CMD_HANDSHAKE_TYPE)
> +			printk(KERN_ERR "gsmi: exec 0x%04x: Not supported\n",
> +			       cmd);
> +		rc = -ENOSYS;
> +		break;
> +	case GSMI_NOT_READY:
> +		printk(KERN_ERR "gsmi: exec 0x%04x: Not ready\n", cmd);
> +		rc = -EBUSY;
> +		break;
> +	case GSMI_DEVICE_ERROR:
> +		printk(KERN_ERR "gsmi: exec 0x%04x: Device error\n", cmd);
> +		rc = -EFAULT;
> +		break;
> +	case GSMI_NOT_FOUND:
> +		printk(KERN_ERR "gsmi: exec 0x%04x: Data not found\n", cmd);
> +		rc = -ENOENT;
> +		break;
> +	case GSMI_LOG_FULL:
> +		printk(KERN_ERR "gsmi: exec 0x%04x: Log full\n", cmd);
> +		rc = -ENOSPC;
> +		break;
> +	case GSMI_HANDSHAKE_CF:
> +	case GSMI_HANDSHAKE_SPIN:
> +	case GSMI_HANDSHAKE_NONE:
> +		rc = result;
> +		break;
> +	default:
> +		printk(KERN_ERR "gsmi: exec 0x%04x: Unknown error 0x%04x\n",
> +		       cmd, result);
> +		rc = -ENXIO;
> +	}
> +
> +	return rc;
> +}
> +
> +static int gsmi_cmd_get_nvram_var(struct gsmi_ioctl *ctl)
> +{
> +	struct gsmi_get_nvram_var *cmd = &ctl->gsmi_cmd.get_nvram_var;
> +	struct gsmi_nvram_var_param param = {
> +		.name_ptr = gsmi_dev->name_buf->address,
> +		.data_ptr = gsmi_dev->data_buf->address,
> +		.data_len = cmd->data_len,
> +	};
> +	uint16_t var_name[GSMI_BUF_SIZE / 2];
> +	int i, rc = 0;
> +	unsigned long flags;
> +
> +	if (cmd->name_len > GSMI_BUF_SIZE / 2 ||
> +	    cmd->name_len > sizeof(cmd->name))
> +		return -1;
> +
> +	spin_lock_irqsave(&gsmi_dev->lock, flags);
> +
> +	/* guid */
> +	memcpy(&param.guid, cmd->guid, GSMI_GUID_SIZE);
> +
> +	/* variable name, converted from ascii to UTF-16 */
> +	memset(var_name, 0, sizeof(var_name));
> +	for (i = 0; i < cmd->name_len; i++)
> +		var_name[i] = cmd->name[i];
> +	memset(gsmi_dev->name_buf->start, 0, gsmi_dev->name_buf->length);
> +	memcpy(gsmi_dev->name_buf->start, var_name, cmd->name_len * 2);
> +
> +	/* data pointer */
> +	memset(gsmi_dev->data_buf->start, 0, gsmi_dev->data_buf->length);
> +
> +	/* parameter buffer */
> +	memset(gsmi_dev->param_buf->start, 0, gsmi_dev->param_buf->length);
> +	memcpy(gsmi_dev->param_buf->start, &param, sizeof(param));
> +
> +	rc = gsmi_exec(GSMI_CALLBACK, ctl->command);
> +	if (rc < 0) {
> +		printk(KERN_ERR "gsmi: Get Variable %s failed\n", cmd->name);
> +	} else if (rc == 1) {
> +		/* variable was not found */
> +		rc = -1;
> +	} else {
> +		/* copy data back to return buffer */
> +		memcpy(cmd->data, gsmi_dev->data_buf->start, cmd->data_len);
> +		rc = 1;
> +	}
> +
> +	spin_unlock_irqrestore(&gsmi_dev->lock, flags);
> +
> +	return rc;
> +}
> +
> +static int gsmi_cmd_get_next_var(struct gsmi_ioctl *ctl)
> +{
> +	struct gsmi_get_next_var *cmd = &ctl->gsmi_cmd.get_next_var;
> +	struct gsmi_get_next_var_param param = {
> +		.name_ptr = gsmi_dev->name_buf->address,
> +		.name_len = gsmi_dev->name_buf->length,
> +	};
> +	uint16_t var_name[GSMI_BUF_SIZE / 2];
> +	int i, rc = 0;
> +	unsigned long flags;
> +
> +	if (cmd->name_len > GSMI_BUF_SIZE / 2 ||
> +	    cmd->name_len > sizeof(cmd->name))
> +		return -1;
> +
> +	spin_lock_irqsave(&gsmi_dev->lock, flags);
> +
> +	/* guid */
> +	memcpy(&param.guid, cmd->guid, sizeof(param.guid));
> +
> +	/* variable name, converted from ascii to UTF-16 */
> +	memset(var_name, 0, sizeof(var_name));
> +	for (i = 0; i < cmd->name_len; i++)
> +		var_name[i] = cmd->name[i];
> +	memset(gsmi_dev->name_buf->start, 0, gsmi_dev->name_buf->length);
> +	memcpy(gsmi_dev->name_buf->start, var_name, cmd->name_len * 2);
> +
> +	/* parameter buffer */
> +	memset(gsmi_dev->param_buf->start, 0, gsmi_dev->param_buf->length);
> +	memcpy(gsmi_dev->param_buf->start, &param, sizeof(param));
> +
> +	rc = gsmi_exec(GSMI_CALLBACK, ctl->command);
> +	if (rc < 0) {
> +		printk(KERN_ERR "gsmi: Get Next Variable Name failed\n");
> +	} else if (rc == 1) {
> +		/* variable not found -- end of list */
> +		memset(cmd->guid, 0, sizeof(cmd->guid));
> +		memset(cmd->name, 0, cmd->name_len);
> +		cmd->name_len = 0;
> +		rc = 1;
> +	} else {
> +		/* copy variable data back to return buffer */
> +		memcpy(&param, gsmi_dev->param_buf->start, sizeof(param));
> +
> +		/* convert variable name back to ascii */
> +		memset(var_name, 0, sizeof(var_name));
> +		memcpy(var_name, gsmi_dev->name_buf->start, param.name_len);
> +		memset(cmd->name, 0, sizeof(cmd->name));
> +		cmd->name_len = param.name_len / 2;
> +		for (i = 0; i < cmd->name_len; i++)
> +			cmd->name[i] = var_name[i];
> +
> +		/* copy guid to return buffer */
> +		memcpy(cmd->guid, &param.guid, sizeof(cmd->guid));
> +		rc = 1;
> +	}
> +
> +	spin_unlock_irqrestore(&gsmi_dev->lock, flags);
> +
> +	return rc;
> +}
> +
> +static int gsmi_cmd_set_nvram_var(struct gsmi_ioctl *ctl)
> +{
> +	struct gsmi_set_nvram_var *cmd = &ctl->gsmi_cmd.set_nvram_var;
> +	struct gsmi_nvram_var_param param = {
> +		.name_ptr = gsmi_dev->name_buf->address,
> +		.data_ptr = gsmi_dev->data_buf->address,
> +		.data_len = cmd->data_len,
> +		.attributes = 0x7, /* nvram, boot, runtime */
> +	};
> +	uint16_t var_name[GSMI_BUF_SIZE / 2];
> +	int i, rc = 0;
> +	unsigned long flags;
> +
> +	if (cmd->name_len > GSMI_BUF_SIZE / 2 ||
> +	    cmd->name_len > sizeof(cmd->name))
> +		return -1;
> +
> +	spin_lock_irqsave(&gsmi_dev->lock, flags);
> +
> +	/* guid */
> +	memcpy(&param.guid, cmd->guid, sizeof(param.guid));
> +
> +	/* variable name, converted from ascii to UTF-16 */
> +	memset(var_name, 0, sizeof(var_name));
> +	for (i = 0; i < cmd->name_len; i++)
> +		var_name[i] = cmd->name[i];
> +	memset(gsmi_dev->name_buf->start, 0, gsmi_dev->name_buf->length);
> +	memcpy(gsmi_dev->name_buf->start, var_name, cmd->name_len * 2);
> +
> +	/* data pointer */
> +	memset(gsmi_dev->data_buf->start, 0, gsmi_dev->data_buf->length);
> +	memcpy(gsmi_dev->data_buf->start, cmd->data, cmd->data_len);
> +
> +	/* parameter buffer */
> +	memset(gsmi_dev->param_buf->start, 0, gsmi_dev->param_buf->length);
> +	memcpy(gsmi_dev->param_buf->start, &param, sizeof(param));
> +
> +	rc = gsmi_exec(GSMI_CALLBACK, ctl->command);
> +	if (rc < 0)
> +		printk(KERN_ERR "gsmi: Set Variable %s failed\n", cmd->name);
> +
> +	spin_unlock_irqrestore(&gsmi_dev->lock, flags);
> +
> +	return rc;
> +}
> +
> +static int gsmi_cmd_set_event_log(struct gsmi_ioctl *ctl)
> +{
> +	struct gsmi_set_event_log *cmd = &ctl->gsmi_cmd.set_event_log;
> +	struct gsmi_set_event_log_param param = {
> +		.data_ptr = gsmi_dev->data_buf->address,
> +		.data_len = cmd->data_len,
> +		.type     = cmd->type,
> +	};
> +	int rc = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&gsmi_dev->lock, flags);
> +
> +	/* data pointer */
> +	memset(gsmi_dev->data_buf->start, 0, gsmi_dev->data_buf->length);
> +	memcpy(gsmi_dev->data_buf->start, cmd->data, cmd->data_len);
> +
> +	/* parameter buffer */
> +	memset(gsmi_dev->param_buf->start, 0, gsmi_dev->param_buf->length);
> +	memcpy(gsmi_dev->param_buf->start, &param, sizeof(param));
> +
> +	rc = gsmi_exec(GSMI_CALLBACK, ctl->command);
> +	if (rc < 0)
> +		printk(KERN_ERR "gsmi: Set Event Log failed\n");
> +
> +	spin_unlock_irqrestore(&gsmi_dev->lock, flags);
> +
> +	return rc;
> +}
> +
> +static int gsmi_cmd_clear_event_log(struct gsmi_ioctl *ctl)
> +{
> +	struct gsmi_clear_event_log *cmd = &ctl->gsmi_cmd.clear_event_log;
> +	int rc = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&gsmi_dev->lock, flags);
> +
> +	/* parameter buffer */
> +	memset(gsmi_dev->param_buf->start, 0, gsmi_dev->param_buf->length);
> +	memcpy(gsmi_dev->param_buf->start, cmd, sizeof(*cmd));
> +
> +	rc = gsmi_exec(GSMI_CALLBACK, ctl->command);
> +	if (rc < 0)
> +		printk(KERN_ERR "gsmi: Clear Event Log failed\n");
> +
> +	/* type 0 will return available space in log */
> +	if (cmd->type == 0)
> +		rc = 1;
> +
> +	spin_unlock_irqrestore(&gsmi_dev->lock, flags);
> +
> +	return rc;
> +}
> +
> +static int gsmi_cmd_clear_config(struct gsmi_ioctl *ctl)
> +{
> +	int rc = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&gsmi_dev->lock, flags);
> +
> +	/* clear parameter buffer */
> +	memset(gsmi_dev->param_buf->start, 0, gsmi_dev->param_buf->length);
> +
> +	rc = gsmi_exec(GSMI_CALLBACK, ctl->command);
> +	if (rc < 0)
> +		printk(KERN_ERR "gsmi: Clear Config failed\n");
> +
> +	spin_unlock_irqrestore(&gsmi_dev->lock, flags);
> +
> +	return rc;
> +}
> +
> +static int gsmi_cmd_noop(struct gsmi_ioctl *ctl)
> +{
> +	int rc = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&gsmi_dev->lock, flags);
> +
> +	/* clear parameter buffer */
> +	memset(gsmi_dev->param_buf->start, 0, gsmi_dev->param_buf->length);
> +
> +	rc = gsmi_exec(GSMI_CALLBACK, ctl->command);
> +	if (rc < 0)
> +		printk(KERN_ERR "gsmi: No-op failed\n");
> +
> +	spin_unlock_irqrestore(&gsmi_dev->lock, flags);
> +
> +	return rc;
> +}
> +
> +static long gsmi_ioctl(struct file *file, unsigned int cmd,
> +		      unsigned long arg)
> +{
> +	struct gsmi_ioctl *ctl = NULL;
> +	uint16_t length;
> +	int rc = 0;
> +
> +	/* everything is in the same ioctl */
> +	if (cmd != GSMI_IOCTL)
> +		return -ENOIOCTLCMD;
> +
> +	/* get length from user */
> +	if (copy_from_user(&length, (size_t __user *)arg,
> +			   sizeof(length))) {
> +		rc = -EFAULT;
> +		goto done;
> +	}
> +
> +	/* verify length */
> +	if (length < sizeof(*ctl)) {
> +		rc = -EINVAL;
> +		goto done;
> +	}
> +
> +	/* allocate ioctl structure */
> +	ctl = kzalloc(length, GFP_KERNEL);
> +	if (!ctl) {
> +		rc = -ENOMEM;
> +		goto done;
> +	}
> +
> +	/* copy rest of structure */
> +	if (copy_from_user(ctl, (void __user *)arg, length)) {
> +		rc = -EFAULT;
> +		goto done;
> +	}
> +
> +	/* verify structure version */
> +	if (ctl->version != GSMI_IOCTL_VERSION) {
> +		rc = -EINVAL;
> +		goto done;
> +	}
> +
> +	/* find and run command handler */
> +	if (ctl->command > sizeof(gsmi_cmd_handler)/sizeof(*gsmi_cmd_handler)) {
> +		rc = -EINVAL;
> +		goto done;
> +	}
> +	if (gsmi_cmd_handler[ctl->command] == NULL) {
> +		rc = -EINVAL;
> +		goto done;
> +	}
> +	rc = gsmi_cmd_handler[ctl->command](ctl);
> +	if (rc < 0) {
> +		goto done;
> +	} else if (rc > 0) {
> +		/* return data to user if needed */
> +		if (copy_to_user((void __user *)arg, ctl, length)) {
> +			rc = -EFAULT;
> +			goto done;
> +		}
> +		rc = 0;
> +	}
> +
> + done:
> +	kfree(ctl);
> +
> +	return rc;
> +}
> +
> +static int gsmi_shutdown_reason(int reason)
> +{
> +	struct gsmi_log_entry_type_1 entry = {
> +		.type     = GSMI_LOG_ENTRY_TYPE_KERNEL,
> +		.instance = reason,
> +	};
> +	struct gsmi_set_event_log_param param = {
> +		.data_len = sizeof(entry),
> +		.type     = 1,
> +	};
> +	static int saved_reason;
> +	int rc = 0;
> +	unsigned long flags;
> +
> +	/* abort early if we were never setup */
> +	if (!gsmi_dev)
> +		return -1;
> +
> +	/* avoid duplicate entries in the log */
> +	if (saved_reason & (1 << reason))
> +		return 0;
> +
> +	spin_lock_irqsave(&gsmi_dev->lock, flags);
> +
> +	saved_reason |= (1 << reason);
> +
> +	/* data pointer */
> +	memset(gsmi_dev->data_buf->start, 0, gsmi_dev->data_buf->length);
> +	memcpy(gsmi_dev->data_buf->start, &entry, sizeof(entry));
> +
> +	/* parameter buffer */
> +	param.data_ptr = gsmi_dev->data_buf->address;
> +	memset(gsmi_dev->param_buf->start, 0, gsmi_dev->param_buf->length);
> +	memcpy(gsmi_dev->param_buf->start, &param, sizeof(param));
> +
> +	rc = gsmi_exec(GSMI_CALLBACK, GSMI_CMD_SET_EVENT_LOG);
> +
> +	spin_unlock_irqrestore(&gsmi_dev->lock, flags);
> +
> +	if (rc < 0)
> +		printk(KERN_ERR "gsmi: Log Shutdown Reason failed\n");
> +	else
> +		printk(KERN_EMERG "gsmi: Log Shutdown Reason 0x%02x\n",
> +		       reason);
> +
> +	return rc;
> +}
> +
> +static int gsmi_reboot_callback(struct notifier_block *nb,
> +				unsigned long reason, void *arg)
> +{
> +	gsmi_shutdown_reason(GSMI_SHUTDOWN_CLEAN);
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block gsmi_reboot_notifier = {
> +	.notifier_call = gsmi_reboot_callback
> +};
> +
> +static int gsmi_die_callback(struct notifier_block *nb,
> +			     unsigned long reason, void *arg)
> +{
> +	if (reason == DIE_NMIWATCHDOG)
> +		gsmi_shutdown_reason(GSMI_SHUTDOWN_NMIWDT);
> +	else if (reason == DIE_OOPS)
> +		gsmi_shutdown_reason(GSMI_SHUTDOWN_DIE);
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block gsmi_die_notifier = {
> +	.notifier_call = gsmi_die_callback
> +};
> +
> +static int gsmi_panic_callback(struct notifier_block *nb,
> +			       unsigned long reason, void *arg)
> +{
> +	gsmi_shutdown_reason(GSMI_SHUTDOWN_PANIC);
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block gsmi_panic_notifier = {
> +	.notifier_call = gsmi_panic_callback
> +};
> +
> +static int gsmi_oops_callback(struct notifier_block *nb,
> +			      unsigned long reason, void *arg)
> +{
> +	if (reason == OOPS_ENTER)
> +		gsmi_shutdown_reason(GSMI_SHUTDOWN_OOPS);
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block gsmi_oops_notifier = {
> +	.notifier_call = gsmi_oops_callback
> +};
> +
> +/*
> + * This hash function was blatantly copied from include/linux/hash.h.
> + * It is used by this driver to obfuscate a board name that requires a
> + * quirk within this driver.
> + *
> + * Please do not remove this copy of the function as any changes to the
> + * global utility hash_64() function would break this driver's ability
> + * to identify a board and provide the appropriate quirk -- mikew@google.com
> + */
> +static u64 __init local_hash_64(u64 val, unsigned bits)
> +{
> +	u64 hash = val;
> +
> +	/*  Sigh, gcc can't optimise this alone like it does for 32 bits. */
> +	u64 n = hash;
> +	n <<= 18;
> +	hash -= n;
> +	n <<= 33;
> +	hash -= n;
> +	n <<= 3;
> +	hash += n;
> +	n <<= 3;
> +	hash -= n;
> +	n <<= 4;
> +	hash += n;
> +	n <<= 2;
> +	hash += n;
> +
> +	/* High bits are more random, so use them. */
> +	return hash >> (64 - bits);
> +}
> +
> +static u32 __init hash_oem_table_id(char s[8])
> +{
> +	u64 input;
> +	memcpy(&input, s, 8);
> +	return local_hash_64(input, 32);
> +}
> +
> +static __init int gsmi_init(void)
> +{
> +	unsigned long flags;
> +	u32 hash;
> +
> +	/*
> +	 * Check platform compatibility.  Only ever load on Google's
> +	 * machines.
> +	 */
> +	if (strncmp(acpi_gbl_FADT.header.oem_id, "GOOGLE", ACPI_OEM_ID_SIZE)) {
> +		printk(KERN_INFO "gsmi: Not a google board\n");
> +		return -ENODEV;
> +	}
> +
> +	/*
> +	 * Only newer firmware supports the gsmi interface.  All older
> +	 * firmware that didn't support this interface used to plug the
> +	 * table name in the first four bytes of the oem_table_id field.
> +	 * Newer firmware doesn't do that though, so use that as the
> +	 * discriminant factor.  We have to do this in order to
> +	 * whitewash our board names out of the public driver.
> +	 */
> +	if (!strncmp(acpi_gbl_FADT.header.oem_table_id, "FACP", 4)) {
> +		printk(KERN_INFO "gsmi: Board is too old\n");
> +		return -ENODEV;
> +	}
> +
> +	/* Disable on board with 1.0 BIOS due to Google bug 2602657 */
> +	hash = hash_oem_table_id(acpi_gbl_FADT.header.oem_table_id);
> +	if (hash == QUIRKY_BOARD_HASH) {
> +		const char *bios_ver = dmi_get_system_info(DMI_BIOS_VERSION);
> +		if (strncmp(bios_ver, "1.0", 3) == 0) {
> +			pr_info("gsmi: disabled on this board's BIOS %s\n",
> +				bios_ver);
> +			return -ENODEV;
> +		}
> +	}
> +
> +	/* check for valid SMI command port in ACPI FADT */
> +	if (acpi_gbl_FADT.smi_command == 0)
> +		return -ENODEV;
> +
> +	/* allocate device structure */
> +	gsmi_dev = kzalloc(sizeof(*gsmi_dev), GFP_KERNEL);
> +	if (!gsmi_dev)
> +		return -ENOMEM;
> +	gsmi_dev->smi_cmd = acpi_gbl_FADT.smi_command;
> +
> +	/* register device */
> +	gsmi_dev->pdev = platform_device_register_simple("gsmi", -1, NULL, 0);
> +	if (IS_ERR(gsmi_dev->pdev)) {
> +		printk(KERN_ERR "gsmi: unable to register platform device\n");
> +		kfree(gsmi_dev);
> +		gsmi_dev = NULL;
> +		return -ENODEV;
> +	}
> +	if (misc_register(&gsmi_miscdev) < 0) {
> +		printk(KERN_ERR "gsmi: unable to register misc device\n");
> +		platform_device_unregister(gsmi_dev->pdev);
> +		kfree(gsmi_dev);
> +		gsmi_dev = NULL;
> +		return -ENODEV;
> +	}
> +
> +	/* SMI access needs to be serialized */
> +	spin_lock_init(&gsmi_dev->lock);
> +
> +	/* SMI callbacks require 32bit addresses */
> +	gsmi_dev->pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> +	gsmi_dev->pdev->dev.dma_mask =
> +		&gsmi_dev->pdev->dev.coherent_dma_mask;
> +	gsmi_dev->dma_pool = dma_pool_create("gsmi", &gsmi_dev->pdev->dev,
> +					     GSMI_BUF_SIZE, GSMI_BUF_ALIGN, 0);
> +
> +	/*
> +	 * pre-allocate buffers because sometimes we are called when
> +	 * this is not feasible: oops, panic, die, mce, etc
> +	 */
> +	gsmi_dev->name_buf = gsmi_buf_alloc();
> +	if (!gsmi_dev->name_buf) {
> +		printk(KERN_ERR "gsmi: failed to allocate name buffer\n");
> +		goto out_err;
> +	}
> +
> +	gsmi_dev->data_buf = gsmi_buf_alloc();
> +	if (!gsmi_dev->data_buf) {
> +		printk(KERN_ERR "gsmi: failed to allocate data buffer\n");
> +		goto out_err;
> +	}
> +
> +	gsmi_dev->param_buf = gsmi_buf_alloc();
> +	if (!gsmi_dev->param_buf) {
> +		printk(KERN_ERR "gsmi: failed to allocate param buffer\n");
> +		goto out_err;
> +	}
> +
> +	/*
> +	 * Determine type of handshake used to serialize the SMI
> +	 * entry. See also gsmi_exec().
> +	 *
> +	 * There's a "behavior" present on some chipsets where writing the
> +	 * SMI trigger register in the southbridge doesn't result in an
> +	 * immediate SMI. Rather, the processor can execute "a few" more
> +	 * instructions before the SMI takes effect. To ensure synchronous
> +	 * behavior, implement a handshake between the kernel driver and the
> +	 * firmware handler to spin until released. This ioctl determines
> +	 * the type of handshake.
> +	 *
> +	 * NONE: The firmware handler does not implement any
> +	 * handshake. Either it doesn't need to, or it's legacy firmware
> +	 * that doesn't know it needs to and never will.
> +	 *
> +	 * CF: The firmware handler will clear the CF in the saved
> +	 * state before returning. The driver may set the CF and test for
> +	 * it to clear before proceeding.
> +	 *
> +	 * SPIN: The firmware handler does not implement any handshake
> +	 * but the driver should spin for a hundred or so microseconds
> +	 * to ensure the SMI has triggered.
> +	 *
> +	 * Finally, the handler will return -ENOSYS if
> +	 * GSMI_CMD_HANDSHAKE_TYPE is unimplemented, which implies
> +	 * HANDSHAKE_NONE.
> +	 */
> +	spin_lock_irqsave(&gsmi_dev->lock, flags);
> +	gsmi_dev->handshake_type = GSMI_HANDSHAKE_SPIN;
> +	gsmi_dev->handshake_type =
> +	    gsmi_exec(GSMI_CALLBACK, GSMI_CMD_HANDSHAKE_TYPE);
> +	if (gsmi_dev->handshake_type == -ENOSYS)
> +		gsmi_dev->handshake_type = GSMI_HANDSHAKE_NONE;
> +	spin_unlock_irqrestore(&gsmi_dev->lock, flags);
> +
> +	/* Remove and clean up gsmi if the handshake could not complete. */
> +	if (gsmi_dev->handshake_type == -ENXIO) {
> +		printk(KERN_INFO "gsmi version " DRIVER_VERSION
> +		       " failed to load\n");
> +		goto out_err;
> +	}
> +
> +	printk(KERN_INFO "gsmi version " DRIVER_VERSION " loaded\n");
> +
> +	register_reboot_notifier(&gsmi_reboot_notifier);
> +	register_die_notifier(&gsmi_die_notifier);
> +	atomic_notifier_chain_register(&panic_notifier_list,
> +				       &gsmi_panic_notifier);
> +	register_oops_notifier(&gsmi_oops_notifier);
> +
> +	return 0;
> +
> + out_err:
> +	gsmi_buf_free(gsmi_dev->param_buf);
> +	gsmi_buf_free(gsmi_dev->data_buf);
> +	gsmi_buf_free(gsmi_dev->name_buf);
> +	dma_pool_destroy(gsmi_dev->dma_pool);
> +	platform_device_unregister(gsmi_dev->pdev);
> +	misc_deregister(&gsmi_miscdev);
> +	kfree(gsmi_dev);
> +	gsmi_dev = NULL;
> +	return -ENODEV;
> +}
> +
> +late_initcall(gsmi_init);
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index 61abb63..588e458 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -114,6 +114,8 @@
>  #include <asm/fbio.h>
>  #endif
>  
> +#include <linux/gsmi.h>
> +
>  static int w_long(unsigned int fd, unsigned int cmd,
>  		compat_ulong_t __user *argp)
>  {
> @@ -1408,6 +1410,11 @@ IGNORE_IOCTL(FBIOGETCMAP32)
>  IGNORE_IOCTL(FBIOSCURSOR32)
>  IGNORE_IOCTL(FBIOGCURSOR32)
>  #endif
> +
> +#ifdef CONFIG_GOOGLE_SMI
> +/* Google SMI driver for /dev/gsmi */
> +COMPATIBLE_IOCTL(GSMI_IOCTL)
> +#endif
>  };
>  
>  /*
> diff --git a/include/linux/gsmi.h b/include/linux/gsmi.h
> new file mode 100644
> index 0000000..8b35b5c
> --- /dev/null
> +++ b/include/linux/gsmi.h
> @@ -0,0 +1,120 @@
> +/*
> + * Copyright 2010 Google Inc. All Rights Reserved.
> + * Author: dlaurie@google.com (Duncan Laurie)
> + *
> + * EFI SMI interface for Google platforms
> + */
> +
> +#ifndef _LINUX_GSMI_H
> +#define _LINUX_GSMI_H
> +
> +#include <linux/types.h>
> +
> +/*
> + * Get NVRAM Variable
> + *
> + * Must know EFI GUID and exact name to retrieve a variable
> + */
> +struct gsmi_get_nvram_var {
> +	uint8_t		guid[16];	/* IN: unique identifier */
> +	uint16_t	name_len;	/* IN: length of ascii name */
> +	char		name[512];	/* IN: unique name in ascii */
> +	uint16_t	data_len;	/* IN: length of data */
> +	uint8_t		data[0];	/* OUT: variable data */
> +} __packed;
> +
> +/*
> + * Get Next NVRAM Variable Name
> + *
> + * Can be used multiple times to get all variables in the system
> + * by supplying the output of one call as the input of the next.
> + */
> +struct gsmi_get_next_var {
> +	uint8_t		guid[16];	/* IN/OUT: unique identifier */
> +	uint16_t	name_len;	/* IN/OUT: length of ascii name */
> +	char		name[512];	/* IN/OUT: unique name in ascii */
> +} __packed;
> +
> +/*
> + * Set NVRAM Variable
> + *
> + * Must know EFI GUID and exact name to set a variable
> + */
> +struct gsmi_set_nvram_var {
> +	uint8_t		guid[16];	/* IN: unique identifier */
> +	uint16_t	name_len;	/* IN: length of ascii name */
> +	char		name[512];	/* IN: unique name in ascii */
> +	uint16_t	data_len;	/* IN: length of data */
> +	uint8_t		data[0];	/* IN: variable data */
> +} __packed;
> +
> +/*
> + * Add entry to event log
> + *
> + * Current defined entry type is 1
> + */
> +#define GSMI_LOG_ENTRY_TYPE_KERNEL	0xdead
> +struct gsmi_log_entry_type_1 {
> +	uint16_t	type;
> +	uint32_t	instance;
> +} __packed;
> +
> +struct gsmi_set_event_log {
> +	uint32_t	type;		/* IN: type of data in event buffer */
> +	uint16_t	data_len;	/* IN: length of event buffer */
> +	uint8_t		data[0];	/* IN: event data buffer */
> +} __packed;
> +
> +/*
> + * Clear event log
> + *
> + * Valid types are:
> + *   0   : does not clear but returns percent free
> + *   25  : ensure 25% of log is clear
> + *   50  : ensure 50% of log is clear
> + *   75  : ensure 75% of log is clear
> + *   100 : ensure 100% of log is clear
> + */
> +struct gsmi_clear_event_log {
> +	uint32_t	type;		/* IN: clear type */
> +} __packed;
> +
> +/*
> + * These are the various defined SMI callbacks.
> + * They all correspond to a structure defined above
> + * and below and are all used via the same ioctl.
> + * Some of the lower numbers are defined by vendors.
> + * Let's start defining Google-internal callbacks at 0xc0,
> + * a namespace partition that will surely have to be revisited someday.
> + */
> +#define GSMI_CMD_GET_NVRAM_VAR		0x01
> +#define GSMI_CMD_GET_NEXT_VAR		0x02
> +#define GSMI_CMD_SET_NVRAM_VAR		0x03
> +#define GSMI_CMD_SET_EVENT_LOG		0x08
> +#define GSMI_CMD_CLEAR_EVENT_LOG	0x09
> +#define GSMI_CMD_DONOTUSE_15		0x15
> +#define GSMI_CMD_DONOTUSE_16		0x16
> +#define GSMI_CMD_DONOTUSE_17		0x17
> +#define GSMI_CMD_CLEAR_CONFIG		0x20
> +#define GSMI_CMD_NOOP			0xc0
> +#define GSMI_CMD_HANDSHAKE_TYPE		0xc1
> +
> +struct gsmi_ioctl {
> +	uint16_t	length;		/* total length including data */
> +	int		version;	/* structure version */
> +	int		command;	/* ioctl command */

Ick.  Use proper data types if you are going to create a new ioctl.
Same goes for the structures above (hint, use __u32 and friends, not the
unit??_t crap.

I'd strongly suggest NOT creating a new ioctl though, that' just going
to be a pain in the long run.


> +	union {
> +		struct gsmi_get_nvram_var	get_nvram_var;
> +		struct gsmi_get_next_var	get_next_var;
> +		struct gsmi_set_nvram_var	set_nvram_var;
> +		struct gsmi_set_event_log	set_event_log;
> +		struct gsmi_clear_event_log	clear_event_log;
> +	} gsmi_cmd;
> +} __packed;
> +
> +#define GSMI_BASE			'G'
> +#define GSMI_IOCTL_VERSION		1
> +#define GSMI_IOCTL			_IOWR(GSMI_BASE, GSMI_IOCTL_VERSION, \
> +					    struct gsmi_ioctl)
> +
> +#endif /* _LINUX_GSMI_H */
> diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
> index 18fd130..34f5dfa 100644
> --- a/include/linux/miscdevice.h
> +++ b/include/linux/miscdevice.h
> @@ -40,6 +40,7 @@
>  #define BTRFS_MINOR		234
>  #define AUTOFS_MINOR		235
>  #define MAPPER_CTRL_MINOR	236
> +#define GOOGLE_SMI_MINOR	242
>  #define MISC_DYNAMIC_MINOR	255

Why make this a static number and not just use a dynamic one?

thanks,

greg k-h
