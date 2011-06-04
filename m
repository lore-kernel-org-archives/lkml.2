Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1FDAme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 20:42:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58634 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab1FDAmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 20:42:33 -0400
Date: Sat, 4 Jun 2011 01:42:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 08/12] superblock: introduce per-sb cache shrinker
 infrastructure
Message-ID: <20110604004231.GV11521@ZenIV.linux.org.uk>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
 <1306998067-27659-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306998067-27659-9-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -278,7 +325,12 @@ void generic_shutdown_super(struct super_block *sb)
>  {
>  	const struct super_operations *sop = sb->s_op;
>  
> -
> +	/*
> +	 * shut down the shrinker first so we know that there are no possible
> +	 * races when shrinking the dcache or icache. Removes the need for
> +	 * external locking to prevent such races.
> +	 */
> +	unregister_shrinker(&sb->s_shrink);
>  	if (sb->s_root) {
>  		shrink_dcache_for_umount(sb);
>  		sync_filesystem(sb);

What it means is that shrinker_rwsem now nests inside ->s_umount...  IOW,
if any ->shrink() gets stuck, so does every generic_shutdown_super().
I'm still not convinced it's a good idea - especially since _this_
superblock will be skipped anyway.  Is there any good reason to evict
shrinker that early?  Note that doing that after ->s_umount is dropped
should be reasonably safe - your shrinker will see that superblock is
doomed if it's called anywhere in that window...
