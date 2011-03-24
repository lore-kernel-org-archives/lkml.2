Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab1CXSWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:22:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49378 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab1CXSWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aIIB0flttNU6c2Kt/OktyxD2W3Trlqco2t1FjL4P5KpY6Zsoe9hIFHvDrSHM+b1aSa
         Ed0gQgHRgm/UallN9/79LP/md0TYy31oBxokmTMa49M+GecM4hv8A2IbcKJkP+8WBo4h
         PoflpmldDo/VTagcU0F92UVDF/3aqLKp2VxU8=
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1103241312280.32226@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
	 <20110324142146.GA11682@elte.hu>
	 <alpine.DEB.2.00.1103240940570.32226@router.home>
	 <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
	 <20110324172653.GA28507@elte.hu>
	 <alpine.DEB.2.00.1103241242450.32226@router.home>
	 <AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com>
	 <alpine.DEB.2.00.1103241300420.32226@router.home>
	 <AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com>
	 <alpine.DEB.2.00.1103241312280.32226@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 19:20:53 +0100
Message-ID: <1300990853.3747.189.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 mars 2011 à 13:15 -0500, Christoph Lameter a écrit :

> But then we would get the bug in kmem_cache_alloc() and not in the
> *_emu() function. So the _emu is executing but failing on Ingo's system
> but not on mine. Question is why.
> 
> For some reason the first reference to %gs:(%rsi) wont work right on his
> system:
> 
> From arch/x86/lib/cmpxchg16b_emu
> 
> #
> # Emulate 'cmpxchg16b %gs:(%rsi)' except we return the result in %al not
> # via the ZF.  Caller will access %al to get result.
> #
> # Note that this is only useful for a cpuops operation.  Meaning that we
> # do *not* have a fully atomic operation but just an operation that is
> # *atomic* on a single cpu (as provided by the this_cpu_xx class of
> # macros).
> #
> this_cpu_cmpxchg16b_emu:
>         pushf
>         cli
> 
>         cmpq %gs:(%rsi), %rax
>         jne not_same
>         cmpq %gs:8(%rsi), %rdx
>         jne not_same
> 
>         movq %rbx, %gs:(%rsi)
>         movq %rcx, %gs:8(%rsi)
> 
>         popf
>         mov $1, %al
>         ret
> 
>  not_same:
>         popf
>         xor %al,%al
>         ret
> 
> CFI_ENDPROC

Random guess

Masking interrupts, and accessing vmalloc() based memory for the first
time ?




