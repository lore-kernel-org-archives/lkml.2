Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab1AEDoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 22:44:46 -0500
Received: from smtp-out.google.com ([74.125.121.67]:3645 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab1AEDop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 22:44:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=vE51x4h8jUUqREVyjvQn/EKtVMaZcwT0tvtaYq5DzkukaZBpxqu/AGleHKkQHzNf/H
         SnDEURQk5hOVOSle4YhQ==
Date: Tue, 4 Jan 2011 19:44:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: linux-kernel@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
In-Reply-To: <1294172717-6044-1-git-send-email-penberg@kernel.org>
Message-ID: <alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jan 2011, Pekka Enberg wrote:

> diff --git a/mm/slub.c b/mm/slub.c
> index bec0e35..9831004 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2516,7 +2516,13 @@ void kmem_cache_destroy(struct kmem_cache *s)
>  		}
>  		if (s->flags & SLAB_DESTROY_BY_RCU)
>  			rcu_barrier();
> +		/*
> +		 * The locking order is (1) sysfs internal locks and (2)
> +		 * slub_lock so drop the latter to avoid a deadlock.
> +		 */
> +		up_write(&slub_lock);
>  		sysfs_slab_remove(s);
> +		return;
>  	}
>  	up_write(&slub_lock);
>  }

slub_lock protects slab_state following kmem_cache_init() if caches are 
created/destroyed prior to the sysfs slab initcall setting the global 
variable, so couldn't this leak the kobject if its initialization and add 
was deferred on kmem_cache_create() and added by slab_sysfs_init()?
