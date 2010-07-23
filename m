Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab0GWBOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 21:14:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42104 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab0GWBMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 21:12:53 -0400
From: Armando Uribe <x0095078@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Rene Sapiens <rene.sapiens@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Armando Uribe <x0095078@ti.com>
Subject: [PATCH 3/9] staging: tidspbridge: Change macros to static inline functions in io_sm
Date: Thu, 22 Jul 2010 20:25:28 -0500
Message-Id: <1279848334-4043-4-git-send-email-x0095078@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1279848334-4043-3-git-send-email-x0095078@ti.com>
References: <1279848334-4043-1-git-send-email-x0095078@ti.com>
 <1279848334-4043-2-git-send-email-x0095078@ti.com>
 <1279848334-4043-3-git-send-email-x0095078@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch change to macros to static inline functions, these
macros are used to perform write/read operations in shared memory

Signed-off-by: Armando Uribe <x0095078@ti.com>
---
 drivers/staging/tidspbridge/core/io_sm.c           |   22 ++++++++++++-------
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |    3 --
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index 03960bd..e5e3684 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -149,6 +149,17 @@ static int register_shm_segs(struct io_mgr *hio_mgr,
 				    struct cod_manager *cod_man,
 				    u32 dw_gpp_base_pa);
 
+static inline void set_chnl_free(struct shm *sm, u32 chnl)
+{
+	sm->host_free_mask &= ~(1 << chnl);
+}
+
+static inline void set_chnl_busy(struct shm *sm, u32 chnl)
+{
+	sm->host_free_mask |= 1 << chnl;
+}
+
+
 /*
  *  ======== bridge_io_create ========
  *      Create an IO manager object.
@@ -818,8 +829,7 @@ void io_cancel_chnl(struct io_mgr *hio_mgr, u32 chnl)
 	sm = hio_mgr->shared_mem;
 
 	/* Inform DSP that we have no more buffers on this channel */
-	IO_AND_VALUE(pio_mgr->hbridge_context, struct shm, sm, host_free_mask,
-		     (~(1 << chnl)));
+	set_chnl_free(sm, chnl);
 
 	sm_interrupt_dsp(pio_mgr->hbridge_context, MBX_PCPY_CLASS);
 func_end:
@@ -994,8 +1004,7 @@ void io_request_chnl(struct io_mgr *io_manager, struct chnl_object *pchnl,
 		DBC_ASSERT((pchnl->dw_state == CHNL_STATEREADY) ||
 			   (pchnl->dw_state == CHNL_STATEEOS));
 		/* Indicate to the DSP we have a buffer available for input */
-		IO_OR_VALUE(io_manager->hbridge_context, struct shm, sm,
-			    host_free_mask, (1 << pchnl->chnl_id));
+		set_chnl_busy(sm, pchnl->chnl_id);
 		*mbx_val = MBX_PCPY_CLASS;
 	} else if (io_mode == IO_OUTPUT) {
 		/*
@@ -1156,10 +1165,7 @@ static void input_chnl(struct io_mgr *pio_mgr, struct chnl_object *pchnl,
 				if (!pchnl->pio_requests)
 					goto func_end;
 				if (LST_IS_EMPTY(pchnl->pio_requests)) {
-					IO_AND_VALUE(pio_mgr->hbridge_context,
-						     struct shm, sm,
-						     host_free_mask,
-						     ~(1 << pchnl->chnl_id));
+					set_chnl_free(sm, pchnl->chnl_id);
 				}
 				clear_chnl = true;
 				notify_client = true;
diff --git a/drivers/staging/tidspbridge/include/dspbridge/io_sm.h b/drivers/staging/tidspbridge/include/dspbridge/io_sm.h
index f1c44f8..841ff94 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/io_sm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/io_sm.h
@@ -33,9 +33,6 @@
 #define DSP_FIELD_ADDR(type, field, base, wordsize) \
     ((((s32)&(((type *)0)->field)) / wordsize) + (u32)base)
 
-#define IO_OR_VALUE(context, type, base, field, value)  (base->field |= value)
-#define IO_AND_VALUE(context, type, base, field, value) (base->field &= value)
-
 #ifdef CONFIG_TIDSPBRIDGE_DVFS
 /* The maximum number of OPPs that are supported */
 extern s32 dsp_max_opps;
-- 
1.6.3.3

