Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab1HDPRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 11:17:30 -0400
Received: from mail.openrapids.net ([64.15.138.104]:55419 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751312Ab1HDPR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 11:17:28 -0400
Date: Thu, 4 Aug 2011 11:17:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [listll] Fix fetching of head->first in lockless lists.
Message-ID: <20110804151725.GA21597@Krystal>
References: <alpine.DEB.2.00.1108040942360.24277@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108040942360.24277@router.home>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:15:12 up 253 days, 20:18,  3 users,  load average: 0.07, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> 
> The fetching of head->first must occur in the cmpxchg loop.
> 
> With the current code head->first may change after the content were assigned to
> the "entry" variable. Entry then not be change anymore in the loop and be
> used as old_entry for the cmpxchg. The cmpxchg will then therefore
> compare "entry" to list->head. This will always fail if list->head has
> changed. The restarting of the loop will not fetch head->first again. So
> we could have a hang there.
> 
> I guess this only works now because the compiler optimizations pull
> the fetching of head->first into the loop.

Hi Christoph,

The cmpxchg re-fetch the head->first (this is its return value). The:

  } while ((entry = cmpxchg(&head->first, old_entry, new)) != old_entry);

Takes care of the re-read and populating "entry" with an updated value.

So the patch you propose here is useless.

Thanks,

Mathieu

> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  lib/llist.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/lib/llist.c
> ===================================================================
> --- linux-2.6.orig/lib/llist.c	2011-08-04 09:34:30.000000000 -0500
> +++ linux-2.6/lib/llist.c	2011-08-04 09:35:08.000000000 -0500
> @@ -42,8 +42,8 @@ void llist_add(struct llist_node *new, s
>  	BUG_ON(in_nmi());
>  #endif
> 
> -	entry = head->first;
>  	do {
> +		entry = head->first;
>  		old_entry = entry;
>  		new->next = entry;
>  		cpu_relax();
> @@ -66,8 +66,8 @@ void llist_add_batch(struct llist_node *
>  	BUG_ON(in_nmi());
>  #endif
> 
> -	entry = head->first;
>  	do {
> +		entry = head->first;
>  		old_entry = entry;
>  		new_last->next = entry;
>  		cpu_relax();
> @@ -97,8 +97,8 @@ struct llist_node *llist_del_first(struc
>  	BUG_ON(in_nmi());
>  #endif
> 
> -	entry = head->first;
>  	do {
> +		entry = head->first;
>  		if (entry == NULL)
>  			return NULL;
>  		old_entry = entry;

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
