Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0ITJ1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 05:27:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53840 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab0ITJ1j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 05:27:39 -0400
Subject: Re: [PATCH 2/6] Add IRQ_TIME_ACCOUNTING, finer accounting of CPU
 irq time
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>
In-Reply-To: <20100920092734.3f46af9f@mschwide.boeblingen.de.ibm.com>
References: <1284688596-6731-1-git-send-email-venki@google.com>
	 <1284688596-6731-3-git-send-email-venki@google.com>
	 <1284895291.2275.617.camel@laptop> <1284897666.2275.638.camel@laptop>
	 <20100920092734.3f46af9f@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Sep 2010 11:27:30 +0200
Message-ID: <1284974850.2275.682.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 09:27 +0200, Martin Schwidefsky wrote:

> > OK, so by virtue of calling the same function on _enter and _exit its
> > not incomplete, just weird.
> 
> That is the same with CONFIG_VIRT_CPU_ACCOUNTING=y. irq_enter/irq_exit
> call account_system_vtime, the function then uses the preempt/softirq/
> hardirq counter to find out which context is currently active.

Yeah, I realized that eventually, I've so far been able to mostly ignore
all that VIRT_CPU_ACCOUNTING muck.

> > And it won't account time double, since it uses irq_start_time to
> > compute deltas between invocations and will attribute that delta to only
> > one state.
> 
> irq_start_time is a bit misleading, it is a time stamp of the last update.
> The confusing part (which deserves a comment) is the fact that the delta
> is not added to anything if hardirq_count and softirq_count are zero.

Yeah, the name didn't help either, but I really expected to see two
hooks: start/exit, I did eventually figure it all out, but its a bit
daft.

If you would have had 4 hooks, the below problem would have been fixable
within the implementation.

> > You still do have the problem with local_bh_disable() though, since you
> > cannot distinguish between having bh disabled and processing softirq.
> > 
> > So a hardirq that hits while you have bh disabled will inflate your
> > softirq time.
> > 
> > A possible solution is to have local_bh_{disable,enable} {add,sub}
> > 2*SOFTIRQ_OFFSET and have the processing use SOFTIRQ_OFFSET, will need a
> > bit of a code shuffle though.
> 
> Hmm, that bug is valid for CONFIG_VIRT_CPU_ACCOUNTING=y as well.

And nobody ever noticed?
