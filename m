Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2KPJps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:45:48 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:39857 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2KPJpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:45:34 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 2/3] arm: plat-orion: Add coherency attribute when setup mbus target
Date: Fri, 16 Nov 2012 10:44:59 +0100
Message-Id: <1353059100-24022-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353059100-24022-1-git-send-email-gregory.clement@free-electrons.com>
References: <1353059100-24022-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent SoC such as Armada 370/XP came with the possibility to deal
with the I/O coherency by hardware. In this case the transaction
attribute of the window must be flagged as "Shared transaction". Once
this flag is set, then the transactions will be forced to be sent
through the coherency block, in other case transaction is driven
directly to DRAM.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Reviewed-by: Yehuda Yitschak <yehuday@marvell.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 arch/arm/plat-orion/addr-map.c              |    4 ++++
 arch/arm/plat-orion/include/plat/addr-map.h |    1 +
 2 files changed, 5 insertions(+)

diff --git a/arch/arm/plat-orion/addr-map.c b/arch/arm/plat-orion/addr-map.c
index a7b8060..febe386 100644
--- a/arch/arm/plat-orion/addr-map.c
+++ b/arch/arm/plat-orion/addr-map.c
@@ -42,6 +42,8 @@ EXPORT_SYMBOL_GPL(mv_mbus_dram_info);
 #define WIN_REMAP_LO_OFF	0x0008
 #define WIN_REMAP_HI_OFF	0x000c
 
+#define ATTR_HW_COHERENCY	(0x1 << 4)
+
 /*
  * Default implementation
  */
@@ -163,6 +165,8 @@ void __init orion_setup_cpu_mbus_target(const struct orion_addr_map_cfg *cfg,
 			w = &orion_mbus_dram_info.cs[cs++];
 			w->cs_index = i;
 			w->mbus_attr = 0xf & ~(1 << i);
+			if (cfg->hw_io_coherency)
+				w->mbus_attr |= ATTR_HW_COHERENCY;
 			w->base = base & 0xffff0000;
 			w->size = (size | 0x0000ffff) + 1;
 		}
diff --git a/arch/arm/plat-orion/include/plat/addr-map.h b/arch/arm/plat-orion/include/plat/addr-map.h
index ec63e4a..b76c065 100644
--- a/arch/arm/plat-orion/include/plat/addr-map.h
+++ b/arch/arm/plat-orion/include/plat/addr-map.h
@@ -17,6 +17,7 @@ struct orion_addr_map_cfg {
 	const int num_wins;	/* Total number of windows */
 	const int remappable_wins;
 	void __iomem *bridge_virt_base;
+	int hw_io_coherency;
 
 	/* If NULL, the default cpu_win_can_remap will be used, using
 	   the value in remappable_wins */
-- 
1.7.9.5

