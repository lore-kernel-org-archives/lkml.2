Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0FVUKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 16:10:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421Ab0FVUKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 16:10:06 -0400
Date: Tue, 22 Jun 2010 13:09:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Andries Brouwer <aeb@cwi.nl>, <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Ulf Hansson <ulf.hansson@stericsson.com>
Subject: Re: [PATCH] Add commandline partitions for block devices v2
Message-Id: <20100622130915.16ad67cd.akpm@linux-foundation.org>
In-Reply-To: <1275997141-25419-1-git-send-email-linus.walleij@stericsson.com>
References: <1275997141-25419-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010 13:39:01 +0200
Linus Walleij <linus.walleij@stericsson.com> wrote:

> From: Ulf Hansson <ulf.hansson@stericsson.com>
> 
> This adds an option to pass in block device partitions from the kernel
> cmdline.
> 
> The rationale is that in embedded systems we sometimes have no standard
> partition table available: often due to the fact that raw binary data is
> read out from the first sectors of the device by ROM code in ASICs. We
> have for a long time supplied custom partition information to embedded
> flash memories through the MTDparts interface which has similar
> semantics, and with the advent of embedded MMC block devices this now
> comes to standard block devices.
> 
> Reviewed-by: Linus Walleij <linus.walleij@stericsson.com>
> Signed-off-by: Ulf Hansson <ulf.hansson@stericsson.com>

This should include your Signed-off-by: as well, since you were on the
patch delivery path.

> Changes v1->v2:
> - Changed file permissions to 644 in blkdev_parts.[c|h]
> - Changed a printk() to include a hint that this comes from
>   blkdev_parts
> - Ready for merging? Andries, you are listed as maintainer for
>   the partitions, will you take this patch?
> ---
>  fs/partitions/Kconfig        |   19 ++++++
>  fs/partitions/Makefile       |    1 +
>  fs/partitions/blkdev_parts.c |  127 ++++++++++++++++++++++++++++++++++++++++++
>  fs/partitions/blkdev_parts.h |   14 +++++
>  fs/partitions/check.c        |    4 +
>  5 files changed, 165 insertions(+), 0 deletions(-)
>  create mode 100644 fs/partitions/blkdev_parts.c
>  create mode 100644 fs/partitions/blkdev_parts.h
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
> +
> +	  Example:
> +	  blkdevparts=mmc0:1024@0,524288@1024;mmc1:8192@0,8192@8192

This is a bit terse, and perhaps the Kconfig file was not the best
place to document the feature.  I'd suggest a standalone file in
Documentation/block[dev]/.  Then add a pointer to that documentation
within the Kconfig help record and in
Documentation/kernel-parameters.txt.

Because it does need more explanation and perhaps more examples, IMO. 
I'm particularly scratching my head over the dynamic behaviour.  This
code will get reexecuted each time the kernel runs rescan_partitions(),
no?  For example ioctl(BLKRRPART).  What happens then and under which
circumstances is that a non-insane thing to do.


>  config OSF_PARTITION
>  	bool "Alpha OSF partition support" if PARTITION_ADVANCED
>  	default y if ALPHA
> diff --git a/fs/partitions/Makefile b/fs/partitions/Makefile
> index 03af8ea..48b216c 100644
> --- a/fs/partitions/Makefile
> +++ b/fs/partitions/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_BLOCK) := check.o
>  obj-$(CONFIG_ACORN_PARTITION) += acorn.o
>  obj-$(CONFIG_AMIGA_PARTITION) += amiga.o
>  obj-$(CONFIG_ATARI_PARTITION) += atari.o
> +obj-$(CONFIG_BLKDEV_PARTITION) += blkdev_parts.o
>  obj-$(CONFIG_MAC_PARTITION) += mac.o
>  obj-$(CONFIG_LDM_PARTITION) += ldm.o
>  obj-$(CONFIG_MSDOS_PARTITION) += msdos.o
> diff --git a/fs/partitions/blkdev_parts.c b/fs/partitions/blkdev_parts.c
> new file mode 100644
> index 0000000..b1c6297
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
> +
> +/*
> + * This is the handler for our kernel commandline parameter,
> + * called from main.c::checksetup().
> + * Note that we can not yet kmalloc() anything, so we only save
> + * the commandline for later processing.
> + */
> +static int cmdline_setup(char *s)
> +{
> +	cmdline = s;
> +	return 1;
> +}
> +__setup("blkdevparts=", cmdline_setup);

Is the string at *s preserved for all time on all architectures?  It
seems that way.

This function should be __init.

> +/* Parse for a matching blkdev-id and return pointer to partdef */
> +static char *parse_blkdev_id(char *blkdev_name)
> +{
> +	int blkdev_id_len;
> +	char *p, *blkdev_id;
> +
> +	/* Start parsing for a matching blkdev-id */
> +	p = blkdev_id = cmdline;
> +	while (blkdev_id != NULL) {
> +
> +		/* Find the end of the blkdev-id string */
> +		p = strchr(blkdev_id, ':');
> +		if (p == NULL)
> +			return NULL;
> +
> +		/* Check if we found a matching blkdev-id */
> +		blkdev_id_len = p - blkdev_id;
> +		if (strlen(blkdev_name)	== blkdev_id_len) {
> +			if (strncmp(blkdev_name, blkdev_id, blkdev_id_len) == 0)
> +				return p;
> +		}
> +
> +		/* Move to next blkdev-id string if there is one */
> +		blkdev_id = strchr(p, ';');
> +		if (blkdev_id != NULL)
> +			blkdev_id++;
> +	}
> +	return NULL;
> +}

See, the documentation didn't tell me what a "blkkdev-id" is.  How does
the user determine the blkdev-id of his devide so he knows how to
configure his command line?

> +static int parse_partdef(char **part, struct parsed_partitions *state, int part_nbr)
> +{
> +	sector_t size, offset;
> +	char *p = *part;
> +
> +	/* Skip the beginning "," or ":" */
> +	p++;
> +
> +	/* Fetch and verify size from partdef */
> +	size = simple_strtoull(p, &p, 10);
> +	if ((size == 0) || (*p != '@'))
> +		return 0;
> +
> +	/* Skip the "@" */
> +	p++;
> +
> +	/* Fetch offset from partdef and check if there are more parts */
> +	offset = simple_strtoull(p, &p, 10);
> +	if (*p == ',')
> +		*part = p;
> +	else
> +		*part = NULL;
> +
> +	/* Add partition to state */
> +	put_partition(state, part_nbr, offset, size);
> +	printk(KERN_INFO "\nPartition: size=%llu, offset=%llu\n",
> +		(unsigned long long) size,
> +		(unsigned long long) offset);
> +	return 1;
> +}

Is all this code warning-free and tested on 32-bit CONFIG_LBDAF=n? 
>From the above typecasts I assume "yes, at some stage".

> +static int parse_blkdev_parts(char *blkdev_name, struct parsed_partitions *state)
> +{
> +	char *partdef;
> +	int part_nbr = 0;
> +
> +	/* Find partdef */
> +	partdef = parse_blkdev_id(blkdev_name);
> +
> +	/* Add parts */
> +	while (partdef != NULL) {
> +		/* Find next part and add it to state */
> +		part_nbr++;
> +		if (!parse_partdef(&partdef, state, part_nbr))
> +			return 0;
> +	}
> +	return part_nbr;
> +}
> +
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
> +		printk(KERN_WARNING "blkdevparts: Could not get a blkdev name\n");
> +		return 0;
> +	}
> +
> +	/* Parse for partitions and add them to the state */
> +	return parse_blkdev_parts(blkdev_name, state);
> +}

It kinda sucks that all this new code cannot be __init.  If, as I
suspect, there is no valid post-boot use case for this code then
perhaps we can somehow arrange for it to get tossed away at
free_initmem() time.  That'll probably cause a build-time sections
warning however we do it :(
