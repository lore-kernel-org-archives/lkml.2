Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230Ab0DBG72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 02:59:28 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51370 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759213Ab0DBG7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 02:59:22 -0400
Date: Fri, 2 Apr 2010 08:59:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] readahead even for FMODE_RANDOM
Message-ID: <20100402065917.GX23510@kernel.dk>
References: <20100401183151.GO23510@kernel.dk> <20100402012338.GA6393@localhost> <20100402063830.GR23510@kernel.dk> <20100402065237.GA21508@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402065237.GA21508@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02 2010, Wu Fengguang wrote:
> On Fri, Apr 02, 2010 at 02:38:30PM +0800, Jens Axboe wrote:
> > On Fri, Apr 02 2010, Wu Fengguang wrote:
> > > Hi Jens,
> > > 
> > > On Fri, Apr 02, 2010 at 02:31:51AM +0800, Jens Axboe wrote:
> > > > Hi,
> > > > 
> > > > I got a problem report with fio where larger block size random reads
> > > > where markedly slower with buffered IO than with O_DIRECT, and the
> > > > initial thought was that perhaps this was some fio oddity. The reporter
> > > > eventually discovered that turning off the fadvise hint made it work
> > > > fine. So I took a look, and it seems we never do readahead for
> > > > FMODE_RANDOM even if the request size is larger than 1 page. That seems
> > > > like a bug, if an application is doing eg 16kb random reads, you want to
> > > > readahead the 12kb remaining data. On devices where smaller transfer
> > > > sizes are slower than larger ones, this can make a large difference.
> > > > 
> > > > This patch makes us readahead even for FMODE_RANDOM, iff we'll be
> > > > reading more pages in that single read. I ran a quick test here, and it
> > > > appears to fix the problem (no difference with fadvise POSIX_FADV_RANDOM
> > > > being passed in or not).
> > >  
> > > I guess the application is doing (at least partial) sequential reads,
> > > while at the same time tell kernel with POSIX_FADV_RANDOM that it's
> > > doing random reads.
> > > 
> > > If so, it's mainly the application's fault.
> > 
> > The application is doing large random reads. It's purely random, so
> > the POSIX_FADV_RANDOM hint is correct. However, thinking about it, it
> 
> How large is it? For random reads > read_ahead_kb,
> ondemand_readahead() will break it into read_ahead_kb sized IOs, while
> force_page_cache_readahead() won't. That may impact IO performance.

The test case was 128kb random reads. So should still be within the
normal read_ahead_kb. I suspect the reporter would not have noticed if
the issue size was as large as read_ahead_kb even if the request size
was larger, the problem was that he ended up seeing 4kb ios only.

> > may be that we later hit a random "block" that has now been cached due
> > to this read-ahead. Let me try and rule that out completely and see if
> > there's still the difference. The original reporter observed 4kb reads
> > hitting the driver, where 128kb was expected.
> 
> 4kb reads hit the disk (on POSIX_FADV_RANDOM)? That sounds like
> behavior in pre .34 kernels that is fixed by commit 0141450f66c:
> 
>     readahead: introduce FMODE_RANDOM for POSIX_FADV_RANDOM

Could explain why I'm not reproducing when doing a quick test on the
laptop. It is an older kernel. So it could be that I'm just imaging the
issue on the current kernel, I don't have hard data to back it up on
that version.

So disregard the patch for now, part-sequential behaviour on
POSIX_FADV_RANDOM isn't the issue here.

-- 
Jens Axboe

