Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab2EWJWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:22:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65107 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2EWJWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:22:16 -0400
Message-ID: <4FBCAC42.3020907@linaro.org>
Date: Wed, 23 May 2012 10:22:10 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [SOLUTION]  linux-next: build failure after merge of the mfd tree
References: <20120521134219.6d6396802bd6a097503bac92@canb.auug.org.au> <4FB9F818.4030801@linaro.org> <20120521184005.3b7661ec6468c5878a22615d@canb.auug.org.au> <4FBA0460.1070300@linaro.org> <20120521191007.9347651e88add2e7c247a24f@canb.auug.org.au> <4FBA08A4.6030706@linaro.org> <20120521095427.GA30045@sirena.org.uk> <4FBA18C7.4030800@linaro.org> <20120522224214.GG10210@sortiz-mobl>
In-Reply-To: <20120522224214.GG10210@sortiz-mobl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

This should sort you out.

The old code protected under 'AB8500_I2C_CORE' depended on 'MFD_DB8500_PRCMU'.

From: Lee Jones <lee.jones@linaro.org>
Date: Wed, 23 May 2012 10:08:51 +0100
Subject: [PATCH] MFD: Assign MFD_DB8500_PRCMU dependency for building ab8500-core

A recent move to eliminate excess historical baggage from ab8500 core
code resulting in errors when building with x86_64 allmodconfig:

In file included from drivers/mfd/ab8500-core.c:21:0:
include/linux/mfd/dbx500-prcmu.h:614:19: error: redefinition of 'prcmu_abb_read'
include/linux/mfd/db8500-prcmu.h:673:19: note: previous definition of 'prcmu_abb_read' was here
include/linux/mfd/dbx500-prcmu.h:619:19: error: redefinition of 'prcmu_abb_write'
include/linux/mfd/db8500-prcmu.h:678:19: note: previous definition of 'prcmu_abb_write' was here
include/linux/mfd/dbx500-prcmu.h:630:19: error: redefinition of 'prcmu_config_clkout'
include/linux/mfd/db8500-prcmu.h:643:19: note: previous definition of 'prcmu_config_clkout' was here
include/linux/mfd/dbx500-prcmu.h:692:20: error: redefinition of 'prcmu_ac_wake_req'
include/linux/mfd/db8500-prcmu.h:683:20: note: previous definition of 'prcmu_ac_wake_req' was here
include/linux/mfd/dbx500-prcmu.h:694:20: error: redefinition of 'prcmu_ac_sleep_req'
include/linux/mfd/db8500-prcmu.h:685:20: note: previous definition of 'prcmu_ac_sleep_req' was here

Problem:
When CONFIG_AB8500_CORE is set, building ab8500-core.c and
!(CONFIG_UX500_SOC_DB8500 | CONFIG_MFD_DB8500_PRCMU), both db8500-prcmu.h
and dbx500-prcmu.h take it upon themselves to _both_ create 'return 0'
inline functions for the following:

prcmu_abb_read()
prcmu_abb_write()
prcmu_config_clkout()
prcmu_ac_wake_req()
prcmu_ac_sleep_req()

Solution:
Depend on MFD_DB8500_PRCMU, which in turn depends on UX500_SOC_DB8500.

Reported-By: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9846424..43e6142 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -683,7 +683,7 @@ config EZX_PCAP
 
 config AB8500_CORE
 	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
-	depends on GENERIC_HARDIRQS && ABX500_CORE
+	depends on GENERIC_HARDIRQS && ABX500_CORE && MFD_DB8500_PRCMU
 	select MFD_CORE
 	help
 	  Select this option to enable access to AB8500 power management
-- 
1.7.9.5
