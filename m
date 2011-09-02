Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab1IBVm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 17:42:27 -0400
Received: from claw.goop.org ([74.207.240.146]:45336 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab1IBVmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 17:42:25 -0400
Message-ID: <4E614DBD.3000504@goop.org>
Date: Fri, 02 Sep 2011 14:42:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 00/13] [PATCH RFC] Paravirtualized ticketlocks
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com> <CA+55aFxpz+1bXVsg7kMeozePa=j_2-OaOuidQ4Y9Bg063=HMfg@mail.gmail.com> <4E61377B.4020600@goop.org> <CA+55aFy8p5-q9cNfyWz1bFT4RKxZosyHM2t5g2miiWm2DvP1Gg@mail.gmail.com>
In-Reply-To: <CA+55aFy8p5-q9cNfyWz1bFT4RKxZosyHM2t5g2miiWm2DvP1Gg@mail.gmail.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 01:27 PM, Linus Torvalds wrote:
> On Fri, Sep 2, 2011 at 1:07 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> I don't know whether that fastpath code is small enough to consider
>> inlining everywhere?
> No.
>
> There's no point in inlining something that ends up containing a
> conditional function call: gcc will have to effectively save/restore
> registers around that thing anyway, so you lose a lot of the
> advantages of inlining. So I think it's better done as an out-of-line
> function, which I thought we did for spinlocks anyway.

Yes, lock currently out-of-line.

I should also make sure that unlock is also out of line when
paravirtualized.

> Also, do you run with CONFIG_OPTIMIZE_SIZE? Without that, gcc should
> be smart enough to make a "likely()" case be a fall-through.

Ah, I was wondering why I'd never seen likely/unlikely do anything
useful.  With OPTIMIZE_SIZE=n, there's no point in explicitly moving the
slowpath out to a separate function.

So the only downside with this variant is that it breaks my design
criteria of making the generated code look identical to the the original
code when CONFIG_PARAVIRT_SPINLOCKS=n.  But I don't know if that's an
actual downside in practice.

    J
