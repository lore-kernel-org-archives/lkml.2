Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab0HYBMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 21:12:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43040 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab0HYBMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 21:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :x-antivirus:x-antivirus-status;
        b=owcLlB802nkunBZoiEdq6KHc5OpnEzUrlJ5DM8hlr+xQboZkAY1z3Wz0CI8tUZDwKR
         m5wr5OPu+lakiiAvnEHghqLKq2wfmvWGoMNq6yp+2hSwatS8EDQsCpNLM1b20rE3a6YA
         0aNt4/9DKRCJA80OFDvxaNqJJosI6iCAukzhg=
Message-ID: <4C746DE0.7000104@gmail.com>
Date: Tue, 24 Aug 2010 18:12:00 -0700
From: Brian Norris <computersforpeace@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Sneha Narnakaje <nsnehaprabha@ti.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>
Subject: [PATCH v4] mtd: nand: Expand nand_ecc_layout, deprecate ioctl ECCGETLAYOUT
References: <4C5CA4A1.1040000@broadcom.com>	<1282154806-9420-1-git-send-email-norris@broadcom.com>	<4C6DD170.1060807@renesas.com>  <4C6E9C23.6060703@broadcom.com> <1282646703.24044.162.camel@localhost>
In-Reply-To: <1282646703.24044.162.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 100824-1, 08/24/2010), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

My e-mail address has changed, since I am no longer working at Broadcom.
I will still be able to track messages to my old account if the MTD mailing
list is CC'd.

On 8/24/2010 3:45 AM, Artem Bityutskiy wrote:
> On Fri, 2010-08-20 at 08:15 -0700, Brian Norris wrote:
>> So this leaves the important patch set as the following two independent, 
>> slightly different approaches to the same problem; we should choose 
>> between them:
>> [PATCH v3 1/2] mtd: Expand...
>> [PATCH v2 2/2] mtd: nand: Expand...
> 
> Could you please re-send up-to date (against current mtd-2.6.git tree)
> patches which implement your strategy #2? I'd add them to my l2 tree.
> 

Sure; ditch the first strategy, and go with this "v4" patch. It is (going
forward) the *only* patch (no PATCH 1/2, 2/2 nonsense). AFAIK this is
against the latest mtd-2.6.git and has no major changes from previous
"versions".

Note that on the same subject (different thread) David suggested our new
struct be allocated dynamically:

On 8/20/2010 2:38 PM, David Woodhouse wrote:
> Perhaps these buffers should be dynamically allocated and we should
> ditch the MAX macros altogether?

For the moment, I think that statically declared sizes are the best solution
mainly for the following reason: they don't require major changes to other
drivers. If we dynamically allocate these, then many drivers will probably
need a whole to adapt considerably.

Besides, I don't have the time now to work on a whole new dynamic approach.
Perhaps I can address this in the future, or it can be left to someone else.

---------------------------------------------------------------------------

struct nand_ecclayout is too small for many new chips; OOB regions can be as
large as 448 bytes and may increase more in the future. Thus, copying that
struct to user-space with the ECCGETLAYOUT ioctl is not a good idea; the ioctl
would have to be updated every time there's a change to the current largest
size.

Instead, the old nand_ecclayout is renamed to nand_ecclayout_user and a
new struct nand_ecclayout is created that can accomodate larger sizes and
expand without affecting the user-space. struct nand_ecclayout can still
be used in board drivers without modification -- at least for now.

A new function is provided to convert from the new to the old in order to
allow the deprecated ioctl to continue to work with truncated data. Perhaps
the ioctl, the conversion process, and the struct nand_ecclayout_user can be
removed altogether in the future.

Note: There are comments in nand/davinci_nand.c::nand_davinci_probe()
regarding this issue; this driver (and maybe others) can be updated to
account for extra space. All kernel drivers can use the expanded
nand_ecclayout as a drop-in replacement and ignore its benefits.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
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

