Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab0EQTCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:02:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:11756 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab0EQTCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:02:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,248,1272870000"; 
   d="scan'208";a="799226214"
Message-Id: <20100517182726.089700767@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 17 May 2010 11:27:26 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: [patch 0/7] sched: change nohz idle load balancing logic to push model
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of patchset which is posted earlier at
http://lkml.org/lkml/2009/12/10/470

Description:
Existing nohz idle load balance logic uses the pull model, with one
idle load balancer CPU nominated on any partially idle system and that
balancer CPU not going into nohz mode. With the periodic tick, the
balancer does the idle balancing on behalf of all the CPUs in nohz mode.

This is not very optimal and has few issues:
* the balancer will continue to have periodic ticks and wakeup
  frequently (HZ rate), even though it may not have any rebalancing to do on
  behalf of any of the idle CPUs.
* On x86 and CPUs that have APIC timer stoppage on idle CPUs, this periodic
  wakeup can result in an additional interrupt on a CPU doing the timer
  broadcast.

The alternative is to have a push model, where all idle CPUs can enter nohz
mode and any busy CPU kicks one of the idle CPUs to take care of idle
balancing on behalf of a group of idle CPUs.

Following patches switches idle load balancer to this push approach.

Updates from the previous version:

* Busy CPU uses send_remote_softirq() for invoking SCHED_SOFTIRQ on the
  idle load balancing cpu, which does the load balancing on behalf of
  all the idle CPUs.

* Dropped the per NUMA node nohz load balancing as it doesn't detect
  certain imbalance scenarios. This will be addressed later.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venki@google.com>

