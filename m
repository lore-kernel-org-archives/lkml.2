Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594Ab0FQSgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 14:36:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44780 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756976Ab0FQSgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 14:36:20 -0400
Message-ID: <4C1A6AE9.2020307@zytor.com>
Date: Thu, 17 Jun 2010 11:35:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
       Mitch Bradley <wmb@laptop.org>
Subject: Re: [PATCH] x86: OLPC: add support for calling into OpenFirmware
 (v4)
References: <20100616223220.326bee18@dev.queued.net>
In-Reply-To: <20100616223220.326bee18@dev.queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 07:32 PM, Andres Salomon wrote:
> 
> Add support for saving OFW's cif, and later calling into it to run OFW
> commands.  OFW remains resident in memory, living within virtual range
> 0xff800000 - 0xffc00000.  A single page directory entry points to the
> pgdir that OFW actually uses, so rather than saving the entire page
> table, we grab and install that one entry permanently in the kernel's
> page table.
> 
> This is currently only used by the OLPC XO.
> 

OK, down to the nitpick level...

> +
> +/* page dir entry containing OFW's pgdir table; filled in by head_32.S */
> +pgd_t *olpc_ofw_pgd __initdata;
> +

This is a physical address, not a pointer.  As such it should be
physaddr_t or u32.

> +static DEFINE_SPINLOCK(ofw_lock);
> +
> +#define MAXARGS 10
> +
> +void __init setup_olpc_ofw_pgd(void)
> +{
> +	pgd_t *base, *pde, *ofw_pde;
> +
> +	if (!olpc_ofw_cif)
> +		return;
> +
> +	/* fetch the kernel's current PDE */
> +	base = __va(read_cr3());
> +	pde = &base[OLPC_OFW_PDE_NR];
> +

Since you're touching this so early, you already know that you're
manipulating swapper_pg_dir.  If you *didn't* know that, the above code
would be wrong, since the change you're about to make wouldn't propagate
to other kernel tasks.

So just use swapper_pg_dir[OLPC_OFW_PDE_NR] directly.

	-hpa
