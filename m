Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab2HXNhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:37:50 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:48133 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2HXNhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:37:46 -0400
X-IronPort-AV: E=Sophos;i="4.80,304,1344211200"; 
   d="scan'208";a="14169629"
Message-ID: <50378070.3000904@citrix.com>
Date: Fri, 24 Aug 2012 14:24:00 +0100
From: Attilio Rao <attilio.rao@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH v4 1/2] XEN/X86: Improve semantic support for x86_init.mapping.pagetable_reserve
References: <1345648122-11935-1-git-send-email-attilio.rao@citrix.com> <1345648122-11935-2-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208231722040.2856@ionos> <50364FE5.1070608@citrix.com> <alpine.LFD.2.02.1208231800530.2856@ionos> <503664C3.7010301@citrix.com> <20120824100309.GG3019@liondog.tnic> <20120824113644.GE11007@konrad-lan.dumpdata.com> <alpine.LFD.2.02.1208241446090.2856@ionos>
In-Reply-To: <alpine.LFD.2.02.1208241446090.2856@ionos>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/08/12 14:00, Thomas Gleixner wrote:
> On Fri, 24 Aug 2012, Konrad Rzeszutek Wilk wrote:
>    
>> His goal was to document the semantics of the call. We all want to clean
>> up the mess of extra calls that don't make sense (remember the
>> write_msr_safe one?) and the first step is get some of the calls
>> documented so that we know if some of these calls can be moved around
>> for refactoring. Attilio went then beyond that being enthuastic about
>> this and wrote logic to deal with the description of the semantics.
>> In part this would help the refactoring as it would catch runtime
>> issues.
>>      
> No. His logic to deal with the semantics started to imply wrong and
> silly semantics in the first place. What's the point of making a
> function deal with A != B, where A is required to be equal to B. We do
> not add special cases for stuff which cannot happen neither on
> baremetal nor on XEN. Period.
>    

Please stop referring to your opinion as if they are the only source of 
truth.
Actually here is a matter of comparing prices. We thought accounting for 
different { start, end } was a viable option, you want something simpler 
and as a x86-maintainer you enforce your opinion over here. But this 
doesn't mean what the patch does is "wrong".

>> That is at odds with what Peter would like to have fixed:
>> (from
>> http://lists.linux-foundation.org/pipermail/ksummit-2012-discuss/2012-June/000070.html)
>> "
>>     Hooks and notifiers are a form of "COME FROM" programming, and they
>>     make it very hard to reason about the code.  The only way that that
>>     can be reasonably mitigated is by having the exact semantics of a
>>     hook or notifier -- the preconditions, postconditions, and other
>>     invariants -- carefully documented.  Experience has shown that in
>>     practice that happens somewhere between rarely and never.
>>
>>     Hooks that terminate into hypercalls or otherwise are empty in the
>>     "normal" flow are particularly problematic, as it is trivial for a
>>     mainstream developer to break them.
>> "
>>      
> I'm not against documentation. I'm against wrong documentation, wrong
> and silly semantics and pointless code which tries to deal with cases which
> are just wrong to begin with.
>
> I looked at the whole pgt_buf_* mess and it's amazingly stupid. We
> could avoid all that dance and make all of that pgt_buf_* stuff static
> and provide proper accessor functions and hand start, end, top to the
> reserve function instead of fiddling with global variables all over
> the place. That'd be a real cleanup and progress.
>    

Assuming that having a bunch of static variable in boot-time code is 
"clean" in your head (and certainly it is not in mine) ...

> But we can't do that easily. And why? Because XEN is making magic
> decisions based on those globals in mask_rw_pte().
>
> 	/*
> 	 * If the new pfn is within the range of the newly allocated
> 	 * kernel pagetable, and it isn't being mapped into an
> 	 * early_ioremap fixmap slot as a freshly allocated page, make sure
> 	 * it is RO.
> 	 */
> 	if (((!is_early_ioremap_ptep(ptep)&&
> 			pfn>= pgt_buf_start&&  pfn<  pgt_buf_top)) ||
> 			(is_early_ioremap_ptep(ptep)&&  pfn != (pgt_buf_end - 1)))
>
> This comment along with the implementation is really a master piece of
> obfuscation. Let's see what this is doing. RO is enforced when:
>
> This is not an early ioreamp AND
>
>        pfn>= pgt_buf_start&&  pfn<  pgt_buf_top
>
> So why is this checking pgt_buf_top? The early stuff is installed
> within pgt_buf_start and pgt_buf_end. Anything which is>=
> pgt_buf_end at this point is completely wrong.
>
> Now the second check is even more interesting:
>
> If this is an early ioremap AND
>
>        pfn != (pgt_buf_end -1 )
>
> then it's forced RO as well.
>
> So this checks whether the early ioremap is happening on the last
> allocated pfn from the pgt_buf range.
>
>    

... how this really prevents pgt_buf_{start, end, top} to be correctly 
cleaned up with accessor function? Because it is completely beyond my 
understanding. It would be enough to implement an inspecting function 
here to export the logic in some sort of way. Also, besides the usage of 
pgt_buf_{start, end, top} out of arch/x86/mm/init.c and besides maybe 
the extra-check you point out, I don't see how this code is supposed to 
be broken.
More importantly, this code snipped is completely orthogonal to the 
proposed patch.
x86_init.mapping.pagetable_reserve will probabilly keep living even 
after the "cleanup" you speak about.

> OMG, really great design! And the comment above that if() obfuscation
> is not really helping much.
>
> If anything is missing a semantic documentation and analysis then
> definitely code like this which is just a cobbled together steaming
> pile of ....
>    

Look, when it cames to "comparing prices" situation I can reimplement 
things in the way you prefer, but here it seems you are just going out 
of the line without a real reason and certainly that was uncalled for.

What I want to understand now is: are you favorable in taking into tips 
a different patch to x86_init.mapping.pagetable_reserve semantic or you 
would not consider it just on the basis that other xen-related code 
doesn't behave the way you like, without giving any real technical 
objection?

Attilio
