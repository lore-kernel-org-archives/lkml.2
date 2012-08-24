Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373Ab2HXPS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 11:18:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:33882 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab2HXPSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 11:18:23 -0400
Date: Fri, 24 Aug 2012 17:18:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Attilio Rao <attilio.rao@citrix.com>
cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH v4 1/2] XEN/X86: Improve semantic support for
 x86_init.mapping.pagetable_reserve
In-Reply-To: <50378070.3000904@citrix.com>
Message-ID: <alpine.LFD.2.02.1208241711300.2856@ionos>
References: <1345648122-11935-1-git-send-email-attilio.rao@citrix.com> <1345648122-11935-2-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208231722040.2856@ionos> <50364FE5.1070608@citrix.com> <alpine.LFD.2.02.1208231800530.2856@ionos>
 <503664C3.7010301@citrix.com> <20120824100309.GG3019@liondog.tnic> <20120824113644.GE11007@konrad-lan.dumpdata.com> <alpine.LFD.2.02.1208241446090.2856@ionos> <50378070.3000904@citrix.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2012, Attilio Rao wrote:
> On 24/08/12 14:00, Thomas Gleixner wrote:
> > On Fri, 24 Aug 2012, Konrad Rzeszutek Wilk wrote:
> >    
> > > His goal was to document the semantics of the call. We all want to clean
> > > up the mess of extra calls that don't make sense (remember the
> > > write_msr_safe one?) and the first step is get some of the calls
> > > documented so that we know if some of these calls can be moved around
> > > for refactoring. Attilio went then beyond that being enthuastic about
> > > this and wrote logic to deal with the description of the semantics.
> > > In part this would help the refactoring as it would catch runtime
> > > issues.
> > >      
> > No. His logic to deal with the semantics started to imply wrong and
> > silly semantics in the first place. What's the point of making a
> > function deal with A != B, where A is required to be equal to B. We do
> > not add special cases for stuff which cannot happen neither on
> > baremetal nor on XEN. Period.
> >    
> 
> Please stop referring to your opinion as if they are the only source of truth.
> Actually here is a matter of comparing prices. We thought accounting for
> different { start, end } was a viable option, you want something simpler and
> as a x86-maintainer you enforce your opinion over here. But this doesn't mean
> what the patch does is "wrong".

As long as the pgt_buf logic is as it is, the allocation starts from
pgt_buf_start and from nowhere else. If you want to change that, then
you have to fix way more than the reserve_function. That part is going
to be the least of your worries.

I'm not enforcing my opinion, I'm pointing to facts and I'm refusing
to take patches which are semantically wrong and try to create
semantics which are detached from the reality.

Stop arguing and just admit that your semantical crusade is just a
failure. 
 
> > > That is at odds with what Peter would like to have fixed:
> > > (from
> > > http://lists.linux-foundation.org/pipermail/ksummit-2012-discuss/2012-June/000070.html)
> > > "
> > >     Hooks and notifiers are a form of "COME FROM" programming, and they
> > >     make it very hard to reason about the code.  The only way that that
> > >     can be reasonably mitigated is by having the exact semantics of a
> > >     hook or notifier -- the preconditions, postconditions, and other
> > >     invariants -- carefully documented.  Experience has shown that in
> > >     practice that happens somewhere between rarely and never.
> > > 
> > >     Hooks that terminate into hypercalls or otherwise are empty in the
> > >     "normal" flow are particularly problematic, as it is trivial for a
> > >     mainstream developer to break them.
> > > "
> > >      
> > I'm not against documentation. I'm against wrong documentation, wrong
> > and silly semantics and pointless code which tries to deal with cases which
> > are just wrong to begin with.
> > 
> > I looked at the whole pgt_buf_* mess and it's amazingly stupid. We
> > could avoid all that dance and make all of that pgt_buf_* stuff static
> > and provide proper accessor functions and hand start, end, top to the
> > reserve function instead of fiddling with global variables all over
> > the place. That'd be a real cleanup and progress.
> >    
> 
> Assuming that having a bunch of static variable in boot-time code is "clean"
> in your head (and certainly it is not in mine) ...

What the hell is the difference between a global variable which is
touched in boot-time code and a static variable ?

It's the same, except that the scope is a different one. And it's way
easier to enforce semantics on a limited scope than on a global one.

And that confinement cannot happen, because XEN already depends on
that global variables in a really messy way.
 
> > If anything is missing a semantic documentation and analysis then
> > definitely code like this which is just a cobbled together steaming
> > pile of ....
> >    
> 
> Look, when it cames to "comparing prices" situation I can reimplement things
> in the way you prefer, but here it seems you are just going out of the line
> without a real reason and certainly that was uncalled for.
> 
> What I want to understand now is: are you favorable in taking into tips a
> different patch to x86_init.mapping.pagetable_reserve semantic or you would
> not consider it just on the basis that other xen-related code doesn't behave
> the way you like, without giving any real technical objection?

I gave enough technical objections. Stop wasting anyones time already.

Thanks,

	tglx
