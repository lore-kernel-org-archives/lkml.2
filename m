Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab2JQPpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:45:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40047 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756329Ab2JQPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:45:13 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: [RESEND PATCH 3/4] mmc: mmci: use io{read,write}*_rep accessors instead of string functions
Date: Wed, 17 Oct 2012 16:45:03 +0100
Message-Id: <1350488704-3711-4-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1350488704-3711-1-git-send-email-will.deacon@arm.com>
References: <1350488704-3711-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The {read,write}s{b,w,l} operations are not defined by all architectures
and are being removed from the asm-generic/io.h interface.

This patch replaces the usage of these string functions with
io{read,write}{8,16,32}_rep calls instead, which are defined for all
architectures.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 drivers/mmc/host/mmci.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index edc3e9b..4f125b4 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -840,14 +840,14 @@ static int mmci_pio_read(struct mmci_host *host, char *buffer, unsigned int rema
 		if (unlikely(count & 0x3)) {
 			if (count < 4) {
 				unsigned char buf[4];
-				readsl(base + MMCIFIFO, buf, 1);
+				ioread32_rep(base + MMCIFIFO, buf, 1);
 				memcpy(ptr, buf, count);
 			} else {
-				readsl(base + MMCIFIFO, ptr, count >> 2);
+				ioread32_rep(base + MMCIFIFO, ptr, count >> 2);
 				count &= ~0x3;
 			}
 		} else {
-			readsl(base + MMCIFIFO, ptr, count >> 2);
+			ioread32_rep(base + MMCIFIFO, ptr, count >> 2);
 		}
 
 		ptr += count;
@@ -900,7 +900,7 @@ static int mmci_pio_write(struct mmci_host *host, char *buffer, unsigned int rem
 		 * byte become a 32bit write, 7 bytes will be two
 		 * 32bit writes etc.
 		 */
-		writesl(base + MMCIFIFO, ptr, (count + 3) >> 2);
+		iowrite32_rep(base + MMCIFIFO, ptr, (count + 3) >> 2);
 
 		ptr += count;
 		remain -= count;
-- 
1.7.4.1

