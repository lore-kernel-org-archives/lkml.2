Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1BCKRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 05:17:48 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42751 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab1BCKRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 05:17:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JEepeFa07jrMTxxj5Dr+bAUfh+HzhdtybQgxxuSArKg+qP4twLSiP/MTkZ1vuOJhm/
         0baP7IF+hXCUPzMnHIETJoOzl2uqUQBNG0F9XWNVkyrStcPEeaSPTUxPIYBIAWKNIsHM
         usQSqVCB3jKcRB9IHfpNnXID8uK6VAnzCATmE=
Date: Thu, 3 Feb 2011 18:17:39 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression: WARNINGS and lockdep spews in 2.6.38-rc3+
 (bisected).
Message-ID: <20110203101739.GA1551@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110203031943.GA8910@elliptictech.com>
 <20110203091227.GA1603@zhy>
 <1296725440.26581.354.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1296725440.26581.354.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 10:30:40AM +0100, Peter Zijlstra wrote:
> On Thu, 2011-02-03 at 17:12 +0800, Yong Zhang wrote:
> >  #ifdef CONFIG_LOCKDEP
> > +       unsigned long flags;
> > +
> >         local_bh_disable();
> >         lock_map_acquire(&timer->lockdep_map);
> >         lock_map_release(&timer->lockdep_map);
> > -       local_bh_enable();
> > +       /* raw_local_irq_[save|restore] is to protect _local_bh_enable() */
> > +       raw_local_irq_save(flags);
> > +       _local_bh_enable();
> > +       raw_local_irq_restore(flags);
> >  #endif 
> 
> _why_ are you doing the raw_local_irq stuff? That's just weird, and that
> comment isn't helping.

Just to avoid trigger WARN_ON_ONCE(!irqs_disabled()) in __local_bh_enable(),

> 
> Also, calling _local_bh_enable() will leave pending softirqs, not
> particularly nice

Ah, indeed. That's bad.

Now I'm not sure how to work around this issue, because local_bh_enable()
and _local_bh_enable() are not suitable here.

Maybe we can introduce another type of local_bh_enable() in which
waking up ksoftirqd is forced if needed.

Thanks,
Yong
