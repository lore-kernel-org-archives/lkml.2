Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab2L2RYv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 12:24:51 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:34587 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab2L2RYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 12:24:49 -0500
Message-ID: <50DF275D.1080702@lwfinger.net>
Date: Sat, 29 Dec 2012 11:24:45 -0600
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

The following does the job and is somewhat cleaner. If you want, I can remove 
the line wrap and submit it as V4. The downside of this approach is that the 
nested ifs will get cumbersome is more governors need cpufreq_governor.o.

Larry

Index: wireless-testing-new/drivers/cpufreq/Makefile
===================================================================
--- wireless-testing-new.orig/drivers/cpufreq/Makefile
+++ wireless-testing-new/drivers/cpufreq/Makefile
@@ -7,8 +7,15 @@ obj-$(CONFIG_CPU_FREQ_STAT)
  obj-$(CONFIG_CPU_FREQ_GOV_PERFORMANCE) += cpufreq_performance.o
  obj-$(CONFIG_CPU_FREQ_GOV_POWERSAVE)   += cpufreq_powersave.o
  obj-$(CONFIG_CPU_FREQ_GOV_USERSPACE)   += cpufreq_userspace.o
-obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)    += cpufreq_ondemand.o cpufreq_governor.o
-obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)        += cpufreq_conservative.o 
cpufreq_governor.o
+obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)    += cpufreq_ondemand.o
+obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)        += cpufreq_conservative.o
+ifdef CONFIG_CPU_FREQ_GOV_ONDEMAND
+  obj-y += cpufreq_governor.o
+else
+  ifdef CONFIG_CPU_FREQ_GOV_CONSERVATIVE
+    obj-y += cpufreq_governor.o
+  endif
+endif

  # CPUfreq cross-arch helpers
  obj-$(CONFIG_CPU_FREQ_TABLE)           += freq_table.o


