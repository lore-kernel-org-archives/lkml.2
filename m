Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab1HZI4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 04:56:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:54669 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab1HZI4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 04:56:39 -0400
Subject: Re: [PATCH 2/5] writeback: dirty position control
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 26 Aug 2011 10:56:11 +0200
In-Reply-To: <20110826015610.GA10320@localhost>
References: <20110812142020.GB17781@localhost>
	 <1314027488.24275.74.camel@twins> <20110823034042.GC7332@localhost>
	 <1314093660.8002.24.camel@twins> <20110823141504.GA15949@localhost>
	 <20110823174757.GC15820@redhat.com> <20110824001257.GA6349@localhost>
	 <20110824180058.GC22434@redhat.com> <20110825031934.GA9764@localhost>
	 <20110825222001.GG27162@redhat.com> <20110826015610.GA10320@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314348971.26922.20.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 09:56 +0800, Wu Fengguang wrote:
>         /*
>          * A linear estimation of the "balanced" throttle rate. The theory is,
>          * if there are N dd tasks, each throttled at task_ratelimit, the bdi's
>          * dirty_rate will be measured to be (N * task_ratelimit). So the below
>          * formula will yield the balanced rate limit (write_bw / N).
>          *
>          * Note that the expanded form is not a pure rate feedback:
>          *      rate_(i+1) = rate_(i) * (write_bw / dirty_rate)              (1)
>          * but also takes pos_ratio into account:
>          *      rate_(i+1) = rate_(i) * (write_bw / dirty_rate) * pos_ratio  (2)
>          *
>          * (1) is not realistic because pos_ratio also takes part in balancing
>          * the dirty rate.  Consider the state
>          *      pos_ratio = 0.5                                              (3)
>          *      rate = 2 * (write_bw / N)                                    (4)
>          * If (1) is used, it will stuck in that state! Because each dd will be
>          * throttled at
>          *      task_ratelimit = pos_ratio * rate = (write_bw / N)           (5)
>          * yielding
>          *      dirty_rate = N * task_ratelimit = write_bw                   (6)
>          * put (6) into (1) we get
>          *      rate_(i+1) = rate_(i)                                        (7)
>          *
>          * So we end up using (2) to always keep
>          *      rate_(i+1) ~= (write_bw / N)                                 (8)
>          * regardless of the value of pos_ratio. As long as (8) is satisfied,
>          * pos_ratio is able to drive itself to 1.0, which is not only where
>          * the dirty count meet the setpoint, but also where the slope of
>          * pos_ratio is most flat and hence task_ratelimit is least fluctuated.
>          */ 

I'm still not buying this, it has the massive assumption N is a
constant, without that assumption you get the same kind of thing you get
from not adding pos_ratio to the feedback term.

Also, I've yet to see what harm it does if you leave it out, all
feedback loops should stabilize just fine.
