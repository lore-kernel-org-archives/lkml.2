Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab0K1Wkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 17:40:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:32970 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab0K1Wke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 17:40:34 -0500
Date: Sun, 28 Nov 2010 23:40:24 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] kthread: NUMA aware kthread_create_on_cpu()
Message-ID: <20101128224024.GA12300@basil.fritz.box>
References: <1290972833.29196.90.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290972833.29196.90.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, Nov 28, 2010 at 08:33:53PM +0100, Eric Dumazet wrote:
> @@ -101,7 +103,15 @@ static int kthread(void *_create)
>  static void create_kthread(struct kthread_create_info *create)
>  {
>  	int pid;
> -
> +	static int last_cpu_pref = -1;
> +
> +	if (create->cpu != last_cpu_pref) {

Is that actually thread-safe?

> +void numa_cpubind_policy(int cpu)
> +{
> +	nodemask_t mask;
> +
> +	init_nodemask_of_node(&mask, cpu_to_node(cpu));
> +	do_set_mempolicy(MPOL_BIND, 0, &mask);

You don't want bind, you want preferred, otherwise this
will explode if the node is empty.

Also this messes up the policy of the caller process. You really
need to save/restore it.

And if the slab is configured for slab interleaving in
the cpuset this will be ignored I think.

Also I think the slab fast path ignores the policy anyways,
the policy only acts when slab has to grab new pages.
Are you sure this works at all?

It would be probably better to pass through the node
to the low level allocation functions and use them
there directly.

Problem is that this ends up in architecture specific code
for the stack, so may be a larger patch.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
