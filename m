Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2DTNGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:06:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:44753 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2DTNFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:05:54 -0400
Message-Id: <20120420122120.097464672@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I'm working on refactoring the SMP boot and CPU hotplug implementation.

The current code has evolved over time into a conglomerate of
warts. My main goals are to:

 - reduce the architecture code by moving repeating constructs to the
   core

 - redesigning the handling of per cpu threads. There is no point to
   tear down the threads just to create them again.

 - restructuring the notifier facility into a proper tree with
   dependencies to avoid the gazillion of callbacks and moving
   setup/teardown code into the context of the upcoming/dying cpu

The motivation behind this work is the cpu hotplug nightmare which we
are facing in the RT kernel and the requests from several groups
(e.g. ARM) to make hotplug more lightweight and faster.

This first part moves the idle thread management for non-boot cpus
into the core. fork_idle() is called in a workqueue as it is
implemented in a few architectures already. This is necessary when not
all cpus are brought up by the early boot code as otherwise we would
take a ref on the user task VM of the thread which brings the cpu up
via the sysfs interface.

This converts all architectures except m32r, mn10300, tile and UM to
the new core facility. These architecture are calling fork_idle() in
the very early boot code in smp_prepare_cpus() for unknown reasons.
I haven't analyzed yet, whether this is on purpose or can be moved
over to the generic facility. It'd be nice if the responsible maintainers
could look into that as well.

Thanks,

	tglx



