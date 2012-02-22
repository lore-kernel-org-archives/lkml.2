Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2BVPqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:46:00 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:39779 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023Ab2BVPp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:45:59 -0500
Date: Wed, 22 Feb 2012 17:45:47 +0200
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rob.lee@linaro.org
Subject: Re: [linux-pm] [PATCH 0/4] thermal: Adding generic cpu cooling
 devices
Message-ID: <20120222154123.GA13675@besouro>
Reply-To: eduardo.valentin@ti.com
References: <1329905650-30161-1-git-send-email-amit.kachhap@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329905650-30161-1-git-send-email-amit.kachhap@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Amit,

Thanks for keeping this up.

On Wed, Feb 22, 2012 at 03:44:06PM +0530, Amit Daniel Kachhap wrote:
> Changes since RFC:
>  *Changed the cpu cooling registration/unregistration API's to instance based
>  *Changed the STATE_ACTIVE trip type to pass correct instance id
>  *Adding support to restore back the policy->max_freq after doing frequency 
>   clipping.

Have checked if this does not overlap with what the user set's as max_freq?
Not sure if we have governors that set max_freq as well. Anyways, looks like
just saving the current max and restoring it may lead to overlaps. I didn't check though.

>  *Moved the trip cooling stats from sysfs node to debugfs node as suggested
>   by Greg KH greg@kroah.com 
>  *Incorporated several review comments from eduardo.valentin@ti.com
> 
> Todo:
>  *Report time spent in each trip point along with the cooling statistics
>  *Add opp library support in cpufreq cooling api's
> 
> Brief Description:
> 
> 1) The generic cooling devices code is placed inside driver/thermal/* as 
> placing inside acpi folder will need un-necessary enabling of acpi code.
> 
> 2) This patchset adds a new trip type THERMAL_TRIP_STATE_ACTIVE which passes
> cooling device instance number and may be helpful for cpufreq cooling devices
> to take the correct cooling action.

As already said on your previous series, the naming is not good. Problem
is that it may confuse people who have ACPI nomenclature in mind. Active,
on those terms, is related to cooling devices that consumes more power,
like activating fans.

> 
> 3) This patchset adds generic cpu cooling low level implementation through
> frequency clipping and cpu hotplug. In future, other cpu related cooling
> devices may be added here. An ACPI version of this already exists
> (drivers/acpi/processor_thermal.c). But this will be useful for platforms
> like ARM using the generic thermal interface along with the generic cpu
> cooling devices. The cooling device registration API's return cooling device
> pointers which can be easily binded with the thermal zone trip points.

Yeah, but here I have to agree with Matthew Garrett's comment on your previous
version. If it is supposed to be generic, then it has to couple of ACPI as well,
otherwise it is generic for non-ACPI right? :-)

One suggestion is to think on how we could make the passive trip type more generic,
so that it could fit any policy there, either ACPI based or non-ACPI.

Talking about policy, I also think that having one specific policy on a generic
cooling strategy is maybe not a good way to go. The percentages stepping is
one proposal, but some other system may want to put its own way of cooling
using the available opps. That comes again back to the point that we probably
want something more generalized there in the generic code.

For instance, while updating the zone, you could have a generic callback
operation which would dictate the relation between trip with passive cooling state.
Then, ACPI would then define how it wants this relation to be. Then you could propose the
percentage based approach, but other people could also have its own way of correlation
or how the zone has to be updated while doing passive cooling.

Another thing is that you may want to include some examples on your documentation.
Examples of system setup with trips, temps, percentages and behavior.

> 
> 4)This patchset provides a simple way of reporting cooling achieved in a
> trip type. This will help in fine cooling the cooling devices attached.
> 
> Amit Daniel Kachhap (4):
>   thermal: Add a new trip type to use cooling device instance number
>   thermal: Add generic cpufreq cooling implementation
>   thermal: Add generic cpuhotplug cooling implementation
>   thermal: Add support to report cooling statistics achieved by cooling
>     devices
> 
>  Documentation/thermal/cpu-cooling-api.txt |   57 ++++
>  Documentation/thermal/sysfs-api.txt       |    4 +-
>  drivers/thermal/Kconfig                   |   11 +
>  drivers/thermal/Makefile                  |    1 +
>  drivers/thermal/cpu_cooling.c             |  484 +++++++++++++++++++++++++++++
>  drivers/thermal/thermal_sys.c             |  165 ++++++++++-
>  include/linux/cpu_cooling.h               |   71 +++++
>  include/linux/thermal.h                   |   14 +
>  8 files changed, 802 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/thermal/cpu-cooling-api.txt
>  create mode 100644 drivers/thermal/cpu_cooling.c
>  create mode 100644 include/linux/cpu_cooling.h
> 
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/linux-pm
