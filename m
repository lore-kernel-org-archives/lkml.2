Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab2KHGzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 01:55:17 -0500
Received: from scrye.com ([75.148.32.185]:33615 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165Ab2KHGzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 01:55:16 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Nov 2012 01:55:16 EST
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 1/1] v3.0.x: mtd: check partition count not partition array pointer
From: Anthony Foiani <tkil@scrye.com>
Reply-To: Anthony Foiani <tkil@scrye.com>
X-Attribution: Tony
Date: Wed, 07 Nov 2012 23:48:24 -0700
Message-ID: <gpq3oh9on.fsf@dworkin.scrye.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b31 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mtd: check partition count not partition array pointer

The documentation claims that "nr_parts" is the determining factor,
while the code originally tested whether "parts" is non-null.

In at least one driver (fsl_elbc_nand), parts is never initialized to
0; even though nr_parts is correctly 0, add_mtd_partitions still tries
to create 0 partitions.)

Make the code adhere to the documentation.

A quick scan of all uses in the 3.0.51 kernel show that they correctly
rely on nr_parts rather than parts.

The current kernel has retired this function; I have not examined its
replacement to see if it has the same issue.

Signed-Off-By: Anthony Foiani <anthony.foiani@gmail.com>
---
 drivers/mtd/mtdcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index c510aff..ac624df 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -446,7 +446,7 @@ int mtd_device_register(struct mtd_info *master,
 			const struct mtd_partition *parts,
 			int nr_parts)
 {
-	return parts ? add_mtd_partitions(master, parts, nr_parts) :
+	return nr_parts ? add_mtd_partitions(master, parts, nr_parts) :
 		add_mtd_device(master);
 }
 EXPORT_SYMBOL_GPL(mtd_device_register);
--
1.7.11.7

