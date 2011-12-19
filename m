Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1LSOUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:20:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab1LSOU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:20:27 -0500
Date: Mon, 19 Dec 2011 14:20:20 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nai Xia <nai.xia@gmail.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/11] Reduce compaction-related stalls and improve
 asynchronous migration of dirty pages v6
Message-ID: <20111219142020.GM3487@suse.de>
References: <1323877293-15401-1-git-send-email-mgorman@suse.de>
 <20111216153716.434bbf05.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20111216153716.434bbf05.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 03:37:16PM -0800, Andrew Morton wrote:
> On Wed, 14 Dec 2011 15:41:22 +0000
> Mel Gorman <mgorman@suse.de> wrote:
> 
> > Short summary: There are severe stalls when a USB stick using VFAT
> > is used with THP enabled that are reduced by this series. If you are
> > experiencing this problem, please test and report back and considering
> > I have seen complaints from openSUSE and Fedora users on this as well
> > as a few private mails, I'm guessing it's a widespread issue. This
> > is a new type of USB-related stall because it is due to synchronous
> > compaction writing where as in the past the big problem was dirty
> > pages reaching the end of the LRU and being written by reclaim.
> 
> Overall footprint:
> 
>  fs/btrfs/disk-io.c            |    5 
>  fs/hugetlbfs/inode.c          |    3 
>  fs/nfs/internal.h             |    2 
>  fs/nfs/write.c                |    4 
>  include/linux/fs.h            |   11 +-
>  include/linux/migrate.h       |   23 +++-
>  include/linux/mmzone.h        |    4 
>  include/linux/vm_event_item.h |    1 
>  mm/compaction.c               |    5 
>  mm/memory-failure.c           |    2 
>  mm/memory_hotplug.c           |    2 
>  mm/mempolicy.c                |    2 
>  mm/migrate.c                  |  171 +++++++++++++++++++++-----------
>  mm/page_alloc.c               |   50 +++++++--
>  mm/swap.c                     |   74 ++++++++++++-
>  mm/vmscan.c                   |  114 ++++++++++++++++++---
>  mm/vmstat.c                   |    2 
>  17 files changed, 371 insertions(+), 104 deletions(-)
> 
> The line count belies the increase in complexity.
> 

I know and I regret that. Unfortunately while I considered other
solutions that were less complex, they were also nowhere near as
effective. The theme is at least consistent in that we are continuing
to move away from calling writepage in reclaim context.

-- 
Mel Gorman
SUSE Labs
