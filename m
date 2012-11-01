Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab2KAGei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 02:34:38 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:47887
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753132Ab2KAGee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 02:34:34 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH] mtd: cmdlinepart: fix the overflow of big mtd partitions
Date: Thu, 1 Nov 2012 13:58:17 +0800
Message-ID: <1351749497-31692-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the kernel parses the following cmdline

	#mtdparts=gpmi-nand:16m(boot),16m(kernel),1g(home),4g(test),-(usr)

for a big nand chip Micron MT29F64G08AFAAAWP(8GB), we got the following wrong
result:

	.............................................
		"mtd: partition size too small (0)"
	.............................................

We can not get any partition.

The "4g(test)" partition triggers a overflow of the "size". The memparse()
returns 4g to the "size", but the size is "unsigned long" type, so a overflow
occurs, the "size" becomes zero in the end.

This patch changes the "size"/"offset" to "unsigned long long" type,
and replaces the UINT_MAX with ULLONG_MAX for macros SIZE_REMAINING and
OFFSET_CONTINUOUS.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/cmdlinepart.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index 4baab3b..1cfd741 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -56,8 +56,8 @@
 
 
 /* special size referring to all the remaining space in a partition */
-#define SIZE_REMAINING UINT_MAX
-#define OFFSET_CONTINUOUS UINT_MAX
+#define SIZE_REMAINING ULLONG_MAX
+#define OFFSET_CONTINUOUS ULLONG_MAX
 
 struct cmdline_mtd_partition {
 	struct cmdline_mtd_partition *next;
@@ -89,7 +89,7 @@ static struct mtd_partition * newpart(char *s,
 				      int extra_mem_size)
 {
 	struct mtd_partition *parts;
-	unsigned long size, offset = OFFSET_CONTINUOUS;
+	unsigned long long size, offset = OFFSET_CONTINUOUS;
 	char *name;
 	int name_len;
 	unsigned char *extra_mem;
@@ -104,7 +104,7 @@ static struct mtd_partition * newpart(char *s,
 	} else {
 		size = memparse(s, &s);
 		if (size < PAGE_SIZE) {
-			printk(KERN_ERR ERRP "partition size too small (%lx)\n", size);
+			printk(KERN_ERR ERRP "partition size too small (%llx)\n", size);
 			return ERR_PTR(-EINVAL);
 		}
 	}
@@ -296,7 +296,7 @@ static int parse_cmdline_partitions(struct mtd_info *master,
 				    struct mtd_partition **pparts,
 				    struct mtd_part_parser_data *data)
 {
-	unsigned long offset;
+	unsigned long long offset;
 	int i, err;
 	struct cmdline_mtd_partition *part;
 	const char *mtd_id = master->name;
-- 
1.7.0.4


