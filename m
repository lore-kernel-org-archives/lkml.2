Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298Ab1CCOIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:08:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657Ab1CCOIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:08:05 -0500
Date: Thu, 3 Mar 2011 15:08:02 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Fix mapping->writeback_index to point to the last
 written page
Message-ID: <20110303140802.GA27751@quack.suse.cz>
References: <4D676067.8050200@ce.jp.nec.com>
 <20110302221808.GG7496@quack.suse.cz>
 <4D6EFC4B.30505@ce.jp.nec.com>
 <20110303133119.GA16562@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303133119.GA16562@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 03-03-11 21:31:19, Wu Fengguang wrote:
> On Thu, Mar 03, 2011 at 10:26:19AM +0800, Jun'ichi Nomura wrote:
>         >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899962 + 8
>         >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899970 + 8
>         >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899978 + 8
>         >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899986 + 8
>         >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899994 + 8
> ==>     >      kworker/0:1-11    4606: block_rq_issue: 8,0 W 0 () 94899962 + 40
>         > >>     flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898554 + 8
> ==>     > >>     flush-8:0-2743  4606: block_rq_issue: 8,0 W 0 () 94898554 + 8
> 
> I'd expect the wrapped around 94898554+8 to be merged with 94899962+8.
  How could they be merged? They are not continguous...

> Why kworker/0:1-11 is submitting the request early? And the second
> request is submitted by flush-8:0-2743.
  I'm not sure about that either - but I think that kworker is submitting
the work when unplug happens while flush ends up doing it when the queue is
alredy unplugged.
  
> > The 1st writeback ended at block 94898562. (94898554+8)
> > The 2nd writeback started there.
> > However, since the last page at the 1st writeback was just redirtied,
> > the 2nd writeback looped back to block 94898554 after sequentially
> > submitting blocks from 94898562 to 94900001.
> > 
> > 1 extra seek which could be avoided.
> > I haven't seen fatal problem with the latest kernel, though.
> > 
> > With older kernels (before 2.6.29, without commit 31a12666),
> > kupdate leaves the dirty pages like spots until the application wraps
> > around the ring. (It could take hours to days.)
> > That led me to this code.
> > 
> > > But as I'm thinking about it, it wouldn't harm our original aim to do
> > > what you propose and it can help this relatively common case. So I think
> > > it's a good idea. Fengguang, what do you think?
> 
> I see no problem too.
> 
> Tested-by: Wu Fengguang <fengguang.wu@intel.com>
  OK, I'll update the changelog to reflect our discussion and post the
patch to Andrew for inclusion.

								Honza
