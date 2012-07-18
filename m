Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab2GRLMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:12:21 -0400
Received: from toro.web-alm.net ([62.245.132.31]:53608 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab2GRLMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:12:17 -0400
Message-ID: <500697A9.6070101@osadl.org>
Date: Wed, 18 Jul 2012 13:02:01 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
CC: Len Brown <len.brown@intel.com>, Kevin Hilman <khilman@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Honor state disabling in the cpuidle ladder governor
References: <20120717185914.063547728@osadl.org> <20120717190330.700421963@osadl.org> <50065953.9040904@linux.vnet.ibm.com>
In-Reply-To: <50065953.9040904@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 08:36 AM, Deepthi Dharwar wrote:
> On 07/18/2012 12:29 AM, Carsten Emde wrote:
>
>> There are two cpuidle governors ladder and menu. While the ladder
>> governor is always available, if CONFIG_CPU_IDLE is selected, the
>> menu governor additionally requires CONFIG_NO_HZ.
>>
>> A particular C state can be disabled by writing to the sysfs file
>> /sys/devices/system/cpu/cpuN/cpuidle/stateN/disable, but this mechanism
>> is only implemented in the menu governor. Thus, in a system where
>> CONFIG_NO_HZ is not selected, the ladder governor becomes default and
>> always will walk through all sleep states - irrespective of whether the
>> C state was disabled via sysfs or not. The only way to select a specific
>> C state was to write the related latency to /dev/cpu_dma_latency and
>> keep the file open as long as this setting was required - not very
>> practical and not suitable for setting a single core in an SMP system.
>>
>> With this patch, the ladder governor only will promote to the next
>> C state, if it has not been disabled, and it will demote, if the
>> current C state was disabled.
>
> Yes, I agree that currently that disabling a particular C-state
> is not reflected in working of ladder governor. This patch is needed
> to fix it on ladder too.
>
> Also wanted to clarify on the intended implementation here,
> if there are say 5 C-states on a system, disabling 2nd
> state would also end by disabling all the remaining 3 deeper states too
> as ladder governor enters the lightest state first, and will only move
> on to the next deeper state if a idle period was long enough as
> per the implementation.
> If one is disabling only the deepest state, then it would
> work as intended.
Yes, the patch does not make the setting of the sysfs variable
"disable" coherent, i.e. if one is disabling a light state, then all
deeper states are disabled as well, but the "disable" variable does not
reflect it. Likewise, if one enables a deep state but a lighter state
still is disabled, then this has no effect.

I could implement a sanitize mechanism of the ladder governor that
takes care the "disable" variables of all deeper states are set to 1,
if a state is disabled, and those of all lighter states are set to 0,
if a state is enabled. Do you wish me to do that?

	-Carsten.
