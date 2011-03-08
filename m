Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab1CHUQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:16:26 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:42450 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237Ab1CHUQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:13 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 02/15] staging: xgifb: delete command queue selection/init
Date: Tue,  8 Mar 2011 22:16:07 +0200
Message-Id: <1299615380-22922-3-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver does not utilize HW command queue in any way, so the code
can be dropped. The support for the default mode (MMIO) and AGP have
been disabled already anyway.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h    |   49 --------
 drivers/staging/xgifb/XGI_main_26.c |  209 -----------------------------------
 2 files changed, 0 insertions(+), 258 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 88d15c8..2c55faa 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -10,7 +10,6 @@
 #include "vb_def.h"
 
 //#define LINUXBIOS   /* turn this on when compiling for LINUXBIOS */
-#define AGPOFF     /* default is turn off AGP */
 
 #define XGIFAIL(x) do { printk(x "\n"); return -EINVAL; } while(0)
 
@@ -66,19 +65,6 @@ MODULE_DEVICE_TABLE(pci, xgifb_pci_table);
 
 #define MAX_ROM_SCAN              0x10000
 
-#define TURBO_QUEUE_CAP           0x40
-#define AGP_CMD_QUEUE_CAP         0x20
-#define VM_CMD_QUEUE_CAP          0x10
-#define MMIO_CMD_QUEUE_CAP        0x08
-
-
-
-/* For 315 series */
-
-#define COMMAND_QUEUE_AREA_SIZE   0x80000 /* 512K */
-#define COMMAND_QUEUE_THRESHOLD   0x1F
-
-
 #define OH_ALLOC_SIZE             4000
 #define SENTINEL                  0x7fffffff
 
@@ -190,16 +176,6 @@ MODULE_DEVICE_TABLE(pci, xgifb_pci_table);
 #define XGI_MEM_MAP_IO_ENABLE     0x01  /* SR20 */
 #define XGI_PCI_ADDR_ENABLE       0x80
 
-#define XGI_AGP_CMDQUEUE_ENABLE   0x80  /* 315/650/740 SR26 */
-#define XGI_VRAM_CMDQUEUE_ENABLE  0x40
-#define XGI_MMIO_CMD_ENABLE       0x20
-#define XGI_CMD_QUEUE_SIZE_512k   0x00
-#define XGI_CMD_QUEUE_SIZE_1M     0x04
-#define XGI_CMD_QUEUE_SIZE_2M     0x08
-#define XGI_CMD_QUEUE_SIZE_4M     0x0C
-#define XGI_CMD_QUEUE_RESET       0x01
-#define XGI_CMD_AUTO_CORR	  0x02
-
 #define XGI_SIMULTANEOUS_VIEW_ENABLE  0x01  /* CR30 */
 #define XGI_MODE_SELECT_CRT2      0x02
 #define XGI_VB_OUTPUT_COMPOSITE   0x04
@@ -350,8 +326,6 @@ static int XGIfb_CRT2_write_enable = 0;
 static int XGIfb_crt2type = -1; /* TW: CRT2 type (for overriding autodetection) */
 static int XGIfb_tvplug = -1; /* PR: Tv plug type (for overriding autodetection) */
 
-static int XGIfb_queuemode = -1; /* TW: Use MMIO queue mode by default (310/325 series only) */
-
 static unsigned char XGIfb_detectedpdc = 0;
 
 static unsigned char XGIfb_detectedlcda = 0xff;
@@ -368,15 +342,6 @@ static struct xgi_hw_device_info XGIhw_ext;
 /* TW: XGI private structure */
 static struct vb_device_info  XGI_Pr;
 
-/* card parameters */
-static u8            XGIfb_caps = 0;
-
-typedef enum _XGI_CMDTYPE {
-	MMIO_CMD = 0,
-	AGP_CMD_QUEUE,
-	VM_CMD_QUEUE,
-} XGI_CMDTYPE;
-
 #define MD_XGI300 1
 #define MD_XGI315 2
 
@@ -519,20 +484,6 @@ static const struct _XGI_crt2type {
 	{"\0",  	-1, 		-1}
 };
 
-/* Queue mode selection for 310 series */
-static const struct _XGI_queuemode {
-	char name[6];
-	int type_no;
-} XGI_queuemode[] = {
-	{"AGP",  	AGP_CMD_QUEUE},
-	{"VRAM", 	VM_CMD_QUEUE},
-	{"MMIO", 	MMIO_CMD},
-	{"agp",  	AGP_CMD_QUEUE},
-	{"vram", 	VM_CMD_QUEUE},
-	{"mmio", 	MMIO_CMD},
-	{"\0",   	-1}
-};
-
 /* TV standard */
 static const struct _XGI_tvtype {
 	char name[6];
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 3998dd4..08551e9 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -898,24 +898,6 @@ static void XGIfb_search_crt2type(const char *name)
 		printk(KERN_INFO "XGIfb: Invalid CRT2 type: %s\n", name);
 }
 
-static void XGIfb_search_queuemode(const char *name)
-{
-	int i = 0;
-
-	if (name == NULL)
-		return;
-
-	while (XGI_queuemode[i].type_no != -1) {
-		if (!strcmp(name, XGI_queuemode[i].name)) {
-			XGIfb_queuemode = XGI_queuemode[i].type_no;
-			break;
-		}
-		i++;
-	}
-	if (XGIfb_queuemode < 0)
-		printk(KERN_INFO "XGIfb: Invalid queuemode type: %s\n", name);
-}
-
 static u8 XGIfb_search_refresh_rate(unsigned int rate)
 {
 	u16 xres, yres;
@@ -1906,19 +1888,6 @@ void XGI_Sense30x(void)
 static int XGIfb_heap_init(void)
 {
 	XGI_OH *poh;
-	u8 temp = 0;
-
-	int agp_enabled = 1;
-	u32 agp_size;
-	unsigned long *cmdq_baseport = NULL;
-	unsigned long *read_port = NULL;
-	unsigned long *write_port = NULL;
-	XGI_CMDTYPE cmd_type;
-#ifndef AGPOFF
-	struct agp_kern_info *agp_info;
-	struct agp_memory *agp;
-	u32 agp_phys;
-#endif
 
 	/* TW: The heap start is either set manually using the "mem" parameter, or
 	 *     defaults as follows:
@@ -1950,178 +1919,6 @@ static int XGIfb_heap_init(void)
 			+ xgi_video_info.video_size;
 	XGIfb_heap_size = XGIfb_heap_end - XGIfb_heap_start;
 
-	/* TW: Now initialize the 310 series' command queue mode.
-	 * On 310/325, there are three queue modes available which
-	 * are chosen by setting bits 7:5 in SR26:
-	 * 1. MMIO queue mode (bit 5, 0x20). The hardware will keep
-	 *    track of the queue, the FIFO, command parsing and so
-	 *    on. This is the one comparable to the 300 series.
-	 * 2. VRAM queue mode (bit 6, 0x40). In this case, one will
-	 *    have to do queue management himself. Register 0x85c4 will
-	 *    hold the location of the next free queue slot, 0x85c8
-	 *    is the "queue read pointer" whose way of working is
-	 *    unknown to me. Anyway, this mode would require a
-	 *    translation of the MMIO commands to some kind of
-	 *    accelerator assembly and writing these commands
-	 *    to the memory location pointed to by 0x85c4.
-	 *    We will not use this, as nobody knows how this
-	 *    "assembly" works, and as it would require a complete
-	 *    re-write of the accelerator code.
-	 * 3. AGP queue mode (bit 7, 0x80). Works as 2., but keeps the
-	 *    queue in AGP memory space.
-	 *
-	 * SR26 bit 4 is called "Bypass H/W queue".
-	 * SR26 bit 1 is called "Enable Command Queue Auto Correction"
-	 * SR26 bit 0 resets the queue
-	 * Size of queue memory is encoded in bits 3:2 like this:
-	 *    00  (0x00)  512K
-	 *    01  (0x04)  1M
-	 *    10  (0x08)  2M
-	 *    11  (0x0C)  4M
-	 * The queue location is to be written to 0x85C0.
-	 *
-	 */
-	cmdq_baseport = (unsigned long *) (xgi_video_info.mmio_vbase
-			+ MMIO_QUEUE_PHYBASE);
-	write_port = (unsigned long *) (xgi_video_info.mmio_vbase
-			+ MMIO_QUEUE_WRITEPORT);
-	read_port = (unsigned long *) (xgi_video_info.mmio_vbase
-			+ MMIO_QUEUE_READPORT);
-
-	DPRINTK("AGP base: 0x%p, read: 0x%p, write: 0x%p\n", cmdq_baseport, read_port, write_port);
-
-	agp_size = COMMAND_QUEUE_AREA_SIZE;
-
-#ifndef AGPOFF
-	if (XGIfb_queuemode == AGP_CMD_QUEUE) {
-		agp_info = vzalloc(sizeof(*agp_info));
-		agp_copy_info(agp_info);
-
-		agp_backend_acquire();
-
-		agp = agp_allocate_memory(COMMAND_QUEUE_AREA_SIZE / PAGE_SIZE,
-				AGP_NORMAL_MEMORY);
-		if (agp == NULL) {
-			DPRINTK("XGIfb: Allocating AGP buffer failed.\n");
-			agp_enabled = 0;
-		} else {
-			if (agp_bind_memory(agp, agp->pg_start) != 0) {
-				DPRINTK("XGIfb: AGP: Failed to bind memory\n");
-				/* TODO: Free AGP memory here */
-				agp_enabled = 0;
-			} else {
-				agp_enable(0);
-			}
-		}
-	}
-#else
-	agp_enabled = 0;
-#endif
-
-	/* TW: Now select the queue mode */
-
-	if ((agp_enabled) && (XGIfb_queuemode == AGP_CMD_QUEUE)) {
-		cmd_type = AGP_CMD_QUEUE;
-		printk(KERN_INFO "XGIfb: Using AGP queue mode\n");
-	/* } else if (XGIfb_heap_size >= COMMAND_QUEUE_AREA_SIZE)  */
-	} else if (XGIfb_queuemode == VM_CMD_QUEUE) {
-		cmd_type = VM_CMD_QUEUE;
-		printk(KERN_INFO "XGIfb: Using VRAM queue mode\n");
-	} else {
-		printk(KERN_INFO "XGIfb: Using MMIO queue mode\n");
-		cmd_type = MMIO_CMD;
-	}
-
-	switch (agp_size) {
-	case 0x80000:
-		temp = XGI_CMD_QUEUE_SIZE_512k;
-		break;
-	case 0x100000:
-		temp = XGI_CMD_QUEUE_SIZE_1M;
-		break;
-	case 0x200000:
-		temp = XGI_CMD_QUEUE_SIZE_2M;
-		break;
-	case 0x400000:
-		temp = XGI_CMD_QUEUE_SIZE_4M;
-		break;
-	}
-
-	switch (cmd_type) {
-	case AGP_CMD_QUEUE:
-#ifndef AGPOFF
-		DPRINTK("XGIfb: AGP buffer base = 0x%lx, offset = 0x%x, size = %dK\n",
-			agp_info->aper_base, agp->physical, agp_size/1024);
-
-		agp_phys = agp_info->aper_base + agp->physical;
-
-		outXGIIDXREG(XGICR, IND_XGI_AGP_IO_PAD, 0);
-		outXGIIDXREG(XGICR, IND_XGI_AGP_IO_PAD, XGI_AGP_2X);
-
-		outXGIIDXREG(XGISR, IND_XGI_CMDQUEUE_THRESHOLD, COMMAND_QUEUE_THRESHOLD);
-
-		outXGIIDXREG(XGISR, IND_XGI_CMDQUEUE_SET, XGI_CMD_QUEUE_RESET);
-
-		*write_port = *read_port;
-
-		temp |= XGI_AGP_CMDQUEUE_ENABLE;
-		outXGIIDXREG(XGISR, IND_XGI_CMDQUEUE_SET, temp);
-
-		*cmdq_baseport = agp_phys;
-
-		XGIfb_caps |= AGP_CMD_QUEUE_CAP;
-#endif
-		break;
-
-	case VM_CMD_QUEUE:
-		XGIfb_heap_end -= COMMAND_QUEUE_AREA_SIZE;
-		XGIfb_heap_size -= COMMAND_QUEUE_AREA_SIZE;
-
-		outXGIIDXREG(XGISR, IND_XGI_CMDQUEUE_THRESHOLD, COMMAND_QUEUE_THRESHOLD);
-
-		outXGIIDXREG(XGISR, IND_XGI_CMDQUEUE_SET, XGI_CMD_QUEUE_RESET);
-
-		*write_port = *read_port;
-
-		temp |= XGI_VRAM_CMDQUEUE_ENABLE;
-		outXGIIDXREG(XGISR, IND_XGI_CMDQUEUE_SET, temp);
-
-		*cmdq_baseport = xgi_video_info.video_size - COMMAND_QUEUE_AREA_SIZE;
-
-		XGIfb_caps |= VM_CMD_QUEUE_CAP;
-
-		DPRINTK("XGIfb: VM Cmd Queue offset = 0x%lx, size is %dK\n",
-			*cmdq_baseport, COMMAND_QUEUE_AREA_SIZE/1024);
-		break;
-
-	default: /* MMIO */
-
-		/* printk("%s:%d - I'm here\n", __FUNCTION__, __LINE__); */
-		/* TW: This previously only wrote XGI_MMIO_CMD_ENABLE
-		 * to IND_XGI_CMDQUEUE_SET. I doubt that this is
-		 * enough. Reserve memory in any way.
-		 */
-		/* FIXME XGIfb_heap_end -= COMMAND_QUEUE_AREA_SIZE; */
-		/* FIXME XGIfb_heap_size -= COMMAND_QUEUE_AREA_SIZE; */
-		/* FIXME */
-		/* FIXME outXGIIDXREG(XGISR, IND_XGI_CMDQUEUE_THRESHOLD, COMMAND_QUEUE_THRESHOLD); */
-		/* FIXME outXGIIDXREG(XGISR, IND_XGI_CMDQUEUE_SET, XGI_CMD_QUEUE_RESET); */
-		/* FIXME */
-		/* FIXME *write_port = *read_port; */
-		/* FIXME */
-		/* FIXME *//* TW: Set Auto_Correction bit */
-		/* FIXME temp |= (XGI_MMIO_CMD_ENABLE | XGI_CMD_AUTO_CORR); */
-		/* FIXME outXGIIDXREG(XGISR, IND_XGI_CMDQUEUE_SET, temp); */
-		/* FIXME */
-		/* FIXME *cmdq_baseport = xgi_video_info.video_size - COMMAND_QUEUE_AREA_SIZE; */
-		/* FIXME */
-		/* FIXME XGIfb_caps |= MMIO_CMD_QUEUE_CAP; */
-		/* FIXME */
-		/* FIXME DPRINTK("XGIfb: MMIO Cmd Queue offset = 0x%lx, size is %dK\n", */
-		/* FIXME	*cmdq_baseport, COMMAND_QUEUE_AREA_SIZE/1024); */
-	break;
-}
-
 	XGIfb_heap.poha_chain = NULL;
 	XGIfb_heap.poh_freelist = NULL;
 
@@ -2643,8 +2440,6 @@ XGIINITSTATIC int __init XGIfb_setup(char *options)
 			enable_dstn = 1;
 			/* TW: DSTN overrules forcecrt2type */
 			XGIfb_crt2type = DISPTYPE_LCD;
-		} else if (!strncmp(this_opt, "queuemode:", 10)) {
-			XGIfb_search_queuemode(this_opt + 10);
 		} else if (!strncmp(this_opt, "pdc:", 4)) {
 			XGIfb_pdc = simple_strtoul(this_opt + 4, NULL, 0);
 			if (XGIfb_pdc & ~0x3c) {
@@ -2662,10 +2457,6 @@ XGIINITSTATIC int __init XGIfb_setup(char *options)
 			/* printk(KERN_INFO "XGIfb: Invalid option %s\n", this_opt); */
 		}
 
-		/* TW: Acceleration only with MMIO mode */
-		if ((XGIfb_queuemode != -1) && (XGIfb_queuemode != MMIO_CMD)) {
-			XGIfb_ypan = 0;
-		}
 		/* TW: Panning only with acceleration */
 		XGIfb_ypan = 0;
 
-- 
1.5.6.5

