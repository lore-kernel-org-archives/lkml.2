Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab0GDD6p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 23:58:45 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54992 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab0GDD6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 23:58:43 -0400
Date: Sun, 4 Jul 2010 12:57:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH] arch/tile: updates to hardwall code from community feedback.
Message-ID: <20100704035759.GA5888@linux-sh.org>
References: <201007030217.o632HoK9004030@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007030217.o632HoK9004030@farm-0002.internal.tilera.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 11:45:18AM -0400, Chris Metcalf wrote:
>  #define for_each_hardwall_task_safe(pos, n, head) \
> -	hardwall_for_each_entry_safe(pos, n, head, thread.hardwall_list)
> +	list_for_each_entry_safe(pos, n, head, thread.hardwall_list)
>  
If you've killed off the rest of the wrappers due to them not really
having to do anything special, you could do the same for this one, too.

>  static struct hardwall_info *hardwall_create(
> -	size_t size, const unsigned long __user *bits)
> +	size_t size, const unsigned char __user *bits)
>  {
>  	struct hardwall_info *iter, *rect;
>  	struct cpumask mask;
>  	unsigned long flags;
> -	int rc, cpu, maxcpus = smp_height * smp_width;
> +	int rc;
>  
> -	/* If "size" is not a multiple of long, it's invalid. */
> -	if (size % sizeof(long))
> +	/* Reject crazy sizes out of hand, a la sys_mbind(). */
> +	if (size > PAGE_SIZE)
>  		return ERR_PTR(-EINVAL);
>  
Does it even make any sense to accept > sizeof(struct cpumask) ? Your
case below obviously handles this by making sure the rest of the bits are
zeroed, but that still seems a bit excessive. If anything, the
sizeof(struct cpumask) should be your worst case (or just rejected out of
hand), and you could use cpumask_size() for everything else.

> -	/* Validate that all the bits we are given fit in our coordinates. */
> -	cpumask_clear(&mask);
> -	for (cpu = 0; size > 0; ++bits, size -= sizeof(long)) {
> -		int i;
> -		unsigned long m;
> -		if (get_user(m, bits) != 0)
> -			return ERR_PTR(-EFAULT);
> -		for (i = 0; i < BITS_PER_LONG; ++i, ++cpu)
> -			if (m & (1UL << i)) {
> -				if (cpu >= maxcpus)
> -					return ERR_PTR(-EINVAL);
> -				cpumask_set_cpu(cpu, &mask);
> -			}
> +	/* Copy whatever fits into a cpumask. */
> +	if (copy_from_user(&mask, bits, min(sizeof(struct cpumask), size)))
> +		return ERR_PTR(-EFAULT);
> +
> +	/*
> +	 * If the size was short, clear the rest of the mask;
> +	 * otherwise validate that the rest of the user mask was zero
> +	 * (we don't try hard to be efficient when validating huge masks).
> +	 */
> +	if (size < sizeof(struct cpumask)) {
> +		memset((char *)&mask + size, 0, sizeof(struct cpumask) - size);
> +	} else if (size > sizeof(struct cpumask)) {
> +		size_t i;
> +		for (i = sizeof(struct cpumask); i < size; ++i) {
> +			char c;
> +			if (get_user(c, &bits[i]))
> +				return ERR_PTR(-EFAULT);
> +			if (c)
> +				return ERR_PTR(-EINVAL);
> +		}
>  	}
>  
Surely you can just replace all of this with cpumask_parse_user()?
