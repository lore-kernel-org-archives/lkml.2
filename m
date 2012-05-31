Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab2EaUpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:45:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51751 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab2EaUpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:45:15 -0400
Date: Thu, 31 May 2012 13:45:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        penberg@kernel.org, cl@linux.com
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context v3
In-Reply-To: <1338438844-5022-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1205311342320.2764@chino.kir.corp.google.com>
References: <1338438844-5022-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, Andi Kleen wrote:

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index cfb6c86..b65eb06 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1586,9 +1586,11 @@ static unsigned interleave_nodes(struct mempolicy *policy)
>   * task can change it's policy.  The system default policy requires no
>   * such protection.
>   */
> -unsigned slab_node(struct mempolicy *policy)
> +unsigned slab_node(void)
>  {
> -	if (!policy || policy->flags & MPOL_F_LOCAL)
> +	struct mempolicy *policy = current->mempolicy;
> +
> +	if (in_interrupt() || !policy || policy->flags & MPOL_F_LOCAL)
>  		return numa_node_id();
>  
>  	switch (policy->mode) {

I think the version proposed by David Mackey is more clear, it makes it 
obvious that we don't want to dereference current in interrupt context 
whereas that relies on short-circuiting your conditional in your approach.
