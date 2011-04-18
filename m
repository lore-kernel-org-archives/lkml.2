Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1DRXbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 19:31:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52081 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1DRXbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 19:31:19 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=bx74Hp8RJ4sA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=UCXm4OdGIi-FydrpeHgA:9 a=iVFgviD7D8ckdUNLUvYA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/3] x86, cpu: Clean up and unify the NOP selection
 infrastructure
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, tglx@linutronix.de,
        mingo@elte.hu, Tejun Heo <tj@kernel.org>
In-Reply-To: <1303166160-10315-3-git-send-email-hpa@linux.intel.com>
References: <1303166160-10315-1-git-send-email-hpa@linux.intel.com>
	 <1303166160-10315-3-git-send-email-hpa@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 18 Apr 2011 19:31:15 -0400
Message-ID: <1303169476.7181.71.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 15:35 -0700, H. Peter Anvin wrote:

>  #endif /* _ASM_X86_NOPS_H */
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 4a23467..2ca3f65 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -68,16 +68,20 @@ __setup("noreplace-paravirt", setup_noreplace_paravirt);
>  	printk(KERN_DEBUG fmt, args)
>  
>  #if defined(GENERIC_NOP1) && !defined(CONFIG_X86_64)
> -/* Use inline assembly to define this because the nops are defined
> -   as inline assembly strings in the include files and we cannot
> -   get them easily into strings. */
> -asm("\t" __stringify(__INITRODATA_OR_MODULE) "\nintelnops: "
> -	GENERIC_NOP1 GENERIC_NOP2 GENERIC_NOP3 GENERIC_NOP4 GENERIC_NOP5 GENERIC_NOP6
> -	GENERIC_NOP7 GENERIC_NOP8
> -    "\t.previous");
> -extern const unsigned char intelnops[];

Can we please add a comment to this. The original (above) was confusing
enough, but at least it used asm() so it wasn't that bad to figure out.
Or at least the asm() usage would trigger in one's mind to think "Damn!
They chose to use 'asm', it must be some kind of nasty trick. Let's take
a better look at WTF they are doing!".

Now the use a normal character array actual makes this even more subtle.
What about adding:

/*
 * Each GENERIC_NOPX is of X bytes, and defined as an array of bytes
 * that correspond to that nop. Getting from one nop to the next, we
 * add to the array the offset that is equal to the sum of all sizes of 
 * nops preceding the one we are after.
 *
 * Note: The GENERIC_NOP5_ATOMIC is at the end, as it breaks the
 * nice symmetry of sizes of the previous nops.
 */

-- Steve
 
> +static const unsigned char  __initconst_or_module intelnops[] =
> +{
> +	GENERIC_NOP1,
> +	GENERIC_NOP2,
> +	GENERIC_NOP3,
> +	GENERIC_NOP4,
> +	GENERIC_NOP5,
> +	GENERIC_NOP6,
> +	GENERIC_NOP7,
> +	GENERIC_NOP8,
> +	GENERIC_NOP5_ATOMIC
> +};
>  static const unsigned char *const __initconst_or_module
> -intel_nops[ASM_NOP_MAX+1] = {
> +intel_nops[ASM_NOP_MAX+2] = {
>  	NULL,
>  	intelnops,
>  	intelnops + 1,
> @@ -87,17 +91,25 @@ intel_nops[ASM_NOP_MAX+1] = {
>  	intelnops + 1 + 2 + 3 + 4 + 5,
>  	intelnops + 1 + 2 + 3 + 4 + 5 + 6,
>  	intelnops + 1 + 2 + 3 + 4 + 5 + 6 + 7,
> +	intelnops + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8,
>  };
>  #endif


