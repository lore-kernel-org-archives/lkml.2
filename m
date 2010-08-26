Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab0HZNWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:22:42 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42276 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab0HZNV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:27 -0400
Message-Id: <20100826132126.424872239@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:19:59 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 22/25] GRU - gru api cleanup
References: <20100826131937.108920216@sgi.com>
Content-Disposition: inline; filename=uv_gru_instruction_macros
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Header file cleanup & reorganization. A variant of the gru_instructions.h
header file is part of the user API. Move items that are NOT part of the
user API from this header file to internal header files.

	- move the CBX definition
	- move the exception retrybits
	- remove the option for mapped/unmapped mode from the
	  instruction macros. Users always run in mapped mode; the
	  kernel always runs in ummapped mode. This option does not
	  need to an option exposed via the macros

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gru_instructions.h |   88 +++++++-------------------------
 drivers/misc/sgi-gru/gruhandles.h       |    1 
 drivers/misc/sgi-gru/grulib.h           |   34 ++++++++++++
 3 files changed, 55 insertions(+), 68 deletions(-)

Index: linux/drivers/misc/sgi-gru/gru_instructions.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru_instructions.h	2010-06-09 08:11:43.303963161 -0500
+++ linux/drivers/misc/sgi-gru/gru_instructions.h	2010-06-09 08:11:50.264036100 -0500
@@ -71,21 +71,6 @@ extern void gru_wait_abort_proc(void *cb
 #define CBSS_PUT_NACKED			5
 
 /*
- * Structure used to fetch exception detail for CBs that terminate with
- * CBS_EXCEPTION
- */
-struct control_block_extended_exc_detail {
-	unsigned long	cb;
-	int		opc;
-	int		ecause;
-	int		exopc;
-	long		exceptdet0;
-	int		exceptdet1;
-	int		cbrstate;
-	int		cbrexecstatus;
-};
-
-/*
  * Instruction formats
  */
 
@@ -289,19 +274,6 @@ struct gru_instruction {
 #define CBR_EXS_EXCEPTION			(1 << CBR_EXS_EXCEPTION_BIT)
 #define CBR_EXS_CB_INT_PENDING			(1 << CBR_EXS_CB_INT_PENDING_BIT)
 
-/*
- * Exceptions are retried for the following cases. If any OTHER bits are set
- * in ecause, the exception is not retryable.
- */
-#define EXCEPTION_RETRY_BITS (CBE_CAUSE_EXECUTION_HW_ERROR |		\
-			      CBE_CAUSE_TLBHW_ERROR |			\
-			      CBE_CAUSE_RA_REQUEST_TIMEOUT |		\
-			      CBE_CAUSE_RA_RESPONSE_NON_FATAL |		\
-			      CBE_CAUSE_HA_RESPONSE_NON_FATAL |		\
-			      CBE_CAUSE_RA_RESPONSE_DATA_ERROR |	\
-			      CBE_CAUSE_HA_RESPONSE_DATA_ERROR		\
-			      )
-
 /* Message queue head structure */
 union gru_mesqhead {
 	unsigned long	val;
@@ -311,7 +283,6 @@ union gru_mesqhead {
 	};
 };
 
-
 /* Generate the low word of a GRU instruction */
 static inline unsigned long
 __opdword(unsigned char opcode, unsigned char exopc, unsigned char xtype,
@@ -324,6 +295,7 @@ __opdword(unsigned char opcode, unsigned
 	   (iaa0 << GRU_CB_IAA0_SHFT) |
 	   (iaa1 << GRU_CB_IAA1_SHFT) |
 	   (ima << GRU_CB_IMA_SHFT) |
+	   (IMA_UNMAPPED << GRU_CB_IMA_SHFT) |
 	   (xtype << GRU_CB_XTYPE_SHFT) |
 	   (opcode << GRU_CB_OPC_SHFT) |
 	   (exopc << GRU_CB_EXOPC_SHFT);
@@ -349,12 +321,6 @@ static inline void gru_start_instruction
 }
 
 
-/* Convert "hints" to IMA */
-#define CB_IMA(h)		((h) | IMA_UNMAPPED)
-
-/* Convert data segment cache line index into TRI0 / TRI1 value */
-#define GRU_DINDEX(i)		((i) * GRU_CACHE_LINE_BYTES)
-
 /* Inline functions for GRU instructions.
  *     Note:
  *     	- nelem and stride are in elements
@@ -369,7 +335,7 @@ static inline void gru_vload_phys(void *
 	ins->nelem = 1;
 	ins->op1_stride = 1;
 	gru_start_instruction(ins, __opdword(OP_VLOAD, 0, XTYPE_DW, iaa, 0,
-					(unsigned long)tri0, CB_IMA(hints)));
+					(unsigned long)tri0, hints));
 }
 
 static inline void gru_vstore_phys(void *cb, unsigned long gpa,
@@ -381,7 +347,7 @@ static inline void gru_vstore_phys(void
 	ins->nelem = 1;
 	ins->op1_stride = 1;
 	gru_start_instruction(ins, __opdword(OP_VSTORE, 0, XTYPE_DW, iaa, 0,
-					(unsigned long)tri0, CB_IMA(hints)));
+					(unsigned long)tri0, hints));
 }
 
 static inline void gru_vload(void *cb, unsigned long mem_addr,
@@ -394,7 +360,7 @@ static inline void gru_vload(void *cb, u
 	ins->nelem = nelem;
 	ins->op1_stride = stride;
 	gru_start_instruction(ins, __opdword(OP_VLOAD, 0, xtype, IAA_RAM, 0,
-					(unsigned long)tri0, CB_IMA(hints)));
+					(unsigned long)tri0, hints));
 }
 
 static inline void gru_vstore(void *cb, unsigned long mem_addr,
@@ -407,7 +373,7 @@ static inline void gru_vstore(void *cb,
 	ins->nelem = nelem;
 	ins->op1_stride = stride;
 	gru_start_instruction(ins, __opdword(OP_VSTORE, 0, xtype, IAA_RAM, 0,
-					tri0, CB_IMA(hints)));
+					tri0, hints));
 }
 
 static inline void gru_ivload(void *cb, unsigned long mem_addr,
@@ -420,7 +386,7 @@ static inline void gru_ivload(void *cb,
 	ins->nelem = nelem;
 	ins->tri1_bufsize_64 = tri1;
 	gru_start_instruction(ins, __opdword(OP_IVLOAD, 0, xtype, IAA_RAM, 0,
-					tri0, CB_IMA(hints)));
+					tri0, hints));
 }
 
 static inline void gru_ivstore(void *cb, unsigned long mem_addr,
@@ -433,7 +399,7 @@ static inline void gru_ivstore(void *cb,
 	ins->nelem = nelem;
 	ins->tri1_bufsize_64 = tri1;
 	gru_start_instruction(ins, __opdword(OP_IVSTORE, 0, xtype, IAA_RAM, 0,
-					tri0, CB_IMA(hints)));
+					tri0, hints));
 }
 
 static inline void gru_vset(void *cb, unsigned long mem_addr,
@@ -447,7 +413,7 @@ static inline void gru_vset(void *cb, un
 	ins->nelem = nelem;
 	ins->op1_stride = stride;
 	gru_start_instruction(ins, __opdword(OP_VSET, 0, xtype, IAA_RAM, 0,
-					 0, CB_IMA(hints)));
+					 0, hints));
 }
 
 static inline void gru_ivset(void *cb, unsigned long mem_addr,
@@ -461,7 +427,7 @@ static inline void gru_ivset(void *cb, u
 	ins->nelem = nelem;
 	ins->tri1_bufsize_64 = tri1;
 	gru_start_instruction(ins, __opdword(OP_IVSET, 0, xtype, IAA_RAM, 0,
-					0, CB_IMA(hints)));
+					0, hints));
 }
 
 static inline void gru_vflush(void *cb, unsigned long mem_addr,
@@ -474,14 +440,14 @@ static inline void gru_vflush(void *cb,
 	ins->op1_stride = stride;
 	ins->nelem = nelem;
 	gru_start_instruction(ins, __opdword(OP_VFLUSH, 0, xtype, IAA_RAM, 0,
-					0, CB_IMA(hints)));
+					0, hints));
 }
 
 static inline void gru_nop(void *cb, int hints)
 {
 	struct gru_instruction *ins = (void *)cb;
 
-	gru_start_instruction(ins, __opdword(OP_NOP, 0, 0, 0, 0, 0, CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_NOP, 0, 0, 0, 0, 0, hints));
 }
 
 
@@ -497,7 +463,7 @@ static inline void gru_bcopy(void *cb, c
 	ins->nelem = nelem;
 	ins->tri1_bufsize_64 = bufsize;
 	gru_start_instruction(ins, __opdword(OP_BCOPY, 0, xtype, IAA_RAM,
-					IAA_RAM, tri0, CB_IMA(hints)));
+					IAA_RAM, tri0, hints));
 }
 
 static inline void gru_bstore(void *cb, const unsigned long src,
@@ -510,7 +476,7 @@ static inline void gru_bstore(void *cb,
 	ins->op2_value_baddr1 = (long)dest;
 	ins->nelem = nelem;
 	gru_start_instruction(ins, __opdword(OP_BSTORE, 0, xtype, 0, IAA_RAM,
-					tri0, CB_IMA(hints)));
+					tri0, hints));
 }
 
 static inline void gru_gamir(void *cb, int exopc, unsigned long src,
@@ -520,7 +486,7 @@ static inline void gru_gamir(void *cb, i
 
 	ins->baddr0 = (long)src;
 	gru_start_instruction(ins, __opdword(OP_GAMIR, exopc, xtype, IAA_RAM, 0,
-					0, CB_IMA(hints)));
+					0, hints));
 }
 
 static inline void gru_gamirr(void *cb, int exopc, unsigned long src,
@@ -530,7 +496,7 @@ static inline void gru_gamirr(void *cb,
 
 	ins->baddr0 = (long)src;
 	gru_start_instruction(ins, __opdword(OP_GAMIRR, exopc, xtype, IAA_RAM, 0,
-					0, CB_IMA(hints)));
+					0, hints));
 }
 
 static inline void gru_gamer(void *cb, int exopc, unsigned long src,
@@ -544,7 +510,7 @@ static inline void gru_gamer(void *cb, i
 	ins->op1_stride = operand1;
 	ins->op2_value_baddr1 = operand2;
 	gru_start_instruction(ins, __opdword(OP_GAMER, exopc, xtype, IAA_RAM, 0,
-					0, CB_IMA(hints)));
+					0, hints));
 }
 
 static inline void gru_gamerr(void *cb, int exopc, unsigned long src,
@@ -557,7 +523,7 @@ static inline void gru_gamerr(void *cb,
 	ins->op1_stride = operand1;
 	ins->op2_value_baddr1 = operand2;
 	gru_start_instruction(ins, __opdword(OP_GAMERR, exopc, xtype, IAA_RAM, 0,
-					0, CB_IMA(hints)));
+					0, hints));
 }
 
 static inline void gru_gamxr(void *cb, unsigned long src,
@@ -568,7 +534,7 @@ static inline void gru_gamxr(void *cb, u
 	ins->baddr0 = (long)src;
 	ins->nelem = 4;
 	gru_start_instruction(ins, __opdword(OP_GAMXR, EOP_XR_CSWAP, XTYPE_DW,
-				 IAA_RAM, 0, 0, CB_IMA(hints)));
+				 IAA_RAM, 0, 0, hints));
 }
 
 static inline void gru_mesq(void *cb, unsigned long queue,
@@ -580,7 +546,7 @@ static inline void gru_mesq(void *cb, un
 	ins->baddr0 = (long)queue;
 	ins->nelem = nelem;
 	gru_start_instruction(ins, __opdword(OP_MESQ, 0, XTYPE_CL, IAA_RAM, 0,
-					tri0, CB_IMA(hints)));
+					tri0, hints));
 }
 
 static inline unsigned long gru_get_amo_value(void *cb)
@@ -613,12 +579,6 @@ static inline union gru_mesqhead  gru_me
 	return mqh;
 }
 
-/*
- * Get struct control_block_extended_exc_detail for CB.
- */
-extern int gru_get_cb_exception_detail(void *cb,
-		       struct control_block_extended_exc_detail *excdet);
-
 #define GRU_EXC_STR_SIZE		256
 
 
@@ -671,6 +631,7 @@ static inline int gru_check_status(void
 	struct gru_control_block_status *cbs = (void *)cb;
 	int ret;
 
+	barrier();
 	ret = cbs->istatus;
 	if (ret != CBS_ACTIVE)
 		ret = gru_check_status_proc(cb);
@@ -700,15 +661,6 @@ static inline void gru_wait_abort(void *
 }
 
 /*
- * Get a pointer to the start of a gseg
- * 	p	- Any valid pointer within the gseg
- */
-static inline void *gru_get_gseg_pointer (void *p)
-{
-	return (void *)((unsigned long)p & ~(GRU_GSEG_PAGESIZE - 1));
-}
-
-/*
  * Get a pointer to a control block
  * 	gseg	- GSeg address returned from gru_get_thread_gru_segment()
  * 	index	- index of desired CB
Index: linux/drivers/misc/sgi-gru/gruhandles.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruhandles.h	2010-06-09 08:11:29.799955128 -0500
+++ linux/drivers/misc/sgi-gru/gruhandles.h	2010-06-09 08:11:50.268036119 -0500
@@ -22,6 +22,7 @@
 
 #ifndef __GRUHANDLES_H__
 #define __GRUHANDLES_H__
+#include "grulib.h"
 #include "gru_instructions.h"
 
 /*
Index: linux/drivers/misc/sgi-gru/grulib.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grulib.h	2010-06-09 08:11:47.993040877 -0500
+++ linux/drivers/misc/sgi-gru/grulib.h	2010-06-09 08:11:50.280038484 -0500
@@ -62,6 +62,25 @@
 #define THREAD_POINTER(p, th)		(p + GRU_GSEG_PAGESIZE * (th))
 #define GSEG_START(cb)			((void *)((unsigned long)(cb) & ~(GRU_GSEG_PAGESIZE - 1)))
 
+/*
+ * Size used to map GRU GSeg
+ */
+#define GRU_GSEG_PAGESIZE    (256 * 1024UL)
+
+/*
+ * Exceptions are retried for the following cases. If any OTHER bits are set
+ * in ecause, the exception is not retryable.
+ */
+#define EXCEPTION_RETRY_BITS (CBE_CAUSE_EXECUTION_HW_ERROR |            \
+			      CBE_CAUSE_TLBHW_ERROR |                   \
+			      CBE_CAUSE_RA_REQUEST_TIMEOUT |            \
+			      CBE_CAUSE_RA_RESPONSE_NON_FATAL |         \
+			      CBE_CAUSE_HA_RESPONSE_NON_FATAL |         \
+			      CBE_CAUSE_RA_RESPONSE_DATA_ERROR |        \
+			      CBE_CAUSE_HA_RESPONSE_DATA_ERROR          \
+			     )
+
+
 struct gru_get_gseg_statistics_req {
 	unsigned long			gseg;
 	struct gru_gseg_statistics	stats;
@@ -134,6 +153,21 @@ struct gru_dump_chiplet_state_req {
 	unsigned long	gsh_cch_state[16];
 };
 
+/*
+ * Structure used to fetch exception detail for CBs that terminate with
+ * CBS_EXCEPTION
+ */
+struct control_block_extended_exc_detail {
+	unsigned long	cb;
+	int		opc;
+	int		ecause;
+	int		exopc;
+	long		exceptdet0;
+	int		exceptdet1;
+	int		cbrstate;
+	int		cbrexecstatus;
+};
+
 #define GRU_DUMP_MAGIC	0x3474ab6c
 struct gru_dump_context_header {
 	unsigned int	magic;

