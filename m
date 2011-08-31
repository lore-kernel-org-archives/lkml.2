Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751000Ab1HaELi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 00:11:38 -0400
Received: from ozlabs.org ([203.10.76.45]:37608 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab1HaELh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 00:11:37 -0400
Date: Wed, 31 Aug 2011 14:11:34 +1000
From: Anton Blanchard <anton@samba.org>
To: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Milton Miller <miltonm@bga.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC PATCH 02/10] fadump: Reserve the memory for firmware
 assisted dump.
Message-ID: <20110831141134.590c4f4e@kryten>
In-Reply-To: <20110713180648.6210.39530.stgit@mars.in.ibm.com>
References: <20110713180252.6210.34810.stgit@mars.in.ibm.com>
	<20110713180648.6210.39530.stgit@mars.in.ibm.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Mahesh,

Just a few comments.

> +#define RMR_START	0x0
> +#define RMR_END		(0x1UL << 28)	/* 256 MB */

What if the RMO is bigger than 256MB? Should we be using ppc64_rma_size?

> +#ifdef DEBUG
> +#define PREFIX		"fadump: "
> +#define DBG(fmt...)	printk(KERN_ERR PREFIX fmt)
> +#else
> +#define DBG(fmt...)
> +#endif

We should use the standard debug macros (pr_debug etc).

> +/* Global variable to hold firmware assisted dump configuration info. */
> +static struct fw_dump fw_dump;

You can remove this comment, especially because the variable isn't global :)

> +	sections = of_get_flat_dt_prop(node, "ibm,configure-kernel-dump-sizes",
> +					NULL);
> +
> +	if (!sections)
> +		return 0;
> +
> +	for (i = 0; i < FW_DUMP_NUM_SECTIONS; i++) {
> +		switch (sections[i].dump_section) {
> +		case FADUMP_CPU_STATE_DATA:
> +			fw_dump.cpu_state_data_size =
> sections[i].section_size;
> +			break;
> +		case FADUMP_HPTE_REGION:
> +			fw_dump.hpte_region_size =
> sections[i].section_size;
> +			break;
> +		}
> +	}
> +	return 1;
> +}

This makes me a bit nervous. We should really get the size of the property
and use it to iterate through the array. I saw no requirement in the PAPR
that the array had to be 2 entries long.

> +static inline unsigned long calculate_reserve_size(void)
> +{
> +	unsigned long size;
> +
> +	/* divide by 20 to get 5% of value */
> +	size = memblock_end_of_DRAM();
> +	do_div(size, 20);
> +
> +	/* round it down in multiples of 256 */
> +	size = size & ~0x0FFFFFFFUL;
> +
> +	/* Truncate to memory_limit. We don't want to over reserve
> the memory.*/
> +	if (memory_limit && size > memory_limit)
> +		size = memory_limit;
> +
> +	return (size > RMR_END ? size : RMR_END);
> +}

5% is pretty aribitrary, that's 400GB on an 8TB box. Also our experience
with kdump is that 256MB is too small. Is there any reason to scale it
with memory size? Can we do what kdump does and set it to a single
value (eg 512MB)?

We could override the default with a boot option, which is similar to
how kdump specifies the region to reserve.

Anton
