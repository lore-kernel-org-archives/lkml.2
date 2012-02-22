Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab2BVJrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:47:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53425 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab2BVJrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:47:43 -0500
Date: Wed, 22 Feb 2012 10:47:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>
Subject: Re: [PATCH 1/3] uprobes/core: Make instruction tables volatile.
Message-ID: <20120222094710.GA31848@elte.hu>
References: <20120222091535.15880.12502.sendpatchset@srdronam.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222091535.15880.12502.sendpatchset@srdronam.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
> Some versions of gcc spits a warning about the asm operand for test_bit and
> also causes the first long of the instruction table to be output.
> 
> Fix is similar to 7115e3fc on arch/x86/kernel/kprobes.c
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/uprobes.c |   61 ++++++++++++++++++++++++---------------------
>  1 files changed, 32 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index cf2a184..13d616d 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -53,34 +53,12 @@
>  	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
>  	 << (row % 32))
>  
> -#ifdef CONFIG_X86_64
> -static u32 good_insns_64[256 / 32] = {
> -	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
> -	/*      ----------------------------------------------         */
> -	W(0x00, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) | /* 00 */
> -	W(0x10, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) , /* 10 */
> -	W(0x20, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) | /* 20 */
> -	W(0x30, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) , /* 30 */
> -	W(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 40 */
> -	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 50 */
> -	W(0x60, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 60 */
> -	W(0x70, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 70 */
> -	W(0x80, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 80 */
> -	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 90 */
> -	W(0xa0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* a0 */
> -	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* b0 */
> -	W(0xc0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0) | /* c0 */
> -	W(0xd0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
> -	W(0xe0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* e0 */
> -	W(0xf0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1)   /* f0 */
> -	/*      ----------------------------------------------         */
> -	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
> -};
> -#endif
> -
> -/* Good-instruction tables for 32-bit apps */
> -
> -static u32 good_insns_32[256 / 32] = {
> +/*
> + * Good-instruction tables for 32-bit apps.  This is non-const and volatile
> + * to keep gcc from statically optimizing it out, as variable_test_bit makes
> + * some versions of gcc to think only *(unsigned long*) is used.
> + */
> +static volatile u32 good_insns_32[256 / 32] = {
>  	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
>  	/*      ----------------------------------------------         */
>  	W(0x00, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0) | /* 00 */
> @@ -104,7 +82,7 @@ static u32 good_insns_32[256 / 32] = {
>  };
>  
>  /* Using this for both 64-bit and 32-bit apps */
> -static u32 good_2byte_insns[256 / 32] = {
> +static volatile u32 good_2byte_insns[256 / 32] = {
>  	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
>  	/*      ----------------------------------------------         */
>  	W(0x00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1) | /* 00 */
> @@ -127,6 +105,31 @@ static u32 good_2byte_insns[256 / 32] = {
>  	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
>  };
>  
> +#ifdef CONFIG_X86_64
> +/* Good-instruction tables for 64-bit apps */
> +static volatile u32 good_insns_64[256 / 32] = {
> +	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
> +	/*      ----------------------------------------------         */
> +	W(0x00, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) | /* 00 */
> +	W(0x10, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) , /* 10 */
> +	W(0x20, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) | /* 20 */
> +	W(0x30, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) , /* 30 */
> +	W(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 40 */
> +	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 50 */
> +	W(0x60, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 60 */
> +	W(0x70, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 70 */
> +	W(0x80, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 80 */
> +	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 90 */
> +	W(0xa0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* a0 */
> +	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* b0 */
> +	W(0xc0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0) | /* c0 */
> +	W(0xd0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
> +	W(0xe0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* e0 */
> +	W(0xf0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1)   /* f0 */
> +	/*      ----------------------------------------------         */
> +	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
> +};
> +#endif

Hm, why was the table moved around? This makes it hard to see 
whether it's just a single volatile that is added, or something 
more.

Thanks,

	Ingo
