Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab0FUUSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:18:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921Ab0FUUSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:18:36 -0400
Date: Mon, 21 Jun 2010 13:18:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hughd@google.com>, yanmin.zhang@intel.com
Subject: Re: [PATCH v3 2/2] tmpfs: Make tmpfs scalable with percpu_counter
 for used blocks
Message-Id: <20100621131802.c2f45c82.akpm@linux-foundation.org>
In-Reply-To: <1276818993.9661.82.camel@schen9-DESK>
References: <1276818993.9661.82.camel@schen9-DESK>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 16:56:33 -0700
Tim Chen <tim.c.chen@linux.intel.com> wrote:

> The current implementation of tmpfs is not scalable.
> We found that stat_lock is contended by multiple threads
> when we need to get a new page, leading to useless spinning
> inside this spin lock.  
> 
> This patch makes use of the percpu_counter library to maintain local
> count of used blocks to speed up getting and returning
> of pages.  So the acquisition of stat_lock is unnecessary
> for getting and returning blocks, improving the performance 
> of tmpfs on system with large number of cpus.  On a 4 socket
> 32 core NHM-EX system, we saw improvement of 270%.

So it had exactly the same performance as the token-jar approach?

It'd be good if the changelog were to mention the inaccuracy issues. 
Describe their impact, if any.

Are you actually happy with this overall approach?

>
> ...
>
> @@ -2258,9 +2254,8 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
>  		return error;
>  
>  	spin_lock(&sbinfo->stat_lock);
> -	blocks = sbinfo->max_blocks - sbinfo->free_blocks;
>  	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
> -	if (config.max_blocks < blocks)
> +	if (config.max_blocks < percpu_counter_sum(&sbinfo->used_blocks))

This could actually use percpu_counter_compare()?

>  		goto out;
>  	if (config.max_inodes < inodes)
>  		goto out;

