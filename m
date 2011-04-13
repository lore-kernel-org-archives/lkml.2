Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab1DMSkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:40:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60407 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671Ab1DMSkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:40:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NKpVQBs2tAZaebH4TwG9XwefMrStjTvBHAGDaS4NhjccxP9szAzU4U8++0HbBVqjWK
         gsO5OAPHQZzl7Rmg146fwmly4fFfLJSPJs6Ndm6Q8ZC5qJe3TWX2NKfZoQQtyBgoMjAP
         CdeH19T2i4s5Li2ltcRn3kpmIK6CYu7YZluIQ=
Date: Thu, 14 Apr 2011 03:39:55 +0900
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/21] sched: Change the ttwu success details
Message-ID: <20110413183955.GA3403@mtj.dyndns.org>
References: <20110405152338.692966333@chello.nl>
 <20110405152728.866866929@chello.nl>
 <1302686630.2388.125.camel@twins>
 <1302691703.2035.10.camel@laptop>
 <1302692799.2035.17.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302692799.2035.17.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Wed, Apr 13, 2011 at 01:06:39PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-04-13 at 12:48 +0200, Peter Zijlstra wrote:
> > Appears to be sufficient to cause the lockup, so somehow the whole
> > workqueue stuff relies on the fact that waking a TASK_(UN)INTERRUPTIBLE
> > task that hasn't been dequeued yet isn't a wakeup.
> > 
> > Tejun any quick clues as to why and how to cure this?
> > 
> > /me goes read that stuff
> 
> OK, so wq_worker_waking_up() does an atomic_inc() that wants to be
> balanced against the atomic_dec() in wq_worker_sleeping(), which is only
> called when we dequeue things.

Yeap, the root cause of the problem is that the change makes
wq_worker_sleeping() and wq_worker_waking_up() asymmetric and thus
puts the nr_running counter goes out of sync which hides active worker
depletion from the workqueue code leading to stall.

One way to deal with it would be adding an extra worker flag to track
sleep state from workqueue side so that it can filter out spurious
wakeups; however, I think it would be far better to resolve this from
scheduler side.  If the callback name is misleading, rename it to
wq_worker_sched_activated() or something and call it only when the
task gets activated.

Thanks.

-- 
tejun
