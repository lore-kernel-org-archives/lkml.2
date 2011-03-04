Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab1CDCUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 21:20:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:23274 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758917Ab1CDCUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 21:20:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,261,1297065600"; 
   d="scan'208";a="715981047"
Date: Fri, 4 Mar 2011 10:20:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Fix mapping->writeback_index to point to the last
 written page
Message-ID: <20110304022003.GA9213@localhost>
References: <4D676067.8050200@ce.jp.nec.com>
 <20110302221808.GG7496@quack.suse.cz>
 <4D6EFC4B.30505@ce.jp.nec.com>
 <20110303133119.GA16562@localhost>
 <20110303140802.GA27751@quack.suse.cz>
 <4D70443A.1010602@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D70443A.1010602@ce.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 09:45:30AM +0800, Jun'ichi Nomura wrote:
> On 03/03/11 23:08, Jan Kara wrote:
> > On Thu 03-03-11 21:31:19, Wu Fengguang wrote:
> >> On Thu, Mar 03, 2011 at 10:26:19AM +0800, Jun'ichi Nomura wrote:

>> [2nd writeback session after 35sec]
>>        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898562 + 8
>>        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898570 + 8
>>        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898578 + 8
>>        ...
>>      kworker/0:1-11    4606: block_rq_issue: 8,0 W 0 () 94898562 + 640
>>      kworker/0:1-11    4606: block_rq_issue: 8,0 W 0 () 94899202 + 72 
>>        ...                                                           
> >>         >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899962 + 8
> >>         >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899970 + 8
> >>         >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899978 + 8
> >>         >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899986 + 8
> >>         >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899994 + 8
> >> ==>     >      kworker/0:1-11    4606: block_rq_issue: 8,0 W 0 () 94899962 + 40
> >>         > >>     flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898554 + 8
> >> ==>     > >>     flush-8:0-2743  4606: block_rq_issue: 8,0 W 0 () 94898554 + 8
> >>
> >> I'd expect the wrapped around 94898554+8 to be merged with 94899962+8.
> >   How could they be merged? They are not continguous...

Oops, it is. It's 94898562+8 that is continuous with 94898554+8, however the
former has been submitted on max_sectors limit. So 94898554+8 lost the chance
to get merged.

> >> Why kworker/0:1-11 is submitting the request early? And the second
> >> request is submitted by flush-8:0-2743.
> >   I'm not sure about that either - but I think that kworker is submitting
> > the work when unplug happens while flush ends up doing it when the queue is
> > alredy unplugged.
> 
> Yes. For the above case, it was unplug.
> 
> For other cases, the reason was max_sectors.
> Before writeback wraps around, the request has already grown to
> max_sectors size (~512KB) and doesn't accept new merge.

Yup, good explanation!

Thanks,
Fengguang
