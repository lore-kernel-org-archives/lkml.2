Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab1ETSFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:05:15 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:9835 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1ETSFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:05:13 -0400
Message-ID: <4DD6AD51.7090900@tilera.com>
Date: Fri, 20 May 2011 14:05:05 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: Re: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM
 driver
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com> <201105050841.40576.arnd@arndb.de>
In-Reply-To: <201105050841.40576.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/2011 2:41 AM, Arnd Bergmann wrote:
> On Wednesday 04 May 2011, Chris Metcalf wrote:
>> This commit does two things: it adds the infrastructure for a new
>> arch/tile/drivers/ directory, and it populates it with the first
>> instance of a driver for that directory, a SPI Flash ROM (srom) driver.
>>
>> [...]
> I generally advise against putting any device drivers into arch/*/,
> on the ground that it is much easier to find similar drivers when
> they are in a common place. We probably have a few similar drivers
> in the tree already, e.g drivers/misc/eeprom/* and drivers/char/ps3flash.c
> and drivers/platform/x86/intel_scu_ipcutil.c are examples of preexisting
> drivers.
>
> I'd probably put this one in driver/misc/eeprom and make the interface
> look like the other ones (sysfs bin attribute instead of character
> device), which is a trivial change.
>
> [...]
>> The actual SROM driver is fairly uncontroversial, and is just a simple
>> driver that allows user space to read and write the SROM at a raw level.
>> (A separate MTD driver exists for "tile", but this is not that driver.)
>> The driver is particularly useful since the Tile chip can boot directly
>> from the SROM, so providing this driver interface allows for updating
>> the boot image prior to a reboot.
> I think the sysfs bin attribute works well here because you don't need
> any ioctl, and the contents are basically a representation of a flat
> file. The implementation would be almost the same.

This works well, except for the fact that we take advantage of the fact
that the hypervisor driver internally buffers up writes to the current
EEPROM sector, and flushes it to hardware only when explicitly told to do
so, or when we start writing to another sector.  This avoids excessive wear
on the EEPROM and also handles detection of whether we need to do a sector
erase before the re-write.  However, it also means that we need to be able
to issue the final explicit flush, or else the last write just sits in the
hypervisor buffer indefinitely.  To make that happen I think I need to
extend the bin_attribute structure, and the bin.c release() function, slightly:

--- fs/sysfs/bin.c~   2011-05-20 14:02:43.000000000 -0400
+++ fs/sysfs/bin.c  2011-05-20 13:31:23.240866000 -0400
@@ -434,18 +434,26 @@
 }

 static int release(struct inode * inode, struct file * file)
 {
        struct bin_buffer *bb = file->private_data;
+       struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
+       struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
+       int rc = 0;
+
+       if (attr->release && sysfs_get_active(attr_sd)) {
+               rc = attr->release(file, attr_sd->s_parent->s_dir.kobj, attr);
+               sysfs_put_active(attr_sd);
+       }

        mutex_lock(&sysfs_bin_lock);
        hlist_del(&bb->list);
        mutex_unlock(&sysfs_bin_lock);

        kfree(bb->buffer);
        kfree(bb);
-       return 0;
+       return rc;
 }

 const struct file_operations bin_fops = {
        .read           = read,
        .write          = write,
--- include/linux/sysfs.h~   2011-05-20 14:02:43.000000000 -0400
+++ include/linux/sysfs.h   2011-05-20 13:23:57.915080000 -0400
@@ -93,10 +93,11 @@
                        char *, loff_t, size_t);
        ssize_t (*write)(struct file *,struct kobject *, struct bin_attribute *,
                         char *, loff_t, size_t);
        int (*mmap)(struct file *, struct kobject *, struct bin_attribute *attr,
                    struct vm_area_struct *vma);
+       int (*release)(struct file *, struct kobject *, struct bin_attribute *);
 };

 /**
  *     sysfs_bin_attr_init - initialize a dynamically allocated bin_attribute
  *     @attr: struct bin_attribute to initialize



This change shouldn't require any changes to any other bin_attribute users
elsewhere in the kernel.

If something like this seems plausible, I already have the patch ready, and
I can send it to LKML.  I've cc'ed Greg K-H and a few other recent
submitters to bin.c in case they'd like to weigh in at this point too; thanks.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


