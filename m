Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab1EaPhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:37:55 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:53032 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757119Ab1EaPhx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:37:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dm1ndnbNY79ZofpMyChLKwQ/L11ZsGhZ7NMAGTZDT0+RamcwpJxp/YAIwUVpNAo61b
         V1M6cehdJlX6lf3Wek4p+xOixBMSmj/wZPl+wkxGzLv9mKFBZMn0OajkflUADobFPaRG
         fpt6eYpLdQHlHnSxDONe4AQfxWJWdmYAq1+3s=
MIME-Version: 1.0
In-Reply-To: <BANLkTinu7dX5Tfhs0ak0BEfc212mpJKb+w@mail.gmail.com>
References: <cover.1306780983.git.bengardiner@nanometrics.ca>
	<BANLkTinu7dX5Tfhs0ak0BEfc212mpJKb+w@mail.gmail.com>
Date: Tue, 31 May 2011 11:37:51 -0400
Message-ID: <BANLkTikFx1Cwtnh+k-eJBcj0Y7mhh5Nbnw@mail.gmail.com>
Subject: Re: [PATCH 0/3] fix-up free space earlier in mount_ubifs()
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: "Matthew L. Creech" <mlcreech@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

To answer your other question:

On Tue, May 31, 2011 at 10:43 AM, Matthew L. Creech <mlcreech@gmail.com> wrote:
> [...]
>
> Do you happen to know if the same thing occurs when you uncleanly
> reboot (so that recovery is needed on the next boot)?  It looks like
> ubifs_recover_master_node() reads the same data that
> fixup_leb_free_space() does, so I'd expect it to fail similarly if
> that's what's happening, regardless of whether fix-up is performed or
> not.

To test unclean w/o free-space-fixup flag set I did a powercut during
'yes > /test-file';

The first time I hsaw a dump from ubifs_check_node:

UBIFS: recovery needed
UBIFS error (pid 1): ubifs_check_node: bad CRC: calculated 0x4763322d,
read 0x4c8c2537
UBIFS error (pid 1): ubifs_check_node: bad node at LEB 501:81608
Backtrace:
[<c002dd8c>] (dump_backtrace+0x0/0x10c) from [<c02ecbac>] (dump_stack+0x18/0x1c)
 r7:00013ec8 r6:c781f000 r5:c89f0ec8 r4:ffffff8b
[<c02ecb94>] (dump_stack+0x0/0x1c) from [<c015ba88>]
(ubifs_check_node+0x1b8/0x2ec)
[<c015b8d0>] (ubifs_check_node+0x0/0x2ec) from [<c0163ee4>]
(ubifs_scan_a_node+0x180/0x398)
[<c0163d64>] (ubifs_scan_a_node+0x0/0x398) from [<c017b498>]
(ubifs_recover_leb+0xd4/0xa94)
[<c017b3c4>] (ubifs_recover_leb+0x0/0xa94) from [<c0164e90>]
(ubifs_replay_journal+0x6ac/0x1c30)
[<c01647e4>] (ubifs_replay_journal+0x0/0x1c30) from [<c01571a8>]
(ubifs_fill_super+0xdf4/0x1ee4)
[<c01563b4>] (ubifs_fill_super+0x0/0x1ee4) from [<c0158508>]
(ubifs_mount+0x270/0x3a4)
[<c0158298>] (ubifs_mount+0x0/0x3a4) from [<c00afe5c>] (mount_fs+0x1c/0xe8)
[<c00afe40>] (mount_fs+0x0/0xe8) from [<c00cc8c0>] (vfs_kern_mount+0x58/0x94)
 r6:00008000 r5:c780c780 r4:c7a78b80
[<c00cc868>] (vfs_kern_mount+0x0/0x94) from [<c00cc958>]
(do_kern_mount+0x3c/0xd4)
 r9:c782dee8 r8:c03ebaa8 r7:c7a78b60 r6:00000000 r5:c7a78b80
r4:00008000
[<c00cc91c>] (do_kern_mount+0x0/0xd4) from [<c00ccb3c>] (do_mount+0x14c/0x734)
 r9:c782dee8 r8:00000020 r7:c7a78b60 r6:c7a78b80 r5:00008000
r4:00000000
[<c00cc9f0>] (do_mount+0x0/0x734) from [<c00cd1c4>] (sys_mount+0xa0/0xd0)
[<c00cd124>] (sys_mount+0x0/0xd0) from [<c0008dd4>]
(mount_block_root+0x98/0x2c8)
 r7:c0023e88 r6:c781b000 r5:00008000 r4:c781b000
[<c0008d3c>] (mount_block_root+0x0/0x2c8) from [<c00090f0>]
(prepare_namespace+0x80/0x1c4)
[<c0009070>] (prepare_namespace+0x0/0x1c4) from [<c0008480>]
(kernel_init+0x110/0x158)
 r7:00000013 r6:c0023300 r5:c0023668 r4:c0023668
[<c0008370>] (kernel_init+0x0/0x158) from [<c0043d58>] (do_exit+0x0/0x750)
 r7:00000013 r6:c0043d58 r5:c0008370 r4:00000000
UBIFS: recovery completed

every time after that there is nothing printed during recovery:

UBIFS: recovery needed
UBIFS: recovery completed
UBIFS: mounted UBI device 0, volume 1, name "rootfs"

To test unclean with free-space-flag set, I did powercut during 'nand
write' in u-boot.

When attempting to mount the rootfs I got dumps from ubifs_read_node:

UBIFS error (pid 1): ubifs_read_node: bad node type (255 but expected 9)
UBIFS error (pid 1): ubifs_read_node: bad node at LEB 496:101088, LEB
mapping status 0
Backtrace:
[<c002dd8c>] (dump_backtrace+0x0/0x10c) from [<c02ecbac>] (dump_stack+0x18/0x1c)
 r7:c782c000 r6:c781f000 r5:c7859780 r4:ffffffea
[<c02ecb94>] (dump_stack+0x0/0x1c) from [<c015bdf4>]
(ubifs_read_node+0x238/0x2ec)
[<c015bbbc>] (ubifs_read_node+0x0/0x2ec) from [<c0168080>]
(dbg_old_index_check_init+0x70/0xe0)
[<c0168010>] (dbg_old_index_check_init+0x0/0xe0) from [<c0163864>]
(ubifs_read_master+0xdbc/0xe20)
[<c0162aa8>] (ubifs_read_master+0x0/0xe20) from [<c0156ffc>]
(ubifs_fill_super+0xc48/0x1ee4)
[<c01563b4>] (ubifs_fill_super+0x0/0x1ee4) from [<c0158508>]
(ubifs_mount+0x270/0x3a4)
[<c0158298>] (ubifs_mount+0x0/0x3a4) from [<c00afe5c>] (mount_fs+0x1c/0xe8)
[<c00afe40>] (mount_fs+0x0/0xe8) from [<c00cc8c0>] (vfs_kern_mount+0x58/0x94)
 r6:00008000 r5:c780c780 r4:c7a848e0
[<c00cc868>] (vfs_kern_mount+0x0/0x94) from [<c00cc958>]
(do_kern_mount+0x3c/0xd4)
 r9:c782dee8 r8:c03ebaa8 r7:c7a848c0 r6:00000000 r5:c7a848e0
r4:00008000
[<c00cc91c>] (do_kern_mount+0x0/0xd4) from [<c00ccb3c>] (do_mount+0x14c/0x734)
 r9:c782dee8 r8:00000020 r7:c7a848c0 r6:c7a848e0 r5:00008000
r4:00000000
[<c00cc9f0>] (do_mount+0x0/0x734) from [<c00cd1c4>] (sys_mount+0xa0/0xd0)
[<c00cd124>] (sys_mount+0x0/0xd0) from [<c0008dd4>]
(mount_block_root+0x98/0x2c8)
 r7:c0023e88 r6:c781b000 r5:00008000 r4:c781b000
[<c0008d3c>] (mount_block_root+0x0/0x2c8) from [<c00090f0>]
(prepare_namespace+0x80/0x1c4)
[<c0009070>] (prepare_namespace+0x0/0x1c4) from [<c0008480>]
(kernel_init+0x110/0x158)
 r7:00000013 r6:c0023300 r5:c0023668 r4:c0023668
[<c0008370>] (kernel_init+0x0/0x158) from [<c0043d58>] (do_exit+0x0/0x750)
 r7:00000013 r6:c0043d58 r5:c0008370 r4:00000000

I didn't ever see the -74 errors or the assertion I placed in
ubifs_write_node().

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
