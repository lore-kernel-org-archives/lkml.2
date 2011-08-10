Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab1HJK0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 06:26:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51679 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1HJK0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 06:26:20 -0400
Subject: Re: [PATCH 4/5] writeback: per task dirty rate limit
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 10 Aug 2011 12:25:48 +0200
In-Reply-To: <20110810034012.GD24486@localhost>
References: <20110806084447.388624428@intel.com>
	 <20110806094527.002914580@intel.com> <1312914906.1083.71.camel@twins>
	 <20110810034012.GD24486@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312971948.23660.8.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 11:40 +0800, Wu Fengguang wrote:
> On Wed, Aug 10, 2011 at 02:35:06AM +0800, Peter Zijlstra wrote:
> > On Sat, 2011-08-06 at 16:44 +0800, Wu Fengguang wrote:
> > > 
> > > Add two fields to task_struct.
> > > 
> > > 1) account dirtied pages in the individual tasks, for accuracy
> > > 2) per-task balance_dirty_pages() call intervals, for flexibility
> > > 
> > > The balance_dirty_pages() call interval (ie. nr_dirtied_pause) will
> > > scale near-sqrt to the safety gap between dirty pages and threshold.
> > > 
> > > XXX: The main problem of per-task nr_dirtied is, if 10k tasks start
> > > dirtying pages at exactly the same time, each task will be assigned a
> > > large initial nr_dirtied_pause, so that the dirty threshold will be
> > > exceeded long before each task reached its nr_dirtied_pause and hence
> > > call balance_dirty_pages(). 
> > 
> > Right, so why remove the per-cpu threshold? you can keep that as a bound
> > on the number of out-standing dirty pages.
> 
> Right, I also have the vague feeling that the per-cpu threshold can
> somehow backup the per-task threshold in case there are too many tasks.
> 
> > Loosing that bound is actually a bad thing (TM), since you could have
> > configured a tight dirty limit and lock up your machine this way.
> 
> It seems good enough to only remove the 4MB upper limit for
> ratelimit_pages, so that the per-cpu limit won't kick in too
> frequently in typical machines.
> 
>   * Here we set ratelimit_pages to a level which ensures that when all CPUs are
>   * dirtying in parallel, we cannot go more than 3% (1/32) over the dirty memory
>   * thresholds before writeback cuts in.
> - *
> - * But the limit should not be set too high.  Because it also controls the
> - * amount of memory which the balance_dirty_pages() caller has to write back.
> - * If this is too large then the caller will block on the IO queue all the
> - * time.  So limit it to four megabytes - the balance_dirty_pages() caller
> - * will write six megabyte chunks, max.
> - */
> -
>  void writeback_set_ratelimit(void)
>  {
>         ratelimit_pages = vm_total_pages / (num_online_cpus() * 32);
>         if (ratelimit_pages < 16)
>                 ratelimit_pages = 16;
> -       if (ratelimit_pages * PAGE_CACHE_SIZE > 4096 * 1024)
> -               ratelimit_pages = (4096 * 1024) / PAGE_CACHE_SIZE;
>  }

Uhm, so what's your bound then? 1/32 of the per-cpu memory seems rather
a lot.
