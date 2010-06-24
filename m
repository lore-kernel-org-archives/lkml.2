Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0FXGE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 02:04:29 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61537 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab0FXGE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 02:04:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lfzoxu4WnoMbjXiTFv3s3aNc+fFOsmh/STCFnBKJcGiAUsVkrqIA2EzCgZx5qvhHKc
         Q+VzhXtOyGyG++awWBn8BuUxHnLop/bO4TVC0aB2KblbZRfNKFZJQCwWRQPtoo72hjLE
         pg5WFVODFi0GN+uyPrCpAtYKPRc6wq87bz4OU=
Subject: Re: [patch 01/52] kernel: add bl_list
From: Eric Dumazet <eric.dumazet@gmail.com>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
In-Reply-To: <20100624030725.718438579@suse.de>
References: <20100624030212.676457061@suse.de>
	 <20100624030725.718438579@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 08:04:22 +0200
Message-ID: <1277359462.3471.1156.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 juin 2010 à 13:02 +1000, npiggin@suse.de a écrit :
> pièce jointe document texte brut (list-bitlock.patch)
> Introduce a type of hlist that can support the use of the lowest bit in the
> hlist_head. This will be subsequently used to implement per-bucket bit spinlock
> for inode and dentry hashes.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> 
> ---
>  include/linux/list_bl.h    |   99 +++++++++++++++++++++++++++++++++++++
>  include/linux/rculist_bl.h |  120 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 219 insertions(+)
> 
> Index: linux-2.6/include/linux/list_bl.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/linux/list_bl.h
> @@ -0,0 +1,99 @@
> +#ifndef _LINUX_LIST_BL_H
> +#define _LINUX_LIST_BL_H
> +
> +#include <linux/list.h>
> +
> +/*
> + * Special version of lists, where head of the list has a bit spinlock
> + * in the lowest bit. This is useful for scalable hash tables without
> + * increasing memory footprint overhead.
> + */
> +
> +struct hlist_bl_head {
> +	struct hlist_bl_node *first;
> +};
> +
> +struct hlist_bl_node {
> +	struct hlist_bl_node *next, **pprev;
> +};
> +#define INIT_HLIST_BL_HEAD(ptr) \
> +	((ptr)->first = NULL)
> +
> +static inline void INIT_HLIST_BL_NODE(struct hlist_bl_node *h)
> +{
> +	h->next = NULL;
> +	h->pprev = NULL;
> +}
> +
> +#define hlist_bl_entry(ptr, type, member) container_of(ptr,type,member)
> +
> +static inline int hlist_bl_unhashed(const struct hlist_bl_node *h)
> +{
> +	return !h->pprev;
> +}
> +
> +static inline struct hlist_bl_node *hlist_bl_first(struct hlist_bl_head *h)
> +{
> +	return (struct hlist_bl_node *)((unsigned long)h->first & ~1UL);
> +}
> +
> +static inline void hlist_bl_set_first(struct hlist_bl_head *h, struct hlist_bl_node *n)
> +{
> +	h->first = (struct hlist_bl_node *)((unsigned long)n | ((unsigned long)h->first & 1UL));

Hmm, shouldnt hlist_bl_set_first() be used only with bit lock held ?

	h->first = (struct hlist_bl_node *)((unsigned long)n | 1UL);
> +}
> +

> +
> +static inline void hlist_bl_set_first_rcu(struct hlist_bl_head *h, struct hlist_bl_node *n)
> +{
> +	rcu_assign_pointer(h->first, (struct hlist_bl_node *)((unsigned long)n | ((unsigned long)h->first & 1UL)));

Same question here.

> +}
> +
> +static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
> +{
> +	return (struct hlist_bl_node *)((unsigned long)rcu_dereference(h->first) & ~1UL);
> +}


Looks really nice Nick, maybe we should push this so that other
subsystem can start using it.

Thanks


