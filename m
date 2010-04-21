Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab0DUEYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 00:24:08 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:54319 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab0DUEYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 00:24:04 -0400
Message-ID: <4BCE7DD1.70900@linux.vnet.ibm.com>
Date: Wed, 21 Apr 2010 06:23:45 +0200
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       gregkh@novell.com, Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone pressure
References: <20100322235053.GD9590@csn.ul.ie> <4BA940E7.2030308@redhat.com> <20100324145028.GD2024@csn.ul.ie> <4BCC4B0C.8000602@linux.vnet.ibm.com> <20100419214412.GB5336@cmpxchg.org> <4BCD55DA.2020000@linux.vnet.ibm.com> <20100420153202.GC5336@cmpxchg.org> <4BCDE2F0.3010009@redhat.com>
In-Reply-To: <4BCDE2F0.3010009@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Rik van Riel wrote:
> On 04/20/2010 11:32 AM, Johannes Weiner wrote:
> 
>> The idea is that it pans out on its own.  If the workload changes, new
>> pages get activated and when that set grows too large, we start shrinking
>> it again.
>>
>> Of course, right now this unscanned set is way too large and we can end
>> up wasting up to 50% of usable page cache on false active pages.
> 
> Thing is, changing workloads often change back.
> 
> Specifically, think of a desktop system that is doing
> work for the user during the day and gets backed up
> at night.
> 
> You do not want the backup to kick the working set
> out of memory, because when the user returns in the
> morning the desktop should come back quickly after
> the screensaver is unlocked.

IMHO it is fine to prevent that nightly backup job from not being 
finished when the user arrives at morning because we didn't give him 
some more cache - and e.g. a 30 sec transition from/to both optimized 
states is fine.
But eventually I guess the point is that both behaviors are reasonable 
to achieve - depending on the users needs.

What we could do is combine all our thoughts we had so far:
a) Rik could create an experimental patch that excludes the in flight pages
b) Johannes could create one for his suggestion to "always scan active 
file pages but only deactivate them when the ratio is off and otherwise 
strip buffers of clean pages"
c) I would extend the patch from Johannes setting the ratio of 
active/inactive pages to be a userspace tunable

a,b,a+b would then need to be tested if they achieve a better behavior.

c on the other hand would be a fine tunable to let administrators 
(knowing their workloads) or distributions (e.g. different values for 
Desktop/Server defaults) adapt their installations.

In theory a,b and c should work fine together in case we need all of them.

> The big question is, what workload suffers from
> having the inactive list at 50% of the page cache?
> 
> So far the only big problem we have seen is on a
> very unbalanced virtual machine, with 256MB RAM
> and 4 fast disks.  The disks simply have more IO
> in flight at once than what fits in the inactive
> list.

Did I get you right that this means the write case - explaining why it 
is building up buffers to the 50% max?

Note: It even uses up to 64 disks, with 1 disk per thread so e.g. 16 
threads => 16 disks.

For being "unbalanced" I'd like to mention that over the years I learned 
that sometimes, after a while, virtualized systems look that way without 
being intended - this happens by adding more and more guests and let 
guest memory balooning take care of it.

> This is a very untypical situation, and we can
> probably solve it by excluding the in-flight pages
> from the active/inactive file calculation.

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance
