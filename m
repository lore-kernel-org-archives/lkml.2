Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab0JEWbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 18:31:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57717 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027Ab0JEWbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 18:31:05 -0400
Message-ID: <4CABA6E5.6030601@zytor.com>
Date: Tue, 05 Oct 2010 15:29:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Vivek Goyal <vgoyal@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: Re: [PATCH 2/4] x86, memblock: Fix crashkernel allocation
References: <4CAA4BD5.4020505@kernel.org> <4CAA4DE2.1020406@kernel.org>
In-Reply-To: <4CAA4DE2.1020406@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 02:57 PM, Yinghai Lu wrote:
>
> +#define DEFAULT_BZIMAGE_ADDR_MAX 0x37FFFFFF
>  static void __init reserve_crashkernel(void)
>  {
>  	unsigned long long total_mem;
> @@ -518,17 +519,28 @@ static void __init reserve_crashkernel(v
>  	if (crash_base <= 0) {
>  		const unsigned long long alignment = 16<<20;	/* 16M */
>  
> -		crash_base = memblock_find_in_range(alignment, ULONG_MAX, crash_size,
> -				 alignment);
> +		/*
> +		 * Assume half crash_size is for bzImage
> +		 *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
> +		 */
> +		crash_base = memblock_find_in_range(alignment,
> +				DEFAULT_BZIMAGE_ADDR_MAX + crash_size/2,
> +				crash_size, alignment);
> +
>  		if (crash_base == MEMBLOCK_ERROR) {
> -			pr_info("crashkernel reservation failed - No suitable area found.\n");
> -			return;
> +			crash_base = memblock_find_in_range(alignment,
> +					 ULONG_MAX, crash_size, alignment);
> +
> +			if (crash_base == MEMBLOCK_ERROR) {
> +				pr_info("crashkernel reservation failed - No suitable area found.\n");
> +				return;
> +			}
>  		}
>  

Okay, this *really* doesn't make sense.

It's bad enough that kexec doesn't know what memory is safe for it, but
why the heck the heuristic that "half is for bzImage and the rest can go
beyond the heuristic limit"?  Can't we at least simply cap the region to
the default, unless the kexec system has passed in some knowable
alternative?  Furthermore, why bother having the "fallback" at all
(certainly without having a message!?)  If we don't get the memory area
we need we're likely to randomly fail anyway.

Let me be completely clear -- it's obvious from all of this that kexec
is fundamentally broken by design: if kexec can't communicate the safe
memory to use it's busted seven ways to Sunday and it needs to be fixed.
 However, in the meantime I can see capping the memory available to it
as a temporary band-aid, but a fallback to picking random memory is
nuts, especially on the motivation that "a future kexec version might be
able to use it."  If so, the "future kexec tools" should SAY SO.

This is beyond crazy -- it's complete and total bonkers.

	-hpa
