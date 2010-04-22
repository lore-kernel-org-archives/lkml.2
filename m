Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab0DVPXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 11:23:30 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:33225 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab0DVPX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 11:23:28 -0400
Date: Thu, 22 Apr 2010 17:23:24 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.34-rc5
Message-ID: <20100422172324.641f31d6@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following bug fixes:

Hendrik Brueckner (1):
      [S390] vdso: use ntp adjusted clock multiplier

Michael Holzheu (1):
      [S390] zcore: Fix reipl device detection

Sebastian Ott (3):
      [S390] cio: allow enable_facility from outside init functions
      [S390] add hook to reenable mss after hibernation
      [S390] cio: use exception-save stsch

Stefan Haberland (1):
      [S390] dasd: fix endless loop in erp

 arch/s390/include/asm/vdso.h            |    1 +
 arch/s390/kernel/asm-offsets.c          |    1 +
 arch/s390/kernel/swsusp_asm64.S         |    3 +++
 arch/s390/kernel/time.c                 |    1 +
 arch/s390/kernel/vdso32/clock_gettime.S |   12 ++++++------
 arch/s390/kernel/vdso32/gettimeofday.S  |    6 +++---
 arch/s390/kernel/vdso64/clock_gettime.S |    4 ++--
 arch/s390/kernel/vdso64/gettimeofday.S  |    2 +-
 drivers/s390/block/dasd.c               |    3 ++-
 drivers/s390/block/dasd_3990_erp.c      |    7 ++++++-
 drivers/s390/char/zcore.c               |    6 +-----
 drivers/s390/cio/chsc.c                 |   29 ++++++++++++++---------------
 drivers/s390/cio/chsc_sch.c             |    2 +-
 drivers/s390/cio/cio.c                  |   18 +++++++++---------
 drivers/s390/cio/css.c                  |   16 ++++++++--------
 drivers/s390/cio/device_fsm.c           |    2 +-
 16 files changed, 60 insertions(+), 53 deletions(-)

diff --git a/arch/s390/include/asm/vdso.h b/arch/s390/include/asm/vdso.h
index 4a76d94..533f357 100644
--- a/arch/s390/include/asm/vdso.h
+++ b/arch/s390/include/asm/vdso.h
@@ -29,6 +29,7 @@ struct vdso_data {
 	__u32 tz_minuteswest;		/* Minutes west of Greenwich	0x30 */
 	__u32 tz_dsttime;		/* Type of dst correction	0x34 */
 	__u32 ectg_available;
+	__u32 ntp_mult;			/* NTP adjusted multiplier	0x3C */
 };
 
 struct vdso_per_cpu_data {
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index 08db736..a094089 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -61,6 +61,7 @@ int main(void)
 	DEFINE(__VDSO_WTOM_NSEC, offsetof(struct vdso_data, wtom_clock_nsec));
 	DEFINE(__VDSO_TIMEZONE, offsetof(struct vdso_data, tz_minuteswest));
 	DEFINE(__VDSO_ECTG_OK, offsetof(struct vdso_data, ectg_available));
+	DEFINE(__VDSO_NTP_MULT, offsetof(struct vdso_data, ntp_mult));
 	DEFINE(__VDSO_ECTG_BASE, offsetof(struct vdso_per_cpu_data, ectg_timer_base));
 	DEFINE(__VDSO_ECTG_USER, offsetof(struct vdso_per_cpu_data, ectg_user_time));
 	/* constants used by the vdso */
diff --git a/arch/s390/kernel/swsusp_asm64.S b/arch/s390/kernel/swsusp_asm64.S
index b354427..c56d3f5 100644
--- a/arch/s390/kernel/swsusp_asm64.S
+++ b/arch/s390/kernel/swsusp_asm64.S
@@ -256,6 +256,9 @@ restore_registers:
 	lghi	%r2,0
 	brasl	%r14,arch_set_page_states
 
+	/* Reinitialize the channel subsystem */
+	brasl	%r14,channel_subsystem_reinit
+
 	/* Return 0 */
 	lmg	%r6,%r15,STACK_FRAME_OVERHEAD + __SF_GPRS(%r15)
 	lghi	%r2,0
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index fba6dec..d906bf1 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -221,6 +221,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
 	vdso_data->xtime_clock_nsec = wall_time->tv_nsec;
 	vdso_data->wtom_clock_sec = wall_to_monotonic.tv_sec;
 	vdso_data->wtom_clock_nsec = wall_to_monotonic.tv_nsec;
+	vdso_data->ntp_mult = mult;
 	smp_wmb();
 	++vdso_data->tb_update_count;
 }
diff --git a/arch/s390/kernel/vdso32/clock_gettime.S b/arch/s390/kernel/vdso32/clock_gettime.S
index 4a98909..9696439 100644
--- a/arch/s390/kernel/vdso32/clock_gettime.S
+++ b/arch/s390/kernel/vdso32/clock_gettime.S
@@ -38,13 +38,13 @@ __kernel_clock_gettime:
 	sl	%r1,__VDSO_XTIME_STAMP+4(%r5)
 	brc	3,2f
 	ahi	%r0,-1
-2:	mhi	%r0,1000			/* cyc2ns(clock,cycle_delta) */
+2:	ms	%r0,__VDSO_NTP_MULT(%r5)	/* cyc2ns(clock,cycle_delta) */
 	lr	%r2,%r0
-	lhi	%r0,1000
+	l	%r0,__VDSO_NTP_MULT(%r5)
 	ltr	%r1,%r1
 	mr	%r0,%r0
 	jnm	3f
-	ahi	%r0,1000
+	a	%r0,__VDSO_NTP_MULT(%r5)
 3:	alr	%r0,%r2
 	srdl	%r0,12
 	al	%r0,__VDSO_XTIME_NSEC(%r5)	/*  + xtime */
@@ -86,13 +86,13 @@ __kernel_clock_gettime:
 	sl	%r1,__VDSO_XTIME_STAMP+4(%r5)
 	brc	3,12f
 	ahi	%r0,-1
-12:	mhi	%r0,1000			/* cyc2ns(clock,cycle_delta) */
+12:	ms	%r0,__VDSO_NTP_MULT(%r5)	/* cyc2ns(clock,cycle_delta) */
 	lr	%r2,%r0
-	lhi	%r0,1000
+	l	%r0,__VDSO_NTP_MULT(%r5)
 	ltr	%r1,%r1
 	mr	%r0,%r0
 	jnm	13f
-	ahi	%r0,1000
+	a	%r0,__VDSO_NTP_MULT(%r5)
 13:	alr	%r0,%r2
 	srdl	%r0,12
 	al	%r0,__VDSO_XTIME_NSEC(%r5)	/*  + xtime */
diff --git a/arch/s390/kernel/vdso32/gettimeofday.S b/arch/s390/kernel/vdso32/gettimeofday.S
index ad8acfc..2d36331 100644
--- a/arch/s390/kernel/vdso32/gettimeofday.S
+++ b/arch/s390/kernel/vdso32/gettimeofday.S
@@ -35,13 +35,13 @@ __kernel_gettimeofday:
 	sl	%r1,__VDSO_XTIME_STAMP+4(%r5)
 	brc	3,3f
 	ahi	%r0,-1
-3:	mhi	%r0,1000			/* cyc2ns(clock,cycle_delta) */
+3:	ms	%r0,__VDSO_NTP_MULT(%r5)	/* cyc2ns(clock,cycle_delta) */
 	st	%r0,24(%r15)
-	lhi	%r0,1000
+	l	%r0,__VDSO_NTP_MULT(%r5)
 	ltr	%r1,%r1
 	mr	%r0,%r0
 	jnm	4f
-	ahi	%r0,1000
+	a	%r0,__VDSO_NTP_MULT(%r5)
 4:	al	%r0,24(%r15)
 	srdl	%r0,12
 	al	%r0,__VDSO_XTIME_NSEC(%r5)	/*  + xtime */
diff --git a/arch/s390/kernel/vdso64/clock_gettime.S b/arch/s390/kernel/vdso64/clock_gettime.S
index 49106c6..f404678 100644
--- a/arch/s390/kernel/vdso64/clock_gettime.S
+++ b/arch/s390/kernel/vdso64/clock_gettime.S
@@ -36,7 +36,7 @@ __kernel_clock_gettime:
 	stck	48(%r15)			/* Store TOD clock */
 	lg	%r1,48(%r15)
 	sg	%r1,__VDSO_XTIME_STAMP(%r5)	/* TOD - cycle_last */
-	mghi	%r1,1000
+	msgf	%r1,__VDSO_NTP_MULT(%r5)	/*  * NTP adjustment */
 	srlg	%r1,%r1,12			/* cyc2ns(clock,cycle_delta) */
 	alg	%r1,__VDSO_XTIME_NSEC(%r5)	/*  + xtime */
 	lg	%r0,__VDSO_XTIME_SEC(%r5)
@@ -64,7 +64,7 @@ __kernel_clock_gettime:
 	stck	48(%r15)			/* Store TOD clock */
 	lg	%r1,48(%r15)
 	sg	%r1,__VDSO_XTIME_STAMP(%r5)	/* TOD - cycle_last */
-	mghi	%r1,1000
+	msgf	%r1,__VDSO_NTP_MULT(%r5)	/*  * NTP adjustment */
 	srlg	%r1,%r1,12			/* cyc2ns(clock,cycle_delta) */
 	alg	%r1,__VDSO_XTIME_NSEC(%r5)	/*  + xtime */
 	lg	%r0,__VDSO_XTIME_SEC(%r5)
diff --git a/arch/s390/kernel/vdso64/gettimeofday.S b/arch/s390/kernel/vdso64/gettimeofday.S
index f873e75..36ee674 100644
--- a/arch/s390/kernel/vdso64/gettimeofday.S
+++ b/arch/s390/kernel/vdso64/gettimeofday.S
@@ -31,7 +31,7 @@ __kernel_gettimeofday:
 	stck	48(%r15)			/* Store TOD clock */
 	lg	%r1,48(%r15)
 	sg	%r1,__VDSO_XTIME_STAMP(%r5)	/* TOD - cycle_last */
-	mghi	%r1,1000
+	msgf	%r1,__VDSO_NTP_MULT(%r5)	/*  * NTP adjustment */
 	srlg	%r1,%r1,12			/* cyc2ns(clock,cycle_delta) */
 	alg	%r1,__VDSO_XTIME_NSEC(%r5)	/*  + xtime.tv_nsec */
 	lg	%r0,__VDSO_XTIME_SEC(%r5)	/* xtime.tv_sec */
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index bbea90b..acf222f 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1899,7 +1899,8 @@ restart:
 		/*  Process requests that may be recovered */
 		if (cqr->status == DASD_CQR_NEED_ERP) {
 			erp_fn = base->discipline->erp_action(cqr);
-			erp_fn(cqr);
+			if (IS_ERR(erp_fn(cqr)))
+				continue;
 			goto restart;
 		}
 
diff --git a/drivers/s390/block/dasd_3990_erp.c b/drivers/s390/block/dasd_3990_erp.c
index 6927e75..6632649 100644
--- a/drivers/s390/block/dasd_3990_erp.c
+++ b/drivers/s390/block/dasd_3990_erp.c
@@ -2309,7 +2309,7 @@ static struct dasd_ccw_req *dasd_3990_erp_add_erp(struct dasd_ccw_req *cqr)
                                      cqr->retries);
 			dasd_block_set_timer(device->block, (HZ << 3));
                 }
-		return cqr;
+		return erp;
 	}
 
 	ccw = cqr->cpaddr;
@@ -2372,6 +2372,9 @@ dasd_3990_erp_additional_erp(struct dasd_ccw_req * cqr)
 	/* add erp and initialize with default TIC */
 	erp = dasd_3990_erp_add_erp(cqr);
 
+	if (IS_ERR(erp))
+		return erp;
+
 	/* inspect sense, determine specific ERP if possible */
 	if (erp != cqr) {
 
@@ -2711,6 +2714,8 @@ dasd_3990_erp_action(struct dasd_ccw_req * cqr)
 	if (erp == NULL) {
 		/* no matching erp found - set up erp */
 		erp = dasd_3990_erp_additional_erp(cqr);
+		if (IS_ERR(erp))
+			return erp;
 	} else {
 		/* matching erp found - set all leading erp's to DONE */
 		erp = dasd_3990_erp_handle_match_erp(cqr, erp);
diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 18daf16..7217966 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -638,11 +638,7 @@ static int __init zcore_reipl_init(void)
 		rc = memcpy_hsa_kernel(ipl_block, ipib_info.ipib, PAGE_SIZE);
 	else
 		rc = memcpy_real(ipl_block, (void *) ipib_info.ipib, PAGE_SIZE);
-	if (rc) {
-		free_page((unsigned long) ipl_block);
-		return rc;
-	}
-	if (csum_partial(ipl_block, ipl_block->hdr.len, 0) !=
+	if (rc || csum_partial(ipl_block, ipl_block->hdr.len, 0) !=
 	    ipib_info.checksum) {
 		TRACE("Checksum does not match\n");
 		free_page((unsigned long) ipl_block);
diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 4038f5b..ce7cb87 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -29,6 +29,7 @@
 #include "chsc.h"
 
 static void *sei_page;
+static DEFINE_SPINLOCK(sda_lock);
 
 /**
  * chsc_error_from_response() - convert a chsc response to an error
@@ -832,11 +833,10 @@ void __init chsc_free_sei_area(void)
 	kfree(sei_page);
 }
 
-int __init
-chsc_enable_facility(int operation_code)
+int chsc_enable_facility(int operation_code)
 {
 	int ret;
-	struct {
+	static struct {
 		struct chsc_header request;
 		u8 reserved1:4;
 		u8 format:4;
@@ -849,33 +849,32 @@ chsc_enable_facility(int operation_code)
 		u32 reserved5:4;
 		u32 format2:4;
 		u32 reserved6:24;
-	} __attribute__ ((packed)) *sda_area;
+	} __attribute__ ((packed, aligned(4096))) sda_area;
 
-	sda_area = (void *)get_zeroed_page(GFP_KERNEL|GFP_DMA);
-	if (!sda_area)
-		return -ENOMEM;
-	sda_area->request.length = 0x0400;
-	sda_area->request.code = 0x0031;
-	sda_area->operation_code = operation_code;
+	spin_lock(&sda_lock);
+	memset(&sda_area, 0, sizeof(sda_area));
+	sda_area.request.length = 0x0400;
+	sda_area.request.code = 0x0031;
+	sda_area.operation_code = operation_code;
 
-	ret = chsc(sda_area);
+	ret = chsc(&sda_area);
 	if (ret > 0) {
 		ret = (ret == 3) ? -ENODEV : -EBUSY;
 		goto out;
 	}
 
-	switch (sda_area->response.code) {
+	switch (sda_area.response.code) {
 	case 0x0101:
 		ret = -EOPNOTSUPP;
 		break;
 	default:
-		ret = chsc_error_from_response(sda_area->response.code);
+		ret = chsc_error_from_response(sda_area.response.code);
 	}
 	if (ret != 0)
 		CIO_CRW_EVENT(2, "chsc: sda (oc=%x) failed (rc=%04x)\n",
-			      operation_code, sda_area->response.code);
+			      operation_code, sda_area.response.code);
  out:
-	free_page((unsigned long)sda_area);
+	spin_unlock(&sda_lock);
 	return ret;
 }
 
diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index 404f630..3b6f4ad 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -124,7 +124,7 @@ static int chsc_subchannel_prepare(struct subchannel *sch)
 	 * since we don't have a way to clear the subchannel and
 	 * cannot disable it with a request running.
 	 */
-	cc = stsch(sch->schid, &schib);
+	cc = stsch_err(sch->schid, &schib);
 	if (!cc && scsw_stctl(&schib.scsw))
 		return -EAGAIN;
 	return 0;
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index f736cdc..5feea1a 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -361,7 +361,7 @@ int cio_commit_config(struct subchannel *sch)
 	struct schib schib;
 	int ccode, retry, ret = 0;
 
-	if (stsch(sch->schid, &schib) || !css_sch_is_valid(&schib))
+	if (stsch_err(sch->schid, &schib) || !css_sch_is_valid(&schib))
 		return -ENODEV;
 
 	for (retry = 0; retry < 5; retry++) {
@@ -372,7 +372,7 @@ int cio_commit_config(struct subchannel *sch)
 			return ccode;
 		switch (ccode) {
 		case 0: /* successful */
-			if (stsch(sch->schid, &schib) ||
+			if (stsch_err(sch->schid, &schib) ||
 			    !css_sch_is_valid(&schib))
 				return -ENODEV;
 			if (cio_check_config(sch, &schib)) {
@@ -404,7 +404,7 @@ int cio_update_schib(struct subchannel *sch)
 {
 	struct schib schib;
 
-	if (stsch(sch->schid, &schib) || !css_sch_is_valid(&schib))
+	if (stsch_err(sch->schid, &schib) || !css_sch_is_valid(&schib))
 		return -ENODEV;
 
 	memcpy(&sch->schib, &schib, sizeof(schib));
@@ -771,7 +771,7 @@ cio_get_console_sch_no(void)
 	if (console_irq != -1) {
 		/* VM provided us with the irq number of the console. */
 		schid.sch_no = console_irq;
-		if (stsch(schid, &console_subchannel.schib) != 0 ||
+		if (stsch_err(schid, &console_subchannel.schib) != 0 ||
 		    (console_subchannel.schib.pmcw.st != SUBCHANNEL_TYPE_IO) ||
 		    !console_subchannel.schib.pmcw.dnv)
 			return -1;
@@ -863,10 +863,10 @@ __disable_subchannel_easy(struct subchannel_id schid, struct schib *schib)
 	cc = 0;
 	for (retry=0;retry<3;retry++) {
 		schib->pmcw.ena = 0;
-		cc = msch(schid, schib);
+		cc = msch_err(schid, schib);
 		if (cc)
 			return (cc==3?-ENODEV:-EBUSY);
-		if (stsch(schid, schib) || !css_sch_is_valid(schib))
+		if (stsch_err(schid, schib) || !css_sch_is_valid(schib))
 			return -ENODEV;
 		if (!schib->pmcw.ena)
 			return 0;
@@ -913,7 +913,7 @@ static int stsch_reset(struct subchannel_id schid, struct schib *addr)
 
 	pgm_check_occured = 0;
 	s390_base_pgm_handler_fn = cio_reset_pgm_check_handler;
-	rc = stsch(schid, addr);
+	rc = stsch_err(schid, addr);
 	s390_base_pgm_handler_fn = NULL;
 
 	/* The program check handler could have changed pgm_check_occured. */
@@ -950,7 +950,7 @@ static int __shutdown_subchannel_easy(struct subchannel_id schid, void *data)
 			/* No default clear strategy */
 			break;
 		}
-		stsch(schid, &schib);
+		stsch_err(schid, &schib);
 		__disable_subchannel_easy(schid, &schib);
 	}
 out:
@@ -1086,7 +1086,7 @@ int __init cio_get_iplinfo(struct cio_iplinfo *iplinfo)
 	schid = *(struct subchannel_id *)&S390_lowcore.subchannel_id;
 	if (!schid.one)
 		return -ENODEV;
-	if (stsch(schid, &schib))
+	if (stsch_err(schid, &schib))
 		return -ENODEV;
 	if (schib.pmcw.st != SUBCHANNEL_TYPE_IO)
 		return -ENODEV;
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 2769da5..5116491 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -870,15 +870,10 @@ static int __init css_bus_init(void)
 
 	/* Try to enable MSS. */
 	ret = chsc_enable_facility(CHSC_SDA_OC_MSS);
-	switch (ret) {
-	case 0: /* Success. */
-		max_ssid = __MAX_SSID;
-		break;
-	case -ENOMEM:
-		goto out;
-	default:
+	if (ret)
 		max_ssid = 0;
-	}
+	else /* Success. */
+		max_ssid = __MAX_SSID;
 
 	ret = slow_subchannel_init();
 	if (ret)
@@ -1048,6 +1043,11 @@ static int __init channel_subsystem_init_sync(void)
 }
 subsys_initcall_sync(channel_subsystem_init_sync);
 
+void channel_subsystem_reinit(void)
+{
+	chsc_enable_facility(CHSC_SDA_OC_MSS);
+}
+
 #ifdef CONFIG_PROC_FS
 static ssize_t cio_settle_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
diff --git a/drivers/s390/cio/device_fsm.c b/drivers/s390/cio/device_fsm.c
index c56ab94..c9b8526 100644
--- a/drivers/s390/cio/device_fsm.c
+++ b/drivers/s390/cio/device_fsm.c
@@ -45,7 +45,7 @@ static void ccw_timeout_log(struct ccw_device *cdev)
 	sch = to_subchannel(cdev->dev.parent);
 	private = to_io_private(sch);
 	orb = &private->orb;
-	cc = stsch(sch->schid, &schib);
+	cc = stsch_err(sch->schid, &schib);
 
 	printk(KERN_WARNING "cio: ccw device timeout occurred at %llx, "
 	       "device information:\n", get_clock());
