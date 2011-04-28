Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694Ab1D1QcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:32:20 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:52405 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760363Ab1D1QcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:32:17 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V4 0/4] cpuidle: global registration of idle states with
	per-cpu statistics
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        khilman@ti.com
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Thu, 28 Apr 2011 22:02:10 +0530
Message-ID: <20110428163201.4868.6984.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series implements global registration of cpuidle
states, and also has the necessary data structure changes to
accommodate the per-cpu writable members of the cpuidle_states
structure.

Previous version of the series (V3) is at 
https://lkml.org/lkml/2011/4/20/23

This series applies on 2.6.39-rc5 with Len Brown's pm_idle() cleanup
version 3 (https://lkml.org/lkml/2011/4/2/8) plus the patch 
https://lkml.org/lkml/diff/2011/4/25/54/1

Changes from previous version (V3):

1. Compile tested for ARM using the following configs: da8xx_omapl_defconfig,
  kirkwood_defconfig, stamp9g20_defconfig, omap2plus_defconfig. Boot tested on
  Panda SoC (OMAP4430) but it doesn't really use cpuidle.

2. Boot tested on x86 nehalem with multiple C-states for both intel_idle
  and acpi_idle drivers. 

3. Boot tested on T60p thinkpad that has T2600 cpu with multiple C-states.
  Additionally tested the case when C-state tables change on 
  AC <-> Battery power switch.

4. De-duplicated code in [1/4] and moved common code related to
  update of cpuidle statistics to drivers/cpuidle/cpuidle.c

5. Handled the case when acpi_processor_cst_has_changed() is called on x86
  on switching power from AC <-> Battery. The implementation is just 
  a prototype. Please provide suggestions.


Brief description of the patches:

The core change in this series is to split the cpuidle_device structure 
into parts that can be global and parts that has to remain per-cpu. 
The per-cpu pieces are mostly generic statistics that can be independent 
of current running driver. As a result of these changes, there is single 
copy of cpuidle_states structure and single registration done by one 
cpu. The low level driver is free to set per-cpu driver data on
each cpu if needed using the cpuidle_set_statedata() as the case
today. Only in very rare cases asymmetric C-states exist which can be 
handled within the cpuidle driver. Most architectures do not have 
asymmetric C-states.

First two patches in the series facilitate splitting of cpuidle_states
and cpuidle_device structure and next two patches do the actual split,
change the API's and make existing code follow the changed API.

[1/4] - Move the idle residency accounting part from cpuidle.c to
  the respective low level drivers, so that the accounting can
  be accurately maintained if the driver decides to demote the
  chosen (suggested) by the governor.

[2/4] - removes the cpuidle_device()->prepare API since is is not
  widely used and the only use case was to allow software
  demotion using CPUIDLE_FLAG_IGNORE flag.  Both these
  functions can be absorbed within the cpuidle back-end
  driver ad hence deprecating the prepare routine and the
  CPUIDLE_FLAG_IGNORE flag.

  - Ref: https://lkml.org/lkml/2011/3/25/52

[3/4] - Splits the usage statistics (read/write) part out of
  cpuidle_state structure, so that the states can become read
  only and hence made global.

[4/4] - most APIs will now need to pass pointer to both global
   cpuidle_driver and per-cpu cpuidle_device structure.

Thanks,
-Trinabh
