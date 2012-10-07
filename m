Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2JGOOl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 10:14:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:45103 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab2JGOOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 10:14:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,547,1344236400"; 
   d="scan'208";a="230944232"
Message-ID: <50718E45.1070706@linux.intel.com>
Date: Sun, 07 Oct 2012 22:14:29 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120306 Thunderbird/3.1.20
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: fengguang.wu@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix PTP dependencies: explicitly select all the possible
 dependencies.
References: <50703B1B.2040705@linux.intel.com>	<20121006.102132.1497404004255213029.davem@davemloft.net>	<50706885.1030908@linux.intel.com> <20121006.171748.734171045678392820.davem@davemloft.net>
In-Reply-To: <20121006.171748.734171045678392820.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang reported a kernel build failure as following:
drivers/built-in.o: In function `pch_gbe_ioctl':
pch_gbe_main.c:(.text+0x510370): undefined reference to `pch_ch_control_write'
pch_gbe_main.c:(.text+0x510393): undefined reference to `pch_ch_control_write'
pch_gbe_main.c:(.text+0x5103b3): undefined reference to `pch_ch_control_write'
...

It's a regression by commit da1586461. The root cause is that
the CONFIG_PPS is not set there, consequently CONFIG_PTP_1588_CLOCK
can not be set anyway, which finally causes ptp_pch and pch_gbe_main
build failures.

As David prefers to use *select* to fix such module co-dependency issues,
this patch explicitly selects all the possible dependencies of PCH_PTP.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Haicheng Li <haicheng.lee@gmail.com>
---
  drivers/net/ethernet/oki-semi/pch_gbe/Kconfig |    3 +++
  1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig 
b/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
index 9730241..5296cc8 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
@@ -26,6 +26,9 @@ if PCH_GBE
  config PCH_PTP
  	bool "PCH PTP clock support"
  	default n
+	depends on EXPERIMENTAL
+	select PPS
+	select PTP_1588_CLOCK
  	select PTP_1588_CLOCK_PCH
  	---help---
  	  Say Y here if you want to use Precision Time Protocol (PTP) in the
-- 
1.7.1
