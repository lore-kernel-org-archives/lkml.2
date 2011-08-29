Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab1H2NMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:12:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43373 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1H2NMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:12:34 -0400
Subject: Re: [PATCH 2/5] writeback: dirty position control
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 29 Aug 2011 15:12:07 +0200
In-Reply-To: <20110824180058.GC22434@redhat.com>
References: <1312814501.10488.41.camel@twins>
	 <20110808230535.GC7176@localhost> <1313154259.6576.42.camel@twins>
	 <20110812142020.GB17781@localhost> <1314027488.24275.74.camel@twins>
	 <20110823034042.GC7332@localhost> <1314093660.8002.24.camel@twins>
	 <20110823141504.GA15949@localhost> <20110823174757.GC15820@redhat.com>
	 <20110824001257.GA6349@localhost> <20110824180058.GC22434@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314623527.2816.28.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 14:00 -0400, Vivek Goyal wrote:
> 
> Ok, I think I am beginning to see your point. Let me just elaborate on
> the example you gave.
> 
> Assume a system is completely balanced and a task is writing at 100MB/s
> rate.
> 
> write_bw = dirty_rate = 100MB/s, pos_ratio = 1; N=1
> 
> bdi->dirty_ratelimit = 100MB/s
> 
> Now another tasks starts dirtying the page cache on same bdi. Number of 
> dirty pages should go up pretty fast and likely position ratio feedback
> will kick in to reduce the dirtying rate. (rate based feedback does not
> kick in till next 200ms) and pos_ratio feedback seems to be instantaneous.
> Assume new pos_ratio is .5
> 
> So new throttle rate for both the tasks is 50MB/s.
> 
> bdi->dirty_ratelimit = 100MB/s (a feedback has not kicked in yet)
> task_ratelimit = bdi->dirty_ratelimit * pos_ratio = 100 *.5 = 50MB/s
> 
> Now lets say 200ms have passed and rate base feedback is reevaluated.
> 
>                                                       write_bw  
> bdi->dirty_ratelimit_(i+1) = bdi->dirty_ratelimit_i * ---------
>                                                       dirty_bw
> 
> bdi->dirty_ratelimit_(i+1) = 100 * 100/100 = 100MB/s
> 
> Ideally bdi->dirty_ratelimit should have now become 50MB/s as N=2 but 
> that did not happen. And reason being that there are two feedback control
> loops and pos_ratio loops reacts to imbalances much more quickly. Because
> previous loop has already reacted to the imbalance and reduced the
> dirtying rate of task, rate based loop does not try to adjust anything
> and thinks everything is just fine.
> 
> Things are fine in the sense that still dirty_rate == write_bw but
> system is not balanced in terms of number of dirty pages and pos_ratio=.5
> 
> So you are trying to make one feedback loop aware of second loop so that
> if second loop is unbalanced, first loop reacts to that as well and not
> just look at dirty_rate and write_bw. So refining new balanced rate by
> pos_ratio helps.
>                                                       write_bw  
> bdi->dirty_ratelimit_(i+1) = bdi->dirty_ratelimit_i * --------- * pos_ratio
>                                                       dirty_bw
> 
> Now if global dirty pages are imbalanced, balanced rate will still go
> down despite the fact that dirty_bw == write_bw. This will lead to
> further reduction in task dirty rate. Which in turn will lead to reduced
> number of dirty rate and should eventually lead to pos_ratio=1.


Ok so this argument makes sense, is there some formalism to describe
such systems where such things are more evident?


