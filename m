Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab1LDNJN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 08:09:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46260 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab1LDNJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 08:09:07 -0500
Date: Sun, 4 Dec 2011 14:09:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.2-rc2 freezes on boot for AMD K6 - bisected to commit
 bcb80e53877c2045d9e52f4a71372c3fe6501f6f
Message-ID: <20111204130901.GA2294@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Ingo Molnar <mingo@elte.hu>,
	Borislav Petkov <borislav.petkov@amd.com>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <4ED5B70F.606@lwfinger.net>
 <4ED5C640.8030102@linux.vnet.ibm.com>
 <4ED5D6C5.5050704@lwfinger.net>
 <4EDA89F2.9070107@lwfinger.net>
 <CA+55aFwWVeAGT2p3tohRLh7VL8f4ztGwAHZxBmosEAGKJfL+Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFwWVeAGT2p3tohRLh7VL8f4ztGwAHZxBmosEAGKJfL+Qg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 03, 2011 at 03:07:56PM -0800, Linus Torvalds wrote:
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

Well, here's the whole story behing this f*ckup:

I didn't want to have yet another family check there, thus the
rdmsr_safe version instead for machines which don't sport the 0x8B MSR.
But, the stupid exception tables are not up at early_init_* time.

hpa suggested I fix that but for that we need to sort them at build time
which is still outstanding as a patchset.

Therefore, I did this temporary fix with the intent to revisit this
later once the tables sorting is done and upstream.

> The right patch would either just remove the "safe" part (and just say
> that the register has to be supported if c->x86 >= 0xf), but quite
> honestly, I don't see why we do that thing in early_init_amd() AT ALL.

Well, no real reason, just 506ed6b53e00ba303ad778122f08e1fca7cf5efb,
which added the Intel side of this, added it there with a family check
too.

The earliest we will use the microcode version is when printing an
MCE when you get an MCE very early, right after having initted MCE
in identify_cpu->mcheck_cpu_int. But that's still fine because the
vendor-specific ->c_init hooks are called before mcheck_cpu_int anyway,
in the same function.

> Afaik, the microcode version field isn't really *needed* by the
> kernelin the first place, much less is it needed by the *early* boot,
> so why isn't this in 'init_amd()' a bit later when the "safe" version
> actually *works*?

Agreed.

> IOW, I think the patch should be something like the attached (TOTALLY
> UNTESTED) patch. Larry, does this work for you? It just moves the
> rdmsr_safe() to the later function.
> 
> Borislav?

So yes, your version works too here, so please go ahead an apply it so
that people can boot their old AMD boxes again. Sorry again for the
trouble.

> 
> > I just updated mainline to 3.2-rc4, and that patch is not included. Please
> > check with Ingo to see why it was not available. It is a real show stopper
> > for old AMD CPUs.
> 
> Ingo seems to have fallen off the earth for the last two weeks.
> There's *one* email form him about 12 hours ago, before that the last
> one I see is from early November.
> 
> Ingo, everything ok?

Oh yeah, and the fix didn't hit mainline yet thus the frustration.

Thanks.

-- 
Regards/Gruss,
Boris.
