Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab0FBGUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 02:20:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64934 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab0FBGUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 02:20:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N8XVY75bK//47wSEhB4/tlxk8fRIny8lgwFSn9GwUADqY65L+UaPU8kg/rzKdJ02QO
         jjnzN9kALDKrX37dHgv8Zg8TMNi3f2G+RcJm3SPtmoBwXD2VOIbnz8RJFZKzIdElZpKu
         krKFd4q7XfCKfWf+ATCN+QSxLPEZ2M9DATFPg=
MIME-Version: 1.0
In-Reply-To: <1275379286-10453-2-git-send-email-ngupta@vflare.org>
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>
	<1275379286-10453-2-git-send-email-ngupta@vflare.org>
Date: Wed, 2 Jun 2010 15:20:13 +0900
Message-ID: <AANLkTimjc8eZY2IqbeZUR7VsWVspZ4ilUz3LPAUIiZuU@mail.gmail.com>
Subject: Re: [PATCH 1/4] Support generic I/O requests
From: Minchan Kim <minchan.kim@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 5:01 PM, Nitin Gupta <ngupta@vflare.org> wrote:
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
>  - physical_block_size
>  - logical_block_size
>  - io_min
>  - io_opt
>
> Note: physical and logical block sizes were already set
> equal to PAGE_SIZE and that seems to be sufficient to get
> PAGE_SIZE aligned I/O.
>
> Since we are no longer limited to handling swap requests
> only, the next few patches rename ramzswap to zram. So,
> the devices will then be called /dev/zram{0, 1, 2, ...}
>
> Usage/Examples:
>  1) Use as /tmp storage
>  - mkfs.ext4 /dev/zram0
>  - mount /dev/zram0 /tmp
>
>  2) Use as swap:
>  - mkswap /dev/zram0
>  - swapon /dev/zram0 -p 10 # give highest priority to zram0
>
> Performance:
>
>  - I/O benchamark done with 'dd' command. Details can be
> found here:
> http://code.google.com/p/compcache/wiki/zramperf
> Summary:
>  - Maximum read speed (approx):
>   - ram disk: 1200 MB/sec
>   - zram disk: 600 MB/sec
>  - Maximum write speed (approx):
>   - ram disk: 500 MB/sec
>   - zram disk: 160 MB/sec
>
> Issues:
>
>  - Double caching: We can potentially waste memory by having
> two copies of a page -- one in page cache (uncompress) and
> second in the device memory (compressed). However, during
> reclaim, clean page cache pages are quickly freed, so this
> does not seem to be a big problem.
>
>  - Stale data: Not all filesystems support issuing 'discard'
> requests to underlying block devices. So, if such filesystems
> are used over zram devices, we can accumulate lot of stale
> data in memory. Even for filesystems to do support discard
> (example, ext4), we need to see how effective it is.
>
>  - Scalability: There is only one (per-device) de/compression
> buffer stats. This can lead to significant contention, especially
> when used for generic (non-swap) purposes.
>
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

I saw mutex lock's usage as rather coarse-grained.
But I decides enhancing it with per-cpu stat after this series are merged.

Thanks for nice feature, Nitin.

P.S)
Why don't you send this series to -mm?
I don't know any patches have to go linux-next and any patches have to
go --mmotm.
I thought zram is related to memory management a little bit.

What's the criteria?

-- 
Kind regards,
Minchan Kim
