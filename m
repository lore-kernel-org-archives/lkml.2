Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005Ab2IFU7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:59:20 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59047 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759932Ab2IFU7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:59:18 -0400
Date: Thu, 6 Sep 2012 13:58:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 03/15] rcu: Properly initialize
 ->boost_tasks on CPU offline
Message-ID: <20120906205856.GA2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346942438.18408.27.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346942438.18408.27.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090620-5112-0000-0000-00000BF67CD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 04:40:38PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-08-30 at 11:56 -0700, Paul E. McKenney wrote:
> > When rcu_preempt_offline_tasks() clears tasks from a leaf rcu_node
> > structure, it does not NULL out the structure's ->boost_tasks field.
> > This commit therefore fixes this issue. 
> 
> What would have been the side-effects of this? Would rcu-boosting have
> been able to go funny on hotplug, and if so, how?

In some circumstances, this could prevent any future RCU boosting.
The ->boost_tasks field would be non-NULL, so it wouldn't ever try
boosting again, having been fooled into thinking that the previous
boost attempt was still in progress.

The expected segfault is prevented by the fact that an attempt to
initiate a boost first checks for ->boost_tasks being non-NULL,
and if so, declines to wake up the RCU-boost kthread.

							Thanx, Paul

