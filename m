Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2FJCTQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 22:19:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47517 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2FJCTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 22:19:15 -0400
Date: Sat, 9 Jun 2012 19:19:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Mackey <tdmackey@twitter.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>, penberg@kernel.org, cl@linux.com
Subject: Re: [PATCH v5] slab/mempolicy: always use local policy from interrupt
 context
In-Reply-To: <1339234803-21106-1-git-send-email-tdmackey@twitter.com>
Message-ID: <alpine.DEB.2.00.1206091917580.7832@chino.kir.corp.google.com>
References: <1338438844-5022-1-git-send-email-andi@firstfloor.org> <1339234803-21106-1-git-send-email-tdmackey@twitter.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2012, David Mackey wrote:

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index f15c1b2..cb0b230 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1602,8 +1602,14 @@ static unsigned interleave_nodes(struct mempolicy *policy)
>   * task can change it's policy.  The system default policy requires no
>   * such protection.
>   */
> -unsigned slab_node(struct mempolicy *policy)
> +unsigned slab_node(void)
>  {
> +	struct mempolicy *policy;
> +
> +	if (in_interrupt())
> +		return numa_node_id();
> +
> +	policy = current->mempolicy;
>  	if (!policy || policy->flags & MPOL_F_LOCAL)
>  		return numa_node_id();
>  

Should probably be numa_mem_id() in both these cases for 
CONFIG_HAVE_MEMORYLESS_NODES, but it won't cause a problem in this form 
either.

Acked-by: David Rientjes <rientjes@google.com>
