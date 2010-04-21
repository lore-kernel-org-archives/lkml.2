Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab0DUM7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 08:59:53 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:45614 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab0DUM7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:59:50 -0400
Subject: Re: [PATCH linux-next 1/2] irq: Add CPU mask affinity hint
 callback framework
From: Ben Hutchings <bhutchings@solarflare.com>
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: tglx@linutronix.de, davem@davemloft.net, arjan@linux.jf.intel.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100420180112.1276.11906.stgit@ppwaskie-hc2.jf.intel.com>
References: <20100420180112.1276.11906.stgit@ppwaskie-hc2.jf.intel.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Wed, 21 Apr 2010 13:59:45 +0100
Message-Id: <1271854785.2101.17.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Apr 2010 13:00:26.0434 (UTC) FILETIME=[9C994A20:01CAE152]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17332.005
X-TM-AS-Result: No--25.545400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 11:01 -0700, Peter P Waskiewicz Jr wrote:
> This patch adds a callback function pointer to the irq_desc
> structure, along with a registration function and a read-only
> proc entry for each interrupt.
> 
> This affinity_hint handle for each interrupt can be used by
> underlying drivers that need a better mechanism to control
> interrupt affinity.  The underlying driver can register a
> callback for the interrupt, which will allow the driver to
> provide the CPU mask for the interrupt to anything that
> requests it.  The intent is to extend the userspace daemon,
> irqbalance, to help hint to it a preferred CPU mask to balance
> the interrupt into.

Doesn't it make more sense to have the driver follow affinity decisions
made from user-space?  I realise that reallocating queues is disruptive
and we probably don't want irqbalance to trigger that, but there should
be a mechanism for the administrator to trigger it.

Looking at your patch for ixgbe:

[...]
> diff --git a/drivers/net/ixgbe/ixgbe_main.c
> b/drivers/net/ixgbe/ixgbe_main.c
> index 1b1419c..3e00d41 100644
> --- a/drivers/net/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ixgbe/ixgbe_main.c
[...]
> @@ -1083,6 +1113,16 @@ static void ixgbe_configure_msix(struct ixgbe_adapter *adapter)
>                         q_vector->eitr = adapter->rx_eitr_param;
>  
>                 ixgbe_write_eitr(q_vector);
> +
> +               /*
> +                * Allocate the affinity_hint cpumask, assign the mask for
> +                * this vector, and register our affinity_hint callback.
> +                */
> +               alloc_cpumask_var(&q_vector->affinity_mask, GFP_KERNEL);
> +               cpumask_set_cpu(v_idx, q_vector->affinity_mask);
> +               irq_register_affinity_hint(adapter->msix_entries[v_idx].vector,
> +                                          adapter,
> +                                          &ixgbe_irq_affinity_callback);
>         }
>  
>         if (adapter->hw.mac.type == ixgbe_mac_82598EB)
[...]

This just assigns IRQs to the first n CPU threads.  Depending on the
enumeration order, this might result in assigning an IRQ to each of 2
threads on a core while leaving other cores unused!

irqbalance can already find the various IRQs associated with a single
net device by looking at the handler names.  So it can do at least as
well as this without such a hint.  Unless drivers have *useful* hints to
give, I don't see the point in adding this mechanism.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

