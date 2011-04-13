Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab1DMBBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 21:01:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:56032 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372Ab1DMBBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 21:01:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,200,1301900400"; 
   d="scan'208";a="418173282"
Subject: Re: [PATCH 3/4]percpu_counter: fix code for 32bit systems
From: Shaohua Li <shaohua.li@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "tj@kernel.org" <tj@kernel.org>
In-Reply-To: <1302599035.3233.27.camel@edumazet-laptop>
References: <1302595444.3981.129.camel@sli10-conroe>
	 <1302599035.3233.27.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 09:01:05 +0800
Message-ID: <1302656465.3981.133.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 17:03 +0800, Eric Dumazet wrote:
> Le mardi 12 avril 2011 à 16:04 +0800, Shaohua Li a écrit :
> > percpu_counter.counter is a 's64'. Accessing it in 32-bit system is racing.
> > we need some locking to protect it otherwise some very wrong value could be
> > accessed.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > ---
> >  include/linux/percpu_counter.h |   43 +++++++++++++++++++++++++++++++----------
> >  1 file changed, 33 insertions(+), 10 deletions(-)
> > 
> > Index: linux/include/linux/percpu_counter.h
> > ===================================================================
> > --- linux.orig/include/linux/percpu_counter.h	2011-04-12 15:48:44.000000000 +0800
> > +++ linux/include/linux/percpu_counter.h	2011-04-12 15:48:54.000000000 +0800
> > @@ -54,7 +54,15 @@ static inline s64 percpu_counter_sum(str
> >  
> >  static inline s64 percpu_counter_read(struct percpu_counter *fbc)
> >  {
> > +#if BITS_PER_LONG == 32
> > +	s64 count;
> > +	spin_lock(&fbc->lock);
> > +	count = fbc->count;
> > +	spin_unlock(&fbc->lock);
> > +	return count;
> > +#else
> >  	return fbc->count;
> > +#endif
> >  }
> >  
> 
> Hmm... did you test this with LOCKDEP on ?
> 
> You add a possible deadlock here.
> 
> Hint : Some percpu_counter are used from irq context.
there are some places we didn't disable interrupt, for example
percpu_counter_add. So the API isn't irq safe to me.

> This interface assumes caller take the appropriate locking.
no comments say this, and some places we don't hold locking.
for example, meminfo_proc_show.

