Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755Ab2CNK0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:26:09 -0400
Received: from dwdmx5.dwd.de ([141.38.3.242]:44884 "EHLO dwdmx5.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760574Ab2CNK0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:26:06 -0400
Date: Wed, 14 Mar 2012 10:25:58 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: Shaohua Li <shli@kernel.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "neilb@suse.de" <neilb@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
In-Reply-To: <CANejiEW=a1piMYvSYM5GmtxKsWYpZj+kjnmNsNUDmW9ydDBjBw@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1203140839590.28358@diagnostix.dwd.de>
References: <20120312030412.375458948@fusionio.com> <alpine.LRH.2.02.1203121806120.23719@diagnostix.dwd.de> <4F5EFEB6.4060402@kernel.org> <alpine.LRH.2.02.1203131213480.15848@diagnostix.dwd.de> <CANejiEWYCxY_hLwgyN08_cXC64c82irkNPytTjOpYyER7pTGow@mail.gmail.com>
 <alpine.LRH.2.02.1203131521190.29286@diagnostix.dwd.de> <CANejiEW=a1piMYvSYM5GmtxKsWYpZj+kjnmNsNUDmW9ydDBjBw@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012, Shaohua Li wrote:

> 2012/3/13 Holger Kiehl <Holger.Kiehl@dwd.de>:
>> On Tue, 13 Mar 2012, Shaohua Li wrote:
>>
>>> Thanks for testing. This is very wield, the req->__data_len is wrong.
>>> Is this a clean build?
>>>
>> I just downloaded linux-3.3-rc7.tar.bz2 from kernel.org and applied
>> your patches again. The result is the same.
>>
>> Am I the only one experiencing these problems?
> Martin Petersen pointed out scsi layer doesn't support discard merge, which
> might be the reason you see the error message (my drive isn't a scsi device).
> can you please try attached patch?
>
Thanks! After this patch the error messages are away.

However, when the system boots it takes a very long time to boot:

    [   16.527389] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: discard,commit=2400,journal_async_commit
    [   24.218410] EXT4-fs (md2): mounted filesystem with ordered data mode. Opts: discard,commit=600,journal_async_commit
    [   69.823138] udevd[474]: timeout '/sbin/blkid -o udev -p /dev/md0'
    [   70.824197] udevd[474]: timeout: killing '/sbin/blkid -o udev -p /dev/md0' [866]
    [   70.826823] udevd[474]: '/sbin/blkid -o udev -p /dev/md0' [866] terminated by signal 9 (Killed)
    [   70.829290] udevd[474]: timeout 'udisks-part-id /dev/md0'
    [   74.942625] udevd[475]: timeout '/sbin/blkid -o udev -p /dev/md2'
    [   75.947158] udevd[475]: timeout: killing '/sbin/blkid -o udev -p /dev/md2' [874]
    [   75.949734] udevd[475]: '/sbin/blkid -o udev -p /dev/md2' [874] terminated by signal 9 (Killed)
    [   75.951945] udevd[475]: timeout 'udisks-part-id /dev/md2'
    [   79.023741] rmmod[886]: ERROR: Module scsi_wait_scan does not exist in /proc/modules
    [   96.005919] systemd[1]: dev-md3.swap activation timed out. Stopping.
    [  127.292002] Adding 9434108k swap on /dev/md3.  Priority:0 extents:1 across:9434108k

During another boot I saw this additional message:

    [   11.988732] scsi_verify_blk_ioctl: 930 callbacks suppressed

The strange thing is that after boot I tried to enter the command
'/sbin/blkid -o udev -p /dev/md0' and it works without any problems
(time for this is 0m0.001s). So I also tried booting without discard
option, but the result is the same.

Otherwise I observed no problems. Even running some more extensive
benchmark testing showed no problems. Only the performance drop is
dramatic. In my own benchmark where thousand of files get copied around
via FTP the performance drops from 4000 files per second to 520 when
mounting the filesystem with discard option. Also during the benchmark
any access to the disk can take very very long if discard is enabled.

Next, I will try this patch on a system without SATA/SCSI disks.

Regards,
Holger
