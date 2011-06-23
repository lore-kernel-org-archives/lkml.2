Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab1FWKPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 06:15:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60495 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759194Ab1FWKPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 06:15:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TEwyA88kA0U0TuYGqsjlAV58cBbyb1ziWnk+xgkpP7ide82X/WqT6oq3yfXZcWqnHC
         jBEL9xvm6elzBKq6C/zFpq2TFHPck/S9XfOV28NHFU36zAoPFSMcIaIazbUHJavoTzFw
         /k2g2Q8E0XYXT5IyQbN2tGPR9YIDpzDM5cIUA=
Date: Thu, 23 Jun 2011 12:15:41 +0200
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] sched: Distangle worker accounting from rq->lock
Message-ID: <20110623101541.GL30101@htj.dyndns.org>
References: <20110622174659.496793734@linutronix.de>
 <20110622174919.135236139@linutronix.de>
 <20110623083722.GF30101@htj.dyndns.org>
 <alpine.LFD.2.02.1106231139270.11814@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1106231139270.11814@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 23, 2011 at 11:58:12AM +0200, Thomas Gleixner wrote:
> > Well, not exactly.  If CPU is being thrashed, we don't want to try to
> > fire up new workers or calling in rescuers.  If nr_running is bumped
> > up from ttwu(), a woken up but not yet running worker already counts
> > as running.  With the suggested change, when we hit such heavy CPU
> > thrashing, workqueue code will add things on top of it.
> 
> That's the whole problem with that self forking workqueue stuff and
> I'm not accepting that ttwu() is the only solution to that. Following
> that logic would just invite more abusers of callbacks into ttwu() and
> if you think it through then the logical consequence is to have an
> upcall hook into userspace so a threading/forking server knows how
> many instances are on the fly to avoid creating new ones under
> pressure.

Extrapolating to extremes doesn't really help anything.  You can make
any argument with logics like that.  The thing isn't being exported to
userland, not even close.

The patch description is simply untrue.  It does affect how wq behaves
under heavy CPU load.  The effect might be perfectly okay but more
likely it will result in subtle suboptimal behaviors under certain
load situations which would be difficult to characterize and track
down.  Again, the trade off (mostly killing of ttwu_local) could be
okay but you can't get away with just claiming "there's no harm".

Thanks.

-- 
tejun
