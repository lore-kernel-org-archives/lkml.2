Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab1HXQN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 12:13:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58665 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1HXQNZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 12:13:25 -0400
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
Date: Wed, 24 Aug 2011 18:12:58 +0200
In-Reply-To: <20110824001257.GA6349@localhost>
References: <20110808141128.GA22080@localhost>
	 <1312814501.10488.41.camel@twins> <20110808230535.GC7176@localhost>
	 <1313154259.6576.42.camel@twins> <20110812142020.GB17781@localhost>
	 <1314027488.24275.74.camel@twins> <20110823034042.GC7332@localhost>
	 <1314093660.8002.24.camel@twins> <20110823141504.GA15949@localhost>
	 <20110823174757.GC15820@redhat.com> <20110824001257.GA6349@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314202378.6925.48.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 08:12 +0800, Wu Fengguang wrote:
> > You somehow directly jump to  
> > 
> > 	balanced_rate = task_ratelimit_200ms * write_bw / dirty_rate
> > 
> > without explaining why following will not work.
> > 
> > 	balanced_rate_(i+1) = balance_rate(i) * write_bw / dirty_rate
> 
> Thanks for asking that, it's probably the root of confusions, so let
> me answer it standalone.
> 
> It's actually pretty simple to explain this equation:
> 
>                                                write_bw
>         balanced_rate = task_ratelimit_200ms * ----------       (1)
>                                                dirty_rate
> 
> If there are N dd tasks, each task is throttled at task_ratelimit_200ms
> for the past 200ms, we are going to measure the overall bdi dirty rate
> 
>         dirty_rate = N * task_ratelimit_200ms                   (2)
> 
> put (2) into (1) we get
> 
>         balanced_rate = write_bw / N                            (3)
> 
> So equation (1) is the right estimation to get the desired target (3).
> 
> 
> As for
> 
>                                                   write_bw
>         balanced_rate_(i+1) = balanced_rate_(i) * ----------    (4)
>                                                   dirty_rate
> 
> Let's compare it with the "expanded" form of (1):
> 
>                                                               write_bw
>         balanced_rate_(i+1) = balanced_rate_(i) * pos_ratio * ----------      (5)
>                                                               dirty_rate
> 
> So the difference lies in pos_ratio.
> 
> Believe it or not, it's exactly the seemingly use of pos_ratio that
> makes (5) independent(*) of the position control.
> 
> Why? Look at (4), assume the system is in a state
> 
> - dirty rate is already balanced, ie. balanced_rate_(i) = write_bw / N
> - dirty position is not balanced, for example pos_ratio = 0.5
> 
> balance_dirty_pages() will be rate limiting each tasks at half the
> balanced dirty rate, yielding a measured
> 
>         dirty_rate = write_bw / 2                               (6)
> 
> Put (6) into (4), we get
> 
>         balanced_rate_(i+1) = balanced_rate_(i) * 2
>                             = (write_bw / N) * 2
> 
> That means, any position imbalance will lead to balanced_rate
> estimation errors if we follow (4). Whereas if (1)/(5) is used, we
> always get the right balanced dirty ratelimit value whether or not
> (pos_ratio == 1.0), hence make the rate estimation independent(*) of
> dirty position control.
> 
> (*) independent as in real values, not the seemingly relations in equation


The assumption here is that N is a constant.. in the above case
pos_ratio would eventually end up at 1 and things would be good again. I
see your argument about oscillations, but I think you can introduce
similar effects by varying N.
