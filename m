Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab0HRSHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 14:07:35 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1596 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab0HRSHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 14:07:32 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Brian Norris" <norris@broadcom.com>
To: linux-mtd@lists.infradead.org
cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
        "Artem Bityutskiy" <dedekind1@gmail.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Brian Norris" <norris@broadcom.com>,
        "Sneha Narnakaje" <nsnehaprabha@ti.com>
Subject: [PATCH v2 1/2] mtd: nand: Expand nand_ecc_layout, deprecate
 ioctl ECCGETLAYOUT
Date: Wed, 18 Aug 2010 11:06:45 -0700
Message-ID: <1282154806-9420-2-git-send-email-norris@broadcom.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <4C5CA4A1.1040000@broadcom.com>
References: <4C5CA4A1.1040000@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 6072FEEB3KC81782382-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is strategy 2 of 2 strategies proposed for this deprecation.

struct nand_ecclayout is too small for many new chips; OOB regions can be as
large as 448 bytes and may increase more in the future. Thus, copying that
struct to user-space with the ECCGETLAYOUT ioctl is not a good idea; the ioctl
would have to be updated every time there's a change to the current largest
size.

Instead, the old nand_ecclayout is renamed to nand_ecclayout_user and a
new struct nand_ecclayout is created that can accomodate larger sizes and
expand without affecting the user-space.

A new function is provided to convert from the new to the old in order to
allow the deprecated ioctl to continue to work with truncated data. Perhaps
the ioctl, the conversion process, and the struct nand_ecclayout_user can be
removed altogether in the future.

Note: There are comments in nand/davinci_nand.c::nand_davinci_probe()
regarding this issue; this driver (and maybe others) can be updated to
account for extra space. All kernel drivers can use the expanded
nand_ecclayout as a drop-in replacement and ignore its benefits.

Signed-off-by: Brian Norris <norris@broadcom.com>
---
 drivers/mtd/mtdchar.c           |   48 ++++++++++++++++++++++++++++++++++++--
 drivers/mtd/nand/davinci_nand.c |    3 ++
 include/linux/mtd/mtd.h         |   15 ++++++++++++
 include/linux/mtd/partitions.h  |    2 +-
 include/mtd/mtd-abi.h           |    4 +-
 include/mtd/mtd-user.h          |    2 +-
 6 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index a825002..24d35ba 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -477,6 +477,39 @@ static int mtd_do_readoob(struct mtd_info *mtd, uint64_t start,
 	return ret;
 }
 
+/*
+ * Copies (and truncates, if necessary) data from the larger struct,
+ * nand_ecclayout, to the smaller, deprecated layout struct,
+ * nand_ecclayout_user. This is necessary only to suppport the deprecated
+ * API ioctl ECCGETLAYOUT while allowing all new functionality to use
+ * nand_ecclayout flexibly (i.e. the struct may change size in new
+ * releases without requiring major rewrites).
+ */
+static int shrink_ecclayout(const struct nand_ecclayout *from,
+		struct nand_ecclayout_user *to)
+{
+	int i;
+
+	if (!from || !to)
+		return -EINVAL;
+
+	memset(to, 0, sizeof(*to));
+
+	to->eccbytes = min((int)from->eccbytes, MTD_MAX_ECCPOS_ENTRIES_OLD);
+	for (i = 0; i < to->eccbytes; i++)
+		to->eccpos[i] = from->eccpos[i];
+
+	for (i = 0; i < MTD_MAX_OOBFREE_ENTRIES; i++) {
+		if (from->oobfree[i].length == 0 &&
+				from->oobfree[i].offset == 0)
+			break;
+		to->oobavail += from->oobfree[i].length;
+		to->oobfree[i] = from->oobfree[i];
+	}
+
+	return 0;
+}
+
 static int mtd_ioctl(struct file *file, u_int cmd, u_long arg)
 {
 	struct mtd_file_info *mfi = file->private_data;
@@ -812,14 +845,23 @@ static int mtd_ioctl(struct file *file, u_int cmd, u_long arg)
 	}
 #endif
 
+	/* This ioctl is being deprecated - it truncates the ecc layout */
 	case ECCGETLAYOUT:
 	{
+		struct nand_ecclayout_user *usrlay;
+
 		if (!mtd->ecclayout)
 			return -EOPNOTSUPP;
 
-		if (copy_to_user(argp, mtd->ecclayout,
-				 sizeof(struct nand_ecclayout)))
-			return -EFAULT;
+		usrlay = kmalloc(sizeof(*usrlay), GFP_KERNEL);
+		if (!usrlay)
+			return -ENOMEM;
+
+		shrink_ecclayout(mtd->ecclayout, usrlay);
+
+		if (copy_to_user(argp, usrlay, sizeof(*usrlay)))
+			ret = -EFAULT;
+		kfree(usrlay);
 		break;
 	}
 
diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index 2ac7367..70698e8 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -749,6 +749,9 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
 		 * breaks userspace ioctl interface with mtd-utils. Once we
 		 * resolve this issue, NAND_ECC_HW_OOB_FIRST mode can be used
 		 * for the 4KiB page chips.
+		 *
+		 * TODO: Note that nand_ecclayout has now been expanded and can
+		 *  hold plenty of OOB entries.
 		 */
 		dev_warn(&pdev->dev, "no 4-bit ECC support yet "
 				"for 4KiB-page NAND\n");
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 8485e42..03a1e95 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -110,6 +110,21 @@ struct mtd_oob_ops {
 	uint8_t		*oobbuf;
 };
 
+#define MTD_MAX_OOBFREE_ENTRIES_LARGE	32
+#define MTD_MAX_ECCPOS_ENTRIES_LARGE	448
+#define MTD_MAX_ECCPOS_ENTRIES_OLD	64	/* Previous maximum */
+/*
+ * Correct ECC layout control structure. This replaces old nand_ecclayout
+ * (mtd-abi.h) that is exported via ECCGETLAYOUT ioctl. It should be expandable
+ *  in the future simply by the above macros.
+ */
+struct nand_ecclayout {
+	__u32 eccbytes;
+	__u32 eccpos[MTD_MAX_ECCPOS_ENTRIES_LARGE];
+	__u32 oobavail;
+	struct nand_oobfree oobfree[MTD_MAX_OOBFREE_ENTRIES_LARGE];
+};
+
 struct mtd_info {
 	u_char type;
 	uint32_t flags;
diff --git a/include/linux/mtd/partitions.h b/include/linux/mtd/partitions.h
index 274b619..930c8ac 100644
--- a/include/linux/mtd/partitions.h
+++ b/include/linux/mtd/partitions.h
@@ -39,7 +39,7 @@ struct mtd_partition {
 	uint64_t size;			/* partition size */
 	uint64_t offset;		/* offset within the master MTD space */
 	uint32_t mask_flags;		/* master MTD flags to mask out for this partition */
-	struct nand_ecclayout *ecclayout;	/* out of band layout for this partition (NAND only)*/
+	struct nand_ecclayout *ecclayout;	/* out of band layout for this partition (NAND only) */
 };
 
 #define MTDPART_OFS_NXTBLK	(-2)
diff --git a/include/mtd/mtd-abi.h b/include/mtd/mtd-abi.h
index 4debb45..5bce083 100644
--- a/include/mtd/mtd-abi.h
+++ b/include/mtd/mtd-abi.h
@@ -119,7 +119,7 @@ struct otp_info {
 #define OTPGETREGIONCOUNT	_IOW('M', 14, int)
 #define OTPGETREGIONINFO	_IOW('M', 15, struct otp_info)
 #define OTPLOCK			_IOR('M', 16, struct otp_info)
-#define ECCGETLAYOUT		_IOR('M', 17, struct nand_ecclayout)
+#define ECCGETLAYOUT		_IOR('M', 17, struct nand_ecclayout_user)
 #define ECCGETSTATS		_IOR('M', 18, struct mtd_ecc_stats)
 #define MTDFILEMODE		_IO('M', 19)
 #define MEMERASE64		_IOW('M', 20, struct erase_info_user64)
@@ -148,7 +148,7 @@ struct nand_oobfree {
  * ECC layout control structure. Exported to userspace for
  * diagnosis and to allow creation of raw images
  */
-struct nand_ecclayout {
+struct nand_ecclayout_user {
 	__u32 eccbytes;
 	__u32 eccpos[64];
 	__u32 oobavail;
diff --git a/include/mtd/mtd-user.h b/include/mtd/mtd-user.h
index aa3c2f8..83327c8 100644
--- a/include/mtd/mtd-user.h
+++ b/include/mtd/mtd-user.h
@@ -29,6 +29,6 @@ typedef struct mtd_info_user mtd_info_t;
 typedef struct erase_info_user erase_info_t;
 typedef struct region_info_user region_info_t;
 typedef struct nand_oobinfo nand_oobinfo_t;
-typedef struct nand_ecclayout nand_ecclayout_t;
+typedef struct nand_ecclayout_user nand_ecclayout_t;
 
 #endif /* __MTD_USER_H__ */
-- 
1.7.0.4


