Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2L2PjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 10:39:21 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:34735 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab2L2PjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 10:39:20 -0500
Message-ID: <50DF0EA4.8090603@lwfinger.net>
Date: Sat, 29 Dec 2012 09:39:16 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: fabio.baltieri@linaro.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH V3] Fix problem with cpufreq_ondemand or cpufreq_conservative
References: <50de4d88.M3WYPilXC8de/dVl%Larry.Finger@lwfinger.net> <2035804.da5iyiYDGE@vostro.rjw.lan>
In-Reply-To: <2035804.da5iyiYDGE@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2012 07:27 AM, Rafael J. Wysocki wrote:
> On Friday, December 28, 2012 07:55:20 PM Larry Finger wrote:
>> Since commit 2aacdff entitled "cpufreq: Move common part from governors
>> to separate file", whenever the drivers that depend on this new file
>> (cpufreq_ondemand or cpufreq_conservative) are built as modules, a new
>> module named cpufreq_governor is created because the Makefile includes
>> cpufreq_governor.o twice. As drivers/cpufreq/cpufreq_governor.c contains no
>> MODULE directives, the resulting module has no license specified, which
>> results in logging of a "module license 'unspecified' taints kernel". In
>> addition, a number of globals are exported GPL only, and are therefore
>> not available. This fix establishes a new boolean configuration variable
>> that forces cpufreq_governor.o to be linked into the kernel whenever
>> either cpufreq_ondemand or cpufreq_conservative is selected.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>> V3 changes only Kconfig and Makefile and avoids creating a new module.
>
> OK, thanks for the patch!
>
> If you don't mind, I'll rename CONFIG_CPU_FREQ_GOVERNOR to
> CONFIG_CPU_FREQ_GOV_COMMON when applying it, though.

No problem. It occurred to me that if one can do logic in a Makefile, then the 
extra configuration variable can be eliminated. I still need to check if that is 
possible.

Larry

>
> Thanks,
> Rafael
>
>
>>   Kconfig  |    5 +++++
>>   Makefile |    5 +++--
>>   2 files changed, 8 insertions(+), 2 deletions(-)
>>
>> Index: wireless-testing-new/drivers/cpufreq/Kconfig
>> ===================================================================
>> --- wireless-testing-new.orig/drivers/cpufreq/Kconfig
>> +++ wireless-testing-new/drivers/cpufreq/Kconfig
>> @@ -20,6 +20,9 @@ if CPU_FREQ
>>   config CPU_FREQ_TABLE
>>   	tristate
>>
>> +config CPU_FREQ_GOVERNOR
>> +	bool
>> +
>>   config CPU_FREQ_STAT
>>   	tristate "CPU frequency translation statistics"
>>   	select CPU_FREQ_TABLE
>> @@ -141,6 +144,7 @@ config CPU_FREQ_GOV_USERSPACE
>>   config CPU_FREQ_GOV_ONDEMAND
>>   	tristate "'ondemand' cpufreq policy governor"
>>   	select CPU_FREQ_TABLE
>> +	select CPU_FREQ_GOVERNOR
>>   	help
>>   	  'ondemand' - This driver adds a dynamic cpufreq policy governor.
>>   	  The governor does a periodic polling and
>> @@ -159,6 +163,7 @@ config CPU_FREQ_GOV_ONDEMAND
>>   config CPU_FREQ_GOV_CONSERVATIVE
>>   	tristate "'conservative' cpufreq governor"
>>   	depends on CPU_FREQ
>> +	select CPU_FREQ_GOVERNOR
>>   	help
>>   	  'conservative' - this driver is rather similar to the 'ondemand'
>>   	  governor both in its source code and its purpose, the difference is
>> Index: wireless-testing-new/drivers/cpufreq/Makefile
>> ===================================================================
>> --- wireless-testing-new.orig/drivers/cpufreq/Makefile
>> +++ wireless-testing-new/drivers/cpufreq/Makefile
>> @@ -7,8 +7,9 @@ obj-$(CONFIG_CPU_FREQ_STAT)
>>   obj-$(CONFIG_CPU_FREQ_GOV_PERFORMANCE)	+= cpufreq_performance.o
>>   obj-$(CONFIG_CPU_FREQ_GOV_POWERSAVE)	+= cpufreq_powersave.o
>>   obj-$(CONFIG_CPU_FREQ_GOV_USERSPACE)	+= cpufreq_userspace.o
>> -obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)	+= cpufreq_ondemand.o cpufreq_governor.o
>> -obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)	+= cpufreq_conservative.o cpufreq_governor.o
>> +obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)	+= cpufreq_ondemand.o
>> +obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)	+= cpufreq_conservative.o
>> +obj-$(CONFIG_CPU_FREQ_GOVERNOR)		+= cpufreq_governor.o
>>
>>   # CPUfreq cross-arch helpers
>>   obj-$(CONFIG_CPU_FREQ_TABLE)		+= freq_table.o

