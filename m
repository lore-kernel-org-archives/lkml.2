Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab2EHUAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 16:00:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:50550 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781Ab2EHUAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 16:00:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="141563667"
Subject: Re: [RFC, PATCH] Make memory reclaim from inodes and dentry cache
 more scalable
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1335996382.3796.88.camel@schen9-DESK>
References: <1335996382.3796.88.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 May 2012 13:00:09 -0700
Message-ID: <1336507209.3796.90.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 15:06 -0700, Tim Chen wrote:
> The following patch detects when inodes and dentries cache are really
> low in free entries, and skip reclamation of memory from them when it is
> futile to do so.  We only resume reclaiming memory from inodes and
> dentries cache when we have a reasonable amount of memory there. 
> This avoided us bottlenecking on sb_lock to do useless memory
> reclamation.  
> 
> I assume that it is okay to check super block's number of free objects
> content without sb_lock as we are holding shrinker list's read lock. The
> shrinker is still registered so super block is not yet deactivated which
> requires shrinker un-registration.  It will be great if Al can help to
> comment on whether this assumption is okay.
> 
> In a test scenario where page cache is putting heavy pressure on memory
> usage with large number of processes, we saw very heavy contention on
> the sb_lock to get free pages as seen in the following profile. The
> patch helped to reduce the runtime by almost a factor of 4.
> 
>     62.81%               cp  [kernel.kallsyms]           [k] _raw_spin_lock
>                          |
>                          --- _raw_spin_lock
>                             |
>                             |--45.19%-- grab_super_passive
>                             |          prune_super
>                             |          shrink_slab
>                             |          do_try_to_free_pages
>                             |          try_to_free_pages
>                             |          __alloc_pages_nodemask
>                             |          alloc_pages_current
> 
> 
> Tim


Hi Al, 

Want to ping you again to see what your thoughts are on this patch I've
sent a week ago.

Thanks.

Tim


