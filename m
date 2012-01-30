Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2A3UAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:00:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51115 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab2A3UAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:00:45 -0500
Date: Mon, 30 Jan 2012 21:00:40 +0100
From: Jan Kara <jack@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system
 suspend/hibernation
Message-ID: <20120130200040.GB7827@quack.suse.cz>
References: <201201281445.49377.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201281445.49377.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 28-01-12 14:45:49, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Freeze all filesystems during system suspend and (kernel-driven)
> hibernation by calling freeze_supers() for all superblocks and thaw
> them during the subsequent resume with the help of thaw_supers().
> 
> This makes filesystems stay in a consistent state in case something
> goes wrong between system suspend (or hibernation) and the subsequent
> resume (e.g. journal replays won't be necessary in those cases).  In
> particular, this should help to solve a long-standing issue that, in
> some cases, during resume from hibernation the boot loader causes the
> journal to be replied for the filesystem containing the kernel image
> and/or initrd causing it to become inconsistent with the information
> stored in the hibernation image.
> 
> The user-space-driven hibernation (s2disk) is not covered by this
> change, because the freezing of filesystems prevents s2disk from
> accessing device special files it needs to do its job.
> 
> This change is based on earlier work by Nigel Cunningham.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  fs/super.c               |   73 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h       |    3 +
>  kernel/power/hibernate.c |   11 +++++--
>  kernel/power/power.h     |   23 --------------
>  kernel/power/suspend.c   |   42 +++++++++++++++++++++++++++
>  5 files changed, 128 insertions(+), 24 deletions(-)
> 
> Index: linux/fs/super.c
> ===================================================================
> --- linux.orig/fs/super.c
> +++ linux/fs/super.c
> @@ -594,6 +594,79 @@ void iterate_supers_type(struct file_sys
>  EXPORT_SYMBOL(iterate_supers_type);
>  
>  /**
> + *	thaw_supers - call thaw_super() for all superblocks
> + */
> +void thaw_supers(void)
> +{
> +	struct super_block *sb, *p = NULL;
> +
> +	spin_lock(&sb_lock);
> +	list_for_each_entry(sb, &super_blocks, s_list) {
> +		if (list_empty(&sb->s_instances))
> +			continue;
> +		sb->s_count++;
> +		spin_unlock(&sb_lock);
> +
> +		if (sb->s_flags & MS_FROZEN) {
> +			thaw_super(sb);
> +			sb->s_flags &= ~MS_FROZEN;
> +		}
> +
> +		spin_lock(&sb_lock);
> +		if (p)
> +			__put_super(p);
> +		p = sb;
> +	}
> +	if (p)
> +		__put_super(p);
> +	spin_unlock(&sb_lock);
> +}
  At least for thawing you can use iterate_supers() helper.

> +/**
> + *	freeze_supers - call freeze_super() for all superblocks
> + */
> +int freeze_supers(void)
> +{
> +	struct super_block *sb, *p = NULL;
> +	int error = 0;
> +
> +	spin_lock(&sb_lock);
> +	/*
> +	 * Freeze in reverse order so filesystems depending on others are
> +	 * frozen in the right order (eg. loopback on ext3).
> +	 */
  Ho, hum, are you sure the order in super_blocks list is the one you need?
Maybe it is but I'm not sure you are guaranteed it is. I've added Al to CC,
he'll likely have opinion on this...

> +	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
> +		if (list_empty(&sb->s_instances))
> +			continue;
> +		sb->s_count++;
> +		spin_unlock(&sb_lock);
> +
> +		if (sb->s_root && sb->s_frozen != SB_FREEZE_TRANS
> +		    && !(sb->s_flags & MS_RDONLY)) {
> +			error = freeze_super(sb);
> +			if (!error)
> +				sb->s_flags |= MS_FROZEN;
> +		}
> +
> +		spin_lock(&sb_lock);
> +		if (error)
> +			break;
> +		if (p)
> +			__put_super(p);
> +		p = sb;
> +	}
> +	if (p)
> +		__put_super(p);
> +	spin_unlock(&sb_lock);
> +
> +	if (error)
> +		thaw_supers();
> +
> +	return error;
> +}
> +
> +
> +/**
>   *	get_super - get the superblock of a device
>   *	@bdev: device to get the superblock for
>   *	

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
