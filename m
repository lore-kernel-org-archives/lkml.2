Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab1DTFuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 01:50:13 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34788 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab1DTFuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 01:50:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=cSDtwvFQTKudhDRTw94caH5R4O8JG5LuKAUQYE/ojq95YdJmA2Xogmvxi/PEBo7dnH
         5ywh5aO08TIKdTkZWmM8+d5+yz8uTXIeyYr3BbjGRjDRnYjiLXDvnJgghb87zu4YhYBK
         oBDVTz1kzMgi8Er9BlZhQuOKsD6R6esHZmjJ8=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=8U3=E0=j8MJ-r70O_aO8Pxvv9Nw@mail.gmail.com>
References: <BANLkTi=8U3=E0=j8MJ-r70O_aO8Pxvv9Nw@mail.gmail.com>
Date: Wed, 20 Apr 2011 13:50:10 +0800
Message-ID: <BANLkTi=F8u7oZM+=W+5vzmvf1b0YiN0fQg@mail.gmail.com>
Subject: [2.6.39-rc2, framebuffer] use after free oops
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any ideas on how best to address this issue [0], since it causes
silent corruption, or at best crashes?

Thanks,
  Daniel

--- [0]

When building in the eg vga16 and intelfb framebuffers and page
debugging, we can get hit by a use-after-free oops [1]; with page
debugging disabled, this slips by unnoticed.

When intelfb registers, the vga16 framebuffer is detected covering
it's I/O regions, so it is removed (in
remove_conflicting_framebuffers->unregister_framebuffer). The problem
is the fb_info structure is freed (in
unregister_framebuffer->vga16fb_destroy->framebuffer_release->kfree)
before all open files to it are closed, so we get a use-after-free
scenario.

Freeing should be deferred until the last user has gone away. What
approach would make sense here?

Daniel

--- [1]

checking generic (a0000 10000) vs hw (d0000000 10000000)
fb: conflicting fb hw usage inteldrmfb vs VGA16 VGA - removing generic driver
Console: switching to colour VGA+ 80x25
BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
IP: [<ffffffff81708394>] mutex_lock_nested+0x94/0x390
PGD 2203ab067 PUD 2203ac067 PMD 0
Oops: 0002 [#2] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:1b.0/sound/card0/uevent
CPU 3
Modules linked in: arc4 ecb uvcvideo videodev v4l2_compat_ioctl32
i915(+) drm_kms_helper iwlagn mmc_block mac80211 drm video sdhci_pci
sdhci mmc_core

Pid: 271, comm: plymouthd Tainted: G      D     2.6.39-rc2-350cd+ #1
Dell Inc. Latitude E5420/0H5TG2
RIP: 0010:[<ffffffff81708394>]  [<ffffffff81708394>]
mutex_lock_nested+0x94/0x390
RSP: 0018:ffff88021ee77c08  EFLAGS: 00010046
RAX: 0000000000010000 RBX: 0000000000000008 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff8170838b
RBP: ffff88021ee77c78 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88021e574020
R13: 0000000000000010 R14: 0000000000000246 R15: ffff88021de6f478
FS:  00007f50d6e9c720(0000) GS:ffff88022ec60000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 00000002203aa000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process plymouthd (pid: 271, threadinfo ffff88021ee76000, task ffff88021e574020)
Stack:
 ffffffff81375552 0000000000000000 00000000fffffff2 ffff88021de6f478
 ffff88021e574020 0000000000000246 0000000000000000 00000000fffffff2
 ffff88021ee77c68 0000000000000000 0000000000000008 0000000000000000
Call Trace:
 [<ffffffff81375552>] ? lock_fb_info+0x22/0x60
 [<ffffffff81375552>] lock_fb_info+0x22/0x60
 [<ffffffff8137a24b>] fb_set_user_cmap+0x15b/0x1a0
 [<ffffffff81376e28>] do_fb_ioctl+0x4b8/0x5e0
 [<ffffffff81105dae>] ? might_fault+0x4e/0xa0
 [<ffffffff81058e61>] ? get_parent_ip+0x11/0x50
 [<ffffffff81058f3d>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffff8170a26d>] ? _raw_spin_unlock_irqrestore+0x3d/0x80
 [<ffffffff8104840e>] ? __wake_up+0x4e/0x70
 [<ffffffff813e47b9>] ? put_ldisc+0x59/0xd0
 [<ffffffff813e4839>] ? tty_ldisc_deref+0x9/0x10
 [<ffffffff813def59>] ? tty_ioctl+0x299/0xa00
 [<ffffffff81377214>] fb_ioctl+0x24/0x30
 [<ffffffff81152ec7>] do_vfs_ioctl+0x87/0x330
 [<ffffffff81140e85>] ? fget+0x95/0x240
 [<ffffffff81140df0>] ? fget_raw+0x240/0x240
 [<ffffffff811531ba>] sys_ioctl+0x4a/0x80
 [<ffffffff8170adfb>] system_call_fastpath+0x16/0x1b
Code: 48 8b 04 25 c8 b5 00 00 8b 80 44 e0 ff ff a9 00 ff ff 07 0f 85
d7 02 00 00 9c 41 5e fa e8 15 d2 98 ff 4c 8d 6b 08 b8 00 00 01 00 <f0>
0f c1 43 08 0f b7 d0 c1 e8 10 39 c2 74 08 f3 90 0f b7 53 08
RIP  [<ffffffff81708394>] mutex_lock_nested+0x94/0x390
 RSP <ffff88021ee77c08>
CR2: 0000000000000010
---[ end trace cdacd65f5f1b187d ]---
note: plymouthd[271] exited with preempt_count 1
--
Daniel J Blueman



-- 
Daniel J Blueman
