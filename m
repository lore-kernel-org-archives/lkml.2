Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0LAQeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:34:50 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:61549 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0LAQet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:34:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SBtUKUia2YBPC4CIwIbhFobNk0zJdx+znFY0N4Kr4rKMa73OkfAwFlX+uKzNk0ItLX
         +GYYzath/CacsPl7b2NRz/F+WaFxnb+ayFZFiFHEHkFPD1SXl9ODsaDRtZgO5Apvz9zu
         3mmwjNdg7Oeok11QJqzu7eY6QxkfAyZpYoTss=
From: Namhyung Kim <namhyung@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MIPS: Fix build failure on mips_sc_is_activated()
Date: Thu,  2 Dec 2010 01:34:42 +0900
Message-Id: <1291221282-9056-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit ea31a6b20371 ("MIPS: Honor L2 bypass bit") breaks
malta build as follows. Looks like not compile-tested :(

  CC      arch/mips/mm/sc-mips.o
arch/mips/mm/sc-mips.c: In function 'mips_sc_is_activated':
arch/mips/mm/sc-mips.c:77:7 error: 'config2' undeclared (first use in this function)
arch/mips/mm/sc-mips.c:77:7 note: each undeclared identifier is reported only once
arch/mips/mm/sc-mips.c:77:7       for each function it appears in
arch/mips/mm/sc-mips.c:81:2 error: 'tmp' undeclared (first use in this function)
arch/mips/mm/sc-mips.c:86:1 warning: control reaches end of non-void function
make[3]: *** [arch/mips/mm/sc-mips.o] Error 1
make[2]: *** [arch/mips/mm/sc-mips.o] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/mips/mm/sc-mips.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/mips/mm/sc-mips.c b/arch/mips/mm/sc-mips.c
index 505feca..a168f52 100644
--- a/arch/mips/mm/sc-mips.c
+++ b/arch/mips/mm/sc-mips.c
@@ -66,8 +66,11 @@ static struct bcache_ops mips_sc_ops = {
  * 12..15 as implementation defined so below function will eventually have
  * to be replaced by a platform specific probe.
  */
-static inline int mips_sc_is_activated(struct cpuinfo_mips *c)
+static inline int mips_sc_is_activated(struct cpuinfo_mips *c,
+				       unsigned int config2)
 {
+	unsigned int tmp;
+
 	/* Check the bypass bit (L2B) */
 	switch (c->cputype) {
 	case CPU_34K:
@@ -83,6 +86,8 @@ static inline int mips_sc_is_activated(struct cpuinfo_mips *c)
 		c->scache.linesz = 2 << tmp;
 	else
 		return 0;
+
+	return 1;
 }
 
 static inline int __init mips_sc_probe(void)
@@ -108,7 +113,7 @@ static inline int __init mips_sc_probe(void)
 
 	config2 = read_c0_config2();
 
-	if (!mips_sc_is_activated(c))
+	if (!mips_sc_is_activated(c, config2))
 		return 0;
 
 	tmp = (config2 >> 8) & 0x0f;
-- 
1.7.0.4

