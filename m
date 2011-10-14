Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab1JNSgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:36:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab1JNSgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:36:12 -0400
Date: Fri, 14 Oct 2011 14:35:39 -0400
From: Jason Baron <jbaron@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        konrad.wilk@oracle.com, rth@redhat.com
Subject: Re: [PATCH RFC V5 00/11] Paravirtualized ticketlocks
Message-ID: <20111014183539.GE2433@redhat.com>
References: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com>
 <1318503245.24856.12.camel@twins>
 <4E971580.6030300@goop.org>
 <20111014141701.GA2433@redhat.com>
 <4E986B2B.60803@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E986B2B.60803@goop.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 10:02:35AM -0700, Jeremy Fitzhardinge wrote:
> On 10/14/2011 07:17 AM, Jason Baron wrote:
> > On Thu, Oct 13, 2011 at 09:44:48AM -0700, Jeremy Fitzhardinge wrote:
> >> pvops is basically a collection of ordinary _ops structures full of
> >> function pointers, but it has a layer of patching to help optimise it. 
> >> In the common case, this just replaces an indirect call with a direct
> >> one, but in some special cases it can inline code.  This is used for
> >> small, extremely performance-critical things like cli/sti, but it
> >> awkward to use in general because you have to specify the inlined code
> >> as a parameterless asm.
> >>
> > I haven't look at the pvops patching (probably should), but I was
> > wondering if jump labels could be used for it? Or is there something
> > that the pvops patching is doing that jump labels can't handle?
> 
> Jump labels are essentially binary: you can use path A or path B.  pvops
> are multiway: there's no limit to the number of potential number of
> paravirtualized hypervisor implementations.  At the moment we have 4:
> native, Xen, KVM and lguest.
> 

Yes, they are binary using the static_branch() interface. But in
general, the asm goto() construct, allows branching to any number of
labels. I have implemented the boolean static_branch() b/c it seems like
the most common interface for jump labels, but I imagine we will
introduce new interfaces as time goes on. You could of course nest
static_branch() calls, although I can't say I've tried it.

We could have an interface, that allowed static branch(), to specifiy an
arbitrary number of no-ops such that call-site itself could look anyway
we want, if we don't know the bias at compile time. This, of course
means potentially greater than 1 no-op in the fast path. I assume the
pvops can have greater than 1 no-op in the fast path. Or is there a
better solution here?

> As I said, pvops patching is very general since it allows a particular
> op site to be either patched with a direct call/jump to the target code,
> or have code inserted inline at the site.  In fact, it probably wouldn't
> take very much to allow it to implement jump labels.
> 
> And the pvops patching mechanism is certainly general to any *ops style
> structure which is initialized once (or rarely) and could be optimised. 
> LSM, perhaps?
> 
> >> Jump_labels is basically an efficient way of doing conditionals
> >> predicated on rarely-changed booleans - so it's similar to pvops in that
> >> it is effectively a very ordinary C construct optimised by dynamic code
> >> patching.
> >>
> > Another thing is that it can be changed at run-time...Can pvops be
> > adjusted at run-time as opposed to just boot-time?
> 
> No.  In general that wouldn't really make sense, because once you've
> booted on one hypervisor you're stuck there (though hypothetically you
> could consider migration between machines with different hypervisors). 
> In some cases it might make sense though, such as switching on PV
> ticketlocks if the host system becomes overcommitted, but leaving the
> native ticketlocks enabled if not.
> 
>     J

A nice featuer of jump labels, is that it allows the various branches
(currently we only support 2), to be written in c code (as opposed to asm),
which means you can write your code as you normally would and access any
parameters as you normally would - hopefully, making the code pretty
readable as well.

I hope this better clarifies the use-cases for the various mechanisms.

Thanks,

-Jason
