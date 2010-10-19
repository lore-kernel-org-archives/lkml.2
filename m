Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab0JSXTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 19:19:12 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:43813 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756510Ab0JSXTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 19:19:10 -0400
Date: Wed, 20 Oct 2010 10:17:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, zohar@us.ibm.com,
        warthog9@kernel.org, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 5/6] IMA: use rbtree instead of radix tree for inode
 information cache
Message-ID: <20101019231747.GC12506@dastard>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
 <20101019225839.12396.92630.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019225839.12396.92630.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 06:58:39PM -0400, Eric Paris wrote:
> @@ -36,12 +63,11 @@ struct ima_iint_cache *ima_iint_find_get(struct inode *inode)
>  	struct ima_iint_cache *iint;
>  
>  	rcu_read_lock();
> -	iint = radix_tree_lookup(&ima_iint_store, (unsigned long)inode);
> -	if (!iint)
> -		goto out;
> -	kref_get(&iint->refcount);
> -out:
> +	iint = __ima_iint_find(inode);
> +	if (iint)
> +		kref_get(&iint->refcount);
>  	rcu_read_unlock();
> +

This is wrong - the rbtree is protected only by the ima_iint_lock(),
not RCU. Hence you can't do lockless lookups on an rbtree in this
manner as they will race with inserts and deletes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
