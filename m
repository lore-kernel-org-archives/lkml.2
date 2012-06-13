Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab2FMOtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:49:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:38363 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab2FMOtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:49:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165170880"
Date: Wed, 13 Jun 2012 07:49:07 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org, hpa@zytor.com,
        eranian@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: Track minimum microcode revision globally v2
Message-ID: <20120613144907.GA32604@tassilo.jf.intel.com>
References: <1339536350-10463-1-git-send-email-andi@firstfloor.org>
 <1339577392.31548.122.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339577392.31548.122.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 10:49:52AM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-12 at 14:25 -0700, Andi Kleen wrote:
> > +void update_min_microcode(struct cpuinfo_x86 *c)
> > +{
> > +       int i;
> > +
> > +       for_each_online_cpu (i)
> 
> Superfluous whitespace
> 
> > +               if (cpu_data(i).microcode < c->microcode)
> > +                       return;
> 
> That needs {}

You must be following a different code style guide than the Linux one.


> >         c->microcode = val[1];
> >  
> > +       update_min_microcode(c);
> >         return 0;
> >  }
> 
> Doing it here means doing the for_each_cpu thing with preempt/irqs
> disabled, that's not funny.

Well a ucode update is a really slow operation anyways.  And the loop
gets stopped at the first mismatch. So it'll never be n^2 and in most
cases much faster. Generally the loop should be several orders 
of magnitude less than the actual cost of the update, even on large 
systems.

> Also this is still a O(n^2) proposition.. so how is this better than the
> notifier thing I had?

Simpler at least. 

I don't know why people love notifiers, they are a "COME FROM" and make
every code who uses them a mess. 

As for CPU_STARTING don't know how complicated it would be. I suppose
it could be done as a follow up.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
