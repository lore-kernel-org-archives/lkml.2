Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964858Ab2AEWhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 17:37:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933011Ab2AEWhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 17:37:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jan  5 14:29:56 2012
Message-Id: <20120105222956.764472986@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Thu, 05 Jan 2012 14:30:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [49/80] mpt2sas: fix non-x86 crash on shutdown
In-Reply-To: <20120105223610.GA9914@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 4496
Lines: 151


From: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>

Upstrem commit: 911ae9434f83e7355d343f6c2be3ef5b00ea7aed

There's a bug in the MSIX backup and restore routines that cause a crash on
non-x86 (direct access to PCI space not via read/write).  These routines are
unnecessary and were removed by the above commit, so also remove them from
stable to fix the crash.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_base.c |   59 +-----------------------------------
 drivers/scsi/mpt2sas/mpt2sas_base.h |    4 --
 2 files changed, 2 insertions(+), 61 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1082,41 +1082,6 @@ _base_config_dma_addressing(struct MPT2S
 }
 
 /**
- * _base_save_msix_table - backup msix vector table
- * @ioc: per adapter object
- *
- * This address an errata where diag reset clears out the table
- */
-static void
-_base_save_msix_table(struct MPT2SAS_ADAPTER *ioc)
-{
-	int i;
-
-	if (!ioc->msix_enable || ioc->msix_table_backup == NULL)
-		return;
-
-	for (i = 0; i < ioc->msix_vector_count; i++)
-		ioc->msix_table_backup[i] = ioc->msix_table[i];
-}
-
-/**
- * _base_restore_msix_table - this restores the msix vector table
- * @ioc: per adapter object
- *
- */
-static void
-_base_restore_msix_table(struct MPT2SAS_ADAPTER *ioc)
-{
-	int i;
-
-	if (!ioc->msix_enable || ioc->msix_table_backup == NULL)
-		return;
-
-	for (i = 0; i < ioc->msix_vector_count; i++)
-		ioc->msix_table[i] = ioc->msix_table_backup[i];
-}
-
-/**
  * _base_check_enable_msix - checks MSIX capabable.
  * @ioc: per adapter object
  *
@@ -1128,7 +1093,7 @@ _base_check_enable_msix(struct MPT2SAS_A
 {
 	int base;
 	u16 message_control;
-	u32 msix_table_offset;
+
 
 	base = pci_find_capability(ioc->pdev, PCI_CAP_ID_MSIX);
 	if (!base) {
@@ -1141,14 +1106,8 @@ _base_check_enable_msix(struct MPT2SAS_A
 	pci_read_config_word(ioc->pdev, base + 2, &message_control);
 	ioc->msix_vector_count = (message_control & 0x3FF) + 1;
 
-	/* get msix table  */
-	pci_read_config_dword(ioc->pdev, base + 4, &msix_table_offset);
-	msix_table_offset &= 0xFFFFFFF8;
-	ioc->msix_table = (u32 *)((void *)ioc->chip + msix_table_offset);
-
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "msix is supported, "
-	    "vector_count(%d), table_offset(0x%08x), table(%p)\n", ioc->name,
-	    ioc->msix_vector_count, msix_table_offset, ioc->msix_table));
+	    "vector_count(%d)\n", ioc->name, ioc->msix_vector_count));
 	return 0;
 }
 
@@ -1162,8 +1121,6 @@ _base_disable_msix(struct MPT2SAS_ADAPTE
 {
 	if (ioc->msix_enable) {
 		pci_disable_msix(ioc->pdev);
-		kfree(ioc->msix_table_backup);
-		ioc->msix_table_backup = NULL;
 		ioc->msix_enable = 0;
 	}
 }
@@ -1189,14 +1146,6 @@ _base_enable_msix(struct MPT2SAS_ADAPTER
 	if (_base_check_enable_msix(ioc) != 0)
 		goto try_ioapic;
 
-	ioc->msix_table_backup = kcalloc(ioc->msix_vector_count,
-	    sizeof(u32), GFP_KERNEL);
-	if (!ioc->msix_table_backup) {
-		dfailprintk(ioc, printk(MPT2SAS_INFO_FMT "allocation for "
-		    "msix_table_backup failed!!!\n", ioc->name));
-		goto try_ioapic;
-	}
-
 	memset(&entries, 0, sizeof(struct msix_entry));
 	r = pci_enable_msix(ioc->pdev, &entries, 1);
 	if (r) {
@@ -3513,9 +3462,6 @@ _base_diag_reset(struct MPT2SAS_ADAPTER
 	u32 hcb_size;
 
 	printk(MPT2SAS_INFO_FMT "sending diag reset !!\n", ioc->name);
-
-	_base_save_msix_table(ioc);
-
 	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "clear interrupts\n",
 	    ioc->name));
 
@@ -3611,7 +3557,6 @@ _base_diag_reset(struct MPT2SAS_ADAPTER
 		goto out;
 	}
 
-	_base_restore_msix_table(ioc);
 	printk(MPT2SAS_INFO_FMT "diag reset: SUCCESS\n", ioc->name);
 	return 0;
 
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -636,8 +636,6 @@ enum mutex_type {
  * @wait_for_port_enable_to_complete:
  * @msix_enable: flag indicating msix is enabled
  * @msix_vector_count: number msix vectors
- * @msix_table: virt address to the msix table
- * @msix_table_backup: backup msix table
  * @scsi_io_cb_idx: shost generated commands
  * @tm_cb_idx: task management commands
  * @scsih_cb_idx: scsih internal commands
@@ -779,8 +777,6 @@ struct MPT2SAS_ADAPTER {
 
 	u8		msix_enable;
 	u16		msix_vector_count;
-	u32		*msix_table;
-	u32		*msix_table_backup;
 	u32		ioc_reset_count;
 
 	/* internal commands, callback index */


