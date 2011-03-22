Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1CVMrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:47:51 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41815 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1CVMru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:47:50 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V1 0/2] cpuidle: global registration of idle states with
	per-cpu statistics
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 22 Mar 2011 18:17:45 +0530
Message-ID: <20110322124724.29408.12885.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is an early RFC to discuss the feasibility of
avoiding registering of idle states from each cpu.

The core change is to split the cpuidle_device structure into parts
that can be global and parts that has to remain per-cpu.  The per-cpu
pieces are mostly generic statistics that can be independent of
current running driver.

Motivation:
* Simplify the cpuidle subsystem framework and have
  registration/unregistration done by single cpu.

* Minimise the data structure that needs to be maintained for multiple
  cpuidle drivers

* Reference: https://lkml.org/lkml/2011/2/10/37

Advantages:
* Make the cpuidle framework simple for most use cases where C-States
  are symmetric.  In case there are asymmetric C-States detected,
  fallback mechanism should be incorporated to maintain the system
  functional
  https://lkml.org/lkml/2011/2/10/257
  https://lkml.org/lkml/2011/2/10/37

* Non x86 archs that does not have asymmetric C-States like POWER, may
  not need the fallback mechanism and hence the framework will be
  simple for most use cases.

Disadvantages:
* Asymmetric C-States are part of x86 ACPI specification.  Incorrect
  handling may functionally affect the system

* Incorporating per-cpu masks for each state to allow/dis-allow global
  states on subset of CPUs may result in an implementation that is
  not better than current solution of having per-cpu states.

This patch series applies on top of the pm_idle cleanup patch
https://lkml.org/lkml/2011/3/22/150 (cpuidle: Cleanup pm_idle and 
include driver/cpuidle.c in-kernel)

This patch series is tested on x86 Nehalem system with multiple ACPI
C-States.

This patch series has limitations of not handling multiple driver
registration and switching between drivers on all CPUs mainly due to
incomplete handling of per-cpu enable/disable and driver_data.

Please let us know your comments and suggest possible approaches to
the problem.

---

Trinabh Gupta (2):
      cpuidle: API changes in callers using new cpuidle_state_stats
      cpuidle: Data structure changes for global cpuidle device


 drivers/acpi/processor_driver.c    |   19 +---
 drivers/acpi/processor_idle.c      |   45 ++++++----
 drivers/cpuidle/cpuidle.c          |  169 ++++++++++++++++++++++--------------
 drivers/cpuidle/cpuidle.h          |    4 -
 drivers/cpuidle/driver.c           |   24 -----
 drivers/cpuidle/governor.c         |   10 +-
 drivers/cpuidle/governors/Makefile |    2
 drivers/cpuidle/governors/menu.c   |   16 ++-
 drivers/cpuidle/sysfs.c            |   62 +++++++------
 drivers/idle/default_driver.c      |   39 +++-----
 include/linux/cpuidle.h            |   70 ++++++++++-----
 11 files changed, 245 insertions(+), 215 deletions(-)

--
-Trinabh
