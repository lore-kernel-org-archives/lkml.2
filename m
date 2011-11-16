Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1KPL3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:29:34 -0500
Received: from science.horizon.com ([71.41.210.146]:27747 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756141Ab1KPL3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:29:32 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Nov 2011 06:29:31 EST
Date: 16 Nov 2011 06:22:46 -0500
Message-ID: <20111116112246.27848.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 3.1-rc10 oops in nameidata_to_filp
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This morning, I found the following on my laptop.  I hope the kernel
version is recent enough to be useful; the only change between then and
current 3.2-rc2 I noticed is an NFS lease fix, and the machine has no
NFS exports or mounts active.

The laptop is a core 2 duo, running a 32-bit kernel with 2 GB of RAM.
Uptime is 26 days, although obviously it's been asleep for a lot of that.

Non-ECC RAM; it *could* be just a random bit flip, but I'm sending
this out into the world in case it's illuniating to someone with
a deeper understanding of the relevant data structures.

It's running a copy of John Linville's wireless development tree,
but the changes there should not affect core file system activity like
this.  (They're mostly in drivers/net/wireless and net/wireless,
touching *nothing* in fs/ or other core kernel code.)

The exact kernel I'm running is:

> commit 137d0943ea2cbcdbfc38606944fc0b6494f7c935
> Merge: dfd5c52 899e3ee
> Author: John W. Linville <linville@tuxdriver.com>
> Date:   Tue Oct 18 10:52:19 2011 -0400
> 
>     Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torva

899e3ee is v3.1-rc10.  The commit is available at
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=137d0943ea2cbcdbfc38606944fc0b6494f7c935

Local file sytsems are all ext3 or tmpfs.  Although I have mounted NFS
file systems since reboot, they were all unmounted days before the oops.

The machine is still up.  I plan on upgrading the kernel and
rebooting unless someone would like some specific testing.


BUG: unable to handle kernel NULL pointer dereference at 00000018
IP: [<c108a788>] __dentry_open.isra.16+0x12c/0x1ed
*pde = 00000000 
Oops: 0000 [#1] SMP 
Modules linked in: nfs lockd sunrpc serpent xcbc b43 mac80211 cfg80211 rfkill bcma

Pid: 15325, comm: find Not tainted 3.1.0-rc10-wl #281 Dell Inc. MXC061                          /0MG532
EIP: 0060:[<c108a788>] EFLAGS: 00010206 CPU: 0
EIP is at __dentry_open.isra.16+0x12c/0x1ed
EAX: 00000000 EBX: c5c80480 ECX: 00000000 EDX: 00000000
ESI: c003fd0c EDI: 00000000 EBP: c3c9be58 ESP: c3c9be40
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process find (pid: 15325, ti=c3c9a000 task=f4a73390 task.ti=c3c9a000)
Stack:
 cef74480 f62a2d80 c3c9beec c3c9beec cef74480 c5c80480 c3c9be70 c108b309
 00000000 c3c9beec 00000000 00000000 c3c9bea4 c10950fe 00000000 00000001
 c003fd0c 00000024 c1093dad cef74400 00000000 00038900 c3c9beec 0000000b
Call Trace:
 [<c108b309>] nameidata_to_filp+0x33/0x3d
 [<c10950fe>] do_last.isra.49+0x3dc/0x4c3
 [<c1093dad>] ? path_init+0x20d/0x249
 [<c10952ab>] path_openat+0xa1/0x254
 [<c11109b7>] ? copy_to_user+0x3f/0x46
 [<c109549e>] do_filp_open+0x26/0x67
 [<c111080b>] ? might_fault+0x8/0xa
 [<c109cfc3>] ? alloc_fd+0x4e/0xba
 [<c1092ee7>] ? getname_flags+0x6d/0xad
 [<c108b36d>] do_sys_open+0x5a/0xe5
 [<c108b43e>] sys_openat+0x1f/0x25
 [<c1314a90>] sysenter_do_call+0x12/0x26
Code: 85 ff 89 43 10 75 0b 85 c0 74 14 8b 78 2c 85 ff 74 0d 89 da 89 f0 ff d7 85 c0 89 45 f0 75 4d 81 63 20 3f fc ff ff 8b 43 7c 8b 00 <8b> 50 18 8d 43 4c e8 5d 10 fe ff f6 43 21 40 0f 84 a2 00 00 00 
EIP: [<c108a788>] __dentry_open.isra.16+0x12c/0x1ed SS:ESP 0068:c3c9be40
CR2: 0000000000000018
---[ end trace 34290958b6905e19 ]---
