Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934281Ab1KJKxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 05:53:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39522 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab1KJKxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 05:53:04 -0500
Subject: Re: [PATCH RFC tip/core/rcu 19/28] nohz: Allow rcu extended
 quiescent state handling seperately from tick stop
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        Mike Frysinger <vapier@gentoo.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Date: Thu, 10 Nov 2011 11:52:06 +0100
In-Reply-To: <20111109164804.GA17538@somewhere.redhat.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
	 <1320265849-5744-19-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20111103040003.GE2042@leaf> <20111103115426.GD8198@somewhere.redhat.com>
	 <20111103133231.GA2287@linux.vnet.ibm.com> <20111103153102.GC18443@leaf>
	 <20111103160656.GC2287@linux.vnet.ibm.com>
	 <20111109164804.GA17538@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320922326.13800.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 17:48 +0100, Frederic Weisbecker wrote:
> > Having four API members rather than the current six does seem quite
> > attractive to me.  Frederic, any reason why this approach won't work?
> 
> The approach I took might sound silly but it's mostly an optimization:
> 
> I did the *_norcu() variant mostly to be able to keep rcu_idle_enter()
> call under the same local_irq_disable() section.
> 
> This way we can't have an interrupt in between that can needlessly perform
> RCU work (and trigger the softirq in the worst case), delaying the point
> where we actually put the CPU to sleep. 

I'm not sure I get what you're saying. A fully decoupled RCU/NO_HZ API
looks like:

  rcu_idle_enter();
  rcu_idle_exit();

  tick_nohz_idle_enter();
  tick_nohz_idle_exit();

And done you are, no funny interactions, 4 functions.

There is no _norcu variant simply because nohz will never touch rcu. If
you want the old coupled behaviour simply call both
tick_nohz_idle_enter() and rcu_idle_enter().


