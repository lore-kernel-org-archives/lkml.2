Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab0JRJP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 05:15:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:56604 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab0JRJP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:15:57 -0400
Subject: Re: [PATCH 8/8] Call tick_check_idle before __irq_enter
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20101017090545.GA3468@zhy>
References: <1286237003-12406-1-git-send-email-venki@google.com>
	 <1286237003-12406-9-git-send-email-venki@google.com>
	 <20101017090545.GA3468@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Oct 2010 11:15:27 +0200
Message-ID: <1287393327.29097.1542.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 17:05 +0800, Yong Zhang wrote:
> On Mon, Oct 04, 2010 at 05:03:23PM -0700, Venkatesh Pallipadi wrote:
> > diff --git a/kernel/softirq.c b/kernel/softirq.c
> > index 267f7b7..6bb7e19 100644
> > --- a/kernel/softirq.c
> > +++ b/kernel/softirq.c
> > @@ -296,10 +296,16 @@ void irq_enter(void)
> >  
> >  	rcu_irq_enter();
> >  	if (idle_cpu(cpu) && !in_interrupt()) {
> > -		__irq_enter();
> > +		/*
> > +		 * Prevent raise_softirq from needlessly waking up ksoftirqd
> > +		 * here, as softirq will be serviced on return from interrupt.
> > +		 */
> > +		local_bh_disable();
> >  		tick_check_idle(cpu);
> > -	} else
> > -		__irq_enter();
> > +		local_bh_enable();
> 
> 		_local_bh_enable()
> 
> local_bh_enable() could invoke do_softirq().

This seems to indeed cure that explosion.. Thanks!


