Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab1J1KuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 06:50:08 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:47718 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab1J1KuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 06:50:05 -0400
Subject: [PATCH v9 0/4] cpuidle: Global registration of idle states with
 per-cpu statistics
To: khilman@ti.com, venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        peterz@infradead.org, rjw@sisk.pl, santosh.shilimkar@ti.com,
        arjan@linux.intel.com, lenb@kernel.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: linux-pm@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 28 Oct 2011 16:19:55 +0530
Message-ID: <20111028104945.7520.83828.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 6 of this patch series dated 22nd Sept 2011 was 
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Kevin Hilman <khilman@ti.com> for OMAP specific parts.
Reviewed-by: Kevin Hilman <khilman@ti.com>
Tested-by: Jean Pihet <j-pihet@ti.com>

Hi Len, 
Can you please queue this series for the next mainline merge window by merging
it into your development tree and also linux-next for further testing.

I have also tested it by applying these patches on your ACPI tree hosted @github.

Thanks
-Deepthi

--

The following patch series implements global registration of cpuidle
states, and also has the necessary data structure changes to
accommodate the per-cpu writable members of the cpuidle_states
structure.

This patch series had been in discussion earlier and
following are the links to the previous discussions.

v8 --> https://lkml.org/lkml/2011/10/3/52
v7 --> https://lkml.org/lkml/2011/9/27/74 
v6 --> https://lkml.org/lkml/2011/9/22/58
v5 --> https://lkml.org/lkml/2011/6/6/259
v4 --> https://lkml.org/lkml/2011/4/28/312
v3 --> https://lkml.org/lkml/2011/2/8/73
v2 --> https://lkml.org/lkml/2011/1/13/98
v1 --> https://lkml.org/lkml/2011/3/22/161

Changes from previous version (v8):

   1. Rebased and tested on 3.1

Tests done:

    1. Compile tested for ARM using the following configs: da8xx_omapl_defconfig,
    kirkwood_defconfig, omap2plus_defconfig, at91rm9200_defconfig
      
    2. Boot tested on x86 nehalem with multiple C-states for both intel_idle
    and acpi_idle drivers.

    3. Boot tested on T60p thinkpad that has T2600 cpu with multiple C-states. 
    Also tested the case when there is dynamic changes in C-states 
    AC <-> Battery Power switch.

Brief description of the patches:

Core change in this series is to split the cpuidle_device structure 
into two parts, i.e  global and per-cpu basis. 

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

[4/4] - Most APIs will now need to pass pointer to both global
cpuidle_driver and per-cpu cpuidle_device structure.

 arch/arm/mach-at91/cpuidle.c          |   41 +++--
 arch/arm/mach-davinci/cpuidle.c       |   51 ++++---
 arch/arm/mach-exynos4/cpuidle.c       |   30 ++--
 arch/arm/mach-kirkwood/cpuidle.c      |   42 +++---
 arch/arm/mach-omap2/cpuidle34xx.c     |  133 +++++++++++------
 arch/sh/kernel/cpu/shmobile/cpuidle.c |   28 ++--
 drivers/acpi/processor_driver.c       |   20 ---
 drivers/acpi/processor_idle.c         |  251 +++++++++++++++++++++++++++------
 drivers/cpuidle/cpuidle.c             |   86 ++++-------
 drivers/cpuidle/driver.c              |   25 +++
 drivers/cpuidle/governors/ladder.c    |   41 ++++-
 drivers/cpuidle/governors/menu.c      |   29 ++--
 drivers/cpuidle/sysfs.c               |   22 ++-
 drivers/idle/intel_idle.c             |  130 +++++++++++++----
 include/acpi/processor.h              |    1 
 include/linux/cpuidle.h               |   52 ++++---
 16 files changed, 650 insertions(+), 332 deletions(-)


-- 

-Deepthi
