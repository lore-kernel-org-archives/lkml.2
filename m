Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2CLSeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:34:10 -0400
Received: from dwdmx5.dwd.de ([141.38.3.242]:48322 "EHLO dwdmx5.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab2CLSeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:34:09 -0400
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2012 14:34:08 EDT
Date: Mon, 12 Mar 2012 18:22:59 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: Shaohua Li <shli@fusionio.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de,
        axboe@kernel.dk
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
In-Reply-To: <20120312030412.375458948@fusionio.com>
Message-ID: <alpine.LRH.2.02.1203121806120.23719@diagnostix.dwd.de>
References: <20120312030412.375458948@fusionio.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, 12 Mar 2012, Shaohua Li wrote:

> The patches add TRIM support for raid linear/0/1/10. I'll add TRIM support for
> raid 4/5/6 later. The implementation is pretty straightforward and
> self-explained.
>
First, thanks for this patch!

I have applied those patches against 3.3.0-rc7 and during boot the kernel
reports a lot of the following:

    Mar 12 18:56:00 c3po kernel: [    7.611045] md/raid0:md3: make_request bug: can't convert block across chunks or bigger than 512k 18861064 512
    Mar 12 18:56:00 c3po kernel: [    7.611047] md/raid0:md3: make_request bug: can't convert block across chunks or bigger than 512k 18862088 512
    Mar 12 18:56:00 c3po kernel: [    7.611049] md/raid0:md3: make_request bug: can't convert block across chunks or bigger than 512k 18863112 512
    Mar 12 18:56:00 c3po kernel: [    7.611052] md/raid0:md3: make_request bug: can't convert block across chunks or bigger than 512k 18864136 512
    Mar 12 18:56:00 c3po kernel: [    7.611054] md/raid0:md3: make_request bug: can't convert block across chunks or bigger than 512k 18865160 512
    Mar 12 18:56:00 c3po kernel: [    7.611056] md/raid0:md3: make_request bug: can't convert block across chunks or bigger than 512k 18866184 512

The raid looks as follows:

   cat /proc/mdstat
   Personalities : [raid0] [raid1]
   md2 : active raid0 sdc3[2] sdb3[1] sda3[0]
         50328576 blocks super 1.1 512k chunks

   md0 : active raid1 sdc1[1] sdb1[2]
         245748 blocks super 1.0 [2/2] [UU]

   md3 : active raid0 sdc5[2] sda5[0] sdb5[1]
         9434112 blocks super 1.1 512k chunks

   md1 : active raid0 sdc2[2] sda2[0] sdb2[1]
         22017024 blocks super 1.1 512k chunks

   unused devices: <none>

/dev/md3 is the swap partition.

I also get these reports from /dev/md2 which is my /home partition:

    Mar 12 19:06:42 c3po kernel: [  658.419035] md/raid0:md2: make_request bug: can't convert block across chunks or bigger than 512k 152088 512
    Mar 12 19:06:42 c3po kernel: [  658.419042] md/raid0:md2: make_request bug: can't convert block across chunks or bigger than 512k 153112 512
    Mar 12 19:06:42 c3po kernel: [  658.451489] md/raid0:md2: make_request bug: can't convert block across chunks or bigger than 512k 3206944 512
    Mar 12 19:06:42 c3po kernel: [  658.451494] md/raid0:md2: make_request bug: can't convert block across chunks or bigger than 512k 3207968 512
    Mar 12 19:06:42 c3po kernel: [  658.451499] md/raid0:md2: make_request bug: can't convert block across chunks or bigger than 512k 3208992 164

I then did a 'make clean' in my kernel tree which is on /dev/md1. After a
sync, which took very long the following errors appear:

    Mar 12 19:12:34 c3po kernel: [ 1010.609388] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 9986936 512
    Mar 12 19:12:34 c3po kernel: [ 1010.609393] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 9987960 512
    Mar 12 19:12:34 c3po kernel: [ 1010.609396] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 9988984 512
    Mar 12 19:12:34 c3po kernel: [ 1010.670542] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 11535480 512
    Mar 12 19:12:34 c3po kernel: [ 1010.787087] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 8998632 160
    Mar 12 19:12:34 c3po kernel: [ 1010.799357] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 9037136 476
    Mar 12 19:12:34 c3po kernel: [ 1010.807195] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 8999792 512
    Mar 12 19:12:34 c3po kernel: [ 1010.807201] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 9000816 108
    Mar 12 19:12:34 c3po kernel: [ 1010.899348] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 8996824 28
    Mar 12 19:12:34 c3po kernel: [ 1010.905625] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 9977808 512
    Mar 12 19:12:34 c3po kernel: [ 1010.905631] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 9978832 512
    Mar 12 19:12:34 c3po kernel: [ 1010.905636] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 9979856 512
    Mar 12 19:12:34 c3po kernel: [ 1010.905641] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 9980880 44
    Mar 12 19:12:34 c3po kernel: [ 1011.145590] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 8940504 72
       .
       .
       .
    Mar 12 19:12:37 c3po kernel: [ 1013.781899] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 9036704 208
    Mar 12 19:12:37 c3po kernel: [ 1013.781910] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 9040824 76
    Mar 12 19:12:37 c3po kernel: [ 1013.901750] md/raid0:md1: make_request bug: can't convert block across chunks or bigger than 512k 8841152 64
    Mar 12 19:12:37 c3po kernel: [ 1014.015810] request botched: dev sda: type=1, flags=9164081
    Mar 12 19:12:37 c3po kernel: [ 1014.015814]   sector 2615297, nr/cnr 0/1024
    Mar 12 19:12:37 c3po kernel: [ 1014.015818]   bio ffff880193fd4140, biotail ffff880193fd45c0, buffer           (null), len 0
    Mar 12 19:12:37 c3po kernel: [ 1014.017423] request botched: dev sdc: type=1, flags=9164081
    Mar 12 19:12:37 c3po kernel: [ 1014.017426]   sector 2614273, nr/cnr 0/1024
    Mar 12 19:12:37 c3po kernel: [ 1014.017430]   bio ffff880193fd4080, biotail ffff880193fd4500, buffer           (null), len 0
    Mar 12 19:12:37 c3po kernel: [ 1014.019569] request botched: dev sdb: type=1, flags=9164081
    Mar 12 19:12:37 c3po kernel: [ 1014.019572]   sector 2614273, nr/cnr 0/1024
    Mar 12 19:12:37 c3po kernel: [ 1014.019576]   bio ffff88016e1fb2c0, biotail ffff880193fd4680, buffer           (null), len 0
    Mar 12 19:12:37 c3po kernel: [ 1014.025916] request botched: dev sda: type=1, flags=916c081
    Mar 12 19:12:37 c3po kernel: [ 1014.025920]   sector 2615298, nr/cnr 0/1024
    Mar 12 19:12:37 c3po kernel: [ 1014.025923]   bio ffff880193fd4380, biotail ffff880193fd45c0, buffer           (null), len 0
    Mar 12 19:12:37 c3po kernel: [ 1014.027496] request botched: dev sdc: type=1, flags=916c081
    Mar 12 19:12:37 c3po kernel: [ 1014.027499]   sector 2614274, nr/cnr 0/1024
    Mar 12 19:12:37 c3po kernel: [ 1014.027503]   bio ffff880193fd42c0, biotail ffff880193fd4500, buffer           (null), len 0
    Mar 12 19:12:37 c3po kernel: [ 1014.034183] request botched: dev sdb: type=1, flags=916c081
    Mar 12 19:12:37 c3po kernel: [ 1014.034187]   sector 2614274, nr/cnr 0/1024
    Mar 12 19:12:37 c3po kernel: [ 1014.034190]   bio ffff880193fd4200, biotail ffff880193fd4680, buffer           (null), len 0
    Mar 12 19:12:37 c3po kernel: [ 1014.037478] request botched: dev sdc: type=1, flags=916c081
    Mar 12 19:12:37 c3po kernel: [ 1014.037482]   sector 2614275, nr/cnr 0/1024
    Mar 12 19:12:37 c3po kernel: [ 1014.037485]   bio ffff880193fd4500, biotail ffff880193fd4500, buffer           (null), len 0
    Mar 12 19:12:37 c3po kernel: [ 1014.039616] request botched: dev sdb: type=1, flags=916c081
    Mar 12 19:12:37 c3po kernel: [ 1014.039620]   sector 2614275, nr/cnr 0/1024
    Mar 12 19:12:37 c3po kernel: [ 1014.039623]   bio ffff880193fd4440, biotail ffff880193fd4680, buffer           (null), len 0
    Mar 12 19:12:37 c3po kernel: [ 1014.040477] request botched: dev sda: type=1, flags=916c081
    Mar 12 19:12:37 c3po kernel: [ 1014.040481]   sector 2615299, nr/cnr 0/1024
       .
       .
       .

The list goes on for very long. Here the mount options:

    /dev/md1 / ext4 rw,noatime,user_xattr,commit=600,barrier=1,journal_async_commit,stripe=384,data=ordered,discard 0 0
    /dev/md0 /boot ext4 rw,noatime,user_xattr,commit=2400,barrier=1,journal_async_commit,data=ordered,discard 0 0
    /dev/md2 /home ext4 rw,noatime,user_xattr,acl,commit=600,barrier=1,journal_async_commit,stripe=384,data=ordered,discard 0 0

The disk in use are the following:

    Mar 12 09:03:57 c3po kernel: [    1.206716] ata2.00: ATA-8: OCZ-VERTEX2, 1.35, max UDMA/133
    Mar 12 09:03:57 c3po kernel: [    1.208374] ata2.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
    Mar 12 09:03:57 c3po kernel: [    1.209939] ata1.00: ATA-8: OCZ-VERTEX2, 1.35, max UDMA/133
    Mar 12 09:03:57 c3po kernel: [    1.211507] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
    Mar 12 09:03:57 c3po kernel: [    1.216427] ata3.00: ATA-8: OCZ-VERTEX2, 1.35, max UDMA/133
    Mar 12 09:03:57 c3po kernel: [    1.218064] ata3.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA


Any idea what is wrong? Please let me know if I can do any further tests
or supply more information.

Regards,
Holger
