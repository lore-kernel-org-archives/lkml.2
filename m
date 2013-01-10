Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab3AJAvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 19:51:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab3AJAvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 19:51:41 -0500
Date: Thu, 10 Jan 2013 01:51:39 +0100
From: David Sterba <dsterba@suse.cz>
To: zwu.kernel@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, david@fromorbit.com, darrick.wong@oracle.com,
        andi@firstfloor.org, hch@infradead.org, linuxram@linux.vnet.ibm.com,
        wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH RESEND v1 03/16] vfs: add I/O frequency update function
Message-ID: <20130110005139.GW20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
 <1356014615-15073-4-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356014615-15073-4-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 10:43:22PM +0800, zwu.kernel@gmail.com wrote:
> --- a/fs/hot_tracking.c
> +++ b/fs/hot_tracking.c
> @@ -164,6 +164,135 @@ static void hot_inode_tree_exit(struct hot_info *root)
>  	spin_unlock(&root->lock);
>  }
>  
> +struct hot_inode_item
> +*hot_inode_item_lookup(struct hot_info *root, u64 ino)
> +{
> +	struct rb_node **p = &root->hot_inode_tree.map.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct hot_comm_item *ci;
> +	struct hot_inode_item *entry;
> +
> +	/* walk tree to find insertion point */
> +	spin_lock(&root->lock);
> +	while (*p) {
> +		parent = *p;
> +		ci = rb_entry(parent, struct hot_comm_item, rb_node);
> +		entry = container_of(ci, struct hot_inode_item, hot_inode);
> +		if (ino < entry->i_ino)
> +			p = &(*p)->rb_left;
> +		else if (ino > entry->i_ino)
> +			p = &(*p)->rb_right;

style comment: put { } around the all if/else blocks

> +		else {
> +			spin_unlock(&root->lock);
> +			kref_get(&entry->hot_inode.refs);

jumping forwards in the series, the spin_unlock and kref_get get swapped
later, and I think that's the right order. Otherwise there's a small
window where the entry does not get the reference and could be
potentially freed by racing kref_put, no?

<lookup entry E>
spin_unlock(tree)
                     spin_lock(tree)
		     <lookup entry E>
		     kref_put(E) or via hot_inode_item_put(E) (1)
kref_get(E)                                                   (2)


if the reference count at (1) was 1, it's freed and (2) hits a free
memory. hot_inode_item_put can be called from filesystem or via seq
print of the respective /proc files, so I think there are chances to hit
the problem.

> +			return entry;
> +		}
> +	}
> +	spin_unlock(&root->lock);
> +
> +	entry = kmem_cache_zalloc(hot_inode_item_cachep, GFP_NOFS);
> +	if (!entry)
> +		return ERR_PTR(-ENOMEM);
> +
> +	spin_lock(&root->lock);
> +	hot_inode_item_init(entry, ino, &root->hot_inode_tree);
> +	rb_link_node(&entry->hot_inode.rb_node, parent, p);
> +	rb_insert_color(&entry->hot_inode.rb_node,
> +			&root->hot_inode_tree.map);
> +	spin_unlock(&root->lock);
> +
> +	kref_get(&entry->hot_inode.refs);

Similar here, the entry is inserted into the tree but there's no
refcount yet. And the order of spin_unlock/kref_get remains unchanged.

> +	return entry;
> +}
> +EXPORT_SYMBOL_GPL(hot_inode_item_lookup);
> +
> +static struct hot_range_item
> +*hot_range_item_lookup(struct hot_inode_item *he,
> +			loff_t start)
> +{
> +	struct rb_node **p = &he->hot_range_tree.map.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct hot_comm_item *ci;
> +	struct hot_range_item *entry;
> +
> +	/* walk tree to find insertion point */
> +	spin_lock(&he->lock);
> +	while (*p) {
> +		parent = *p;
> +		ci = rb_entry(parent, struct hot_comm_item, rb_node);
> +		entry = container_of(ci, struct hot_range_item, hot_range);
> +		if (start < entry->start)
> +			p = &(*p)->rb_left;
> +		else if (start > hot_range_end(entry))
> +			p = &(*p)->rb_right;

if { ...} 
else if { ... }

> +		else {
> +			spin_unlock(&he->lock);
> +			kref_get(&entry->hot_range.refs);

same here

> +			return entry;
> +		}
> +	}
> +	spin_unlock(&he->lock);
> +
> +	entry = kmem_cache_zalloc(hot_range_item_cachep, GFP_NOFS);
> +	if (!entry)
> +		return ERR_PTR(-ENOMEM);
> +
> +	spin_lock(&he->lock);
> +	hot_range_item_init(entry, start, he);
> +	rb_link_node(&entry->hot_range.rb_node, parent, p);
> +	rb_insert_color(&entry->hot_range.rb_node,
> +			&he->hot_range_tree.map);
> +	spin_unlock(&he->lock);
> +
> +	kref_get(&entry->hot_range.refs);

and here

> +	return entry;
> +}
> +
> +/*
> + * This function does the actual work of updating
> + * the frequency numbers, whatever they turn out to be.

Can this function be described a bit better? This comment did not help.

> + */
> +static void hot_rw_freq_calc(struct timespec old_atime,
> +		struct timespec cur_time, u64 *avg)
> +{
> +	struct timespec delta_ts;
> +	u64 new_delta;
> +
> +	delta_ts = timespec_sub(cur_time, old_atime);
> +	new_delta = timespec_to_ns(&delta_ts) >> FREQ_POWER;
> +
> +	*avg = (*avg << FREQ_POWER) - *avg + new_delta;
> +	*avg = *avg >> FREQ_POWER;
> +}
> +
> +static void hot_freq_data_update(struct hot_freq_data *freq_data, bool write)
> +{
> +	struct timespec cur_time = current_kernel_time();
> +
> +	if (write) {
> +		freq_data->nr_writes += 1;

The preferred style is

		freq_data->nr_writes++

> +		hot_rw_freq_calc(freq_data->last_write_time,
> +				cur_time,
> +				&freq_data->avg_delta_writes);
> +		freq_data->last_write_time = cur_time;
> +	} else {
> +		freq_data->nr_reads += 1;

(...)

> +		hot_rw_freq_calc(freq_data->last_read_time,
> +				freq_data->last_read_time,
> +				cur_time,
> +				&freq_data->avg_delta_reads);
> +		freq_data->last_read_time = cur_time;
> +	}
> +}
> +

david
