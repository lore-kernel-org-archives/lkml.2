Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1HLFpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 01:45:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:17976 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab1HLFpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 01:45:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,360,1309762800"; 
   d="scan'208";a="37722562"
Date: Fri, 12 Aug 2011 13:45:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: dirty position control
Message-ID: <20110812054528.GA10524@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094526.733282037@intel.com>
 <1312811193.10488.33.camel@twins>
 <20110808141128.GA22080@localhost>
 <1312814501.10488.41.camel@twins>
 <20110808230535.GC7176@localhost>
 <1313103367.26866.39.camel@twins>
 <20110812024353.GA11606@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812024353.GA11606@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Making our final function look like:
> > 
> >                s - x 3
> >  f(x) :=  1 + (-----)
> >                l - s
> 
> Very intuitive reasoning, thanks!
> 
> I substituted real numbers to the function assuming a mem=2GB system.
> 
> with limit=thresh:
> 
>         gnuplot> set xrange [60000:80000]
>         gnuplot> plot 1 +  (70000.0 - x)**3/(80000-70000.0)**3

I'll use the above one, which is more simple and elegant: 

        f(freerun)  = 2.0
        f(setpoint) = 1.0
        f(limit)    = 0

Code is

        unsigned long freerun = (thresh + bg_thresh) / 2;

        setpoint = (limit + freerun) / 2;
        pos_ratio = abs(dirty - setpoint);
        pos_ratio <<= BANDWIDTH_CALC_SHIFT;
        do_div(pos_ratio, limit - setpoint + 1);
        x = pos_ratio;
        pos_ratio = pos_ratio * x >> BANDWIDTH_CALC_SHIFT;
        pos_ratio = pos_ratio * x >> BANDWIDTH_CALC_SHIFT;
        if (dirty > setpoint)
                pos_ratio = -pos_ratio;
        pos_ratio += 1 << BANDWIDTH_CALC_SHIFT;

Thanks,
Fengguang
