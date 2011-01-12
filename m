Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab1ALUM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 15:12:57 -0500
Received: from relay2.sgi.com ([192.48.179.30]:60930 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752329Ab1ALUMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:12:55 -0500
Subject: Re: [announce] vfs-scale git tree update
From: Alex Elder <aelder@sgi.com>
Reply-To: aelder@sgi.com
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1294805755.2821.6.camel@perseus>
References: <20110107075831.GA14915@amd> <1294763679.2435.72.camel@doink>
	 <AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
	 <1294768668.2435.177.camel@doink>  <1294804776.2821.4.camel@perseus>
	 <1294805755.2821.6.camel@perseus>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 14:11:23 -0600
Message-ID: <1294863083.2551.13.camel@doink>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jan 2011 20:11:24.0552 (UTC) FILETIME=[E31E7880:01CBB294]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 12:15 +0800, Ian Kent wrote:
> On Wed, 2011-01-12 at 11:59 +0800, Ian Kent wrote:
> > On Tue, 2011-01-11 at 11:57 -0600, Alex Elder wrote:
> > > On Tue, 2011-01-11 at 08:51 -0800, Linus Torvalds wrote:
> > > > On Tue, Jan 11, 2011 at 8:34 AM, Alex Elder <aelder@sgi.com> wrote:
> > > > >
> > > > > FYI, when using this code, as merged by Linus, I hit the
> > > > > BUG_ON() at the beginning of d_set_d_op() when it's called
> > > > > by autofs4_dir_mkdir().  I managed to work around it by
> > > > > just commenting out those BUG_ON() calls but it's something
> > > > > that ought to get addressed properly.
> > > > 
> > > > Yeah, removing the BUG_ON() isn't the right thing to do - it means
> > > > that autofs4 is obviously setting the dentry ops twice for the same
> > > > dentry.
> > > > 
> > > > Possibly the thing could be relaxed to allow setting the _same_ d_op
> > > > pointer, ie do something like
> > > > 
> > > >    if (dentry->d_op == op)
> > > >       return;
> > > > 
> > > > at the top of that function. But looking at it, I don't think that
> > > > fixes the autofs4 issue.
> > > 
> > > That's easy enough, but it seems everybody else ensures
> > > this gets done just once per dentry, and it would be nice
> > > to preserve that "tightness" if possible.
> > > 
> > > > The fact that autofs4 does "d_add()" before it sets the d_ops (or
> > > > other dentry state, for that matter) looks a bit scary. To me that
> > > > smells like it might get a  dentry lookup hit before it's actually
> > > > fully done.
> > > 
> > > Agreed.
> > 
> > Isn't the parent i_mutex held during mkdir()?
> > Still the order can be changed, of course.
> > 
> > > 
> > > > Does it make any difference if you move the various d_add() calls down
> > > > to the end of the functions to when the "dentry" has really been
> > > > instantiated?
> > > 
> > > Looking at it quickly, I don't think that would matter for
> > > the case at hand.  I.e., that might be safer but it doesn't
> > > address the fact that these fields are getting initialized
> > > multiple times.
> > 
> > Yeah, a hangover from changes done over time.
> > Not setting the dentry op in ->lookup() should fix this.
> 
> Could you try this patch please.

OK, sorry for the delay.  I tried the patch.  I applied
it against 4162cf64973df51fc885825bc9ca4d055891c49f,
which is the linus/master branch I had on hand.  This
time I got a different failure due to a null pointer
dereference.  Console capture below.  I can log
in still but the boot sequence never got to the
login prompt on the console as it normally does.

					-Alex

> autofs4 - dont set dentry op in ->lookup()

. . .
Starting smartd
done
Starting network time protocol daemon (NTPD)
done
Starting automount BUG: unable to handle kernel NULL pointer dereference
at 0000000000000010
IP: [<ffffffffa0296744>] autofs4_lookup+0x3dd/0x4a7 [autofs4]
PGD 0 
Oops: 0000 [#1] SMP 
last sysfs
file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/local_cpus
CPU 2 
Modules linked in: autofs4 binfmt_misc nfs lockd nfs_acl auth_rpcgss
sunrpc ib_ipoib ib_cm ib_sa ipv6 mperf ib_uverbs ib_umad iw_cxgb3 cxgb3
mdio mlx4_ib mlx4_core microcode fuse loop dm_mod sr_mod cdrom ib_mthca
ib_mad e1000e mptfc scsi_transport_fc scsi_tgt ib_core shpchp
usb_storage i5k_amb pci_hotplug rtc_cmos rtc_core iTCO_wdt rtc_lib
tpm_tis i2c_i801 i2c_core ioatdma dca tpm i5000_edac iTCO_vendor_support
edac_core pcspkr container button joydev tpm_bios serio_raw sg usbhid
hid uhci_hcd ehci_hcd sd_mod crc_t10dif usbcore ext3 jbd mbcache piix
edd xfs exportfs fan thermal processor thermal_sys hwmon ide_generic
ide_core sata_nv megaraid_sas mptsas mptscsih mptbase scsi_transport_sas
ata_piix ahci libahci libata scsi_mod

Pid: 3880, comm: automount Not tainted 2.6.37-alex #1
X7DGT-INF/AltixXE310
RIP: 0010:[<ffffffffa0296744>]  [<ffffffffa0296744>] autofs4_lookup
+0x3dd/0x4a7 [autofs4]
RSP: 0018:ffff88011f7a3b88  EFLAGS: 00010202
RAX: 0000000000000002 RBX: ffff880117faeb40 RCX: 0000000000000011
RDX: 0000000000000000 RSI: ffff88011ecfcb38 RDI: ffff88011ecfcb38
RBP: ffff88011f7a3c38 R08: 0000000000000000 R09: ffff88011ed41578
R10: ffff880120f4c007 R11: 000000000000343e R12: ffff880117fae9f8
R13: ffff88011ecfcb00 R14: 0000000000000001 R15: ffff88011ecfcb00
FS:  00007ffb9915a950(0000) GS:ffff8800cfd00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 000000011e7d1000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process automount (pid: 3880, threadinfo ffff88011f7a2000, task
ffff880124628480)
Stack:
 ffff88011f7a3c08 0000000000000011 ffff88012ffd9e00 ffff88011f7a3db8
 ffff880120247050 ffff8800cfd0e0e0 ffff880117faeb40 0000000000000000
 00000001249405f8 ffff880117faebc0 ffff88011ecfcb38 00000011dc2bc535
Call Trace:
 [<ffffffff810e86fb>] ? d_alloc+0x165/0x1bd
 [<ffffffff810de19e>] d_alloc_and_lookup+0x49/0x68
 [<ffffffff810de34c>] do_lookup+0x18f/0x23a
 [<ffffffff810e07a9>] link_path_walk+0x5ad/0xa90
 [<ffffffff810e0edd>] do_path_lookup+0x4b/0x107
 [<ffffffff810e1973>] user_path_at+0x52/0x8c
 [<ffffffff810d91fe>] ? cp_new_stat+0xe2/0xee
 [<ffffffff810e7525>] ? dput+0x25/0x23e
 [<ffffffff810d93bc>] vfs_fstatat+0x35/0x62
 [<ffffffff810d94cb>] vfs_stat+0x16/0x18
 [<ffffffff810d94e7>] sys_newstat+0x1a/0x3b
 [<ffffffff8100293b>] system_call_fastpath+0x16/0x1b
Code: 47 60 48 85 c0 74 14 48 8b 00 48 85 c0 74 0c 48 8b b5 68 ff ff ff
4c 89 ff ff d0 48 8b bd 78 ff ff ff e8 79 c1 03 e1 48 8b 55 88 <f6> 42
10 04 74 76 65 48 8b 14 25 80 b5 00 00 48 8b 42 08 48 8b 
RIP  [<ffffffffa0296744>] autofs4_lookup+0x3dd/0x4a7 [autofs4]
 RSP <ffff88011f7a3b88>
CR2: 0000000000000010
---[ end trace 6655d1f57e42cf9e ]---
Starting mail service (Postfix)
done
Starting CRON daemon
done
eth0: no IPv6 routers present


