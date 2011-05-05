Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab1EEGls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 02:41:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50714 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab1EEGlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 02:41:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM driver
Date: Thu, 5 May 2011 08:41:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com>
In-Reply-To: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105050841.40576.arnd@arndb.de>
X-Provags-ID: V02:K0:wqUQ1IBN0GEVoqzb6See6oTSYreVBfjDYyjhRvhU902
 Bbs+WDBOjYQZsTeNQOP2nALvt52tOyeuzK8VgaL48hWtUnJ9qi
 pSuxZlisWpbvuAFVXrzbNpoilSA4Hof9GUbfgPEkIGtZGCdB49
 Oxj9UsPFjZY/mfHr+8+ge/aSQs85EavBKEd5OQ7m+luAjJhtco
 keI18iijBGucqEzHACUtA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 May 2011, Chris Metcalf wrote:
> This commit does two things: it adds the infrastructure for a new
> arch/tile/drivers/ directory, and it populates it with the first
> instance of a driver for that directory, a SPI Flash ROM (srom) driver.
> 
> The directory is motivated as follows.  While some classes of
> driver implementations should be grouped together so they are easily
> modified as a class (network, ATA, RTC, PCI, I2C, etc etc) there are
> "miscellaneous" drivers that don't benefit from any sharing with other
> driver implementations.  If those drivers are for hardware that can
> plausibly be used by multiple architectures, it makes sense to put
> them somewhere like drivers/char.  But if they are only usable on
> a single architecture (in this case drivers written for the Tilera
> para-virtualization model using our hypervisor) it makes sense to group
> such drivers with their architecture, to avoid cluttering the "drivers"
> hierarchy for other architectures that can't use that driver.

I generally advise against putting any device drivers into arch/*/,
on the ground that it is much easier to find similar drivers when
they are in a common place. We probably have a few similar drivers
in the tree already, e.g drivers/misc/eeprom/* and drivers/char/ps3flash.c
and drivers/platform/x86/intel_scu_ipcutil.c are examples of preexisting
drivers.

I'd probably put this one in driver/misc/eeprom and make the interface
look like the other ones (sysfs bin attribute instead of character
device), which is a trivial change.

Alternatively, you could create drivers/platform/tile to hold tile
specific device drivers, instead of keeping them under arch/tile.

> The actual SROM driver is fairly uncontroversial, and is just a simple
> driver that allows user space to read and write the SROM at a raw level.
> (A separate MTD driver exists for "tile", but this is not that driver.)
> The driver is particularly useful since the Tile chip can boot directly
> from the SROM, so providing this driver interface allows for updating
> the boot image prior to a reboot.

I think the sysfs bin attribute works well here because you don't need
any ioctl, and the contents are basically a representation of a flat
file. The implementation would be almost the same.

> +/**
> + * srom_llseek() - Change the current device offset.
> + * @filp: File for this specific open of the device.
> + * @off: New offset value.
> + * @whence: Base for new offset value.
> + *
> + * Returns new offset, or an error code.
> + */
> +static loff_t srom_llseek(struct file *filp, loff_t off, int whence)
> +{
> +	struct srom_dev *dev = filp->private_data;
> +	long newpos;
> +
> +	switch (whence) {
> +	case 0: /* SEEK_SET */
> +		newpos = off;
> +		break;
> +
> +	case 1: /* SEEK_CUR */
> +		newpos = filp->f_pos + off;
> +		break;
> +
> +	case 2: /* SEEK_END */
> +		newpos = dev->size + off;
> +		break;
> +
> +	default: /* can't happen */
> +		return -EINVAL;
> +	}
> +
> +	if (newpos < 0 || newpos > dev->size)
> +		return -EINVAL;
> +
> +	filp->f_pos = newpos;
> +	return newpos;
> +}

This looks unnecessary, just use generic_file_llseek.
	
	Arnd
