Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab0HHMXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 08:23:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:43386 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab0HHMXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 08:23:36 -0400
Subject: RE: [PATCH 1/2] mtdpart: memory accessor interface for MTD layer
From: David Woodhouse <dwmw2@infradead.org>
To: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: "'David Brownell'" <david-b@pacbell.net>,
        "'Bernd Schmidt'" <bernd.schmidt@analog.com>,
        "'Nicolas Pitre'" <nico@fluxnic.net>,
        "'Kevin Hilman'" <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, "'David Howells'" <dhowells@redhat.com>,
        "'David Brownell'" <dbrownell@users.sourceforge.net>,
        linux-mtd@lists.infradead.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>
In-Reply-To: <000401cb3533$5c982470$15c86d50$@raj@ti.com>
References: <350720.60481.qm@web180309.mail.gq1.yahoo.com>
	 <1280920127.19499.20.camel@localhost>
	 <000401cb3533$5c982470$15c86d50$@raj@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Aug 2010 13:23:18 +0100
Message-ID: <1281270198.19967.258.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 12:18 +0530, Sudhakar Rajashekhara wrote:
> 
> Thanks for the feedback. I'll be re-working on this patch and will
> re-post
> the updated patch soon. 

Start with this, perhaps...

Subject: mtd/partitions: Add add_mtd_partitions_ret() function

Some callers want access to the MTD devices which get registered for
them when they call add_mtd_partitions(). Add a variant on the function
which does that.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 4c539de..b9ee79b 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -522,26 +522,36 @@ out_register:
  * for reasons of data integrity.
  */
 
-int add_mtd_partitions(struct mtd_info *master,
-		       const struct mtd_partition *parts,
-		       int nbparts)
+int add_mtd_partitions_ret(struct mtd_info *master,
+			   const struct mtd_partition *parts,
+			   int nbparts, struct mtd_info ***mtds_ret)
 {
 	struct mtd_part *slave;
 	uint64_t cur_offset = 0;
+	struct mtd_info **mtds = NULL;
 	int i;
 
 	printk(KERN_NOTICE "Creating %d MTD partitions on \"%s\":\n", nbparts, master->name);
 
+	if (mtds_ret) {
+		mtds = kmalloc(sizeof(*mtds) * nbparts, GFP_KERNEL);
+		if (!mtds)
+			return -ENOMEM;
+	}
 	for (i = 0; i < nbparts; i++) {
 		slave = add_one_partition(master, parts + i, i, cur_offset);
-		if (!slave)
+		if (!slave) {
+			kfree(mtds);
 			return -ENOMEM;
+		}
 		cur_offset = slave->offset + slave->mtd.size;
 	}
 
+	if (mtds_ret)
+		*mtds_ret = mtds;
 	return 0;
 }
-EXPORT_SYMBOL(add_mtd_partitions);
+EXPORT_SYMBOL_GPL(add_mtd_partitions_ret);
 
 static DEFINE_SPINLOCK(part_parser_lock);
 static LIST_HEAD(part_parsers);
diff --git a/include/linux/mtd/partitions.h b/include/linux/mtd/partitions.h
index 274b619..f7935fa 100644
--- a/include/linux/mtd/partitions.h
+++ b/include/linux/mtd/partitions.h
@@ -49,9 +49,12 @@ struct mtd_partition {
 
 struct mtd_info;
 
-int add_mtd_partitions(struct mtd_info *, const struct mtd_partition *, int);
+int add_mtd_partitions_ret(struct mtd_info *, const struct mtd_partition *, int,
+			   struct mtd_info ***);
 int del_mtd_partitions(struct mtd_info *);
 
+#define add_mtd_partitions(m, p, n) add_mtd_partitions_ret(m, p, n, NULL)
+
 /*
  * Functions dealing with the various ways of partitioning the space
  */

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

