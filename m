Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1DSQtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:49:07 -0400
Received: from kroah.org ([198.145.64.141]:59760 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab1DSQtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:49:03 -0400
Date: Tue, 19 Apr 2011 09:21:57 -0700
From: Greg KH <greg@kroah.com>
To: Vasiliy Kulikov <segoon@openwall.com>, David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] char: agp: fix OOM and buffer overflow
Message-ID: <20110419162157.GD23196@kroah.com>
References: <1302800120-31560-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302800120-31560-1-git-send-email-segoon@openwall.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 08:55:19PM +0400, Vasiliy Kulikov wrote:
> page_count is copied from userspace.  agp_allocate_memory() tries to
> check whether this number is too big, but doesn't take into account the
> wrap case.  Also agp_create_user_memory() doesn't check whether
> alloc_size is calculated from num_agp_pages variable without overflow.
> This may lead to allocation of too small buffer with following buffer
> overflow.
> 
> Another problem in agp code is not addressed in the patch - kernel memory
> exhaustion (AGPIOC_RESERVE and AGPIOC_ALLOCATE ioctls).  It is not checked
> whether requested pid is a pid of the caller (no check in agpioc_reserve_wrap()).
> Each allocation is limited to 16KB, though, there is no per-process limit.
> This might lead to OOM situation, which is not even solved in case of the
> caller death by OOM killer - the memory is allocated for another (faked) process.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

David, what ever happened to this, and the other agp bugfix from
Vasiliy?

thanks,

greg k-h

> ---
>  drivers/char/agp/generic.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
> index 745e7ba..342df51 100644
> --- a/drivers/char/agp/generic.c
> +++ b/drivers/char/agp/generic.c
> @@ -115,6 +115,9 @@ static struct agp_memory *agp_create_user_memory(unsigned long num_agp_pages)
>  	struct agp_memory *new;
>  	unsigned long alloc_size = num_agp_pages*sizeof(struct page *);
>  
> +	if (INT_MAX/sizeof(struct page *) < num_agp_pages)
> +		return NULL;
> +
>  	new = kzalloc(sizeof(struct agp_memory), GFP_KERNEL);
>  	if (new == NULL)
>  		return NULL;
> @@ -234,11 +237,14 @@ struct agp_memory *agp_allocate_memory(struct agp_bridge_data *bridge,
>  	int scratch_pages;
>  	struct agp_memory *new;
>  	size_t i;
> +	int cur_memory;
>  
>  	if (!bridge)
>  		return NULL;
>  
> -	if ((atomic_read(&bridge->current_memory_agp) + page_count) > bridge->max_memory_agp)
> +	cur_memory = atomic_read(&bridge->current_memory_agp);
> +	if ((cur_memory + page_count > bridge->max_memory_agp) ||
> +	    (cur_memory + page_count < page_count))
>  		return NULL;
>  
>  	if (type >= AGP_USER_TYPES) {
> -- 
> 1.7.0.4
> 
> _______________________________________________
> Security mailing list
> Security@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/security
