Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1DTGz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 02:55:26 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39829 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab1DTGzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 02:55:24 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V3 0/4] cpuidle: global registration of idle states with
	per-cpu statistics
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        venki@google.com, ak@linux.intel.com, len.brown@intel.com
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-omap@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Wed, 20 Apr 2011 12:25:15 +0530
Message-ID: <20110420065445.332.13688.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This patch series along with Len Brown's pm_idle() cleanup 
(ref:https://lkml.org/lkml/2011/4/2/8) will simplify the cpuidle framework 
and make it easy to port to other architectures like POWER.

References: 
https://lkml.org/lkml/2011/2/10/37
https://lkml.org/lkml/2011/3/25/52

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

Version 1 is at https://lkml.org/lkml/2011/3/22/161
Version 2 is at https://lkml.org/lkml/2011/4/11/32

Changes from V2:

1. Enabled global registration for arm at91_idle_driver,
  davinci_idle_driver, kirkwood_idle_driver, omap3_idle_driver cpuidle
  drivers. Enabled global registration for x86 intel_idle_driver also.

2. Made ladder governor follow new changed API. Thus both menu and ladder
  governors work with these changes.

This patch series applies on top of 2.6.39-rc2 and is tested on x86 Nehalem 
system with multiple ACPI C-States with both acpi_idle and intel_idle
cpuidle drivers. Note that this code is not tested for arm yet.

Thanks,
-Trinabh
