Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab2ICB1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 21:27:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57524 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab2ICB1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 21:27:16 -0400
Date: Sun, 2 Sep 2012 18:26:42 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tj@kernel.org,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120903012642.GD20060@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120831014359.GB15218@moria.home.lan>
 <20120831150159.GB13483@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120831150159.GB13483@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 11:01:59AM -0400, Vivek Goyal wrote:
> On Thu, Aug 30, 2012 at 06:43:59PM -0700, Kent Overstreet wrote:
> > On Thu, Aug 30, 2012 at 06:07:45PM -0400, Vivek Goyal wrote:
> > > On Wed, Aug 29, 2012 at 10:13:45AM -0700, Kent Overstreet wrote:
> > > 
> > > [..]
> > > > > Performance aside, punting submission to per device worker in case of deep
> > > > > stack usage sounds cleaner solution to me.
> > > > 
> > > > Agreed, but performance tends to matter in the real world. And either
> > > > way the tricky bits are going to be confined to a few functions, so I
> > > > don't think it matters that much.
> > > > 
> > > > If someone wants to code up the workqueue version and test it, they're
> > > > more than welcome...
> > > 
> > > Here is one quick and dirty proof of concept patch. It checks for stack
> > > depth and if remaining space is less than 20% of stack size, then it
> > > defers the bio submission to per queue worker.
> > 
> > I can't think of any correctness issues. I see some stuff that could be
> > simplified (blk_drain_deferred_bios() is redundant, just make it a
> > wrapper around blk_deffered_bio_work()).
> > 
> > Still skeptical about the performance impact, though - frankly, on some
> > of the hardware I've been running bcache on this would be a visible
> > performance regression - probably double digit percentages but I'd have
> > to benchmark it.  That kind of of hardware/usage is not normal today,
> > but I've put a lot of work into performance and I don't want to make
> > things worse without good reason.
> 
> Would you like to give this patch a quick try and see with bcache on your
> hardware how much performance impact do you see. 

If I can get a test system I can publish numbers setup with a modern
kernel, on I will. Will take a bit though.

> Given the fact that submission through worker happens only in case of 
> when stack usage is high, that should reduce the impact of the patch
> and common use cases should reamin unaffected.

Except depending on how users have their systems configured, it'll
either never happen or it'll happen for most every bio. That makes the
performance overhead unpredictable, too.

> > 
> > Have you tested/benchmarked it?
> 
> No, I have not. I will run some simple workloads on SSD.

Normal SATA ssds are not going to show the overhead - achi is a pig
and it'll be lost in the noise.

> There are so many places in kernel where worker threads do work on behalf
> of each process. I think this is really a minor concern and I would not
> be too worried about it.

Yeah, but this is somewhat unprecedented in the amount of cpu time
you're potentially moving to worker threads.

It is a concern.

> What is concerning though really is the greater stack usage due to
> recursive nature of make_request() and performance impact of deferral
> to a worker thread.

Your patch shouldn't increase stack usage (at least if your threshold is
safe - it's too high as is).
