Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab2AVAwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 19:52:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45905 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2AVAwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 19:52:10 -0500
Date: Sun, 22 Jan 2012 00:51:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: linux-pcmcia@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [BUG] PCMCIA card inserted, five s2ram cycles, you're dead
Message-ID: <20120122005151.GA12326@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM platform, a pcnet_cs CF card inserted in pcmcia_socket0's slot
which works after each resume.

The messages below are produced by:
printk("%s: %p [%s] %u\n", __func__, dev, kobject_name(&dev->kobj), atomic_read(&dev->kobj.kref.refcount));

placed before get_device() in each of the stated functions in
drivers/base/power/main.c.  As you will notice, the kref count for
pcmcia_socket0 decrements each resume until it explodes.  I suspect
there's a bug somewhere in the PCMCIA code, possibly here:

static int pcmcia_bus_early_resume(struct pcmcia_socket *skt)
{
        if (!verify_cis_cache(skt)) {
                pcmcia_put_socket(skt);
                return 0;
        }

I've not been able to check that theory tonight.  Maybe someone who
knows the code can suggest - if not, I'll try deleting that
pcmcia_put_socket() call at some point tomorrow.

On the 3rd suspend/resume cycle:

dpm_prepare: c1a0d998 [pcmcia_socket0] 3
dpm_suspend: c1a0d998 [pcmcia_socket0] 3
dpm_suspend_noirq: c1a0d998 [pcmcia_socket0] 3
dpm_resume_noirq: c1a0d998 [pcmcia_socket0] 3
dpm_resume: c1a0d998 [pcmcia_socket0] 3
dpm_complete: c1a0d998 [pcmcia_socket0] 2

On the 4th suspend/resume cycle:

dpm_prepare: c1a0d998 [pcmcia_socket0] 2
dpm_suspend: c1a0d998 [pcmcia_socket0] 2
dpm_suspend_noirq: c1a0d998 [pcmcia_socket0] 2
dpm_resume_noirq: c1a0d998 [pcmcia_socket0] 2
dpm_resume: c1a0d998 [pcmcia_socket0] 2
dpm_complete: c1a0d998 [pcmcia_socket0] 1

On the 5th suspend/resume cycle:

dpm_prepare: c1a0d998 [pcmcia_socket0] 1
dpm_suspend: c1a0d998 [pcmcia_socket0] 1
dpm_suspend_noirq: c1a0d998 [pcmcia_socket0] 1
dpm_resume_noirq: c1a0d998 [pcmcia_socket0] 1
dpm_resume: c1a0d998 [pcmcia_socket0] 1
dpm_complete: c1a0d998 [pcmcia_socket0] 0
------------[ cut here ]------------
WARNING: at include/linux/kref.h:41 kobject_get+0x28/0x50()
Modules linked in: ucb1x00_core
Backtrace: [<c0212090>] (dump_backtrace+0x0/0x110) from [<c04799dc>] (dump_stack+0x18/0x1c)
 r7:00000000 r6:c0335374 r5:c0500312 r4:00000029
[<c04799c4>] (dump_stack+0x0/0x1c) from [<c021cba0>] (warn_slowpath_common+0x50/0x68)
[<c021cb50>] (warn_slowpath_common+0x0/0x68) from [<c021cbdc>] (warn_slowpath_null+0x24/0x28)
 r8:c0adbe74 r7:c05811e0 r6:c1a19234 r5:c1a0d998 r4:c1a0d9a0
[<c021cbb8>] (warn_slowpath_null+0x0/0x28) from [<c0335374>] (kobject_get+0x28/0x50)
[<c033534c>] (kobject_get+0x0/0x50) from [<c03804f4>] (get_device+0x1c/0x24)
 r4:c1a0da18
[<c03804d8>] (get_device+0x0/0x24) from [<c0388cec>] (dpm_complete+0x5c/0x1a0)
[<c0388c90>] (dpm_complete+0x0/0x1a0) from [<c0389cc0>] (dpm_resume_end+0x1c/0x20)
 r8:c05a9864 r7:00000003 r6:c059ada4 r5:00000000 r4:00000010
[<c0389ca4>] (dpm_resume_end+0x0/0x20) from [<c0245668>] (suspend_devices_and_enter+0x1ac/0x1f8)
 r4:00000000
[<c02454bc>] (suspend_devices_and_enter+0x0/0x1f8) from [<c02457b0>] (enter_state+0xfc/0x144)
 r8:c0aac000 r7:c04803c0 r6:00000003 r5:00000003 r4:00000000
[<c02456b4>] (enter_state+0x0/0x144) from [<c02446fc>] (state_store+0x9c/0x11c)
 r5:00000003 r4:c05009ad
[<c0244660>] (state_store+0x0/0x11c) from [<c0334da0>] (kobj_attr_store+0x28/0x2c)
[<c0334d78>] (kobj_attr_store+0x0/0x2c) from [<c02d7848>] (sysfs_write_file+0x10c/0x144)
[<c02d773c>] (sysfs_write_file+0x0/0x144) from [<c0289d2c>] (vfs_write+0xb8/0x144)
[<c0289c74>] (vfs_write+0x0/0x144) from [<c0289e88>] (sys_write+0x4c/0x7c)
 r8:c020f4a4 r7:00000004 r6:c0ae0cc0 r5:00000000 r4:00000000
[<c0289e3c>] (sys_write+0x0/0x7c) from [<c020f300>] (ret_fast_syscall+0x0/0x2c)
 r6:b6f09c64 r5:00000004 r4:0209a408
---[ end trace 589b3a68dda1e5cd ]---

