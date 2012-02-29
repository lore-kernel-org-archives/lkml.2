Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965908Ab2B2AdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:33:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:11585 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab2B2AdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:33:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112493318"
Date: Wed, 29 Feb 2012 08:27:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Righi <andrea@betterlinux.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] memcg: add dirty page accounting infrastructure
Message-ID: <20120229002743.GA11583@localhost>
References: <20120228140022.614718843@intel.com>
 <20120228144746.971869014@intel.com>
 <20120228143738.b84d49ff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120228143738.b84d49ff.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 02:37:38PM -0800, Andrew Morton wrote:
> On Tue, 28 Feb 2012 22:00:24 +0800
> Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > From: Greg Thelen <gthelen@google.com>
> > 
> > Add memcg routines to count dirty, writeback, and unstable_NFS pages.
> > These routines are not yet used by the kernel to count such pages.  A
> > later change adds kernel calls to these new routines.
> > 
> > As inode pages are marked dirty, if the dirtied page's cgroup differs
> > from the inode's cgroup, then mark the inode shared across several
> > cgroup.
> > 
> > ...
> >
> > @@ -1885,6 +1888,44 @@ void mem_cgroup_update_page_stat(struct 
> >  			ClearPageCgroupFileMapped(pc);
> >  		idx = MEM_CGROUP_STAT_FILE_MAPPED;
> >  		break;
> > +
> > +	case MEMCG_NR_FILE_DIRTY:
> > +		/* Use Test{Set,Clear} to only un/charge the memcg once. */
> > +		if (val > 0) {
> > +			if (TestSetPageCgroupFileDirty(pc))
> > +				val = 0;
> > +		} else {
> > +			if (!TestClearPageCgroupFileDirty(pc))
> > +				val = 0;
> > +		}
> 
> Made me scratch my head for a while, but I see now that the `val' arg
> to (the undocumented) mem_cgroup_update_page_stat() can only ever have
> the values 1 or -1.  I hope.

Yeah, I see it's called this way:

   3    151  /c/linux/include/linux/memcontrol.h <<mem_cgroup_inc_page_stat>>
             mem_cgroup_update_page_stat(page, idx, 1);

   4    157  /c/linux/include/linux/memcontrol.h <<mem_cgroup_dec_page_stat>>
             mem_cgroup_update_page_stat(page, idx, -1);

Thanks,
Fengguang
