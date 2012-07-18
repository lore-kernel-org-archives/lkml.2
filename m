Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab2GRFQC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 01:16:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:12473 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab2GRFPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 01:15:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="179331449"
Date: Wed, 18 Jul 2012 13:15:52 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: show_uevent() and general protection fault
Message-ID: <20120718051552.GA9124@localhost>
References: <20120713083140.GA19738@localhost>
 <20120713084616.GA20037@localhost>
 <20120717013342.GD21914@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120717013342.GD21914@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 06:33:42PM -0700, Greg Kroah-Hartman wrote:
> On Fri, Jul 13, 2012 at 04:46:16PM +0800, Fengguang Wu wrote:
> > This is another kconfig, produced a bit different call trace, however
> > also related to sysfs_read_file().
> 
> Any hint as to which file is being read?

Good idea! I added this debugging aid:

--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -129,6 +129,11 @@ sysfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
        struct sysfs_buffer * buffer = file->private_data;
        ssize_t retval = 0;
+       char pathname[300], *path;
+
+       path = d_path(&(file->f_path), pathname, sizeof(pathname));
+       if (!IS_ERR(path))
+               printk("%s\n", path);
 
        mutex_lock(&buffer->mutex);
        if (buffer->needs_read_fill || *ppos == 0) {

And find some sysfs files that triggered the errors:

wfg@waimea ~/kvm% grep -hB1 'kernel paging request' /tmp/dmesg-kvm_bisect-waimea-*|grep /sys/               
[   28.995741] /sys/module/tpm_tis/parameters/hid
[   60.885798] /sys/module/tpm_tis/parameters/hid

wfg@waimea ~/kvm% grep -hB1 'general protection fault' /tmp/dmesg-kvm_bisect-waimea-*|grep -o /sys/.* | sort -u
/sys/devices/LNXSYSTM:00/device:00/PNP0103:00/uevent
/sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:21/PNP0303:00/uevent
/sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:21/PNP0400:00/uevent
/sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:21/PNP0501:00/uevent
/sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:21/PNP0700:00/uevent
/sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:21/PNP0B00:00/uevent
/sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:21/PNP0F13:00/uevent
/sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/uevent
/sys/devices/LNXSYSTM:00/device:00/PNP0C0F:00/uevent
/sys/devices/LNXSYSTM:00/device:00/PNP0C0F:01/uevent
/sys/devices/LNXSYSTM:00/device:00/PNP0C0F:02/uevent
/sys/devices/LNXSYSTM:00/device:00/PNP0C0F:03/uevent
/sys/devices/LNXSYSTM:00/LNXCPU:00/uevent
/sys/devices/LNXSYSTM:00/LNXCPU:01/uevent
/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0/uevent
/sys/devices/LNXSYSTM:00/LNXPWRBN:00/uevent
/sys/devices/LNXSYSTM:00/uevent
/sys/devices/platform/i8042/serio0/input/input1/uevent

Thanks,
Fengguang
