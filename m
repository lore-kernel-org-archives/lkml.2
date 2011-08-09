Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab1HICCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 22:02:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1HICCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 22:02:02 -0400
Date: Mon, 8 Aug 2011 22:01:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] IO-less dirty throttling v8
Message-ID: <20110809020127.GA3700@redhat.com>
References: <20110806084447.388624428@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110806084447.388624428@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 04:44:47PM +0800, Wu Fengguang wrote:
> Hi all,
> 
> The _core_ bits of the IO-less balance_dirty_pages().
> Heavily simplified and re-commented to make it easier to review.
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git dirty-throttling-v8
> 
> Only the bare minimal algorithms are presented, so you will find some rough
> edges in the graphs below. But it's usable :)
> 
> 	http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/
> 
> And an introduction to the (more complete) algorithms:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/slides/smooth-dirty-throttling.pdf
> 
> Questions and reviews are highly appreciated!

Hi Wu,

I am going through the slide number 39 where you talk about it being
future proof and it can be used for IO control purposes. You have listed
following merits of this approach.

* per-bdi nature, works on NFS and Software RAID
* no delayed response (working at the right layer)
* no page tracking, hence decoupled from memcg
* no interactions with FS and CFQ
* get proportional IO controller for free
* reuse/inherit all the base facilities/functions

I would say that it will also be a good idea to list the demerits of
this approach in current form and that is that it only deals with
controlling buffered write IO and nothing else. So on the same
block device, other direct writes might be going on from same group
and in this scheme a user will not have any control. Another disadvantage
is that throttling at page cache level does not take care of IO
spikes at device level.

Now I think one could probably come up with more sophisticated scheme
where throttling is done at bdi level but is also accounted at device
level at IO controller. (Something similar I had done in the past but
Dave Chinner did not like it).

Anyway, keeping track of per cgroup rate and throttling accordingly
can definitely help implement an algorithm for per cgroup IO control.
We probably just need to find a reasonable way to account all this
IO to end device so that we have control of all kind of IO of a cgroup.

How do you implement proportional control here? From overall bdi bandwidth
vary per cgroup bandwidth regularly based on cgroup weight? Again the
issue here is that it controls only buffered WRITES and nothing else and
in this case co-ordinating with CFQ will probably be hard. So I guess
usage of proportional IO just for buffered WRITES will have limited
usage.

Thanks
Vivek




> 
> shortlog:
> 
> 	Wu Fengguang (5):
> 	      writeback: account per-bdi accumulated dirtied pages
> 	      writeback: dirty position control
> 	      writeback: dirty rate control
> 	      writeback: per task dirty rate limit
> 	      writeback: IO-less balance_dirty_pages()
> 
> 	The last 4 patches are one single logical change, but splitted here to
> 	make it easier to review the different parts of the algorithm.
> 
> diffstat:
> 
> 	 include/linux/backing-dev.h      |    8 +
> 	 include/linux/sched.h            |    7 +
> 	 include/trace/events/writeback.h |   24 --
> 	 mm/backing-dev.c                 |    3 +
> 	 mm/memory_hotplug.c              |    3 -
> 	 mm/page-writeback.c              |  459 ++++++++++++++++++++++----------------
> 	 6 files changed, 290 insertions(+), 214 deletions(-)
> 
> Thanks,
> Fengguang
