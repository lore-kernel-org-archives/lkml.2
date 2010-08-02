Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab0HBOuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:50:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:34191 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab0HBOuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:50:17 -0400
Date: Mon, 2 Aug 2010 11:49:37 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 11/19] perf record: Release resources at exit
Message-ID: <20100802144937.GF12166@ghostprotocols.net>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
 <1280711334-30000-12-git-send-email-acme@infradead.org>
 <20100802073009.GB7841@amd>
 <20100802075422.GA24085@elte.hu>
 <20100802080353.GA8713@amd>
 <20100802091714.GA6781@elte.hu>
 <20100802095947.GA9427@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802095947.GA9427@amd>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 02, 2010 at 07:59:47PM +1000, Nick Piggin escreveu:
> On Mon, Aug 02, 2010 at 11:17:14AM +0200, Ingo Molnar wrote:
> > Most apps free their stuff before they exit - i do it in all my own C apps.
> > 
> > That is generally useful: for example it makes it easier to thread a program 
> > later on - when exit() becomes pthread_exit() and a silent leak turns into a 
> > real leak.

Right, part of my goal was exactly the potential librarization of
nowaday main routines of builtin commands.

> > Hence Valgrind checking for exit() by default looks useful to me.
> 
> Sure, most of the time I would too (in fact, all the time seeing as
> I don't write non-trivial user programs). But when you're doing last
> pass optimisations, it would be very reasonable to avoid things like
> teardown of complex data structures.

Yeah, I thought about having some test to only do the on-exit
destruction of lots of rbtrees if in debugging mode, and I may end up
doing it at some point.

But on another angle, right now I think we really need to more
aggressively delete stuff (like maps that had no hits on
PERF_RECORD_EXIT'ed threads and thus have no reference on any hist_entry
instance) to support huge perf.data file buildid exit processing. So
part of the goal was that: no leaks left behind policy.

That is, till the day when we stash the 20 byte buildid in the per
binary image loaded kernel data structure so that we can have it in the
PERF_RECORD_MMAP and avoid all this processing at exit, and instead do
it taking advantage of the existing noise at loading time. 8-)
 
- Arnaldo
