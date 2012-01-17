Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab2AQRfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:35:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48412 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2AQRfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:35:05 -0500
Date: Tue, 17 Jan 2012 09:35:00 -0800
From: Tejun Heo <tj@kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: cfq crashing on boot with CONFIG_DEBUG_PAGE_ALLOC (linus
 master)
Message-ID: <20120117173500.GA6762@google.com>
References: <20120117161024.GC30322@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117161024.GC30322@shiny>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 11:10:24AM -0500, Chris Mason wrote:
> Hi everyone,
> 
> Looks like cfq is using stale pages, I'm getting crashes on boot with
> CONFIG_DEBUG_PAGE_ALLOC enabled.  The oops leads to crashing in
> cfqq_type, and if you add some fuzz for inlining, it looks like we're
> here:
> 
> (gdb) list *cfq_insert_request+0x3f5
> 0xffffffff812683d8 is in cfq_insert_request (block/cfq-iosched.c:3131).
> 3126	
> 3127		/*
> 3128		 * workload type is changed, don't save slice, otherwise preempt
> 3129		 * doesn't happen
> 3130		 */
> 3131		if (cfqq_type(old_cfqq) != cfqq_type(cfqq))
> 3132			cfqq->cfqg->saved_workload_slice = 0;
> 3133	
> 3134		/*
> 3135		 * Put the new queue at the front of the of the current list,
> 
> It seems like the most likely reason is that old_cfqq was previously
> freed:
> 
>         struct cfq_queue *old_cfqq = cfqd->active_queue;

Does the following patch resolve the problem?

  http://article.gmane.org/gmane.linux.kernel.next/20340/raw

Thanks.

-- 
tejun
