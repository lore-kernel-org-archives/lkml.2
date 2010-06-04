Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab0FDTLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 15:11:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672Ab0FDTLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 15:11:36 -0400
Date: Fri, 4 Jun 2010 12:10:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Minchan Kim <minchan.kim@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Support generic I/O requests
Message-Id: <20100604121041.1b88b0af.akpm@linux-foundation.org>
In-Reply-To: <1275379286-10453-2-git-send-email-ngupta@vflare.org>
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>
	<1275379286-10453-2-git-send-email-ngupta@vflare.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Jun 2010 13:31:23 +0530
Nitin Gupta <ngupta@vflare.org> wrote:

> Currently, ramzwap devices (/dev/ramzswapX) can only
> be used as swap disks since it was hard-coded to consider
> only the first request in bio vector.
> 
> Now, we iterate over all the segments in an incoming
> bio which allows us to handle all kinds of I/O requests.
> 
> ramzswap devices can still handle PAGE_SIZE aligned and
> multiple of PAGE_SIZE sized I/O requests only. To ensure
> that we get always get such requests only, we set following
> request_queue attributes to PAGE_SIZE:
>  - physical_block_size
>  - logical_block_size
>  - io_min
>  - io_opt
> 
> Note: physical and logical block sizes were already set
> equal to PAGE_SIZE and that seems to be sufficient to get
> PAGE_SIZE aligned I/O.
> 
> Since we are no longer limited to handling swap requests
> only, the next few patches rename ramzswap to zram. So,
> the devices will then be called /dev/zram{0, 1, 2, ...}

Thanks for doing this - I think it's for the best..

> Usage/Examples:
>  1) Use as /tmp storage
>  - mkfs.ext4 /dev/zram0
>  - mount /dev/zram0 /tmp

hm, how does that work?  The "device" will only handle page-sized and
page-aligned requests, won't it?  Can you walk us through what happens
when the fs does a 512-byte I/O?

>  - Double caching: We can potentially waste memory by having
> two copies of a page -- one in page cache (uncompress) and
> second in the device memory (compressed). However, during
> reclaim, clean page cache pages are quickly freed, so this
> does not seem to be a big problem.

Yes, clean pagecache is cheap.  But what happens when the pagecache
copy of the page gets modified?

Or is it the case that once a compressed page gets copied out to
pagecache, the compressed version is never used again?  If so, the
memory could be synchronously freed, so I guess I don't understand what
you mean here.

>  - Stale data: Not all filesystems support issuing 'discard'
> requests to underlying block devices. So, if such filesystems
> are used over zram devices, we can accumulate lot of stale
> data in memory. Even for filesystems to do support discard
> (example, ext4), we need to see how effective it is.

Can you walk us through how zram uses discard requests?
