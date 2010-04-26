Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0DZOM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:12:29 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40753 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822Ab0DZOM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:12:28 -0400
Date: Mon, 26 Apr 2010 16:12:26 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Andrew Morton <akpm@linux-foundation.org>, maltesch@gmx.de,
       Ralf Baechle <ralf@linux-mips.org>,
       Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] Missmatch between source and Kconfig for ACPI && !PM
Message-ID: <20100426141226.GC2710@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

	There's a check for CONFIG_PM inside a block that is only
compiled if CONFIG_ACPI is set. As CONFIG_ACPI depends on CONFIG_PM
the check is currently redundant, the Code always active and it's else
branch always dead.

	The attached patch takes the naive solution and only makes it
clearer how this source is handled currently. However if the
combination ACPI && !PM is usefull the depends in Kconfig might need
to be lowered.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From f122e465fc239e4dd8f4d27c72e1066f0a59c6c7 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@cs.fau.de>
Date: Mon, 26 Apr 2010 16:02:37 +0200
Subject: [PATCH] Remove check for CONFIG_PM which is always present when CONFIG_ACPI

As the config option for ACPI directly depends on PM in Kconfig there
is currently no way to have ACPI enabled but no PM. Nontheless there's
some code handling exactly this case.

menuconfig ACPI
[...]
		   depends on PM
[...]

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/rtc/rtc-cmos.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index e9aa814..0b2ae16 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -970,7 +970,6 @@ static inline int cmos_poweroff(struct device *dev)
 
 #include <linux/acpi.h>
 
-#ifdef	CONFIG_PM
 static u32 rtc_handler(void *context)
 {
 	acpi_clear_event(ACPI_EVENT_RTC);
@@ -999,11 +998,6 @@ static void rtc_wake_off(struct device *dev)
 {
 	acpi_disable_event(ACPI_EVENT_RTC, 0);
 }
-#else
-#define rtc_wake_setup()	do{}while(0)
-#define rtc_wake_on		NULL
-#define rtc_wake_off		NULL
-#endif
 
 /* Every ACPI platform has a mc146818 compatible "cmos rtc".  Here we find
  * its device node and pass extra config data.  This helps its driver use
-- 
1.6.3.3









