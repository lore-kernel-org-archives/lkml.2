Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab0JMIQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:16:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40638 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab0JMIQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:16:32 -0400
Date: Wed, 13 Oct 2010 10:16:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "hpa@zytor.com" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [patch]x86: spread tlb flush vector between nodes
Message-ID: <20101013081629.GA1621@basil.fritz.box>
References: <1286955698.13317.5.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286955698.13317.5.camel@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 03:41:38PM +0800, Shaohua Li wrote:

Hi Shaohua,

> Currently flush tlb vector allocation is based on below equation:
> 	sender = smp_processor_id() % 8
> This isn't optimal, CPUs from different node can have the same vector, this
> causes a lot of lock contention. Instead, we can assign the same vectors to
> CPUs from the same node, while different node has different vectors. This has
> below advantages:
> a. if there is lock contention, the lock contention is between CPUs from one
> node. This should be much cheaper than the contention between nodes.
> b. completely avoid lock contention between nodes. This especially benefits
> kswapd, which is the biggest user of tlb flush, since kswapd sets its affinity
> to specific node.

The original scheme with 8 vectors was designed when Linux didn't have
per CPU interrupt numbers yet, and interrupts vectors were a scarce resource.

Now that we have per CPU interrupts and there is no immediate danger 
of running out I think it's better to use more than 8 vectors for the TLB 
flushes.

Perhaps could use 32 vectors or so and give each node on a 8S 
system 4 slots and on a 4 node system 8 slots?


> In my test, this could reduce > 20% CPU overhead in extreme case.

Nice result.


> +
> +static int tlb_cpuhp_notify(struct notifier_block *n,
> +		unsigned long action, void *hcpu)
> +{
> +	switch (action & 0xf) {
> +	case CPU_ONLINE:
> +	case CPU_DEAD:
> +		calculate_tlb_offset();
> +	}
> +	return NOTIFY_OK;

I don't think we really need the complexity of a notifier here.
In most x86 setups possible is very similar to online.

So I would suggest simply to compute a static mapping at boot
and simplify the code.

In theory there is a slight danger of node<->CPU numbers
changing with consecutive hot plug actions, but right now
this should not happen anyways and it would be unlikely
later.

-Andi
