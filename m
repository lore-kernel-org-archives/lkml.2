Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2BCBNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 20:13:37 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60871 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550Ab2BCBNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 20:13:32 -0500
Date: Thu, 2 Feb 2012 17:12:08 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH RFC 0/3] Fix cpuidle_idle_call() RCU usage
Message-ID: <20120203011208.GA2004@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020301-7182-0000-0000-000000A9C0D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series is a second attempt to fix the idle-loop uses of RCU,
see https://lkml.org/lkml/2012/2/1/741 for v1.  Where the first series
attempted to drive rcu_idle_enter() and rcu_idle_exit() further down
into the Linux kernels multitude of idle loops, this patch instead
marks specific idle-loop operations containing RCU read-side critical
sections, as suggested by Nicolas Pitre and Steven Rostedt.  The possibility
of code shared between idle and non-idle also requires the ability to nest
rcu_idle_enter() calls.  The individual patches are as follows:

1.	Allow nesting of rcu_idle_enter() and rcu_idle_exit().
2.	Add an RCU_NONIDLE() macro to enclose idle-loop code that
	contains RCU read-side critical sections.
3.	Use RCU_NONIDLE() to protect cpuidle_idle_call()'s tracepoints.

This patchset has the distinct advantage of avoiding touching any
architecture-specific code.  ;-)

							Thanx, Paul

------------------------------------------------------------------------

 b/drivers/cpuidle/cpuidle.c |   12 ++++++++----
 b/include/linux/rcupdate.h  |   27 +++++++++++++++++++++++++++
 b/kernel/rcu.h              |   18 +++++++++++++++++-
 b/kernel/rcutiny.c          |   16 ++++++++++++----
 b/kernel/rcutree.c          |   19 +++++++++++++------
 kernel/rcutiny.c            |    2 ++
 kernel/rcutree.c            |    2 ++
 7 files changed, 81 insertions(+), 15 deletions(-)

