Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1C1WwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:52:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61613 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab1C1WwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=X63h33+1y/LvVo5gnPO2TQU/kHAkwZ0eyOZsAj1CB7cl09zwRYebEqg3dF6UAK6rWF
         3Dowvc3iwBBkgwh5LhJLky+AQGy3PdxOFYrm/TVBfmRnokeKdcGirJKhF3kD6ycgyWuW
         IcR5IO7BgEa9+tw18NRrLECCl/GNUwVW+Vd8w=
MIME-Version: 1.0
In-Reply-To: <20110328215344.GC3008@dastard>
References: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>
	<20110328215344.GC3008@dastard>
Date: Tue, 29 Mar 2011 07:52:14 +0900
Message-ID: <BANLkTimHPFMUOCFAruF5J4OMHSkZsMsAgA@mail.gmail.com>
Subject: Re: Very aggressive memory reclaim
From: Minchan Kim <minchan.kim@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: John Lepikhin <johnlepikhin@gmail.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 6:53 AM, Dave Chinner <david@fromorbit.com> wrote:
> [cc xfs and mm lists]
>
> On Mon, Mar 28, 2011 at 08:39:29PM +0400, John Lepikhin wrote:
>> Hello,
>>
>> I use high-loaded machine with 10M+ inodes inside XFS, 50+ GB of
>> memory, intensive HDD traffic and 20..50 forks per second. Vanilla
>> kernel 2.6.37.4. The problem is that kernel frees memory very
>> aggressively.
>>
>> For example:
>>
>> 25% of memory is used by processes
>> 50% for page caches
>> 7% for slabs, etc.
>> 18% free.
>>
>> That's bad but works. After few hours:
>>
>> 25% of memory is used by processes
>> 62% for page caches
>> 7% for slabs, etc.
>> 5% free.
>>
>> Most of files are cached, works perfectly. This is the moment when
>> kernel decides to free some memory. After memory reclaim:
>>
>> 25% of memory is used by processes
>> 25% for page caches(!)
>> 7% for slabs, etc.
>> 43% free(!)
>>
>> Page cache is dropped, server becomes too slow. This is the beginning
>> of new cycle.
>>
>> I didn't found any huge mallocs at that moment. Looks like because of
>> large number of small mallocs (forks) kernel have pessimistic forecast
>> about future memory usage and frees too much memory. Is there any
>> options of tuning this? Any other variants?
>
> First it would be useful to determine why the VM is reclaiming so
> much memory. If it is somewhat predictable when the excessive
> reclaim is going to happen, it might be worth capturing an event
> trace from the VM so we can see more precisely what it is doiing
> during this event. In that case, recording the kmem/* and vmscan/*
> events is probably sufficient to tell us what memory allocations
> triggered reclaim and how much reclaim was done on each event.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

Recently, We had a similar issue.
http://www.spinics.net/lists/linux-mm/msg12243.html
But it seems to not merge. I don't know why since I didn't follow up the thread.
Maybe Cced guys can help you.

Is it a sudden big cache drop at the moment or accumulated small cache
drop for long time?
What's your zones' size?

Please attach the result of cat /proc/zoneinfo for others.
