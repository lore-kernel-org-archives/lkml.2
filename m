Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806Ab2CTMJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 08:09:20 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43766 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab2CTMJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 08:09:18 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1203200839120.29880@diagnostix.dwd.de>
References: <20120316073213.656519005@fusionio.com>
	<alpine.LRH.2.02.1203181824590.24824@diagnostix.dwd.de>
	<CANejiEWeaF44Rbgt5jhf_bnafF4yoTTZAYsqoD2+greJ07c-_A@mail.gmail.com>
	<alpine.LRH.2.02.1203200839120.29880@diagnostix.dwd.de>
Date: Tue, 20 Mar 2012 20:09:17 +0800
X-Google-Sender-Auth: X84ZqgORyWHFKxodjHc2i0Mr6Ys
Message-ID: <CANejiEVWbP53QVKZQBS2xKtaqdX6jdW_mjZxJ9q5=cxKNk6_dg@mail.gmail.com>
Subject: Re: [patch v2 0/6] Add TRIM support for raid linear/0/1/10
From: Shaohua Li <shli@kernel.org>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>, neilb@suse.de,
        axboe@kernel.dk, vgoyal@redhat.com, martin.petersen@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/20 Holger Kiehl <Holger.Kiehl@dwd.de>:
> Hello,
>
>
> On Tue, 20 Mar 2012, Shaohua Li wrote:
>
>> 2012/3/20 Holger Kiehl <Holger.Kiehl@dwd.de>:
>>>
>>> Hello,
>>>
>>>
>>> On Fri, 16 Mar 2012, Shaohua Li wrote:
>>>
>>>> The patches add TRIM support for raid linear/0/1/10. I'll add TRIM
>>>> support
>>>> for
>>>> raid 4/5/6 later. The implementation is pretty straightforward and
>>>> self-explained.
>>>>
>>>> v1->v2:
>>>> 1. fixed a checking issue
>>>> 2. dropped discard request plug and replace it with no discard merege,
>>>> because
>>>> current SCSI layer can't handle discard request merge.
>>>>
>>> Have tested TRIM patches on three different systems with the following
>>> hardware/ setup:
>>>
>>>   1) root mounted on a raid1 over two SAS SSD's (200GB) and /home
>>> partition
>>>      on a raid0 over a fusionio ioDrive Duo. Is very new and seen very
>>>      little usage.
>>>
>>>   2) root and /home mounted on a raid0 over two Intel X25 Postville
>>>      (160GB) connected to a Intel P55 Express chipset. Has seen very
>>>      heavy usage for approx. 2 years.
>>>
>>>   3) root and /home mounted on a raid0 over three OCZ-VERTEX2 (120GB)
>>>      connected via ICH7 south bridge. Has seen mild usage for approx.
>>>      1.5 years.
>>>
>>> Made the following observations when running my own benchmark which
>>> copies around a lot of small files and deletes them. The benchmark on
>>> all systems was always run only on the /home partition ie. on a raid0.
>>>
>>> For system 1) there is hardly any measurable differnce whether discard
>>> is enabled or not (~29000 files per second).
>>>
>>> On system 2) the performance drops from 6500->3700 files per second,
>>> but under normal usage one does not notice any difference.
>>
>> do you have the blktrace data when the benchmark is running, especially
>> when doing file deletion. I'd like to check the latency of discard in this
>> case.
>>
> It is uploaded on ftp://ftp.dwd.de/pub/afd/test/trim
Thanks, I'll check it.

>>> System 3) has problems during boot, it is so slow that some operations
>>> receive a timeout during boot:
>>>
>>>  udevd[474]: timeout '/sbin/blkid -o udev -p /dev/md0'
>>>  udevd[474]: timeout: killing '/sbin/blkid -o udev -p /dev/md0' [866]
>>>  systemd[1]: dev-md3.swap activation timed out. Stopping.
>>
>> In this one, discard request is slow. And per SATA standard, discard
>> request
>> can't be parallel, so only one request one time, which further slows it
>> down.
>>
> Ok, so having three disc in a raid 0 is even worth.
>
>
>>> Even removing discard does not help and the above errors happen during
>>> boot and booting takes a long time.
>>
>> this doesn't make sense. If you don't mount with discard option, no
>> discard request
>> is issued.
>>
> I read some where that swap uses discard by default and if I remember
> correctly it initializes the whole swap area at boot. So doing that
> over three disks might explain why I get those timeout error messages
> and after boot these commands work without delay.
This looks a bug to me. if swapon doesn't add discard option, we shouldn't
do discard. Let me post a patch, and see how people think.

Thanks,
Shaohua
