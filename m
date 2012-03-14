Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab2CNLcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:32:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37033 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab2CNLct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:32:49 -0400
MIME-Version: 1.0
In-Reply-To: <CANejiEXP9ORKTfE4O9khaHSp-Y8yOQU1LLUD5Q5pBJOGR+A-aA@mail.gmail.com>
References: <20120312030412.375458948@fusionio.com>
	<alpine.LRH.2.02.1203121806120.23719@diagnostix.dwd.de>
	<4F5EFEB6.4060402@kernel.org>
	<alpine.LRH.2.02.1203131213480.15848@diagnostix.dwd.de>
	<CANejiEWYCxY_hLwgyN08_cXC64c82irkNPytTjOpYyER7pTGow@mail.gmail.com>
	<alpine.LRH.2.02.1203131521190.29286@diagnostix.dwd.de>
	<CANejiEW=a1piMYvSYM5GmtxKsWYpZj+kjnmNsNUDmW9ydDBjBw@mail.gmail.com>
	<alpine.LRH.2.02.1203140839590.28358@diagnostix.dwd.de>
	<CANejiEXP9ORKTfE4O9khaHSp-Y8yOQU1LLUD5Q5pBJOGR+A-aA@mail.gmail.com>
Date: Wed, 14 Mar 2012 19:32:49 +0800
X-Google-Sender-Auth: 0-bgqh7EFWrBOo4V-_KVJNK8dEU
Message-ID: <CANejiEXnYpKx741LDs9SzrQKKpfmguO2WFkzWemtiMPtZH0ODA@mail.gmail.com>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
From: Shaohua Li <shli@kernel.org>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "neilb@suse.de" <neilb@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/14 Shaohua Li <shli@kernel.org>:
> 2012/3/14 Holger Kiehl <Holger.Kiehl@dwd.de>:
>> On Wed, 14 Mar 2012, Shaohua Li wrote:
>>
>>> 2012/3/13 Holger Kiehl <Holger.Kiehl@dwd.de>:
>>>>
>>>> On Tue, 13 Mar 2012, Shaohua Li wrote:
>>>>
>>>>> Thanks for testing. This is very wield, the req->__data_len is wrong.
>>>>> Is this a clean build?
>>>>>
>>>> I just downloaded linux-3.3-rc7.tar.bz2 from kernel.org and applied
>>>> your patches again. The result is the same.
>>>>
>>>> Am I the only one experiencing these problems?
>>>
>>> Martin Petersen pointed out scsi layer doesn't support discard merge,
>>> which
>>> might be the reason you see the error message (my drive isn't a scsi
>>> device).
>>> can you please try attached patch?
>>>
>> Thanks! After this patch the error messages are away.
>>
>> However, when the system boots it takes a very long time to boot:
>>
>>   [   16.527389] EXT4-fs (md0): mounted filesystem with ordered data mode.
>> Opts: discard,commit=2400,journal_async_commit
>>   [   24.218410] EXT4-fs (md2): mounted filesystem with ordered data mode.
>> Opts: discard,commit=600,journal_async_commit
>>   [   69.823138] udevd[474]: timeout '/sbin/blkid -o udev -p /dev/md0'
>>   [   70.824197] udevd[474]: timeout: killing '/sbin/blkid -o udev -p
>> /dev/md0' [866]
>>   [   70.826823] udevd[474]: '/sbin/blkid -o udev -p /dev/md0' [866]
>> terminated by signal 9 (Killed)
>>   [   70.829290] udevd[474]: timeout 'udisks-part-id /dev/md0'
>>   [   74.942625] udevd[475]: timeout '/sbin/blkid -o udev -p /dev/md2'
>>   [   75.947158] udevd[475]: timeout: killing '/sbin/blkid -o udev -p
>> /dev/md2' [874]
>>   [   75.949734] udevd[475]: '/sbin/blkid -o udev -p /dev/md2' [874]
>> terminated by signal 9 (Killed)
>>   [   75.951945] udevd[475]: timeout 'udisks-part-id /dev/md2'
>>   [   79.023741] rmmod[886]: ERROR: Module scsi_wait_scan does not exist in
>> /proc/modules
>>   [   96.005919] systemd[1]: dev-md3.swap activation timed out. Stopping.
>>   [  127.292002] Adding 9434108k swap on /dev/md3.  Priority:0 extents:1
>> across:9434108k
>>
>> During another boot I saw this additional message:
>>
>>   [   11.988732] scsi_verify_blk_ioctl: 930 callbacks suppressed
>>
>> The strange thing is that after boot I tried to enter the command
>> '/sbin/blkid -o udev -p /dev/md0' and it works without any problems
>> (time for this is 0m0.001s). So I also tried booting without discard
>> option, but the result is the same.
>>
>> Otherwise I observed no problems. Even running some more extensive
>> benchmark testing showed no problems. Only the performance drop is
>> dramatic. In my own benchmark where thousand of files get copied around
>> via FTP the performance drops from 4000 files per second to 520 when
>> mounting the filesystem with discard option. Also during the benchmark
>> any access to the disk can take very very long if discard is enabled.
>>
>> Next, I will try this patch on a system without SATA/SCSI disks.
> Maybe the discard runs slow with small size request in the disk.
> please drop patch "blk: add plug for blkdev_issue_discard" and try again. Since
> we can't do merge, the plug just introduces latency.
> if it doesn't help, please capture a blktrace when you do the benchmark and
> send it to me.
Is it possible if you can directly build a fs in such ssd (that is not
using raid), and check
the performance of discard? I'd like to make sure it's not the problem
of the ssd itself.
the raid chunk size is 512k, which is already big even without merge.

Thanks,
Shaohua
