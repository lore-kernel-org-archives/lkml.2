Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab2KUHqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:46:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2KUHqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:46:20 -0500
Date: Tue, 20 Nov 2012 23:46:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v6 1/4] genalloc: add a global pool list, allow to find
 pools by phys address
Message-Id: <20121120234613.47d8183c.akpm@linux-foundation.org>
In-Reply-To: <1353061817-3207-2-git-send-email-p.zabel@pengutronix.de>
References: <1353061817-3207-1-git-send-email-p.zabel@pengutronix.de>
	<1353061817-3207-2-git-send-email-p.zabel@pengutronix.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012 11:30:14 +0100 Philipp Zabel <p.zabel@pengutronix.de> wrote:

> This patch keeps all created pools in a global list and adds two
> functions that allow to retrieve the gen_pool pointer from a known
> physical address and from a device tree node.
>
> ...
>
> +/*
> + * gen_pool_find_by_phys - find a pool by physical start address
> + * @phys: physical address as added with gen_pool_add_virt
> + *
> + * Returns the pool that contains the chunk starting at phys,
> + * or NULL if not found.
> + */
> +struct gen_pool *gen_pool_find_by_phys(phys_addr_t phys)
> +{
> +	struct gen_pool *pool, *found = NULL;
> +	struct gen_pool_chunk *chunk;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(pool, &pools, next_pool) {
> +		list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk) {
> +			if (phys == chunk->phys_addr) {
> +				found = pool;
> +				break;
> +			}
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	return found;
> +}
> +EXPORT_SYMBOL_GPL(gen_pool_find_by_phys);

It is rather pointless to use the fancy super-fast RCU locking
around a linear search!  We have various data structures which can be
used to make this search much more efficient.  radix-tree is one, if
the search keys are unique (which is the case here).

Secondly, that whole "phys" concept doesn't need to be in there.  It
would be better to implement a far more general
gen_pool_find_by_key(unsigned long key) and then do the phys->ulong
specialization elsewhere.

Finally the changelog gives no indication *why* you feel the kernel
needs this feature.  What is it for?  What are the use cases?  This is
the most important information for reviewers, hence it should be up
there front and center, in lavish detail.

Because once this is understood:

a) people might be able to suggest alternatives.  Can't do that
   without the required info and

b) people might then be interested in merging the patch into a kernel!

> +#ifdef CONFIG_OF
> +/**
> + * of_get_named_gen_pool - find a pool by phandle property
> + * @np: device node
> + * @propname: property name containing phandle(s)
> + * @index: index into the phandle array
> + *
> + * Returns the pool that contains the chunk starting at the physical
> + * address of the device tree node pointed at by the phandle property,
> + * or NULL if not found.
> + */
> +struct gen_pool *of_get_named_gen_pool(struct device_node *np,
> +	const char *propname, int index)
> +{
> +	struct device_node *np_pool;
> +	struct resource res;
> +	int ret;
> +
> +	np_pool = of_parse_phandle(np, propname, index);
> +	if (!np_pool)
> +		return NULL;
> +	ret = of_address_to_resource(np_pool, 0, &res);
> +	if (ret < 0)
> +		return NULL;
> +	return gen_pool_find_by_phys((phys_addr_t) res.start);
> +}
> +EXPORT_SYMBOL_GPL(of_get_named_gen_pool);

Seems rather inappropriate that this should be in lib/genpool.c. 
Put it somewhere such as drivers/of/base.c, perhaps.

