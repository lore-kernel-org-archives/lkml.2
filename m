Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595Ab2HQCGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:06:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:59977 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677Ab2HQCG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:06:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,782,1336374000"; 
   d="scan'208";a="203197794"
Date: Fri, 17 Aug 2012 10:06:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, devel@driverdev.osuosl.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: show_uevent() and general protection fault
Message-ID: <20120817020608.GA24538@localhost>
References: <20120713083140.GA19738@localhost>
 <20120713084616.GA20037@localhost>
 <20120717013342.GD21914@kroah.com>
 <20120718051552.GA9124@localhost>
 <20120816172711.GB27415@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816172711.GB27415@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 10:27:11AM -0700, Greg KH wrote:
> On Wed, Jul 18, 2012 at 01:15:52PM +0800, Fengguang Wu wrote:
> > On Mon, Jul 16, 2012 at 06:33:42PM -0700, Greg Kroah-Hartman wrote:
> > > On Fri, Jul 13, 2012 at 04:46:16PM +0800, Fengguang Wu wrote:
> > > > This is another kconfig, produced a bit different call trace, however
> > > > also related to sysfs_read_file().
> > > 
> > > Any hint as to which file is being read?
> > 
> > Good idea! I added this debugging aid:
> > 
> > --- a/fs/sysfs/file.c
> > +++ b/fs/sysfs/file.c
> > @@ -129,6 +129,11 @@ sysfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
> >  {
> >         struct sysfs_buffer * buffer = file->private_data;
> >         ssize_t retval = 0;
> > +       char pathname[300], *path;
> > +
> > +       path = d_path(&(file->f_path), pathname, sizeof(pathname));
> > +       if (!IS_ERR(path))
> > +               printk("%s\n", path);
> >  
> >         mutex_lock(&buffer->mutex);
> >         if (buffer->needs_read_fill || *ppos == 0) {
> > 
> > And find some sysfs files that triggered the errors:
> > 
> > wfg@waimea ~/kvm% grep -hB1 'kernel paging request' /tmp/dmesg-kvm_bisect-waimea-*|grep /sys/               
> > [   28.995741] /sys/module/tpm_tis/parameters/hid
> > [   60.885798] /sys/module/tpm_tis/parameters/hid
> > 
> > wfg@waimea ~/kvm% grep -hB1 'general protection fault' /tmp/dmesg-kvm_bisect-waimea-*|grep -o /sys/.* | sort -u
> > /sys/devices/LNXSYSTM:00/device:00/PNP0103:00/uevent
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:21/PNP0303:00/uevent
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:21/PNP0400:00/uevent
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:21/PNP0501:00/uevent
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:21/PNP0700:00/uevent
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:21/PNP0B00:00/uevent
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:21/PNP0F13:00/uevent
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/uevent
> > /sys/devices/LNXSYSTM:00/device:00/PNP0C0F:00/uevent
> > /sys/devices/LNXSYSTM:00/device:00/PNP0C0F:01/uevent
> > /sys/devices/LNXSYSTM:00/device:00/PNP0C0F:02/uevent
> > /sys/devices/LNXSYSTM:00/device:00/PNP0C0F:03/uevent
> > /sys/devices/LNXSYSTM:00/LNXCPU:00/uevent
> > /sys/devices/LNXSYSTM:00/LNXCPU:01/uevent
> > /sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0/uevent
> > /sys/devices/LNXSYSTM:00/LNXPWRBN:00/uevent
> > /sys/devices/LNXSYSTM:00/uevent
> > /sys/devices/platform/i8042/serio0/input/input1/uevent
> 
> This is odd, I can't duplicate it at all, is it still showing up for
> you?

Yes, and I got to know why with this debug patch.

> --- tip.orig/drivers/base/core.c        2012-08-17 08:48:07.101972082 +0800
> +++ tip/drivers/base/core.c     2012-08-17 09:49:43.665912992 +0800
> @@ -343,8 +343,11 @@ static ssize_t show_uevent(struct device
>                 goto out;
>  
>         /* copy keys to file */
> -       for (i = 0; i < env->envp_idx; i++)
> +       printk(KERN_ERR "uevent %d env[%d]: %s/.../%s\n", env->buflen, env->envp_idx, top_kobj->name, dev->kobj.name);
> +       for (i = 0; i < env->envp_idx; i++) {
> +               printk(KERN_ERR "uevent %d env[%d]: %s\n", (int)count, i, env->envp[i]);
>                 count += sprintf(&buf[count], "%s\n", env->envp[i]);
> +       }
>  out:
>         kfree(env);
>         return count;

It's printing 32 strings of "(null)\n" (7 characters each) to the buffer,
which eventually overflows it.

[   65.968387] uevent 12 env[1627389952]: LNXCPU:01/.../LNXCPU:01
[   65.969586] uevent 0 env[0]: (null)
[   65.970463] uevent 7 env[1]: (null)
[   65.971338] uevent 14 env[2]: (null)
[   65.972225] uevent 21 env[3]: (null)
[   65.973111] uevent 28 env[4]: (null)
[   65.973952] uevent 35 env[5]: (null)
[   65.974852] uevent 42 env[6]: (null)
[   65.975735] uevent 49 env[7]: (null)
[   65.976627] uevent 56 env[8]: (null)
[   65.977545] uevent 63 env[9]: (null)
[   65.978469] uevent 70 env[10]: (null)
[   65.979410] uevent 77 env[11]: (null)
[   65.980321] uevent 84 env[12]: (null)
[   65.981243] uevent 91 env[13]: (null)
[   65.982159] uevent 98 env[14]: (null)
[   65.983080] uevent 105 env[15]: (null)
[   65.983972] uevent 112 env[16]: (null)
[   65.984908] uevent 119 env[17]: (null)
[   65.985850] uevent 126 env[18]: (null)
[   65.986797] uevent 133 env[19]: (null)
[   65.987768] uevent 140 env[20]: (null)
[   65.988723] uevent 147 env[21]: (null)
[   65.989661] uevent 154 env[22]: (null)
[   65.990591] uevent 161 env[23]: (null)
[   65.991527] uevent 168 env[24]: (null)
[   65.992452] uevent 175 env[25]: (null)
[   65.993383] uevent 182 env[26]: (null)
[   65.994386] uevent 189 env[27]: (null)
[   65.995342] uevent 196 env[28]: (null)
[   65.996289] uevent 203 env[29]: (null)
[   65.997243] uevent 210 env[30]: (null)
[   65.998197] uevent 217 env[31]: (null)
[   65.999124] general protection fault: 0000 [#1] PREEMPT 
[   66.000106] CPU 0 
[   66.000106] Pid: 128, comm: trinity-child0 Not tainted 3.6.0-rc1-bisect2-00037-gdfdf036-dirty #8 Bochs Bochs
[   66.000106] RIP: 0010:[<ffffffff811cb0bc>]  [<ffffffff811cb0bc>] strnlen+0x2e/0x37
...
[   66.000106] Call Trace:
[   66.000106]  [<ffffffff811cc700>] string.isra.3+0x49/0xe6
[   66.000106]  [<ffffffff811cd511>] vsnprintf+0x267/0x6dd
[   66.000106]  [<ffffffff810a0001>] ? compat_sys_clock_gettime+0x12/0x91
[   66.000106]  [<ffffffff8181dd30>] ? retint_restore_args+0x13/0x13
[   66.000106]  [<ffffffff811cdda0>] vscnprintf+0x16/0x3a
[   66.000106]  [<ffffffff8104bc95>] vprintk_emit+0x313/0x66f
[   66.000106]  [<ffffffff811cd34b>] ? vsnprintf+0xa1/0x6dd
[   66.000106]  [<ffffffff81804bc9>] printk+0x4f/0x58
[   66.000106]  [<ffffffff812c6b4b>] show_uevent+0x164/0x1db
[   66.000106]  [<ffffffff812c67c3>] dev_attr_show+0x29/0x77
[   66.000106]  [<ffffffff81153a1d>] ? sysfs_read_file+0xc5/0x221
[   66.000106]  [<ffffffff810cfab4>] ? __get_free_pages+0x2f/0x6a
[   66.000106]  [<ffffffff81153a55>] sysfs_read_file+0xfd/0x221
[   66.000106]  [<ffffffff8110264d>] vfs_read+0xdb/0x1c1
[   66.000106]  [<ffffffff81102a47>] sys_read+0x56/0x9e

Thanks,
Fengguang
