Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab0GESq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 14:46:28 -0400
Received: from kroah.org ([198.145.64.141]:35200 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab0GESoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 14:44:13 -0400
Date: Mon, 5 Jul 2010 11:35:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.48
Message-ID: <20100705183558.GB31678@kroah.com>
References: <20100705183537.GA31678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100705183537.GA31678@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index efc948f..6411139 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .47
+EXTRAVERSION = .48
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/parisc/math-emu/decode_exc.c b/arch/parisc/math-emu/decode_exc.c
index 66c8a9f..62ebcde 100644
--- a/arch/parisc/math-emu/decode_exc.c
+++ b/arch/parisc/math-emu/decode_exc.c
@@ -342,6 +342,7 @@ decode_fpu(unsigned int Fpu_register[], unsigned int trap_counts[])
 		return SIGNALCODE(SIGFPE, FPE_FLTINV);
 	  case DIVISIONBYZEROEXCEPTION:
 		update_trap_counts(Fpu_register, aflags, bflags, trap_counts);
+		Clear_excp_register(exception_index);
 	  	return SIGNALCODE(SIGFPE, FPE_FLTDIV);
 	  case INEXACTEXCEPTION:
 		update_trap_counts(Fpu_register, aflags, bflags, trap_counts);
diff --git a/arch/powerpc/lib/string.S b/arch/powerpc/lib/string.S
index 64e2e49..3ac0cd3 100644
--- a/arch/powerpc/lib/string.S
+++ b/arch/powerpc/lib/string.S
@@ -71,7 +71,7 @@ _GLOBAL(strcmp)
 
 _GLOBAL(strncmp)
 	PPC_LCMPI r5,0
-	beqlr
+	ble-	2f
 	mtctr	r5
 	addi	r5,r3,-1
 	addi	r4,r4,-1
@@ -82,6 +82,8 @@ _GLOBAL(strncmp)
 	beqlr	1
 	bdnzt	eq,1b
 	blr
+2:	li	r3,0
+	blr
 
 _GLOBAL(strlen)
 	addi	r4,r3,-1
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index 5ff4de3..303721d 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -821,7 +821,7 @@ static int calculate_lfsr(int n)
 		index = ENTRIES-1;
 
 	/* make sure index is valid */
-	if ((index > ENTRIES) || (index < 0))
+	if ((index >= ENTRIES) || (index < 0))
 		index = ENTRIES-1;
 
 	return initial_lfsr[index];
diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index 1f03248..ca5e7b0 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -66,30 +66,6 @@ static void pseries_mach_cpu_die(void)
 	for(;;);
 }
 
-static int qcss_tok;	/* query-cpu-stopped-state token */
-
-/* Get state of physical CPU.
- * Return codes:
- *	0	- The processor is in the RTAS stopped state
- *	1	- stop-self is in progress
- *	2	- The processor is not in the RTAS stopped state
- *	-1	- Hardware Error
- *	-2	- Hardware Busy, Try again later.
- */
-static int query_cpu_stopped(unsigned int pcpu)
-{
-	int cpu_status, status;
-
-	status = rtas_call(qcss_tok, 1, 2, &cpu_status, pcpu);
-	if (status != 0) {
-		printk(KERN_ERR
-		       "RTAS query-cpu-stopped-state failed: %i\n", status);
-		return status;
-	}
-
-	return cpu_status;
-}
-
 static int pseries_cpu_disable(void)
 {
 	int cpu = smp_processor_id();
@@ -113,8 +89,9 @@ static void pseries_cpu_die(unsigned int cpu)
 	unsigned int pcpu = get_hard_smp_processor_id(cpu);
 
 	for (tries = 0; tries < 25; tries++) {
-		cpu_status = query_cpu_stopped(pcpu);
-		if (cpu_status == 0 || cpu_status == -1)
+		cpu_status = smp_query_cpu_stopped(pcpu);
+		if (cpu_status == QCSS_STOPPED ||
+		    cpu_status == QCSS_HARDWARE_ERROR)
 			break;
 		msleep(200);
 	}
@@ -256,6 +233,7 @@ static int __init pseries_cpu_hotplug_init(void)
 {
 	struct device_node *np;
 	const char *typep;
+	int qcss_tok;
 
 	for_each_node_by_name(np, "interrupt-controller") {
 		typep = of_get_property(np, "compatible", NULL);
diff --git a/arch/powerpc/platforms/pseries/plpar_wrappers.h b/arch/powerpc/platforms/pseries/plpar_wrappers.h
index d967c18..1adef11 100644
--- a/arch/powerpc/platforms/pseries/plpar_wrappers.h
+++ b/arch/powerpc/platforms/pseries/plpar_wrappers.h
@@ -4,6 +4,14 @@
 #include <asm/hvcall.h>
 #include <asm/page.h>
 
+/* Get state of physical CPU from query_cpu_stopped */
+int smp_query_cpu_stopped(unsigned int pcpu);
+#define QCSS_STOPPED 0
+#define QCSS_STOPPING 1
+#define QCSS_NOT_STOPPED 2
+#define QCSS_HARDWARE_ERROR -1
+#define QCSS_HARDWARE_BUSY -2
+
 static inline long poll_pending(void)
 {
 	return plpar_hcall_norets(H_POLL_PENDING);
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index c9337c7..db0cbbb 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -59,6 +59,28 @@ static cpumask_t of_spin_map;
 
 extern void generic_secondary_smp_init(unsigned long);
 
+/* Query where a cpu is now.  Return codes #defined in plpar_wrappers.h */
+int smp_query_cpu_stopped(unsigned int pcpu)
+{
+	int cpu_status, status;
+	int qcss_tok = rtas_token("query-cpu-stopped-state");
+
+	if (qcss_tok == RTAS_UNKNOWN_SERVICE) {
+		printk(KERN_INFO "Firmware doesn't support "
+				"query-cpu-stopped-state\n");
+		return QCSS_HARDWARE_ERROR;
+	}
+
+	status = rtas_call(qcss_tok, 1, 2, &cpu_status, pcpu);
+	if (status != 0) {
+		printk(KERN_ERR
+		       "RTAS query-cpu-stopped-state failed: %i\n", status);
+		return status;
+	}
+
+	return cpu_status;
+}
+
 /**
  * smp_startup_cpu() - start the given cpu
  *
@@ -84,6 +106,12 @@ static inline int __devinit smp_startup_cpu(unsigned int lcpu)
 
 	pcpu = get_hard_smp_processor_id(lcpu);
 
+	/* Check to see if the CPU out of FW already for kexec */
+	if (smp_query_cpu_stopped(pcpu) == QCSS_NOT_STOPPED){
+		cpu_set(lcpu, of_spin_map);
+		return 1;
+	}
+
 	/* Fixup atomic count: it exited inside IRQ handler. */
 	task_thread_info(paca[lcpu].__current)->preempt_count	= 0;
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8afc274..512c281 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -157,6 +157,10 @@ int libata_allow_tpm = 0;
 module_param_named(allow_tpm, libata_allow_tpm, int, 0444);
 MODULE_PARM_DESC(allow_tpm, "Permit the use of TPM commands");
 
+static int atapi_an;
+module_param(atapi_an, int, 0444);
+MODULE_PARM_DESC(atapi_an, "Enable ATAPI AN media presence notification (0=0ff [default], 1=on)");
+
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("Library module for ATA devices");
 MODULE_LICENSE("GPL");
@@ -2341,7 +2345,8 @@ int ata_dev_configure(struct ata_device *dev)
 		 * to enable ATAPI AN to discern between PHY status
 		 * changed notifications and ATAPI ANs.
 		 */
-		if ((ap->flags & ATA_FLAG_AN) && ata_id_has_atapi_AN(id) &&
+		if (atapi_an &&
+		    (ap->flags & ATA_FLAG_AN) && ata_id_has_atapi_AN(id) &&
 		    (!sata_pmp_attached(ap) ||
 		     sata_scr_read(&ap->link, SCR_NOTIFICATION, &sntf) == 0)) {
 			unsigned int err_mask;
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 7e860da..604c991 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -313,9 +313,14 @@ static void deliver_recv_msg(struct smi_info *smi_info,
 {
 	/* Deliver the message to the upper layer with the lock
 	   released. */
-	spin_unlock(&(smi_info->si_lock));
-	ipmi_smi_msg_received(smi_info->intf, msg);
-	spin_lock(&(smi_info->si_lock));
+
+	if (smi_info->run_to_completion) {
+		ipmi_smi_msg_received(smi_info->intf, msg);
+	} else {
+		spin_unlock(&(smi_info->si_lock));
+		ipmi_smi_msg_received(smi_info->intf, msg);
+		spin_lock(&(smi_info->si_lock));
+	}
 }
 
 static void return_hosed_msg(struct smi_info *smi_info, int cCode)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b60d328..4d96950 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4816,6 +4816,7 @@ static int md_ioctl(struct inode *inode, struct file *file,
 	int err = 0;
 	void __user *argp = (void __user *)arg;
 	mddev_t *mddev = NULL;
+	int ro;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -4951,6 +4952,34 @@ static int md_ioctl(struct inode *inode, struct file *file,
 			err = do_md_stop (mddev, 1, 1);
 			goto done_unlock;
 
+		case BLKROSET:
+			if (get_user(ro, (int __user *)(arg))) {
+				err = -EFAULT;
+				goto done_unlock;
+			}
+			err = -EINVAL;
+
+			/* if the bdev is going readonly the value of mddev->ro
+			 * does not matter, no writes are coming
+			 */
+			if (ro)
+				goto done_unlock;
+
+			/* are we are already prepared for writes? */
+			if (mddev->ro != 1)
+				goto done_unlock;
+
+			/* transitioning to readauto need only happen for
+			 * arrays that call md_write_start
+			 */
+			if (mddev->pers) {
+				err = restart_array(mddev);
+				if (err == 0) {
+					mddev->ro = 2;
+					set_disk_ro(mddev->gendisk, 0);
+				}
+			}
+			goto done_unlock;
 	}
 
 	/*
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 2b510a3..4b78069 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -413,7 +413,7 @@ static void raid1_end_write_request(struct bio *bio, int error)
  */
 static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 {
-	const unsigned long this_sector = r1_bio->sector;
+	const sector_t this_sector = r1_bio->sector;
 	int new_disk = conf->last_used, disk = new_disk;
 	int wonly_disk = -1;
 	const int sectors = r1_bio->sectors;
@@ -429,7 +429,7 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
  retry:
 	if (conf->mddev->recovery_cp < MaxSector &&
 	    (this_sector + sectors >= conf->next_resync)) {
-		/* Choose the first operation device, for consistancy */
+		/* Choose the first operational device, for consistancy */
 		new_disk = 0;
 
 		for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
@@ -879,9 +879,10 @@ static int make_request(struct request_queue *q, struct bio * bio)
 			if (test_bit(Faulty, &rdev->flags)) {
 				rdev_dec_pending(rdev, mddev);
 				r1_bio->bios[i] = NULL;
-			} else
+			} else {
 				r1_bio->bios[i] = bio;
-			targets++;
+				targets++;
+			}
 		} else
 			r1_bio->bios[i] = NULL;
 	}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b08dd95..dbf51e9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -490,7 +490,7 @@ static int raid10_mergeable_bvec(struct request_queue *q,
  */
 static int read_balance(conf_t *conf, r10bio_t *r10_bio)
 {
-	const unsigned long this_sector = r10_bio->sector;
+	const sector_t this_sector = r10_bio->sector;
 	int disk, slot, nslot;
 	const int sectors = r10_bio->sectors;
 	sector_t new_distance, current_distance;
diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index b8c0fa6..0477bd1 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -162,8 +162,8 @@ static struct pci_device_id com20020pci_id_table[] = {
 	{ 0x1571, 0xa204, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
 	{ 0x1571, 0xa205, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
 	{ 0x1571, 0xa206, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
-	{ 0x10B5, 0x9030, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
-	{ 0x10B5, 0x9050, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
+	{ 0x10B5, 0x9030, 0x10B5,     0x2978,     0, 0, ARC_CAN_10MBIT },
+	{ 0x10B5, 0x9050, 0x10B5,     0x2273,     0, 0, ARC_CAN_10MBIT },
 	{ 0x14BA, 0x6000, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
 	{ 0x10B5, 0x2200, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
 	{0,}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a67f837..536e392 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1721,7 +1721,11 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 
 			pages_skipped = mpd->wbc->pages_skipped;
 			err = mapping->a_ops->writepage(page, mpd->wbc);
-			if (!err)
+			if (!err && (pages_skipped == mpd->wbc->pages_skipped))
+				/*
+				 * have successfully written the page
+				 * without skipping the same
+				 */
 				mpd->pages_written++;
 			/*
 			 * In error case, we have to continue because
@@ -2059,17 +2063,6 @@ static int __mpage_da_writepage(struct page *page,
 	struct buffer_head *bh, *head, fake;
 	sector_t logical;
 
-	if (mpd->io_done) {
-		/*
-		 * Rest of the page in the page_vec
-		 * redirty then and skip then. We will
-		 * try to to write them again after
-		 * starting a new transaction
-		 */
-		redirty_page_for_writepage(wbc, page);
-		unlock_page(page);
-		return MPAGE_DA_EXTENT_TAIL;
-	}
 	/*
 	 * Can we merge this page to current extent?
 	 */
@@ -2160,6 +2153,137 @@ static int __mpage_da_writepage(struct page *page,
 }
 
 /*
+ * write_cache_pages_da - walk the list of dirty pages of the given
+ * address space and call the callback function (which usually writes
+ * the pages).
+ *
+ * This is a forked version of write_cache_pages().  Differences:
+ *	Range cyclic is ignored.
+ *	no_nrwrite_index_update is always presumed true
+ */
+static int write_cache_pages_da(struct address_space *mapping,
+				struct writeback_control *wbc,
+				struct mpage_da_data *mpd)
+{
+	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	int ret = 0;
+	int done = 0;
+	struct pagevec pvec;
+	int nr_pages;
+	pgoff_t index;
+	pgoff_t end;		/* Inclusive */
+	long nr_to_write = wbc->nr_to_write;
+
+	if (wbc->nonblocking && bdi_write_congested(bdi)) {
+		wbc->encountered_congestion = 1;
+		return 0;
+	}
+
+	pagevec_init(&pvec, 0);
+	index = wbc->range_start >> PAGE_CACHE_SHIFT;
+	end = wbc->range_end >> PAGE_CACHE_SHIFT;
+
+	while (!done && (index <= end)) {
+		int i;
+
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+			      PAGECACHE_TAG_DIRTY,
+			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		if (nr_pages == 0)
+			break;
+
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+
+			/*
+			 * At this point, the page may be truncated or
+			 * invalidated (changing page->mapping to NULL), or
+			 * even swizzled back from swapper_space to tmpfs file
+			 * mapping. However, page->index will not change
+			 * because we have a reference on the page.
+			 */
+			if (page->index > end) {
+				done = 1;
+				break;
+			}
+
+			lock_page(page);
+
+			/*
+			 * Page truncated or invalidated. We can freely skip it
+			 * then, even for data integrity operations: the page
+			 * has disappeared concurrently, so there could be no
+			 * real expectation of this data interity operation
+			 * even if there is now a new, dirty page at the same
+			 * pagecache address.
+			 */
+			if (unlikely(page->mapping != mapping)) {
+continue_unlock:
+				unlock_page(page);
+				continue;
+			}
+
+			if (!PageDirty(page)) {
+				/* someone wrote it for us */
+				goto continue_unlock;
+			}
+
+			if (PageWriteback(page)) {
+				if (wbc->sync_mode != WB_SYNC_NONE)
+					wait_on_page_writeback(page);
+				else
+					goto continue_unlock;
+			}
+
+			BUG_ON(PageWriteback(page));
+			if (!clear_page_dirty_for_io(page))
+				goto continue_unlock;
+
+			ret = __mpage_da_writepage(page, wbc, mpd);
+
+			if (unlikely(ret)) {
+				if (ret == AOP_WRITEPAGE_ACTIVATE) {
+					unlock_page(page);
+					ret = 0;
+				} else {
+					done = 1;
+					break;
+				}
+ 			}
+
+			if (nr_to_write > 0) {
+				nr_to_write--;
+				if (nr_to_write == 0 &&
+				    wbc->sync_mode == WB_SYNC_NONE) {
+					/*
+					 * We stop writing back only if we are
+					 * not doing integrity sync. In case of
+					 * integrity sync we have to keep going
+					 * because someone may be concurrently
+					 * dirtying pages, and we might have
+					 * synced a lot of newly appeared dirty
+					 * pages, but have not synced all of the
+					 * old dirty pages.
+					 */
+					done = 1;
+					break;
+				}
+			}
+
+			if (wbc->nonblocking && bdi_write_congested(bdi)) {
+				wbc->encountered_congestion = 1;
+				done = 1;
+				break;
+			}
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+	return ret;
+}
+
+
+/*
  * mpage_da_writepages - walk the list of dirty pages of the given
  * address space, allocates non-allocated blocks, maps newly-allocated
  * blocks to existing bhs and issue IO them
@@ -2175,7 +2299,6 @@ static int mpage_da_writepages(struct address_space *mapping,
 			       struct writeback_control *wbc,
 			       struct mpage_da_data *mpd)
 {
-	long to_write;
 	int ret;
 
 	if (!mpd->get_block)
@@ -2190,19 +2313,18 @@ static int mpage_da_writepages(struct address_space *mapping,
 	mpd->pages_written = 0;
 	mpd->retval = 0;
 
-	to_write = wbc->nr_to_write;
-
-	ret = write_cache_pages(mapping, wbc, __mpage_da_writepage, mpd);
-
+	ret = write_cache_pages_da(mapping, wbc, mpd);
 	/*
 	 * Handle last extent of pages
 	 */
 	if (!mpd->io_done && mpd->next_page != mpd->first_page) {
 		if (mpage_da_map_blocks(mpd) == 0)
 			mpage_da_submit_io(mpd);
-	}
 
-	wbc->nr_to_write = to_write - mpd->pages_written;
+		mpd->io_done = 1;
+		ret = MPAGE_DA_EXTENT_TAIL;
+	}
+	wbc->nr_to_write -= mpd->pages_written;
 	return ret;
 }
 
@@ -2447,11 +2569,14 @@ static int ext4_da_writepages_trans_blocks(struct inode *inode)
 static int ext4_da_writepages(struct address_space *mapping,
 			      struct writeback_control *wbc)
 {
+	pgoff_t	index;
+	int range_whole = 0;
 	handle_t *handle = NULL;
 	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
+	long pages_written = 0, pages_skipped;
+	int range_cyclic, cycled = 1, io_done = 0;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
-	long to_write, pages_skipped = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 
 	/*
@@ -2485,16 +2610,27 @@ static int ext4_da_writepages(struct address_space *mapping,
 		nr_to_writebump = sbi->s_mb_stream_request - wbc->nr_to_write;
 		wbc->nr_to_write = sbi->s_mb_stream_request;
 	}
-
-
-	pages_skipped = wbc->pages_skipped;
+	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
+		range_whole = 1;
+
+	range_cyclic = wbc->range_cyclic;
+	if (wbc->range_cyclic) {
+		index = mapping->writeback_index;
+		if (index)
+			cycled = 0;
+		wbc->range_start = index << PAGE_CACHE_SHIFT;
+		wbc->range_end  = LLONG_MAX;
+		wbc->range_cyclic = 0;
+	} else
+		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 
 	mpd.wbc = wbc;
 	mpd.inode = mapping->host;
 
-restart_loop:
-	to_write = wbc->nr_to_write;
-	while (!ret && to_write > 0) {
+	pages_skipped = wbc->pages_skipped;
+
+retry:
+	while (!ret && wbc->nr_to_write > 0) {
 
 		/*
 		 * we  insert one extent at a time. So we need
@@ -2527,46 +2663,60 @@ restart_loop:
 				goto out_writepages;
 			}
 		}
-		to_write -= wbc->nr_to_write;
-
 		mpd.get_block = ext4_da_get_block_write;
 		ret = mpage_da_writepages(mapping, wbc, &mpd);
 
 		ext4_journal_stop(handle);
 
-		if (mpd.retval == -ENOSPC)
+		if (mpd.retval == -ENOSPC) {
+			/* commit the transaction which would
+			 * free blocks released in the transaction
+			 * and try again
+			 */
 			jbd2_journal_force_commit_nested(sbi->s_journal);
-
-		/* reset the retry count */
-		if (ret == MPAGE_DA_EXTENT_TAIL) {
+			wbc->pages_skipped = pages_skipped;
+			ret = 0;
+		} else if (ret == MPAGE_DA_EXTENT_TAIL) {
 			/*
 			 * got one extent now try with
 			 * rest of the pages
 			 */
-			to_write += wbc->nr_to_write;
+			pages_written += mpd.pages_written;
+			wbc->pages_skipped = pages_skipped;
 			ret = 0;
-		} else if (wbc->nr_to_write) {
+			io_done = 1;
+		} else if (wbc->nr_to_write)
 			/*
 			 * There is no more writeout needed
 			 * or we requested for a noblocking writeout
 			 * and we found the device congested
 			 */
-			to_write += wbc->nr_to_write;
 			break;
-		}
-		wbc->nr_to_write = to_write;
 	}
-
-	if (!wbc->range_cyclic && (pages_skipped != wbc->pages_skipped)) {
-		/* We skipped pages in this loop */
-		wbc->nr_to_write = to_write +
-				wbc->pages_skipped - pages_skipped;
-		wbc->pages_skipped = pages_skipped;
-		goto restart_loop;
+	if (!io_done && !cycled) {
+		cycled = 1;
+		index = 0;
+		wbc->range_start = index << PAGE_CACHE_SHIFT;
+		wbc->range_end  = mapping->writeback_index - 1;
+		goto retry;
 	}
+	if (pages_skipped != wbc->pages_skipped)
+		printk(KERN_EMERG "This should not happen leaving %s "
+				"with nr_to_write = %ld ret = %d\n",
+				__func__, wbc->nr_to_write, ret);
+
+	/* Update index */
+	index += pages_written;
+	wbc->range_cyclic = range_cyclic;
+	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
+		/*
+		 * set the writeback_index so that range_cyclic
+		 * mode will write it back later
+		 */
+		mapping->writeback_index = index;
 
 out_writepages:
-	wbc->nr_to_write = to_write - nr_to_writebump;
+	wbc->nr_to_write -= nr_to_writebump;
 	return ret;
 }
 
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 0070431..f7f5995 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -935,7 +935,8 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb));
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+	    sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group;
 		flex_group = ext4_flex_group(sbi, input->group);
 		sbi->s_flex_groups[flex_group].free_blocks +=
diff --git a/fs/namespace.c b/fs/namespace.c
index efe0251..2083810 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1132,8 +1132,15 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
 {
 	struct path path;
 	int retval;
+	int lookup_flags = 0;
 
-	retval = user_path(name, &path);
+	if (flags & ~(MNT_FORCE | MNT_DETACH | MNT_EXPIRE | UMOUNT_NOFOLLOW))
+		return -EINVAL;
+
+	if (!(flags & UMOUNT_NOFOLLOW))
+		lookup_flags |= LOOKUP_FOLLOW;
+
+	retval = user_path_at(AT_FDCWD, name, lookup_flags, &path);
 	if (retval)
 		goto out;
 	retval = -EINVAL;
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 80292ff..e02db8e 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -126,7 +126,7 @@ struct svc_program		nfsd_program = {
 int nfsd_vers(int vers, enum vers_op change)
 {
 	if (vers < NFSD_MINVERS || vers >= NFSD_NRVERS)
-		return -1;
+		return 0;
 	switch(change) {
 	case NFSD_SET:
 		nfsd_versions[vers] = nfsd_version[vers];
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 909e13e..248465c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1061,6 +1061,8 @@ extern int send_sigurg(struct fown_struct *fown);
 #define MNT_FORCE	0x00000001	/* Attempt to forcibily umount */
 #define MNT_DETACH	0x00000002	/* Just detach from the tree */
 #define MNT_EXPIRE	0x00000004	/* Mark for expiry */
+#define UMOUNT_NOFOLLOW	0x00000008	/* Don't follow symlink on umount */
+#define UMOUNT_UNUSED	0x80000000	/* Flag guaranteed to be unused */
 
 extern struct list_head super_blocks;
 extern spinlock_t sb_lock;
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index ab1c472..0594330 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -753,6 +753,7 @@ int sctp_user_addto_chunk(struct sctp_chunk *chunk, int off, int len,
 			  struct iovec *data);
 void sctp_chunk_free(struct sctp_chunk *);
 void  *sctp_addto_chunk(struct sctp_chunk *, int len, const void *data);
+void  *sctp_addto_chunk_fixed(struct sctp_chunk *, int len, const void *data);
 struct sctp_chunk *sctp_chunkify(struct sk_buff *,
 				 const struct sctp_association *,
 				 struct sock *);
diff --git a/mm/filemap.c b/mm/filemap.c
index bff0b00..a4800c5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1118,6 +1118,12 @@ page_not_up_to_date_locked:
 		}
 
 readpage:
+		/*
+		 * A previous I/O error may have been due to temporary
+		 * failures, eg. multipath errors.
+		 * PG_error will be set again if readpage fails.
+		 */
+		ClearPageError(page);
 		/* Start the actual read. The read will unlock the page. */
 		error = mapping->a_ops->readpage(filp, page);
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index d68869f..baf2fa4 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -107,7 +107,7 @@ static const struct sctp_paramhdr prsctp_param = {
 	__constant_htons(sizeof(struct sctp_paramhdr)),
 };
 
-/* A helper to initialize to initialize an op error inside a
+/* A helper to initialize an op error inside a
  * provided chunk, as most cause codes will be embedded inside an
  * abort chunk.
  */
@@ -124,6 +124,29 @@ void  sctp_init_cause(struct sctp_chunk *chunk, __be16 cause_code,
 	chunk->subh.err_hdr = sctp_addto_chunk(chunk, sizeof(sctp_errhdr_t), &err);
 }
 
+/* A helper to initialize an op error inside a
+ * provided chunk, as most cause codes will be embedded inside an
+ * abort chunk.  Differs from sctp_init_cause in that it won't oops
+ * if there isn't enough space in the op error chunk
+ */
+int sctp_init_cause_fixed(struct sctp_chunk *chunk, __be16 cause_code,
+		      size_t paylen)
+{
+	sctp_errhdr_t err;
+	__u16 len;
+
+	/* Cause code constants are now defined in network order.  */
+	err.cause = cause_code;
+	len = sizeof(sctp_errhdr_t) + paylen;
+	err.length  = htons(len);
+
+	if (skb_tailroom(chunk->skb) < len)
+		return -ENOSPC;
+	chunk->subh.err_hdr = sctp_addto_chunk_fixed(chunk,
+						     sizeof(sctp_errhdr_t),
+						     &err);
+	return 0;
+}
 /* 3.3.2 Initiation (INIT) (1)
  *
  * This chunk is used to initiate a SCTP association between two
@@ -1114,6 +1137,24 @@ nodata:
 	return retval;
 }
 
+/* Create an Operation Error chunk of a fixed size,
+ * specifically, max(asoc->pathmtu, SCTP_DEFAULT_MAXSEGMENT)
+ * This is a helper function to allocate an error chunk for
+ * for those invalid parameter codes in which we may not want
+ * to report all the errors, if the incomming chunk is large
+ */
+static inline struct sctp_chunk *sctp_make_op_error_fixed(
+	const struct sctp_association *asoc,
+	const struct sctp_chunk *chunk)
+{
+	size_t size = asoc ? asoc->pathmtu : 0;
+
+	if (!size)
+		size = SCTP_DEFAULT_MAXSEGMENT;
+
+	return sctp_make_op_error_space(asoc, chunk, size);
+}
+
 /* Create an Operation Error chunk.  */
 struct sctp_chunk *sctp_make_op_error(const struct sctp_association *asoc,
 				 const struct sctp_chunk *chunk,
@@ -1354,6 +1395,18 @@ void *sctp_addto_chunk(struct sctp_chunk *chunk, int len, const void *data)
 	return target;
 }
 
+/* Append bytes to the end of a chunk. Returns NULL if there isn't sufficient
+ * space in the chunk
+ */
+void *sctp_addto_chunk_fixed(struct sctp_chunk *chunk,
+			     int len, const void *data)
+{
+	if (skb_tailroom(chunk->skb) >= len)
+		return sctp_addto_chunk(chunk, len, data);
+	else
+		return NULL;
+}
+
 /* Append bytes from user space to the end of a chunk.  Will panic if
  * chunk is not big enough.
  * Returns a kernel err value.
@@ -1957,13 +2010,12 @@ static sctp_ierror_t sctp_process_unk_param(const struct sctp_association *asoc,
 		 * returning multiple unknown parameters.
 		 */
 		if (NULL == *errp)
-			*errp = sctp_make_op_error_space(asoc, chunk,
-					ntohs(chunk->chunk_hdr->length));
+			*errp = sctp_make_op_error_fixed(asoc, chunk);
 
 		if (*errp) {
-			sctp_init_cause(*errp, SCTP_ERROR_UNKNOWN_PARAM,
+			sctp_init_cause_fixed(*errp, SCTP_ERROR_UNKNOWN_PARAM,
 					WORD_ROUND(ntohs(param.p->length)));
-			sctp_addto_chunk(*errp,
+			sctp_addto_chunk_fixed(*errp,
 					WORD_ROUND(ntohs(param.p->length)),
 					param.v);
 		} else {
diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index a7a3677..a2a53e8 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -45,10 +45,10 @@
 
 #define MAX_ADDR_STR 32
 
-static struct media *media_list = NULL;
+static struct media media_list[MAX_MEDIA];
 static u32 media_count = 0;
 
-struct bearer *tipc_bearers = NULL;
+struct bearer tipc_bearers[MAX_BEARERS];
 
 /**
  * media_name_valid - validate media name
@@ -108,9 +108,11 @@ int  tipc_register_media(u32 media_type,
 	int res = -EINVAL;
 
 	write_lock_bh(&tipc_net_lock);
-	if (!media_list)
-		goto exit;
 
+	if (tipc_mode != TIPC_NET_MODE) {
+		warn("Media <%s> rejected, not in networked mode yet\n", name);
+		goto exit;
+	}
 	if (!media_name_valid(name)) {
 		warn("Media <%s> rejected, illegal name\n", name);
 		goto exit;
@@ -660,33 +662,10 @@ int tipc_disable_bearer(const char *name)
 
 
 
-int tipc_bearer_init(void)
-{
-	int res;
-
-	write_lock_bh(&tipc_net_lock);
-	tipc_bearers = kcalloc(MAX_BEARERS, sizeof(struct bearer), GFP_ATOMIC);
-	media_list = kcalloc(MAX_MEDIA, sizeof(struct media), GFP_ATOMIC);
-	if (tipc_bearers && media_list) {
-		res = 0;
-	} else {
-		kfree(tipc_bearers);
-		kfree(media_list);
-		tipc_bearers = NULL;
-		media_list = NULL;
-		res = -ENOMEM;
-	}
-	write_unlock_bh(&tipc_net_lock);
-	return res;
-}
-
 void tipc_bearer_stop(void)
 {
 	u32 i;
 
-	if (!tipc_bearers)
-		return;
-
 	for (i = 0; i < MAX_BEARERS; i++) {
 		if (tipc_bearers[i].active)
 			tipc_bearers[i].publ.blocked = 1;
@@ -695,10 +674,6 @@ void tipc_bearer_stop(void)
 		if (tipc_bearers[i].active)
 			bearer_disable(tipc_bearers[i].publ.name);
 	}
-	kfree(tipc_bearers);
-	kfree(media_list);
-	tipc_bearers = NULL;
-	media_list = NULL;
 	media_count = 0;
 }
 
diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
index ca57348..000228e 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -114,7 +114,7 @@ struct bearer_name {
 
 struct link;
 
-extern struct bearer *tipc_bearers;
+extern struct bearer tipc_bearers[];
 
 void tipc_media_addr_printf(struct print_buf *pb, struct tipc_media_addr *a);
 struct sk_buff *tipc_media_get_names(void);
diff --git a/net/tipc/net.c b/net/tipc/net.c
index 7906608..f25b1cd 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -116,7 +116,8 @@
 */
 
 DEFINE_RWLOCK(tipc_net_lock);
-struct network tipc_net = { NULL };
+struct _zone *tipc_zones[256] = { NULL, };
+struct network tipc_net = { tipc_zones };
 
 struct tipc_node *tipc_net_select_remote_node(u32 addr, u32 ref)
 {
@@ -158,28 +159,12 @@ void tipc_net_send_external_routes(u32 dest)
 	}
 }
 
-static int net_init(void)
-{
-	memset(&tipc_net, 0, sizeof(tipc_net));
-	tipc_net.zones = kcalloc(tipc_max_zones + 1, sizeof(struct _zone *), GFP_ATOMIC);
-	if (!tipc_net.zones) {
-		return -ENOMEM;
-	}
-	return 0;
-}
-
 static void net_stop(void)
 {
 	u32 z_num;
 
-	if (!tipc_net.zones)
-		return;
-
-	for (z_num = 1; z_num <= tipc_max_zones; z_num++) {
+	for (z_num = 1; z_num <= tipc_max_zones; z_num++)
 		tipc_zone_delete(tipc_net.zones[z_num]);
-	}
-	kfree(tipc_net.zones);
-	tipc_net.zones = NULL;
 }
 
 static void net_route_named_msg(struct sk_buff *buf)
@@ -282,9 +267,7 @@ int tipc_net_start(u32 addr)
 	tipc_named_reinit();
 	tipc_port_reinit();
 
-	if ((res = tipc_bearer_init()) ||
-	    (res = net_init()) ||
-	    (res = tipc_cltr_init()) ||
+	if ((res = tipc_cltr_init()) ||
 	    (res = tipc_bclink_init())) {
 		return res;
 	}
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index fa1a7d5..61acdf1 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -161,7 +161,7 @@ HOSTCFLAGS_zconf.tab.o	:= -I$(src)
 HOSTLOADLIBES_qconf	= $(KC_QT_LIBS) -ldl
 HOSTCXXFLAGS_qconf.o	= $(KC_QT_CFLAGS) -D LKC_DIRECT_LINK
 
-HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0`
+HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0` -ldl
 HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
                           -D LKC_DIRECT_LINK
 
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index a9ab8af..594660f 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -523,9 +523,8 @@ struct key *find_keyring_by_name(const char *name, bool skip_perm_check)
 	struct key *keyring;
 	int bucket;
 
-	keyring = ERR_PTR(-EINVAL);
 	if (!name)
-		goto error;
+		return ERR_PTR(-EINVAL);
 
 	bucket = keyring_hash(name);
 
@@ -549,17 +548,18 @@ struct key *find_keyring_by_name(const char *name, bool skip_perm_check)
 					   KEY_SEARCH) < 0)
 				continue;
 
-			/* we've got a match */
-			atomic_inc(&keyring->usage);
-			read_unlock(&keyring_name_lock);
-			goto error;
+			/* we've got a match but we might end up racing with
+			 * key_cleanup() if the keyring is currently 'dead'
+			 * (ie. it has a zero usage count) */
+			if (!atomic_inc_not_zero(&keyring->usage))
+				continue;
+			goto out;
 		}
 	}
 
-	read_unlock(&keyring_name_lock);
 	keyring = ERR_PTR(-ENOKEY);
-
- error:
+out:
+	read_unlock(&keyring_name_lock);
 	return keyring;
 
 } /* end find_keyring_by_name() */
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 45b240a..b04a2bd 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -592,7 +592,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 
 			ret = install_thread_keyring(context);
 			if (ret < 0) {
-				key = ERR_PTR(ret);
+				key_ref = ERR_PTR(ret);
 				goto error;
 			}
 		}
@@ -609,7 +609,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 
 			ret = install_process_keyring(context);
 			if (ret < 0) {
-				key = ERR_PTR(ret);
+				key_ref = ERR_PTR(ret);
 				goto error;
 			}
 		}
@@ -665,7 +665,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 
 	case KEY_SPEC_GROUP_KEYRING:
 		/* group keyrings are not yet supported */
-		key = ERR_PTR(-EINVAL);
+		key_ref = ERR_PTR(-EINVAL);
 		goto error;
 
 	case KEY_SPEC_REQKEY_AUTH_KEY:
