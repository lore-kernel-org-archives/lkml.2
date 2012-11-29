Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab2K2ADO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:03:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576Ab2K2ADN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:03:13 -0500
Date: Wed, 28 Nov 2012 16:03:03 -0800
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, bcrl@kvack.org, jmoyer@redhat.com,
        axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 00/25] AIO performance improvements/cleanups
Message-ID: <20121129000303.GF18574@lenny.home.zabbo.net>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 08:43:24AM -0800, Kent Overstreet wrote:
> Bunch of performance improvements and cleanups Zach Brown and I have
> been working on. The code should be pretty solid at this point, though
> it could of course use more review and testing.

Thanks for sending these out.  I have some initial review comments
that'll follow, but I'm running out of steam today.  I'll continue
tomorrow.

> The results in my testing are pretty impressive, particularly when an
> ioctx is being shared between multiple threads. In my crappy synthetic
> benchmark, with 4 threads submitting and one thread reaping completions,
> I saw overhead in the aio code go from ~50% (mostly ioctx lock
> contention) to low single digits. Performance with ioctx per thread
> improved too, but I'd have to rerun those benchmarks.

You should probably mention that those four threads were *spinning* on
io_submit() :).  I'm still guessing that this unreasonably inflated the
contention amongst submitters and that without this inflation we might
not find the per-cpu ioctx refcounts worth the trouble.

> Performance wise, the end result of this patch series is that submitting
> a kiocb writes to _no_ shared cachelines - the penalty for sharing an
> ioctx is gone there. There's still going to be some cacheline contention
> when we deliver the completions to the aio ringbuffer (at least if you
> have interrupts being delivered on multiple cores, which for high end
> stuff you do) but I have a couple more patches not in this series that
> implement coalescing for that (by taking advantage of interrupt
> coalescing). With that, there's basically no bottlenecks or performance
> issues to speak of in the aio code.

Yeah, this is good stuff.  Thanks for pushing it.

We should mention Jens' omnibus patch that also took on these problems:

  http://git.kernel.dk/?p=linux-block.git;a=commit;h=6b6723fc3e4f24dbd80526df935ca115ead578c6

- z
