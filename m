Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424Ab0JYTWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:22:46 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:40899 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab0JYTWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:22:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <19653.55494.240658.165153@quad.stoffel.home>
Date: Mon, 25 Oct 2010 15:21:42 -0400
From: "John Stoffel" <john@stoffel.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, zohar@us.ibm.com,
        warthog9@kernel.org, david@fromorbit.com, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
In-Reply-To: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:

Eric> The IMA code needs to store the number of tasks which have an
Eric> open fd granting permission to write a file even when IMA is not
Eric> in use.  It needs this information in order to be enabled at a
Eric> later point in time without losing it's integrity garantees.

This sounds completely wrong to me.  If I disable IMA (but have the
sucker compiled in due to a vendor...) I don't want *any* overhead,
and this is speaking using my SysAdmin hat for people who do EDA
design work, and having fast systems is key for us.  IMA is NOT.  We
disable SELINUX too, because of the overhead and the maintenance
nightmare.

If IMA isn't enabled right from the get-go, how can you ensure
integrity?  And how can you ensure integrity if root is compromised?
If root can disable IMA, screw around with a file, then turn on IMA
again without the change being guarrentteed to be noticed (and not
because the attacked didn't do the attack perfectly!) what's the use?

How does this help any?  

To quote from:
http://domino.research.ibm.com/comm/research_people.nsf/pages/sailer.ima.html

    What IMA is not

    IMA is not controlling your system. IMA is non-intrusive and is best
    described as an independent observer collecting integrity information
    of loaded code or sensitive application files on demand. Consequently,
    IMA does not prevent a system from illegal behavior that might
    compromise the system including the integrity measurement architecture
    itself. Recognizing the danger of being by-passed, IMA simply
    invalidates its own measurement list by invalidating the TPM integrity
    aggregate and thereby rendering the evidence useless (non-verifiable)
    until it is reset during the next system reboot. For example, if
    applications write directly to a device (/dev/hda, /dev/sda) or kernel
    memory (/dev/kmem), then IMA invalidates the TPM aggregate.

    IMA is not a Digital Rights Management tool either. IMA collects
    evidence on the local system, which can be used for many purposes but
    whose release is fully controlled by the local system. It is getting
    harder to lie about what you are running when you use IMA; no doubt
    about it. However, if system security is going to be reality, systems
    that lie at will seem not a convincing alternative in a distributed
    environment where the weakest link determines the security of the
    distributed service. The price to pay is that properties must be
    established securely and that the balance between use and abuse of
    knowledge about such properties as well as the validity of requiring
    such evidence (e.g., before connecting a system to a video-on-demand
    service) must be controlled by rules that are enforced the same way
    they are in other areas of our daily life (most likely by laws).


So basically, IMA is super duper tripwire with the ability to allow
some remote system to come in and ask for your Hashes.  And if you
screw around with it, it immediately disables itself.  

Which seems to fly in the face of your claim that it needs to be able
to re-enable itself by tracking open inodes even when disabled.

Eric>   At the moment that means we store a little bit of data about
Eric> every inode in a cache.  We use a radix tree key'd on the
Eric> inode's memory address.  Dave Chinner pointed out that a radix
Eric> tree is a terrible data structure for such a sparse key space.
Eric> This patch switches to using an rbtree which should be more
Eric> efficient.

As the number of inodes goes up (say during a backup which reads
them...) won't the size of this cache go up as well, even when IMA is
disabled?  Why is this overhead even needed?  

This should all just be ripped out.

John

Eric> Bug report from Dave:

Eric>  I just noticed that slabtop
Eric> was reportingi an awfully high usage of radix tree nodes:

Eric>  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
Eric> 4200331 2778082  66%    0.55K 144839       29   2317424K radix_tree_node
Eric> 2321500 2060290  88%    1.00K  72581       32   2322592K xfs_inode
Eric> 2235648 2069791  92%    0.12K  69864       32    279456K iint_cache

Eric> That is, 2.7M radix tree nodes are allocated, and the cache itself
Eric> is consuming 2.3GB of RAM. I know that the XFS inodei caches are
Eric> indexed by radix tree node, but for 2 million cached inodes that
Eric> would mean a density of 1 inode per radix tree node, which for a
Eric> system with 16M inodes in the filsystems is an impossibly low
Eric> density. The worst I've seen in a production system like kernel.org
Eric> is about 20-25% density, which would mean about 150−200k radix tree
Eric> nodes for that many inodes. So it's not the inode cache.

Eric> So I looked up what the iint_cache was. It appears to used for storing
Eric> per-inode IMA information, and uses a radix tree for indexing.
Eric> It uses the *address* of the struct inode as the indexing key. That
Eric> means the key space is extremely sparse - for XFS the struct inode
Eric> addresses are approximately 1000 bytes apart, which means the
Eric> closest the radix tree index keys get is ~1000. Which means
Eric> that there is a single entry per radix tree leaf node, so the radix
Eric> tree is using roughly 550 bytes for every 120byte structure being
Eric> cached. For the above example, it's probably wasting close to 1GB of
Eric> RAM....

Eric> Reported-by: Dave Chinner <david@fromorbit.com>
Eric> Signed-off-by: Eric Paris <eparis@redhat.com>
Eric> Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Eric> ---

Eric>  security/integrity/ima/ima.h      |    6 +-
Eric>  security/integrity/ima/ima_iint.c |  105 +++++++++++++++++++++++++------------
Eric>  2 files changed, 75 insertions(+), 36 deletions(-)

Eric> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
Eric> index 3fbcd1d..7557791 100644
Eric> --- a/security/integrity/ima/ima.h
Eric> +++ b/security/integrity/ima/ima.h
Eric> @@ -100,6 +100,8 @@ static inline unsigned long ima_hash_key(u8 *digest)
 
Eric>  /* integrity data associated with an inode */
Eric>  struct ima_iint_cache {
Eric> +	struct rb_node rb_node; /* rooted in ima_iint_tree */
Eric> +	struct inode *inode;	/* back pointer to inode in question */
Eric>  	u64 version;		/* track inode changes */
Eric>  	unsigned long flags;
Eric>  	u8 digest[IMA_DIGEST_SIZE];
Eric> @@ -108,7 +110,6 @@ struct ima_iint_cache {
Eric>  	long writecount;	/* measured files writecount */
Eric>  	long opencount;		/* opens reference count */
Eric>  	struct kref refcount;	/* ima_iint_cache reference count */
Eric> -	struct rcu_head rcu;
Eric>  };
 
Eric>  /* LIM API function definitions */
Eric> @@ -122,13 +123,12 @@ int ima_store_template(struct ima_template_entry *entry, int violation,
Eric>  void ima_template_show(struct seq_file *m, void *e,
Eric>  		       enum ima_show_type show);
 
Eric> -/* radix tree calls to lookup, insert, delete
Eric> +/* rbtree tree calls to lookup, insert, delete
Eric>   * integrity data associated with an inode.
Eric>   */
Eric>  struct ima_iint_cache *ima_iint_insert(struct inode *inode);
Eric>  struct ima_iint_cache *ima_iint_find_get(struct inode *inode);
Eric>  void iint_free(struct kref *kref);
Eric> -void iint_rcu_free(struct rcu_head *rcu);
 
Eric>  /* IMA policy related functions */
Eric>  enum ima_hooks { FILE_CHECK = 1, FILE_MMAP, BPRM_CHECK };
Eric> diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
Eric> index afba4ae..8395f0f 100644
Eric> --- a/security/integrity/ima/ima_iint.c
Eric> +++ b/security/integrity/ima/ima_iint.c
Eric> @@ -12,21 +12,48 @@
Eric>   * File: ima_iint.c
Eric>   * 	- implements the IMA hooks: ima_inode_alloc, ima_inode_free
Eric>   *	- cache integrity information associated with an inode
Eric> - *	  using a radix tree.
Eric> + *	  using a rbtree tree.
Eric>   */
Eric>  #include <linux/slab.h>
Eric>  #include <linux/module.h>
Eric>  #include <linux/spinlock.h>
Eric> -#include <linux/radix-tree.h>
Eric> +#include <linux/rbtree.h>
Eric>  #include "ima.h"
 
Eric> -RADIX_TREE(ima_iint_store, GFP_ATOMIC);
Eric> -DEFINE_SPINLOCK(ima_iint_lock);
Eric> +static struct rb_root ima_iint_tree = RB_ROOT;
Eric> +static DEFINE_SPINLOCK(ima_iint_lock);
Eric>  static struct kmem_cache *iint_cache __read_mostly;
 
Eric>  int iint_initialized = 0;
 
Eric> -/* ima_iint_find_get - return the iint associated with an inode
Eric> +/*
Eric> + * __ima_iint_find - return the iint associated with an inode
Eric> + */
Eric> +static struct ima_iint_cache *__ima_iint_find(struct inode *inode)
Eric> +{
Eric> +	struct ima_iint_cache *iint;
Eric> +	struct rb_node *n = ima_iint_tree.rb_node;
Eric> +
Eric> +	assert_spin_locked(&ima_iint_lock);
Eric> +
Eric> +	while (n) {
Eric> +		iint = rb_entry(n, struct ima_iint_cache, rb_node);
Eric> +
Eric> +		if (inode < iint->inode)
Eric> +			n = n->rb_left;
Eric> +		else if (inode > iint->inode)
Eric> +			n = n->rb_right;
Eric> +		else
Eric> +			break;
Eric> +	}
Eric> +	if (!n)
Eric> +		return NULL;
Eric> +
Eric> +	return iint;
Eric> +}
Eric> +
Eric> +/*
Eric> + * ima_iint_find_get - return the iint associated with an inode
Eric>   *
Eric>   * ima_iint_find_get gets a reference to the iint. Caller must
Eric>   * remember to put the iint reference.
Eric> @@ -35,13 +62,12 @@ struct ima_iint_cache *ima_iint_find_get(struct inode *inode)
Eric>  {
Eric>  	struct ima_iint_cache *iint;
 
Eric> -	rcu_read_lock();
Eric> -	iint = radix_tree_lookup(&ima_iint_store, (unsigned long)inode);
Eric> -	if (!iint)
Eric> -		goto out;
Eric> -	kref_get(&iint->refcount);
Eric> -out:
Eric> -	rcu_read_unlock();
Eric> +	spin_lock(&ima_iint_lock);
Eric> +	iint = __ima_iint_find(inode);
Eric> +	if (iint)
Eric> +		kref_get(&iint->refcount);
Eric> +	spin_unlock(&ima_iint_lock);
Eric> +
Eric>  	return iint;
Eric>  }
 
Eric> @@ -51,25 +77,43 @@ out:
Eric>   */
Eric>  int ima_inode_alloc(struct inode *inode)
Eric>  {
Eric> -	struct ima_iint_cache *iint = NULL;
Eric> -	int rc = 0;
Eric> +	struct rb_node **p;
Eric> +	struct rb_node *new_node, *parent = NULL;
Eric> +	struct ima_iint_cache *new_iint, *test_iint;
Eric> +	int rc;
 
Eric> -	iint = kmem_cache_alloc(iint_cache, GFP_NOFS);
Eric> -	if (!iint)
Eric> +	new_iint = kmem_cache_alloc(iint_cache, GFP_NOFS);
Eric> +	if (!new_iint)
Eric>  		return -ENOMEM;
 
Eric> -	rc = radix_tree_preload(GFP_NOFS);
Eric> -	if (rc < 0)
Eric> -		goto out;
Eric> +	new_iint->inode = inode;
Eric> +	new_node = &new_iint->rb_node;
 
Eric>  	spin_lock(&ima_iint_lock);
Eric> -	rc = radix_tree_insert(&ima_iint_store, (unsigned long)inode, iint);
Eric> +
Eric> +	p = &ima_iint_tree.rb_node;
Eric> +	while (*p) {
Eric> +		parent = *p;
Eric> +		test_iint = rb_entry(parent, struct ima_iint_cache, rb_node);
Eric> +
Eric> +		rc = -EEXIST;
Eric> +		if (inode < test_iint->inode)
Eric> +			p = &(*p)->rb_left;
Eric> +		else if (inode > test_iint->inode)
Eric> +			p = &(*p)->rb_right;
Eric> +		else
Eric> +			goto out_err;
Eric> +	}
Eric> +
Eric> +	rb_link_node(new_node, parent, p);
Eric> +	rb_insert_color(new_node, &ima_iint_tree);
Eric> +
Eric>  	spin_unlock(&ima_iint_lock);
Eric> -	radix_tree_preload_end();
Eric> -out:
Eric> -	if (rc < 0)
Eric> -		kmem_cache_free(iint_cache, iint);
 
Eric> +	return 0;
Eric> +out_err:
Eric> +	spin_unlock(&ima_iint_lock);
Eric> +	kref_put(&new_iint->refcount, iint_free);
Eric>  	return rc;
Eric>  }
 
Eric> @@ -99,13 +143,6 @@ void iint_free(struct kref *kref)
Eric>  	kmem_cache_free(iint_cache, iint);
Eric>  }
 
Eric> -void iint_rcu_free(struct rcu_head *rcu_head)
Eric> -{
Eric> -	struct ima_iint_cache *iint = container_of(rcu_head,
Eric> -						   struct ima_iint_cache, rcu);
Eric> -	kref_put(&iint->refcount, iint_free);
Eric> -}
Eric> -
Eric>  /**
Eric>   * ima_inode_free - called on security_inode_free
Eric>   * @inode: pointer to the inode
Eric> @@ -117,10 +154,12 @@ void ima_inode_free(struct inode *inode)
Eric>  	struct ima_iint_cache *iint;
 
Eric>  	spin_lock(&ima_iint_lock);
Eric> -	iint = radix_tree_delete(&ima_iint_store, (unsigned long)inode);
Eric> +	iint = __ima_iint_find(inode);
Eric> +	if (iint)
Eric> +		rb_erase(&iint->rb_node, &ima_iint_tree);
Eric>  	spin_unlock(&ima_iint_lock);
Eric>  	if (iint)
Eric> -		call_rcu(&iint->rcu, iint_rcu_free);
Eric> +		kref_put(&iint->refcount, iint_free);
Eric>  }
 
Eric>  static void init_once(void *foo)

Eric> --
Eric> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Eric> the body of a message to majordomo@vger.kernel.org
Eric> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Eric> Please read the FAQ at  http://www.tux.org/lkml/

-- 
