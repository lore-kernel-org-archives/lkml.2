Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab2EGXrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 19:47:36 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60762 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841Ab2EGXre convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 19:47:34 -0400
MIME-Version: 1.0
In-Reply-To: <1336431315-29736-1-git-send-email-andi@firstfloor.org>
References: <1336431315-29736-1-git-send-email-andi@firstfloor.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 7 May 2012 19:47:13 -0400
Message-ID: <CAHGf_=p7JbWW8jgzWGHX+xwU8JWzpSMZS0kn-rmP=eg_Uqrgow@mail.gmail.com>
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context v3
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        penberg@kernel.org, cl@linux.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
> index 7c727a9..7106786 100644
> --- a/include/linux/mempolicy.h
> +++ b/include/linux/mempolicy.h
> @@ -215,7 +215,7 @@ extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
>  extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
>  extern bool mempolicy_nodemask_intersects(struct task_struct *tsk,
>                                const nodemask_t *mask);
> -extern unsigned slab_node(struct mempolicy *policy);
> +extern unsigned slab_node(void);
>
>  extern enum zone_type policy_zone;
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index cfb6c86..e05e007 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1586,9 +1586,11 @@ static unsigned interleave_nodes(struct mempolicy *policy)
>  * task can change it's policy.  The system default policy requires no
>  * such protection.
>  */
> -unsigned slab_node(struct mempolicy *policy)
> +unsigned slab_node(void)
>  {
> -       if (!policy || policy->flags & MPOL_F_LOCAL)
> +       struct mempolicy *policy = current->mempolicy;
> +
> +       if (!in_interrupt() || !policy || policy->flags & MPOL_F_LOCAL)
>                return numa_node_id();

I think your patch is correct. but I don't like interrupt context
dereference current task.
It would be nice if we only see current->mempolicy when !in_interrupt.

But this doesn't mean NAK anyway.

 Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
