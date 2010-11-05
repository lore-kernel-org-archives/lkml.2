Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0KET7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 15:59:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752375Ab0KET7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 15:59:51 -0400
Date: Fri, 5 Nov 2010 12:58:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, fweisbec@gmail.com,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] watchdog:  touch_nmi_watchdog should only touch local
 cpu not every one
Message-Id: <20101105125855.20e5ce4c.akpm@linux-foundation.org>
In-Reply-To: <20101105135117.GA27712@swordfish.minsk.epam.com>
References: <1288919932-1857-1-git-send-email-dzickus@redhat.com>
	<20101105135117.GA27712@swordfish.minsk.epam.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Nov 2010 15:51:18 +0200
Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> On (11/04/10 21:18), Don Zickus wrote:
> >  void touch_nmi_watchdog(void)
> >  {
> > +	/*
> > +	 * Using __raw here because some code paths have
> > +	 * preemption enabled.  If preemption is enabled
> > +	 * then interrupts should be enabled too, in which
> > +	 * case we shouldn't have to worry about the watchdog
> > +	 * going off.
> > +	 */
> > +	__raw_get_cpu_var(watchdog_nmi_touch) = true;
> > +
> > +	touch_softlockup_watchdog();
> > +}
> > +EXPORT_SYMBOL(touch_nmi_watchdog);
> > +
> > +void touch_all_nmi_watchdogs(void)
> > +{
> >  	if (watchdog_enabled) {
> >  		unsigned cpu;
> >  
> > @@ -151,7 +166,7 @@ void touch_nmi_watchdog(void)
> >  	}
> >  	touch_softlockup_watchdog();
> >  }
> > -EXPORT_SYMBOL(touch_nmi_watchdog);
> > +EXPORT_SYMBOL(touch_all_nmi_watchdogs);
> >  
> 
> Hello,
> Seems like no one is actually calling touch_all_nmi_watchdogs, as for now. 
> Right?

Yes, there doesn't seem a lot of point in adding the interface unless
we have callers.

> 
> Minor nit
> 
> 	touch_all_nmi_watchdogs:
> 	...
> 	for_each_present_cpu(cpu) {
> 		if (per_cpu(watchdog_nmi_touch, cpu) != true)
> 			per_cpu(watchdog_nmi_touch, cpu) = true;
> 	}
> 
> 
> which is, I belive, could be simplified to 
> 	for_each_present_cpu(cpu) {
> 		per_cpu(watchdog_nmi_touch, cpu) = true;
> 	}

We sometimes do this trick to avoid dirtying lots of cachelines which
already held the correct value.  It'll be extra-benefical when dealing
with other CPU's data, I expect.
