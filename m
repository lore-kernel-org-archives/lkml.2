Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2ICUlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 16:41:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab2ICUlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 16:41:51 -0400
Date: Mon, 3 Sep 2012 16:41:37 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Kent Overstreet <koverstreet@google.com>
cc: Vivek Goyal <vgoyal@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tj@kernel.org,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
In-Reply-To: <20120831014359.GB15218@moria.home.lan>
Message-ID: <Pine.LNX.4.64.1209031638110.15620@file.rdu.redhat.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com> <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com> <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com> <20120831014359.GB15218@moria.home.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Aug 2012, Kent Overstreet wrote:

> On Thu, Aug 30, 2012 at 06:07:45PM -0400, Vivek Goyal wrote:
> > On Wed, Aug 29, 2012 at 10:13:45AM -0700, Kent Overstreet wrote:
> > 
> > [..]
> > > > Performance aside, punting submission to per device worker in case of deep
> > > > stack usage sounds cleaner solution to me.
> > > 
> > > Agreed, but performance tends to matter in the real world. And either
> > > way the tricky bits are going to be confined to a few functions, so I
> > > don't think it matters that much.
> > > 
> > > If someone wants to code up the workqueue version and test it, they're
> > > more than welcome...
> > 
> > Here is one quick and dirty proof of concept patch. It checks for stack
> > depth and if remaining space is less than 20% of stack size, then it
> > defers the bio submission to per queue worker.
> 
> I can't think of any correctness issues. I see some stuff that could be
> simplified (blk_drain_deferred_bios() is redundant, just make it a
> wrapper around blk_deffered_bio_work()).
> 
> Still skeptical about the performance impact, though - frankly, on some
> of the hardware I've been running bcache on this would be a visible
> performance regression - probably double digit percentages but I'd have
> to benchmark it.  That kind of of hardware/usage is not normal today,
> but I've put a lot of work into performance and I don't want to make
> things worse without good reason.
> 
> Have you tested/benchmarked it?
> 
> There's scheduling behaviour, too. We really want the workqueue thread's
> cpu time to be charged to the process that submitted the bio. (We could
> use a mechanism like that in other places, too... not like this is a new
> issue).
> 
> This is going to be a real issue for users that need strong isolation -
> for any driver that uses non negligable cpu (i.e. dm crypt), we're
> breaking that (not that it wasn't broken already, but this makes it
> worse).

... or another possibility - start a timer when something is put to 
current->bio_list and use that timer to pop entries off current->bio_list 
and submit them to a workqueue. The timer can be cpu-local so only 
interrupt masking is required to synchronize against the timer.

This would normally run just like the current kernel and in case of 
deadlock, the timer would kick in and resolve the deadlock.

> I could be convinced, but right now I prefer my solution.

It fixes bio allocation problem, but not other similar mempool problems in 
dm and md.

Mikulas
