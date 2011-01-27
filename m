Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1A0CT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 21:19:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58558 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1A0CT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 21:19:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 27 Jan 2011 11:13:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [BUGFIX v2] memcg: fix res_counter_read_u64 lock aware (Was Re:
 [PATCH] oom: handle overflow in mem_cgroup_out_of_memory()
Message-Id: <20110127111350.cc5b3111.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110126175722.01b0db3a.akpm@linux-foundation.org>
References: <1296030555-3594-1-git-send-email-gthelen@google.com>
	<20110126170713.GA2401@cmpxchg.org>
	<xr93y667lgdm.fsf@gthelen.mtv.corp.google.com>
	<20110126183023.GB2401@cmpxchg.org>
	<xr9362tbl83f.fsf@gthelen.mtv.corp.google.com>
	<20110126142909.0b710a0c.akpm@linux-foundation.org>
	<20110127092434.df18c7a6.kamezawa.hiroyu@jp.fujitsu.com>
	<20110127095342.3d81cf5f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110127104339.0f580bac.kamezawa.hiroyu@jp.fujitsu.com>
	<20110126175722.01b0db3a.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011 17:57:22 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 27 Jan 2011 10:43:39 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > --- mmotm-0125.orig/kernel/res_counter.c
> > +++ mmotm-0125/kernel/res_counter.c
> > @@ -126,10 +126,24 @@ ssize_t res_counter_read(struct res_coun
> >  			pos, buf, s - buf);
> >  }
> >  
> > +#if BITS_PER_LONG == 32
> > +u64 res_counter_read_u64(struct res_counter *counter, int member)
> > +{
> > +	unsigned long flags;
> > +	u64 ret;
> > +
> > +	spin_lock_irqsave(&counter->lock, flags);
> > +	ret = *res_counter_member(counter, member);
> > +	spin_unlock_irqrestore(&counter->lock, flags);
> > +
> > +	return ret;
> > +}
> > +#else
> >  u64 res_counter_read_u64(struct res_counter *counter, int member)
> >  {
> >  	return *res_counter_member(counter, member);
> >  }
> > +#endif
> 
> _irqsave is only needed if the lock will be taken from irq context. 
> Does that happen?
> 
I just obey current desing of res_counter, as bugfix.
This counter is designed to be safe against irq context.
Adding CC: to Balbir.

To be honest, it has never happened since res_counter is introduced. I imagine
there was a big plan when this counter was designed. But I think it will 
be never called other than memcg because cpu, blkio controller haven't
use res_counter, finally. And memcg tends to use per-cpu counter because of
performance.

If I need to remove irq flags from this function, I'll do in another patch
which changes total design of res_counter and make it not safe agaisnt irq context.

Thanks,
-Kame

