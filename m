Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab1LHHHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:07:19 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42988 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1LHHHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:07:15 -0500
Date: Wed, 7 Dec 2011 23:07:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kautuk Consul <consul.kautuk@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] vmalloc: purge_fragmented_blocks: Acquire spinlock
 before reading vmap_block
In-Reply-To: <1323327732-30817-1-git-send-email-consul.kautuk@gmail.com>
Message-ID: <alpine.DEB.2.00.1112072304010.28419@chino.kir.corp.google.com>
References: <1323327732-30817-1-git-send-email-consul.kautuk@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011, Kautuk Consul wrote:

> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 3231bf3..2228971 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -855,11 +855,14 @@ static void purge_fragmented_blocks(int cpu)
>  
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(vb, &vbq->free, free_list) {
> +		spin_lock(&vb->lock);
>  
> -		if (!(vb->free + vb->dirty == VMAP_BBMAP_BITS && vb->dirty != VMAP_BBMAP_BITS))
> +		if (!(vb->free + vb->dirty == VMAP_BBMAP_BITS &&
> +			  vb->dirty != VMAP_BBMAP_BITS)) {
> +			spin_unlock(&vb->lock);
>  			continue;
> +		}
>  
> -		spin_lock(&vb->lock);
>  		if (vb->free + vb->dirty == VMAP_BBMAP_BITS && vb->dirty != VMAP_BBMAP_BITS) {
>  			vb->free = 0; /* prevent further allocs after releasing lock */
>  			vb->dirty = VMAP_BBMAP_BITS; /* prevent purging it again */

Nack, this is wrong because the if-clause you're modifying isn't the 
criteria that is used to determine whether the purge occurs or not.  It's 
merely an optimization to prevent doing exactly what your patch is doing: 
taking vb->lock unnecessarily.

In the original code, if the if-clause fails, the lock is only then taken 
and the exact same test occurs again while protected.  If the test now 
fails, the lock is immediately dropped.  A branch here is faster than a 
contented spinlock.
