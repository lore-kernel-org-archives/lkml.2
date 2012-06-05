Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab2FESel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 14:34:41 -0400
Received: from relay1.sgi.com ([192.48.179.29]:54066 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab2FESek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 14:34:40 -0400
Date: Tue, 5 Jun 2012 13:34:39 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: relax_domain_level boot parameter has no effect
Message-ID: <20120605183439.GA16819@sgi.com>
References: <20120601210348.GA22471@sgi.com> <1338824262.28282.87.camel@twins> <20120604181614.GA22172@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604181614.GA22172@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 01:16:14PM -0500, Dimitri Sivanich wrote:
> On Mon, Jun 04, 2012 at 05:37:42PM +0200, Peter Zijlstra wrote:
> > On Fri, 2012-06-01 at 16:03 -0500, Dimitri Sivanich wrote:
> > > I noticed (and verified) that the relax_domain_level boot parameter does not
> > > get processed because sched_domain_level_max is 0 at the time that
> > > setup_relax_domain_level() is run.
> > > 
> > > int sched_domain_level_max;
> > > 
> > > static int __init setup_relax_domain_level(char *str)
> > > {
> > >         unsigned long val;
> > > 
> > >         val = simple_strtoul(str, NULL, 0);
> > >         if (val < sched_domain_level_max)
> > >                 default_relax_domain_level = val;
> > > 
> > >         return 1;
> > > }
> > > __setup("relax_domain_level=", setup_relax_domain_level);
> > 
> > Ah indeed.. this has been so for a while I guess.
> 
> On a very related note, the sched_relax_domain_level setting in cpuset
> doesn't appear to work correctly either (if I'm interpreting all of this
> correctly).
> 
> The reason is that the build_sched_domain() routine calls the
> set_domain_attribute() routine prior to setting the sd->level, however,
> the set_domain_attribute() routine relies on the sd->level to decide whether
> idle load balancing will be off/on.
> 
> static void set_domain_attribute(struct sched_domain *sd,
> ..
> ==>     if (request < sd->level) {
>                 /* turn off idle balance on this domain */
> ..
> ..
> struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
> ..
> ==>     set_domain_attribute(sd, attr);
>         cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
>         if (child) {
> ==>             sd->level = child->level + 1;
>                 sched_domain_level_max = max(sched_domain_level_max, sd->level);
> 
> 
> > What are you using this knob for?
> 
> I was poking around for different ways to turn off idle load balancing when
> I ran into all of this.

I'll submit a patch shortly that should return these back to what appears to
be their intended functionality.
