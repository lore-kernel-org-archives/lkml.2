Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab1AMMvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 07:51:40 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35293 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab1AMMvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 07:51:37 -0500
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC V2 0/3] cpuidle: Cleanup pm_idle and include driver/cpuidle.c
	in-kernel 
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Date: Thu, 13 Jan 2011 18:21:30 +0530
Message-ID: <20110113125113.11174.78525.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core of the kernel's idle routine on x86 presently depends
on an exported pm_idle function pointer that is unmanaged.
The first problem is that this exported pointer can be modified
by any subsystem. There is no tracking or notification mechanism.
Secondly and more importantly, various subsystems save the value of
this pointer, flip it and later restore to the saved value. There is
no guarantee that the saved value is still valid. The problem has
been discussed at http://lkml.org/lkml/2009/8/28/43 and
http://lkml.org/lkml/2009/8/28/50.

This patch series tries to achieve the goal of having cpuidle manage
all idle routine management by doing the following changes:

* Remove pm_idle pointer from process_xx.c and implicitly call
  cpuidle.c:cpuidle_idle_call().

* Change select_idle_routine() in x86 bootup code to create
  a cpuidle_driver structure and register the routines with the
  cpuidle subsystem using a default_idle driver in 
  drivers/idle/default_driver.c

* The 'best' (current) cpuidle_driver is selected based
  on the priority that is supplied at the time of registration/
  unregistration.

* Arch supplied default idle (hlt or poll) is used during transitions.  

* List of cpuidle_drivers and their (per-cpu) cpuidle_devices are
  maintained in a doubly linked list to enable selection and unregistering 
  when not used. Previously cpuidle subsystem had only one set of
  cpuidle_driver and corresponding cpuidle_devices.

* Ideally we could have a single list of idle routines supplied by
  different modules and use a priority+governor to select the best.
  We could incrementally do this since we have a dependency: Only
  idle routines from a set (ACPI) should be used on all cpus and not
  a combination of say C1e on some cpus and ACPI routines on some
  other cpus.

This patch series applies on 2.6.37, and was tested on x86 system with
multiple sleep states. 

Request your comment on the general approach based on the discussion
in v1 (https://lkml.org/lkml/2010/10/19/449).

Changes from v1: cpuidle: add idle routine registration and cleanup 
pm_idle pointer

* v1 has registration mechanisms for single idle routines and expects
  cpuidle.c:cpuidle_idle_call() to take over for systems with multiple
  idle routines.

  While this series uses cpuidle.c:cpuidle_idle_call() as a means to
  invoke single idle routines as well as multiple idle routines. The 
  registration mechanism proposed in V1 is completely replaced by 
  cpuidle.c with added fields like 'priority'.

---

Trinabh Gupta (3):
      cpuidle: Default Idle Driver for x86
      cpuidle data structure changes, list based cpuidle driver registration
      cpuidle: Remove pm_idle pointer for x86


 arch/x86/kernel/process.c     |  340 -------------------------------
 arch/x86/kernel/process_32.c  |    4 
 arch/x86/kernel/process_64.c  |    4 
 arch/x86/xen/setup.c          |    1 
 drivers/acpi/processor_idle.c |    2 
 drivers/cpuidle/Kconfig       |    2 
 drivers/cpuidle/cpuidle.c     |   42 +---
 drivers/cpuidle/driver.c      |   68 +++++-
 drivers/cpuidle/governor.c    |   13 +
 drivers/idle/Makefile         |    2 
 drivers/idle/default_driver.c |  451 +++++++++++++++++++++++++++++++++++++++++
 include/linux/cpuidle.h       |    4 
 12 files changed, 543 insertions(+), 390 deletions(-)
 create mode 100644 drivers/idle/default_driver.c

-- 
-Trinabh
