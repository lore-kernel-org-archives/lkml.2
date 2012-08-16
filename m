Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab2HPLFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:05:30 -0400
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:51605 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab2HPLF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:05:29 -0400
Message-ID: <502CD3F8.70001@hardwarefreak.com>
Date: Thu, 16 Aug 2012 06:05:28 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Miquel van Smoorenburg <mikevs@xs4all.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: O_DIRECT to md raid 6 is slow
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com> <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com> <201208152307.q7FN7hMR008630@xs8.xs4all.nl>
In-Reply-To: <201208152307.q7FN7hMR008630@xs8.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2012 6:07 PM, Miquel van Smoorenburg wrote:
> In article <xs4all.502C1C01.1040509@hardwarefreak.com> you write:
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
> Ehrm no. If you modify, say, a 4K block on a RAID5 array, you just have
> to read that 4K block, and the corresponding 4K block on the
> parity drive, recalculate parity, and write back 4K of data and 4K
> of parity. (read|read) modify (write|write). You do not have to
> do I/O in chunksize, ehm, chunks, and you do not have to rmw all disks.

See:  http://www.spinics.net/lists/xfs/msg12627.html

Dave usually knows what he's talking about, and I didn't see Neil nor
anyone else correcting him on his description of md RMW behavior.  What
I stated above is pretty much exactly what Dave stated, but for the fact
I got the RMW read bytes wrong--should be 2MB/3MB for a 6 drive md/RAID6
and 5MB/6MB for 12 drives.

>> Parity RAID sucks in general because of RMW, but it is orders of
>> magnitude worse when one chooses to use an insane chunk size to boot,
>> and especially so with a large drive count.
[snip]
> Also, 256K or 512K isn't all that big nowadays, there's not much
> latency difference between reading 32K or 512K..

You're forgetting 3 very important things:

1.  All filesystems have metadata
2.  All (worth using) filesystems have a metadata journal
3.  All workloads include some, if not major, metadata operations

When writing journal and directory metadata there is a huge difference
between a 32KB and 512KB chunk especially as the drive count in the
array increases.  Rarely does a filesystem pack enough journal
operations into a single writeout to fill a 512KB stripe, let alone a
4MB stripe.  With a 32KB chunk you see full stripe width journal writes
frequently, minimizing the number of RMW writes to the journal, even up
to 16 data spindle parity arrays (18 drive RAID6).   Using a 512KB chunk
will cause most journal writes to be partial stripe writes, triggering
RMW for most journal writes.  The same is true for directory metadata
writes.

Everyone knows that parity RAID sucks for anything but purely streaming
workloads with little metadata.  With most/all other workloads, using a
large chunk size, such as the md metadata 1.2 default of 512KB, with
parity RAID, simply makes it much worse, whether the RMW cycle affects
all disks or just one data disk and one parity disk.

>> Recreate your array, partition aligned, and manually specify a sane
>> chunk size of something like 32KB.  You'll be much happier with real
>> workloads.
> 
> Aligning is a good idea, 

Understatement of the century.  Just as critical, if not more so, FS
stripe alignment is mandatory with parity RAID lest full stripe writeout
can/will trigger RMW.

> and on modern distributions partitions,
> LVM lv's etc are generally created with 1MB alignment. But using
> a small chunksize like 32K? That depends on the workload, but
> in most cases I'd advise against it.

People should ignore your advice in this regard.  A small chunk size is
optimal for nearly all workloads on a parity array for the reasons I
stated above.  It's the large chunk that is extremely workload
dependent, as again, it only fits well with low metadata streaming
workloads.

-- 
Stan

