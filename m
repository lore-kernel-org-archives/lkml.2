Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1HWLAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 07:00:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38969 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab1HWLAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 07:00:09 -0400
Subject: Re: [PATCH 07/15] x86: add xadd helper macro
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Tue, 23 Aug 2011 12:59:32 +0200
In-Reply-To: <41c1484d36a94613f86f33e15219d5fcd14b2343.1314054734.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com>
	 <41c1484d36a94613f86f33e15219d5fcd14b2343.1314054734.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314097172.8002.30.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



What you could do is something like:

#define CASE_B	case 1
#define CASE_W	case 2
#define CASE_L	case 4
#ifdef CONFIG_64BIT
# define CASE_Q	case 8
#else
# define CASE_Q case -1 /* sizeof() won't ever return this */
#endif


> +#define xadd(ptr, inc)                                                 \
> +       do {                                                            \
> +               switch (sizeof(*(ptr))) {                               \
                 CASE_B:                                                 \
> +                       asm volatile (LOCK_PREFIX "xaddb %b0, %1\n"     \
> +                                     : "+r" (inc), "+m" (*(ptr))       \
> +                                     : : "memory", "cc");              \
> +                       break;                                          \
		 CASE_W:                                                 \
> +                       asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"     \
> +                                     : "+r" (inc), "+m" (*(ptr))       \
> +                                     : : "memory", "cc");              \
> +                       break;                                          \
                 CASE_L:                                                 \
> +                       asm volatile (LOCK_PREFIX "xaddl %0, %1\n"      \
> +                                     : "+r" (inc), "+m" (*(ptr))       \
> +                                     : : "memory", "cc");              \
> +                       break;                                          \
                 CASE_Q:                                                 \
> +                       asm volatile (LOCK_PREFIX "xaddq %q0, %1\n"     \
> +                                     : "+r" (inc), "+m" (*(ptr))       \
> +                                     : : "memory", "cc");              \
> +                       break;                                          \
		 default:						 \
			 __xadd_wrong_size();				 \
> +               }                                                       \
> +       } while(0) 


