Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab1KRAXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 19:23:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab1KRAXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 19:23:24 -0500
Date: Thu, 17 Nov 2011 16:23:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm: account reaped page cache on inode cache pruning
Message-Id: <20111117162322.1c3e3d05.akpm@linux-foundation.org>
In-Reply-To: <20111116134713.8933.34389.stgit@zurg>
References: <20111116134713.8933.34389.stgit@zurg>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011 17:47:13 +0300
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Inode cache pruning indirectly reclaims page-cache by invalidating mapping pages.
> Let's account them into reclaim-state to notice this progress in memory reclaimer.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  fs/inode.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index ee4e66b..1f6c48d 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -692,6 +692,8 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
>  	else
>  		__count_vm_events(PGINODESTEAL, reap);
>  	spin_unlock(&sb->s_inode_lru_lock);
> +	if (current->reclaim_state)
> +		current->reclaim_state->reclaimed_slab += reap;
>  
>  	dispose_list(&freeable);
>  }

hm, yes, I suppose we should.

It seems to be cheating to use the "reclaimed_slab" field for this. 
Perhaps it would be cleaner to add an additional field to reclaim_state
for non-slab pages which were also reclaimed.  That's a cosmetic thing
and I guess we don't need to go that far, not sure...


