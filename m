Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab1HLJqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 05:46:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:58740 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab1HLJqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 05:46:30 -0400
Subject: Re: [PATCH 2/5] writeback: dirty position control
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 12 Aug 2011 11:45:33 +0200
In-Reply-To: <20110812054528.GA10524@localhost>
References: <20110806084447.388624428@intel.com>
	 <20110806094526.733282037@intel.com> <1312811193.10488.33.camel@twins>
	 <20110808141128.GA22080@localhost> <1312814501.10488.41.camel@twins>
	 <20110808230535.GC7176@localhost> <1313103367.26866.39.camel@twins>
	 <20110812024353.GA11606@localhost> <20110812054528.GA10524@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313142333.6576.8.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 13:45 +0800, Wu Fengguang wrote:
> Code is
> 
>         unsigned long freerun = (thresh + bg_thresh) / 2;
> 
>         setpoint = (limit + freerun) / 2;
>         pos_ratio = abs(dirty - setpoint);
>         pos_ratio <<= BANDWIDTH_CALC_SHIFT;
>         do_div(pos_ratio, limit - setpoint + 1);

Why do you use do_div()? from the code those things are unsigned long,
and you can divide that just fine.

Also, there's div64_s64 that can do signed divides for s64 types.
That'll loose the extra conditionals you used for abs and putting the
sign back.

>         x = pos_ratio;
>         pos_ratio = pos_ratio * x >> BANDWIDTH_CALC_SHIFT;
>         pos_ratio = pos_ratio * x >> BANDWIDTH_CALC_SHIFT;

So on 32bit with unsigned long that gets 32=2*(10+b) bits for x, that
solves to 6, which isn't going to be enough I figure since
(dirty-setpoint) !< 64.

So you really need to use u64/s64 types here, unsigned long just won't
do, with u64 you have 64=2(10+b) 22 bits for x, which should fit.


>         if (dirty > setpoint)
>                 pos_ratio = -pos_ratio;
>         pos_ratio += 1 << BANDWIDTH_CALC_SHIFT; 


