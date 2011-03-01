Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab1CAOgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:36:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:51084 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab1CAOgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:36:50 -0500
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
In-Reply-To: <20110301001300.GD2331@linux.vnet.ibm.com>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
	 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
	 <4D6765B6.1030401@cn.fujitsu.com>
	 <20110225203219.GD2269@linux.vnet.ibm.com>
	 <4D6B16A8.4050405@cn.fujitsu.com> <1298886437.2428.10174.camel@twins>
	 <20110301001300.GD2331@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 15:38:11 +0100
Message-ID: <1298990291.5226.870.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 16:13 -0800, Paul E. McKenney wrote:

> I am OK doing the sched_setscheduler_nocheck() in UP_PREPARE, correct?

Yeah, it should be perfectly fine to call that.

> Ah, there is the rub -- I am using wait_event(), so I need to wake up the
> kthread once before anyone uses it (or at least concurrently with anyone
> using it).  Which I can presumably do from the CPU_STARTING notifier.

Right, so your kthread is doing:

static int rcu_cpu_kthread()
{
  for (;;) {
    wait_event_interruptible();

    /* do stuff */

  }
  return 0;
}

Which means that all folks wanting to make use of this already need to
do a wakeup. So I don't see any reason to do that first wakeup from
CPU_STARTING.

wait_event() will only actually wait if the condition is false, in the
start-up case above it will find the condition true and fall right
through to do stuff.



