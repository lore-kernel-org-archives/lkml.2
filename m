Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab0KBRTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 13:19:21 -0400
Received: from xenotime.net ([72.52.115.56]:48759 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754298Ab0KBRTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 13:19:15 -0400
Date: Tue, 2 Nov 2010 10:19:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Subject: Re: [PATCH] drivers/i2c: add support for tile architecture "bus"
 for I2C devices
Message-Id: <20101102101912.3df5012c.rdunlap@xenotime.net>
In-Reply-To: <201011021712.oA2HCsMe028141@farm-0010.internal.tilera.com>
References: <201011021712.oA2HCsMe028141@farm-0010.internal.tilera.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Nov 2010 13:05:34 -0400 Chris Metcalf wrote:

> This change enables the Linux driver to access i2c devices via
> the Tilera hypervisor's virtualized API.
> 
> Note that the arch/tile/include/hv/ headers are "upstream" headers
> that likely benefit less from LKML review.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/include/hv/drv_i2cm_intf.h |   68 +++++++
>  drivers/i2c/busses/Kconfig           |   10 +
>  drivers/i2c/busses/Makefile          |    1 +
>  drivers/i2c/busses/i2c-tile.c        |  324 ++++++++++++++++++++++++++++++++++
>  4 files changed, 403 insertions(+), 0 deletions(-)
>  create mode 100644 arch/tile/include/hv/drv_i2cm_intf.h
>  create mode 100644 drivers/i2c/busses/i2c-tile.c
> 
> diff --git a/arch/tile/include/hv/drv_i2cm_intf.h b/arch/tile/include/hv/drv_i2cm_intf.h
> new file mode 100644
> index 0000000..6584a72
> --- /dev/null
> +++ b/arch/tile/include/hv/drv_i2cm_intf.h
> @@ -0,0 +1,68 @@
> +/*
> + * Copyright 2010 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +
> +/**

In kernel source code, "/**" is used to begin kernel-doc notation blocks.
Please don't use it for non-kernel-doc comments.

(multiple times...)

> + * @file drv_i2cm_intf.h
> + * Interface definitions for the I2CM driver.
> + *
> + * The I2C Master interface driver provides a manner for supervisors to
> + * access the I2C devices on the I2C bus.
> + *
> + * When the supervisor issues an I2C data transaction, it stores the i2c
> + * device slave address and the data offset within the device in the offset
> + * of the HV I2C device handle. The low half-word contains the slave address
> + * while the data offset is stored in byte 2 and 3. For the write access,
> + * the first 1 or 2 bytes of the write data contain the device data address
> + * if the data offset field of the HV device handle offset is 0; otherwise,
> + * the write data are puse data payload. For the read access, it is always
> + * preceded by a dummy write access which should contain an either 1-byte or
> + * 2-byte device data address while the read message holds no addressing
> + * information.
> + */
> +
> +#ifndef _SYS_HV_INCLUDE_DRV_I2CM_INTF_H
> +#define _SYS_HV_INCLUDE_DRV_I2CM_INTF_H
> +
> +/** Maximum size of an HV I2C transfer. */
> +#define HV_I2CM_CHUNK_SIZE 128
> +
> +/** Length of the i2c device name. */
> +#define I2C_DEV_NAME_SIZE   20
> +
> +/** I2C device descriptor, to be exported to the client OS. */
> +typedef struct
> +{
> +  char name[I2C_DEV_NAME_SIZE];   /**< Device name, e.g. "24c512". */
> +  uint32_t addr;                  /**< I2C device slave address */
> +}
> +tile_i2c_desc_t;

+ } tile_i2c_desc_t;
(i.e., join those 2 lines)

> +
> +/** Get the number of i2c devices. Read-only, takes a 4-byte value. */
> +#define I2C_GET_NUM_DEVS_OFF   0xF0000000
> +
> +/** Get i2c device info. Read-only, takes an array of tile_i2c_desc_t's. */
> +#define I2C_GET_DEV_INFO_OFF   0xF0000004
> +
> +/** This structure is used to encode the I2C device slave address
> + *  and the chip data offset and is passed to the HV in the offset
> + *  of the i2cm HV device file.
> + */
> +typedef struct
> +{
> +  uint32_t addr:8;               /**< I2C device slave address */
> +  uint32_t data_offset:24;       /**< I2C device data offset */
> +}
> +tile_i2c_addr_desc_t;

ditto.  (assuming that typedefs are even accepted)

> +
> +#endif /* _SYS_HV_INCLUDE_DRV_I2CM_INTF_H */



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
