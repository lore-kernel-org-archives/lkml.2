Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab0LQJFC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 04:05:02 -0500
Received: from www.tglx.de ([62.245.132.106]:50159 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab0LQJE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 04:04:57 -0500
Date: Fri, 17 Dec 2010 10:04:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arthur Kepner <akepner@sgi.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/irq: assign vectors from numa_node
In-Reply-To: <20101216223442.GE20481@sgi.com>
Message-ID: <alpine.LFD.2.00.1012170145330.12146@localhost6.localdomain6>
References: <20101203205348.GI20481@sgi.com> <alpine.LFD.2.00.1012101051290.2653@localhost6.localdomain6> <20101216223442.GE20481@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2401;0cOn Thu, 16 Dec 2010, Arthur Kepner wrote:

> On Fri, Dec 10, 2010 at 11:55:12AM +0100, Thomas Gleixner wrote:
> > On Fri, 3 Dec 2010, Arthur Kepner wrote:
> > > 
> > > Several drivers (e.g., mlx4_core) do something similar to:
> > > 
> > > 	err = pci_enable_msix(pdev, entries, num_possible_cpus());
> > 
> > Which is the main problem and this patch just addresses the
> > symptoms. As Eric pointed out earlier, this needs to be solved
> > differently.
> > 
> > There is absolutely no point assigning 4096 interrupts to a single
> > node in the first place. 
> 
> I'm not arguing that it's a good idea for a driver to request so 
> many resources. But some do. ...

Right, some do and we now make efforts to let them do that nonsense no
matter what ?

>  .... And what we do now is even worse than 
> assigning all the interrupts to a single node.

We assign it to a single core, which is wrong. But what the heck is
the difference between assinging 4k irqs to a single core or to a
single node ?

Nothing. And that's the whole problem.

I agree that the per node assignement needs to be resolved, but not in
the way that we just ignore the underlying problems and solve them at
the wrong place. You did not answer my comment further down in the
patch:

> > I agree, that __assign_irq_vector() should honour the request for a
> > node, but I don't agree, that we should magically spread stuff on
> > whatever node we find, when the node ran out of vectors.
> > 
> > There is probably a reason, why you want an interrupt on a specific
> > node and just silently pushing it somewhere else feels very wrong.
> > 
> > This needs to be solved from ground up with proper rules about failure
> > modes and fallback decisions.

Where is the answer to this ?

> > Especially not, if we end up using only a few
> > of them in the end. And those you use are not necessarily on that very
> > node.
> 
> OK. Eric mentioned in a related thread that vector allocation 
> might be deferred until request_irq(). That sounds like a good 
> idea. But unless we change the way initial vector assignment is 

It does NOT sound like a good idea. Again, I agree that we need to fix
the per node assignment, but we need to discuss the problem of
anything which goes beyond the node.

> done, it just defers the problem (assuming that request_irq() 
> is done for every irq allocated in create_irq_nr()).

There is neither a reason for a driver to create so many interrupts in
the first place nor a re reason to request them right away. This is
just horrible crap, nothing else. Why the hell would a driver need to
startup 4k interrupts just to load itself w/o a single user?

We do _NOT_ work around such insanity somewhere else even if we can.

> Using the numa_node of the device to do the initial vector 
> assignment seems like a reasonable default choice, no? 

I still agree that we should honour the node request, but that has a
totally different scope than what your patch is trying to do.

Thanks,

	tglx
