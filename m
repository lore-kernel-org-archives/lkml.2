Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab0KORk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:40:58 -0500
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1571 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261Ab0KORk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:40:56 -0500
Message-ID: <4CE17098.8090000@xs4all.nl>
Date: Mon, 15 Nov 2010 18:40:40 +0100
From: Jim Bos <jim876@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Thunderbird/3.1.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jakub Jelinek <jakub@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
References: <4CD843DC.10106@gmail.com> <Pine.LNX.4.64.1011091352460.29956@wotan.suse.de> <20101109134816.GB29433@basil.fritz.box> <m3lj52txaq.fsf@redhat.com> <4CD97A3D.1040602@xs4all.nl> <m31v6nmmr3.fsf@jhcloos.com> <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com> <20101115085605.GE2583@sunsite.ms.mff.cuni.cz> <20101115100331.GG2583@sunsite.ms.mff.cuni.cz> <20101115105446.GD7269@basil.fritz.box> <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com> <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com>
In-Reply-To: <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 05:04 PM, Linus Torvalds wrote:
> On Mon, Nov 15, 2010 at 3:16 AM, Jakub Jelinek <jakub@redhat.com> wrote:
>>
>> I don't see any problems on the assembly level.  i8k_smm is
>> not inlined in this case and checks all 3 conditions.
> 
> If it really is related to gcc not understanding that "*regs" has
> changed due to the memory being an automatic variable, and passing in
> "regs" itself as a pointer to that automatic variable together with
> the "memory" clobber not being sufficient, than I think it's the lack
> of inlining that will automatically hide the bug.
> 
> (Side note: and I think this does show how much of a gcc bug it is not
> to consider "memory" together with passing in a pointer to an asm to
> always be a clobber).
> 
> Because if it isn't inlined, then "regs" will be seen a a real pointer
> to some external memory (the caller) rather than being optimized to
> just be the auto structure on the stack. Because *mem is auto only
> within the context of the caller.
> 
> Which actually points to a possible simpler:
>  - remove the "+m" since it adds too much register pressure
>  - mark the i8k_smm() as "noinline" instead.
> 
> Quite frankly, I'd hate to add even more crud to that inline asm (to
> save/restore the registers manually). It's already not the prettiest
> thing around.
> 
> So does the attached patch work for everybody?
> 
>                              Linus

Hmm, that doesn't work.

[ Not sure if you read to whole thread but initial workaround was to
change the asm(..) to asm volatile(..) which did work. ]

Jim.
