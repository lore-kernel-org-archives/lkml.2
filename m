Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab0LVAkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:40:13 -0500
Received: from relay3.sgi.com ([192.48.152.1]:42563 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753908Ab0LVAkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:40:12 -0500
Date: Tue, 21 Dec 2010 16:40:10 -0800
From: Arthur Kepner <akepner@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/irq: assign vectors from numa_node
Message-ID: <20101222004010.GI4709@sgi.com>
References: <20101203205348.GI20481@sgi.com> <alpine.LFD.2.00.1012101051290.2653@localhost6.localdomain6> <20101216223442.GE20481@sgi.com> <alpine.LFD.2.00.1012170145330.12146@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012170145330.12146@localhost6.localdomain6>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 10:04:48AM +0100, Thomas Gleixner wrote:
> B1;2401;0cOn Thu, 16 Dec 2010, Arthur Kepner wrote:
> 
> > On Fri, Dec 10, 2010 at 11:55:12AM +0100, Thomas Gleixner wrote:
> > > .....
> > > There is absolutely no point assigning 4096 interrupts to a single
> > > node in the first place. 
> > 
> > I'm not arguing that it's a good idea for a driver to request so 
> > many resources. But some do. ...
> 
> Right, some do and we now make efforts to let them do that nonsense no
> matter what ?

To me, it seems better (and easier) to let drivers do non-sensical 
things, than to determine what is sensible for a particluar driver. 

How would you choose a limit of interrupt allocations? 

> 
> >  .... And what we do now is even worse than 
> > assigning all the interrupts to a single node.
> 
> We assign it to a single core, which is wrong. But what the heck is
> the difference between assinging 4k irqs to a single core or to a
> single node ?
> 
> Nothing. And that's the whole problem.
> 
> I agree that the per node assignement needs to be resolved, but not in
> the way that we just ignore the underlying problems and solve them at
> the wrong place. You did not answer my comment further down in the
> patch:
> 
> > > I agree, that __assign_irq_vector() should honour the request for a
> > > node, but I don't agree, that we should magically spread stuff on
> > > whatever node we find, when the node ran out of vectors.
> > > 
> > > There is probably a reason, why you want an interrupt on a specific
> > > node and just silently pushing it somewhere else feels very wrong.
> > > 
> > > This needs to be solved from ground up with proper rules about failure
> > > modes and fallback decisions.
> 
> Where is the answer to this ?

The patch I sent made a 'best effort' to assign an interrupt to the 
node where the device is installed. If no vectors were available on 
that node, it tried elsewhere. 

> 
> > > Especially not, if we end up using only a few
> > > of them in the end. And those you use are not necessarily on that very
> > > node.
> > 
> > OK. Eric mentioned in a related thread that vector allocation 
> > might be deferred until request_irq(). That sounds like a good 
> > idea. But unless we change the way initial vector assignment is 
> 
> It does NOT sound like a good idea. 

This seems at odds with what you said here:

http://marc.info/?l=linux-kernel&m=128566136604152&w=2

(specifically this bit:

8<---------------------------- [snip] ----------------------------

..... So the solution would be:

create_irq allocates an irq number + irq descriptor, nothing else

chip->startup() will setup the vector and chip->shutdown releases
it. ......

8<---------------------------- [snip] ----------------------------

)

Can you clarify?

> ... Again, I agree that we need to fix
> the per node assignment, but we need to discuss the problem of
> anything which goes beyond the node.

Suppose that a interrupt is initially assigned to a different 
node than the device. Is that such a big deal? They can be 
redistributed later by a user-space irq balancer.

> 
> > done, it just defers the problem (assuming that request_irq() 
> > is done for every irq allocated in create_irq_nr()).
> 
> There is neither a reason for a driver to create so many interrupts in
> the first place nor a re reason to request them right away. This is
> just horrible crap, nothing else. Why the hell would a driver need to
> startup 4k interrupts just to load itself w/o a single user?
> 
> We do _NOT_ work around such insanity somewhere else even if we can.
> 
> > Using the numa_node of the device to do the initial vector 
> > assignment seems like a reasonable default choice, no? 
> 
> I still agree that we should honour the node request, but that has a
> totally different scope than what your patch is trying to do.
> 

-- 
Arthur
