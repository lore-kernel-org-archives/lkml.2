Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384Ab2HXNAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:00:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:33039 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab2HXNA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:00:26 -0400
Date: Fri, 24 Aug 2012 15:00:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: Borislav Petkov <bp@alien8.de>, Attilio Rao <attilio.rao@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH v4 1/2] XEN/X86: Improve semantic support for
 x86_init.mapping.pagetable_reserve
In-Reply-To: <20120824113644.GE11007@konrad-lan.dumpdata.com>
Message-ID: <alpine.LFD.2.02.1208241446090.2856@ionos>
References: <1345648122-11935-1-git-send-email-attilio.rao@citrix.com> <1345648122-11935-2-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208231722040.2856@ionos> <50364FE5.1070608@citrix.com> <alpine.LFD.2.02.1208231800530.2856@ionos>
 <503664C3.7010301@citrix.com> <20120824100309.GG3019@liondog.tnic> <20120824113644.GE11007@konrad-lan.dumpdata.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2012, Konrad Rzeszutek Wilk wrote:
> His goal was to document the semantics of the call. We all want to clean
> up the mess of extra calls that don't make sense (remember the
> write_msr_safe one?) and the first step is get some of the calls
> documented so that we know if some of these calls can be moved around
> for refactoring. Attilio went then beyond that being enthuastic about
> this and wrote logic to deal with the description of the semantics.
> In part this would help the refactoring as it would catch runtime
> issues.

No. His logic to deal with the semantics started to imply wrong and
silly semantics in the first place. What's the point of making a
function deal with A != B, where A is required to be equal to B. We do
not add special cases for stuff which cannot happen neither on
baremetal nor on XEN. Period.

> That is at odds with what Peter would like to have fixed:
> (from
> http://lists.linux-foundation.org/pipermail/ksummit-2012-discuss/2012-June/000070.html)
> "
>    Hooks and notifiers are a form of "COME FROM" programming, and they
>    make it very hard to reason about the code.  The only way that that
>    can be reasonably mitigated is by having the exact semantics of a
>    hook or notifier -- the preconditions, postconditions, and other
>    invariants -- carefully documented.  Experience has shown that in
>    practice that happens somewhere between rarely and never.
> 
>    Hooks that terminate into hypercalls or otherwise are empty in the
>    "normal" flow are particularly problematic, as it is trivial for a
>    mainstream developer to break them.
> "

I'm not against documentation. I'm against wrong documentation, wrong
and silly semantics and pointless code which tries to deal with cases which
are just wrong to begin with.

I looked at the whole pgt_buf_* mess and it's amazingly stupid. We
could avoid all that dance and make all of that pgt_buf_* stuff static
and provide proper accessor functions and hand start, end, top to the
reserve function instead of fiddling with global variables all over
the place. That'd be a real cleanup and progress.

But we can't do that easily. And why? Because XEN is making magic
decisions based on those globals in mask_rw_pte().

	/*
	 * If the new pfn is within the range of the newly allocated
	 * kernel pagetable, and it isn't being mapped into an
	 * early_ioremap fixmap slot as a freshly allocated page, make sure
	 * it is RO.
	 */
	if (((!is_early_ioremap_ptep(ptep) &&
			pfn >= pgt_buf_start && pfn < pgt_buf_top)) ||
			(is_early_ioremap_ptep(ptep) && pfn != (pgt_buf_end - 1)))

This comment along with the implementation is really a master piece of
obfuscation. Let's see what this is doing. RO is enforced when:

This is not an early ioreamp AND

      pfn >= pgt_buf_start && pfn < pgt_buf_top

So why is this checking pgt_buf_top? The early stuff is installed
within pgt_buf_start and pgt_buf_end. Anything which is >=
pgt_buf_end at this point is completely wrong.

Now the second check is even more interesting:

If this is an early ioremap AND

      pfn != (pgt_buf_end -1 )

then it's forced RO as well.

So this checks whether the early ioremap is happening on the last
allocated pfn from the pgt_buf range.

OMG, really great design! And the comment above that if() obfuscation
is not really helping much.

If anything is missing a semantic documentation and analysis then
definitely code like this which is just a cobbled together steaming
pile of ....

Thanks,

	tglx



