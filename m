Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1H3LkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:40:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab1H3LkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:40:00 -0400
Message-ID: <4E5CCC0B.2010900@redhat.com>
Date: Tue, 30 Aug 2011 14:39:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Duncan Sands <baldrick@free.fr>
CC: Zachary Amsden <zamsden@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH x86 kvm] Fix register corruption in pvclock_scale_delta
References: <4E5CA62E.8060304@free.fr>
In-Reply-To: <4E5CA62E.8060304@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 11:58 AM, Duncan Sands wrote:
> Hi Zachary, this patch can cause a compile failure if the compiler 
> chooses to
> use a memory location for mul_frac rather than a register (as allowed 
> by the
> "m" in the constraints):
>
>   pvclock.s:229: Error: no instruction mnemonic suffix given and no 
> register operands; can't size instruction
>
> In this example the assembler is:
>
>         #APP
>         mul -48(%rbp) ; shrd $32, %rdx, %rax
>         #NO_APP
>
> A simple solution is to use mulq, as in the following patch:
>
> Signed-off-by: Duncan Sands <baldrick@free.fr>
>
> --- a/arch/x86/include/asm/pvclock.h
> +++ b/arch/x86/include/asm/pvclock.h
> @@ -44,7 +44,7 @@ static inline u64 pvclock_scale_delta(u64 delta, u32 
> mul_frac, int shift)
>                 : "a" ((u32)delta), "1" ((u32)(delta >> 32)), "2" 
> (mul_frac) );
>  #elif defined(__x86_64__)
>         __asm__ (
> -               "mul %[mul_frac] ; shrd $32, %[hi], %[lo]"
> +               "mulq %[mul_frac] ; shrd $32, %[hi], %[lo]"
>                 : [lo]"=a"(product),
>                   [hi]"=d"(tmp)
>                 : "0"(delta),

Thanks, applied.

-- 
error compiling committee.c: too many arguments to function

