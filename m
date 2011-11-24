Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab1KXQoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 11:44:10 -0500
Received: from science.horizon.com ([71.41.210.146]:22625 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753020Ab1KXQoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 11:44:08 -0500
Date: 24 Nov 2011 11:44:06 -0500
Message-ID: <20111124164406.22919.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: jack@suse.cz, linux@horizon.com
Subject: Re: 3.1-rc10 oops in nameidata_to_filp
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20111124145141.GB22640@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> wrote:
>  Well, probably you also have /proc and other virtual filesystems mounted :)

Yes.  To be precise, the mount list is:
rootfs / rootfs rw 0 0
/dev/root / ext3 rw,relatime,errors=remount-ro,commit=5,barrier=1,data=ordered 0 0
tmpfs /lib/init/rw tmpfs rw,nosuid,relatime,size=5120k,mode=755 0 0
tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=206512k,mode=755 0 0
tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev tmpfs rw,relatime,size=10240k,mode=755 0 0
tmpfs /run/shm tmpfs rw,nosuid,nodev,relatime,size=413024k 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620 0 0
rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0

>  Interesting. So we failed at doing dereference for
> file_ra_state_init(&f->f_ra, f->f_mapping->host->i_mapping);

>   In particular f->f_mapping->host was NULL. That is curious since
> f_mapping is normally initialized to inode->i_mapping (which has ->host
> properly set) shortly before and only devices and similar special inodes
> override this in their ->open() callback to something else. Furthermore I
> see the process doing open() was find(1) which usually opens only
> directories which do not commonly have special ->open callback. So that
> makes things even more strange.

>  So my guess would be that find wandered into some virtual filesystem and
> that set f_mapping to something strange (or had inode->i_mapping not
> initialized properly). Anyway, unless you can reproduce this and find on
> which filesystem this happened, I don't know how to debug this further...

It's been happening every day or so.

[Timestamp Nov 20 07:37:54]
BUG: unable to handle kernel NULL pointer dereference at 00000018
IP: [<c108a788>] __dentry_open.isra.16+0x12c/0x1ed
*pde = 00000000 
Oops: 0000 [#4] SMP 
Modules linked in: nfs lockd sunrpc serpent xcbc b43 mac80211 cfg80211 rfkill bcma

Pid: 15266, comm: find Tainted: G      D     3.1.0-rc10-wl #281 Dell Inc. MXC061                          /0MG532
EIP: 0060:[<c108a788>] EFLAGS: 00010206 CPU: 0
EIP is at __dentry_open.isra.16+0x12c/0x1ed
EAX: 00000000 EBX: ce058580 ECX: 00000000 EDX: 00000000
ESI: c003fd0c EDI: 00000000 EBP: cf03be58 ESP: cf03be40
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process find (pid: 15266, ti=cf03a000 task=d7176cb0 task.ti=cf03a000)
Stack:
 cef74480 f62a2d80 cf03beec cf03beec cef74480 ce058580 cf03be70 c108b309
 00000000 cf03beec 00000000 00000000 cf03bea4 c10950fe 00000000 00000001
 c003fd0c 00000024 c1093dad cef74400 00000000 00038900 cf03beec 0000000a
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
EIP: [<c108a788>] __dentry_open.isra.16+0x12c/0x1ed SS:ESP 0068:cf03be40
CR2: 0000000000000018
---[ end trace 34290958b6905e1c ]---


[Timestamp Nov 23 00:21:04]
BUG: unable to handle kernel NULL pointer dereference at 00000018
IP: [<c108a788>] __dentry_open.isra.16+0x12c/0x1ed
*pde = 00000000 
Oops: 0000 [#5] SMP 
Modules linked in: nfs lockd sunrpc serpent xcbc b43 mac80211 cfg80211 rfkill bcma

Pid: 5856, comm: find Tainted: G      D     3.1.0-rc10-wl #281 Dell Inc. MXC061                          /0MG532
EIP: 0060:[<c108a788>] EFLAGS: 00010206 CPU: 0
EIP is at __dentry_open.isra.16+0x12c/0x1ed
EAX: 00000000 EBX: c93c7380 ECX: 00000000 EDX: 00000000
ESI: c003fd0c EDI: 00000000 EBP: c93c1e58 ESP: c93c1e40
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process find (pid: 5856, ti=c93c0000 task=cbac8a50 task.ti=c93c0000)
Stack:
 cef74480 f62a2d80 c93c1eec c93c1eec cef74480 c93c7380 c93c1e70 c108b309
 00000000 c93c1eec 00000000 00000000 c93c1ea4 c10950fe 00000000 00000001
 c003fd0c 00000024 c1093dad cef74400 00000000 00038900 c93c1eec 0000000b
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
EIP: [<c108a788>] __dentry_open.isra.16+0x12c/0x1ed SS:ESP 0068:c93c1e40
CR2: 0000000000000018
---[ end trace 34290958b6905e1d ]---


[Timestamp Nov 24 08:01:32]
BUG: unable to handle kernel NULL pointer dereference at 00000018
IP: [<c108a788>] __dentry_open.isra.16+0x12c/0x1ed
*pde = 00000000 
Oops: 0000 [#6] SMP 
Modules linked in: nfs lockd sunrpc serpent xcbc b43 mac80211 cfg80211 rfkill bcma

Pid: 11313, comm: find Tainted: G      D     3.1.0-rc10-wl #281 Dell Inc. MXC061                          /0MG532
EIP: 0060:[<c108a788>] EFLAGS: 00010206 CPU: 1
EIP is at __dentry_open.isra.16+0x12c/0x1ed
EAX: 00000000 EBX: d09da800 ECX: 00000000 EDX: 00000000
ESI: c003fd0c EDI: 00000000 EBP: f45bde58 ESP: f45bde40
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process find (pid: 11313, ti=f45bc000 task=f4ad1130 task.ti=f45bc000)
Stack:
 cef74480 f62a2d80 f45bdeec f45bdeec cef74480 d09da800 f45bde70 c108b309
 00000000 f45bdeec 00000000 00000000 f45bdea4 c10950fe 00000000 00000001
 c003fd0c 00000024 c1093dad cef74400 00000000 00038900 f45bdeec 0000000b
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
EIP: [<c108a788>] __dentry_open.isra.16+0x12c/0x1ed SS:ESP 0068:f45bde40
CR2: 0000000000000018
---[ end trace 34290958b6905e1e ]---

It turned out the machine was quite recoverable and I've been running it without rebooting since then.
This includes several suspends to RAM and one to disk.

So far, it seems pretty reproducible, but I suppose it could be a kernel bit flip.
(F***ing Intel not even *allowing* ECC in "consumer" chipsets...)

I should probably add a debugging patch and reboot.  Is there a debugging helper
for printing a dentry and vfsmount?
