Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1CHNqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 08:46:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:35712 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab1CHNqb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 08:46:31 -0500
Subject: Re: [patchlet] sched: fix rt throttle runtime borrowing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1299590878.7949.41.camel@marge.simson.net>
References: <1299486101.14465.25.camel@marge.simson.net>
	 <AANLkTikOY2-_EAjYTBZG4Wb9HNHRxJ4Qcd+zbvbxzPbt@mail.gmail.com>
	 <1299490414.14465.74.camel@marge.simson.net>
	 <1299508052.8093.1.camel@marge.simson.net>
	 <1299588399.2308.1424.camel@twins>
	 <1299590878.7949.41.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 08 Mar 2011 14:46:23 +0100
Message-ID: <1299591983.2308.1502.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 14:27 +0100, Mike Galbraith wrote:

> > Also, how much of a problem is it really? When I start a FIFO spinner on
> > my machine I can still ssh in and kill the thing.
> 
> It's a problem if you have one box.  Also, try starting a hefty load
> then having an rt task go nuts.  Nothing good happens here. 

Right, so I think we're not aggressive enough to migrate tasks away from
very small cpu_power CPUs, trapping tasks on such CPUs.

Of course, this is no help for pinned tasks.. but then you get what you
asked for isn't it ;-)

> > Not allowing 100% FIFO usage on SMP is going to make it very very hard
> > to implement any kind of fifo-cgroup stuff.
> 
> The only thing I care much about is the default setup.  The safety net
> should work, otherwise it's a waste.

Right, but how much trouble can be avoided by making the sched_fair
load-balancer migrate tasks away from very small cpu_power CPUs?

It won't avoid actual deadlocks when someone tries to wait for workqueue
broadcasts and the like, but how much of that is actually happening?

> Maybe only doing the borrow thing when there are active RT groups is the
> right thing to do.  (minus knob) 

Thing is the whole borrowing needs to go, Dario and me finally came up
with a 'sane' way to implement fifo-cgroups, but that does include
explicitly allowing starving CPUs.

Not allowing that very quickly degenerates into massive trouble like
gang-scheduling or bouncing tasks around like mad and generally messing
up the 'load-balancer'.


