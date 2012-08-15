Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab2HOW4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 18:56:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2HOW4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 18:56:07 -0400
Date: Wed, 15 Aug 2012 15:56:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SGI XPC fails to load when cpu 0 is out of IRQ
 resources.
Message-Id: <20120815155605.cf02ef7b.akpm@linux-foundation.org>
In-Reply-To: <20120803194628.GN3093@sgi.com>
References: <20120803194628.GN3093@sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2012 14:46:29 -0500
Robin Holt <holt@sgi.com> wrote:

> On many of our larger systems, CPU 0 has had all of its IRQ resources
> consumed before XPC loads.  Worse cases on machines with multiple
> 10 GigE cards and multiple IB cards have depleted the entire first
> socket of IRQs.  That patch makes selecting the node upon which
> IRQs are allocated (as well as all the other GRU Message Queue
> structures) specifiable as a module load param and has a default
> behavior of searching all nodes/cpus for an available resource.
> 

Is this problem serious enough to warrant a -stable backport?  If you
want it to appear in vendor kernels then I guess "yes".

> +static int
> +xpc_init_mq_node(int nid)
> +{
> +	int cpu;
> +
> +	for_each_cpu(cpu, cpumask_of_node(nid)) {
> +		xpc_activate_mq_uv = xpc_create_gru_mq_uv(XPC_ACTIVATE_MQ_SIZE_UV, nid,
> +							  XPC_ACTIVATE_IRQ_NAME,
> +							  xpc_handle_activate_IRQ_uv);
> +		if (!IS_ERR(xpc_activate_mq_uv))
> +			break;
> +	}
> +	if (IS_ERR(xpc_activate_mq_uv))
> +		return PTR_ERR(xpc_activate_mq_uv);
> +
> +	for_each_cpu(cpu, cpumask_of_node(nid)) {
> +		xpc_notify_mq_uv = xpc_create_gru_mq_uv(XPC_NOTIFY_MQ_SIZE_UV, nid,
> +							XPC_NOTIFY_IRQ_NAME,
> +							xpc_handle_notify_IRQ_uv);
> +		if (!IS_ERR(xpc_notify_mq_uv))
> +			break;
> +	}
> +	if (IS_ERR(xpc_notify_mq_uv)) {
> +		xpc_destroy_gru_mq_uv(xpc_activate_mq_uv);
> +		return PTR_ERR(xpc_notify_mq_uv);
> +	}
> +
> +	return 0;
> +}

This seems to take the optimistic approach to CPU hotplug ;)
get_online_cpus(), perhaps?

