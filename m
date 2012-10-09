Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab2JIJpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:45:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:7870 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab2JIJph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:45:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,560,1344236400"; 
   d="scan'208";a="231632000"
From: Haicheng Li <haicheng.lee@gmail.com>
To: davem@davemloft.net
Cc: haicheng.li@linux.intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, fengguang.wu@intel.com,
        Haicheng Li <haicheng.lee@gmail.com>
Subject: [PATCH] pch_gbe: Fix build error by selecting all the possible dependencies.
Date: Tue,  9 Oct 2012 17:43:12 +0800
Message-Id: <1349775792-12573-1-git-send-email-haicheng.lee@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20121006075954.GA29618@localhost>
References: <20121006075954.GA29618@localhost>
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

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig b/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
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

