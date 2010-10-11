Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0JKNfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:35:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55677 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab0JKNft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:35:49 -0400
Date: Mon, 11 Oct 2010 14:35:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thorsten Glaser <tg@mirbsd.de>
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: aranym bug, manifests as "ida_remove called for id=13" on recent
 kernels
Message-ID: <20101011133545.GJ19804@ZenIV.linux.org.uk>
References: <20101007174948.GT19804@ZenIV.linux.org.uk>
 <AANLkTin4886D+-yo=zrf2Yj2R5NM9qdRkc3M9cG2rN_F@mail.gmail.com>
 <20101010144952.GF19804@ZenIV.linux.org.uk>
 <AANLkTinuA3AzMoJ82pvCuhmo59DZxL2F1j3xhXUkjj7z@mail.gmail.com>
 <20101010235256.GG19804@ZenIV.linux.org.uk>
 <20101011024103.GH19804@ZenIV.linux.org.uk>
 <20101011043632.GA2566@cynthia.pants.nu>
 <20101011044808.GI19804@ZenIV.linux.org.uk>
 <Pine.BSM.4.64L.1010111218040.23471@herc.mirbsd.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.BSM.4.64L.1010111218040.23471@herc.mirbsd.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 12:21:46PM +0000, Thorsten Glaser wrote:
> Al Viro dixit:
> 
> >On Sun, Oct 10, 2010 at 09:36:32PM -0700, Brad Boyer wrote:
> 
> >> > Spot the obvious bug...  BTW, why on the Earth does debian-ports m68k tree
> >> > use gcc-4.3 with Cthulhu-scaring 700Kb gzipped patch and does *not* have
> >> > gcc-4.4?
> >> 
> >> I believe that gcc-4.4 for m68k is being held up by the TLS support patches.
> 
> Yes, indeed. I???m working on gcc-4.4 but am stalled because, after
> finally getting a kernel to build, it has no support for nfeth.

	Huh?  Oh, you mean the net_device_ops transition missed in
arch/m68k/emu/nfeth.c?  Just add

static const struct net_device_ops nfeth_netdev_ops = {
        .ndo_open = nfeth_open,
        .ndo_stop = nfeth_stop,
        .ndo_get_stats = nfeth_get_stats,
        .ndo_start_xmit = nfeth_xmit,
        .ndo_tx_timeout = nfeth_tx_timeout,
        .ndo_validate_addr      = eth_validate_addr,
};

in it and replace the assignments to ->open, etc. in nfeth_probe() with
        dev->netdev_ops = &nfeth_netdev_ops;

and the sucker will work. 

Below is what I'm using on top of mainline kernel; it's a combination of
couple of patches in debian m68k kernel plus compile fixes.  At least
works well enough for booting with /dev/hda getting contents from file on
host and network working well enough for ssh.  With gcc-4.1 that seems
to be enough.  With 4.3... slapping assignment to global variable right
before the return from proc_pid_follow_link() gets it to boot and work
well enough for apt-get and compiles, but I wouldn't bet a dime on the
correctness around failure exits all over the tree.  This kind of
miscompile is definitely triggered in a lot of places - anything that
does return ERR_PTR(error) right after error = foo(...); is going to
get fscked and it's not a rare thing.  Amazing that it doesn't fall
apart much harder...

BTW, now that I've tried allmodconfig build, 4.3 gives a bunch of ICE
on e.g. ntfs.  Cross-build, so it's not an underlying kernel breakage...

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 8030e24..6a6893a 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -248,6 +248,37 @@ config SUN3
 
 	  If you don't want to compile a kernel exclusively for a Sun 3, say N.
 
+config NATFEAT
+	bool "ARAnyM emulator support"
+	depends on ATARI
+	help
+	  This option enables support for ARAnyM native features, such as
+	  access to a disk image as /dev/hda. Useful with the ARANYM option.
+
+config NFETH
+	tristate "NatFeat Ethernet support"
+	depends on NET_ETHERNET && NATFEAT
+	help
+	  Say Y to include support for the ARAnyM NatFeat network device
+	  which will emulate a regular ethernet device while presenting an
+	  ethertap device to the host system.
+
+config NFBLOCK
+	tristate "NatFeat block device support"
+	depends on BLOCK && NATFEAT
+	help
+	  Say Y to include support for the ARAnyM NatFeat block device
+	  which allows direct access to the hard drives without using
+	  the hardware emulation.
+
+config NFCON
+	tristate "NatFeat console driver"
+	depends on NATFEAT
+	help
+	  Say Y to include support for the ARAnyM NatFeat console driver
+	  which allows the console output to be redirected to the stderr
+	  output of ARAnyM.
+
 comment "Processor type"
 
 config M68020
diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
index b06a7e3..b793163 100644
--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -76,6 +76,7 @@ core-$(CONFIG_MVME16x)		+= arch/m68k/mvme16x/
 core-$(CONFIG_BVME6000)		+= arch/m68k/bvme6000/
 core-$(CONFIG_SUN3X)		+= arch/m68k/sun3x/	arch/m68k/sun3/
 core-$(CONFIG_SUN3)		+= arch/m68k/sun3/	arch/m68k/sun3/prom/
+core-$(CONFIG_NATFEAT)		+= arch/m68k/emu/
 core-$(CONFIG_M68040)		+= arch/m68k/fpsp040/
 core-$(CONFIG_M68060)		+= arch/m68k/ifpsp060/
 core-$(CONFIG_M68KFPU_EMU)	+= arch/m68k/math-emu/
diff --git a/arch/m68k/emu/Makefile b/arch/m68k/emu/Makefile
new file mode 100644
index 0000000..34f9a4d
--- /dev/null
+++ b/arch/m68k/emu/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for Linux arch/m68k/emu source directory
+#
+
+obj-y			+= natfeat.o
+
+obj-$(CONFIG_NFETH)	+= nfeth.o
+obj-$(CONFIG_NFBLOCK)	+= nfblock.o
+obj-$(CONFIG_NFCON)	+= nfcon.o
diff --git a/arch/m68k/emu/natfeat.c b/arch/m68k/emu/natfeat.c
new file mode 100644
index 0000000..f22c072
--- /dev/null
+++ b/arch/m68k/emu/natfeat.c
@@ -0,0 +1,75 @@
+/*
+ * natfeat.c - ARAnyM hardware support via Native Features (natfeats)
+ *
+ * Copyright (c) 2005 Petr Stehlik of ARAnyM dev team
+ *
+ * Reworked for Linux by Roman Zippel <zippel@linux-m68k.org>
+ *
+ * This software may be used and distributed according to the terms of
+ * the GNU General Public License (GPL), incorporated herein by reference.
+ */
+
+#include <linux/types.h>
+#include <linux/console.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <asm/machdep.h>
+#include <asm/natfeat.h>
+
+asm("\n"
+"	.global nf_get_id,nf_call\n"
+"nf_get_id:\n"
+"	.short	0x7300\n"
+"	rts\n"
+"nf_call:\n"
+"	.short	0x7301\n"
+"	rts\n"
+"1:	moveq.l	#0,%d0\n"
+"	rts\n"
+"	.section __ex_table,\"a\"\n"
+"	.long	nf_get_id,1b\n"
+"	.long	nf_call,1b\n"
+"	.previous");
+
+void nfprint(const char *fmt, ...)
+{
+	static char buf[256];
+	va_list ap;
+	int n;
+
+	va_start(ap, fmt);
+	n = vsnprintf(buf, 256, fmt, ap);
+	nf_call(nf_get_id("NF_STDERR"), buf);
+	va_end(ap);
+}
+
+static void nf_poweroff(void)
+{
+	long id = nf_get_id("NF_SHUTDOWN");
+
+	if (id)
+		nf_call(id);
+}
+
+void nf_init(void)
+{
+	unsigned long id, version;
+	char buf[256];
+
+	id = nf_get_id("NF_VERSION");
+	if (!id)
+		return;
+	version = nf_call(id);
+
+	id = nf_get_id("NF_NAME");
+	if (!id)
+		return;
+	nf_call(id, buf, 256);
+	buf[255] = 0;
+
+	pr_info("NatFeats found (%s, %lu.%lu)\n", buf, version >> 16,
+		version & 0xffff);
+
+	mach_power_off = nf_poweroff;
+}
diff --git a/arch/m68k/emu/nfblock.c b/arch/m68k/emu/nfblock.c
new file mode 100644
index 0000000..fed2883
--- /dev/null
+++ b/arch/m68k/emu/nfblock.c
@@ -0,0 +1,195 @@
+/*
+ * ARAnyM block device driver
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/genhd.h>
+#include <linux/blkdev.h>
+#include <linux/hdreg.h>
+#include <linux/slab.h>
+
+#include <asm/natfeat.h>
+
+static long nfhd_id;
+
+enum {
+	/* emulation entry points */
+	NFHD_READ_WRITE = 10,
+	NFHD_GET_CAPACITY = 14,
+
+	/* skip ACSI devices */
+	NFHD_DEV_OFFSET = 8,
+};
+
+static inline s32 nfhd_read_write(u32 major, u32 minor, u32 rwflag, u32 recno,
+				  u32 count, u32 buf)
+{
+	return nf_call(nfhd_id + NFHD_READ_WRITE, major, minor, rwflag, recno,
+		       count, buf);
+}
+
+static inline s32 nfhd_get_capacity(u32 major, u32 minor, u32 *blocks,
+				    u32 *blocksize)
+{
+	return nf_call(nfhd_id + NFHD_GET_CAPACITY, major, minor, blocks,
+		       blocksize);
+}
+
+static LIST_HEAD(nfhd_list);
+
+static int major_num;
+module_param(major_num, int, 0);
+
+struct nfhd_device {
+	struct list_head list;
+	int id;
+	u32 blocks, bsize;
+	int bshift;
+	struct request_queue *queue;
+	struct gendisk *disk;
+};
+
+static int nfhd_make_request(struct request_queue *queue, struct bio *bio)
+{
+	struct nfhd_device *dev = queue->queuedata;
+	struct bio_vec *bvec;
+	int i, dir, len, shift;
+	sector_t sec = bio->bi_sector;
+
+	dir = bio_data_dir(bio);
+	shift = dev->bshift;
+	bio_for_each_segment(bvec, bio, i) {
+		len = bvec->bv_len;
+		len >>= 9;
+		nfhd_read_write(dev->id, 0, dir, sec >> shift, len >> shift,
+				bvec_to_phys(bvec));
+		sec += len;
+	}
+	bio_endio(bio, 0);
+	return 0;
+}
+
+int nfhd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
+{
+	struct nfhd_device *dev = bdev->bd_disk->private_data;
+
+	geo->cylinders = dev->blocks >> (6 - dev->bshift);
+	geo->heads = 4;
+	geo->sectors = 16;
+
+	return 0;
+}
+
+static struct block_device_operations nfhd_ops = {
+	.owner	= THIS_MODULE,
+	.getgeo	= nfhd_getgeo,
+};
+
+static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
+{
+	struct nfhd_device *dev;
+	int dev_id = id - NFHD_DEV_OFFSET;
+
+	printk(KERN_INFO "nfhd%u: found device with %u blocks (%u bytes)\n",
+		dev_id, blocks, bsize);
+
+	if (bsize < 512 || (bsize & (bsize - 1))) {
+		printk(KERN_WARNING "nfhd%u: invalid block size\n", dev_id);
+		return -EINVAL;
+	}
+
+	dev = kmalloc(sizeof(struct nfhd_device), GFP_KERNEL);
+	if (!dev)
+		goto out;
+
+	dev->id = id;
+	dev->blocks = blocks;
+	dev->bsize = bsize;
+	dev->bshift = ffs(bsize) - 10;
+
+	dev->queue = blk_alloc_queue(GFP_KERNEL);
+	if (dev->queue == NULL)
+		goto free_dev;
+
+	dev->queue->queuedata = dev;
+	blk_queue_make_request(dev->queue, nfhd_make_request);
+	blk_queue_logical_block_size(dev->queue, bsize);
+
+	dev->disk = alloc_disk(16);
+	if (!dev->disk)
+		goto free_queue;
+
+	dev->disk->major = major_num;
+	dev->disk->first_minor = dev_id * 16;
+	dev->disk->fops = &nfhd_ops;
+	dev->disk->private_data = dev;
+	sprintf(dev->disk->disk_name, "nfhd%u", dev_id);
+	set_capacity(dev->disk, (sector_t)blocks * (bsize / 512));
+	dev->disk->queue = dev->queue;
+
+	add_disk(dev->disk);
+
+	list_add_tail(&dev->list, &nfhd_list);
+
+	return 0;
+
+free_queue:
+	blk_cleanup_queue(dev->queue);
+free_dev:
+	kfree(dev);
+out:
+	return -ENOMEM;
+}
+
+static int __init nfhd_init(void)
+{
+	u32 blocks, bsize;
+	int i;
+
+	nfhd_id = nf_get_id("XHDI");
+	if (!nfhd_id)
+		return -ENODEV;
+
+	major_num = register_blkdev(major_num, "nfhd");
+	if (major_num <= 0) {
+		printk(KERN_WARNING "nfhd: unable to get major number\n");
+		return -ENODEV;
+	}
+
+	for (i = NFHD_DEV_OFFSET; i < 24; i++) {
+		if (nfhd_get_capacity(i, 0, &blocks, &bsize))
+			continue;
+		nfhd_init_one(i, blocks, bsize);
+	}
+
+	return 0;
+}
+
+static void __exit nfhd_exit(void)
+{
+	struct nfhd_device *dev, *next;
+
+	list_for_each_entry_safe(dev, next, &nfhd_list, list) {
+		list_del(&dev->list);
+		del_gendisk(dev->disk);
+		put_disk(dev->disk);
+		blk_cleanup_queue(dev->queue);
+		kfree(dev);
+	}
+	unregister_blkdev(major_num, "nfhd");
+}
+
+module_init(nfhd_init);
+module_exit(nfhd_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/arch/m68k/emu/nfcon.c b/arch/m68k/emu/nfcon.c
new file mode 100644
index 0000000..91984fe
--- /dev/null
+++ b/arch/m68k/emu/nfcon.c
@@ -0,0 +1,164 @@
+/*
+ * ARAnyM console driver
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/tty_flip.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/uaccess.h>
+
+#include <asm/natfeat.h>
+
+static int stderr_id;
+static struct tty_driver *nfcon_tty_driver;
+
+static void nfcon_write(struct console *con, const char *str, unsigned int count)
+{
+	char buf[68];
+
+	buf[64] = 0;
+	while (count > 64) {
+		memcpy(buf, str, 64);
+		nf_call(stderr_id, buf);
+		str += 64;
+		count -= 64;
+	}
+	memcpy(buf, str, count);
+	buf[count] = 0;
+	nf_call(stderr_id, buf);
+}
+
+struct tty_driver *nfcon_device(struct console *con, int *index)
+{
+	*index = 0;
+	return (con->flags & CON_ENABLED) ? nfcon_tty_driver : NULL;
+}
+
+static struct console nf_console = {
+	.name	= "nfcon",
+	.write	= nfcon_write,
+	.device	= nfcon_device,
+	.flags	= CON_PRINTBUFFER,
+	.index	= -1,
+};
+
+
+static int nfcon_tty_open(struct tty_struct *tty, struct file *filp)
+{
+	return 0;
+}
+
+static void nfcon_tty_close(struct tty_struct *tty, struct file *filp)
+{
+}
+
+static int nfcon_tty_write(struct tty_struct *tty, const unsigned char *buf, int count)
+{
+	char temp[68];
+	int i = count;
+
+	temp[64] = 0;
+	while (i > 64) {
+		memcpy(temp, buf, 64);
+		nf_call(stderr_id, temp);
+		buf += 64;
+		i -= 64;
+	}
+	memcpy(temp, buf, i);
+	temp[i] = 0;
+	nf_call(stderr_id, temp);
+
+	return count;
+}
+
+static int nfcon_tty_put_char(struct tty_struct *tty, unsigned char ch)
+{
+	char temp[2] = { ch, 0 };
+
+	nf_call(stderr_id, temp);
+	return 1;
+}
+
+static int nfcon_tty_write_room(struct tty_struct *tty)
+{
+	return 64;
+}
+
+static const struct tty_operations nfcon_tty_ops = {
+	.open		= nfcon_tty_open,
+	.close		= nfcon_tty_close,
+	.write		= nfcon_tty_write,
+	.put_char	= nfcon_tty_put_char,
+	.write_room	= nfcon_tty_write_room,
+};
+
+static int __init nf_debug_setup(char *arg)
+{
+	if (strcmp(arg, "nfcon"))
+		return 0;
+
+	stderr_id = nf_get_id("NF_STDERR");
+	if (stderr_id) {
+		nf_console.flags |= CON_ENABLED;
+		register_console(&nf_console);
+	}
+
+	return 0;
+}
+
+early_param("debug", nf_debug_setup);
+
+static int __init nfcon_init(void)
+{
+	int res;
+
+	stderr_id = nf_get_id("NF_STDERR");
+	if (!stderr_id)
+		return -ENODEV;
+
+	nfcon_tty_driver = alloc_tty_driver(1);
+	if (!nfcon_tty_driver)
+		return -ENOMEM;
+
+	nfcon_tty_driver->owner = THIS_MODULE;
+	nfcon_tty_driver->driver_name = "nfcon";
+	nfcon_tty_driver->name = "nfcon";
+	nfcon_tty_driver->type = TTY_DRIVER_TYPE_SYSTEM;
+	nfcon_tty_driver->subtype = SYSTEM_TYPE_TTY;
+	nfcon_tty_driver->init_termios = tty_std_termios;
+	nfcon_tty_driver->flags = TTY_DRIVER_REAL_RAW;
+
+	tty_set_operations(nfcon_tty_driver, &nfcon_tty_ops);
+	res = tty_register_driver(nfcon_tty_driver);
+	if (res) {
+		printk(KERN_ERR "failed to register nfcon tty driver\n");
+		put_tty_driver(nfcon_tty_driver);
+		return res;
+	}
+
+	if (!(nf_console.flags & CON_ENABLED))
+		register_console(&nf_console);
+
+	return 0;
+}
+
+static void __exit nfcon_exit(void)
+{
+	unregister_console(&nf_console);
+	tty_unregister_driver(nfcon_tty_driver);
+	put_tty_driver(nfcon_tty_driver);
+}
+
+module_init(nfcon_init);
+module_exit(nfcon_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/arch/m68k/emu/nfeth.c b/arch/m68k/emu/nfeth.c
new file mode 100644
index 0000000..1318802
--- /dev/null
+++ b/arch/m68k/emu/nfeth.c
@@ -0,0 +1,287 @@
+/*
+ * atari_nfeth.c - ARAnyM ethernet card driver for GNU/Linux
+ *
+ * Copyright (c) 2005 Milan Jurik, Petr Stehlik of ARAnyM dev team
+ *
+ * Based on ARAnyM driver for FreeMiNT written by Standa Opichal
+ *
+ * This software may be used and distributed according to the terms of
+ * the GNU General Public License (GPL), incorporated herein by reference.
+ */
+
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/module.h>
+#include <asm/natfeat.h>
+#include <asm/virtconvert.h>
+
+enum {
+	GET_VERSION = 0,	/* no parameters, return NFAPI_VERSION in d0 */
+	XIF_INTLEVEL,		/* no parameters, return Interrupt Level in d0 */
+	XIF_IRQ,		/* acknowledge interrupt from host */
+	XIF_START,		/* (ethX), called on 'ifup', start receiver thread */
+	XIF_STOP,		/* (ethX), called on 'ifdown', stop the thread */
+	XIF_READLENGTH,		/* (ethX), return size of network data block to read */
+	XIF_READBLOCK,		/* (ethX, buffer, size), read block of network data */
+	XIF_WRITEBLOCK,		/* (ethX, buffer, size), write block of network data */
+	XIF_GET_MAC,		/* (ethX, buffer, size), return MAC HW addr in buffer */
+	XIF_GET_IPHOST,		/* (ethX, buffer, size), return IP address of host */
+	XIF_GET_IPATARI,	/* (ethX, buffer, size), return IP address of atari */
+	XIF_GET_NETMASK		/* (ethX, buffer, size), return IP netmask */
+};
+
+#define DRV_NAME	"nfeth"
+#define DRV_VERSION	"0.3"
+#define DRV_RELDATE	"10/12/2005"
+
+#define MAX_UNIT	8
+
+/* These identify the driver base version and may not be removed. */
+static char version[] __devinitdata =
+KERN_INFO DRV_NAME ".c:v" DRV_VERSION " " DRV_RELDATE " S.Opichal, M.Jurik, P.Stehlik\n"
+KERN_INFO "  http://aranym.atari.org/\n";
+
+MODULE_AUTHOR("Milan Jurik");
+MODULE_DESCRIPTION("Atari NFeth driver");
+MODULE_LICENSE("GPL");
+/*
+MODULE_PARM(nfeth_debug, "i");
+MODULE_PARM_DESC(nfeth_debug, "nfeth_debug level (1-2)");
+*/
+
+
+static long nfEtherID;
+static int nfEtherIRQ;
+
+struct nfeth_private {
+	int ethX;
+	struct net_device_stats	stats;
+};
+
+static struct net_device *nfeth_dev[MAX_UNIT];
+
+int nfeth_open(struct net_device *dev);
+int nfeth_stop(struct net_device *dev);
+irqreturn_t nfeth_interrupt(int irq, void *dev_id);
+int nfeth_xmit(struct sk_buff *skb, struct net_device *dev);
+
+int nfeth_open(struct net_device *dev)
+{
+	struct nfeth_private *priv = netdev_priv(dev);
+	int res;
+
+	res = nf_call(nfEtherID + XIF_START, priv->ethX);
+
+	/* Clean statistics */
+	memset(&priv->stats, 0, sizeof(struct net_device_stats));
+
+	pr_debug(DRV_NAME ": open %d\n", res);
+
+	/* Ready for data */
+	netif_start_queue(dev);
+
+	return 0;
+}
+
+int nfeth_stop(struct net_device *dev)
+{
+	struct nfeth_private *priv = netdev_priv(dev);
+
+	/* No more data */
+	netif_stop_queue(dev);
+
+	nf_call(nfEtherID + XIF_STOP, priv->ethX);
+
+	return 0;
+}
+
+/*
+ * Read a packet out of the adapter and pass it to the upper layers
+ */
+static inline void recv_packet(struct net_device *dev)
+{
+	struct nfeth_private *priv = netdev_priv(dev);
+	int handled = 0;
+	unsigned short pktlen;
+	struct sk_buff *skb;
+
+	/* read packet length (excluding 32 bit crc) */
+	pktlen = nf_call(nfEtherID + XIF_READLENGTH, priv->ethX);
+
+	pr_debug(DRV_NAME ": recv_packet: %i\n", pktlen);
+
+	if (!pktlen) {
+		pr_debug(DRV_NAME ": recv_packet: pktlen == 0\n");
+		priv->stats.rx_errors++;
+		return;
+	}
+
+	skb = dev_alloc_skb(pktlen + 2);
+	if (!skb) {
+		pr_debug(DRV_NAME
+			 ": recv_packet: out of mem (buf_alloc failed)\n");
+		priv->stats.rx_dropped++;
+		return;
+	}
+
+	skb->dev = dev;
+	skb_reserve(skb, 2);		/* 16 Byte align  */
+	skb_put(skb, pktlen);		/* make room */
+	nf_call(nfEtherID + XIF_READBLOCK, priv->ethX, virt_to_phys(skb->data),
+		pktlen);
+
+	skb->protocol = eth_type_trans(skb, dev);
+	netif_rx(skb);
+	dev->last_rx = jiffies;
+	priv->stats.rx_packets++;
+	priv->stats.rx_bytes += pktlen;
+
+	/* and enqueue packet */
+	handled = 1;
+	return;
+}
+
+irqreturn_t nfeth_interrupt(int irq, void *dev_id)
+{
+	int i, m, mask;
+
+	mask = nf_call(nfEtherID + XIF_IRQ, 0);
+	for (i = 0, m = 1; i < MAX_UNIT; m <<= 1, i++) {
+		if (mask & m && nfeth_dev[i]) {
+			recv_packet(nfeth_dev[i]);
+			nf_call(nfEtherID + XIF_IRQ, m);
+		}
+	}
+	return IRQ_HANDLED;
+}
+
+int nfeth_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	int len;
+	char *data, shortpkt[ETH_ZLEN];
+	struct nfeth_private *priv = netdev_priv(dev);
+
+	data = skb->data;
+	len = skb->len;
+	if (len < ETH_ZLEN) {
+		memset(shortpkt, 0, ETH_ZLEN);
+		memcpy(shortpkt, data, len);
+		data = shortpkt;
+		len = ETH_ZLEN;
+	}
+
+	dev->trans_start = jiffies;
+
+	pr_debug(DRV_NAME ": send %d bytes\n", len);
+	nf_call(nfEtherID + XIF_WRITEBLOCK, priv->ethX, virt_to_phys(data),
+		len);
+
+	priv->stats.tx_packets++;
+	priv->stats.tx_bytes += len;
+
+	dev_kfree_skb(skb);
+	return 0;
+}
+
+static void nfeth_tx_timeout(struct net_device *dev)
+{
+	struct nfeth_private *priv = netdev_priv(dev);
+	priv->stats.tx_errors++;
+	netif_wake_queue(dev);
+}
+
+static struct net_device_stats *nfeth_get_stats(struct net_device *dev)
+{
+	struct nfeth_private *priv = netdev_priv(dev);
+	return &priv->stats;
+}
+
+static const struct net_device_ops nfeth_netdev_ops = {
+	.ndo_open = nfeth_open,
+	.ndo_stop = nfeth_stop,
+	.ndo_get_stats = nfeth_get_stats,
+	.ndo_start_xmit = nfeth_xmit,
+	.ndo_tx_timeout = nfeth_tx_timeout,
+	.ndo_validate_addr	= eth_validate_addr,
+};
+
+struct net_device * __init nfeth_probe(int unit)
+{
+	struct net_device *dev;
+	struct nfeth_private *priv;
+	char mac[ETH_ALEN], host_ip[32], local_ip[32];
+	int err;
+
+	if (!nf_call(nfEtherID + XIF_GET_MAC, unit, mac, ETH_ALEN))
+		return NULL;
+
+	dev = alloc_etherdev(sizeof(struct nfeth_private));
+	if (!dev)
+		return NULL;
+
+	dev->irq = nfEtherIRQ;
+	dev->flags |= NETIF_F_NO_CSUM;
+	memcpy(dev->dev_addr, mac, ETH_ALEN);
+	dev->netdev_ops = &nfeth_netdev_ops;
+
+	priv = netdev_priv(dev);
+	priv->ethX = unit;
+
+	err = register_netdev(dev);
+	if (err) {
+		free_netdev(dev);
+		return NULL;
+	}
+
+	nf_call(nfEtherID + XIF_GET_IPHOST, unit,
+		host_ip, sizeof(host_ip));
+	nf_call(nfEtherID + XIF_GET_IPATARI, unit,
+		local_ip, sizeof(local_ip));
+
+	pr_info("%s: nfeth addr:%s (%s) HWaddr:%pM\n", dev->name, host_ip,
+		local_ip, mac);
+
+	return dev;
+}
+
+int __init nfeth_init(void)
+{
+	long ver;
+	int i;
+
+	nfEtherID = nf_get_id("ETHERNET");
+	if (!nfEtherID)
+		return -ENODEV;
+
+	ver = nf_call(nfEtherID + GET_VERSION);
+	pr_info("nfeth API %lu\n", ver);
+
+	nfEtherIRQ = nf_call(nfEtherID + XIF_INTLEVEL);
+	if (request_irq(nfEtherIRQ, nfeth_interrupt, IRQF_SHARED,
+			"eth emu", nfeth_interrupt)) {
+		printk(KERN_ERR "nfeth: request for irq %d failed",
+		       nfEtherIRQ);
+		return -ENODEV;
+	}
+
+	for (i = 0; i < MAX_UNIT; i++)
+		nfeth_dev[i] = nfeth_probe(i);
+
+	return 0;
+}
+
+void __exit nfeth_cleanup(void)
+{
+	int i;
+
+	for (i = 0; i < MAX_UNIT; i++) {
+		if (nfeth_dev[i]) {
+			unregister_netdev(nfeth_dev[0]);
+			free_netdev(nfeth_dev[0]);
+		}
+	}
+	free_irq(nfEtherIRQ, nfeth_interrupt);
+}
+
+module_init(nfeth_init);
+module_exit(nfeth_cleanup);
diff --git a/arch/m68k/include/asm/natfeat.h b/arch/m68k/include/asm/natfeat.h
new file mode 100644
index 0000000..a3521b8
--- /dev/null
+++ b/arch/m68k/include/asm/natfeat.h
@@ -0,0 +1,22 @@
+/*
+ * ARAnyM hardware support via Native Features (natfeats)
+ *
+ * Copyright (c) 2005 Petr Stehlik of ARAnyM dev team
+ *
+ * This software may be used and distributed according to the terms of
+ * the GNU General Public License (GPL), incorporated herein by reference.
+ */
+
+#ifndef _NATFEAT_H
+#define _NATFEAT_H
+
+long nf_get_id(const char *feature_name);
+long nf_call(long id, ...);
+
+void nf_init(void);
+void nf_shutdown(void);
+
+void nfprint(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+
+# endif /* _NATFEAT_H */
diff --git a/arch/m68k/kernel/setup.c b/arch/m68k/kernel/setup.c
index 303730a..17b2b62 100644
--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -42,6 +42,7 @@
 #ifdef CONFIG_SUN3X
 #include <asm/dvma.h>
 #endif
+#include <asm/natfeat.h>
 
 #if !FPSTATESIZE || !NR_IRQS
 #warning No CPU/platform type selected, your kernel will not work!
@@ -324,6 +325,10 @@ void __init setup_arch(char **cmdline_p)
 		panic("No configuration setup");
 	}
 
+#ifdef CONFIG_NATFEAT
+	nf_init();
+#endif
+
 	paging_init();
 
 #ifndef CONFIG_SUN3
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 2cc81a5..9c85755 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -418,6 +418,14 @@ config ATARILANCE
 	  on the AMD Lance chipset: RieblCard (with or without battery), or
 	  PAMCard VME (also the version by Rhotron, with different addresses).
 
+config ATARI_ETHERNEC
+	tristate "Atari EtherNEC Ethernet support"
+	depends on NET_ETHERNET && ATARI && ATARI_ROM_ISA
+	help
+	  Say Y to include support for the EtherNEC network adapter for the
+	  ROM port. The driver works by polling instead of interrupts, so it
+	  is quite slow.
+
 config SUN3LANCE
 	tristate "Sun3/Sun3x on-board LANCE support"
 	depends on SUN3 || SUN3X
