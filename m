Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab0KCFcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 01:32:35 -0400
Received: from [69.28.251.93] ([69.28.251.93]:54161 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab0KCFce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 01:32:34 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] MIPS: Fix build errors in sc-mips.c
Date: Tue, 02 Nov 2010 22:28:01 -0700
Message-Id: <01184c101e5d39225a6380cce3c5bad5@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seen with malta_defconfig on Linus' tree:

  CC      arch/mips/mm/sc-mips.o
arch/mips/mm/sc-mips.c: In function 'mips_sc_is_activated':
arch/mips/mm/sc-mips.c:77: error: 'config2' undeclared (first use in this function)
arch/mips/mm/sc-mips.c:77: error: (Each undeclared identifier is reported only once
arch/mips/mm/sc-mips.c:77: error: for each function it appears in.)
arch/mips/mm/sc-mips.c:81: error: 'tmp' undeclared (first use in this function)
make[2]: *** [arch/mips/mm/sc-mips.o] Error 1
make[1]: *** [arch/mips/mm] Error 2
make: *** [arch/mips] Error 2

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/mm/sc-mips.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/mips/mm/sc-mips.c b/arch/mips/mm/sc-mips.c
index 505feca..ef625eb 100644
--- a/arch/mips/mm/sc-mips.c
+++ b/arch/mips/mm/sc-mips.c
@@ -66,8 +66,11 @@ static struct bcache_ops mips_sc_ops = {
  * 12..15 as implementation defined so below function will eventually have
  * to be replaced by a platform specific probe.
  */
-static inline int mips_sc_is_activated(struct cpuinfo_mips *c)
+static inline int mips_sc_is_activated(struct cpuinfo_mips *c,
+	unsigned int config2)
 {
+	unsigned int tmp;
+
 	/* Check the bypass bit (L2B) */
 	switch (c->cputype) {
 	case CPU_34K:
@@ -83,6 +86,7 @@ static inline int mips_sc_is_activated(struct cpuinfo_mips *c)
 		c->scache.linesz = 2 << tmp;
 	else
 		return 0;
+	return 1;
 }
 
 static inline int __init mips_sc_probe(void)
@@ -108,7 +112,7 @@ static inline int __init mips_sc_probe(void)
 
 	config2 = read_c0_config2();
 
-	if (!mips_sc_is_activated(c))
+	if (!mips_sc_is_activated(c, config2))
 		return 0;
 
 	tmp = (config2 >> 8) & 0x0f;
-- 
1.7.0.4

