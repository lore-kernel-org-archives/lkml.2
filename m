Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab2AEOlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:41:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52832 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab2AEOlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:41:01 -0500
Date: Thu, 5 Jan 2012 14:40:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH v5 7/8] mm: Only IPI CPUs to drain local pages if they
	exist
Message-ID: <20120105144011.GU11810@n2100.arm.linux.org.uk>
References: <1325499859-2262-1-git-send-email-gilad@benyossef.com> <1325499859-2262-8-git-send-email-gilad@benyossef.com> <4F033EC9.4050909@gmail.com> <20120105142017.GA27881@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105142017.GA27881@csn.ul.ie>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 02:20:17PM +0000, Mel Gorman wrote:
> On Tue, Jan 03, 2012 at 12:45:45PM -0500, KOSAKI Motohiro wrote:
> > >   void drain_all_pages(void)
> > >   {
> > > -	on_each_cpu(drain_local_pages, NULL, 1);
> > > +	int cpu;
> > > +	struct per_cpu_pageset *pcp;
> > > +	struct zone *zone;
> > > +
> > 
> > get_online_cpu() ?
> > 
> 
> Just a separate note;
> 
> I'm looking at some mysterious CPU hotplug problems that only happen
> under heavy load. My strongest suspicion at the moment that the problem
> is related to on_each_cpu() being used without get_online_cpu() but you
> cannot simply call get_online_cpu() in this path without causing
> deadlock.

Mel,

That's a known hotplug problems.  PeterZ has a patch which (probably)
solves it, but there seems to be very little traction of any kind to
merge it.  I've been chasing that patch and getting no replies what so
ever from folk like Peter, Thomas and Ingo.

The problem affects all IPI-raising functions, which mask with
cpu_online_mask directly.

I'm not sure that smp_call_function() can use get_online_cpu() as it
looks like it's not permitted to sleep (it spins in csd_lock_wait if
it is to wait for the called function to complete on all CPUs,
rather than using a sleepable completion.)  get_online_cpu() solves
the online mask problem by sleeping until it's safe to access it.

So, I think this whole CPU bringup mess needs to be re-thought, and
the seemingly constant to pile more and more restrictions onto the
bringup path needs resolving.  It's got to the point where there's
soo many restrictions that actually it's impossible for arch code to
simultaneously satisfy them all.
