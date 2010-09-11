Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab0IKNbp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 09:31:45 -0400
Received: from r00tworld.com ([212.85.137.21]:34399 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab0IKNbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 09:31:38 -0400
From: pageexec@freemail.hu
To: Roland McGrath <roland@redhat.com>
Date: Sat, 11 Sep 2010 15:30:38 +0200
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] setup_arg_pages: diagnose excessive argument size
Reply-to: pageexec@freemail.hu
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        "Brad Spengler <spender@grsecurity.net> Eugene Teo" 
	<eugene@redhat.com>
Message-ID: <4C8B847E.4988.3D86C35@pageexec.freemail.hu>
In-reply-to: <20100910085915.8CC23405D5@magilla.sf.frob.com>
References: <20100827220258.GF4703@outflux.net>, <pageexec@freemail.hu's message of  Wednesday, 8 September 2010 10:29:58 +0200 <4C874986.23581.F34F4BD@pageexec.freemail.hu>>, <20100910085915.8CC23405D5@magilla.sf.frob.com>
X-mailer: Pegasus Mail for Windows (4.52)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Sat, 11 Sep 2010 15:30:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Sep 2010 at 1:59, Roland McGrath wrote:

> > > +	if (unlikely(stack_top < mmap_min_addr) ||
> > 
> > this could arguably elicit some warning, or even better, prevent the
> > sysctl from setting mmap_min_addr too high in the first place.
> 
> This code has local checks to ensure that things don't fail worse later.
> Those are good to have regardless.  If you'd like to add some constraints
> on setting mmap_min_addr, that's certainly fine too.  But it's no reason
> not to have this simple and clear check here.

it's somewhat confusing as it does not immediately relate to the problem
you're addressing. let's take a step back and see what issues we have here:

1. the would-be stack vma shifts down so much that it becomes completely
   invalid (due to the int wraparound on its start address).

2. the would be stack vma shifts down to violate mmap_min_addr.

it's obvious that before ensuring 2, 1 must pass. the check for 1 does not
at all involve mmap_min_addr, whereas both of your checks do. even worse, the
check for 2 doesn't depend on the relation between stack_top and mmap_min_addr
per se (userland has no influence over them), so as i said, it's all confusing.

> > or alternatively, just check for
> > 
> > 	mmap_min_addr > stack_top - (vma->vm_end - vma->vm_start)
> 
> IMHO that is far less clear as to what the intent of the check is than what
> I wrote.

why is that? it's obvious that vm_end-vm_size=vm_size and the check simply
ensures that problem 2 above doesn't occur whereas in neither of your checks
can one see the clear intent for ensuring 2. your 2nd check basically ensures
that vm_size fits in the usable address space bounded by [mmap_min_addr, stack_top]
but it doesn't immediately tell the user why that size check is useful (especially
since we're not concerned with sizes per se, but addresses, it's just a corollary
in this particular case that a size check can replace an address check, but that
doesn't mean it'll help any future reader see the original intent). so while
the math is ok in your checks (modulo the = case), it's a kind of premature
optimization that hides the problems you're addressing.

>  It's especially subtle that this check allows overflow
> and then you check for that later,

no, actually that particular check was for addressing one particular
problem (to show you how to formulate it that makes intent clear), as a
train of thought if you like. the final proposed version (which has been
in PaX) has the int overflow check first and then the mmap_min_addr check.

> rather than the formulation I gave
> where no overflow is possible and it's immediately obvious why. 

you're only focused on the math and let the human intent slip by, that's
the issue i have with your checks (and you didn't get the = corner case
right btw, it should be allowed, nor refused if you want to be pedantic).

really, in security clarity of intent and its manifestation in code takes
precedence over optimization, let the compiler do the latter job.

> > which looks even better if done in shift_arg_pages as i've done it in PaX:
> 
> My change to setup_arg_pages is consistent with the existing
> CONFIG_STACK_GROWSUP code.

the GROWSUP code doesn't use unlikely (very confusing to see it in this
context since you're not addressing any hot path/performance issues), nor
does it care about mmap_min_addr (whereas both of your checks do which
depending on the generated asm, may even be racy when mmap_min_addr changes)
nor does it check for any int overflows. about the only similarity i can
see is its computation of 'vm_size' and an associated size check (properly
commented unlike your code) but it's normal there, whereas the problems you're
addressing are fundamentally vma address related, not vma size related.

> IMHO simple fixes should go in first
> and other restructuring of the code can be done later.

yours is not a simple fix as it doesn't make it clear what two problems
you're trying to address with your checks.

> > > +		return -ENOMEM;
> > 
> > i'd say EFAULT is more consistent, ENOMEM is used for cases when the kernel
> > couldn't allocate physical memory for something, EFAULT is when there's some
> > issue with the address space itself (based on the reaction to find_vma or
> > expand_stack failures).
> 
> I disagree.

well, in that case the EFAULT return codes in this function need some
cleanup too, you know, in the name of consistency ;).

> > also what about the BUG_ON in shift_arg_pages? it could go now, right?
> 
> It is now impossible by the logic of the arithmetic, yes.  But it is
> another local sanity check asserting the assumptions of the code in that
> function.  So there is no reason to 

there is no reason for it to be a BUG_ON (never was in fact), the kernel
can easily recover from the detected condition.

cheers,

 PaX Team

PS: i thought it was common courtesy and customary to credit people in the
commit who found/reported/fixed problems.

