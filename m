Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab0FWJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 05:29:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53842 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0FWJ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 05:29:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=CSFE2HFMtl26ZYggHqmMs/XhwdM5aWt6+G0SpwWUCs44j3LXWrmwSWZsucNQMI5DRs
         XPK3x7tv54RAwmDVXGcKk51CHawJ8Fl6l3vKWrNMk4J1iLv9da0iMgKaWU4hsLHUkMfK
         zGRoQPHJcCpqUgTLlHPqSFNnGh0PixHadpVCA=
MIME-Version: 1.0
Date: Wed, 23 Jun 2010 17:29:23 +0800
Message-ID: <AANLkTimSgDvUpWcrVH2_CXCyFm4x9o9rv_9QhXOIH-zB@mail.gmail.com>
Subject: How do I write use bio structure to write a page on disk ?
From: qiux dulin <dulinqiux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm trying to write a page on /dev/sda1 sector 1 in my Vmware virtual machine.
The page is allocated from system memory, and  the virtual machine is
Ubuntu 8.04, linux kernel version is:

root@my-desktop:/home/my# uname -r
2.6.24-16-generic


the following is disk information, my Ubuntu is installed on /dev/sdb,
/dev/sda is a new disk which is just added.

root@my-desktop:/home/my# fdisk -l

Disk /dev/sda: 2147 MB, 2147483648 bytes
255 heads, 63 sectors/track, 261 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x8fc01c81

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1         261     2096451   83  Linux

Disk /dev/sdb: 16.1 GB, 16106127360 bytes
255 heads, 63 sectors/track, 1958 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00095f72

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1        1870    15020743+  83  Linux
/dev/sdb2            1871        1958      706860    5  Extended
/dev/sdb5            1871        1958      706828+  82  Linux swap / Solaris


but I always fail.
The following is my code :


#include <linux/init.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/errno.h>
#include <linux/blkdev.h>
#include <linux/slab.h>
#include <linux/bio.h>
#include <linux/completion.h>
#include <linux/gfp.h>
#include <linux/ide.h>
#include <asm/page.h>

#define MY_DEV_NAME "/dev/sda1"

MODULE_LICENSE("Dual BSD/GPL");

int tbio_end_io(struct bio * bio, unsigned int bytes_done, int error)
{
	printk(KERN_ALERT "[md]:enter tbio_end_io!\n");
	return 0;
}

int tbio_end_io1(struct bio * bio, unsigned int bytes_done, int error)
{
	printk(KERN_ALERT "[md]:enter tbio_end_io1!\n");
	return 0;
}

void md_read(struct block_device *dev,sector_t sector, int size,
struct page *page)
{
	struct bio *bio = bio_alloc(GFP_NOIO, 1);

	bio->bi_bdev = dev;
	bio->bi_sector = sector;
	bio_add_page(bio, page, size, 0);
	bio->bi_end_io = tbio_end_io1;
	bio->bi_rw = READ;

	submit_bio(rw, bio);
}

void md_write(struct block_device *dev,sector_t sector, int size,
struct page *page)
{
	struct bio *bio = bio_alloc(GFP_NOIO, 1);

	bio->bi_bdev = dev;
	bio->bi_sector = sector;
	bio_add_page(bio, page, size, 0);
	bio->bi_end_io = tbio_end_io;
	bio->bi_rw = WRITE;

	submit_bio(rw, bio);
}

static int __init md_init(void)
{
	printk(KERN_ALERT "[md]:enter init!\n");

        int err = 0;
        struct block_device *dev = NULL;

        struct page *pg = NULL;
		
        struct page *pg1 = NULL;

	const char *info = "Hello World!\n";

        pg = alloc_page(GFP_NOIO);
        if (!pg)
        {
		printk(KERN_ALERT "[md]:alloc_page failed!\n");
                return -1;
        }
        memset(page_address(pg), 0, PAGE_SIZE);
        strcpy((char *)page_address(pg), info);

	printk(KERN_ALERT "The page to write is %s\n",(char *)page_address(pg));

        dev = open_bdev_excl(MY_DEV_NAME, O_RDWR, NULL);
        if (IS_ERR(dev)) {
                printk(KERN_ALERT "open blkdev error!\n");
                return -1;
        }
			
	md_write(dev, 1, strlen(info)+1, pg);
		
	printk(KERN_ALERT "Now read !!!\n");

	pg1 = alloc_page(GFP_NOIO);
        if (!pg1)
        {
		printk(KERN_ALERT "[md]:alloc_page failed!\n");
                return -1;
        }

	md_read(dev, 1, strlen(info)+1, pg1);

	printk(KERN_ALERT "The page just reading is %s\n",(char *)page_address(pg1));

	__free_page(pg1);
		
        __free_page(pg);
        close_bdev_excl(dev);

        return err;
}

static void __exit md_exit(void)
{
        printk(KERN_ALERT "[md]:exit OK!\n");
}

module_init(md_init);
module_exit(md_exit);


The "dmesg" command information is:

[  752.339448] [md]:enter init!
[  752.341971] The page to write is Hello World!
[  752.341985]
[  752.344972] Now read !!!
[  752.346339] ata1.00: WARNING: zero len r/w req     //What does this mean?
[  752.346745] ata1.00: WARNING: zero len r/w req
[  752.346772] ata1.00: WARNING: zero len r/w req
[  752.346777] ata1.00: WARNING: zero len r/w req
[  752.346781] ata1.00: WARNING: zero len r/w req
[  752.346785] ata1.00: WARNING: zero len r/w req
[  752.347183] sd 0:0:0:0: [sda] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
[  752.347454] end_request: I/O error, dev sda, sector 1
[  752.366091] The page just reading is 	               //It should be
"hello world" here, but ......
[  752.370112] ata1.00: WARNING: zero len r/w req
[  752.370152] ata1.00: WARNING: zero len r/w req
[  752.370158] ata1.00: WARNING: zero len r/w req
[  752.370163] ata1.00: WARNING: zero len r/w req
[  752.370167] ata1.00: WARNING: zero len r/w req
[  752.370171] ata1.00: WARNING: zero len r/w req
[  752.370181] sd 0:0:0:0: [sda] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
[  752.370186] end_request: I/O error, dev sda, sector 1


What is the reason and how should I write a page to disk sector
through bio structure?
And how to test if it write successfully instead of use bio->bi_rw = READ ?

Thank you very much!
