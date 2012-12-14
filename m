Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2LNQEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:04:37 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47398 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252Ab2LNQEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:04:35 -0500
Message-ID: <50CB4CF7.5040400@linux.vnet.ibm.com>
Date: Fri, 14 Dec 2012 09:59:51 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Luigi Semenzato <semenzato@google.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 0/8] zswap: compressed swap caching
References: <1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com> <CAA25o9SYYmbq9oJaEKxuBoXSXaeku4=L7qK-1wXABTAsKCjrtQ@mail.gmail.com>
In-Reply-To: <CAA25o9SYYmbq9oJaEKxuBoXSXaeku4=L7qK-1wXABTAsKCjrtQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121416-7182-0000-0000-000003CBEE33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Luigi,

To echo Dan, it'd be great if we could move this discussion to a new
thread as to leaving this one for code review/comments.  But I did
want to respond.

On 12/12/2012 04:49 PM, Luigi Semenzato wrote:
> Just a couple of questions and comments as a user.  I apologize if
> this is the wrong time to make them, feel free to ignore them.
> 
> 1. It's becoming difficult to understand how zcache, zcache2, zram,
> and now zswap, interact and/or overlap with each other.  For instance,
> I am examining the possibility of using zcache2 and zram in parallel.
> Should I also/instead consider zswap, using a plain RAM disk as the
> swap device?

I guess the short answer is:
* Zcache is no more, replaced by zcache2 (so I stop making the
distinction)
* You wouldn't use zcache and zswap together unless you first disabled
the frontswap part of zcache, however this configuration isn't
recommended since there would be no cooperation between the compressed
page cache and compressed swap cache.
* Zram could work with either zswap or zcache although the
interactions would be interesting; namely, I think zram stores would
likely fail with high frequency since the primary reason the page
would not be captured by either zswap or zcache before it reaches zram
is that zswap/zcache was unable to allocate space.  So zram would
likely fail for the same reason, causing swap slots to be marked as
bad and rapidly shrink the effective size of the zram device.

> 2. Zswap looks like a two-stage swap device, with one stage being
> compressed memory.  I don't know if and where the abstraction breaks,
> and what the implementation issues would be, but I would find it
> easier to view and configure this as a two-stage swap, where one stage
> is chosen as zcache (but could be something else).

I didn't follow this.

> 3. As far as I can tell, none of these compressors has a good way of
> balancing the amount of memory dedicated to compression against the
> pressure on the rest of the memory.  On both zram and zswap, we set a
> max size for the compressed data.  That size determines how much RAM
> is left for the working set, which should remain uncompressed.  But
> the size of the working set can vary significantly with the load.  If
> we choose the size based on a worst-case working set, we'll be
> underutilizing RAM on average.  If we choose it smaller than that, the
> worst-case working set will cause excessive CPU use and thrashing.

This kind of adaptive tuning would be hard to implement and even
harder to get right for everyone, if it could be done at all.
However, one way to achieve this would be to have something in
userspace periodically change the sysfs attribute that controls
maximum compressed pool size based on your own policy.  Both zswap and
zcache have this tunable.

Seth

