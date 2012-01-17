Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab2AQR7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:59:19 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:61655 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2AQR7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:59:18 -0500
Date: Tue, 17 Jan 2012 12:59:10 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: cfq crashing on boot with CONFIG_DEBUG_PAGE_ALLOC (linus master)
Message-ID: <20120117175910.GA3658@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120117161024.GC30322@shiny>
 <20120117173500.GA6762@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117173500.GA6762@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F15B6F2.0029,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 09:35:00AM -0800, Tejun Heo wrote:
> On Tue, Jan 17, 2012 at 11:10:24AM -0500, Chris Mason wrote:
> > Hi everyone,
> > 
> > Looks like cfq is using stale pages, I'm getting crashes on boot with
> > CONFIG_DEBUG_PAGE_ALLOC enabled.  The oops leads to crashing in
> > cfqq_type, and if you add some fuzz for inlining, it looks like we're
> > here:
> > 
> > (gdb) list *cfq_insert_request+0x3f5
> > 0xffffffff812683d8 is in cfq_insert_request (block/cfq-iosched.c:3131).
> > 3126	
> > 3127		/*
> > 3128		 * workload type is changed, don't save slice, otherwise preempt
> > 3129		 * doesn't happen
> > 3130		 */
> > 3131		if (cfqq_type(old_cfqq) != cfqq_type(cfqq))
> > 3132			cfqq->cfqg->saved_workload_slice = 0;
> > 3133	
> > 3134		/*
> > 3135		 * Put the new queue at the front of the of the current list,
> > 
> > It seems like the most likely reason is that old_cfqq was previously
> > freed:
> > 
> >         struct cfq_queue *old_cfqq = cfqd->active_queue;
> 
> Does the following patch resolve the problem?
> 
>   http://article.gmane.org/gmane.linux.kernel.next/20340/raw

Sorry, same oops with this applied.

-chris

