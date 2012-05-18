Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab2ERQfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:35:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758653Ab2ERQdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:31 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Michal Marek <mmarek@suse.cz>,
        Greg K H <gregkh@linuxfoundation.org>
Subject: [PATCH EDAC v26 46/66] edac: Get rid of the old kobj's from the edac mc code
Date: Fri, 18 May 2012 13:32:33 -0300
Message-Id: <1337358773-6919-47-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that al users for the old kobj raw access are gone,
we can get rid of the legacy kobj-based structures and
data.

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Greg K H <gregkh@linuxfoundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c      |    1 -
 drivers/edac/i5000_edac.c   |    3 ---
 drivers/edac/i82875p_edac.c |    4 ----
 include/linux/edac.h        |   30 ------------------------------
 4 files changed, 0 insertions(+), 38 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 3c2b8f7..df29884 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -371,7 +371,6 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	}
 
 	mci->op_state = OP_ALLOC;
-	INIT_LIST_HEAD(&mci->grp_kobj_list);
 
 	/* at this point, the root kobj is valid, and in order to
 	 * 'free' the object, then the function:
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 9146100..df93080 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1408,7 +1408,6 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	kobject_get(&mci->edac_mci_kobj);
 	debugf0("MC: %s: %s(): mci = %p\n", __FILE__, __func__, mci);
 
 	mci->pdev = &pdev->dev;	/* record ptr  to the generic device */
@@ -1481,7 +1480,6 @@ fail1:
 	i5000_put_devices(mci);
 
 fail0:
-	kobject_put(&mci->edac_mci_kobj);
 	edac_mc_free(mci);
 	return -ENODEV;
 }
@@ -1527,7 +1525,6 @@ static void __devexit i5000_remove_one(struct pci_dev *pdev)
 
 	/* retrieve references to resources, and free those resources */
 	i5000_put_devices(mci);
-	kobject_put(&mci->edac_mci_kobj);
 	edac_mc_free(mci);
 }
 
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index 7ab033d..333c86c 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -425,9 +425,6 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 		goto fail0;
 	}
 
-	/* Keeps mci available after edac_mc_del_mc() till edac_mc_free() */
-	kobject_get(&mci->edac_mci_kobj);
-
 	debugf3("%s(): init mci\n", __func__);
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR;
@@ -470,7 +467,6 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 	return 0;
 
 fail1:
-	kobject_put(&mci->edac_mci_kobj);
 	edac_mc_free(mci);
 
 fail0:
diff --git a/include/linux/edac.h b/include/linux/edac.h
index aeaafd0..08fdceb 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -456,7 +456,6 @@ struct dimm_info {
 	/* Memory location data */
 	unsigned location[EDAC_MAX_LAYERS];
 
-	struct kobject kobj;		/* sysfs kobject for this csrow */
 	struct mem_ctl_info *mci;	/* the parent */
 
 	u32 grain;		/* granularity of reported error in bytes */
@@ -510,34 +509,11 @@ struct csrow_info {
 
 	struct mem_ctl_info *mci;	/* the parent */
 
-	struct kobject kobj;	/* sysfs kobject for this csrow */
-
 	/* channel information for this csrow */
 	u32 nr_channels;
 	struct rank_info *channels;
 };
 
-struct mcidev_sysfs_group {
-	const char *name;				/* group name */
-	const struct mcidev_sysfs_attribute *mcidev_attr; /* group attributes */
-};
-
-/* mcidev_sysfs_attribute structure
- *	used for driver sysfs attributes and in mem_ctl_info
- * 	sysfs top level entries
- */
-struct mcidev_sysfs_attribute {
-	/* It should use either attr or grp */
-	struct attribute attr;
-	const struct mcidev_sysfs_group *grp;	/* Points to a group of attributes */
-
-	/* Ops for show/store values at the attribute - not used on group */
-	ssize_t (*show)(struct mem_ctl_info *, char *);
-	ssize_t (*store)(struct mem_ctl_info *, const char *, size_t);
-
-	void *priv;
-};
-
 /*
  * struct errcount_attribute - used to store the several error counts
  */
@@ -640,12 +616,6 @@ struct mem_ctl_info {
 
 	struct completion complete;
 
-	/* edac sysfs device control */
-	struct kobject edac_mci_kobj;
-
-	/* list for all grp instances within a mc */
-	struct list_head grp_kobj_list;
-
 	/* Additional top controller level attributes, but specified
 	 * by the low level driver.
 	 *
-- 
1.7.8

