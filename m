Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab0KASvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:51:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab0KASvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:51:36 -0400
Message-ID: <4CCF0BE3.2090700@redhat.com>
Date: Mon, 01 Nov 2010 14:50:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Mandeep Singh Baines <msb@chromium.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, wad@chromium.org, olofj@chromium.org,
        hughd@chromium.org
Subject: Re: [PATCH] RFC: vmscan: add min_filelist_kbytes sysctl for protecting
 the working set
References: <20101028191523.GA14972@google.com> <20101101012322.605C.A69D9226@jp.fujitsu.com> <20101101182416.GB31189@google.com>
In-Reply-To: <20101101182416.GB31189@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2010 02:24 PM, Mandeep Singh Baines wrote:

> Under memory pressure, I see the active list get smaller and smaller. Its
> getting smaller because we're scanning it faster and faster, causing more
> and more page faults which slows forward progress resulting in the active
> list getting smaller still. One way to approach this might to make the
> scan rate constant and configurable. It doesn't seem right that we scan
> memory faster and faster under low memory. For us, we'd rather OOM than
> evict pages that are likely to be accessed again so we'd prefer to make
> a conservative estimate as to what belongs in the working set. Other
> folks (long computations) might want to reclaim more aggressively.

Have you actually read the code?

The active file list is only ever scanned when it is larger
than the inactive file list.

>> Q2: In the above you used min_filelist_kbytes=50000. How do you decide
>> such value? Do other users can calculate proper value?
>>
>
> 50M was small enough that we were comfortable with keeping 50M of file pages
> in memory and large enough that it is bigger than the working set. I tested
> by loading up a bunch of popular web sites in chrome and then observing what
> happend when I ran out of memory. With 50M, I saw almost no thrashing and
> the system stayed responsive even under low memory. but I wanted to be
> conservative since I'm really just guessing.
>
> Other users could calculate their value by doing something similar.

Maybe we can scale this by memory amount?

Say, make sure the total amount of page cache in the system
is at least 2* as much as the sum of all the zone->pages_high
watermarks, and refuse to evict page cache if we have less
than that?

This may need to be tunable for a few special use cases,
like HPC and virtual machine hosting nodes, but it may just
do the right thing for everybody else.

Another alternative could be to really slow down the
reclaiming of page cache once we hit this level, so virt
hosts and HPC nodes can still decrease the page cache to
something really small ... but only if it is not being
used.

Andrew, could a hack like the above be "good enough"?

Anybody - does the above hack inspire you to come up with
an even better idea?
