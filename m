Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1HHNre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 09:47:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42691 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab1HHNrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 09:47:33 -0400
Subject: Re: [PATCH 4/5] writeback: per task dirty rate limit
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 08 Aug 2011 15:47:14 +0200
In-Reply-To: <20110806094527.002914580@intel.com>
References: <20110806084447.388624428@intel.com>
	 <20110806094527.002914580@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312811234.10488.34.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-06 at 16:44 +0800, Wu Fengguang wrote:
> Add two fields to task_struct.
> 
> 1) account dirtied pages in the individual tasks, for accuracy
> 2) per-task balance_dirty_pages() call intervals, for flexibility
> 
> The balance_dirty_pages() call interval (ie. nr_dirtied_pause) will
> scale near-sqrt to the safety gap between dirty pages and threshold.
> 
> XXX: The main problem of per-task nr_dirtied is, if 10k tasks start
> dirtying pages at exactly the same time, each task will be assigned a
> large initial nr_dirtied_pause, so that the dirty threshold will be
> exceeded long before each task reached its nr_dirtied_pause and hence
> call balance_dirty_pages().
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  include/linux/sched.h |    7 ++
>  mm/memory_hotplug.c   |    3 -
>  mm/page-writeback.c   |  106 +++++++++-------------------------------
>  3 files changed, 32 insertions(+), 84 deletions(-) 

No fork() hooks? This way tasks inherit their parent's dirty count on
clone().
