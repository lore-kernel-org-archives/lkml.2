Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0ETXNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 19:13:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002Ab0ETXN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 19:13:29 -0400
Date: Thu, 20 May 2010 16:13:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tim <tim.c.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 2/2] tmpfs: Make tmpfs scalable with caches for free
 blocks
Message-Id: <20100520161324.5b4b146d.akpm@linux-foundation.org>
In-Reply-To: <1274225672.31973.8951.camel@mudge.jf.intel.com>
References: <1274225672.31973.8951.camel@mudge.jf.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010 16:34:32 -0700
tim <tim.c.chen@linux.intel.com> wrote:

> The current implementation of tmpfs is not scalable.
> The stat_lock is contended whenever we need to get a 
> new page, leading to lots of lock contentions.  This patch  
> makes use of the qtoken library to maintain local
> caches of free pages to speed up getting and returning
> of pages without acquisition of stat_lock.  It
> improved the performance of tmpfs by 270% for Aim7 fserver
> workload.
> 
> ...
>
> -		spin_lock(&sbinfo->stat_lock);
> -		sbinfo->free_blocks += pages;
> +		spin_lock(&inode->i_lock);
> +		qtoken_return(&sbinfo->token_jar, pages);
>  		inode->i_blocks -= pages*BLOCKS_PER_PAGE;
> -		spin_unlock(&sbinfo->stat_lock);
> +		spin_unlock(&inode->i_lock);

Well most of the calls into the qtoken layer occur under inode->i_lock.
So did we really need that spinlock inside the qtoken library code?

It is a problem when library code such as qtoken performs its own
internal locking.  We have learned that such code is much more useful
and flexible if it performs no locking at all, and requires that
callers provide the locking (lib/rbtree.c, lib/radix-tree.c,
lib/prio_heap.c, lib/flex_array.c, etcetera).  Can we follow this
approach with qtoken?

