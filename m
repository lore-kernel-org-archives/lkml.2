Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0JUDXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 23:23:05 -0400
Received: from [69.28.251.93] ([69.28.251.93]:50708 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757083Ab0JUDXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 23:23:04 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Subject: [PATCH v2 8/9] MIPS: Honor L2 bypass bit
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Date: Wed, 20 Oct 2010 20:05:42 -0700
Message-Id: <74b5d3ba9506b2e6d885546bd6dcdaec@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On many of the newer MIPS32 cores, CP0 CONFIG2 bit 12 (L2B) indicates
that the L2 cache is disabled and therefore Linux should not attempt
to use it.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/mm/sc-mips.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/mips/mm/sc-mips.c b/arch/mips/mm/sc-mips.c
index 5ab5fa8..f2e2886 100644
--- a/arch/mips/mm/sc-mips.c
+++ b/arch/mips/mm/sc-mips.c
@@ -79,6 +79,17 @@ static inline int __init mips_sc_probe(void)
 		return 0;
 
 	config2 = read_c0_config2();
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
 	tmp = (config2 >> 4) & 0x0f;
 	if (0 < tmp && tmp <= 7)
 		c->scache.linesz = 2 << tmp;
-- 
1.7.0.4

