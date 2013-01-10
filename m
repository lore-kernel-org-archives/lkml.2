Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab3AJAwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 19:52:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab3AJAwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 19:52:01 -0500
Date: Thu, 10 Jan 2013 01:51:59 +0100
From: David Sterba <dsterba@suse.cz>
To: zwu.kernel@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, david@fromorbit.com, darrick.wong@oracle.com,
        andi@firstfloor.org, hch@infradead.org, linuxram@linux.vnet.ibm.com,
        wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH RESEND v1 04/16] vfs: add two map arrays
Message-ID: <20130110005159.GX20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
 <1356014615-15073-5-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356014615-15073-5-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 10:43:23PM +0800, zwu.kernel@gmail.com wrote:
> --- a/fs/hot_tracking.c
> +++ b/fs/hot_tracking.c
> +/* Free inode and range map info */
> +static void hot_map_exit(struct hot_info *root)
> +{
> +	int i;
> +	for (i = 0; i < HEAT_MAP_SIZE; i++) {
> +		spin_lock(&root->heat_inode_map[i].lock);
> +		hot_map_list_free(&root->heat_inode_map[i].node_list, root);
> +		spin_unlock(&root->heat_inode_map[i].lock);

please insert an empty line here to improve readability

> +		spin_lock(&root->heat_range_map[i].lock);
> +		hot_map_list_free(&root->heat_range_map[i].node_list, root);
> +		spin_unlock(&root->heat_range_map[i].lock);
> +	}
> +}
> +
> +/*
>   * Initialize kmem cache for hot_inode_item and hot_range_item.
>   */
>  void __init hot_cache_init(void)
> --- a/include/linux/hot_tracking.h
> +++ b/include/linux/hot_tracking.h
> @@ -71,6 +82,12 @@ struct hot_range_item {
>  struct hot_info {
>  	struct hot_rb_tree hot_inode_tree;
>  	spinlock_t lock; /*protect inode tree */
> +
> +	/* map of inode temperature */
> +	struct hot_map_head heat_inode_map[HEAT_MAP_SIZE];
> +	/* map of range temperature */
> +	struct hot_map_head heat_range_map[HEAT_MAP_SIZE];
> +	unsigned int hot_map_nr;
>  };

Final layout of struct hot_info is

struct hot_info {
        struct hot_rb_tree         hot_inode_tree;       /*     0     8 */
        spinlock_t                 lock;                 /*     8    72 */
        /* --- cacheline 1 boundary (64 bytes) was 16 bytes ago --- */
        struct hot_map_head        heat_inode_map[256];  /*    80 24576 */
        /* --- cacheline 385 boundary (24640 bytes) was 16 bytes ago --- */
        struct hot_map_head        heat_range_map[256];  /* 24656 24576 */
        /* --- cacheline 769 boundary (49216 bytes) was 16 bytes ago --- */
        unsigned int               hot_map_nr;           /* 49232     4 */

        /* XXX 4 bytes hole, try to pack */

        struct workqueue_struct *  update_wq;            /* 49240     8 */
        struct delayed_work        update_work;          /* 49248   216 */

        /* XXX last struct has 4 bytes of padding */

        /* --- cacheline 772 boundary (49408 bytes) was 56 bytes ago --- */
        struct hot_type *          hot_type;             /* 49464     8 */
        /* --- cacheline 773 boundary (49472 bytes) --- */
        struct shrinker            hot_shrink;           /* 49472    48 */
        struct dentry *            vol_dentry;           /* 49520     8 */

        /* size: 49528, cachelines: 774, members: 10 */
        /* sum members: 49524, holes: 1, sum holes: 4 */
        /* paddings: 1, sum paddings: 4 */
        /* last cacheline: 56 bytes */
};

that's an order-4 allocation and the heat_*_map[] themselves need order-3.

Also the structure

struct hot_map_head {
        struct list_head           node_list;            /*     0    16 */
        u8                         temp;                 /*    16     1 */

        /* XXX 7 bytes hole, try to pack */

        spinlock_t                 lock;                 /*    24    72 */
        /* --- cacheline 1 boundary (64 bytes) was 32 bytes ago --- */

        /* size: 96, cachelines: 2, members: 3 */
        /* sum members: 89, holes: 1, sum holes: 7 */
        /* last cacheline: 32 bytes */
};

is not packed efficiently and given the number of the array items, the wasted
space adds to the sum.

So, this needs to be fixed. Options I see:

1) try to allocate the structure with GFP_NOWARN and use vmalloc as a fallback
2) allocate heat_*_map arrays dynamically

An array of 256 pointers takes 2048 bytes, so when there are 2 of them plus
other struct items, overall size will go beyond a 4k page. Also, doing
kmalloc on each heat_*_map item could spread them over memory, although
hot_info is a long-term structure and it would make sense to keep the
data located at one place. For struct hot_map_head I suggest to create a
slab.


david
