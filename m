Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1CBLNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:13:07 -0500
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:38439 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1CBLNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:13:05 -0500
X-Greylist: delayed 1206 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Mar 2011 06:13:04 EST
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: a major regression in recent kernels? - was: Re: Null pointer OOPS in sync_inodes_sb+0xa9/0x104
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20110302034417.4954.qmail@science.horizon.com>
Date: Wed, 2 Mar 2011 10:52:55 +0000
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        George Spelvin <linux@horizon.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <023AB542-CCF0-4436-8594-51132FEA8070@cam.ac.uk>
References: <20110302034417.4954.qmail@science.horizon.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I am not sure who the "responsible" person for this is but a problem is emerging on recent kernels where device hot plug and/or suspend/resume (which I guess effectively performas hot plug/unplug as part of its operation) causes kernel crashes with NULL pointer dereference.  It has now been reported at least by three different people on LKML/fs-devel and also one of Tuxera's customers is seeing it too on their embedded hardware.

The problem appears to be that on device unplug, the s_bdi field in the struct super block is set to NULL.  But at that point a file system is still mounted and fully operational!  So any file system / VFS code that goes through s_bdi causes a NULL pointer dereference.

Not sure what the correct solution is but this is definitely a functional regression given I now am aware of four independent reports in recent kernels but never before.

Here are links to the reports in the archives:

	https://lkml.org/lkml/2010/12/9/436

	http://www.gossamer-threads.com/lists/linux/kernel/1345992

And below is the third report which appears to be the same problem as the above two, i.e. the super block's s_bdi is NULL, so dereferencing it causes a NULL pointer dereference and sync_inodes_sb() contains a call to bdi_queue_work() which is likely inlined automatically by gcc and the crash is thus when bdi is first dereferenced in bdi_queue_work()...

Not sure what the solution is.  I don't think it is a matter of checking against s_bdi being NULL because it is used in a lot of places so it will be hard to track them all down.  More likely s_bdi should not be set to NULL until all super_block structures referencing it go away and the disappeared device driver code should be adapted to match but I may be wrong...

Just thought you should be made aware as this problem appears to be ignored / stay under the radar of people who actually have a hope of fixing it properly so far...

Best regards,

	Anton

On 2 Mar 2011, at 03:44, George Spelvin wrote:
> Just after resuming from a suspend to RAM, 2.6.38-rc6 plus Eric Dumazet's
> [PATCH] net: Add default_advmss() methods to blackhole dst_ops
> 
> Core 2 duo, 32-bit kernel, 2 GiB RAM.
> I suspend to RAM every few days; this is not the first
> time since booting.
> 
> The display hadn'd flipped to X yet, so I managed to capture the screen
> (manually transcribed):
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000030
> IP: [<c10a3a21>] sync_inodes_sb+0xa9/0x104
> *pde = 00000000
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1.3/3-1.3:1.0/input11/name
> Modules linked in: btusb sco rfcomm l2cap crc16 bluetooth ctr twofish_generic twofish_i586 twofish_common serpent xcbc sha256_generic b43 mac80211 cfg80211
> 
> Pid: 23367, comm: mount Not tainted 2.6.38-rc6 #228 Dell Inc. MXC061                          /0MG532
> EIP: 0060:[<c10a3a21>] EFLAGS: 0010246 CPU: 1
> EIP is at sync_inodes_sb+0xa9/0x104
> EAX: c003fd5c EBX: f58f606c ECX: 00000000 EDX: 00000909
> ESI: d4cc1424 EDI: c003fd0c EBP: 00000000 ESP: f56ffee8
> DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process mount (pid: 23367, ti=f56fe000 task=c28472a0 task.ti = f56fe000)
> Stack:
> 7fffffff f58f6000 00000001 00000000 f56ffef8 f56ffef8 f56fff04 00000000
> 00000303 f56fff0c f56fff0c f58f6000 00000001 00000000 f4a57000 c10a6c72
> f58f6000 00000020 00000000 c108e442 00000000 00000000 00000020 00000000
> Call Trace:
> [<c10a6c72>] ? _sync_filesystem+0x3a/0x69
> [<c108e442>] ? do_remount_sb+0x59/0xce
> [<c10a067b>] ? do_mount+0x214/0x6a8
> [<c10a0b83>] ? sys_mount+0x74/0xa9
> [<c1002750>] ? sysenter_do_call+0x12/0x26
> Code: b9 3a c1 e8 f4 6d f8 ff b8 80 f7 51 c1 31 f6 e8 f1 09 26 00 8b 7b 6c 83 c3 6c 83 ef 50 eb 44 f6 47 30 38 75 38 8b af c0 00 00 00 <83> 7d 30 00 74 2c 89 f8 e8 1a 85 ff ff fe 05 80 f7 51 c1 89 f0
> EIP: [<c10a3a21>] sync_inodes_sb+0xa9/0x104 SS:ESP 0068:f56ffee8
> CR2: 0000000000000030
> 
> I can't make much sense out of it, but maybe someone can.  It's a simple
> laptop with one rotating hard drive.  Distro is Debian/unstable, kernel
> is hand-compiled from Linus' git.

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

