Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab1HRMfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:35:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:43085 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab1HRMff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:35:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,245,1312182000"; 
   d="scan'208";a="39808942"
Date: Thu, 18 Aug 2011 20:35:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] writeback: Per-block device
 bdi->dirty_writeback_interval and bdi->dirty_expire_interval.
Message-ID: <20110818123523.GB1883@localhost>
References: <CAFPAmTSrh4r71eQqW-+_nS2KFK2S2RQvYBEpa3QnNkZBy8ncbw@mail.gmail.com>
 <20110818094824.GA25752@localhost>
 <1313669702.6607.24.camel@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313669702.6607.24.camel@sauron>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 08:14:57PM +0800, Artem Bityutskiy wrote:
> On Thu, 2011-08-18 at 17:48 +0800, Wu Fengguang wrote:
> > > For example, the user might want to write-back pages in smaller
> > > intervals to a block device which has a
> > > faster known writeback speed.
> > 
> > That's not a complete rational. What does the user ultimately want by
> > setting a smaller interval? What would be the problems to the other
> > slow devices if the user does so by simply setting a small value
> > _globally_?
> > 
> > We need strong use cases for doing such user interface changes.
> > Would you detail the problem and the pains that can only (or best)
> > be addressed by this patch?
> 
> Here is a real use-case we had when developing the N900 phone. We had
> internal flash and external microSD slot. Internal flash is soldered in
> and cannot be removed by the user. MicroSD, in contrast, can be removed
> by the user.
> 
> For the internal flash we wanted long intervals and relaxed limits to
> gain better performance.

Understand -- it's backed by the battery anyway.

Yeah it's a practical way. It might even optimize away some of the
writes if they are truncated some time later. It also allows possible
optimization of deferring the writes to user inactive periods.

However the ultimate optimization could be to prioritize READs over
WRITEs in the IO scheduler, so that async WRITEs have minimal impact
on normal operations. It's the only option for the MicroSD case,
anyway.

> For MicroSD we wanted very short intervals and tough limits to make sure
> that if the user suddenly removes his microSD (users do this all the
> time) - we do not lose data.

Pretty reasonable.

> The discussed capability would be very useful in that case, AFAICS.

Agreed.

> IOW, this is not only about fast/slow devices and how quickly you want
> to be able to sync the FS, this is also about data integrity guarantees.

In fact I never think it would matter for fast/slow devices.  It's the
dirty_ratio/dirty_bytes interfaces that ask for improvement if care
about too many pages being cached.

The intervals interfaces are intended for data integrity and nothing
more.

Thanks,
Fengguang
