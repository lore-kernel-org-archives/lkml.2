Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1HBWwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:52:06 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:41638 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1HBWvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:51:54 -0400
From: Len Brown <lenb@kernel.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Subject: [PATCH 18/19] APEI GHES: 32-bit buildfix
Date: Tue, 02 Aug 2011 18:14:51 -0400
Message-id: <2c39c2e0b2d8414cfd8b9067ed1c3aac4ed303c1.1312323131.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.6.396.ge0613
In-reply-to: <1312323292-2986-1-git-send-email-lenb@kernel.org>
References: <1312323292-2986-1-git-send-email-lenb@kernel.org>
In-reply-to: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
References: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8bit
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

drivers/acpi/apei/ghes.c:542: warning: integer overflow in expression
drivers/acpi/apei/ghes.c:619: warning: integer overflow in expression

ghes.c:(.text+0x46289): undefined reference to `__udivdi3'
  in function ghes_estatus_cache_add().

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/ghes.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index e92c47c..0784f99 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -65,7 +65,7 @@
 
 #define GHES_ESTATUS_CACHES_SIZE	4
 
-#define GHES_ESTATUS_IN_CACHE_MAX_NSEC	(10 * NSEC_PER_SEC)
+#define GHES_ESTATUS_IN_CACHE_MAX_NSEC	10000000000ULL
 /* Prevent too many caches are allocated because of RCU */
 #define GHES_ESTATUS_CACHE_ALLOCED_MAX	(GHES_ESTATUS_CACHES_SIZE * 3 / 2)
 
@@ -622,7 +622,8 @@ static void ghes_estatus_cache_add(
 			break;
 		}
 		count = atomic_read(&cache->count);
-		period = duration / (count + 1);
+		period = duration;
+		do_div(period, (count + 1));
 		if (period > max_period) {
 			max_period = period;
 			slot = i;
-- 
1.7.6.396.ge0613

