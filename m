Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab2GPMqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:46:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54448 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab2GPMqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:46:14 -0400
Date: Mon, 16 Jul 2012 14:46:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
Message-ID: <20120716124614.GA19497@x1.osrc.amd.com>
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
 <20120713130336.GC10298@x1.osrc.amd.com>
 <20120713162009.GA10268@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120713162009.GA10268@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 12:20:09PM -0400, Jörn Engel wrote:

[ … ]

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

You probably want to check lsscsi presence on the system, wasn't
installed by default on my debian testing image, for example. See diff
at the end of this mail.

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

	echo "Usage: $0 <dev>"

in case the name of the script changes.

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
> index a796407..637c952 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -555,4 +555,10 @@ config BLK_DEV_RBD
>  
>  	  If unsure, say N.
>  
> +config BLOCKCONSOLE
> +	bool "Block device console logging support"
> +	help
> +	  This enables logging to block devices.
> +	  See <file:Documentation/block/blockconsole.txt> for details.
> +
>  endif # BLK_DEV
> diff --git a/drivers/block/Makefile b/drivers/block/Makefile
> index 5b79505..1eb7f902 100644
> --- a/drivers/block/Makefile
> +++ b/drivers/block/Makefile
> @@ -41,5 +41,6 @@ obj-$(CONFIG_XEN_BLKDEV_BACKEND)	+= xen-blkback/
>  obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
>  obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
>  obj-$(CONFIG_BLK_DEV_PCIESSD_MTIP32XX)	+= mtip32xx/
> +obj-$(CONFIG_BLOCKCONSOLE)	+= blockconsole.o
>  
>  swim_mod-y	:= swim.o swim_asm.o
> diff --git a/drivers/block/blockconsole.c b/drivers/block/blockconsole.c
> new file mode 100644
> index 0000000..d13203f
> --- /dev/null
> +++ b/drivers/block/blockconsole.c
> @@ -0,0 +1,606 @@
> +#include <linux/bio.h>
> +#include <linux/blockconsole.h>
> +#include <linux/console.h>
> +#include <linux/fs.h>
> +#include <linux/kthread.h>
> +#include <linux/mm.h>
> +#include <linux/mount.h>
> +#include <linux/random.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/workqueue.h>
> +
> +#define BLOCKCONSOLE_MAGIC_OLD	"\nLinux blockconsole version 1.0\n"

blockconsole is not yet upstream, you probably want to get rid of the
_OLD handling completely?

> +#define BLOCKCONSOLE_MAGIC	"\nLinux blockconsole version 1.1\n"
> +#define BCON_UUID_OFS		(32)
> +#define BCON_ROUND_OFS		(41)
> +#define BCON_TILE_OFS		(50)
> +#define BCON_HEADERSIZE		(50)
> +#define BCON_LONG_HEADERSIZE	(59) /* with tile index */
> +
> +#define PAGE_COUNT		(256)
> +#define SECTOR_COUNT		(PAGE_COUNT * (PAGE_SIZE >> 9))
> +#define CACHE_PAGE_MASK		(PAGE_COUNT - 1)
> +#define CACHE_SECTOR_MASK	(SECTOR_COUNT - 1)
> +#define CACHE_SIZE		(PAGE_COUNT << PAGE_SHIFT)
> +#define CACHE_MASK		(CACHE_SIZE - 1)
> +#define SECTOR_SHIFT		(9)
> +#define SECTOR_SIZE		(1 << SECTOR_SHIFT)
> +#define SECTOR_MASK		(~(SECTOR_SIZE-1))
> +#define PG_SECTOR_MASK		((PAGE_SIZE >> 9) - 1)
> +
> +struct bcon_bio {
> +	struct bio bio;
> +	struct bio_vec bvec;
> +	void *sector;
> +	int in_flight;
> +};
> +
> +struct blockconsole {
> +	char devname[32];
> +	struct spinlock end_io_lock;
> +	struct timer_list pad_timer;
> +	int error_count;
> +	struct kref kref;

Another build failure missing

#include <linux/kref.h>

drivers/block/blockconsole.c:44:14: error: field ‘kref’ has incomplete type
drivers/block/blockconsole.c: In function ‘bcon_get’:
drivers/block/blockconsole.c:63:2: error: implicit declaration of function ‘kref_get’ [-Werror=implicit-function-declaration]
drivers/block/blockconsole.c: In function ‘bcon_release’:
drivers/block/blockconsole.c:68:28: warning: initialization from incompatible pointer type [enabled by default]
drivers/block/blockconsole.c:68:28: warning: (near initialization for ‘bc’) [enabled by default]
drivers/block/blockconsole.c: In function ‘bcon_put’:
drivers/block/blockconsole.c:79:2: error: implicit declaration of function ‘kref_put’ [-Werror=implicit-function-declaration]
drivers/block/blockconsole.c: In function ‘bcon_create’:
drivers/block/blockconsole.c:499:2: error: implicit declaration of function ‘kref_init’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[2]: *** [drivers/block/blockconsole.o] Error 1
make[1]: *** [drivers/block] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....

Below's a diff of what I did here to make this work, feel free to take
anything from it.

With the include added, it builds fine. Then I took an usb stick and I
did:

$ ./mkblockconsole /dev/sdc

<reboot>

$ ./bcon_tail

which created a file called /var/log/bcon.32ea1561.

Doing a

$ less /var/log/bcon.32ea1561
Linux blockconsole version 1.1
32ea1561
00000000
00000000
                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@
^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@
^@^@^@^@^@^@
...

gives a lot of zeros, right up to the first megabyte, to be exact after which
the log starts:

$ hexdump -C /var/log/bcon.32ea1561

00000000  0a 4c 69 6e 75 78 20 62  6c 6f 63 6b 63 6f 6e 73  |.Linux blockcons|
00000010  6f 6c 65 20 76 65 72 73  69 6f 6e 20 31 2e 31 0a  |ole version 1.1.|
00000020  33 32 65 61 31 35 36 31  0a 30 30 30 30 30 30 30  |32ea1561.0000000|
00000030  30 0a 30 30 30 30 30 30  30 30 0a 20 20 20 20 20  |0.00000000.     |
00000040  20 20 20 20 20 20 20 20  20 20 20 20 20 20 20 20  |                |
*
000001f0  20 20 20 20 20 20 20 20  20 20 20 20 20 20 20 0a  |               .|
00000200  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00100000  0a 4c 69 6e 75 78 20 62  6c 6f 63 6b 63 6f 6e 73  |.Linux blockcons|
00100010  6f 6c 65 20 76 65 72 73  69 6f 6e 20 31 2e 31 0a  |ole version 1.1.|
00100020  33 32 65 61 31 35 36 31  0a 30 30 30 30 30 30 30  |32ea1561.0000000|
00100030  30 0a 30 30 30 30 30 30  30 31 0a 5b 20 20 20 20  |0.00000001.[    |
00100040  30 2e 30 30 30 30 30 30  5d 20 49 6e 69 74 69 61  |0.000000] Initia|
00100050  6c 69 7a 69 6e 67 20 63  67 72 6f 75 70 20 73 75  |lizing cgroup su|
....

So I can read the log by doing

$ strings /var/log/bcon.32ea1561 | less

So why is that first megabyte full of zeros there?

Other than that, it works like a charm and I like the idea that no
kernel cmdline args are needed.

Also, you might want to add a step-by-step fast howto to the docs with
concrete steps like the above so that people can try this out faster.

Thanks.

--
diff --git a/Documentation/block/blockconsole/bcon_tail b/Documentation/block/blockconsole/bcon_tail
index 950bfd1..e415b6f 100755
--- a/Documentation/block/blockconsole/bcon_tail
+++ b/Documentation/block/blockconsole/bcon_tail
@@ -4,6 +4,12 @@ TAIL_LEN=16
 TEMPLATE=/tmp/bcon_template
 BUF=/tmp/bcon_buf
 
+if [ -z "$(which lsscsi)" ];
+then
+	echo "You need to install the lsscsi package on your distro."
+	exit 1
+fi
+
 end_of_log() {
 	DEV=$1
 	UUID=`head -c40 $DEV|tail -c8`
diff --git a/Documentation/block/blockconsole/mkblockconsole b/Documentation/block/blockconsole/mkblockconsole
index d9514e7..05c4ad8 100755
--- a/Documentation/block/blockconsole/mkblockconsole
+++ b/Documentation/block/blockconsole/mkblockconsole
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 if [ ! $# -eq 1 ]; then
-	echo "Usage: mkblockconsole <dev>"
+	echo "Usage: $0 <dev>"
 	exit 1
 elif mount|fgrep -q $1; then
 	echo Device appears to be mounted - aborting
diff --git a/drivers/block/blockconsole.c b/drivers/block/blockconsole.c
index d13203f..b4e995d 100644
--- a/drivers/block/blockconsole.c
+++ b/drivers/block/blockconsole.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/workqueue.h>
+#include <linux/kref.h>
 
 #define BLOCKCONSOLE_MAGIC_OLD	"\nLinux blockconsole version 1.0\n"
 #define BLOCKCONSOLE_MAGIC	"\nLinux blockconsole version 1.1\n"

-- 
Regards/Gruss,
Boris.
