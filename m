Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0JBK3n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 06:29:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:33091 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab0JBK3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 06:29:42 -0400
Subject: Re: [PATCH 1/7] si time accounting accounts bh_disable'd time to
 si -v3
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <AANLkTinEN8i=Tx-CrdVzv-FGJH5jXaxwsPm-GDf-M_hi@mail.gmail.com>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	 <1285788096-29471-2-git-send-email-venki@google.com>
	 <1285844662.2144.9.camel@laptop>
	 <AANLkTinEN8i=Tx-CrdVzv-FGJH5jXaxwsPm-GDf-M_hi@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 02 Oct 2010 01:16:46 +0200
Message-ID: <1285975006.2144.67.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-30 at 09:26 -0700, Venkatesh Pallipadi wrote:
> > One nit: in_serving_softirq() doesn't seem right as either:
> >
> >  - we're not accounting ksoftirq in it, or
> >  - we're are and VIRT_CPU_ACCOUNTING is again broken ;-)
> >
> > So only the softirq from irq tails wants to have SOFTIRQ_OFFSET set, the
> > ksoftirqd stuff can be tested for using PF_flags or something (ksoftirq
> > doesn't currently have a PF_SOFTIRQ flag, but -rt does and we could
> > bring that over).
> >
> 
> The problem is that ksoftirqd is also handling softirq's and some
> eventual users of in_serving_softirq (like the network code in this
> patch) want to differentiate between whether it is the softirq thats
> running or some real process (!ksoftirqd) context.

The make in_serving_softirq() be something like:
  (preempt_count() & SOFTIRQ_OFFSET) || (current->flags & PF_SOFTIRQ)


> Also, ksoftirqd adds to softirq counts, does trace softirq, etc. So,
> it kind of made sense to add the time also to softirq stats as well.
> If we dont account time to softirq stats, then if some user is looking
> at say time per softirq using the softirq count will be misled. No?

Simply add back the task accounting when you report it?

> In the other thread you mentioned doing that will cause problems. Were
> you thinking of scheduler issues or are there other problems charging
> softirq time this way?

Of course there are.. you're double accounting the time of ksoftirqd,
and worse, you're adding that back into the equation as part of the !
sched_fair time.
