Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0KMNHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 08:07:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58606 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab0KMNHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 08:07:48 -0500
Date: Sat, 13 Nov 2010 13:07:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: memblock: convert reserve_crashkernel() to
	use memblock
Message-ID: <20101113130700.GA26105@n2100.arm.linux.org.uk>
References: <cover.1289292124.git.mika.westerberg@iki.fi> <07f23b6e32b1ee64287dc53803890052df6546f3.1289292124.git.mika.westerberg@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07f23b6e32b1ee64287dc53803890052df6546f3.1289292124.git.mika.westerberg@iki.fi>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 11:06:13AM +0200, Mika Westerberg wrote:
>  static void __init reserve_crashkernel(void)
>  {
>  	unsigned long long crash_size, crash_base;
> -	unsigned long long total_mem;
>  	int ret;
>  
> -	total_mem = get_total_mem();
> -	ret = parse_crashkernel(boot_command_line, total_mem,
> +	/* this is necessary because of memblock_phys_mem_size() */
> +	memblock_analyze();

I think you need to check with the memblock people whether its legal to
call memblock_analyze() multiple times.  What do other arches do for
this?

Secondly, when paging_init() returns, bootmem has been initialized, and
memory taken from bootmem to feed the zone allocators.  This memory is
not registered back into memblock.  Allocations from memblock after
paging_init() has returned will lead to overlaps with bootmem, and
therefore corruption.

So, this code is better off left as-is, rather than trying to convert it
to what mistakenly appears "the latest thing".
