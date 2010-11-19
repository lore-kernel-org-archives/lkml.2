Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0KSOny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 09:43:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:53051 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab0KSOnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 09:43:53 -0500
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20101119142418.GN6554@const.bordeaux.inria.fr>
References: <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
	 <20101116211431.GA15211@tango.0pointer.de>
	 <201011182333.48281.hpj@urpla.net>
	 <20101118231218.GX6024@const.famille.thibault.fr>
	 <1290123351.18039.49.camel@maggy.simson.net>
	 <20101118234339.GA6024@const.famille.thibault.fr>
	 <AANLkTimTNxLYGLgnS9TUT_YiMnmDVrqseByGGogj+A4Z@mail.gmail.com>
	 <20101119000204.GE6024@const.famille.thibault.fr>
	 <20101119000720.GF6024@const.famille.thibault.fr>
	 <1290167844.2109.1560.camel@laptop>
	 <20101119142418.GN6554@const.bordeaux.inria.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 15:43:13 +0100
Message-ID: <1290177793.2109.1612.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 15:24 +0100, Samuel Thibault wrote:
> Peter Zijlstra, le Fri 19 Nov 2010 12:57:24 +0100, a écrit :
> > On Fri, 2010-11-19 at 01:07 +0100, Samuel Thibault wrote:
> > > Also note that having a hierarchical process structure should permit to
> > > make things globally more efficient: avoid putting e.g. your cpp, cc1,
> > > and asm processes at three corners of your 4-socket NUMA machine :) 
> > 
> > And no, using that to load-balance between CPUs doesn't necessarily help
> > with the NUMA case,
> 
> It doesn't _necessarily_ help, but it should help in quite a few cases.

Colour me unconvinced, measuring shared cache footprint using PMUs might
help (and people have actually implemented and played with that at
various times in the past) but again, the added overhead of doing so
will hurt a lot more workloads than might benefit.

> > load-balancing is an impossible job (equivalent to
> > page-replacement -- you simply don't know the future), applications
> > simply do wildly weird stuff. 
> 
> Sure. Not a reason not to get the low-hanging fruits :)

I'm not at all convinced using the process hierarchy will really help
much, but feel free to write the patch and test it. But making the
migration condition very complex will definitely hurt some workloads.

> > From a process hierarchy there's absolutely no difference between a
> > cc1/cpp/asm and some MPI jobs, both can be parent-child relations with
> > pipes between, some just run short and have data affinity, others run
> > long and don't have any.
> 
> MPI jobs typically communicate with each other. Keeping them on the same
> socket permits to keep shared-memory MPI drivers to mostly remain in
> e.g. the L3 cache. That typically gives benefits.

Pushing them away permits them to use a larger part of that same L3
cache allowing them to work on larger data sets. Most of the MPI apps
have a large compute to communication ratio because that is what allows
them to run in parallel so well (traditionally the interconnects were
terribly slow to boot), that suggests that working on larger data sets
is a good thing and running on the same node really doesn't matter since
communication is assumes slow anyway.

There really is no simple solution to his.
