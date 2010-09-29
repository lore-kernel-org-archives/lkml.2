Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab0I2Ad0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 20:33:26 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43436 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab0I2AdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 20:33:25 -0400
Date: Tue, 28 Sep 2010 17:33:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH RFC tip/core/rcu 0/3] v1 RCU priority boosting
Message-ID: <20100929003320.GA15904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch set is the first version of RCU priority boosting, consisting
of the following:

1.	Add RCU priority inversion testing to rcutorture.
2.	Move TINY_RCU grace-period processing from softirq to kthread
	to allow boosting.
3.	Implement RCU priority boosting for TINY_RCU.

This patch has the following shortcomings, and thus is not yet ready for
inclusion:

o	It does not yet include some restructuring of TREE_RCU that
	is required to make boosting practical.

o	It does not yet include boosting for TREE_RCU.

o	Documentation has not yet been updated.  In the meantime, it is
	important to note that the "rcu_kthread" process must have its
	priority set to at least SCHED_FIFO:2, given that rcutorture
	uses SCHED_FIFO:1 to do the testing.  This priority can be set
	using the new RCU_BOOST_PRIO kernel configuration parameter
	or by using the "chrt" command, for example, "chrt -p 2 6".

o	A great deal more testing is required.

o	There are probably quite a few bugs remaining, even in the parts
	done thus far.

							Thanx, Paul

 b/include/linux/init_task.h |    9 +
 b/include/linux/rcupdate.h  |    1 
 b/include/linux/rcutiny.h   |    8 -
 b/include/linux/rcutree.h   |    1 
 b/include/linux/sched.h     |   11 +
 b/init/Kconfig              |   39 ++++++
 b/kernel/rcutiny.c          |   71 +++++++++--
 b/kernel/rcutiny_plugin.h   |   15 +-
 b/kernel/rcutorture.c       |  270 ++++++++++++++++++++++++++++++++++++++++++--
 kernel/rcutiny.c            |   66 ++++------
 kernel/rcutiny_plugin.h     |  206 ++++++++++++++++++++++++++++++++-
 11 files changed, 608 insertions(+), 89 deletions(-)
