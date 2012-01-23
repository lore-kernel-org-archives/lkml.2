Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab2AWSJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:09:09 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:58073 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2AWSJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:09:08 -0500
Date: Mon, 23 Jan 2012 13:06:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, bp@amd64.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        lenb@kernel.org
Cc: xen-devel@lists.xensource.com
Subject: WARN... Device 'cpu1' does not have a release() function, it is
 broken and must be fixed. when doing 'xl vcpu-set <guest_id> 1'
Message-ID: <20120123180601.GA24553@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F1DA214.00D3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I bring a CPU down in a guest (which should be the same as bringing a
CPU down using the ACPI framework), I get this:

[   14.484206] SMP alternatives: switching to UP code
[   14.514287] ------------[ cut here ]------------
[   14.514318] WARNING: at /home/konrad/linux-linus/drivers/base/core.c:194 device_release+0x82/0x90()
[   14.514354] Device 'cpu1' does not have a release() function, it is broken and must be fixed.
[   14.514386] Modules linked in: radeon fbcon tileblit font ttm bitblit softcursor drm_kms_helper xen_blkfront xen_netfront xen_fbfront fb_sys_fops sysimgblt sysfillrect syscopyarea xen_kbdfront xenfs xen_privcmd
[   14.514557] Pid: 22, comm: xenwatch Not tainted 3.3.0-rc1 #1
[   14.514586] Call Trace:
[   14.515094]  [<ffffffff810897fa>] warn_slowpath_common+0x7a/0xb0
[   14.515094]  [<ffffffff810898d1>] warn_slowpath_fmt+0x41/0x50
[   14.515094]  [<ffffffff813dea02>] device_release+0x82/0x90
[   14.515094]  [<ffffffff812dfb85>] kobject_release+0x45/0x90
[   14.515094]  [<ffffffff812dfa4c>] kobject_put+0x2c/0x60
[   14.515094]  [<ffffffff813de6a2>] put_device+0x12/0x20
[   14.515094]  [<ffffffff813df409>] device_unregister+0x19/0x20
[   14.515094]  [<ffffffff813e4edf>] unregister_cpu+0x4f/0x80
[   14.515094]  [<ffffffff81052c7c>] arch_unregister_cpu+0x1c/0x20
[   14.515094]  [<ffffffff8137f787>] handle_vcpu_hotplug_event+0xc7/0xd0
[   14.515094]  [<ffffffff8137b900>] xenwatch_thread+0xb0/0x180
[   14.515094]  [<ffffffff810ad3f0>] ? wake_up_bit+0x40/0x40
[   14.515094]  [<ffffffff8137b850>] ? split+0xf0/0xf0
[   14.515094]  [<ffffffff810acd16>] kthread+0x96/0xa0
[   14.515094]  [<ffffffff816151e4>] kernel_thread_helper+0x4/0x10
[   14.515094]  [<ffffffff8160cc80>] ? retint_restore_args+0x5/0x6
[   14.515094]  [<ffffffff816151e0>] ? gs_change+0x13/0x13
[   14.515094] ---[ end trace 8f70af51a2e2611f ]---

Looking at "commit e032d80774315869aa2285b217fdbbfed86c0b49
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Mon Jan 16 14:40:28 2012 -0800

    mce: fix warning messages about static struct mce_device
"

it looks like the corret fix is to make the 'cpu_devices' in
arch/x86/kernel/topology.c to be changed to be more dynamic
(or perhaps have an empty release function)?

Is anybody else hitting this with ACPI CPU hot-unplug? Or do I have
the privilige of being the first? Oh, I hadn't done a full bisection
but v3.2 does not have this.

The guest config is quite simple:
extra="console=hvc0 debug earlyprintk=xen memblock=debug"
kernel="/mnt/lab/bootstrap-x86_64/vmlinuz"
ramdisk="/mnt/lab/bootstrap-x86_64/initramfs.cpio.gz"
memory=1024
maxmem=2048
vcpus=2
name="bootstrap-x86_64"
on_crash="preserve"
vfb = [ 'vnc=1, vnclisten=0.0.0.0,vncunused=1']
