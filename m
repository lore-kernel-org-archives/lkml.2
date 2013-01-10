Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab3AJGYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 01:24:52 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:62185 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3AJGYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 01:24:51 -0500
MIME-Version: 1.0
In-Reply-To: <20130110004817.GU20089@twin.jikos.cz>
References: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
	<1356014615-15073-2-git-send-email-zwu.kernel@gmail.com>
	<20130110004817.GU20089@twin.jikos.cz>
Date: Thu, 10 Jan 2013 14:24:50 +0800
Message-ID: <CAEH94LipqaUaRNZv-X_=eZpdrMCAL3DhyxLSOeXLSmdjbNNLpQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v1 01/16] vfs: introduce some data structures
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: dsterba@suse.cz
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, david@fromorbit.com, darrick.wong@oracle.com,
        andi@firstfloor.org, hch@infradead.org, linuxram@linux.vnet.ibm.com,
        wuzhy@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 8:48 AM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Dec 20, 2012 at 10:43:20PM +0800, zwu.kernel@gmail.com wrote:
>> --- /dev/null
>> +++ b/fs/hot_tracking.c
>> @@ -0,0 +1,109 @@
>> +/*
>> + * fs/hot_tracking.c
>
> From what I've undrestood the file name written here is not wanted, so
> please drop it (and from .h too)
Done.
>
>> + *
>> + * Copyright (C) 2012 IBM Corp. All rights reserved.
>> + * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public
>> + * License v2 as published by the Free Software Foundation.
>
> A short description of the hot tracking feature or pointer to the
> Documentation/ file would be nice here.
ok, Done
>
>> + */
>> +
>> +#include <linux/list.h>
>> +#include <linux/err.h>
>> +#include <linux/slab.h>
>> +#include <linux/module.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/hardirq.h>
>> +#include <linux/fs.h>
>> +#include <linux/blkdev.h>
>> +#include <linux/types.h>
>> +#include <linux/limits.h>
>> +#include "hot_tracking.h"
>> +
>> +/* kmem_cache pointers for slab caches */
>
> This comment seems useless to me, I does not help understanding the code, just
> says the same what reads in C. There are more such redundant comments in the
> series, but I'm not going point to all of them right now.
Removed.
>
>> +static struct kmem_cache *hot_inode_item_cachep __read_mostly;
>> +static struct kmem_cache *hot_range_item_cachep __read_mostly;
>> +
>
>> --- /dev/null
>> +++ b/include/linux/hot_tracking.h
>> +/* The common info for both following structures */
>> +struct hot_comm_item {
>> +     struct rb_node rb_node; /* rbtree index */
>> +     struct hot_freq_data hot_freq_data;  /* frequency data */
>> +     spinlock_t lock; /* protects object data */
>> +     struct kref refs;  /* prevents kfree */
>> +};
>> +
>> +/* An item representing an inode and its access frequency */
>> +struct hot_inode_item {
>> +     struct hot_comm_item hot_inode; /* node in hot_inode_tree */
>> +     struct hot_rb_tree hot_range_tree; /* tree of ranges */
>> +     spinlock_t lock; /* protect range tree */
>> +     struct hot_rb_tree *hot_inode_tree;
>> +     u64 i_ino; /* inode number from inode */
>> +};
>
> Please align the comments to something like this (or drop them if they seem
> redundant):
Done
>
> /* The common info for both following structures */
> struct hot_comm_item {
>         struct rb_node rb_node;              /* rbtree index */
>         struct hot_freq_data hot_freq_data;  /* frequency data */
>         spinlock_t lock;                     /* protects object data */
>         struct kref refs;                    /* prevents kfree */
>         struct list_head n_list;             /* list node index */
> };
>
> /* An item representing an inode and its access frequency */
> struct hot_inode_item {
>         struct hot_comm_item hot_inode;      /* node in hot_inode_tree */
>         struct hot_rb_tree hot_range_tree;   /* tree of ranges */
>         spinlock_t lock;                     /* protect range tree */
>         struct hot_rb_tree *hot_inode_tree;
>         u64 i_ino;                           /* inode number from inode */
> };
>
>> +extern void __init hot_cache_init(void);
>
> this belongs to the private include fs/hot_tracking.h (because this is called
> only once by vfs init and not by filesystems), there's
> hot_track_init(superblock) for that purpose introduced later.
Done, Move it to fs/hot_tracking.h
>
>
> david



-- 
Regards,

Zhi Yong Wu
