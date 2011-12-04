Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab1LDDPX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 22:15:23 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53361 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab1LDDPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 22:15:21 -0500
Message-ID: <4EDAE5C5.30101@lwfinger.net>
Date: Sat, 03 Dec 2011 21:15:17 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <borislav.petkov@amd.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.2-rc2 freezes on boot for AMD K6 - bisected to commit bcb80e53877c2045d9e52f4a71372c3fe6501f6f
References: <4ED5B70F.606@lwfinger.net> <4ED5C640.8030102@linux.vnet.ibm.com> <4ED5D6C5.5050704@lwfinger.net> <4EDA89F2.9070107@lwfinger.net> <CA+55aFwWVeAGT2p3tohRLh7VL8f4ztGwAHZxBmosEAGKJfL+Qg@mail.gmail.com>
In-Reply-To: <CA+55aFwWVeAGT2p3tohRLh7VL8f4ztGwAHZxBmosEAGKJfL+Qg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2011 05:07 PM, Linus Torvalds wrote:
> On Sat, Dec 3, 2011 at 12:43 PM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>
> Ugh. I hate that patch.
>
> It's completely stupid. If "rdmsr_safe()" doesn't work at that point
> in the boot, then it's pointless to call it.
>
> So this change is pure and utter crap:
>
>    -	rdmsr_safe(MSR_AMD64_PATCH_LEVEL,&c->microcode,&dummy);
>    +	if (c->x86>= 0xf)
>    +		rdmsr_safe(MSR_AMD64_PATCH_LEVEL,&c->microcode,&dummy);
>
> because it is misleading as hell: that rdmsr isn't *safe* at all, so
> why are we calling "rdmsr_safe()"?
>
> It's wrong.
>
> The right patch would either just remove the "safe" part (and just say
> that the register has to be supported if c->x86>= 0xf), but quite
> honestly, I don't see why we do that thing in early_init_amd() AT ALL.
> Afaik, the microcode version field isn't really *needed* by the
> kernelin the first place, much less is it needed by the *early* boot,
> so why isn't this in 'init_amd()' a bit later when the "safe" version
> actually *works*?
>
> IOW, I think the patch should be something like the attached (TOTALLY
> UNTESTED) patch. Larry, does this work for you? It just moves the
> rdmsr_safe() to the later function.
>
> Borislav?
>
>> I just updated mainline to 3.2-rc4, and that patch is not included. Please
>> check with Ingo to see why it was not available. It is a real show stopper
>> for old AMD CPUs.
>
> Ingo seems to have fallen off the earth for the last two weeks.
> There's *one* email form him about 12 hours ago, before that the last
> one I see is from early November.
>
> Ingo, everything ok?
>
>                     Linus

Linus,

With your patch, my K8 box boots fine running 3.2-rc4. If you wish, you may add 
a "Tested-by: Larry Finger <Larry.Finger@lwfinger.net>.

Thanks for the explanation, and the patch,

Larry
