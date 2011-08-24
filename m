Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1HXXT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:19:29 -0400
Received: from claw.goop.org ([74.207.240.146]:53973 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab1HXXT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:19:28 -0400
Message-ID: <4E5586FD.7080103@goop.org>
Date: Wed, 24 Aug 2011 16:19:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Christoph Lameter <cl@linux.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 13/15] x86: add cmpxchg_flag() variant
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com> <alpine.DEB.2.00.1108231355380.26421@router.home> <4E540548.4080402@goop.org> <4E541154.6090805@zytor.com> <4E542681.2090703@goop.org> <alpine.DEB.2.00.1108240852370.24118@router.home> <4E5527C2.8000801@goop.org> <alpine.DEB.2.00.1108241408310.30776@router.home> <4E555FBB.3020906@zytor.com> <4E556150.8030100@goop.org> <4E558380.7060304@zytor.com> <CA+55aFy9r7jHi_9B4zH9LEy4PidWvjs5nDddHA5RyKRvunDehA@mail.gmail.com>
In-Reply-To: <CA+55aFy9r7jHi_9B4zH9LEy4PidWvjs5nDddHA5RyKRvunDehA@mail.gmail.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 04:11 PM, Linus Torvalds wrote:
> On Wed, Aug 24, 2011 at 4:04 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> I was also thinking that using it reduces register pressure, since you
>>> don't need to keep the "old" value around, so it dies sooner.
>> ... but you burn a register for the intermediate flag value, so you're
>> just as bad off.
> But that register has much shorter liveness - so I do agree that it *can* help.
>
> Whether it actually *does* help is unclear. I do agree that we might
> be better off without introducing yet another (questionable)
> interface.

I think the interface is useful because it directly expresses what many
cmpxchg users want to know: "Did that work?"  There are very few users
which actually care what the "old" value was if it wasn't what they were
expecting.

There's 3(ish) ways it could be implemented, but I don't have a strong
opinion on them:

 1. with a direct compare, as people are doing now
 2. with sete to set a flag (clearly better for > wordsize arguments)
 3. with asm goto
 4. (with a hypothetical gcc extension which exposes condition codes)

My experiments with asm goto were not very promising at first glance,
but it *should* be the best of the lot for most users.  A hybrid 1/2
implementation would also be possible.

But the interface hides the implementation specifics, so its not all
that important.

    J
