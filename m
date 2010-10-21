Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab0JUQHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 12:07:48 -0400
Received: from [69.28.251.93] ([69.28.251.93]:59951 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab0JUQHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 12:07:47 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Subject: [PATCH v3 8/9] MIPS: Honor L2 bypass bit
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 21 Oct 2010 08:59:48 -0700
Message-Id: <2e65c61bf8fd3a7b2aa4e24013cb0dba@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[v3: Fix build errors]

On many of the newer MIPS32 cores, CP0 CONFIG2 bit 12 (L2B) indicates
that the L2 cache is disabled and therefore Linux should not attempt
to use it.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-mips@linux-mips.org>
Cc: <linux-kernel@vger.kernel.org>
---
 arch/mips/mm/sc-mips.c |   38 ++++++++++++++++++++++++++++++++++----
 1 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/arch/mips/mm/sc-mips.c b/arch/mips/mm/sc-mips.c
index 5ab5fa8..ef625eb 100644
--- a/arch/mips/mm/sc-mips.c
+++ b/arch/mips/mm/sc-mips.c
@@ -57,6 +57,38 @@ static struct bcache_ops mips_sc_ops = {
 	.bc_inv = mips_sc_inv
 };
 
+/*
+ * Check if the L2 cache controller is activated on a particular platform.
+ * MTI's L2 controller and the L2 cache controller of Broadcom's BMIPS
+ * cores both use c0_config2's bit 12 as "L2 Bypass" bit, that is the
+ * cache being disabled.  However there is no guarantee for this to be
+ * true on all platforms.  In an act of stupidity the spec defined bits
+ * 12..15 as implementation defined so below function will eventually have
+ * to be replaced by a platform specific probe.
+ */
+static inline int mips_sc_is_activated(struct cpuinfo_mips *c,
+	unsigned int config2)
+{
+	unsigned int tmp;
+
+	/* Check the bypass bit (L2B) */
+	switch (c->cputype) {
+	case CPU_34K:
+	case CPU_74K:
+	case CPU_1004K:
+	case CPU_BMIPS5000:
+		if (config2 & (1 << 12))
+			return 0;
+	}
+
+	tmp = (config2 >> 4) & 0x0f;
+	if (0 < tmp && tmp <= 7)
+		c->scache.linesz = 2 << tmp;
+	else
+		return 0;
+	return 1;
+}
+
 static inline int __init mips_sc_probe(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
@@ -79,10 +111,8 @@ static inline int __init mips_sc_probe(void)
 		return 0;
 
 	config2 = read_c0_config2();
-	tmp = (config2 >> 4) & 0x0f;
-	if (0 < tmp && tmp <= 7)
-		c->scache.linesz = 2 << tmp;
-	else
+
+	if (!mips_sc_is_activated(c, config2))
 		return 0;
 
 	tmp = (config2 >> 8) & 0x0f;
-- 
1.7.0.4

