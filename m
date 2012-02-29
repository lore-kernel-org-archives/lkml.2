Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030620Ab2B2Aw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:52:27 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52542 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966169Ab2B2Aw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:52:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 29 Feb 2012 09:50:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Andrea Righi <andrea@betterlinux.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] memcg: add page_cgroup flags for dirty page
 tracking
Message-Id: <20120229095051.739bb363.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120228144746.900395448@intel.com>
References: <20120228140022.614718843@intel.com>
	<20120228144746.900395448@intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 22:00:23 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> From: Greg Thelen <gthelen@google.com>
> 
> Add additional flags to page_cgroup to track dirty pages
> within a mem_cgroup.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Andrea Righi <andrea@betterlinux.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

I'm sorry but I changed the design of page_cgroup's flags update
and never want to add new flags (I'd like to remove page_cgroup->flags.)

Please see linux-next.

A good example is PCG_FILE_MAPPED, which I removed.

memcg: use new logic for page stat accounting
memcg: remove PCG_FILE_MAPPED

You can make use of PageDirty() and PageWriteback() instead of new flags.. (I hope.)

Thanks,
-Kame

> ---
>  include/linux/page_cgroup.h |   23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> --- linux.orig/include/linux/page_cgroup.h	2012-02-19 10:53:14.000000000 +0800
> +++ linux/include/linux/page_cgroup.h	2012-02-19 10:53:16.000000000 +0800
> @@ -10,6 +10,9 @@ enum {
>  	/* flags for mem_cgroup and file and I/O status */
>  	PCG_MOVE_LOCK, /* For race between move_account v.s. following bits */
>  	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
> +	PCG_FILE_DIRTY, /* page is dirty */
> +	PCG_FILE_WRITEBACK, /* page is under writeback */
> +	PCG_FILE_UNSTABLE_NFS, /* page is NFS unstable */
>  	__NR_PCG_FLAGS,
>  };
>  
> @@ -64,6 +67,10 @@ static inline void ClearPageCgroup##unam
>  static inline int TestClearPageCgroup##uname(struct page_cgroup *pc)	\
>  	{ return test_and_clear_bit(PCG_##lname, &pc->flags);  }
>  
> +#define TESTSETPCGFLAG(uname, lname)			\
> +static inline int TestSetPageCgroup##uname(struct page_cgroup *pc)	\
> +	{ return test_and_set_bit(PCG_##lname, &pc->flags); }
> +
>  /* Cache flag is set only once (at allocation) */
>  TESTPCGFLAG(Cache, CACHE)
>  CLEARPCGFLAG(Cache, CACHE)
> @@ -77,6 +84,22 @@ SETPCGFLAG(FileMapped, FILE_MAPPED)
>  CLEARPCGFLAG(FileMapped, FILE_MAPPED)
>  TESTPCGFLAG(FileMapped, FILE_MAPPED)
>  
> +SETPCGFLAG(FileDirty, FILE_DIRTY)
> +CLEARPCGFLAG(FileDirty, FILE_DIRTY)
> +TESTPCGFLAG(FileDirty, FILE_DIRTY)
> +TESTCLEARPCGFLAG(FileDirty, FILE_DIRTY)
> +TESTSETPCGFLAG(FileDirty, FILE_DIRTY)
> +
> +SETPCGFLAG(FileWriteback, FILE_WRITEBACK)
> +CLEARPCGFLAG(FileWriteback, FILE_WRITEBACK)
> +TESTPCGFLAG(FileWriteback, FILE_WRITEBACK)
> +
> +SETPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
> +CLEARPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
> +TESTPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
> +TESTCLEARPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
> +TESTSETPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
> +
>  SETPCGFLAG(Migration, MIGRATION)
>  CLEARPCGFLAG(Migration, MIGRATION)
>  TESTPCGFLAG(Migration, MIGRATION)
> 
> 
> 

