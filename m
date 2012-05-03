Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2ECJSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:18:02 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34484 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab2ECJSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:18:00 -0400
Date: Thu, 3 May 2012 12:21:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Doug Ledford <dledford@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        sfr@canb.auug.org.au
Subject: Re: [Patch 1/4] ipc/mqueue: improve performance of send/recv
Message-ID: <20120503092105.GA6603@mwanda>
References: <1335894655-11398-1-git-send-email-dledford@redhat.com>
 <5b62749cb9227016ed5965fa57b96c0dccce37a8.1335894230.git.dledford@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b62749cb9227016ed5965fa57b96c0dccce37a8.1335894230.git.dledford@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 01:50:52PM -0400, Doug Ledford wrote:
> @@ -150,16 +241,25 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
>  			info->attr.mq_maxmsg = attr->mq_maxmsg;
>  			info->attr.mq_msgsize = attr->mq_msgsize;
>  		}
> -		mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
> -		if (mq_msg_tblsz > PAGE_SIZE)
> -			info->messages = vmalloc(mq_msg_tblsz);
> -		else
> -			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
> -		if (!info->messages)
> -			goto out_inode;
> +		/*
> +		 * We used to allocate a static array of pointers and account
> +		 * the size of that array as well as one msg_msg struct per
> +		 * possible message into the queue size. That's no longer
> +		 * accurate as the queue is now an rbtree and will grow and
> +		 * shrink depending on usage patterns.  We can, however, still
> +		 * account one msg_msg struct per message, but the nodes are
> +		 * allocated depending on priority usage, and most programs
> +		 * only use one, or a handful, of priorities.  However, since
> +		 * this is pinned memory, we need to assume worst case, so
> +		 * that means the min(mq_maxmsg, max_priorities) * struct
> +		 * posix_msg_tree_node.
> +		 */
> +		mq_treesize = info->attr.mq_maxmsg * sizeof(struct msg_msg) +
> +			min_t(unsigned int, info->attr.mq_maxmsg, MQ_PRIO_MAX) *
> +			sizeof(struct posix_msg_tree_node);

"info->attr.mq_maxmsg" is a long, but the min_t() truncates it to an
unsigned int.  I'm not familiar with this code so I don't know if
that's a problem...

We do the same thing in mqueue_evict_inode() and mq_attr_ok().

regards,
dan carpenter

