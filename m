Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967047Ab0GSVmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:42:23 -0400
Received: from relay2.sgi.com ([192.48.179.30]:37520 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966868Ab0GSViy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:38:54 -0400
Message-Id: <20100719213851.608094597@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:32:21 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 03/25] GRU - update gru tlb miss statistics
References: <20100719213651.362618144@sgi.com>
Content-Disposition: inline; filename=uv_gru_tlb_statistics
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Update the GRU TLB dropin statistics. Add counts to indicate
number of TLB miss interrupts and a separate count of TLB
entries actually written. Also minor code cleanup of the TLB fault path.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gru.h       |    3 ++-
 drivers/misc/sgi-gru/grufault.c  |   33 +++++++++++++++++++++++++--------
 drivers/misc/sgi-gru/gruprocfs.c |    1 +
 drivers/misc/sgi-gru/grutables.h |    1 +
 4 files changed, 29 insertions(+), 9 deletions(-)

Index: linux/drivers/misc/sgi-gru/gru.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru.h	2010-06-09 08:11:31.372037434 -0500
+++ linux/drivers/misc/sgi-gru/gru.h	2010-06-09 08:11:40.281083913 -0500
@@ -61,7 +61,8 @@ struct gru_gseg_statistics {
 	unsigned long	upm_tlbmiss;
 	unsigned long	tlbdropin;
 	unsigned long	context_stolen;
-	unsigned long	reserved[10];
+	unsigned long	interrupts;
+	unsigned long	reserved[9];
 };
 
 /* Flags for GRU options on the gru_create_context() call */
Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2010-06-09 08:11:39.747460083 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2010-06-09 08:11:40.285085853 -0500
@@ -289,8 +289,10 @@ static int gru_vtop(struct gru_thread_st
 	return VTOP_SUCCESS;
 
 inval:
+	STAT(tlb_dropin_fail_invalid);
 	return VTOP_INVALID;
 upm:
+	STAT(tlb_dropin_fail_retry);
 	return VTOP_RETRY;
 }
 
@@ -422,7 +424,7 @@ static int gru_try_dropin(struct gru_sta
 	if (ret == VTOP_INVALID)
 		goto failinval;
 	if (ret == VTOP_RETRY)
-		goto failupm;
+		goto failretry;
 
 	if (!(gts->ts_sizeavail & GRU_SIZEAVAIL(pageshift))) {
 		gts->ts_sizeavail |= GRU_SIZEAVAIL(pageshift);
@@ -438,9 +440,9 @@ static int gru_try_dropin(struct gru_sta
 	}
 
 	gru_cb_set_istatus_active(cbk);
-	gts->ustats.tlbdropin++;
 	tfh_write_restart(tfh, gpa, GAA_RAM, vaddr, asid, write,
 			  GRU_PAGESIZE(pageshift));
+	gts->ustats.tlbdropin++;
 	gru_dbg(grudev,
 		"%s: gid %d, gts 0x%p, tfh 0x%p, vaddr 0x%lx, asid 0x%x, indexway 0x%x,"
 		" rw %d, ps %d, gpa 0x%lx\n",
@@ -453,20 +455,33 @@ failnoasid:
 	/* No asid (delayed unload). */
 	STAT(tlb_dropin_fail_no_asid);
 	gru_dbg(grudev, "FAILED no_asid tfh: 0x%p, vaddr 0x%lx\n", tfh, vaddr);
-	if (!cbk)
+	if (atomic)
 		tfh_user_polling_mode(tfh);
 	else
 		gru_flush_cache(tfh);
 	gru_flush_cache_cbe(cbe);
 	return -EAGAIN;
 
+failretry:
+	/* vtop failed - retry */
+	if (atomic)
+		tfh_user_polling_mode(tfh);
+	else
+		gru_flush_cache(tfh);
+	gru_flush_cache_cbe(cbe);
+	gru_dbg(grudev, "FAILED retry tfh: 0x%p, vaddr 0x%lx\n", tfh, vaddr);
+	return -EAGAIN;
+
 failupm:
 	/* Atomic failure switch CBR to UPM */
-	tfh_user_polling_mode(tfh);
+	if (atomic)
+		tfh_user_polling_mode(tfh);
+	else
+		gru_flush_cache(tfh);
 	gru_flush_cache_cbe(cbe);
 	STAT(tlb_dropin_fail_upm);
 	gru_dbg(grudev, "FAILED upm tfh: 0x%p, vaddr 0x%lx\n", tfh, vaddr);
-	return 1;
+	return -EAGAIN;
 
 failfmm:
 	/* FMM state on UPM call */
@@ -501,13 +516,12 @@ failinval:
 	/* All errors (atomic & non-atomic) switch CBR to EXCEPTION state */
 	tfh_exception(tfh);
 	gru_flush_cache_cbe(cbe);
-	STAT(tlb_dropin_fail_invalid);
 	gru_dbg(grudev, "FAILED inval tfh: 0x%p, vaddr 0x%lx\n", tfh, vaddr);
 	return -EFAULT;
 
 failactive:
 	/* Range invalidate active. Switch to UPM iff atomic */
-	if (!cbk)
+	if (atomic)
 		tfh_user_polling_mode(tfh);
 	else
 		gru_flush_cache(tfh);
@@ -531,7 +545,7 @@ static irqreturn_t gru_intr(int chiplet,
 	struct gru_thread_state *gts;
 	struct gru_tlb_fault_handle *tfh = NULL;
 	struct completion *cmp;
-	int cbrnum, ctxnum;
+	int cbrnum, ctxnum, multi = 0;
 
 	STAT(intr);
 
@@ -581,7 +595,10 @@ static irqreturn_t gru_intr(int chiplet,
 		 * This is running in interrupt context. Trylock the mmap_sem.
 		 * If it fails, retry the fault in user context.
 		 */
+		if (!multi)
+			gts->ustats.interrupts++;
 		gts->ustats.fmm_tlbmiss++;
+		multi = 1;
 		if (!gts->ts_force_cch_reload &&
 					down_read_trylock(&gts->ts_mm->mmap_sem)) {
 			gru_try_dropin(gru, gts, tfh, NULL);
Index: linux/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruprocfs.c	2010-06-09 08:11:39.763413322 -0500
+++ linux/drivers/misc/sgi-gru/gruprocfs.c	2010-06-09 08:11:40.301082823 -0500
@@ -79,6 +79,7 @@ static int statistics_show(struct seq_fi
 	printstat(s, tlb_dropin);
 	printstat(s, tlb_preload_page);
 	printstat(s, tlb_dropin_fail_no_asid);
+	printstat(s, tlb_dropin_fail_retry);
 	printstat(s, tlb_dropin_fail_upm);
 	printstat(s, tlb_dropin_fail_invalid);
 	printstat(s, tlb_dropin_fail_range_active);
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2010-06-09 08:11:39.779413278 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2010-06-09 08:11:40.315537614 -0500
@@ -205,6 +205,7 @@ struct gru_stats_s {
 	atomic_long_t tlb_dropin;
 	atomic_long_t tlb_preload_page;
 	atomic_long_t tlb_dropin_fail_no_asid;
+	atomic_long_t tlb_dropin_fail_retry;
 	atomic_long_t tlb_dropin_fail_upm;
 	atomic_long_t tlb_dropin_fail_invalid;
 	atomic_long_t tlb_dropin_fail_range_active;

