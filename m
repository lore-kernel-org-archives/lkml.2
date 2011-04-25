Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab1DYBCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 21:02:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:28901 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab1DYBCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 21:02:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,264,1301900400"; 
   d="scan'208";a="633520115"
Subject: Re: [RFC]block: add flush request at head
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        "Shi, Alex" <alex.shi@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <20110422225704.GA1576@mtj.dyndns.org>
References: <1303112174.3981.187.camel@sli10-conroe>
	 <4DABF194.4010603@fusionio.com> <1303115157.3981.198.camel@sli10-conroe>
	 <20110422225704.GA1576@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Apr 2011 09:01:59 +0800
Message-ID: <1303693319.3981.272.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-23 at 06:57 +0800, Tejun Heo wrote:
> Hello,
> 
> On Mon, Apr 18, 2011 at 04:25:57PM +0800, Shaohua Li wrote:
> > then why requeue adds request at head? we could have the similar issue.
> 
> SCSI doesn't seem to do it anymore but it used to cache scmd at
> rq->special over requeues so that it doesn't have to re-initialize
> requests across requeues, which means that unprepped request getting
> ahead of requeued ones may lead to deadlock due to resource
> starvation, so that's why requeue uses front queueing.
> 
> The code changed over time and the above requirement might not be
> necessary at this point.  I don't know.  However, block layer doesn't
> have any method to enforce that requests can't hold any extra resource
> on requeue and having such difficult to trigger deadlock condition
> dormant is scary.
> 
> What kind of benchmarking are we talking about on which kernel?
> blk-flush support has been revamped twice recently.  2.6.38 stripped
> out the block layer barrier thing and then it got re-reimplemented for
> 2.6.39 to support advanced flush merging.  If the regression (for
> which benchmark btw?) was visible on the older reimplementation, I'd
> really like to know how it behaves on 2.6.39-rcX.
> 
> If the problem is localized to 2.6.38, oh well, too bad, but I don't
> think we care too much.  If some distro is basing their kernel on
> 2.6.38 and the flush regression is hurting them, backporting the new
> implementation from 2.6.39 shouldn't be too difficult after all.  The
> reimplementation was almost self-contained.
> 
> If the regression affects 2.6.39 implementation too, eh well, we need
> to think of something, but I'd really like to know what kind of
> workload we're talking about.
> 
> > I'll look at this. Optimizing this one should fix the regression too. On
> > the other hand, adding flush request at head if it just follows a flush
> > still has its advantage, because drive cache is already flushed out.
> 
> New implementation wouldn't issue two flushes back to back like that,
> it doesn't make any sense to begin with.  Again, what have you been
> testing and how?
Hi Tejun,
this is a regression from 2.6.39-rc2 compared to 2.6.39-rc1, so this
isn't related to the flush rewritten. Workload is sysbench fileio,
please see the first mail at the thread for detail.

Thanks,
Shaohua

