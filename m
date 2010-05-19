Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab0ESTra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:47:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27927 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0ESTr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:47:29 -0400
Date: Wed, 19 May 2010 12:46:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Andries Brouwer <aeb@cwi.nl>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Added commandline partitions for block devices
Message-Id: <20100519124608.485a6f68.randy.dunlap@oracle.com>
In-Reply-To: <1274256495-8699-1-git-send-email-ulf.hansson@stericsson.com>
References: <1274256495-8699-1-git-send-email-ulf.hansson@stericsson.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090209.4BF4404A.01ED:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 10:08:15 +0200 Ulf Hansson wrote:

> This adds an option to pass in block device partitions from the
> kernel cmdline.
> 
> The rationale is that in embedded systems we sometimes have no
> standard partition table available: often due to the fact that raw
> binary data is read out from the first sectors of the device by
> ROM code in ASICs. We have for a long time supplied custom partition
> information to embedded flash memories through the MTDparts interface
> which has similar semantics, and with the advent of embedded MMC
> block devices this now comes to standard block devices.
> 
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> Signed-off-by: Ulf Hansson <ulf.hansson@stericsson.com>
> ---
>  fs/partitions/Kconfig        |   19 ++++++
>  fs/partitions/Makefile       |    1 +
>  fs/partitions/blkdev_parts.c |  127 ++++++++++++++++++++++++++++++++++++++++++
>  fs/partitions/blkdev_parts.h |   14 +++++
>  fs/partitions/check.c        |    4 +
>  5 files changed, 165 insertions(+), 0 deletions(-)
>  create mode 100755 fs/partitions/blkdev_parts.c
>  create mode 100755 fs/partitions/blkdev_parts.h
> 
> diff --git a/fs/partitions/Kconfig b/fs/partitions/Kconfig
> index cb5f0a3..097be19 100644
> --- a/fs/partitions/Kconfig
> +++ b/fs/partitions/Kconfig
> @@ -68,6 +68,25 @@ config ACORN_PARTITION_RISCIX
>  	  of machines called RISCiX.  If you say 'Y' here, Linux will be able
>  	  to read disks partitioned under RISCiX.
>  
> +config BLKDEV_PARTITION
> +	bool "Blockdev commandline partition support" if PARTITION_ADVANCED

	               command line

> +	default n
> +	help
> +	  Say Y if you like to setup partitions for block devices by reading
> +	  from the kernel command line (kernel boot arguments).
> +
> +	  The format of the partitions on the command line:
> +	  blkdevparts=<blkdev-def>[;<blkdev-def>]
> +	  <blkdev-def> := <blkdev-id>:<partdef>[,<partdef>]
> +	  <partdef>    := <size>[@<offset>]
> +
> +	  <blkdev-id>  := unique id used to map driver to blockdev name
> +	  <size>       := size in numbers of sectors
> +	  <offset>     := offset in sectors for partition to start at

Are MMC sectors always a known, fixed size?  512 bytes or 4096 bytes?


> +
> +	  Example:
> +	  blkdevparts=mmc0:1024@0,524288@1024;mmc1:8192@0,8192@8192
> +
>  config OSF_PARTITION
>  	bool "Alpha OSF partition support" if PARTITION_ADVANCED
>  	default y if ALPHA

> diff --git a/fs/partitions/blkdev_parts.c b/fs/partitions/blkdev_parts.c
> new file mode 100755
> index 0000000..48f4136
> --- /dev/null
> +++ b/fs/partitions/blkdev_parts.c
> @@ -0,0 +1,127 @@
> +/*
> + *
> + * Copyright (C) ST-Ericsson SA 2010
> + *
> + * Author: Ulf Hansson <ulf.hansson@stericsson.com> for ST-Ericsson
> + * License terms: GNU General Public License (GPL) version 2
> + *
> + * Create partitions for block devices by reading from the kernel
> + * command line (kernel boot arguments).
> + *
> + */
> +
> +#include "check.h"
> +#include "blkdev_parts.h"
> +
> +static char *cmdline;

> +int blkdev_partition(struct parsed_partitions *state, struct block_device *bdev)
> +{
> +	char blkdev_name[BDEVNAME_SIZE];
> +
> +	/* Check if there are any partitions to handle */
> +	if (cmdline == NULL)
> +		return 0;
> +
> +	/* Get the name of the blockdevice we are operating upon */
> +	if (bdevname(bdev, blkdev_name) == NULL) {
> +		printk(KERN_WARNING "Could not get a blkdev name\n");

Needs some message source id; maybe:
		printk(KERN_WARNING "blkdevparts: Could not get a blkdev name\n");

> +		return 0;
> +	}
> +
> +	/* Parse for partitions and add them to the state */
> +	return parse_blkdev_parts(blkdev_name, state);
> +}


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
