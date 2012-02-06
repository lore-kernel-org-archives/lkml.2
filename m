Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab2BFXlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 18:41:06 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:58359 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab2BFXj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 18:39:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EADRkME9bdWOb/2dsb2JhbABDhQurP4FzAQUaAQgECwEjIxAlAhgOAgI5AxsGARKHf6ZHkieBL4l/AQUCAgIIAQEEDQQGAQsJCBSDSl4VgkKBFgSVKIVYg1eJLQ
X-IronPort-AV: E=Sophos;i="4.73,373,1325458800"; 
   d="scan'208";a="473049157"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 2/4] staging: tidspbridge: remove DBC_ASSERT macro
Date: Tue,  7 Feb 2012 00:39:35 +0100
Message-Id: <1abc64714f6e8234d0e930436fe8fd2c85c892d8.1328563908.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <cover.1328563908.git.vjaquez@igalia.com>
References: <cover.1328563908.git.vjaquez@igalia.com>
In-Reply-To: <cover.1328563908.git.vjaquez@igalia.com>
References: <cover.1328563908.git.vjaquez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is only valid when CONFIG_TIDSPBRDIGE_DEBUG is enabled and it only
prints a log message, it is not a real assertion mechanism like BUG_ON() or
WARN_ON().

It is better to remove them: less code to maintain.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 drivers/staging/tidspbridge/core/chnl_sm.c         |   12 ----------
 drivers/staging/tidspbridge/core/io_sm.c           |   14 ------------
 drivers/staging/tidspbridge/core/tiomap3430.c      |    3 --
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    1 -
 drivers/staging/tidspbridge/core/tiomap_io.c       |   15 -------------
 .../staging/tidspbridge/include/dspbridge/dbc.h    |   11 ----------
 drivers/staging/tidspbridge/pmgr/cmm.c             |    6 +---
 drivers/staging/tidspbridge/pmgr/dbll.c            |    3 --
 drivers/staging/tidspbridge/pmgr/dev.c             |    6 -----
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |    6 -----
 drivers/staging/tidspbridge/rmgr/disp.c            |    3 --
 drivers/staging/tidspbridge/rmgr/drv.c             |    7 ------
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    2 -
 drivers/staging/tidspbridge/rmgr/mgr.c             |    2 -
 drivers/staging/tidspbridge/rmgr/nldr.c            |   22 --------------------
 drivers/staging/tidspbridge/rmgr/node.c            |   11 ----------
 drivers/staging/tidspbridge/rmgr/proc.c            |   15 -------------
 drivers/staging/tidspbridge/rmgr/rmm.c             |    3 --
 drivers/staging/tidspbridge/rmgr/strm.c            |   11 ----------
 19 files changed, 2 insertions(+), 151 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/chnl_sm.c b/drivers/staging/tidspbridge/core/chnl_sm.c
index 91daf25..3136e8d 100644
--- a/drivers/staging/tidspbridge/core/chnl_sm.c
+++ b/drivers/staging/tidspbridge/core/chnl_sm.c
@@ -123,7 +123,6 @@ int bridge_chnl_add_io_req(struct chnl_object *chnl_obj, void *host_buf,
 				CHNL_IS_OUTPUT(pchnl->chnl_mode))
 			return -EPIPE;
 		/* No other possible states left */
-		DBC_ASSERT(0);
 	}
 
 	dev_obj = dev_get_first();
@@ -190,7 +189,6 @@ func_cont:
 	 * Note: for dma chans dw_dsp_addr contains dsp address
 	 * of SM buffer.
 	 */
-	DBC_ASSERT(chnl_mgr_obj->word_size != 0);
 	/* DSP address */
 	chnl_packet_obj->dsp_tx_addr = dw_dsp_addr / chnl_mgr_obj->word_size;
 	chnl_packet_obj->byte_size = byte_size;
@@ -201,7 +199,6 @@ func_cont:
 			CHNL_IOCSTATCOMPLETE);
 	list_add_tail(&chnl_packet_obj->link, &pchnl->io_requests);
 	pchnl->cio_reqs++;
-	DBC_ASSERT(pchnl->cio_reqs <= pchnl->chnl_packets);
 	/*
 	 * If end of stream, update the channel state to prevent
 	 * more IOR's.
@@ -209,8 +206,6 @@ func_cont:
 	if (is_eos)
 		pchnl->state |= CHNL_STATEEOS;
 
-	/* Legacy DSM Processor-Copy */
-	DBC_ASSERT(pchnl->chnl_type == CHNL_PCPY);
 	/* Request IO from the DSP */
 	io_request_chnl(chnl_mgr_obj->iomgr, pchnl,
 			(CHNL_IS_INPUT(pchnl->chnl_mode) ? IO_INPUT :
@@ -283,7 +278,6 @@ int bridge_chnl_cancel_io(struct chnl_object *chnl_obj)
 		list_add_tail(&chirp->link, &pchnl->io_completions);
 		pchnl->cio_cs++;
 		pchnl->cio_reqs--;
-		DBC_ASSERT(pchnl->cio_reqs >= 0);
 	}
 
 	spin_unlock_bh(&chnl_mgr_obj->chnl_mgr_lock);
@@ -311,8 +305,6 @@ int bridge_chnl_close(struct chnl_object *chnl_obj)
 	status = bridge_chnl_cancel_io(chnl_obj);
 	if (status)
 		return status;
-	/* Assert I/O on this channel is now cancelled: Protects from io_dpc */
-	DBC_ASSERT((pchnl->state & CHNL_STATECANCEL));
 	/* Invalidate channel object: Protects from CHNL_GetIOCompletion() */
 	/* Free the slot in the channel manager: */
 	pchnl->chnl_mgr_obj->channels[pchnl->chnl_id] = NULL;
@@ -367,7 +359,6 @@ int bridge_chnl_create(struct chnl_mgr **channel_mgr,
 		 *      mgr_attrts->max_channels = CHNL_MAXCHANNELS =
 		 *                       DDMA_MAXDDMACHNLS = DDMA_MAXZCPYCHNLS.
 		 */
-		DBC_ASSERT(mgr_attrts->max_channels == CHNL_MAXCHANNELS);
 		max_channels = CHNL_MAXCHANNELS + CHNL_MAXCHANNELS * CHNL_PCPY;
 		/* Create array of channels */
 		chnl_mgr_obj->channels = kzalloc(sizeof(struct chnl_object *)
@@ -584,7 +575,6 @@ int bridge_chnl_get_ioc(struct chnl_object *chnl_obj, u32 timeout,
 	omap_mbox_disable_irq(dev_ctxt->mbox, IRQ_RX);
 	if (dequeue_ioc) {
 		/* Dequeue IOC and set chan_ioc; */
-		DBC_ASSERT(!list_empty(&pchnl->io_completions));
 		chnl_packet_obj = list_first_entry(&pchnl->io_completions,
 				struct chnl_irp, link);
 		list_del(&chnl_packet_obj->link);
@@ -748,7 +738,6 @@ int bridge_chnl_open(struct chnl_object **chnl,
 			return status;
 	}
 
-	DBC_ASSERT(ch_id < chnl_mgr_obj->max_channels);
 
 	/* Create channel object: */
 	pchnl = kzalloc(sizeof(struct chnl_object), GFP_KERNEL);
@@ -837,7 +826,6 @@ int bridge_chnl_register_notify(struct chnl_object *chnl_obj,
 {
 	int status = 0;
 
-	DBC_ASSERT(!(event_mask & ~(DSP_STREAMDONE | DSP_STREAMIOCOMPLETION)));
 
 	if (event_mask)
 		status = ntfy_register(chnl_obj->ntfy_obj, hnotification,
diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index 694c0e5..0930a98 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -973,29 +973,16 @@ void io_request_chnl(struct io_mgr *io_manager, struct chnl_object *pchnl,
 	chnl_mgr_obj = io_manager->chnl_mgr;
 	sm = io_manager->shared_mem;
 	if (io_mode == IO_INPUT) {
-		/*
-		 * Assertion fires if CHNL_AddIOReq() called on a stream
-		 * which was cancelled, or attached to a dead board.
-		 */
-		DBC_ASSERT((pchnl->state == CHNL_STATEREADY) ||
-			   (pchnl->state == CHNL_STATEEOS));
 		/* Indicate to the DSP we have a buffer available for input */
 		set_chnl_busy(sm, pchnl->chnl_id);
 		*mbx_val = MBX_PCPY_CLASS;
 	} else if (io_mode == IO_OUTPUT) {
 		/*
-		 * This assertion fails if CHNL_AddIOReq() was called on a
-		 * stream which was cancelled, or attached to a dead board.
-		 */
-		DBC_ASSERT((pchnl->state & ~CHNL_STATEEOS) ==
-			   CHNL_STATEREADY);
-		/*
 		 * Record the fact that we have a buffer available for
 		 * output.
 		 */
 		chnl_mgr_obj->output_mask |= (1 << pchnl->chnl_id);
 	} else {
-		DBC_ASSERT(io_mode);	/* Shouldn't get here. */
 	}
 func_end:
 	return;
@@ -1087,7 +1074,6 @@ static void input_chnl(struct io_mgr *pio_mgr, struct chnl_object *pchnl,
 	dw_arg = sm->arg;
 	if (chnl_id >= CHNL_MAXCHANNELS) {
 		/* Shouldn't be here: would indicate corrupted shm. */
-		DBC_ASSERT(chnl_id);
 		goto func_end;
 	}
 	pchnl = chnl_mgr_obj->channels[chnl_id];
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 212cbc9..c3efc2e 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -396,16 +396,13 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 	(void)dev_get_symbol(dev_context->dev_obj, SHMBASENAME,
 			     &ul_shm_base_virt);
 	ul_shm_base_virt *= DSPWORDSIZE;
-	DBC_ASSERT(ul_shm_base_virt != 0);
 	/* DSP Virtual address */
 	ul_tlb_base_virt = dev_context->atlb_entry[0].dsp_va;
-	DBC_ASSERT(ul_tlb_base_virt <= ul_shm_base_virt);
 	ul_shm_offset_virt =
 	    ul_shm_base_virt - (ul_tlb_base_virt * DSPWORDSIZE);
 	/* Kernel logical address */
 	ul_shm_base = dev_context->atlb_entry[0].gpp_va + ul_shm_offset_virt;
 
-	DBC_ASSERT(ul_shm_base != 0);
 	/* 2nd wd is used as sync field */
 	dw_sync_addr = ul_shm_base + SHMSYNCOFFSET;
 	/* Write a signature into the shm base + offset; this will
diff --git a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
index 02dd439..16a4aaf 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
@@ -303,7 +303,6 @@ int dsp_peripheral_clk_ctrl(struct bridge_dev_context *dev_context,
 	}
 	/* TODO -- Assert may be a too hard restriction here.. May be we should
 	 * just return with failure when the CLK ID does not match */
-	/* DBC_ASSERT(clk_id_index < MBX_PM_MAX_RESOURCES); */
 	if (clk_id_index == MBX_PM_MAX_RESOURCES) {
 		/* return with a more meaningfull error code */
 		return -EPERM;
diff --git a/drivers/staging/tidspbridge/core/tiomap_io.c b/drivers/staging/tidspbridge/core/tiomap_io.c
index dfb356e..9c18873 100644
--- a/drivers/staging/tidspbridge/core/tiomap_io.c
+++ b/drivers/staging/tidspbridge/core/tiomap_io.c
@@ -68,20 +68,17 @@ int read_ext_dsp_data(struct bridge_dev_context *dev_ctxt,
 		status = dev_get_symbol(dev_context->dev_obj,
 					SHMBASENAME, &ul_shm_base_virt);
 	}
-	DBC_ASSERT(ul_shm_base_virt != 0);
 
 	/* Check if it is a read of Trace section */
 	if (!status && !ul_trace_sec_beg) {
 		status = dev_get_symbol(dev_context->dev_obj,
 					DSP_TRACESEC_BEG, &ul_trace_sec_beg);
 	}
-	DBC_ASSERT(ul_trace_sec_beg != 0);
 
 	if (!status && !ul_trace_sec_end) {
 		status = dev_get_symbol(dev_context->dev_obj,
 					DSP_TRACESEC_END, &ul_trace_sec_end);
 	}
-	DBC_ASSERT(ul_trace_sec_end != 0);
 
 	if (!status) {
 		if ((dsp_addr <= ul_trace_sec_end) &&
@@ -105,19 +102,16 @@ int read_ext_dsp_data(struct bridge_dev_context *dev_ctxt,
 			status = dev_get_symbol(dev_context->dev_obj,
 						DYNEXTBASE, &ul_dyn_ext_base);
 		}
-		DBC_ASSERT(ul_dyn_ext_base != 0);
 
 		if (!status) {
 			status = dev_get_symbol(dev_context->dev_obj,
 						EXTBASE, &ul_ext_base);
 		}
-		DBC_ASSERT(ul_ext_base != 0);
 
 		if (!status) {
 			status = dev_get_symbol(dev_context->dev_obj,
 						EXTEND, &ul_ext_end);
 		}
-		DBC_ASSERT(ul_ext_end != 0);
 
 		/* Trace buffer is right after the shm SEG0,
 		 *  so set the base address to SHMBASE */
@@ -126,8 +120,6 @@ int read_ext_dsp_data(struct bridge_dev_context *dev_ctxt,
 			ul_ext_end = ul_trace_sec_end;
 		}
 
-		DBC_ASSERT(ul_ext_end != 0);
-		DBC_ASSERT(ul_ext_end > ul_ext_base);
 
 		if (ul_ext_end < ul_ext_base)
 			status = -EPERM;
@@ -135,7 +127,6 @@ int read_ext_dsp_data(struct bridge_dev_context *dev_ctxt,
 		if (!status) {
 			ul_tlb_base_virt =
 			    dev_context->atlb_entry[0].dsp_va * DSPWORDSIZE;
-			DBC_ASSERT(ul_tlb_base_virt <= ul_shm_base_virt);
 			dw_ext_prog_virt_mem =
 			    dev_context->atlb_entry[0].gpp_va;
 
@@ -271,7 +262,6 @@ int write_ext_dsp_data(struct bridge_dev_context *dev_context,
 			/* Get SHM_BEG  EXT_BEG and EXT_END. */
 			ret = dev_get_symbol(dev_context->dev_obj,
 					     SHMBASENAME, &ul_shm_base_virt);
-		DBC_ASSERT(ul_shm_base_virt != 0);
 		if (dynamic_load) {
 			if (!ret) {
 				if (symbols_reloaded)
@@ -280,7 +270,6 @@ int write_ext_dsp_data(struct bridge_dev_context *dev_context,
 					    (dev_context->dev_obj, DYNEXTBASE,
 					     &ul_ext_base);
 			}
-			DBC_ASSERT(ul_ext_base != 0);
 			if (!ret) {
 				/* DR  OMAPS00013235 : DLModules array may be
 				 * in EXTMEM. It is expected that DYNEXTMEM and
@@ -299,7 +288,6 @@ int write_ext_dsp_data(struct bridge_dev_context *dev_context,
 					    dev_get_symbol
 					    (dev_context->dev_obj, EXTBASE,
 					     &ul_ext_base);
-				DBC_ASSERT(ul_ext_base != 0);
 				if (!ret)
 					ret =
 					    dev_get_symbol
@@ -312,15 +300,12 @@ int write_ext_dsp_data(struct bridge_dev_context *dev_context,
 		if (trace_load)
 			ul_ext_base = ul_shm_base_virt;
 
-		DBC_ASSERT(ul_ext_end != 0);
-		DBC_ASSERT(ul_ext_end > ul_ext_base);
 		if (ul_ext_end < ul_ext_base)
 			ret = -EPERM;
 
 		if (!ret) {
 			ul_tlb_base_virt =
 			    dev_context->atlb_entry[0].dsp_va * DSPWORDSIZE;
-			DBC_ASSERT(ul_tlb_base_virt <= ul_shm_base_virt);
 
 			if (symbols_reloaded) {
 				ret = dev_get_symbol
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dbc.h b/drivers/staging/tidspbridge/include/dspbridge/dbc.h
index dc88f34..90c45f6 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dbc.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dbc.h
@@ -25,15 +25,4 @@
 #ifndef DBC_
 #define DBC_
 
-/* Assertion Macros: */
-#ifdef CONFIG_TIDSPBRIDGE_DEBUG
-
-#define DBC_ASSERT(exp) \
-    if (!(exp)) \
-	pr_err("%s, line %d: Assertion (" #exp ") failed.\n", \
-	__FILE__, __LINE__)
-#else
-#define DBC_ASSERT(exp) {}
-#endif /* DEBUG */
-
 #endif /* DBC_ */
diff --git a/drivers/staging/tidspbridge/pmgr/cmm.c b/drivers/staging/tidspbridge/pmgr/cmm.c
index 2eeb5370..0d19bcd 100644
--- a/drivers/staging/tidspbridge/pmgr/cmm.c
+++ b/drivers/staging/tidspbridge/pmgr/cmm.c
@@ -253,8 +253,6 @@ int cmm_create(struct cmm_object **ph_cmm_mgr,
 	if (mgr_attrts == NULL)
 		mgr_attrts = &cmm_dfltmgrattrs;	/* set defaults */
 
-	/* 4 bytes minimum */
-	DBC_ASSERT(mgr_attrts->min_block_size >= 4);
 	/* save away smallest block allocation for this cmm mgr */
 	cmm_obj->min_block_size = mgr_attrts->min_block_size;
 	cmm_obj->page_size = PAGE_SIZE;
@@ -849,7 +847,8 @@ int cmm_xlator_free_buf(struct cmm_xlatorobject *xlator, void *buf_va)
 			if (status) {
 				/* Uh oh, this shouldn't happen. Descriptor
 				 * gone! */
-				DBC_ASSERT(false);	/* CMM is leaking mem */
+				pr_err("%s, line %d: Assertion failed\n",
+				       __FILE__, __LINE__);
 			}
 		}
 	}
@@ -898,7 +897,6 @@ void *cmm_xlator_translate(struct cmm_xlatorobject *xlator, void *paddr,
 
 	cmm_mgr_obj = (struct cmm_object *)xlator_obj->cmm_mgr;
 	/* get this translator's default SM allocator */
-	DBC_ASSERT(xlator_obj->seg_id > 0);
 	allocator = cmm_mgr_obj->pa_gppsm_seg_tab[xlator_obj->seg_id - 1];
 	if (!allocator)
 		goto loop_cont;
diff --git a/drivers/staging/tidspbridge/pmgr/dbll.c b/drivers/staging/tidspbridge/pmgr/dbll.c
index db1af79..997feeb 100644
--- a/drivers/staging/tidspbridge/pmgr/dbll.c
+++ b/drivers/staging/tidspbridge/pmgr/dbll.c
@@ -936,9 +936,6 @@ static struct dynload_symbol *dbll_find_symbol(struct dynamic_loader_sym *this,
 	if (!status && gbl_search)
 		dev_dbg(bridge, "%s: Symbol not found: %s\n", __func__, name);
 
-	DBC_ASSERT((status && (dbll_sym != NULL))
-		   || (!status && (dbll_sym == NULL)));
-
 	ret_sym = (struct dynload_symbol *)dbll_sym;
 	return ret_sym;
 }
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index e4257fd..980bd53 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -108,7 +108,6 @@ u32 dev_brd_write_fxn(void *arb, u32 dsp_add, void *host_buf,
 
 	if (dev_obj) {
 		/* Require of BrdWrite() */
-		DBC_ASSERT(dev_obj->bridge_context != NULL);
 		status = (*dev_obj->bridge_interface.brd_write) (
 					dev_obj->bridge_context, host_buf,
 					dsp_add, ul_num_bytes, mem_space);
@@ -164,7 +163,6 @@ int dev_create_device(struct dev_object **device_obj,
 	/* Create the device object, and pass a handle to the Bridge driver for
 	 * storage. */
 	if (!status) {
-		DBC_ASSERT(drv_fxns);
 		dev_obj = kzalloc(sizeof(struct dev_object), GFP_KERNEL);
 		if (dev_obj) {
 			/* Fill out the rest of the Dev Object structure: */
@@ -186,9 +184,6 @@ int dev_create_device(struct dev_object **device_obj,
 			status = (dev_obj->bridge_interface.dev_create)
 			    (&dev_obj->bridge_context, dev_obj,
 			     host_res);
-			/* Assert bridge_dev_create()'s ensure clause: */
-			DBC_ASSERT(status
-				   || (dev_obj->bridge_context != NULL));
 		} else {
 			status = -ENOMEM;
 		}
@@ -282,7 +277,6 @@ int dev_create2(struct dev_object *hdev_obj)
 	struct dev_object *dev_obj = hdev_obj;
 
 	/* There can be only one Node Manager per DEV object */
-	DBC_ASSERT(!dev_obj->node_mgr);
 	status = node_create_mgr(&dev_obj->node_mgr, hdev_obj);
 	if (status)
 		dev_obj->node_mgr = NULL;
diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index 792b443..18109fc 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -206,7 +206,6 @@ int dcd_enumerate_object(s32 index, enum dsp_dcdobjtype obj_type,
 		 *  "_\0" + length of sz_obj_type string + terminating NULL.
 		 */
 		dw_key_len = strlen(DCD_REGKEY) + 1 + sizeof(sz_obj_type) + 1;
-		DBC_ASSERT(dw_key_len < DCD_MAXPATHLENGTH);
 
 		/* Create proper REG key; concatenate DCD_REGKEY with
 		 * obj_type. */
@@ -375,7 +374,6 @@ int dcd_get_object_def(struct dcd_manager *hdcd_mgr,
 	/* Pre-determine final key length. It's length of DCD_REGKEY +
 	 *  "_\0" + length of sz_obj_type string + terminating NULL */
 	dw_key_len = strlen(DCD_REGKEY) + 1 + sizeof(sz_obj_type) + 1;
-	DBC_ASSERT(dw_key_len < DCD_MAXPATHLENGTH);
 
 	/* Create proper REG key; concatenate DCD_REGKEY with obj_type. */
 	strncpy(sz_reg_key, DCD_REGKEY, strlen(DCD_REGKEY) + 1);
@@ -434,7 +432,6 @@ int dcd_get_object_def(struct dcd_manager *hdcd_mgr,
 	}
 
 	/* Ensure sz_uuid + 1 is not greater than sizeof sz_sect_name. */
-	DBC_ASSERT((strlen(sz_uuid) + 1) < sizeof(sz_sect_name));
 
 	/* Create section name based on node UUID. A period is
 	 * pre-pended to the UUID string to form the section name.
@@ -635,7 +632,6 @@ int dcd_get_library_name(struct dcd_manager *hdcd_mgr,
 	 *  "_\0" + length of sz_obj_type string + terminating NULL.
 	 */
 	dw_key_len = strlen(DCD_REGKEY) + 1 + sizeof(sz_obj_type) + 1;
-	DBC_ASSERT(dw_key_len < DCD_MAXPATHLENGTH);
 
 	/* Create proper REG key; concatenate DCD_REGKEY with obj_type. */
 	strncpy(sz_reg_key, DCD_REGKEY, strlen(DCD_REGKEY) + 1);
@@ -663,7 +659,6 @@ int dcd_get_library_name(struct dcd_manager *hdcd_mgr,
 		break;
 	default:
 		status = -EINVAL;
-		DBC_ASSERT(false);
 	}
 	if (!status) {
 		if ((strlen(sz_reg_key) + strlen(sz_obj_type)) <
@@ -794,7 +789,6 @@ int dcd_register_object(struct dsp_uuid *uuid_obj,
 	 *  "_\0" + length of sz_obj_type string + terminating NULL.
 	 */
 	dw_key_len = strlen(DCD_REGKEY) + 1 + sizeof(sz_obj_type) + 1;
-	DBC_ASSERT(dw_key_len < DCD_MAXPATHLENGTH);
 
 	/* Create proper REG key; concatenate DCD_REGKEY with obj_type. */
 	strncpy(sz_reg_key, DCD_REGKEY, strlen(DCD_REGKEY) + 1);
diff --git a/drivers/staging/tidspbridge/rmgr/disp.c b/drivers/staging/tidspbridge/rmgr/disp.c
index 04c88a7..63fdf1e 100644
--- a/drivers/staging/tidspbridge/rmgr/disp.c
+++ b/drivers/staging/tidspbridge/rmgr/disp.c
@@ -268,7 +268,6 @@ int disp_node_create(struct disp_object *disp_obj,
 	node_type = node_get_type(hnode);
 	node_msg_args = pargs->asa.node_msg_args;
 	max = disp_obj->bufsize_rms;	/*Max # of RMS words that can be sent */
-	DBC_ASSERT(max == RMS_COMMANDBUFSIZE);
 	chars_in_rms_word = sizeof(rms_word) / disp_obj->char_size;
 	/* Number of RMS words needed to hold arg data */
 	dw_length =
@@ -429,7 +428,6 @@ int disp_node_create(struct disp_object *disp_obj,
 	}
 	if (!status) {
 		ul_bytes = total * sizeof(rms_word);
-		DBC_ASSERT(ul_bytes < (RMS_COMMANDBUFSIZE * sizeof(rms_word)));
 		status = send_message(disp_obj, node_get_timeout(hnode),
 				      ul_bytes, node_env);
 	}
@@ -665,7 +663,6 @@ static int send_message(struct disp_object *disp_obj, u32 timeout,
 			status = -EPERM;
 		} else {
 			if (CHNL_IS_IO_COMPLETE(chnl_ioc_obj)) {
-				DBC_ASSERT(chnl_ioc_obj.buf == pbuf);
 				if (*((int *)chnl_ioc_obj.buf) < 0) {
 					/* Translate DSP's to kernel error */
 					status = -EREMOTEIO;
diff --git a/drivers/staging/tidspbridge/rmgr/drv.c b/drivers/staging/tidspbridge/rmgr/drv.c
index f3bff1b..cd93c12 100644
--- a/drivers/staging/tidspbridge/rmgr/drv.c
+++ b/drivers/staging/tidspbridge/rmgr/drv.c
@@ -172,7 +172,6 @@ void drv_proc_node_update_status(void *node_resource, s32 status)
 {
 	struct node_res_object *node_res_obj =
 	    (struct node_res_object *)node_resource;
-	DBC_ASSERT(node_resource != NULL);
 	node_res_obj->node_allocated = status;
 }
 
@@ -181,7 +180,6 @@ void drv_proc_node_update_heap_status(void *node_resource, s32 status)
 {
 	struct node_res_object *node_res_obj =
 	    (struct node_res_object *)node_resource;
-	DBC_ASSERT(node_resource != NULL);
 	node_res_obj->heap_allocated = status;
 }
 
@@ -378,13 +376,8 @@ int drv_get_dev_object(u32 index, struct drv_object *hdrv_obj,
 			      struct dev_object **device_obj)
 {
 	int status = 0;
-#ifdef CONFIG_TIDSPBRIDGE_DEBUG
-	/* used only for Assertions and debug messages */
-	struct drv_object *pdrv_obj = (struct drv_object *)hdrv_obj;
-#endif
 	struct dev_object *dev_obj;
 	u32 i;
-	DBC_ASSERT(!(list_empty(&pdrv_obj->dev_list)));
 
 	dev_obj = (struct dev_object *)drv_get_first_dev_object();
 	for (i = 0; i < index; i++) {
diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 34730de..f0f07ef 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -255,8 +255,6 @@ static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	u32 status;
 
-	DBC_ASSERT(vma->vm_start < vma->vm_end);
-
 	vma->vm_flags |= VM_RESERVED | VM_IO;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
diff --git a/drivers/staging/tidspbridge/rmgr/mgr.c b/drivers/staging/tidspbridge/rmgr/mgr.c
index 1dca953..b0ce0bc 100644
--- a/drivers/staging/tidspbridge/rmgr/mgr.c
+++ b/drivers/staging/tidspbridge/rmgr/mgr.c
@@ -141,7 +141,6 @@ int mgr_enum_node_info(u32 node_id, struct dsp_ndbprops *pndb_props,
 	}
 	pmgr_obj = drv_datap->mgr_object;
 
-	DBC_ASSERT(pmgr_obj);
 	/* Forever loop till we hit failed or no more items in the
 	 * Enumeration. We will exit the loop other than 0; */
 	while (!status) {
@@ -225,7 +224,6 @@ int mgr_enum_processor_info(u32 processor_id,
 		dev_dbg(bridge, "%s: Failed to get MGR Object\n", __func__);
 		goto func_end;
 	}
-	DBC_ASSERT(pmgr_obj);
 	/* Forever loop till we hit no more items in the
 	 * Enumeration. We will exit the loop other than 0; */
 	while (status1 == 0) {
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index 6fb19ef..cc20dd9 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -427,13 +427,10 @@ int nldr_create(struct nldr_object **nldr,
 		dev_get_cod_mgr(hdev_obj, &cod_mgr);
 		if (cod_mgr) {
 			status = cod_get_loader(cod_mgr, &nldr_obj->dbll);
-			DBC_ASSERT(!status);
 			status = cod_get_base_lib(cod_mgr, &nldr_obj->base_lib);
-			DBC_ASSERT(!status);
 			status =
 			    cod_get_base_name(cod_mgr, sz_zl_file,
 							COD_MAXPATHLENGTH);
-			DBC_ASSERT(!status);
 		}
 		status = 0;
 		/* end lazy status checking */
@@ -534,7 +531,6 @@ int nldr_create(struct nldr_object **nldr,
 		status =
 		    cod_get_base_name(cod_mgr, sz_zl_file, COD_MAXPATHLENGTH);
 		/* lazy check */
-		DBC_ASSERT(!status);
 		/* First count number of overlay nodes */
 		status =
 		    dcd_get_objects(nldr_obj->dcd_mgr, sz_zl_file,
@@ -666,7 +662,6 @@ int nldr_get_fxn_addr(struct nldr_nodeobject *nldr_node_obj,
 			root = nldr_node_obj->delete_lib;
 			break;
 		default:
-			DBC_ASSERT(false);
 			break;
 		}
 	} else {
@@ -806,7 +801,6 @@ int nldr_load(struct nldr_nodeobject *nldr_node_obj,
 					break;
 
 				default:
-					DBC_ASSERT(false);
 					break;
 				}
 			}
@@ -853,7 +847,6 @@ int nldr_unload(struct nldr_nodeobject *nldr_node_obj,
 					nldr_node_obj->pers_libs = 0;
 					break;
 				default:
-					DBC_ASSERT(false);
 					break;
 				}
 			} else {
@@ -1090,7 +1083,6 @@ static void free_sects(struct nldr_object *nldr_obj,
 		ret =
 		    rmm_free(nldr_obj->rmm, 0, ovly_section->sect_run_addr,
 			     ovly_section->size, true);
-		DBC_ASSERT(ret);
 		ovly_section = ovly_section->next_sect;
 		i++;
 	}
@@ -1210,7 +1202,6 @@ static int load_lib(struct nldr_nodeobject *nldr_node_obj,
 
 	if (depth > MAXDEPTH) {
 		/* Error */
-		DBC_ASSERT(false);
 	}
 	root->lib = NULL;
 	/* Allocate a buffer for library file name of size DBL_MAXPATHLENGTH */
@@ -1273,7 +1264,6 @@ static int load_lib(struct nldr_nodeobject *nldr_node_obj,
 		    dcd_get_num_dep_libs(nldr_node_obj->nldr_obj->dcd_mgr,
 					 &uuid, &nd_libs, &np_libs, phase);
 	}
-	DBC_ASSERT(nd_libs >= np_libs);
 	if (!status) {
 		if (!(*nldr_node_obj->phase_split))
 			np_libs = 0;
@@ -1435,7 +1425,6 @@ static int load_ovly(struct nldr_nodeobject *nldr_node_obj,
 		}
 	}
 
-	DBC_ASSERT(i < nldr_obj->ovly_nodes);
 
 	if (!po_node) {
 		status = -ENOENT;
@@ -1461,7 +1450,6 @@ static int load_ovly(struct nldr_nodeobject *nldr_node_obj,
 		break;
 
 	default:
-		DBC_ASSERT(false);
 		break;
 	}
 
@@ -1609,7 +1597,6 @@ static int remote_alloc(void **ref, u16 mem_sect, u32 size,
 			mem_phase_bit = EXECUTEDATAFLAGBIT;
 			break;
 		default:
-			DBC_ASSERT(false);
 			break;
 		}
 		if (mem_sect == DBLL_CODE)
@@ -1628,11 +1615,9 @@ static int remote_alloc(void **ref, u16 mem_sect, u32 size,
 	/* Find an appropriate segment based on mem_sect */
 	if (segid == NULLID) {
 		/* No memory requirements of preferences */
-		DBC_ASSERT(!mem_load_req);
 		goto func_cont;
 	}
 	if (segid <= MAXSEGID) {
-		DBC_ASSERT(segid < nldr_obj->dload_segs);
 		/* Attempt to allocate from segid first. */
 		rmm_addr_obj->segid = segid;
 		status =
@@ -1643,7 +1628,6 @@ static int remote_alloc(void **ref, u16 mem_sect, u32 size,
 		}
 	} else {
 		/* segid > MAXSEGID ==> Internal or external memory */
-		DBC_ASSERT(segid == MEMINTERNALID || segid == MEMEXTERNALID);
 		/*  Check for any internal or external memory segment,
 		 *  depending on segid. */
 		mem_sect_type |= segid == MEMINTERNALID ?
@@ -1717,7 +1701,6 @@ static void unload_lib(struct nldr_nodeobject *nldr_node_obj,
 	struct nldr_object *nldr_obj = nldr_node_obj->nldr_obj;
 	u16 i;
 
-	DBC_ASSERT(root != NULL);
 
 	/* Unload dependent libraries */
 	for (i = 0; i < root->dep_libs; i++)
@@ -1768,7 +1751,6 @@ static void unload_ovly(struct nldr_nodeobject *nldr_node_obj,
 		}
 	}
 
-	DBC_ASSERT(i < nldr_obj->ovly_nodes);
 
 	if (!po_node)
 		/* TODO: Should we print warning here? */
@@ -1795,14 +1777,11 @@ static void unload_ovly(struct nldr_nodeobject *nldr_node_obj,
 		other_alloc = po_node->other_sects;
 		break;
 	default:
-		DBC_ASSERT(false);
 		break;
 	}
-	DBC_ASSERT(ref_count && (*ref_count > 0));
 	if (ref_count && (*ref_count > 0)) {
 		*ref_count -= 1;
 		if (other_ref) {
-			DBC_ASSERT(*other_ref > 0);
 			*other_ref -= 1;
 		}
 	}
@@ -1868,7 +1847,6 @@ int nldr_find_addr(struct nldr_nodeobject *nldr_node, u32 sym_addr,
 			root = nldr_node->delete_lib;
 			break;
 		default:
-			DBC_ASSERT(false);
 			break;
 		}
 	} else {
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index d23d1d0..83b053f 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -703,7 +703,6 @@ DBAPI node_alloc_msg_buf(struct node_object *hnode, u32 usize,
 
 	status = proc_get_processor_id(pnode->processor, &proc_id);
 	if (proc_id != DSP_UNIT) {
-		DBC_ASSERT(NULL);
 		goto func_end;
 	}
 	/*  If segment ID includes MEM_SETVIRTUALSEGID then pbuffer is a
@@ -889,7 +888,6 @@ int node_connect(struct node_object *node1, u32 stream1,
 	if (node1_type != NODE_GPP) {
 		hnode_mgr = node1->node_mgr;
 	} else {
-		DBC_ASSERT(node2 != (struct node_object *)DSP_HGPPNODE);
 		hnode_mgr = node2->node_mgr;
 	}
 
@@ -968,9 +966,6 @@ int node_connect(struct node_object *node1, u32 stream1,
 			goto out_unlock;
 		}
 
-		DBC_ASSERT((node1_type == NODE_GPP) ||
-				(node2_type == NODE_GPP));
-
 		chnl_mode = (node1_type == NODE_GPP) ?
 			CHNL_MODETODSP : CHNL_MODEFROMDSP;
 
@@ -1617,7 +1612,6 @@ int node_free_msg_buf(struct node_object *hnode, u8 * pbuffer,
 			status = cmm_xlator_free_buf(pnode->xlator, pbuffer);
 		}
 	} else {
-		DBC_ASSERT(NULL);	/* BUG */
 	}
 func_end:
 	return status;
@@ -1692,7 +1686,6 @@ int node_get_channel_id(struct node_object *hnode, u32 dir, u32 index,
 			}
 		}
 	} else {
-		DBC_ASSERT(dir == DSP_FROMNODE);
 		if (index < MAX_OUTPUTS(hnode)) {
 			if (hnode->outputs[index].type == HOSTCONNECT) {
 				*chan_id = hnode->outputs[index].dev_id;
@@ -2222,7 +2215,6 @@ int node_run(struct node_object *hnode)
 						   NODE_GET_PRIORITY(hnode));
 	} else {
 		/* We should never get here */
-		DBC_ASSERT(false);
 	}
 func_cont1:
 	/* Update node state. */
@@ -2600,7 +2592,6 @@ static void fill_stream_connect(struct node_object *node1,
 			strm1->connect_type = CONNECTTYPE_GPPOUTPUT;
 	} else {
 		/* GPP == > NODE */
-		DBC_ASSERT(node2 != (struct node_object *)DSP_HGPPNODE);
 		strm_index = node2->num_inputs + node2->num_outputs - 1;
 		strm2 = &(node2->stream_connect[strm_index]);
 		strm2->cb_struct = sizeof(struct dsp_streamconnect);
@@ -2696,7 +2687,6 @@ static int get_fxn_address(struct node_object *hnode, u32 * fxn_addr,
 		break;
 	default:
 		/* Should never get here */
-		DBC_ASSERT(false);
 		break;
 	}
 
@@ -2775,7 +2765,6 @@ static int get_node_props(struct dcd_manager *hdcd_mgr,
 		} else {
 			/* Copy device name */
 			len = strlen(pndb_props->ac_name);
-			DBC_ASSERT(len < MAXDEVNAMELEN);
 			hnode->str_dev_name = kzalloc(len + 1, GFP_KERNEL);
 			if (hnode->str_dev_name == NULL) {
 				status = -ENOMEM;
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index 4e2f2e4..8da5db6 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -1152,8 +1152,6 @@ int proc_load(void *hprocessor, const s32 argc_index,
 			if (status) {
 				status = -EPERM;
 			} else {
-				DBC_ASSERT(p_proc_object->last_coff ==
-					   NULL);
 				/* Allocate memory for pszLastCoff */
 				p_proc_object->last_coff =
 						kzalloc((strlen(user_args[0]) +
@@ -1176,7 +1174,6 @@ int proc_load(void *hprocessor, const s32 argc_index,
 		if (!hmsg_mgr) {
 			status = msg_create(&hmsg_mgr, p_proc_object->dev_obj,
 					    (msg_onexit) node_on_exit);
-			DBC_ASSERT(!status);
 			dev_set_msg_mgr(p_proc_object->dev_obj, hmsg_mgr);
 		}
 	}
@@ -1272,7 +1269,6 @@ int proc_load(void *hprocessor, const s32 argc_index,
 							strlen(pargv0) + 1);
 			else
 				status = -ENOMEM;
-			DBC_ASSERT(brd_state == BRD_LOADED);
 		}
 	}
 
@@ -1559,7 +1555,6 @@ func_cont:
 		if (!((*p_proc_object->intf_fxns->brd_status)
 				(p_proc_object->bridge_context, &brd_state))) {
 			pr_info("%s: dsp in running state\n", __func__);
-			DBC_ASSERT(brd_state != BRD_HIBERNATION);
 		}
 	} else {
 		pr_err("%s: Failed to start the dsp\n", __func__);
@@ -1585,7 +1580,6 @@ int proc_stop(void *hprocessor)
 	u32 node_tab_size = 1;
 	u32 num_nodes = 0;
 	u32 nodes_allocated = 0;
-	int brd_state;
 
 	if (!p_proc_object) {
 		status = -EFAULT;
@@ -1618,11 +1612,6 @@ int proc_stop(void *hprocessor)
 				msg_delete(hmsg_mgr);
 				dev_set_msg_mgr(p_proc_object->dev_obj, NULL);
 			}
-			if (!((*p_proc_object->
-			      intf_fxns->brd_status) (p_proc_object->
-							  bridge_context,
-							  &brd_state)))
-				DBC_ASSERT(brd_state == BRD_STOPPED);
 		}
 	} else {
 		pr_err("%s: Failed to stop the processor\n", __func__);
@@ -1760,7 +1749,6 @@ static int proc_monitor(struct proc_object *proc_obj)
 {
 	int status = -EPERM;
 	struct msg_mgr *hmsg_mgr;
-	int brd_state;
 
 	/* This is needed only when Device is loaded when it is
 	 * already 'ACTIVE' */
@@ -1777,9 +1765,6 @@ static int proc_monitor(struct proc_object *proc_obj)
 	if (!((*proc_obj->intf_fxns->brd_monitor)
 			  (proc_obj->bridge_context))) {
 		status = 0;
-		if (!((*proc_obj->intf_fxns->brd_status)
-				  (proc_obj->bridge_context, &brd_state)))
-			DBC_ASSERT(brd_state == BRD_IDLE);
 	}
 
 	return status;
diff --git a/drivers/staging/tidspbridge/rmgr/rmm.c b/drivers/staging/tidspbridge/rmgr/rmm.c
index 6b41049..fe13a74 100644
--- a/drivers/staging/tidspbridge/rmgr/rmm.c
+++ b/drivers/staging/tidspbridge/rmgr/rmm.c
@@ -292,7 +292,6 @@ bool rmm_free(struct rmm_target_obj *target, u32 segid, u32 dsp_addr, u32 size,
 		list_for_each_entry_safe(sect, tmp, &target->ovly_list,
 				list_elem) {
 			if (dsp_addr == sect->addr) {
-				DBC_ASSERT(size == sect->size);
 				/* Remove from list */
 				list_del(&sect->list_elem);
 				kfree(sect);
@@ -325,8 +324,6 @@ bool rmm_stat(struct rmm_target_obj *target, enum dsp_memtype segid,
 	u32 total_free_size = 0;
 	u32 free_blocks = 0;
 
-	DBC_ASSERT(target != NULL);
-
 	if ((u32) segid < target->num_segs) {
 		head = target->free_list[segid];
 
diff --git a/drivers/staging/tidspbridge/rmgr/strm.c b/drivers/staging/tidspbridge/rmgr/strm.c
index 8e2d649..80d01e5 100644
--- a/drivers/staging/tidspbridge/rmgr/strm.c
+++ b/drivers/staging/tidspbridge/rmgr/strm.c
@@ -119,7 +119,6 @@ int strm_allocate_buffer(struct strm_res_object *strmres, u32 usize,
 		goto func_end;
 
 	for (i = 0; i < num_bufs; i++) {
-		DBC_ASSERT(stream_obj->xlator != NULL);
 		(void)cmm_xlator_alloc_buf(stream_obj->xlator, &ap_buffer[i],
 					   usize);
 		if (ap_buffer[i] == NULL) {
@@ -162,7 +161,6 @@ int strm_close(struct strm_res_object *strmres,
 		status =
 		    (*intf_fxns->chnl_get_info) (stream_obj->chnl_obj,
 						     &chnl_info_obj);
-		DBC_ASSERT(!status);
 
 		if (chnl_info_obj.cio_cs > 0 || chnl_info_obj.cio_reqs > 0)
 			status = -EPIPE;
@@ -205,7 +203,6 @@ int strm_create(struct strm_mgr **strm_man,
 		if (!status) {
 			(void)dev_get_intf_fxns(dev_obj,
 						&(strm_mgr_obj->intf_fxns));
-			DBC_ASSERT(strm_mgr_obj->intf_fxns != NULL);
 		}
 	}
 
@@ -254,7 +251,6 @@ int strm_free_buffer(struct strm_res_object *strmres, u8 ** ap_buffer,
 
 	if (!status) {
 		for (i = 0; i < num_bufs; i++) {
-			DBC_ASSERT(stream_obj->xlator != NULL);
 			status =
 			    cmm_xlator_free_buf(stream_obj->xlator,
 						ap_buffer[i]);
@@ -302,7 +298,6 @@ int strm_get_info(struct strm_object *stream_obj,
 
 	if (stream_obj->xlator) {
 		/* We have a translator */
-		DBC_ASSERT(stream_obj->segment_id > 0);
 		cmm_xlator_info(stream_obj->xlator, (u8 **) &virt_base, 0,
 				stream_obj->segment_id, false);
 	}
@@ -496,14 +491,12 @@ int strm_open(struct node_object *hnode, u32 dir, u32 index,
 		goto func_cont;
 
 	/* No System DMA */
-	DBC_ASSERT(strm_obj->strm_mode != STRMMODE_LDMA);
 	/* Get the shared mem mgr for this streams dev object */
 	status = dev_get_cmm_mgr(strm_mgr_obj->dev_obj, &hcmm_mgr);
 	if (!status) {
 		/*Allocate a SM addr translator for this strm. */
 		status = cmm_xlator_create(&strm_obj->xlator, hcmm_mgr, NULL);
 		if (!status) {
-			DBC_ASSERT(strm_obj->segment_id > 0);
 			/*  Set translators Virt Addr attributes */
 			status = cmm_xlator_info(strm_obj->xlator,
 						 (u8 **) &pattr->virt_base,
@@ -535,10 +528,6 @@ func_cont:
 				 * strm_mgr_obj->chnl_mgr better be valid or we
 				 * assert here), and then return -EPERM.
 				 */
-				DBC_ASSERT(status == -ENOSR ||
-					   status == -ECHRNG ||
-					   status == -EALREADY ||
-					   status == -EIO);
 				status = -EPERM;
 			}
 		}
-- 
1.7.8.3

