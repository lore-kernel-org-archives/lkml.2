Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162993Ab2GMNDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 09:03:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34900 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162577Ab2GMNDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 09:03:41 -0400
Date: Fri, 13 Jul 2012 15:03:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
Message-ID: <20120713130336.GC10298@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	=?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
	Steve Hodgson <steve@purestorage.com>
References: <20120424205946.GH20610@logfs.org>
 <x49zka0j5bk.fsf@segfault.boston.devel.redhat.com>
 <20120425132513.GA23492@logfs.org>
 <x49vcknkdvn.fsf@segfault.boston.devel.redhat.com>
 <20120712174633.GA7248@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120712174633.GA7248@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 01:46:34PM -0400, Jörn Engel wrote:
> Console driver similar to netconsole, except it writes to a block
> device.  Can be useful in a setup where netconsole, for whatever
> reasons, is impractical.
> 
> Changes since version 1.0:
> - Header format overhaul, addressing several annoyances when actually
>   using blockconsole for production.
> - Steve Hodgson added a panic notifier.
> 
> Signed-off-by: Steve Hodgson <steve@purestorage.com>
> Signed-off-by: Joern Engel <joern@logfs.org>
> ---
>  Documentation/block/blockconsole.txt            |   75 +++
>  Documentation/block/blockconsole/bcon_tail      |   52 ++
>  Documentation/block/blockconsole/mkblockconsole |   24 +
>  block/partitions/Makefile                       |    1 +
>  block/partitions/blockconsole.c                 |   22 +
>  block/partitions/check.c                        |    4 +
>  drivers/block/Kconfig                           |    5 +
>  drivers/block/Makefile                          |    1 +
>  drivers/block/blockconsole.c                    |  606 +++++++++++++++++++++++
>  include/linux/mount.h                           |    2 +-
>  init/do_mounts.c                                |    4 +-
>  11 files changed, 793 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/block/blockconsole.txt
>  create mode 100755 Documentation/block/blockconsole/bcon_tail
>  create mode 100755 Documentation/block/blockconsole/mkblockconsole
>  create mode 100644 block/partitions/blockconsole.c
>  create mode 100644 drivers/block/blockconsole.c
> 
> diff --git a/Documentation/block/blockconsole.txt b/Documentation/block/blockconsole.txt
> new file mode 100644
> index 0000000..a906e61
> --- /dev/null
> +++ b/Documentation/block/blockconsole.txt
> @@ -0,0 +1,75 @@
> +
> +started by Jörn Engel <joern@logfs.org> 2012.03.17
> +
> +Introduction:
> +=============
> +
> +This module logs kernel printk messages to block devices, e.g. usb
> +sticks.  It allows after-the-fact debugging when the main
> +disk/filesystem fails and serial consoles and netconsole are
> +impractical.
> +
> +It can currently only be used built-in.

If so, you need to change the tristate in Kconfig below to bool.

> Blockconsole hooks into the
> +partition scanning code and will bring up configured block devices as
> +soon as possible.  While this doesn't allow capture of early kernel
> +panics, it does capture most of the boot process.
> +
> +Block device configuration:
> +==================================
> +
> +Blockconsole has no configuration parameter.  In order to use a block
> +device for logging, the blockconsole header has to be written to the
> +device in questions.

	     question.

> Logging to partitions is not supported.

That could be useful though. We have a setup here where we create a
partition on the block device and install the OS there for testing
purposes while leaving room on the device after it for other OS installs
and other people to test stuff.

If blockconsole could log to partitions, one could create an additional
small partition exactly for such logs.

I don't know how much work adding logging to partitions is though.

> +
> +The example program mkblockconsole can be used to generate such a
> +header on a device.
> +
> +Header format:
> +==============
> +
> +A legal header looks like this:
> +
> +Linux blockconsole version 1.1
> +818cf322
> +00000000
> +00000000
> +
> +It consists of a newline, the "Linux blockconsole version 1.1" string
> +plus three numbers on seperate lines each.  Numbers are all 32bit,

			separate

> +represented as 8-byte hex strings, with letters in lowercase.  The
> +first number is a uuid for this particular console device.  Just pick
> +a random number when generating the device.  The second number is a
> +wrap counter and unlikely to ever increment.  The third is a tile
> +counter, with a tile being one megabyte in size.
> +
> +Miscellaneous notes:
> +====================
> +
> +Blockconsole will write a new header for every tile or once every
> +megabyte.  The header starts with a newline in order to ensure the
> +"Linux blockconsole...' string always ends up at the beginning of a
> +line if you read the blockconsole in a text editor.
> +
> +The blockconsole header is constructed such that opening the log
> +device in a text editor, ignoring memory constraints due to large
> +devices, should just work and be reasonably non-confusing to readers.
> +However, the example program bcon_tail can be used to copy the last 16
> +tiles of the log device to /var/log/bcon.<uuid>, which should be much
> +easier to handle.
> +
> +The wrap counter is used by blockconsole to determine where to
> +continue logging after a reboot.  New logs will be written to the
> +first tile that wasn't written to by the last instance of
> +blockconsole.  Similarly bcon_tail is doing a binary search to find
> +the end of the log.
> +
> +Writing to the log device is strictly circular.  This should give
> +optimal performance and reliability on cheap devices, like usb sticks.
> +
> +Writing to block devices has to happen in sector granularity, while
> +kernel logging happens in byte granularity.  In order not to lose
> +messages in important cases like kernel crashes, a timer will write
> +out partial sectors if no new messages appear for a while.  The
> +unwritten part of the sector will be filled with spaces and a single
> +newline.  In a quiet system, these empty lines can make up the bulk of
> +the log.
> diff --git a/Documentation/block/blockconsole/bcon_tail b/Documentation/block/blockconsole/bcon_tail
> new file mode 100755
> index 0000000..950bfd1
> --- /dev/null
> +++ b/Documentation/block/blockconsole/bcon_tail
> @@ -0,0 +1,52 @@
> +#!/bin/bash
> +
> +TAIL_LEN=16
> +TEMPLATE=/tmp/bcon_template
> +BUF=/tmp/bcon_buf
> +
> +end_of_log() {
> +	DEV=$1
> +	UUID=`head -c40 $DEV|tail -c8`
> +	LOGFILE=/var/log/bcon.$UUID
> +	SECTORS=`hdparm -g $DEV|grep sectors|sed 's/.*sectors = \([0-9]*\).*/\1/'`
> +	#MSIZE=`expr $SECTORS / 2048`
> +	dd if=$DEV iflag=direct bs=512 2>/dev/null|head -c50 > $TEMPLATE
> +	#START, MIDDLE and END are in sectors
> +	START=0
> +	MIDDLE=$SECTORS
> +	END=$SECTORS
> +	while true; do
> +		MIDDLE=`expr \( \( $END + $START \) / 4096 \) \* 2048`
> +		if [ $MIDDLE -eq $START ]; then
> +			break
> +		fi
> +		dd if=$DEV iflag=direct bs=512 count=1 skip=$MIDDLE 2>/dev/null|head -c50 > $BUF
> +		if diff -q $BUF $TEMPLATE > /dev/null; then
> +			START=$MIDDLE
> +		else
> +			END=$MIDDLE
> +		fi
> +	done
> +	#switch to megabytes
> +	END=`expr $END / 2048`
> +	START=`expr $START / 2048`
> +	if [ $START -lt $TAIL_LEN ]; then
> +		START=0
> +	else
> +		START=`expr $START - $TAIL_LEN + 1`
> +	fi
> +	LEN=`expr $END - $START`
> +	dd if=$DEV iflag=direct bs=1M count=$LEN skip=$START >$LOGFILE 2>/dev/null
> +	echo $LOGFILE
> +}
> +
> +# HEADER contains a newline, so the funny quoting is necessary
> +HEADER='
> +Linux blockconsole version 1.1'
> +CANDIDATES=`lsscsi |sed 's|.*/dev|/dev|'`
> +
> +for DEV in $CANDIDATES; do
> +	if [ "`head -c32 $DEV`" == "$HEADER" ]; then
> +		end_of_log $DEV
> +	fi
> +done
> diff --git a/Documentation/block/blockconsole/mkblockconsole b/Documentation/block/blockconsole/mkblockconsole
> new file mode 100755
> index 0000000..d9514e7
> --- /dev/null
> +++ b/Documentation/block/blockconsole/mkblockconsole
> @@ -0,0 +1,24 @@
> +#!/bin/sh
> +
> +if [ ! $# -eq 1 ]; then
> +	echo "Usage: mkblockconsole <dev>"
> +	exit 1
> +elif mount|fgrep -q $1; then
> +	echo Device appears to be mounted - aborting
> +	exit 1
> +else
> +	dd if=/dev/zero bs=1M count=1 > $1
> +	# The funky formatting is actually needed!
> +	UUID=`head -c4 /dev/urandom |hexdump -e '/4 "%08x"'`
> +	echo > /tmp/$UUID
> +	echo 'Linux blockconsole version 1.1' >> /tmp/$UUID
> +	echo "$UUID" >> /tmp/$UUID
> +	echo 00000000 >> /tmp/$UUID
> +	echo 00000000 >> /tmp/$UUID
> +	for i in `seq 452`; do echo -n " " >> /tmp/$UUID; done
> +	echo >> /tmp/$UUID
> +	cat /tmp/$UUID > $1
> +	rm /tmp/$UUID
> +	sync
> +	exit 0
> +fi
> diff --git a/block/partitions/Makefile b/block/partitions/Makefile
> index 03af8ea..bf26d4a 100644
> --- a/block/partitions/Makefile
> +++ b/block/partitions/Makefile
> @@ -18,3 +18,4 @@ obj-$(CONFIG_IBM_PARTITION) += ibm.o
>  obj-$(CONFIG_EFI_PARTITION) += efi.o
>  obj-$(CONFIG_KARMA_PARTITION) += karma.o
>  obj-$(CONFIG_SYSV68_PARTITION) += sysv68.o
> +obj-$(CONFIG_BLOCKCONSOLE) += blockconsole.o
> diff --git a/block/partitions/blockconsole.c b/block/partitions/blockconsole.c
> new file mode 100644
> index 0000000..79796a8
> --- /dev/null
> +++ b/block/partitions/blockconsole.c
> @@ -0,0 +1,22 @@
> +#include <linux/blockconsole.h>

This one is kinda missing from the patch:

block/partitions/blockconsole.c:1:32: fatal error: linux/blockconsole.h: No such file or directory
compilation terminated.
make[2]: *** [block/partitions/blockconsole.o] Error 1
make[1]: *** [block/partitions] Error 2
make: *** [block] Error 2
make: *** Waiting for unfinished jobs....

> +
> +#include "check.h"
> +
> +int blockconsole_partition(struct parsed_partitions *state)
> +{
> +	Sector sect;
> +	void *data;
> +	int err = 0;
> +
> +	data = read_part_sector(state, 0, &sect);
> +	if (!data)
> +		return -EIO;
> +	if (!bcon_magic_present(data))
> +		goto out;
> +
> +	bcon_add(state->name);
> +	err = 1;
> +out:
> +	put_dev_sector(sect);
> +	return err;
> +}
> diff --git a/block/partitions/check.c b/block/partitions/check.c
> index bc90867..8de99fa 100644
> --- a/block/partitions/check.c
> +++ b/block/partitions/check.c
> @@ -36,11 +36,15 @@
>  
>  int warn_no_part = 1; /*This is ugly: should make genhd removable media aware*/
>  
> +int blockconsole_partition(struct parsed_partitions *state);
>  static int (*check_part[])(struct parsed_partitions *) = {
>  	/*
>  	 * Probe partition formats with tables at disk address 0
>  	 * that also have an ADFS boot block at 0xdc0.
>  	 */
> +#ifdef CONFIG_BLOCKCONSOLE
> +	blockconsole_partition,
> +#endif
>  #ifdef CONFIG_ACORN_PARTITION_ICS
>  	adfspart_check_ICS,
>  #endif
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index a796407..7ce033d 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -555,4 +555,9 @@ config BLK_DEV_RBD
>  
>  	  If unsure, say N.
>  
> +config BLOCKCONSOLE
> +	tristate "Block device console logging support"
> +	help
> +	  This enables logging to block devices.
> +

This help text should be expanded to be more verbose, maybe add
reference to the documentation files.

>  endif # BLK_DEV
> diff --git a/drivers/block/Makefile b/drivers/block/Makefile

...

So I'll gladly give it a run once you have a patch that builds :-)

Thanks.

-- 
Regards/Gruss,
Boris.
