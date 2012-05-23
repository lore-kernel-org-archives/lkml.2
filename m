Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab2EWWUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 18:20:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2EWWUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 18:20:12 -0400
Date: Wed, 23 May 2012 15:20:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: Hugh Dickins <hughd@google.com>, Nick Piggin <npiggin@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] tmpfs not interleaving properly
Message-Id: <20120523152011.3b581761.akpm@linux-foundation.org>
In-Reply-To: <74F10842A85F514CA8D8C487E74474BB2C1597@P-EXMB1-DC21.corp.sgi.com>
References: <74F10842A85F514CA8D8C487E74474BB2C1597@P-EXMB1-DC21.corp.sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012 13:28:21 +0000
Nathan Zimmer <nzimmer@sgi.com> wrote:

> 
> When tmpfs has the memory policy interleaved it always starts allocating at each file at node 0.
> When there are many small files the lower nodes fill up disproportionately.
> My proposed solution is to start a file at a randomly chosen node.
> 
> ...
>
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -17,6 +17,7 @@ struct shmem_inode_info {
>  		char		*symlink;	/* unswappable short symlink */
>  	};
>  	struct shared_policy	policy;		/* NUMA memory alloc policy */
> +	int			node_offset;	/* bias for interleaved nodes */
>  	struct list_head	swaplist;	/* chain of maybes on swap */
>  	struct list_head	xattr_list;	/* list of shmem_xattr */
>  	struct inode		vfs_inode;
> diff --git a/mm/shmem.c b/mm/shmem.c
> index f99ff3e..58ef512 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -819,7 +819,7 @@ static struct page *shmem_alloc_page(gfp_t gfp,
>  
>  	/* Create a pseudo vma that just contains the policy */
>  	pvma.vm_start = 0;
> -	pvma.vm_pgoff = index;
> +	pvma.vm_pgoff = index + info->node_offset;
>  	pvma.vm_ops = NULL;
>  	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
>  
> @@ -1153,6 +1153,7 @@ static struct inode *shmem_get_inode(struct super_block *sb, const struct inode
>  			inode->i_fop = &shmem_file_operations;
>  			mpol_shared_policy_init(&info->policy,
>  						 shmem_get_sbmpol(sbinfo));
> +			info->node_offset = node_random(&node_online_map);
>  			break;
>  		case S_IFDIR:
>  			inc_nlink(inode);

The patch seems a bit arbitrary and hacky.  It would have helped if you
had fully described how it works, and why this implementation was
chosen.

- Why alter (actually, lie about!) the offset-into-file?  Could we
  have similarly perturbed the address arg to alloc_page_vma() to do
  the spreading?

- The patch is dependent upon MPOL_INTERLEAVE being in effect, isn't
  it?  How do we guarantee that it is in force here?

- We look up the policy via mpol_shared_policy_lookup() using the
  unperturbed index.  Why?  Should we be using index+info->node_offset
  there?


