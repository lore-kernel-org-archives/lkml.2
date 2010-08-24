Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab0HXLuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 07:50:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58539 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0HXLuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 07:50:11 -0400
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time
 accounting
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: Venkatesh Pallipadi <venki@google.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
In-Reply-To: <20100824113801.GO4684@balbir.in.ibm.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
	 <20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
	 <AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
	 <20100722131239.208d9501@mschwide.boeblingen.de.ibm.com>
	 <AANLkTim==2J3Fo8Axz0yLvpfWf1bq_e0c0EYWi6y3xRe@mail.gmail.com>
	 <1282636286.2605.2307.camel@laptop>
	 <20100824080515.GK4684@balbir.in.ibm.com>
	 <1282640953.2605.2428.camel@laptop>
	 <20100824113801.GO4684@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 24 Aug 2010 13:49:51 +0200
Message-ID: <1282650591.2605.2621.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 17:08 +0530, Balbir Singh wrote:
> * Peter Zijlstra <peterz@infradead.org> [2010-08-24 11:09:13]:

> > The whole attribution mess can only be solved by actually splitting out
> > the entries that do work, like per-cgroup workqueue threads and similar
> > things.
> > 
> > System wide entities like IRQs are very hard to attribute correctly like
> > Martin already argued, and I don't think its worth doing.
> 
> I see Martin's view point, is the suggestion then that we amortize
> these costs across all tasks?

I'm still not sure what you want them for, but if its for wanting to
know wth the system is up to, simply account them on their own, and not
include them in any task stats.

That is, keep the existing hi/si interface and improve upon that, but
also subtract those times from the task execution times.

That way, if a cpu is like 80% hogged by IRQ action, you'll not see a
100% busy task, but only a 20%.

At that point you can also feed the IRQ time back into
sched_rt_avg_update() (which strictly speaking isn't rt but !fair), and
the load-balancer will automagically try and move tasks away from that
cpu.

If you really want to account (and possibly control) all the work
belonging to a particular group you'll have to make sure work does
indeed stay within the group -- which is where per-cgroup workqueue
threads and per-cgroup softirq threads etc. come into play.

Lumping all work together and then trying to extract something again is
silly.

And hardirq time really is system time, not cgroup or task time.
