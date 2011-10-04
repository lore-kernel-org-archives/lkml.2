Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab1JDFXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 01:23:50 -0400
Received: from lunge.queued.net ([173.255.254.236]:49200 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab1JDFXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 01:23:48 -0400
Date: Mon, 3 Oct 2011 22:23:46 -0700
From: Andres Salomon <dilinger@queued.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [PATCH] mtd: rename the redboot module to RedBoot
Message-ID: <20111003222346.5ac48654@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parse_mtd_partitions takes a list of partition types; if the driver
isn't loaded, it attempts to load it, and then it grabs the partition
parser.  For redboot, the module name is "redboot.ko", while the parser
name is "RedBoot".  Since modprobe is case-sensitive, attempting to
modprobe "RedBoot" will never work.  I suspect the embedded systems that
make use of redboot just always manually loaded redboot prior to loading
their specific nand chip drivers (or statically compiled it in).

Alternatives include renaming the parser to "redboot", changing
parse_mtd_partitions to accept pairs of strings, or changing modprobe
to be case-insensitive.  Renaming the module seems like the easy,
obvious solution. :)

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mtd/Makefile  |    2 +-
 drivers/mtd/RedBoot.c |  315 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/redboot.c |  315 -------------------------------------------------
 3 files changed, 316 insertions(+), 316 deletions(-)
 create mode 100644 drivers/mtd/RedBoot.c
 delete mode 100644 drivers/mtd/redboot.c

diff --git a/drivers/mtd/Makefile b/drivers/mtd/Makefile
index 39664c4..2b6763c 100644
--- a/drivers/mtd/Makefile
+++ b/drivers/mtd/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_MTD)		+= mtd.o
 mtd-y				:= mtdcore.o mtdsuper.o mtdconcat.o mtdpart.o
 mtd-$(CONFIG_MTD_OF_PARTS)	+= ofpart.o
 
-obj-$(CONFIG_MTD_REDBOOT_PARTS) += redboot.o
+obj-$(CONFIG_MTD_REDBOOT_PARTS) += RedBoot.o
 obj-$(CONFIG_MTD_CMDLINE_PARTS) += cmdlinepart.o
 obj-$(CONFIG_MTD_AFS_PARTS)	+= afs.o
 obj-$(CONFIG_MTD_AR7_PARTS)	+= ar7part.o
diff --git a/drivers/mtd/RedBoot.c b/drivers/mtd/RedBoot.c
new file mode 100644
index 0000000..7a87d07
--- /dev/null
+++ b/drivers/mtd/RedBoot.c
@@ -0,0 +1,315 @@
+/*
+ * Parse RedBoot-style Flash Image System (FIS) tables and
+ * produce a Linux partition array to match.
+ *
+ * Copyright © 2001      Red Hat UK Limited
+ * Copyright © 2001-2010 David Woodhouse <dwmw2@infradead.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/vmalloc.h>
+
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+
+struct fis_image_desc {
+    unsigned char name[16];      // Null terminated name
+    uint32_t	  flash_base;    // Address within FLASH of image
+    uint32_t	  mem_base;      // Address in memory where it executes
+    uint32_t	  size;          // Length of image
+    uint32_t	  entry_point;   // Execution entry point
+    uint32_t	  data_length;   // Length of actual data
+    unsigned char _pad[256-(16+7*sizeof(uint32_t))];
+    uint32_t	  desc_cksum;    // Checksum over image descriptor
+    uint32_t	  file_cksum;    // Checksum over image data
+};
+
+struct fis_list {
+	struct fis_image_desc *img;
+	struct fis_list *next;
+};
+
+static int directory = CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK;
+module_param(directory, int, 0);
+
+static inline int redboot_checksum(struct fis_image_desc *img)
+{
+	/* RedBoot doesn't actually write the desc_cksum field yet AFAICT */
+	return 1;
+}
+
+static int parse_redboot_partitions(struct mtd_info *master,
+                             struct mtd_partition **pparts,
+                             unsigned long fis_origin)
+{
+	int nrparts = 0;
+	struct fis_image_desc *buf;
+	struct mtd_partition *parts;
+	struct fis_list *fl = NULL, *tmp_fl;
+	int ret, i;
+	size_t retlen;
+	char *names;
+	char *nullname;
+	int namelen = 0;
+	int nulllen = 0;
+	int numslots;
+	unsigned long offset;
+#ifdef CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED
+	static char nullstring[] = "unallocated";
+#endif
+
+	if ( directory < 0 ) {
+		offset = master->size + directory * master->erasesize;
+		while (master->block_isbad && 
+		       master->block_isbad(master, offset)) {
+			if (!offset) {
+			nogood:
+				printk(KERN_NOTICE "Failed to find a non-bad block to check for RedBoot partition table\n");
+				return -EIO;
+			}
+			offset -= master->erasesize;
+		}
+	} else {
+		offset = directory * master->erasesize;
+		while (master->block_isbad && 
+		       master->block_isbad(master, offset)) {
+			offset += master->erasesize;
+			if (offset == master->size)
+				goto nogood;
+		}
+	}
+	buf = vmalloc(master->erasesize);
+
+	if (!buf)
+		return -ENOMEM;
+
+	printk(KERN_NOTICE "Searching for RedBoot partition table in %s at offset 0x%lx\n",
+	       master->name, offset);
+
+	ret = master->read(master, offset,
+			   master->erasesize, &retlen, (void *)buf);
+
+	if (ret)
+		goto out;
+
+	if (retlen != master->erasesize) {
+		ret = -EIO;
+		goto out;
+	}
+
+	numslots = (master->erasesize / sizeof(struct fis_image_desc));
+	for (i = 0; i < numslots; i++) {
+		if (!memcmp(buf[i].name, "FIS directory", 14)) {
+			/* This is apparently the FIS directory entry for the
+			 * FIS directory itself.  The FIS directory size is
+			 * one erase block; if the buf[i].size field is
+			 * swab32(erasesize) then we know we are looking at
+			 * a byte swapped FIS directory - swap all the entries!
+			 * (NOTE: this is 'size' not 'data_length'; size is
+			 * the full size of the entry.)
+			 */
+
+			/* RedBoot can combine the FIS directory and
+			   config partitions into a single eraseblock;
+			   we assume wrong-endian if either the swapped
+			   'size' matches the eraseblock size precisely,
+			   or if the swapped size actually fits in an
+			   eraseblock while the unswapped size doesn't. */
+			if (swab32(buf[i].size) == master->erasesize ||
+			    (buf[i].size > master->erasesize
+			     && swab32(buf[i].size) < master->erasesize)) {
+				int j;
+				/* Update numslots based on actual FIS directory size */
+				numslots = swab32(buf[i].size) / sizeof (struct fis_image_desc);
+				for (j = 0; j < numslots; ++j) {
+
+					/* A single 0xff denotes a deleted entry.
+					 * Two of them in a row is the end of the table.
+					 */
+					if (buf[j].name[0] == 0xff) {
+				  		if (buf[j].name[1] == 0xff) {
+							break;
+						} else {
+							continue;
+						}
+					}
+
+					/* The unsigned long fields were written with the
+					 * wrong byte sex, name and pad have no byte sex.
+					 */
+					swab32s(&buf[j].flash_base);
+					swab32s(&buf[j].mem_base);
+					swab32s(&buf[j].size);
+					swab32s(&buf[j].entry_point);
+					swab32s(&buf[j].data_length);
+					swab32s(&buf[j].desc_cksum);
+					swab32s(&buf[j].file_cksum);
+				}
+			} else if (buf[i].size < master->erasesize) {
+				/* Update numslots based on actual FIS directory size */
+				numslots = buf[i].size / sizeof(struct fis_image_desc);
+			}
+			break;
+		}
+	}
+	if (i == numslots) {
+		/* Didn't find it */
+		printk(KERN_NOTICE "No RedBoot partition table detected in %s\n",
+		       master->name);
+		ret = 0;
+		goto out;
+	}
+
+	for (i = 0; i < numslots; i++) {
+		struct fis_list *new_fl, **prev;
+
+		if (buf[i].name[0] == 0xff) {
+			if (buf[i].name[1] == 0xff) {
+				break;
+			} else {
+				continue;
+			}
+		}
+		if (!redboot_checksum(&buf[i]))
+			break;
+
+		new_fl = kmalloc(sizeof(struct fis_list), GFP_KERNEL);
+		namelen += strlen(buf[i].name)+1;
+		if (!new_fl) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		new_fl->img = &buf[i];
+                if (fis_origin) {
+                        buf[i].flash_base -= fis_origin;
+                } else {
+                        buf[i].flash_base &= master->size-1;
+                }
+
+		/* I'm sure the JFFS2 code has done me permanent damage.
+		 * I now think the following is _normal_
+		 */
+		prev = &fl;
+		while(*prev && (*prev)->img->flash_base < new_fl->img->flash_base)
+			prev = &(*prev)->next;
+		new_fl->next = *prev;
+		*prev = new_fl;
+
+		nrparts++;
+	}
+#ifdef CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED
+	if (fl->img->flash_base) {
+		nrparts++;
+		nulllen = sizeof(nullstring);
+	}
+
+	for (tmp_fl = fl; tmp_fl->next; tmp_fl = tmp_fl->next) {
+		if (tmp_fl->img->flash_base + tmp_fl->img->size + master->erasesize <= tmp_fl->next->img->flash_base) {
+			nrparts++;
+			nulllen = sizeof(nullstring);
+		}
+	}
+#endif
+	parts = kzalloc(sizeof(*parts)*nrparts + nulllen + namelen, GFP_KERNEL);
+
+	if (!parts) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	nullname = (char *)&parts[nrparts];
+#ifdef CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED
+	if (nulllen > 0) {
+		strcpy(nullname, nullstring);
+	}
+#endif
+	names = nullname + nulllen;
+
+	i=0;
+
+#ifdef CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED
+	if (fl->img->flash_base) {
+	       parts[0].name = nullname;
+	       parts[0].size = fl->img->flash_base;
+	       parts[0].offset = 0;
+		i++;
+	}
+#endif
+	for ( ; i<nrparts; i++) {
+		parts[i].size = fl->img->size;
+		parts[i].offset = fl->img->flash_base;
+		parts[i].name = names;
+
+		strcpy(names, fl->img->name);
+#ifdef CONFIG_MTD_REDBOOT_PARTS_READONLY
+		if (!memcmp(names, "RedBoot", 8) ||
+				!memcmp(names, "RedBoot config", 15) ||
+				!memcmp(names, "FIS directory", 14)) {
+			parts[i].mask_flags = MTD_WRITEABLE;
+		}
+#endif
+		names += strlen(names)+1;
+
+#ifdef CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED
+		if(fl->next && fl->img->flash_base + fl->img->size + master->erasesize <= fl->next->img->flash_base) {
+			i++;
+			parts[i].offset = parts[i-1].size + parts[i-1].offset;
+			parts[i].size = fl->next->img->flash_base - parts[i].offset;
+			parts[i].name = nullname;
+		}
+#endif
+		tmp_fl = fl;
+		fl = fl->next;
+		kfree(tmp_fl);
+	}
+	ret = nrparts;
+	*pparts = parts;
+ out:
+	while (fl) {
+		struct fis_list *old = fl;
+		fl = fl->next;
+		kfree(old);
+	}
+	vfree(buf);
+	return ret;
+}
+
+static struct mtd_part_parser redboot_parser = {
+	.owner = THIS_MODULE,
+	.parse_fn = parse_redboot_partitions,
+	.name = "RedBoot",
+};
+
+static int __init redboot_parser_init(void)
+{
+	return register_mtd_parser(&redboot_parser);
+}
+
+static void __exit redboot_parser_exit(void)
+{
+	deregister_mtd_parser(&redboot_parser);
+}
+
+module_init(redboot_parser_init);
+module_exit(redboot_parser_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
+MODULE_DESCRIPTION("Parsing code for RedBoot Flash Image System (FIS) tables");
diff --git a/drivers/mtd/redboot.c b/drivers/mtd/redboot.c
deleted file mode 100644
index 7a87d07..0000000
--- a/drivers/mtd/redboot.c
+++ /dev/null
@@ -1,315 +0,0 @@
-/*
- * Parse RedBoot-style Flash Image System (FIS) tables and
- * produce a Linux partition array to match.
- *
- * Copyright © 2001      Red Hat UK Limited
- * Copyright © 2001-2010 David Woodhouse <dwmw2@infradead.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/init.h>
-#include <linux/vmalloc.h>
-
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/partitions.h>
-
-struct fis_image_desc {
-    unsigned char name[16];      // Null terminated name
-    uint32_t	  flash_base;    // Address within FLASH of image
-    uint32_t	  mem_base;      // Address in memory where it executes
-    uint32_t	  size;          // Length of image
-    uint32_t	  entry_point;   // Execution entry point
-    uint32_t	  data_length;   // Length of actual data
-    unsigned char _pad[256-(16+7*sizeof(uint32_t))];
-    uint32_t	  desc_cksum;    // Checksum over image descriptor
-    uint32_t	  file_cksum;    // Checksum over image data
-};
-
-struct fis_list {
-	struct fis_image_desc *img;
-	struct fis_list *next;
-};
-
-static int directory = CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK;
-module_param(directory, int, 0);
-
-static inline int redboot_checksum(struct fis_image_desc *img)
-{
-	/* RedBoot doesn't actually write the desc_cksum field yet AFAICT */
-	return 1;
-}
-
-static int parse_redboot_partitions(struct mtd_info *master,
-                             struct mtd_partition **pparts,
-                             unsigned long fis_origin)
-{
-	int nrparts = 0;
-	struct fis_image_desc *buf;
-	struct mtd_partition *parts;
-	struct fis_list *fl = NULL, *tmp_fl;
-	int ret, i;
-	size_t retlen;
-	char *names;
-	char *nullname;
-	int namelen = 0;
-	int nulllen = 0;
-	int numslots;
-	unsigned long offset;
-#ifdef CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED
-	static char nullstring[] = "unallocated";
-#endif
-
-	if ( directory < 0 ) {
-		offset = master->size + directory * master->erasesize;
-		while (master->block_isbad && 
-		       master->block_isbad(master, offset)) {
-			if (!offset) {
-			nogood:
-				printk(KERN_NOTICE "Failed to find a non-bad block to check for RedBoot partition table\n");
-				return -EIO;
-			}
-			offset -= master->erasesize;
-		}
-	} else {
-		offset = directory * master->erasesize;
-		while (master->block_isbad && 
-		       master->block_isbad(master, offset)) {
-			offset += master->erasesize;
-			if (offset == master->size)
-				goto nogood;
-		}
-	}
-	buf = vmalloc(master->erasesize);
-
-	if (!buf)
-		return -ENOMEM;
-
-	printk(KERN_NOTICE "Searching for RedBoot partition table in %s at offset 0x%lx\n",
-	       master->name, offset);
-
-	ret = master->read(master, offset,
-			   master->erasesize, &retlen, (void *)buf);
-
-	if (ret)
-		goto out;
-
-	if (retlen != master->erasesize) {
-		ret = -EIO;
-		goto out;
-	}
-
-	numslots = (master->erasesize / sizeof(struct fis_image_desc));
-	for (i = 0; i < numslots; i++) {
-		if (!memcmp(buf[i].name, "FIS directory", 14)) {
-			/* This is apparently the FIS directory entry for the
-			 * FIS directory itself.  The FIS directory size is
-			 * one erase block; if the buf[i].size field is
-			 * swab32(erasesize) then we know we are looking at
-			 * a byte swapped FIS directory - swap all the entries!
-			 * (NOTE: this is 'size' not 'data_length'; size is
-			 * the full size of the entry.)
-			 */
-
-			/* RedBoot can combine the FIS directory and
-			   config partitions into a single eraseblock;
-			   we assume wrong-endian if either the swapped
-			   'size' matches the eraseblock size precisely,
-			   or if the swapped size actually fits in an
-			   eraseblock while the unswapped size doesn't. */
-			if (swab32(buf[i].size) == master->erasesize ||
-			    (buf[i].size > master->erasesize
-			     && swab32(buf[i].size) < master->erasesize)) {
-				int j;
-				/* Update numslots based on actual FIS directory size */
-				numslots = swab32(buf[i].size) / sizeof (struct fis_image_desc);
-				for (j = 0; j < numslots; ++j) {
-
-					/* A single 0xff denotes a deleted entry.
-					 * Two of them in a row is the end of the table.
-					 */
-					if (buf[j].name[0] == 0xff) {
-				  		if (buf[j].name[1] == 0xff) {
-							break;
-						} else {
-							continue;
-						}
-					}
-
-					/* The unsigned long fields were written with the
-					 * wrong byte sex, name and pad have no byte sex.
-					 */
-					swab32s(&buf[j].flash_base);
-					swab32s(&buf[j].mem_base);
-					swab32s(&buf[j].size);
-					swab32s(&buf[j].entry_point);
-					swab32s(&buf[j].data_length);
-					swab32s(&buf[j].desc_cksum);
-					swab32s(&buf[j].file_cksum);
-				}
-			} else if (buf[i].size < master->erasesize) {
-				/* Update numslots based on actual FIS directory size */
-				numslots = buf[i].size / sizeof(struct fis_image_desc);
-			}
-			break;
-		}
-	}
-	if (i == numslots) {
-		/* Didn't find it */
-		printk(KERN_NOTICE "No RedBoot partition table detected in %s\n",
-		       master->name);
-		ret = 0;
-		goto out;
-	}
-
-	for (i = 0; i < numslots; i++) {
-		struct fis_list *new_fl, **prev;
-
-		if (buf[i].name[0] == 0xff) {
-			if (buf[i].name[1] == 0xff) {
-				break;
-			} else {
-				continue;
-			}
-		}
-		if (!redboot_checksum(&buf[i]))
-			break;
-
-		new_fl = kmalloc(sizeof(struct fis_list), GFP_KERNEL);
-		namelen += strlen(buf[i].name)+1;
-		if (!new_fl) {
-			ret = -ENOMEM;
-			goto out;
-		}
-		new_fl->img = &buf[i];
-                if (fis_origin) {
-                        buf[i].flash_base -= fis_origin;
-                } else {
-                        buf[i].flash_base &= master->size-1;
-                }
-
-		/* I'm sure the JFFS2 code has done me permanent damage.
-		 * I now think the following is _normal_
-		 */
-		prev = &fl;
-		while(*prev && (*prev)->img->flash_base < new_fl->img->flash_base)
-			prev = &(*prev)->next;
-		new_fl->next = *prev;
-		*prev = new_fl;
-
-		nrparts++;
-	}
-#ifdef CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED
-	if (fl->img->flash_base) {
-		nrparts++;
-		nulllen = sizeof(nullstring);
-	}
-
-	for (tmp_fl = fl; tmp_fl->next; tmp_fl = tmp_fl->next) {
-		if (tmp_fl->img->flash_base + tmp_fl->img->size + master->erasesize <= tmp_fl->next->img->flash_base) {
-			nrparts++;
-			nulllen = sizeof(nullstring);
-		}
-	}
-#endif
-	parts = kzalloc(sizeof(*parts)*nrparts + nulllen + namelen, GFP_KERNEL);
-
-	if (!parts) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	nullname = (char *)&parts[nrparts];
-#ifdef CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED
-	if (nulllen > 0) {
-		strcpy(nullname, nullstring);
-	}
-#endif
-	names = nullname + nulllen;
-
-	i=0;
-
-#ifdef CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED
-	if (fl->img->flash_base) {
-	       parts[0].name = nullname;
-	       parts[0].size = fl->img->flash_base;
-	       parts[0].offset = 0;
-		i++;
-	}
-#endif
-	for ( ; i<nrparts; i++) {
-		parts[i].size = fl->img->size;
-		parts[i].offset = fl->img->flash_base;
-		parts[i].name = names;
-
-		strcpy(names, fl->img->name);
-#ifdef CONFIG_MTD_REDBOOT_PARTS_READONLY
-		if (!memcmp(names, "RedBoot", 8) ||
-				!memcmp(names, "RedBoot config", 15) ||
-				!memcmp(names, "FIS directory", 14)) {
-			parts[i].mask_flags = MTD_WRITEABLE;
-		}
-#endif
-		names += strlen(names)+1;
-
-#ifdef CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED
-		if(fl->next && fl->img->flash_base + fl->img->size + master->erasesize <= fl->next->img->flash_base) {
-			i++;
-			parts[i].offset = parts[i-1].size + parts[i-1].offset;
-			parts[i].size = fl->next->img->flash_base - parts[i].offset;
-			parts[i].name = nullname;
-		}
-#endif
-		tmp_fl = fl;
-		fl = fl->next;
-		kfree(tmp_fl);
-	}
-	ret = nrparts;
-	*pparts = parts;
- out:
-	while (fl) {
-		struct fis_list *old = fl;
-		fl = fl->next;
-		kfree(old);
-	}
-	vfree(buf);
-	return ret;
-}
-
-static struct mtd_part_parser redboot_parser = {
-	.owner = THIS_MODULE,
-	.parse_fn = parse_redboot_partitions,
-	.name = "RedBoot",
-};
-
-static int __init redboot_parser_init(void)
-{
-	return register_mtd_parser(&redboot_parser);
-}
-
-static void __exit redboot_parser_exit(void)
-{
-	deregister_mtd_parser(&redboot_parser);
-}
-
-module_init(redboot_parser_init);
-module_exit(redboot_parser_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
-MODULE_DESCRIPTION("Parsing code for RedBoot Flash Image System (FIS) tables");
-- 
1.7.2.5

