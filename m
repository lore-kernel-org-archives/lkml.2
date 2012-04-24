Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab2DXVzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:55:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40406 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab2DXVzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:55:09 -0400
Message-ID: <1335304497.28150.243.camel@twins>
Subject: Re: [RFC][PATCH 2/3] math128: Introduce {mult,add,cmp}_u128
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 24 Apr 2012 23:54:57 +0200
In-Reply-To: <CA+55aFyvBTDh_DkXs6Z6zFmjyYxvWaAEm9-rJDXhvPx8CpDiKA@mail.gmail.com>
References: <20120424161039.293018424@chello.nl>
	 <20120424162224.526249106@chello.nl>
	 <CA+55aFyvBTDh_DkXs6Z6zFmjyYxvWaAEm9-rJDXhvPx8CpDiKA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 12:37 -0700, Linus Torvalds wrote:
> Also, it might be worth looking at code generation, to see if it's
> better to just do
> 
>    a.hi += b.hi;
>    a.low += b.low;
>    if (a.low < b.low)
>       a.hi++;
>    return a;
> 
> because that might make it clear that there are fewer actual values
> live at any particular time. But gcc may not care. Try it.

It does indeed generate tons better code. FWIW, Mans' suggestion of: 
  a.hi += a.lo < b.lo;
horribly confuses gcc.

> Also, for the multiply, please make sure gcc knows to do a "32x32->64"
> multiplication, rather than thinking it needs to do full 64x64
> multiplies..
> 
> I'm not sure gcc understands that as you wrote it.

It does indeed grok it (as Mans also confirmed for ARM), however:

>  You are probably
> better off actually using 32-bit values, and then an explicit cast, ie
> 
>   u32 a32_0 = .. low 32 bits of a ..
>   u32 b32_0 = .. low 32 bits of b ..
>   u64 res64_0 = (u64) a32_0 * (u64) b32_0;
> 
> but if gcc understands it from the shifts and masks, I guess it doesn't matter.

that does generate slightly better code in that it avoids some masks on
64bit:

@@ -7,12 +7,11 @@
 .LFB38:
        .cfi_startproc
        movq    %rdi, %r8
-       movq    %rdi, %rdx
        movq    %rsi, %rcx
+       mov     %edi, %edx
        shrq    $32, %r8
-       andl    $4294967295, %edx
        shrq    $32, %rcx
-       andl    $4294967295, %esi
+       mov     %esi, %esi
        movq    %rcx, %rax
        imulq   %rdx, %rcx
        imulq   %rsi, %rdx



