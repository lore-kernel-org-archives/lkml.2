Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966130Ab2B1Whl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:37:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965907Ab2B1Whk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:37:40 -0500
Date: Tue, 28 Feb 2012 14:37:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Righi <andrea@betterlinux.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] memcg: add dirty page accounting infrastructure
Message-Id: <20120228143738.b84d49ff.akpm@linux-foundation.org>
In-Reply-To: <20120228144746.971869014@intel.com>
References: <20120228140022.614718843@intel.com>
	<20120228144746.971869014@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 22:00:24 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> From: Greg Thelen <gthelen@google.com>
> 
> Add memcg routines to count dirty, writeback, and unstable_NFS pages.
> These routines are not yet used by the kernel to count such pages.  A
> later change adds kernel calls to these new routines.
> 
> As inode pages are marked dirty, if the dirtied page's cgroup differs
> from the inode's cgroup, then mark the inode shared across several
> cgroup.
> 
> ...
>
> @@ -1885,6 +1888,44 @@ void mem_cgroup_update_page_stat(struct 
>  			ClearPageCgroupFileMapped(pc);
>  		idx = MEM_CGROUP_STAT_FILE_MAPPED;
>  		break;
> +
> +	case MEMCG_NR_FILE_DIRTY:
> +		/* Use Test{Set,Clear} to only un/charge the memcg once. */
> +		if (val > 0) {
> +			if (TestSetPageCgroupFileDirty(pc))
> +				val = 0;
> +		} else {
> +			if (!TestClearPageCgroupFileDirty(pc))
> +				val = 0;
> +		}

Made me scratch my head for a while, but I see now that the `val' arg
to (the undocumented) mem_cgroup_update_page_stat() can only ever have
the values 1 or -1.  I hope.

>
> ...
>
