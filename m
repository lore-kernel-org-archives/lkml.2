Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab2HOXuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 19:50:44 -0400
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:51371 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab2HOXun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 19:50:43 -0400
Message-ID: <502C35D4.6010804@hardwarefreak.com>
Date: Wed, 15 Aug 2012 18:50:44 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: John Robinson <john.robinson@anonymous.org.uk>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: O_DIRECT to md raid 6 is slow
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com> <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com> <502C1C01.1040509@hardwarefreak.com> <CALCETrUTNV0r6xeF+mbqqw7w_StxoF2qFxzCLfb-LVH7ay_SHw@mail.gmail.com>
In-Reply-To: <CALCETrUTNV0r6xeF+mbqqw7w_StxoF2qFxzCLfb-LVH7ay_SHw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2012 5:10 PM, Andy Lutomirski wrote:
> On Wed, Aug 15, 2012 at 3:00 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> On 8/15/2012 12:57 PM, Andy Lutomirski wrote:
>>> On Wed, Aug 15, 2012 at 4:50 AM, John Robinson
>>> <john.robinson@anonymous.org.uk> wrote:
>>>> On 15/08/2012 01:49, Andy Lutomirski wrote:
>>>>>
>>>>> If I do:
>>>>> # dd if=/dev/zero of=/dev/md0p1 bs=8M
>>>>
>>>> [...]
>>>>
>>>>> It looks like md isn't recognizing that I'm writing whole stripes when
>>>>> I'm in O_DIRECT mode.
>>>>
>>>>
>>>> I see your md device is partitioned. Is the partition itself stripe-aligned?
>>>
>>> Crud.
>>>
>>> md0 : active raid6 sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]
>>>       11720536064 blocks super 1.2 level 6, 512k chunk, algorithm 2
>>> [6/6] [UUUUUU]
>>>
>>> IIUC this means that I/O should be aligned on 2MB boundaries (512k
>>> chunk * 4 non-parity disks).  gdisk put my partition on a 2048 sector
>>> (i.e. 1MB) boundary.
>>
>> It's time to blow away the array and start over.  You're already
>> misaligned, and a 512KB chunk is insanely unsuitable for parity RAID,
>> but for a handful of niche all streaming workloads with little/no
>> rewrite, such as video surveillance or DVR workloads.
>>
>> Yes, 512KB is the md 1.2 default.  And yes, it is insane.  Here's why:
>> Deleting a single file changes only a few bytes of directory metadata.
>> With your 6 drive md/RAID6 with 512KB chunk, you must read 3MB of data,
>> modify the directory block in question, calculate parity, then write out
>> 3MB of data to rust.  So you consume 6MB of bandwidth to write less than
>> a dozen bytes.  With a 12 drive RAID6 that's 12MB of bandwidth to modify
>> a few bytes of metadata.  Yes, insane.
> 
> Grr.  I thought the bad old days of filesystem and related defaults
> sucking were over.  

The previous md chunk default of 64KB wasn't horribly bad, though still
maybe a bit high for alot of common workloads.  I didn't have eyes/ears
on the discussion and/or testing process that led to the 'new' 512KB
default.  Obviously something went horribly wrong here.  512KB isn't a
show stopper as a default for 0/1/10, but is 8-16 times too large for
parity RAID.

> cryptsetup aligns sanely these days, xfs is
> sensible, etc.  

XFS won't align with the 512KB chunk default of metadata 1.2.  The
largest XFS journal stripe unit (su--chunk) is 256KB, and even that
isn't recommended.  Thus mkfs.xfs throws an error due to the 512KB
stripe.  See the md and xfs archives for more details, specifically Dave
Chinner's colorful comments on the md 512KB default.

> wtf?  <rant>Why is there no sensible filesystem for
> huge disks?  zfs can't cp --reflink and has all kinds of source
> availability and licensing issues, xfs can't dedupe at all, and btrfs
> isn't nearly stable enough.</rant>

Deduplication isn't a responsibility of a filesystem.  TTBOMK there are
two, and only two, COW filesystems in existence:  ZFS and BTRFS.  And
these are the only two to offer a native dedupe capability.  They did it
because they could, with COW, not necessarily because they *should*.
There are dozens of other single node, cluster, and distributed
filesystems in use today and none of them support COW, and thus none
support dedup.  So to *expect* a 'sensible' filesystem to include dedupe
is wishful thinking at best.

> Anyhow, I'll try the patch from Wu Fengguang.  There's still a bug here...

Always one somewhere.

-- 
Stan

