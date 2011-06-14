Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab1FNF0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 01:26:53 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:58298
	"EHLO CH1EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751699Ab1FNF0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 01:26:51 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <dhowells@redhat.com>, <gerg@snapgear.com>,
        <lethal@linux-sh.org>, <gerg@uclinux.org>, <geert@linux-m68k.org>,
        Bob Liu <lliubbo@gmail.com>
Subject: [PATCH] romfs: fix romfs_get_unmapped_area() param check
Date: Tue, 14 Jun 2011 13:36:10 +0800
Message-ID: <1308029770-6176-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

romfs_get_unmapped_area() check param len without considering PAGE_ALIGN which
will cause do_mmap_pgoff() return -EINVAL error after commit f67d9b1576c
nommu: add page_align to mmap.

This patch fix the param check by changing it to the same way which function
ramfs_nommu_get_unmapped_area() did in ramfs/file-nommu.c.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 fs/romfs/mmap-nommu.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/romfs/mmap-nommu.c b/fs/romfs/mmap-nommu.c
index f0511e8..eed9942 100644
--- a/fs/romfs/mmap-nommu.c
+++ b/fs/romfs/mmap-nommu.c
@@ -27,14 +27,18 @@ static unsigned long romfs_get_unmapped_area(struct file *file,
 {
 	struct inode *inode = file->f_mapping->host;
 	struct mtd_info *mtd = inode->i_sb->s_mtd;
-	unsigned long isize, offset;
+	unsigned long isize, offset, maxpages, lpages;
 
 	if (!mtd)
 		goto cant_map_directly;
 
+	/* the mapping mustn't extend beyond the EOF */
+	lpages = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	isize = i_size_read(inode);
 	offset = pgoff << PAGE_SHIFT;
-	if (offset > isize || len > isize || offset > isize - len)
+
+	maxpages = (isize + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if ((pgoff >= maxpages) || (maxpages - pgoff < lpages))
 		return (unsigned long) -EINVAL;
 
 	/* we need to call down to the MTD layer to do the actual mapping */
-- 
1.6.3.3


