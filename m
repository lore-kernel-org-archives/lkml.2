Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2F2VZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 17:25:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab2F2VZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 17:25:41 -0400
Date: Sat, 30 Jun 2012 07:25:19 +1000
From: NeilBrown <neilb@suse.de>
To: Andrew Boie <andrew.p.boie@intel.com>
Cc: gregkh@linuxfoundation.org, ccross@android.com, arve@android.com,
        rebecca@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcb: Android bootloader control block driver
Message-ID: <20120630072519.71835f43@notabene.brown>
In-Reply-To: <1340998590-23042-1-git-send-email-andrew.p.boie@intel.com>
References: <1340998590-23042-1-git-send-email-andrew.p.boie@intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.iVllnukMhZR.Hj7WeNKNbj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.iVllnukMhZR.Hj7WeNKNbj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Jun 2012 12:36:30 -0700 Andrew Boie <andrew.p.boie@intel.com>
wrote:

> Android userspace tells the kernel that it wants to boot into recovery
> or some other non-default OS environment by passing a string argument
> to reboot(). It is left to the OEM to hook this up to their specific
> bootloader.
>=20
> This driver uses the bootloader control block (BCB) in the 'misc'
> partition, which is the AOSP mechanism used to communicate with
> the bootloader. Writing 'bootonce-NNN' to the command field
> will cause the bootloader to do a oneshot boot into an alternate
> boot label NNN if it exists. The device and partition number are
> passed in via kernel command line.
>=20
> It is the bootloader's job to guard against this area being uninitialzed
> or containing an invalid boot label, and just boot normally if that
> is the case. The bootloader will always populate a magic signature in
> the BCB; the driver will refuse to update it if not present.
>=20
> Signed-off-by: Andrew Boie <andrew.p.boie@intel.com>

Maybe I'm missing something obvious, but why does this need to be implement=
ed
in the kernel?  Can't some user-space process just write to that partition
using open/read/seek/write/close before calling 'reboot'.

Thanks,
NeilBrown



> ---
>  drivers/staging/android/Kconfig  |   11 ++
>  drivers/staging/android/Makefile |    1 +
>  drivers/staging/android/bcb.c    |  232 ++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 244 insertions(+)
>  create mode 100644 drivers/staging/android/bcb.c
>=20
> diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kc=
onfig
> index 9a99238..c30fd20 100644
> --- a/drivers/staging/android/Kconfig
> +++ b/drivers/staging/android/Kconfig
> @@ -78,6 +78,17 @@ config ANDROID_INTF_ALARM_DEV
>  	  elapsed realtime, and a non-wakeup alarm on the monotonic clock.
>  	  Also exports the alarm interface to user-space.
> =20
> +config BOOTLOADER_CONTROL
> +	tristate "Bootloader Control Block module"
> +	default n
> +	help
> +	  This driver installs a reboot hook, such that if reboot() is invoked
> +	  with a string argument NNN, "bootonce-NNN" is copied to the command
> +	  field in the Bootloader Control Block on the /misc partition, to be
> +	  read by the bootloader. If the string matches one of the boot labels
> +	  defined in its configuration, it will boot once into that label. The
> +	  device and partition number are specified on the kernel command line.
> +
>  endif # if ANDROID
> =20
>  endmenu
> diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/M=
akefile
> index 8e18d4e..a27707f 100644
> --- a/drivers/staging/android/Makefile
> +++ b/drivers/staging/android/Makefile
> @@ -9,5 +9,6 @@ obj-$(CONFIG_ANDROID_LOW_MEMORY_KILLER)	+=3D lowmemorykil=
ler.o
>  obj-$(CONFIG_ANDROID_SWITCH)		+=3D switch/
>  obj-$(CONFIG_ANDROID_INTF_ALARM_DEV)	+=3D alarm-dev.o
>  obj-$(CONFIG_PERSISTENT_TRACER)		+=3D trace_persistent.o
> +obj-$(CONFIG_BOOTLOADER_CONTROL)	+=3D bcb.o
> =20
>  CFLAGS_REMOVE_trace_persistent.o =3D -pg
> diff --git a/drivers/staging/android/bcb.c b/drivers/staging/android/bcb.c
> new file mode 100644
> index 0000000..af75257
> --- /dev/null
> +++ b/drivers/staging/android/bcb.c
> @@ -0,0 +1,232 @@
> +/*
> + * bcb.c: Reboot hook to write bootloader commands to
> + *        the Android bootloader control block
> + *
> + * (C) Copyright 2012 Intel Corporation
> + * Author: Andrew Boie <andrew.p.boie@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/blkdev.h>
> +#include <linux/reboot.h>
> +
> +#define BCB_MAGIC	0xFEEDFACE
> +
> +/* Persistent area written by Android recovery console and Linux bcb dri=
ver
> + * reboot hook for communication with the bootloader. Bootloader must
> + * gracefully handle this area being unitinitailzed */
> +struct bootloader_message {
> +	/* Directive to the bootloader on what it needs to do next.
> +	 * Possible values:
> +	 *   boot-NNN - Automatically boot into label NNN
> +	 *   bootonce-NNN - Automatically boot into label NNN, clearing this
> +	 *     field afterwards
> +	 *   anything else / garbage - Boot default label */
> +	char command[32];
> +
> +	/* Storage area for error codes when using the BCB to boot into special
> +	 * boot targets, e.g. for baseband update. Not used here. */
> +	char status[32];
> +
> +	/* Area for recovery console to stash its command line arguments
> +	 * in case it is reset and the cache command file is erased.
> +	 * Not used here. */
> +	char recovery[1024];
> +
> +	/* Magic sentinel value written by the bootloader; don't update this
> +	 * if not equalto to BCB_MAGIC */
> +	uint32_t magic;
> +};
> +
> +/* TODO: device names/partition numbers are unstable. Add support for lo=
oking
> + * by GPT partition UUIDs */
> +static char *bootdev =3D "sda";
> +module_param(bootdev, charp, S_IRUGO);
> +MODULE_PARM_DESC(bootdev, "Block device for bootloader communication");
> +
> +static int partno;
> +module_param(partno, int, S_IRUGO);
> +MODULE_PARM_DESC(partno, "Partition number for bootloader communication"=
);
> +
> +static int device_match(struct device *dev, void *data)
> +{
> +	if (strcmp(dev_name(dev), bootdev) =3D=3D 0)
> +		return 1;
> +	return 0;
> +}
> +
> +static struct block_device *get_emmc_bdev(void)
> +{
> +	struct block_device *bdev;
> +	struct device *disk_device;
> +
> +	disk_device =3D class_find_device(&block_class, NULL, NULL, device_matc=
h);
> +	if (!disk_device) {
> +		pr_err("bcb: device %s not found!\n", bootdev);
> +		return NULL;
> +	}
> +	bdev =3D bdget_disk(dev_to_disk(disk_device), partno);
> +	if (!bdev) {
> +		dev_err(disk_device, "bcb: unable to get disk (%s,%d)\n",
> +				bootdev, partno);
> +		return NULL;
> +	}
> +	/* Note: this bdev ref will be freed after first
> +	   bdev_get/bdev_put cycle */
> +	return bdev;
> +}
> +
> +static u64 last_lba(struct block_device *bdev)
> +{
> +	if (!bdev || !bdev->bd_inode)
> +		return 0;
> +	return div_u64(bdev->bd_inode->i_size,
> +		       bdev_logical_block_size(bdev)) - 1ULL;
> +}
> +
> +static size_t read_lba(struct block_device *bdev,
> +		       u64 lba, u8 *buffer, size_t count)
> +{
> +	size_t totalreadcount =3D 0;
> +	sector_t n =3D lba * (bdev_logical_block_size(bdev) / 512);
> +
> +	if (!buffer || lba > last_lba(bdev))
> +		return 0;
> +
> +	while (count) {
> +		int copied =3D 512;
> +		Sector sect;
> +		unsigned char *data =3D read_dev_sector(bdev, n++, &sect);
> +		if (!data)
> +			break;
> +		if (copied > count)
> +			copied =3D count;
> +		memcpy(buffer, data, copied);
> +		put_dev_sector(sect);
> +		buffer +=3D copied;
> +		totalreadcount +=3D copied;
> +		count -=3D copied;
> +	}
> +	return totalreadcount;
> +}
> +
> +static size_t write_lba(struct block_device *bdev,
> +		       u64 lba, u8 *buffer, size_t count)
> +{
> +	size_t totalwritecount =3D 0;
> +	sector_t n =3D lba * (bdev_logical_block_size(bdev) / 512);
> +
> +	if (!buffer || lba > last_lba(bdev))
> +		return 0;
> +
> +	while (count) {
> +		int copied =3D 512;
> +		Sector sect;
> +		unsigned char *data =3D read_dev_sector(bdev, n++, &sect);
> +		if (!data)
> +			break;
> +		if (copied > count)
> +			copied =3D count;
> +		memcpy(data, buffer, copied);
> +		set_page_dirty(sect.v);
> +		unlock_page(sect.v);
> +		put_dev_sector(sect);
> +		buffer +=3D copied;
> +		totalwritecount +=3D copied;
> +		count -=3D copied;
> +	}
> +	sync_blockdev(bdev);
> +	return totalwritecount;
> +}
> +
> +static int bcb_reboot_notifier_call(
> +		struct notifier_block *notifier,
> +		unsigned long what, void *data)
> +{
> +	int ret =3D NOTIFY_DONE;
> +	char *cmd =3D (char *)data;
> +	struct block_device *bdev =3D NULL;
> +	struct bootloader_message *bcb =3D NULL;
> +
> +	if (what !=3D SYS_RESTART || !data)
> +		goto out;
> +
> +	bdev =3D get_emmc_bdev();
> +	if (!bdev)
> +		goto out;
> +
> +	/* make sure the block device is open rw */
> +	if (blkdev_get(bdev, FMODE_READ | FMODE_WRITE, NULL) < 0) {
> +		pr_err("bcb: blk_dev_get failed!\n");
> +		goto out;
> +	}
> +
> +	bcb =3D kmalloc(sizeof(*bcb), GFP_KERNEL);
> +	if (!bcb) {
> +		pr_err("bcb: out of memory\n");
> +		goto out;
> +	}
> +
> +	if (read_lba(bdev, 0, (u8 *)bcb, sizeof(*bcb)) !=3D sizeof(*bcb)) {
> +		pr_err("bcb: couldn't read bootloader control block\n");
> +		goto out;
> +	}
> +
> +	if (bcb->magic !=3D BCB_MAGIC) {
> +		pr_err("bcb: bootloader control block corrupted, not writing\n");
> +		goto out;
> +	}
> +
> +	/* When the bootloader reads this area, it will null-terminate it
> +	* and check if it matches any existing boot labels */
> +	snprintf(bcb->command, sizeof(bcb->command), "bootonce-%s", cmd);
> +
> +	if (write_lba(bdev, 0, (u8 *)bcb, sizeof(*bcb)) !=3D sizeof(*bcb)) {
> +		pr_err("bcb: couldn't write bootloader control block\n");
> +		goto out;
> +	}
> +
> +	ret =3D NOTIFY_OK;
> +out:
> +	kfree(bcb);
> +	if (bdev)
> +		blkdev_put(bdev, FMODE_READ | FMODE_WRITE);
> +
> +	return ret;
> +}
> +
> +static struct notifier_block bcb_reboot_notifier =3D {
> +	.notifier_call =3D bcb_reboot_notifier_call,
> +};
> +
> +static int __init bcb_init(void)
> +{
> +	if (partno < 1) {
> +		pr_err("bcb: partition number not specified\n");
> +		return -1;
> +	}
> +	if (register_reboot_notifier(&bcb_reboot_notifier)) {
> +		pr_err("bcb: unable to register reboot notifier\n");
> +		return -1;
> +	}
> +	pr_info("bcb: writing commands to (%s,%d)\n",
> +			bootdev, partno);
> +	return 0;
> +}
> +module_init(bcb_init);
> +
> +static void __exit bcb_exit(void)
> +{
> +	unregister_reboot_notifier(&bcb_reboot_notifier);
> +}
> +module_exit(bcb_exit);
> +
> +MODULE_AUTHOR("Andrew Boie <andrew.p.boie@intel.com>");
> +MODULE_DESCRIPTION("bootloader communication module");
> +MODULE_LICENSE("GPL v2");


--Sig_/.iVllnukMhZR.Hj7WeNKNbj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+4dPznsnt1WYoG5AQKayw//bLpknvsmu6WUh7nVlSRCM1BcplWNukUk
ToqS6HABfoZeGbE7ahf0Ecdtdrkp57fQV+GLBBlxGvWH9sAcCnybayli67qYtJ4U
xbaq+NZJha9cq1IWO0LS/zyDDOaPtTUaE+TtqVSCnVNithHcUbZ9MDgk9Uzr0Gfh
OSEO3aei+nT+sEPKV+kU9h576wDBzhy6RuzRNnMHLK54WTj1fmZKAoUohYc574hn
tu3YTBUyoOJSIwctyrphVtJCZgKb9HdJ+mVa7TOA6p7h8Zi290ZHJMaRnFi4loaE
X8Uk5VAhCOYksKLEWVdR/9dcNCTFKa6HQkIfJlJJ5pXz3OkIO+ReHdveK8xqc4ft
f4wQLUPZx2flcLFewYoVaBAD8y5mBE9Va3OcEIOu8hp6j6dmptYKT9LdxeK9nBma
Jk8rpx5DUmPetSlFLEKnpBDpFNkmhdDER2EZyJXHWKkD/T23oCVF6G+9LYE/2CJe
GcLhCCH9QfZlM3o0zoxshHNH+F5Q78uTZCcnFOZnoR852cej4dDq6VFqYG5b7hd4
gdVHJ0bzCD+FjFAnW5uQ6ud1TmCV6eLHhFrfEAm22PfyNAzh0bL9v2mwGV6VW76Z
2n5Q2XMDXYlIXPlz34TYxpIFmAOJCGnuJT/fcpGEL2f49NjZz2Qcn1wMG122omol
Zng/XV0thaE=
=tFvY
-----END PGP SIGNATURE-----

--Sig_/.iVllnukMhZR.Hj7WeNKNbj--
