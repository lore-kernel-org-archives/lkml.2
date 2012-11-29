Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab2K2TBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:01:38 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58544 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab2K2TBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:01:36 -0500
Date: Thu, 29 Nov 2012 11:01:33 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, bcrl@kvack.org, jmoyer@redhat.com,
        axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 00/25] AIO performance improvements/cleanups
Message-ID: <20121129190133.GF15094@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
 <20121129000303.GF18574@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129000303.GF18574@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 04:03:03PM -0800, Zach Brown wrote:
> On Wed, Nov 28, 2012 at 08:43:24AM -0800, Kent Overstreet wrote:
> > Bunch of performance improvements and cleanups Zach Brown and I have
> > been working on. The code should be pretty solid at this point, though
> > it could of course use more review and testing.
> 
> Thanks for sending these out.  I have some initial review comments
> that'll follow, but I'm running out of steam today.  I'll continue
> tomorrow.
> 
> > The results in my testing are pretty impressive, particularly when an
> > ioctx is being shared between multiple threads. In my crappy synthetic
> > benchmark, with 4 threads submitting and one thread reaping completions,
> > I saw overhead in the aio code go from ~50% (mostly ioctx lock
> > contention) to low single digits. Performance with ioctx per thread
> > improved too, but I'd have to rerun those benchmarks.
> 
> You should probably mention that those four threads were *spinning* on
> io_submit() :).  I'm still guessing that this unreasonably inflated the
> contention amongst submitters and that without this inflation we might
> not find the per-cpu ioctx refcounts worth the trouble.

Yeah, should've mentioned that :) It was intentionally a worst case
scenario for aio.

> > Performance wise, the end result of this patch series is that submitting
> > a kiocb writes to _no_ shared cachelines - the penalty for sharing an
> > ioctx is gone there. There's still going to be some cacheline contention
> > when we deliver the completions to the aio ringbuffer (at least if you
> > have interrupts being delivered on multiple cores, which for high end
> > stuff you do) but I have a couple more patches not in this series that
> > implement coalescing for that (by taking advantage of interrupt
> > coalescing). With that, there's basically no bottlenecks or performance
> > issues to speak of in the aio code.
> 
> Yeah, this is good stuff.  Thanks for pushing it.
> 
> We should mention Jens' omnibus patch that also took on these problems:
> 
>   http://git.kernel.dk/?p=linux-block.git;a=commit;h=6b6723fc3e4f24dbd80526df935ca115ead578c6

Oh yeah. I think this patch series solves everything Jens was working on
in the aio code, but there's still dio stuff in that patch that's worth
looking at.
