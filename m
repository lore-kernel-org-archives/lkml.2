Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1CHUSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:18:53 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:58628 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab1CHUQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:17 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 03/15] staging: xgifb: delete offscreen memory management
Date: Tue,  8 Mar 2011 22:16:08 +0200
Message-Id: <1299615380-22922-4-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The offscreen memory area currently conflicts with the video memory
exported to the framebuffer layer. The driver does not utilize offscreen
memory, so the functionality can be deleted.

The patch also eliminates the one last memory leak when the driver
is unloaded.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h    |   47 -----
 drivers/staging/xgifb/XGI_main_26.c |  319 -----------------------------------
 drivers/staging/xgifb/XGIfb.h       |    1 -
 3 files changed, 0 insertions(+), 367 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 2c55faa..b27623a 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -65,9 +65,6 @@ MODULE_DEVICE_TABLE(pci, xgifb_pci_table);
 
 #define MAX_ROM_SCAN              0x10000
 
-#define OH_ALLOC_SIZE             4000
-#define SENTINEL                  0x7fffffff
-
 #define SEQ_ADR                   0x14
 #define SEQ_DATA                  0x15
 #define DAC_ADR                   0x18
@@ -315,7 +312,6 @@ static int XGIfb_userom = 0;
 /* global flags */
 static int XGIfb_registered;
 static int XGIfb_tvmode = 0;
-static int XGIfb_mem = 0;
 static int XGIfb_pdc = 0;
 static int enable_dstn = 0;
 static int XGIfb_ypan = -1;
@@ -538,31 +534,6 @@ static const struct _chswtable {
 	{ 0,      0,      ""       , ""       }
 };
 
-typedef struct _XGI_OH {
-	struct _XGI_OH *poh_next;
-	struct _XGI_OH *poh_prev;
-	unsigned long offset;
-	unsigned long size;
-} XGI_OH;
-
-typedef struct _XGI_OHALLOC {
-	struct _XGI_OHALLOC *poha_next;
-	XGI_OH aoh[1];
-} XGI_OHALLOC;
-
-typedef struct _XGI_HEAP {
-	XGI_OH oh_free;
-	XGI_OH oh_used;
-	XGI_OH *poh_freelist;
-	XGI_OHALLOC *poha_chain;
-	unsigned long max_freesize;
-} XGI_HEAP;
-
-static unsigned long XGIfb_heap_start;
-static unsigned long XGIfb_heap_end;
-static unsigned long XGIfb_heap_size;
-static XGI_HEAP      XGIfb_heap;
-
 // Eden Chen
 static const struct _XGI_TV_filter {
 	u8 filter[9][4];
@@ -766,15 +737,6 @@ static int      XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 static void     XGIfb_pre_setmode(void);
 static void     XGIfb_post_setmode(void);
 
-struct XGI_memreq {
-	unsigned long offset;
-	unsigned long size;
-};
-
-/* XGI-specific Export functions */
-void            XGI_malloc(struct XGI_memreq *req);
-void            XGI_free(unsigned long base);
-
 /* Internal hardware access routines */
 void            XGIfb_set_reg4(u16 port, unsigned long data);
 u32             XGIfb_get_reg3(u16 port);
@@ -788,15 +750,6 @@ static void     XGIfb_get_VB_type(void);
 static int      XGIfb_has_VB(void);
 
 
-/* Internal heap routines */
-static int      XGIfb_heap_init(void);
-static XGI_OH   *XGIfb_poh_new_node(void);
-static XGI_OH   *XGIfb_poh_allocate(unsigned long size);
-static void     XGIfb_delete_node(XGI_OH *poh);
-static void     XGIfb_insert_node(XGI_OH *pohList, XGI_OH *poh);
-static XGI_OH   *XGIfb_poh_free(unsigned long base);
-static void     XGIfb_free_node(XGI_OH *poh);
-
 /* Internal routines to access PCI configuration space */
 unsigned char XGIfb_query_VGA_config_space(struct xgi_hw_device_info *pXGIhw_ext,
 					   unsigned long offset,
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 08551e9..aeccdee 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1495,16 +1495,6 @@ static int XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
 
 	fix->smem_len = xgi_video_info.video_size;
 
-	/*        if((!XGIfb_mem) || (XGIfb_mem > (xgi_video_info.video_size/1024))) {
-	 if (xgi_video_info.video_size > 0x1000000) {
-	 fix->smem_len = 0xD00000;
-	 } else if (xgi_video_info.video_size > 0x800000)
-	 fix->smem_len = 0x800000;
-	 else
-	 fix->smem_len = 0x400000;
-	 } else
-	 fix->smem_len = XGIfb_mem * 1024;
-	 */
 	fix->type = video_type;
 	fix->type_aux = 0;
 	if (xgi_video_info.video_bpp == 8)
@@ -1883,297 +1873,6 @@ void XGI_Sense30x(void)
 	outXGIIDXREG(XGIPART4, 0x0d, backupP4_0d);
 }
 
-/* ------------------------ Heap routines -------------------------- */
-
-static int XGIfb_heap_init(void)
-{
-	XGI_OH *poh;
-
-	/* TW: The heap start is either set manually using the "mem" parameter, or
-	 *     defaults as follows:
-	 *     -) If more than 16MB videoRAM available, let our heap start at 12MB.
-	 *     -) If more than  8MB videoRAM available, let our heap start at  8MB.
-	 *     -) If 4MB or less is available, let it start at 4MB.
-	 *     This is for avoiding a clash with X driver which uses the beginning
-	 *     of the videoRAM. To limit size of X framebuffer, use Option MaxXFBMem
-	 *     in XF86Config-4.
-	 *     The heap start can also be specified by parameter "mem" when starting the XGIfb
-	 *     driver. XGIfb mem=1024 lets heap starts at 1MB, etc.
-	 */
-	if ((!XGIfb_mem) || (XGIfb_mem > (xgi_video_info.video_size / 1024))) {
-		if (xgi_video_info.video_size > 0x1000000)
-			xgi_video_info.heapstart = 0xD00000;
-		else if (xgi_video_info.video_size > 0x800000)
-			xgi_video_info.heapstart = 0x800000;
-		else
-			xgi_video_info.heapstart = 0x400000;
-	} else {
-		xgi_video_info.heapstart = XGIfb_mem * 1024;
-	}
-	XGIfb_heap_start = (unsigned long) (xgi_video_info.video_vbase
-			+ xgi_video_info.heapstart);
-	printk(KERN_INFO "XGIfb: Memory heap starting at %dK\n",
-			(int)(xgi_video_info.heapstart / 1024));
-
-	XGIfb_heap_end = (unsigned long) xgi_video_info.video_vbase
-			+ xgi_video_info.video_size;
-	XGIfb_heap_size = XGIfb_heap_end - XGIfb_heap_start;
-
-	XGIfb_heap.poha_chain = NULL;
-	XGIfb_heap.poh_freelist = NULL;
-
-	poh = XGIfb_poh_new_node();
-
-	if (poh == NULL)
-		return 1;
-
-	poh->poh_next = &XGIfb_heap.oh_free;
-	poh->poh_prev = &XGIfb_heap.oh_free;
-	poh->size = XGIfb_heap_end - XGIfb_heap_start + 1;
-	poh->offset = XGIfb_heap_start - (unsigned long) xgi_video_info.video_vbase;
-
-	DPRINTK("XGIfb: Heap start:0x%p, end:0x%p, len=%dk\n",
-		(char *) XGIfb_heap_start, (char *) XGIfb_heap_end,
-		(unsigned int) poh->size / 1024);
-
-	DPRINTK("XGIfb: First Node offset:0x%x, size:%dk\n",
-		(unsigned int) poh->offset, (unsigned int) poh->size / 1024);
-
-	XGIfb_heap.oh_free.poh_next = poh;
-	XGIfb_heap.oh_free.poh_prev = poh;
-	XGIfb_heap.oh_free.size = 0;
-	XGIfb_heap.max_freesize = poh->size;
-
-	XGIfb_heap.oh_used.poh_next = &XGIfb_heap.oh_used;
-	XGIfb_heap.oh_used.poh_prev = &XGIfb_heap.oh_used;
-	XGIfb_heap.oh_used.size = SENTINEL;
-
-	return 0;
-}
-
-static XGI_OH *XGIfb_poh_new_node(void)
-{
-	int i;
-	unsigned long cOhs;
-	XGI_OHALLOC *poha;
-	XGI_OH *poh;
-
-	if (XGIfb_heap.poh_freelist == NULL) {
-		poha = kmalloc(OH_ALLOC_SIZE, GFP_KERNEL);
-		if (!poha)
-			return NULL;
-
-		poha->poha_next = XGIfb_heap.poha_chain;
-		XGIfb_heap.poha_chain = poha;
-
-		cOhs = (OH_ALLOC_SIZE - sizeof(XGI_OHALLOC)) / sizeof(XGI_OH)
-				+ 1;
-
-		poh = &poha->aoh[0];
-		for (i = cOhs - 1; i != 0; i--) {
-			poh->poh_next = poh + 1;
-			poh = poh + 1;
-		}
-
-		poh->poh_next = NULL;
-		XGIfb_heap.poh_freelist = &poha->aoh[0];
-	}
-
-	poh = XGIfb_heap.poh_freelist;
-	XGIfb_heap.poh_freelist = poh->poh_next;
-
-	return poh;
-}
-
-static XGI_OH *XGIfb_poh_allocate(unsigned long size)
-{
-	XGI_OH *pohThis;
-	XGI_OH *pohRoot;
-	int bAllocated = 0;
-
-	if (size > XGIfb_heap.max_freesize) {
-		DPRINTK("XGIfb: Can't allocate %dk size on offscreen\n",
-				(unsigned int) size / 1024);
-		return NULL;
-	}
-
-	pohThis = XGIfb_heap.oh_free.poh_next;
-
-	while (pohThis != &XGIfb_heap.oh_free) {
-		if (size <= pohThis->size) {
-			bAllocated = 1;
-			break;
-		}
-		pohThis = pohThis->poh_next;
-	}
-
-	if (!bAllocated) {
-		DPRINTK("XGIfb: Can't allocate %dk size on offscreen\n",
-				(unsigned int) size / 1024);
-		return NULL;
-	}
-
-	if (size == pohThis->size) {
-		pohRoot = pohThis;
-		XGIfb_delete_node(pohThis);
-	} else {
-		pohRoot = XGIfb_poh_new_node();
-
-		if (pohRoot == NULL)
-			return NULL;
-
-		pohRoot->offset = pohThis->offset;
-		pohRoot->size = size;
-
-		pohThis->offset += size;
-		pohThis->size -= size;
-	}
-
-	XGIfb_heap.max_freesize -= size;
-
-	pohThis = &XGIfb_heap.oh_used;
-	XGIfb_insert_node(pohThis, pohRoot);
-
-	return pohRoot;
-}
-
-static void XGIfb_delete_node(XGI_OH *poh)
-{
-	XGI_OH *poh_prev;
-	XGI_OH *poh_next;
-
-	poh_prev = poh->poh_prev;
-	poh_next = poh->poh_next;
-
-	poh_prev->poh_next = poh_next;
-	poh_next->poh_prev = poh_prev;
-
-}
-
-static void XGIfb_insert_node(XGI_OH *pohList, XGI_OH *poh)
-{
-	XGI_OH *pohTemp;
-
-	pohTemp = pohList->poh_next;
-
-	pohList->poh_next = poh;
-	pohTemp->poh_prev = poh;
-
-	poh->poh_prev = pohList;
-	poh->poh_next = pohTemp;
-}
-
-static XGI_OH *XGIfb_poh_free(unsigned long base)
-{
-	XGI_OH *pohThis;
-	XGI_OH *poh_freed;
-	XGI_OH *poh_prev;
-	XGI_OH *poh_next;
-	unsigned long ulUpper;
-	unsigned long ulLower;
-	int foundNode = 0;
-
-	poh_freed = XGIfb_heap.oh_used.poh_next;
-
-	while (poh_freed != &XGIfb_heap.oh_used) {
-		if (poh_freed->offset == base) {
-			foundNode = 1;
-			break;
-		}
-
-		poh_freed = poh_freed->poh_next;
-	}
-
-	if (!foundNode)
-		return NULL;
-
-	XGIfb_heap.max_freesize += poh_freed->size;
-
-	poh_prev = poh_next = NULL;
-	ulUpper = poh_freed->offset + poh_freed->size;
-	ulLower = poh_freed->offset;
-
-	pohThis = XGIfb_heap.oh_free.poh_next;
-
-	while (pohThis != &XGIfb_heap.oh_free) {
-		if (pohThis->offset == ulUpper)
-			poh_next = pohThis;
-		else if ((pohThis->offset + pohThis->size) == ulLower)
-			poh_prev = pohThis;
-
-		pohThis = pohThis->poh_next;
-	}
-
-	XGIfb_delete_node(poh_freed);
-
-	if (poh_prev && poh_next) {
-		poh_prev->size += (poh_freed->size + poh_next->size);
-		XGIfb_delete_node(poh_next);
-		XGIfb_free_node(poh_freed);
-		XGIfb_free_node(poh_next);
-		return poh_prev;
-	}
-
-	if (poh_prev) {
-		poh_prev->size += poh_freed->size;
-		XGIfb_free_node(poh_freed);
-		return poh_prev;
-	}
-
-	if (poh_next) {
-		poh_next->size += poh_freed->size;
-		poh_next->offset = poh_freed->offset;
-		XGIfb_free_node(poh_freed);
-		return poh_next;
-	}
-
-	XGIfb_insert_node(&XGIfb_heap.oh_free, poh_freed);
-
-	return poh_freed;
-}
-
-static void XGIfb_free_node(XGI_OH *poh)
-{
-	if (poh == NULL)
-		return;
-
-	poh->poh_next = XGIfb_heap.poh_freelist;
-	XGIfb_heap.poh_freelist = poh;
-
-}
-
-void XGI_malloc(struct XGI_memreq *req)
-{
-	XGI_OH *poh;
-
-	poh = XGIfb_poh_allocate(req->size);
-
-	if (poh == NULL) {
-		req->offset = 0;
-		req->size = 0;
-		DPRINTK("XGIfb: Video RAM allocation failed\n");
-	} else {
-		DPRINTK("XGIfb: Video RAM allocation succeeded: 0x%p\n",
-				(char *) (poh->offset + (unsigned long) xgi_video_info.video_vbase));
-
-		req->offset = poh->offset;
-		req->size = poh->size;
-	}
-
-}
-
-void XGI_free(unsigned long base)
-{
-	XGI_OH *poh;
-
-	poh = XGIfb_poh_free(base);
-
-	if (poh == NULL) {
-		DPRINTK("XGIfb: XGIfb_poh_free() failed at base 0x%x\n",
-				(unsigned int) base);
-	}
-}
-
 /* --------------------- SetMode routines ------------------------- */
 
 static void XGIfb_pre_setmode(void)
@@ -2434,8 +2133,6 @@ XGIINITSTATIC int __init XGIfb_setup(char *options)
 			XGIfb_search_tvstd(this_opt + 7);
 		} else if (!strncmp(this_opt, "tvstandard:", 11)) {
 			XGIfb_search_tvstd(this_opt + 7);
-		} else if (!strncmp(this_opt, "mem:", 4)) {
-			XGIfb_mem = simple_strtoul(this_opt + 4, NULL, 0);
 		} else if (!strncmp(this_opt, "dstn", 4)) {
 			enable_dstn = 1;
 			/* TW: DSTN overrules forcecrt2type */
@@ -2686,9 +2383,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	else
 		printk("Fail\n");
 
-	if (XGIfb_heap_init())
-		printk(KERN_WARNING "XGIfb: Failed to initialize offscreen memory heap\n");
-
 	xgi_video_info.mtrr = (unsigned int) 0;
 
 	if ((xgifb_mode_idx < 0) || ((XGIbios_mode[xgifb_mode_idx].mode_no) != 0xFF)) {
@@ -3074,15 +2768,6 @@ module_param(resetcard, int, 0);
 module_param(videoram, int, 0);
 #endif
 
-MODULE_PARM_DESC(mem,
-		"\nDetermines the beginning of the video memory heap in KB. This heap is used\n"
-		"for video RAM management for eg. DRM/DRI. On 300 series, the default depends\n"
-		"on the amount of video RAM available. If 8MB of video RAM or less is available,\n"
-		"the heap starts at 4096KB, if between 8 and 16MB are available at 8192KB,\n"
-		"otherwise at 12288KB. On 315 and Xabre series, the heap size is 32KB by default.\n"
-		"The value is to be specified without 'KB' and must match the MaxXFBMem setting\n"
-		"for XFree86 4.x/X.org 6.7 and later.\n");
-
 MODULE_PARM_DESC(noypan,
 		"\nIf set to anything other than 0, y-panning will be disabled and scrolling\n"
 		"will be performed by redrawing the screen. (default: 0)\n");
@@ -3191,7 +2876,3 @@ module_init(xgifb_init_module);
 module_exit(xgifb_remove_module);
 
 #endif	/*  /MODULE  */
-
-EXPORT_SYMBOL(XGI_malloc);
-EXPORT_SYMBOL(XGI_free);
-
diff --git a/drivers/staging/xgifb/XGIfb.h b/drivers/staging/xgifb/XGIfb.h
index d6c3139..7813bbe 100644
--- a/drivers/staging/xgifb/XGIfb.h
+++ b/drivers/staging/xgifb/XGIfb.h
@@ -92,7 +92,6 @@ struct video_info{
         char  *       mmio_vbase;
         unsigned long vga_base;
         unsigned long mtrr;
-        unsigned long heapstart;
 
         int    video_bpp;
         int    video_cmap_len;
-- 
1.5.6.5

