Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab1FVTkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:40:20 -0400
Received: from claw.goop.org ([74.207.240.146]:57826 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758080Ab1FVTkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:40:19 -0400
Message-ID: <4E0240AC.9060603@goop.org>
Date: Wed, 22 Jun 2011 12:21:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC 0/7] x86: convert ticketlocks to C and remove duplicate
 code
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com> <1308664868.26237.173.camel@twins>
In-Reply-To: <1308664868.26237.173.camel@twins>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2011 07:01 AM, Peter Zijlstra wrote:
> One other thing you could contemplate is adding something like:
>
> #define xadd(ptr, inc)							\
> do {									\
> 	switch(sizeof(*(ptr))) {					\
> 	case 1:								\
> 		asm volatile (LOCK_PREFIX "xaddb %0, %1\n"		\
>                              : "+r" (inc), "+m" (*(ptr))		\
>                              : : "memory", "cc");			\
> 	case 2:
> 		... xaddw ...
> 	case 4:
> 		... xaddl ...
> } while (0)
>
> and a similar something for inc. For both there seem to be various asm
> bits left (we could even consider adding xadd to
> arch/x86/include/asm/cmpxchg*.h).

A friend just pointed out that gcc has a "__sync_fetch_and_add()"
intrinsic, which compiles to xadd when used in this context.  What's the
general feeling about using these kinds of gcc features?

It also has __sync_bool_compare_and_swap(), which would simplify a lot
of asm/cmpxchg.h...

    J
