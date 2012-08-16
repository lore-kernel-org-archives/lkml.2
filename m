Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab2HPBJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:09:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37103 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab2HPBJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:09:05 -0400
MIME-Version: 1.0
In-Reply-To: <502C35D4.6010804@hardwarefreak.com>
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com>
 <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com>
 <502C1C01.1040509@hardwarefreak.com> <CALCETrUTNV0r6xeF+mbqqw7w_StxoF2qFxzCLfb-LVH7ay_SHw@mail.gmail.com>
 <502C35D4.6010804@hardwarefreak.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 15 Aug 2012 18:08:43 -0700
Message-ID: <CALCETrViO5umuDQX1a6v=eKOMK8aAr4o7QMiWybv2in=XwO8CQ@mail.gmail.com>
Subject: Re: O_DIRECT to md raid 6 is slow
To: stan@hardwarefreak.com
Cc: John Robinson <john.robinson@anonymous.org.uk>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 4:50 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 8/15/2012 5:10 PM, Andy Lutomirski wrote:
>> On Wed, Aug 15, 2012 at 3:00 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>>> On 8/15/2012 12:57 PM, Andy Lutomirski wrote:
>>>> On Wed, Aug 15, 2012 at 4:50 AM, John Robinson
>>>> <john.robinson@anonymous.org.uk> wrote:
>>>>> On 15/08/2012 01:49, Andy Lutomirski wrote:
>>>>>>
>>>>>> If I do:
>>>>>> # dd if=/dev/zero of=/dev/md0p1 bs=8M
>>>>>
>>>>> [...]
>>
>> Grr.  I thought the bad old days of filesystem and related defaults
>> sucking were over.
>
> The previous md chunk default of 64KB wasn't horribly bad, though still
> maybe a bit high for alot of common workloads.  I didn't have eyes/ears
> on the discussion and/or testing process that led to the 'new' 512KB
> default.  Obviously something went horribly wrong here.  512KB isn't a
> show stopper as a default for 0/1/10, but is 8-16 times too large for
> parity RAID.
>
>> cryptsetup aligns sanely these days, xfs is
>> sensible, etc.
>
> XFS won't align with the 512KB chunk default of metadata 1.2.  The
> largest XFS journal stripe unit (su--chunk) is 256KB, and even that
> isn't recommended.  Thus mkfs.xfs throws an error due to the 512KB
> stripe.  See the md and xfs archives for more details, specifically Dave
> Chinner's colorful comments on the md 512KB default.

Heh -- that's why the math didn't make any sense :)

>
>> wtf?  <rant>Why is there no sensible filesystem for
>> huge disks?  zfs can't cp --reflink and has all kinds of source
>> availability and licensing issues, xfs can't dedupe at all, and btrfs
>> isn't nearly stable enough.</rant>
>
> Deduplication isn't a responsibility of a filesystem.  TTBOMK there are
> two, and only two, COW filesystems in existence:  ZFS and BTRFS.  And
> these are the only two to offer a native dedupe capability.  They did it
> because they could, with COW, not necessarily because they *should*.
> There are dozens of other single node, cluster, and distributed
> filesystems in use today and none of them support COW, and thus none
> support dedup.  So to *expect* a 'sensible' filesystem to include dedupe
> is wishful thinking at best.

I should clarify my rant for the record.  I don't care about in-fs
dedupe.  I want COW so userspace can dedupe and generally replace
hardlinks with sensible cowlinks.  I'm also working on some fun tools
that *require* reflinks for anything resembling decent performance.

--Andy
