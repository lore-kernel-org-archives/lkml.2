Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab1BHKsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:48:52 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:59554 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1BHKsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:48:51 -0500
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V3 0/3] cpuidle: Cleanup pm_idle and include
	driver/cpuidle.c in-kernel 
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 16:18:44 +0530
Message-ID: <20110208104713.9458.10698.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2 did not support architectures other than x86 that use pm_idle.
With this patch, architectures that use pm_idle (other than x86) can 
continue to do so and co-exist. They can be incrementally converted
to directly call into cpuidle instead of pm_idle pointer.

Changes in V3:

* Re-arranged code in driver/cpuidle.c to allow non-x86 architectures
  to continue to use pm-idle pointer until cpuidle.c is included into
  the kernel for those architectures.

* This patch series tries to maintain pm_idle pointer for non-x86
  archs so that the interface does not change at this point.  These
  archs can continue to set pm_idle=cpuidle_idle_call() if they want
  to use cpuidle or stick to the present boot process.

* After wider review and testing we could incrementally convert other
  archs (including arm, blackfin, cris, ia64, m32r, m68knommu, 
  microblaze, mn10300, sh, sparc) also to use cpuidle.c implicitly.

* This patch series applies on 2.6.37, and was tested on x86 system 
  with multiple sleep states. It was also compile tested on ARM, 
  boot tested on POWER6.

Goal:
This patch series tries to achieve the goal of having cpuidle manage
all idle routine for x86. It removes pm_idle function pointer which
causes problems as discussed at http://lkml.org/lkml/2009/8/28/43 and
http://lkml.org/lkml/2009/8/28/50.

V1 of this series is at https://lkml.org/lkml/2010/10/19/449
and V2 is at https://lkml.org/lkml/2011/1/13/98

ToDo:
* Force default idle for xen in xen/setup.c
* This series applies on 2.6.37, would have to be rebased to
2.6.38-rc3

---

Trinabh Gupta (3):
      cpuidle: default idle driver for x86
      cpuidle: list based cpuidle driver registration and selection
      cpuidle: Remove pm_idle pointer for x86


 arch/x86/kernel/process.c     |  340 -------------------------------
 arch/x86/kernel/process_32.c  |    4
 arch/x86/kernel/process_64.c  |    4
 arch/x86/xen/setup.c          |    1
 drivers/acpi/processor_idle.c |    2
 drivers/cpuidle/Kconfig       |    9 +
 drivers/cpuidle/cpuidle.c     |   43 +++-
 drivers/cpuidle/driver.c      |  112 ++++++++++
 drivers/idle/Makefile         |    2
 drivers/idle/default_driver.c |  453 +++++++++++++++++++++++++++++++++++++++++
 include/linux/cpuidle.h       |    3
 11 files changed, 613 insertions(+), 360 deletions(-)
 create mode 100644 drivers/idle/default_driver.c


--
Trinabh
