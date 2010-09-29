Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab0I2LyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:54:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:51593 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab0I2LyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:54:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,252,1283756400"; 
   d="scan'208";a="559002021"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 5/5] ACPI, APEI, Fix ERST MOVE_DATA instruction implementation
Date: Wed, 29 Sep 2010 19:53:55 +0800
Message-Id: <1285761235-4751-6-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285761235-4751-1-git-send-email-ying.huang@intel.com>
References: <1285761235-4751-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The src_base and dst_base fields in apei_exec_context are physical
address, so they should be ioremaped before being used in ERST
MOVE_DATA instruction.

Reported-by: Javier Martinez Canillas <martinez.javier@gmail.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/erst.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -266,13 +266,30 @@ static int erst_exec_move_data(struct ap
 {
 	int rc;
 	u64 offset;
+	void *src, *dst;
+
+	/* ioremap does not work in interrupt context */
+	if (in_interrupt()) {
+		pr_warning(ERST_PFX
+			   "MOVE_DATA can not be used in interrupt context");
+		return -EBUSY;
+	}
 
 	rc = __apei_exec_read_register(entry, &offset);
 	if (rc)
 		return rc;
-	memmove((void *)(unsigned long)ctx->dst_base + offset,
-		(void *)(unsigned long)ctx->src_base + offset,
-		ctx->var2);
+
+	src = ioremap(ctx->src_base + offset, ctx->var2);
+	if (!src)
+		return -ENOMEM;
+	dst = ioremap(ctx->dst_base + offset, ctx->var2);
+	if (!dst)
+		return -ENOMEM;
+
+	memmove(dst, src, ctx->var2);
+
+	iounmap(src);
+	iounmap(dst);
 
 	return 0;
 }
