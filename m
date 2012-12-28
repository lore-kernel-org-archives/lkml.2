Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab2L1WRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 17:17:32 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39580 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab2L1WR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 17:17:27 -0500
Message-ID: <50DE1A74.4040607@lwfinger.net>
Date: Fri, 28 Dec 2012 16:17:24 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC: cpufreq@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix problem with cpufreq_pndemand or cpufreq_conservative
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 2aacdff entitled "cpufreq: Move common part from governors to 
separate file", whenever the drivers that depend on this new file 
(cpufreq_ondemand or cpufreq_conservative) are built as modules, a new module 
named cpufreq_governor is created. It seems that kmake is smart enough to create 
a separate module whenever more than one module includes the same object file. 
As drivers/cpufreq/cpufreq_governor.c contains no MODULE directives, the 
resulting module has no license specified, which results in logging of a "module 
license 'unspecified' taints kernel". In addition, a number of globals are 
exported GPL only, and are therefore not available.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

This particular patch is the simplest possible; however, it hides the intent. I 
have prepared the longer version that makes the reason clearer by adding a new 
configuration variable that is dependent on the other two, and rearranges 
drivers/cpufreq/Makefile. That version could be submitted if that is what is 
desired. The changes to cpufreq_governor.c are the same as in this version.

Larry


       cpufreq_governor.c |    5 +++++
       1 file changed, 5 insertions(+)
---
Index: wireless-testing-new/drivers/cpufreq/cpufreq_governor.c
===================================================================
--- wireless-testing-new.orig/drivers/cpufreq/cpufreq_governor.c
+++ wireless-testing-new/drivers/cpufreq/cpufreq_governor.c
@@ -25,6 +25,7 @@
  #include <linux/tick.h>
  #include <linux/types.h>
  #include <linux/workqueue.h>
+#include <linux/module.h>

  #include "cpufreq_governor.h"

@@ -316,3 +317,7 @@ second_time:
  	return 0;
  }
  EXPORT_SYMBOL_GPL(cpufreq_governor_dbs);
+MODULE_AUTHOR("Alexander Clouter <alex@digriz.org.uk>");
+MODULE_DESCRIPTION("'cpufreq_governor' - A mini-module containing "
+		"common code for cpufreq_conservative and cpufreq_ondemand");
+MODULE_LICENSE("GPL");






