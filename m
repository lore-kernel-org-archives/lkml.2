Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab1IVTha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 15:37:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43131 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab1IVTh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 15:37:29 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.121.148]
In-Reply-To: <20110922082840.10520.85895.stgit@localhost6.localdomain6>
References: <20110922082840.10520.85895.stgit@localhost6.localdomain6>
Date: Thu, 22 Sep 2011 21:37:27 +0200
Message-ID: <CAORVsuWX6hQ9Zo_V8GFzzyOYziLmCtVz+DEpv+nqpF1WRPTWCg@mail.gmail.com>
Subject: Re: [RFC PATCH V6 0/4] cpuidle: Global registration of idle states
 with per-cpu statistics
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: khilman@ti.com, venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        peterz@infradead.org, santosh.shilimkar@ti.com, arjan@linux.intel.com,
        lenb@kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Sep 22, 2011 at 10:28 AM, Deepthi Dharwar
<deepthi@linux.vnet.ibm.com> wrote:
> The following patch series implements global registration of cpuidle
> states, and also has the necessary data structure changes to
> accommodate the per-cpu writable members of the cpuidle_states
> structure.
>
> This patch series had been in discussion earlier and
> following are the links to the previous discussions.
>
> v1 --> https://lkml.org/lkml/2011/3/22/161
> v2 --> https://lkml.org/lkml/2011/1/13/98
> v3 --> https://lkml.org/lkml/2011/2/8/73
> v4 --> https://lkml.org/lkml/2011/4/28/312
> v5 --> https://lkml.org/lkml/2011/6/6/259
>
> Changes from previous version (V5):
>
>    Rebased the series to 3.1-rc7
>
> Tests done:
>
>    1. Compile tested for ARM using the following configs: da8xx_omapl_defconfig,
>    exynos4_defconfig, kirkwood_defconfig, omap2plus_defconfig,
>    at91rm9200_defconfig

Tested OK on OMAP3:
Signed-off-by: Jean Pihet <j-pihet@ti.com>

>
>    2. Boot tested on x86 nehalem with multiple C-states for both intel_idle
>    and acpi_idle drivers.
>
>    3. Boot tested on T60p thinkpad that has T2600 cpu with multiple C-states.
>    Also tested the case when there is dynamic changes in C-states
>    AC <-> Battery Power switch.
>
> Brief description of the patches:
>
> Core change in this series is to split the cpuidle_device structure
> into two parts, i.e  global and per-cpu basis.
>
> The per-cpu pieces are mostly generic statistics that can be independent
> of current running driver. As a result of these changes, there is single
> copy of cpuidle_states structure and single registration done by one
> cpu. The low level driver is free to set per-cpu driver data on
> each cpu if needed using the cpuidle_set_statedata() as the case
> today. Only in very rare cases asymmetric C-states exist which can be
> handled within the cpuidle driver. Most architectures do not have
> asymmetric C-states.
>
> First two patches in the series facilitate splitting of cpuidle_states
> and cpuidle_device structure and next two patches do the actual split,
> change the API's and make existing code follow the changed API.
>
> [1/4] - Move the idle residency accounting part from cpuidle.c to
> the respective low level drivers, so that the accounting can
> be accurately maintained if the driver decides to demote the
> chosen (suggested) by the governor.
This is a nice improvement since OMAP heavily uses the state demotion
in the cpuidle driver, and will use it even more with the per-device
PM QoS support added.

Thanks & regards,
Jean

>
> [2/4] - removes the cpuidle_device()->prepare API since is is not
> widely used and the only use case was to allow software
> demotion using CPUIDLE_FLAG_IGNORE flag.  Both these
> functions can be absorbed within the cpuidle back-end
> driver ad hence deprecating the prepare routine and the
> CPUIDLE_FLAG_IGNORE flag.
>
>    - Ref: https://lkml.org/lkml/2011/3/25/52
>
> [3/4] - Splits the usage statistics (read/write) part out of
> cpuidle_state structure, so that the states can become read
> only and hence made global.
>
> [4/4] - Most APIs will now need to pass pointer to both global
> cpuidle_driver and per-cpu cpuidle_device structure.
>
>  arch/arm/mach-at91/cpuidle.c          |   41 +++--
>  arch/arm/mach-davinci/cpuidle.c       |   51 ++++---
>  arch/arm/mach-exynos4/cpuidle.c       |   30 ++--
>  arch/arm/mach-kirkwood/cpuidle.c      |   42 +++---
>  arch/arm/mach-omap2/cpuidle34xx.c     |  133 +++++++++++------
>  arch/sh/kernel/cpu/shmobile/cpuidle.c |   28 ++--
>  drivers/acpi/processor_driver.c       |   20 ---
>  drivers/acpi/processor_idle.c         |  251 +++++++++++++++++++++++++++------
>  drivers/cpuidle/cpuidle.c             |   86 ++++-------
>  drivers/cpuidle/driver.c              |   25 +++
>  drivers/cpuidle/governors/ladder.c    |   41 ++++-
>  drivers/cpuidle/governors/menu.c      |   29 ++--
>  drivers/cpuidle/sysfs.c               |   22 ++-
>  drivers/idle/intel_idle.c             |  130 +++++++++++++----
>  include/acpi/processor.h              |    1
>  include/linux/cpuidle.h               |   52 ++++---
>  16 files changed, 650 insertions(+), 332 deletions(-)
>
>
> --
>
> Thanks
>  -Deepthi
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
