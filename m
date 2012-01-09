Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab2AILCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 06:02:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45052 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2AILCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 06:02:17 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.53+drm33.21
Date: Mon,  9 Jan 2012 12:02:11 +0100
Message-Id: <1326106931-4088-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.53+drm33.21 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release contains patches from upstream 2.6.32.53, but dropped any patches
to the DRM subsystem.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
or
  git://kernel.ubuntu.com/smb/linux-2.6.32.y-drm33.z.git

and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary
or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* cfq-iosched: fix cfq_cic_link() race confition
* SCSI: mpt2sas: _scsih_smart_predicted_fault uses GFP_KERNEL in interrupt context
* MXC PWM: should active during DOZE/WAIT/DBG mode
* vfs: __read_cache_page should use gfp argument rather than GFP_KERNEL
* ARM:imx:fix pwm period value
* ARM: 7220/1: mmc: mmci: Fixup error handling for dma
* watchdog: hpwdt: Changes to handle NX secure bit in 32bit path
* hung_task: fix false positive during vfork
* ath9k: Fix kernel panic in AR2427 in AP mode
* Linux 2.6.32.53

 Makefile                              |    2 +-
 arch/arm/plat-mxc/pwm.c               |   16 +++++++++++++++-
 block/cfq-iosched.c                   |   11 +++++++++--
 drivers/mmc/host/mmci.c               |    6 +++++-
 drivers/net/wireless/ath/ath9k/main.c |    3 +++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c  |    2 +-
 drivers/watchdog/hpwdt.c              |    5 ++++-
 kernel/hung_task.c                    |   14 ++++++++++----
 mm/filemap.c                          |    7 ++-----
 9 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/Makefile b/Makefile
index 8c56b60..c9803a7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .52+drm33.21
+EXTRAVERSION = .53+drm33.21
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/arch/arm/plat-mxc/pwm.c b/arch/arm/plat-mxc/pwm.c
index 5cdbd60..1640486 100644
--- a/arch/arm/plat-mxc/pwm.c
+++ b/arch/arm/plat-mxc/pwm.c
@@ -31,6 +31,9 @@
 #define MX3_PWMSAR                0x0C    /* PWM Sample Register */
 #define MX3_PWMPR                 0x10    /* PWM Period Register */
 #define MX3_PWMCR_PRESCALER(x)    (((x - 1) & 0xFFF) << 4)
+#define MX3_PWMCR_DOZEEN                (1 << 24)
+#define MX3_PWMCR_WAITEN                (1 << 23)
+#define MX3_PWMCR_DBGEN			(1 << 22)
 #define MX3_PWMCR_CLKSRC_IPG_HIGH (2 << 16)
 #define MX3_PWMCR_CLKSRC_IPG      (1 << 16)
 #define MX3_PWMCR_EN              (1 << 0)
@@ -73,10 +76,21 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 		do_div(c, period_ns);
 		duty_cycles = c;

+		/*
+		 * according to imx pwm RM, the real period value should be
+		 * PERIOD value in PWMPR plus 2.
+		 */
+		if (period_cycles > 2)
+			period_cycles -= 2;
+		else
+			period_cycles = 0;
+
 		writel(duty_cycles, pwm->mmio_base + MX3_PWMSAR);
 		writel(period_cycles, pwm->mmio_base + MX3_PWMPR);

-		cr = MX3_PWMCR_PRESCALER(prescale) | MX3_PWMCR_EN;
+		cr = MX3_PWMCR_PRESCALER(prescale) |
+			MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
+			MX3_PWMCR_DBGEN | MX3_PWMCR_EN;

 		if (cpu_is_mx25())
 			cr |= MX3_PWMCR_CLKSRC_IPG;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1c9fba6..e5c77d8 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1981,7 +1981,7 @@ static int cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
 		}
 	}

-	if (ret)
+	if (ret && ret != -EEXIST)
 		printk(KERN_ERR "cfq: cic link failed!\n");

 	return ret;
@@ -1997,6 +1997,7 @@ cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 {
 	struct io_context *ioc = NULL;
 	struct cfq_io_context *cic;
+	int ret;

 	might_sleep_if(gfp_mask & __GFP_WAIT);

@@ -2004,6 +2005,7 @@ cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 	if (!ioc)
 		return NULL;

+retry:
 	cic = cfq_cic_lookup(cfqd, ioc);
 	if (cic)
 		goto out;
@@ -2012,7 +2014,12 @@ cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 	if (cic == NULL)
 		goto err;

-	if (cfq_cic_link(cfqd, ioc, cic, gfp_mask))
+	ret = cfq_cic_link(cfqd, ioc, cic, gfp_mask);
+	if (ret == -EEXIST) {
+		/* someone has linked cic to ioc already */
+		cfq_cic_free(cic);
+		goto retry;
+	} else if (ret)
 		goto err_free;

 out:
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 705a589..68d800f 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -232,8 +232,12 @@ mmci_cmd_irq(struct mmci_host *host, struct mmc_command *cmd,
 	}

 	if (!cmd->data || cmd->error) {
-		if (host->data)
+		if (host->data) {
+			/* Terminate the DMA transfer */
+			if (dma_inprogress(host))
+				mmci_dma_data_error(host);
 			mmci_stop_data(host);
+		}
 		mmci_request_end(host, cmd->mrq);
 	} else if (!(cmd->data->flags & MMC_DATA_READ)) {
 		mmci_start_data(host, cmd->data);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 54e716a..31be89b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2472,6 +2472,9 @@ static void ath9k_sta_notify(struct ieee80211_hw *hw,
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;

+	if (!(sc->sc_flags & SC_OP_TXAGGR))
+		return;
+
 	switch (cmd) {
 	case STA_NOTIFY_ADD:
 		ath_node_attach(sc, sta);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index cb972b6..11253d9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3145,7 +3145,7 @@ _scsih_smart_predicted_fault(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	/* insert into event log */
 	sz = offsetof(Mpi2EventNotificationReply_t, EventData) +
 	     sizeof(Mpi2EventDataSasDeviceStatusChange_t);
-	event_reply = kzalloc(sz, GFP_KERNEL);
+	event_reply = kzalloc(sz, GFP_ATOMIC);
 	if (!event_reply) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 0b91907..2a9f54a 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -220,6 +220,7 @@ static int __devinit cru_detect(unsigned long map_entry,

 	cmn_regs.u1.reax = CRU_BIOS_SIGNATURE_VALUE;

+	set_memory_x((unsigned long)bios32_entrypoint, (2 * PAGE_SIZE));
 	asminline_call(&cmn_regs, bios32_entrypoint);

 	if (cmn_regs.u1.ral != 0) {
@@ -237,8 +238,10 @@ static int __devinit cru_detect(unsigned long map_entry,
 		if ((physical_bios_base + physical_bios_offset)) {
 			cru_rom_addr =
 				ioremap(cru_physical_address, cru_length);
-			if (cru_rom_addr)
+			if (cru_rom_addr) {
+				set_memory_x((unsigned long)cru_rom_addr, cru_length);
 				retval = 0;
+			}
 		}

 		printk(KERN_DEBUG "hpwdt: CRU Base Address:   0x%lx\n",
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index d4e84174..07187ae 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -74,11 +74,17 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)

 	/*
 	 * Ensure the task is not frozen.
-	 * Also, when a freshly created task is scheduled once, changes
-	 * its state to TASK_UNINTERRUPTIBLE without having ever been
-	 * switched out once, it musn't be checked.
+	 * Also, skip vfork and any other user process that freezer should skip.
 	 */
-	if (unlikely(t->flags & PF_FROZEN || !switch_count))
+	if (unlikely(t->flags & (PF_FROZEN | PF_FREEZER_SKIP)))
+	    return;
+
+	/*
+	 * When a freshly created task is scheduled once, changes its state to
+	 * TASK_UNINTERRUPTIBLE without having ever been switched out once, it
+	 * musn't be checked.
+	 */
+	if (unlikely(!switch_count))
 		return;

 	if (switch_count != t->last_switch_count) {
diff --git a/mm/filemap.c b/mm/filemap.c
index 9e0826e..a1fe378 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1675,7 +1675,7 @@ repeat:
 		page = __page_cache_alloc(gfp | __GFP_COLD);
 		if (!page)
 			return ERR_PTR(-ENOMEM);
-		err = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
+		err = add_to_page_cache_lru(page, mapping, index, gfp);
 		if (unlikely(err)) {
 			page_cache_release(page);
 			if (err == -EEXIST)
@@ -1772,10 +1772,7 @@ static struct page *wait_on_page_read(struct page *page)
  * @gfp:	the page allocator flags to use if allocating
  *
  * This is the same as "read_mapping_page(mapping, index, NULL)", but with
- * any new page allocations done using the specified allocation flags. Note
- * that the Radix tree operations will still use GFP_KERNEL, so you can't
- * expect to do this atomically or anything like that - but you can pass in
- * other page requirements.
+ * any new page allocations done using the specified allocation flags.
  *
  * If the page does not get brought uptodate, return -EIO.
  */
