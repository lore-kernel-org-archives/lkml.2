Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526Ab2IGLRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:17:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41152 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760374Ab2IGLPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:15:37 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 15/19] mfd: Don't convert just one IRQ using irqdomain if a range is provided
Date: Fri,  7 Sep 2012 12:14:55 +0100
Message-Id: <1347016499-29354-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MFD core code attempts to convert specified hardware (local) IRQ
numbers to virtual-IRQs, which something Linux can understand. This
works great when only one IRQ is specified. However, converting
entire ranges is currently unsupported. If this occurs we issue a
kernel warning to inform the user of this, but we continue to
convert the first specified IRQ anyway and replace the range. This
is not the correct behaviour. This patch ensures that if a range
is specified, it is left untouched.

CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/mfd-core.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index f8b7771..f07cf69 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -126,10 +126,12 @@ static int mfd_add_device(struct device *parent, int id,
 		} else if (cell->resources[r].flags & IORESOURCE_IRQ) {
 			if (domain) {
 				/* Unable to create mappings for IRQ ranges. */
-				WARN_ON(cell->resources[r].start !=
-					cell->resources[r].end);
-				res[r].start = res[r].end = irq_create_mapping(
-					domain, cell->resources[r].start);
+				if (!WARN_ON(cell->resources[r].start !=
+						cell->resources[r].end))
+					res[r].start = res[r].end =
+						irq_create_mapping(
+							domain,
+							cell->resources[r].start);
 			} else {
 				res[r].start = irq_base +
 					cell->resources[r].start;
-- 
1.7.9.5

