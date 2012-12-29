Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab2L2BzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 20:55:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31310 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab2L2BzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 20:55:23 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=4xDcOe4IjvRdPVVETi+CqA==:17 a=TtU46XPs5IkA:10 a=TRgVYD6ZyiEA:10 a=bfdTmMi5DwwA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=yQdBAQUQAAAA:8 a=Tf1pAs_9cGAA:10 a=rRNTo9lXbcyGnLgugroA:9 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=4xDcOe4IjvRdPVVETi+CqA==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 75.81.36.228
Date: Fri, 28 Dec 2012 19:55:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: rjw@sisk.pl
Cc: fabio.baltieri@linaro.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH V3] Fix problem with cpufreq_ondemand or
 cpufreq_conservative
Message-ID: <50de4d88.M3WYPilXC8de/dVl%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 2aacdff entitled "cpufreq: Move common part from governors
to separate file", whenever the drivers that depend on this new file
(cpufreq_ondemand or cpufreq_conservative) are built as modules, a new
module named cpufreq_governor is created because the Makefile includes
cpufreq_governor.o twice. As drivers/cpufreq/cpufreq_governor.c contains no
MODULE directives, the resulting module has no license specified, which
results in logging of a "module license 'unspecified' taints kernel". In
addition, a number of globals are exported GPL only, and are therefore
not available. This fix establishes a new boolean configuration variable
that forces cpufreq_governor.o to be linked into the kernel whenever
either cpufreq_ondemand or cpufreq_conservative is selected.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V3 changes only Kconfig and Makefile and avoids creating a new module.

Larry

 Kconfig  |    5 +++++
 Makefile |    5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

Index: wireless-testing-new/drivers/cpufreq/Kconfig
===================================================================
--- wireless-testing-new.orig/drivers/cpufreq/Kconfig
+++ wireless-testing-new/drivers/cpufreq/Kconfig
@@ -20,6 +20,9 @@ if CPU_FREQ
 config CPU_FREQ_TABLE
 	tristate
 
+config CPU_FREQ_GOVERNOR
+	bool
+
 config CPU_FREQ_STAT
 	tristate "CPU frequency translation statistics"
 	select CPU_FREQ_TABLE
@@ -141,6 +144,7 @@ config CPU_FREQ_GOV_USERSPACE
 config CPU_FREQ_GOV_ONDEMAND
 	tristate "'ondemand' cpufreq policy governor"
 	select CPU_FREQ_TABLE
+	select CPU_FREQ_GOVERNOR
 	help
 	  'ondemand' - This driver adds a dynamic cpufreq policy governor.
 	  The governor does a periodic polling and 
@@ -159,6 +163,7 @@ config CPU_FREQ_GOV_ONDEMAND
 config CPU_FREQ_GOV_CONSERVATIVE
 	tristate "'conservative' cpufreq governor"
 	depends on CPU_FREQ
+	select CPU_FREQ_GOVERNOR
 	help
 	  'conservative' - this driver is rather similar to the 'ondemand'
 	  governor both in its source code and its purpose, the difference is
Index: wireless-testing-new/drivers/cpufreq/Makefile
===================================================================
--- wireless-testing-new.orig/drivers/cpufreq/Makefile
+++ wireless-testing-new/drivers/cpufreq/Makefile
@@ -7,8 +7,9 @@ obj-$(CONFIG_CPU_FREQ_STAT)
 obj-$(CONFIG_CPU_FREQ_GOV_PERFORMANCE)	+= cpufreq_performance.o
 obj-$(CONFIG_CPU_FREQ_GOV_POWERSAVE)	+= cpufreq_powersave.o
 obj-$(CONFIG_CPU_FREQ_GOV_USERSPACE)	+= cpufreq_userspace.o
-obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)	+= cpufreq_ondemand.o cpufreq_governor.o
-obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)	+= cpufreq_conservative.o cpufreq_governor.o
+obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)	+= cpufreq_ondemand.o
+obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)	+= cpufreq_conservative.o
+obj-$(CONFIG_CPU_FREQ_GOVERNOR)		+= cpufreq_governor.o
 
 # CPUfreq cross-arch helpers
 obj-$(CONFIG_CPU_FREQ_TABLE)		+= freq_table.o
