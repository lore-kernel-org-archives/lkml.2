Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0H0IIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 04:08:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:54403 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab0H0IIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 04:08:38 -0400
Subject: Re: divide by zero bug in find_busiest_group
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Chetan Ahuja <chetan.ahuja@gmail.com>, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <AANLkTim75Z-X--LDJX8MLYF8G=vPW_GniVFQrkL7QoAy@mail.gmail.com>
References: <AANLkTimT4T-6dO=Uo05DexYf3exq=0SkZemHuB5aRP3Q@mail.gmail.com>
	 <AANLkTim75Z-X--LDJX8MLYF8G=vPW_GniVFQrkL7QoAy@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 10:08:34 +0200
Message-ID: <1282896514.1975.1748.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 12:19 -0700, Venkatesh Pallipadi wrote:
> >  There's also another place group->cpu_power values gets updated
> > without any synchronization, in
> > the update_cpu_power function. Though the only way  this could result
> > in a bad value for cpu_power
> > is by  core A reading an in-transit value for a non-atomically-updated
> > 64 bit value from core B :-). Unlikely ?
> > Very !!. Should we make that update explicity atomic ?  Would be prudent.

struct sched_group {
	...
        unsigned int cpu_power, cpu_power_orig;
	...
}

we assume that things are naturally aligned and reads/writes to word
sized entities are 'atomic' -- lots of kernel code makes this
assumption.

So the worst thing that can happen with the unsynchronized update of
cpu_power is that a reader sees the old value, no problem, we don't care
its all statistics anyway. Racing writers (could happen between regular
and nohz load-balance) we don't care about either, since the result is
either one or the other, not a mixture of both.


