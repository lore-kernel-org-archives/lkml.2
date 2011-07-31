Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab1GaBdC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 21:33:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53305 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab1GaBc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 21:32:57 -0400
Message-ID: <4E34B095.100@zytor.com>
Date: Sat, 30 Jul 2011 18:32:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com> <1311971867-25124-2-git-send-email-hpa@linux.intel.com> <CA+55aFz07ewwkBHeqj_VqAiNCBzDj8uzA0xzt2fc4qrYB9O19g@mail.gmail.com>
In-Reply-To: <CA+55aFz07ewwkBHeqj_VqAiNCBzDj8uzA0xzt2fc4qrYB9O19g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2011 06:13 PM, Linus Torvalds wrote:
> So here is my counter-suggestion
> 
> NOTE NOTE NOTE! This is completely and utterly untested.  I didn't
> actually check how big the "rdrand" and "setc" instructions are, so
> the ASM_NOP4 there is just a random "I guess two 'xor' instructions
> are four bytes shorter than the rdrand/setc instructions are".
> 
> So please don't take this as a serious patch that should be applied,
> but instead take it as a serious alternative *approach*.
> 
> Note that with the default inline function in <asm-generic/random.h>
> is designed so that architectures that use it (this patch does *not*
> contain the architecture glue to enable it) will compile the loop in
> random.c entirely away. No test, no nothing.
> 
> Comments?
> 
> (Btw, even on x86, assuming the concept works and the ASM_NOP4 is
> corrected to the right length, we'd need to support older assemblers
> that don't understand the "rdrand" instruction, so it would need to be
> done as a explicit byte sequence).
> 
> Again, TOTALLY UNTESTED. Concept patch only!! There may be seriously
> stupid bugs here, but the point is that it should make it easy for an
> architecture to have a "get a word of random data quickly".
> 

The only minor issue with this is that RDRAND can, at least in theory,
return a failure condition transiently ("the entropy buffer is empty")
or permanently ("the random number generator is broken.")  Although we
have never actually observed the former under anything approaching
realistic conditions, the recommendation is to loop for 10 iterations.

The end result is a small loop, just over 20 bytes long; as a result I
left the implementation as a subroutine instead of inlining it in my v2
patch:

ENTRY(x86_rdrand_long)
        mov     $RDRAND_RETRY_LIMIT, %eax
1:
        .byte 0x48, 0x0f, 0xc7, 0xf2    /* rdrand %rdx */
        jnc     2f
        mov     %rdx, (%rdi)
        ret
2:
        dec     %eax
        rep;nop
        jnz     1b
        ret
ENDPROC(x86_rdrand_long)

We can of course inline this loop with alternatives if you would prefer.
 I'll do a v3 patchset with that implementation later today and we can
check out how it looks.

What makes that more than a bit ugly is that extract_entropy() and
extract_entropy_user() take their randomness type ("perfect/blocking"
versus "PRNG degrade OK/nonblocking") from a pointer to the pool, which
means that some kind of indirection or policy information is going to be
necessary there anyway, in order to enable get_random_bytes() and its
friends -- as opposed to get_random_int().

As such, it seems cleaner to me to take the hit of going through a
function pointer.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
