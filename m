Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab2IDT0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:26:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757652Ab2IDT0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:26:31 -0400
Date: Tue, 4 Sep 2012 15:26:19 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Kent Overstreet <koverstreet@google.com>
cc: Vivek Goyal <vgoyal@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tj@kernel.org,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
In-Reply-To: <20120904034100.GA21602@moria.home.lan>
Message-ID: <Pine.LNX.4.64.1209041509160.22689@file.rdu.redhat.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com> <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com> <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com> <20120831014359.GB15218@moria.home.lan>
 <Pine.LNX.4.64.1209031638110.15620@file.rdu.redhat.com>
 <20120904034100.GA21602@moria.home.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Sep 2012, Kent Overstreet wrote:

> On Mon, Sep 03, 2012 at 04:41:37PM -0400, Mikulas Patocka wrote:
> > ... or another possibility - start a timer when something is put to 
> > current->bio_list and use that timer to pop entries off current->bio_list 
> > and submit them to a workqueue. The timer can be cpu-local so only 
> > interrupt masking is required to synchronize against the timer.
> > 
> > This would normally run just like the current kernel and in case of 
> > deadlock, the timer would kick in and resolve the deadlock.
> 
> Ugh. That's a _terrible_ idea.
> 
> Remember the old plugging code? You ever have to debug performance
> issues caused by it?

Yes, I do remember it (and I fixed one bug that resulted in missed unplug 
and degraded performance).

But currently, deadlocks due to exhausted mempools and bios being stalled 
in current->bio_list don't happen (or do happen below so rarely that they 
aren't reported).

If we add a timer, it will turn a deadlock into an i/o delay, but it can't 
make things any worse.

BTW. can these new-style timerless plugs introduce deadlocks too? What 
happens when some bios are indefinitely delayed because their requests are 
held in a plug and a mempool runs out?

> > > I could be convinced, but right now I prefer my solution.
> > 
> > It fixes bio allocation problem, but not other similar mempool problems in 
> > dm and md.
> 
> I looked a bit more, and actually I think the rest of the problem is
> pretty limited in scope - most of those mempool allocations are per
> request, not per split.
> 
> I'm willing to put some time into converting dm/md over to bioset's
> front_pad. I'm having to learn the code for the immutable biovec work,
> anyways.

Currently, dm targets allocate request-specific data from target-specific 
mempool. mempools are in dm-crypt, dm-delay, dm-mirror, dm-snapshot, 
dm-thin, dm-verity. You can change it to allocate request-specific data 
with the bio.

Mikulas
