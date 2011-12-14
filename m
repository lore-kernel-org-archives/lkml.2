Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab1LNB7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 20:59:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:47226 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab1LNB7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 20:59:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85439939"
Date: Wed, 14 Dec 2011 09:49:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Curt Wohlgemuth <curtw@google.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] writeback: Unduplicate writeback reason
Message-ID: <20111214014903.GA25931@localhost>
References: <20111214003150.GA14520@localhost>
 <1323825240.23971.11.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323825240.23971.11.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Wed, Dec 14, 2011 at 09:14:00AM +0800, Steven Rostedt wrote:
> Names of the writeback reasons are used in both the main kernel as well
> as for parsing the tracepoint format file. Instead of duplicating the
> names in two locations making it likely that they may become out of
> sync, use some macro magic to make sure all the names stay in sync. Any
> update only needs to happen in one spot for it to take place in all
> locations.
 
It looks a bit hacky, but does the nice job of de-duplicating code.
And it compiles. So I like it and would like to take it with the below
rename :-)

> Note, this is an RFC patch, and it probably needs much better comments
> (well, it currently has no comments), and the C() macro probably should
> have a different name too.

C => WB_ENUM_REASONS_ITEM? It may look unpleasantly long, however is
unique enough to make the many #define/#undef safe. 

Thanks!
Fengguang

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Index: linux-trace.git/fs/fs-writeback.c
> ===================================================================
> --- linux-trace.git.orig/fs/fs-writeback.c
> +++ linux-trace.git/fs/fs-writeback.c
> @@ -47,15 +47,10 @@ struct wb_writeback_work {
>  	struct completion *done;	/* set if the caller waits */
>  };
>  
> +#undef C
> +#define C(a, b) [a] = b
>  const char *wb_reason_name[] = {
> -	[WB_REASON_BACKGROUND]		= "background",
> -	[WB_REASON_TRY_TO_FREE_PAGES]	= "try_to_free_pages",
> -	[WB_REASON_SYNC]		= "sync",
> -	[WB_REASON_PERIODIC]		= "periodic",
> -	[WB_REASON_LAPTOP_TIMER]	= "laptop_timer",
> -	[WB_REASON_FREE_MORE_MEM]	= "free_more_memory",
> -	[WB_REASON_FS_FREE_SPACE]	= "fs_free_space",
> -	[WB_REASON_FORKER_THREAD]	= "forker_thread"
> +	WB_ENUM_REASONS
>  };
>  
>  /*
> Index: linux-trace.git/include/linux/writeback.h
> ===================================================================
> --- linux-trace.git.orig/include/linux/writeback.h
> +++ linux-trace.git/include/linux/writeback.h
> @@ -38,21 +38,23 @@ enum writeback_sync_modes {
>  	WB_SYNC_ALL,	/* Wait on every mapping */
>  };
>  
> +#define WB_ENUM_REASONS							\
> +		C(WB_REASON_BACKGROUND,		"background"),		\
> +		C(WB_REASON_TRY_TO_FREE_PAGES,	"try_to_free_pages"),	\
> +		C(WB_REASON_SYNC,		"sync"),		\
> +		C(WB_REASON_PERIODIC,		"periodic"),		\
> +		C(WB_REASON_LAPTOP_TIMER,	"laptop_timer"),	\
> +		C(WB_REASON_FREE_MORE_MEM,	"free_more_memory"),	\
> +		C(WB_REASON_FS_FREE_SPACE,	"fs_free_space"),	\
> +		C(WB_REASON_FORKER_THREAD,	"forker_thread")
> +
>  /*
>   * why some writeback work was initiated
>   */
> -enum wb_reason {
> -	WB_REASON_BACKGROUND,
> -	WB_REASON_TRY_TO_FREE_PAGES,
> -	WB_REASON_SYNC,
> -	WB_REASON_PERIODIC,
> -	WB_REASON_LAPTOP_TIMER,
> -	WB_REASON_FREE_MORE_MEM,
> -	WB_REASON_FS_FREE_SPACE,
> -	WB_REASON_FORKER_THREAD,
> +#undef C
> +#define C(a, b) a
> +enum wb_reason { WB_ENUM_REASONS, WB_REASONS_MAX };
>  
> -	WB_REASON_MAX,
> -};
>  extern const char *wb_reason_name[];
>  
>  /*
> Index: linux-trace.git/include/trace/events/writeback.h
> ===================================================================
> --- linux-trace.git.orig/include/trace/events/writeback.h
> +++ linux-trace.git/include/trace/events/writeback.h
> @@ -21,16 +21,11 @@
>  		{I_REFERENCED,		"I_REFERENCED"}		\
>  	)
>  
> +#undef C
> +#define C(a, b) {a, b}
>  #define show_work_reason(reason)					\
>  	__print_symbolic(reason,					\
> -		{WB_REASON_BACKGROUND,		"background"},		\
> -		{WB_REASON_TRY_TO_FREE_PAGES,	"try_to_free_pages"},	\
> -		{WB_REASON_SYNC,		"sync"},		\
> -		{WB_REASON_PERIODIC,		"periodic"},		\
> -		{WB_REASON_LAPTOP_TIMER,	"laptop_timer"},	\
> -		{WB_REASON_FREE_MORE_MEM,	"free_more_memory"},	\
> -		{WB_REASON_FS_FREE_SPACE,	"fs_free_space"},	\
> -		{WB_REASON_FORKER_THREAD,	"forker_thread"}	\
> +			 WB_ENUM_REASONS				\
>  	)
>  
>  struct wb_writeback_work;
> 
