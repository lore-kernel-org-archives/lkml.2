Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab1LEHaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 02:30:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52952 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab1LEHaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 02:30:04 -0500
Date: Mon, 5 Dec 2011 08:28:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.2-rc2 freezes on boot for AMD K6 - bisected to commit
 bcb80e53877c2045d9e52f4a71372c3fe6501f6f
Message-ID: <20111205072806.GA2366@elte.hu>
References: <4ED5B70F.606@lwfinger.net>
 <4ED5C640.8030102@linux.vnet.ibm.com>
 <4ED5D6C5.5050704@lwfinger.net>
 <4EDA89F2.9070107@lwfinger.net>
 <CA+55aFwWVeAGT2p3tohRLh7VL8f4ztGwAHZxBmosEAGKJfL+Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwWVeAGT2p3tohRLh7VL8f4ztGwAHZxBmosEAGKJfL+Qg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, Dec 3, 2011 at 12:43 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> > On 11/30/2011 01:09 AM, Larry Finger wrote:
> >> On 11/29/2011 11:59 PM, Srivatsa S. Bhat wrote:
> >>>
> >>> Can you please try out the patch posted in
> >>> https://lkml.org/lkml/2011/11/28/178 ?
> 
> Ugh. I hate that patch.
> 
> It's completely stupid. If "rdmsr_safe()" doesn't work at that point
> in the boot, then it's pointless to call it.
> 
> So this change is pure and utter crap:
> 
>   -	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
>   +	if (c->x86 >= 0xf)
>   +		rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
> 
> because it is misleading as hell: that rdmsr isn't *safe* at all, so
> why are we calling "rdmsr_safe()"?

Yeah.

> It's wrong.
> 
> The right patch would either just remove the "safe" part (and 
> just say that the register has to be supported if c->x86 >= 
> 0xf), but quite honestly, I don't see why we do that thing in 
> early_init_amd() AT ALL. Afaik, the microcode version field 
> isn't really *needed* by the kernelin the first place, much 
> less is it needed by the *early* boot, so why isn't this in 
> 'init_amd()' a bit later when the "safe" version actually 
> *works*?
> 
> IOW, I think the patch should be something like the attached 
> (TOTALLY UNTESTED) patch. Larry, does this work for you? It 
> just moves the rdmsr_safe() to the later function.

Looks sane to me.

We can improve the early init properties some more - but there's 
always going to be a chicken-and-egg problem there. At minimum 
we should add a comment to rdmsr_safe() that explains its 
dependencies.

Thanks,

	Ingo
