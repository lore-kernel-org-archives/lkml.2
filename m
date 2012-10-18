Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab2JRIV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:21:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63905 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2JRIV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:21:57 -0400
Message-ID: <507FBC20.50004@linaro.org>
Date: Thu, 18 Oct 2012 10:21:52 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: linux-kernel@vger.kernel.org, len.brown@intel.com, khilman@ti.com,
        rjw@sisk.pl, deepthi@linux.vnet.ibm.com, akpm@linux-foundation.org,
        g.trinabh@gmail.com, snanda@chromium.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH] cpuidle: reinitialize power_usage values when adding/removing
 C-states
References: <1350427184-11684-1-git-send-email-jwerner@chromium.org> <507E88F3.8070403@linaro.org> <CAODwPW8CfgLQS+933ZQSueiat3QrAtRZh98h3iqtN8vxBOy=qg@mail.gmail.com>
In-Reply-To: <CAODwPW8CfgLQS+933ZQSueiat3QrAtRZh98h3iqtN8vxBOy=qg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 08:43 PM, Julius Werner wrote:
>> This is specific to the acpi and should be handled in the
>> processor_idle.c file instead of the cpuidle core code.
>>
>> Could be the function 'acpi_processor_cst_has_changed' the right place
>> to set a dummy power value for the power in the new C-state ?
> 
> Thanks for your feedback. I think it wouldn't be wise to split the
> dummy power value logic over two places, but I could submit a patch
> that makes set_power_states globally accessible and calls it from
> acpi_processor_cst_has_changed instead.

No please, do not export this function. That will add more confusion on
the acpi code and more generally in the cpuidle core code.

IIUC, a new state is inserted/deleted and we will set the entire array
of states to setup the power.

You have the acpi_processor_cst_has_changed function calling the
acpi_processor_setup_cpuidle_states function. It seems to be a good
candidate to setup the power of the new state. All the states are filled
again AFAICS under the lock.

> However, I do not think this should really be ACPI specific. It
> applies to any cpuidle driver that wants to change its idle states at
> runtime. Currently only the ACPI one does, but the future might bring
> others that would run into the same problem. I also think that
> set_power_states fits much better into cpuidle_enable_device
> conceptually anyway (right next to poll_idle_init which also does
> state initialization).

The states are now part of the cpuidle driver and the set_power_states
should remain to this file. The dynamic C-states brought some complexity
in the acpi code and honestly this code is very confusing.

Maybe one day, that would make sense but until then I am in favor of
keeping the arch specific bits in the drivers, especially when they are
*hum* so "complex".

poll_idle_init looks hackish for me and probably move it to the arch
would also make sense.

Thanks
  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

