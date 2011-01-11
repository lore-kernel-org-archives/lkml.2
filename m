Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab1AKQfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:35:40 -0500
Received: from relay3.sgi.com ([192.48.152.1]:48052 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932402Ab1AKQff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:35:35 -0500
Subject: Re: [announce] vfs-scale git tree update
From: Alex Elder <aelder@sgi.com>
Reply-To: aelder@sgi.com
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110107075831.GA14915@amd>
References: <20110107075831.GA14915@amd>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 10:34:39 -0600
Message-ID: <1294763679.2435.72.camel@doink>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jan 2011 16:34:40.0242 (UTC) FILETIME=[71887D20:01CBB1AD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 18:58 +1100, Nick Piggin wrote:
> Git tree is here:
>   
>   git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
>   
> Branch is: vfs-scale-working
> 
> Head is: b3e19d924b6eaf2ca7d22cba99a517c5171007b6
> 
> Changes since last posting:
> * Implemented Linus' suggestions:
>   - Switch the filesystem methods in one hit rather than having _rcu
>     variants. This avoids a lot of cruft from core code.
>   - Implement filesystem rcu-walk aware conversions in seperate patches
>     after the APIs are changed, making bisectability better.
>   - Change dentry_memcmp to dentry_cmp
>   - Rework the way ->d_revalidate is handled to be simpler.
> 
> * Fixed configfs bug caused by switching d_op on live dentry.
> 
> * Leave d_revalidate filesystem changes out for now. The sysfs one
>   in particular seems to have been causing a funny regression.
> 
> * Bit more tweaking of changelogs documentation and comments.
> 
> * Passes ltp, xfstests, dbench stressing over nfs, and some of my own
>   racer tests on a couple of filesystems. Needs wider testing.

FYI, when using this code, as merged by Linus, I hit the
BUG_ON() at the beginning of d_set_d_op() when it's called
by autofs4_dir_mkdir().  I managed to work around it by
just commenting out those BUG_ON() calls but it's something
that ought to get addressed properly.  Console grab below.

I first saw it with a kernel built from a merge of latest
XFS from oss.sgi.com with e54be894eae1... from Linus, but
I have now verified I get the same problem using Linus'
tree alone.

					-Alex

Commit: e54be894eae10eca9892e965cc9532f5d5a11767

. . .

Starting ypbind
done
Starting smartd
done
Starting automount ------------[ cut here ]------------
kernel BUG at /home/aelder/xfs/xfs/fs/dcache.c:1358!
invalid opcode: 0000 [#1] SMP 
last sysfs
file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/local_cpus
CPU 1 
Modules linked in: autofs4 binfmt_misc nfs lockd nfs_acl auth_rpcgss
sunrpc mperf ib_ipoib ib_cm ib_sa ipv6 ib_uverbs ib_umad iw_cxgb3 cxgb3
mdio mlx4_ib mlx4_core microcode fuse loop dm_mod sr_mod cdrom mptfc
ib_mthca scsi_transport_fc scsi_tgt ib_mad ib_core e1000e i5k_amb shpchp
i5000_edac rtc_cmos pci_hotplug edac_core iTCO_wdt usb_storage ioatdma
iTCO_vendor_support tpm_tis tpm container tpm_bios button dca i2c_i801
i2c_core rtc_core rtc_lib serio_raw pcspkr joydev sg usbhid hid uhci_hcd
ehci_hcd sd_mod crc_t10dif usbcore ext3 jbd mbcache piix edd xfs
exportfs fan thermal processor thermal_sys hwmon ide_generic ide_core
sata_nv megaraid_sas mptsas mptscsih mptbase scsi_transport_sas ata_piix
ahci libahci libata scsi_mod

Pid: 3848, comm: automount Not tainted 2.6.37-alex #2
X7DGT-INF/AltixXE310
RIP: 0010:[<ffffffff810e54bf>]  [<ffffffff810e54bf>] d_set_d_op+0xb/0x58
RSP: 0018:ffff88011e465e18  EFLAGS: 00010282
RAX: ffff88010c783e00 RBX: ffff88010a069800 RCX: 0000000000000013
RDX: 0000000000000000 RSI: ffffffffa02e6e80 RDI: ffff88010c78ccc0
RBP: ffff88011e465e18 R08: ffff88010a069800 R09: ffff88012268f800
R10: ffff88011185f007 R11: ffff88011e465e48 R12: ffff88010c78ccc0
R13: ffff88010a069800 R14: ffff88011c05fda0 R15: ffff8801269bb288
FS:  00007fd2db210950(0000) GS:ffff8800cfc80000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd2dc37de30 CR3: 000000010a55a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process automount (pid: 3848, threadinfo ffff88011e464000, task
ffff88010aacc1c0)
Stack:
 ffff88011e465e58 ffffffffa02e3fb7 ffff88011e465e38 0000000000000000
 ffff8801269bb288 000000000000016d ffff88010c78ccc0 00007fd2dc5c8216
 ffff88011e465e88 ffffffff810dee5d 0000000000000000 ffff88010c78ccc0
Call Trace:
 [<ffffffffa02e3fb7>] autofs4_dir_mkdir+0x124/0x19b [autofs4]
 [<ffffffff810dee5d>] vfs_mkdir+0x7e/0xd6
 [<ffffffff810e151a>] sys_mkdirat+0x91/0xe1
 [<ffffffff810e157d>] sys_mkdir+0x13/0x15
 [<ffffffff8100293b>] system_call_fastpath+0x16/0x1b
Code: 89 f7 e8 29 75 ff ff 4c 89 ff e8 d3 ce 1e 00 5a 5b 44 89 e0 41 5c
41 5d 41 5e 41 5f c9 c3 90 90 48 83 7f 60 00 55 48 89 e5 74 04 <0f> 0b
eb fe 66 f7 07 00 f0 74 04 0f 0b eb fe 48 85 f6 48 89 77 
RIP  [<ffffffff810e54bf>] d_set_d_op+0xb/0x58
 RSP <ffff88011e465e18>
---[ end trace d78cc1e6e1dedc2f ]---




