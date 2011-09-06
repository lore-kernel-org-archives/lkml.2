Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab1IFMku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 08:40:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:39430 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab1IFMkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 08:40:40 -0400
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
Date: Tue, 06 Sep 2011 14:40:19 +0200
References: <1313154259.6576.42.camel@twins>
	 <20110812142020.GB17781@localhost> <1314027488.24275.74.camel@twins>
	 <20110823034042.GC7332@localhost> <1314093660.8002.24.camel@twins>
	 <20110823141504.GA15949@localhost> <20110823174757.GC15820@redhat.com>
	 <20110824001257.GA6349@localhost> <20110824180058.GC22434@redhat.com>
	 <1314623527.2816.28.camel@twins> <20110829133729.GA27871@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315312819.12533.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-02 at 14:16 +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-29 at 21:37 +0800, Wu Fengguang wrote:
> > > 
> > > Ok so this argument makes sense, is there some formalism to describe
> > > such systems where such things are more evident?
> > 
> > I find the most easy and clean way to describe it is,
> > 
> > (1) the below formula
> >                                                           write_bw  
> >     bdi->dirty_ratelimit_(i+1) = bdi->dirty_ratelimit_i * --------- * pos_ratio
> >                                                           dirty_bw
> > is able to yield
> > 
> >     dirty_ratelimit_(i) ~= (write_bw / N)
> > 
> > as long as
> > 
> > - write_bw, dirty_bw and pos_ratio are not changing rapidly
> > - dirty pages are not around @freerun or @limit
> > 
> > Otherwise there will be larger estimation errors.
> > 
> > (2) based on (1), we get
> > 
> >     task_ratelimit ~= (write_bw / N) * pos_ratio
> > 
> > So the pos_ratio feedback is able to drive dirty count to the
> > setpoint, where pos_ratio = 1.
> > 
> > That interpretation based on _real values_ can neatly decouple the two
> > feedback loops :) It makes full utilization of the fact "the
> > dirty_ratelimit _value_ is independent on pos_ratio except for
> > possible impacts on estimation errors". 
> 
> OK, so the 'problem' I have with this is that the whole control thing
> really doesn't care about N. All it does is measure:
> 
>  - dirty rate
>  - writeback rate
> 
> observe:
> 
>  - dirty count; with the independent input of its setpoint
> 
> control:
> 
>  - ratelimit
> 
> so I was looking for a way to describe the interaction between the two
> feedback loops without involving the exact details of what they're
> controlling, but that might just end up being an oxymoron.


Hmm, so per Vivek's argument the system without pos_ratio in the
feedback term isn't convergent. Therefore we should be able to argue
from convergent/stability grounds that this term is indeed needed.

Does the stability proof of a control system need the model of what its
controlling? I guess I ought to go get a book on this or so.



