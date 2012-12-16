Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2LPCpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 21:45:45 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:54830 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249Ab2LPCpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 21:45:44 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak4MACQ1zVB5LIoV/2dsb2JhbABFhVKyeYYGF3OCHgEBBTocIxAIAw4KLhQlAyETGYd5uyIUjEmEQwOWCZBJgwc
Date: Sun, 16 Dec 2012 13:45:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fadvise: perform WILLNEED readahead in a workqueue
Message-ID: <20121216024520.GH9806@dastard>
References: <20121215005448.GA7698@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121215005448.GA7698@dcvr.yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 12:54:48AM +0000, Eric Wong wrote:
> Applications streaming large files may want to reduce disk spinups and
> I/O latency by performing large amounts of readahead up front.
> Applications also tend to read files soon after opening them, so waiting
> on a slow fadvise may cause unpleasant latency when the application
> starts reading the file.
> 
> As a userspace hacker, I'm sometimes tempted to create a background
> thread in my app to run readahead().  However, I believe doing this
> in the kernel will make life easier for other userspace hackers.
> 
> Since fadvise makes no guarantees about when (or even if) readahead
> is performed, this change should not hurt existing applications.
> 
> "strace -T" timing on an uncached, one gigabyte file:
> 
>  Before: fadvise64(3, 0, 0, POSIX_FADV_WILLNEED) = 0 <2.484832>
>   After: fadvise64(3, 0, 0, POSIX_FADV_WILLNEED) = 0 <0.000061>

You've basically asked fadvise() to readahead the entire file if it
can. That means it is likely to issue enough readahead to fill the
IO queue, and that's where all the latency is coming from. If all
you are trying to do is reduce the latency of the first read, then
only readahead the initial range that you are going to need to read...

Also, Pushing readahead off to a workqueue potentially allows
someone to DOS the system because readahead won't ever get throttled
in the syscall context...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
