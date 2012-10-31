Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001Ab2JaDqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 23:46:04 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56207 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab2JaDqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 23:46:01 -0400
Date: Tue, 30 Oct 2012 20:45:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        joe.korty@ccur.com
Subject: [PATCH tip/core/rcu 0/2] v2 Add callback-free CPUs
Message-ID: <20121031034552.GA1999@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103103-5406-0000-0000-000001924F5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

RCU callback execution can add significant OS jitter and also can
degrade scheduling latency.  This commit therefore adds the ability
for selected CPUs ("rcu_nocbs=" boot parameter) to have their callbacks
offloaded to kthreads, inspired by Joe Korty's and Jim Houston's JRCU.
If the "rcu_nocb_poll" boot parameter is also specified, these kthreads
will do polling, removing the need for the offloaded CPUs to do wakeups.
At least one CPU must be doing normal callback processing: currently CPU
0 cannot be selected as a no-CBs CPU.  In addition, attempts to offline
the last normal-CBs CPU will fail.

Changes since v1 (https://lkml.org/lkml/2012/9/5/572):

1.	Contains fixes for a few problems located by Fengguang Wu's
	kbuild test robot.
2.	Counters are now atomic_long_t rather than atomic_t, as
	suggested by Peter Zijlstra.
3.	The rcu_nocbs= kernel boot parameter is now documented.
4.	Fixed a bug introduced by commit c96ea7cf (Avoid spurious
	RCU CPU stall warnings) that resulted in boot-time NULL-pointer
	dereferences (reported by Paul Gortmaker).
4.	Account for normal and offloaded callbacks separately, so that
	offloading is represented in debugfs output.

The patches in this series are as follows:

1.	Offload RCU callbacks based on boot-time kernel parameter.
2.	Account for normal and offloaded callbacks separately, so that
	offloading is represented in debugfs output.

							Thanx, Paul

 b/Documentation/kernel-parameters.txt |    5 
 b/include/trace/events/rcu.h          |    1 
 b/init/Kconfig                        |   19 +
 b/kernel/rcutree.c                    |   63 ++++-
 b/kernel/rcutree.h                    |   48 ++++
 b/kernel/rcutree_plugin.h             |  399 +++++++++++++++++++++++++++++++++-
 b/kernel/rcutree_trace.c              |   12 -
 7 files changed, 528 insertions(+), 19 deletions(-)

