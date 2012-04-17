Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab2DQPVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:21:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38331 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab2DQPVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:21:13 -0400
MIME-Version: 1.0
Message-ID: <f81dcf86-fb34-4e39-923b-3fd1862e60c6@default>
Date: Tue, 17 Apr 2012 08:20:58 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: RE: Followup: [PATCH -mm] make swapin readahead skip over holes
References: <7297ae3b-f3e1-480b-838f-69b0e09a733d@default>
 <4F8C7D59.1000402@redhat.com>
In-Reply-To: <4F8C7D59.1000402@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090201.4F8D8A65.004B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rik van Riel [mailto:riel@redhat.com]
> Subject: Re: Followup: [PATCH -mm] make swapin readahead skip over holes
> 
> On 04/16/2012 02:34 PM, Dan Magenheimer wrote:
> > Hi Rik --
> >
> > For values of N=24 and N=28, your patch made the workload
> > run 4-9% percent faster.  For N=16 and N=20, it was 5-10%
> > slower.  And for N=36 and N=40, it was 30%-40% slower!
> >
> > Is this expected?  Since the swap "disk" is a partition
> > on the one active drive, maybe the advantage is lost due
> > to contention?
> 
> There are several things going on here:
> 
> 1) you are running a workload that thrashes
> 
> 2) the speed at which data is swapped in is increased
>     with this patch
> 
> 3) with only 1GB memory, the inactive anon list is
>     the same size as the active anon list
> 
> 4) the above points combined mean that less of the
>     working set could be in memory at once
> 
> One solution may be to decrease the swap cluster for
> small systems, when they are thrashing.
> 
> On the other hand, for most systems swap is very much
> a special circumstance, and you want to focus on quickly
> moving excess stuff into swap, and moving it back into
> memory when needed.

Hmmm... as I look at this patch more, I think I get a
picture of what's going on and I'm still concerned.
Please correct me if I am misunderstanding:

What the patch does is increase the average size of
a "cluster" of sequential pages brought in per "read"
from the swap device.  As a result there are more pages
brought back into memory "speculatively" because it is
presumably cheaper to bring in more pages per disk seek,
even if it results in a lower "swapcache hit rate".
In effect, you've done the equivalent of increasing the
default swap cluster size (on average).

If the above is wrong, please cut here and ignore
the following. :-)  But in case it is right (or
close enough), let me continue...

In other words, you are both presuming a "swap workload"
that is more sequential than random for which this patch
improves performance, and assuming a "swap device" 
for which the cost of a seek is high enough to overcome
the costs of filling the swap cache with pages that won't
be used.

While it is easy to write a simple test/benchmark that
swaps a lot (and we probably all have similar test code
that writes data into a huge bigger-than-RAM array and then
reads it back), such a test/benchmark is usually sequential,
so one would assume most swap testing is done with a
sequential-favoring workload.  The kernbench workload
apparently exercises swap quite a bit more randomly and
your patch makes it run slower for low and high levels
of swapping, while faster for moderate swapping.

I also suspect (without proof) that the patch will
result in lower performance on non-rotating devices, such
as SSDs.

(Sure one can change the swap cluster size to 1, but how
many users or even sysadmins know such a thing even
exists... so the default is important.)

I'm no I/O expert, but I suspect if one of the Linux
I/O developers proposed a patch that unilaterally made
all sequential I/O faster and all random I/O slower,
it would get torn to pieces.

I'm certainly not trying to tear your patch to pieces,
just trying to evaluate it.  Hope that's OK.

Thanks,
Dan
