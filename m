Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab0FVH1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 03:27:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:46262 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab0FVH1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 03:27:21 -0400
Subject: Re: [patch 11/33] fs: dcache scale subdirs
From: Peter Zijlstra <peterz@infradead.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Kacur <jkacur@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1277186557.1791.7.camel@work-vm>
References: <20090904065142.114706411@nick.local0.net>
	 <20090904065535.609317663@nick.local0.net>
	 <1276787615.27822.426.camel@twins> <20100617165329.GA6138@laptop>
	 <1277127322.1875.516.camel@laptop> <20100621144806.GC31679@laptop>
	 <1277132103.1875.519.camel@laptop>  <1277186557.1791.7.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 22 Jun 2010 09:27:11 +0200
Message-ID: <1277191631.1875.525.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 23:02 -0700, john stultz wrote:
> On Mon, 2010-06-21 at 16:55 +0200, Peter Zijlstra wrote:
> > On Tue, 2010-06-22 at 00:48 +1000, Nick Piggin wrote:
> > > > Right, so I was staring at the -rt splat, so its John who created that
> > > > wreckage?
> > > 
> > > It was, but apparently they saw an RCU bug there somewhere and hit it
> > > with the big hammer. I haven't been able to reproduce it on a non-rt
> > > kernel yet, and I see yet why RCU is not good enough here.
> > 
> > John, could you describe the failure you spotted?
> 
> The problem was that the rcu_read_lock() on the dentry ascending wasn't
> preventing d_put/d_kill from removing entries from the parent node. So
> the next entry we tried to follow was invalid. So we were getting odd
> oopses from select_parent().
> 
> I'm not as familiar with the rcu rules there, so the patch I made just
> held the locks as it went down the chain. Not ideal of course, but still
> an improvement over the dcache_lock that was there prior.
> 
> Peter: I'm sorry, I've been out for a few days. Can you give me some
> background on what brought this up and what -rt splat you mean?

Well, you make lockdep very unhappy by locking multiple dentries
(unbounded number) all in the same lock class.
