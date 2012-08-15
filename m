Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab2HOWLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 18:11:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54064 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2HOWLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 18:11:06 -0400
MIME-Version: 1.0
In-Reply-To: <502C1C01.1040509@hardwarefreak.com>
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com>
 <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com>
 <502C1C01.1040509@hardwarefreak.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 15 Aug 2012 15:10:44 -0700
Message-ID: <CALCETrUTNV0r6xeF+mbqqw7w_StxoF2qFxzCLfb-LVH7ay_SHw@mail.gmail.com>
Subject: Re: O_DIRECT to md raid 6 is slow
To: stan@hardwarefreak.com
Cc: John Robinson <john.robinson@anonymous.org.uk>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 3:00 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 8/15/2012 12:57 PM, Andy Lutomirski wrote:
>> On Wed, Aug 15, 2012 at 4:50 AM, John Robinson
>> <john.robinson@anonymous.org.uk> wrote:
>>> On 15/08/2012 01:49, Andy Lutomirski wrote:
>>>>
>>>> If I do:
>>>> # dd if=/dev/zero of=/dev/md0p1 bs=8M
>>>
>>> [...]
>>>
>>>> It looks like md isn't recognizing that I'm writing whole stripes when
>>>> I'm in O_DIRECT mode.
>>>
>>>
>>> I see your md device is partitioned. Is the partition itself stripe-aligned?
>>
>> Crud.
>>
>> md0 : active raid6 sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]
>>       11720536064 blocks super 1.2 level 6, 512k chunk, algorithm 2
>> [6/6] [UUUUUU]
>>
>> IIUC this means that I/O should be aligned on 2MB boundaries (512k
>> chunk * 4 non-parity disks).  gdisk put my partition on a 2048 sector
>> (i.e. 1MB) boundary.
>
> It's time to blow away the array and start over.  You're already
> misaligned, and a 512KB chunk is insanely unsuitable for parity RAID,
> but for a handful of niche all streaming workloads with little/no
> rewrite, such as video surveillance or DVR workloads.
>
> Yes, 512KB is the md 1.2 default.  And yes, it is insane.  Here's why:
> Deleting a single file changes only a few bytes of directory metadata.
> With your 6 drive md/RAID6 with 512KB chunk, you must read 3MB of data,
> modify the directory block in question, calculate parity, then write out
> 3MB of data to rust.  So you consume 6MB of bandwidth to write less than
> a dozen bytes.  With a 12 drive RAID6 that's 12MB of bandwidth to modify
> a few bytes of metadata.  Yes, insane.

Grr.  I thought the bad old days of filesystem and related defaults
sucking were over.  cryptsetup aligns sanely these days, xfs is
sensible, etc.  wtf?  <rant>Why is there no sensible filesystem for
huge disks?  zfs can't cp --reflink and has all kinds of source
availability and licensing issues, xfs can't dedupe at all, and btrfs
isn't nearly stable enough.</rant>

Anyhow, I'll try the patch from Wu Fengguang.  There's still a bug here...

--Andy
