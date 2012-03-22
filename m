Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab2CVSMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:12:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37714 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab2CVSMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:12:43 -0400
MIME-Version: 1.0
In-Reply-To: <8414.1332439350@turing-police.cc.vt.edu>
References: <8414.1332439350@turing-police.cc.vt.edu>
Date: Thu, 22 Mar 2012 14:12:42 -0400
Message-ID: <CACLa4pu22sZm4STNSXoOfeyw1BRK06Gu30Ec=6RAqUP+egxRHw@mail.gmail.com>
Subject: Re: 3.3.0-next-20120321 crash in mls_compute_sid at boot time...
From: Eric Paris <eparis@parisplace.org>
To: Valdis.Kletnieks@vt.edu
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's known and should be fixed in linux-next from today.  If not, let me know!

On Thu, Mar 22, 2012 at 2:02 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> Repeatable crash (3 for 3) at boot on my Dell Latitude laptop.  Userspace is
> Fedora Rawhide, works OK on 3.3.0-rc6-next-20120305, so broken in the last 2
> weeks or so. I'll go ahead and bisect it over the next few days if nobody
> recognizes the issue..
>
> successful boot from next-20120305:
> [   57.293391] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
> [   57.293427] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
> [   57.299341] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [   57.299420] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [   57.301381] SELinux: initialized (dev dm-3, type ext4), uses xattr
> [   57.301929] SELinux: initialized (dev dm-6, type ext4), uses xattr
> [   57.389391] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [   57.391364] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
> [   57.580314] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
> [   57.583127] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
>
> and we continue.  On 0321, we apparently bomb on the tmpfs after dm-6 (which
> assuming we're walking in /proc/mounts order would be /run:
>
> /dev/mapper/vg_blackice-root / ext4 rw,seclabel,relatime,user_xattr,barrier=1,data=ordered 0 0
> /dev/mapper/vg_blackice-usr /usr ext4 rw,seclabel,relatime,user_xattr,barrier=1,data=ordered 0 0
> tmpfs /run tmpfs rw,seclabel,nosuid,nodev,relatime,mode=755 0 0
>
> In any case, it would be one of these:
>
> % grep tmpfs /proc/mounts
> devtmpfs /dev devtmpfs rw,seclabel,nosuid,relatime,size=2009804k,nr_inodes=502451,mode=755 0 0
> tmpfs /dev/shm tmpfs rw,seclabel,relatime 0 0
> tmpfs /run tmpfs rw,seclabel,nosuid,nodev,relatime,mode=755 0 0
> tmpfs /sys/fs/cgroup tmpfs rw,seclabel,nosuid,nodev,noexec,relatime,mode=755 0 0
> tmpfs /media tmpfs rw,seclabel,nosuid,nodev,noexec,relatime,mode=755 0 0
> tmpfs /tmp tmpfs rw,seclabel,relatime,size=1048576k 0 0
> tmpfs /var/run tmpfs rw,seclabel,nosuid,nodev,relatime,mode=755 0 0
> tmpfs /var/lock tmpfs rw,seclabel,nosuid,nodev,relatime,mode=755 0 0
>
> The traceback:
> [   28.049217] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [   28.049434] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [   28.051332] SELinux: initialized (dev dm-3, type ext4), uses xattr
> [   28.051878] SELinux: initialized (dev dm-6, type ext4), uses xattr
> [   28.064712] type=1403 audit(1332432761.063:2): policy loaded auid=4294967295 ses=4294967295
> [   28.069261] BUG: unable to handle kernel NULL pointer dereference at 000000000000003b
> [   28.069558] IP: [<ffffffff81219974>] mls_compute_sid+0x99/0x104
> [   28.069758] PGD 117754067 PUD 116907067 PMD 0
> [   28.070076] Oops: 0000 [#1] PREEMPT SMP
> [   28.070076] CPU 1
> [   28.070076] Modules linked in:
> [   28.070076]
> [   28.070076] Pid: 1, comm: systemd Not tainted 3.3.0-next-20120321 #4 Dell Inc. Latitude E6500           /
> [   28.070076] RIP: 0010:[<ffffffff81219974>]  [<ffffffff81219974>] mls_compute_sid+0x99/0x104
> [   28.070076] RSP: 0018:ffff88011a097cd8  EFLAGS: 00010246
> [   28.070076] RAX: 0000000000000000 RBX: ffff8801172320c8 RCX: 0000000000000010
> [   28.070076] RDX: 0000000000000000 RSI: ffff88011a097cec RDI: ffff880117329420
> [   28.070076] RBP: ffff88011a097d18 R08: ffff88011a097d80 R09: 0000000000000000
> [   28.070076] R10: ffff880118d78000 R11: 0000000000000000 R12: ffff8801190a5248
> [   28.070076] R13: 0000000000000000 R14: ffff8801190a5248 R15: ffff8801172320c8
> [   28.070076] FS:  00007fd07127c840(0000) GS:ffff88011fd00000(0000) knlGS:0000000000000000
> [   28.070076] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   28.070076] CR2: 000000000000003b CR3: 0000000117559000 CR4: 00000000000407e0
> [   28.070076] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   28.070076] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   28.070076] Process systemd (pid: 1, threadinfo ffff88011a096000, task ffff88011a094040)
> [   28.070076] Stack:
> [   28.070076]  ffffffff81a44000 ffff88011a097d80 0000097f1a097d18 0000000000000754
> [   28.070076]  ffffffff81215972 0000000000000000 0000000000000010 ffff880117470b00
> [   28.070076]  ffff88011a097df8 ffffffff81215c15 ffff88011a097d48 ffffffff810714ab
> [   28.070076] Call Trace:
> [   28.070076]  [<ffffffff81215972>] ? security_compute_sid.part.9+0x4a/0x372
> [   28.070076]  [<ffffffff81215c15>] security_compute_sid.part.9+0x2ed/0x372
> [   28.070076]  [<ffffffff810714ab>] ? trace_hardirqs_on_caller+0x123/0x17f
> [   28.070076]  [<ffffffff81215ccc>] security_compute_sid+0x32/0x34
> [   28.070076]  [<ffffffff81216645>] security_transition_sid_user+0x22/0x24
> [   28.070076]  [<ffffffff812165c6>] ? security_context_to_sid+0x14/0x16
> [   28.070076]  [<ffffffff8120c90c>] sel_write_create+0x179/0x23e
> [   28.070076]  [<ffffffff8120d4f3>] ? sel_write_load+0x66e/0x66e
> [   28.070076]  [<ffffffff8120c793>] ? sel_write_relabel+0x17b/0x17b
> [   28.070076]  [<ffffffff8120d55f>] selinux_transaction_write+0x6c/0x95
> [   28.070076]  [<ffffffff81108cce>] vfs_write+0xde/0x13b
> [   28.070076]  [<ffffffff81108f0c>] sys_write+0x3e/0x6b
> [   28.070076]  [<ffffffff815e4122>] system_call_fastpath+0x16/0x1b
> [   28.070076] Code: ff 4c 8b 45 c8 48 85 c0 44 8a 4d c0 74 0d 48 89 c6 4c 89 c7 e8 d0 fc ff ff eb 70 48 8b 05 9d bf 24 01 41 0f b7 d5 48 8b 44 d0 f8 <8a> 40 3b ff c8 3c 05 77 2e 0f b6 c0 ff 24 c5 d0 4c 6481 48 89
> [   28.070076] RIP  [<ffffffff81219974>] mls_compute_sid+0x99/0x104
> [   28.070076]  RSP <ffff88011a097cd8>
> [   28.070076] CR2: 000000000000003b
> [   28.089014] ---[ end trace c3f2f492efc8ebcc ]---
>
