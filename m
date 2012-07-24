Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab2GXBNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:13:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49232 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab2GXBKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:10:17 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <nico@linaro.org>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, Cyril Chemparathy <cyril@ti.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: [RFC 17/23] ARM: add machine desc hook for early memory/paging initialization
Date: Mon, 23 Jul 2012 21:09:19 -0400
Message-ID: <1343092165-9470-18-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343092165-9470-1-git-send-email-cyril@ti.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a machine descriptor hook that gives control to machine
specific code prior to memory and paging initialization.

On Keystone platforms, this hook is used to switch the PHYS_OFFSET over
to the "real" non-32-bit-addressable address range.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
---
 arch/arm/include/asm/mach/arch.h |    1 +
 arch/arm/kernel/setup.c          |    3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index 0b1c94b..49e9c2a 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -39,6 +39,7 @@ struct machine_desc {
 					 struct meminfo *);
 	void			(*reserve)(void);/* reserve mem blocks	*/
 	void			(*map_io)(void);/* IO mapping function	*/
+	void			(*init_meminfo)(void);
 	void			(*init_early)(void);
 	void			(*init_irq)(void);
 	struct sys_timer	*timer;		/* system tick timer	*/
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index e15d83b..7cbe292 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -964,6 +964,9 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+	if (mdesc->init_meminfo)
+		mdesc->init_meminfo();
+
 	sort(&meminfo.bank, meminfo.nr_banks, sizeof(meminfo.bank[0]), meminfo_cmp, NULL);
 	sanity_check_meminfo();
 	arm_memblock_init(&meminfo, mdesc);
-- 
1.7.9.5

