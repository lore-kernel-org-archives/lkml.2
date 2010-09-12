Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab0ILNsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 09:48:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56449 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0ILNsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 09:48:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=qp8Yi/DML2ZVrimWUXzH+5BPs61bsT6vf1YNmgazwxT/afQ4lYfdnv7h1415e6rWea
         /0WKP8BYKtngvHxfciLs9hccbIjRchiEUOwhHWqEOY/ONe8Xf8leLIFZi1VZbFKgD/wC
         zU4K24syCNZbRWIGOuzC6gwAhrEzHWh4yjFvc=
Subject: [PATCH] ACPI: apei: Cast u64 to unsigned long, fix compile warning
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Len Brown <lenb@kernel.org>, Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Sep 2010 09:48:25 -0400
Message-ID: <1284299305.7239.4.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In today linux-net I got a compile warning in acpi/apei

drivers/acpi/apei/erst.c: In function ‘erst_exec_move_data’:
drivers/acpi/apei/erst.c:273: warning: cast to pointer from integer of different size
drivers/acpi/apei/erst.c:274: warning: cast to pointer from integer of different size

The problem is that apei_exec_context->dst_base type is u64.
But in 32 bits architecture void * is 32 bits long. 
Casting it to unsigned long solves the issue

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/acpi/apei/erst.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index a4904f1..37d7a05 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -270,8 +270,8 @@ static int erst_exec_move_data(struct apei_exec_context *ctx,
 	rc = __apei_exec_read_register(entry, &offset);
 	if (rc)
 		return rc;
-	memmove((void *)ctx->dst_base + offset,
-		(void *)ctx->src_base + offset,
+	memmove((void *)(unsigned long)ctx->dst_base + offset,
+		(void *)(unsigned long)ctx->src_base + offset,
 		ctx->var2);
 
 	return 0;
-- 
1.7.0.4



