Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1GULd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 07:33:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:41464 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab1GULd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 07:33:28 -0400
Subject: Re: [PATCH RFC] rtmutex: Permit rt_mutex_unlock() to be invoked
 with irqs disabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulmck@linux.vnet.ibm.com
Cc: tglx@linutronix.de, laijs@cn.fujitsu.com, darren@dvhart.com,
        rostedt@goodmis.org, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20110719201410.GA10553@linux.vnet.ibm.com>
References: <20110719201410.GA10553@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Jul 2011 13:32:48 +0200
Message-ID: <1311247968.29152.122.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 13:14 -0700, Paul E. McKenney wrote:
> Because rcu_read_unlock() can be invoked with interrupts disabled, it can
> in turn invoke rt_mutex_unlock() with interrupts disabled.  This situation
> results in lockdep splats (https://lkml.org/lkml/2011/7/7/362) because the
> rt_mutex structure's ->lock_wait is acquired elsewhere without disabling
> interrupts, which can result in deadlocks.
> 
> This commit therefore changes the rt_mutex structure's ->lock_wait
> acquisitions to disable interrupts.
> 
> An alternative fix is to prohibit invoking rcu_read_unlock() with
> interrupts disabled unless the entire preceding RCU read-side critical
> section has run with interrupts disabled.  However, there is already
> at least one case in mainline where this potential rule is violated,
> and there might well be many more.  These would likely be found one at
> a time using the lockdep-water-torture method, hence the alternative
> fix in the form of this commit.

Thomas, I'm inclined to merge this, any objections?
