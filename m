Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967066Ab0GSVma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:42:30 -0400
Received: from relay2.sgi.com ([192.48.179.30]:37515 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966854Ab0GSViy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:38:54 -0400
Message-Id: <20100719213852.592123191@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:32:27 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 09/25] GRU - add software reserved bits to cbr definition
References: <20100719213651.362618144@sgi.com>
Content-Disposition: inline; filename=uv_gru_software_reserved
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

The GRU hardware has reserved a few bits for software use.
Add these "software reserved" fields to the structure definitions.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gru_instructions.h |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

Index: linux/drivers/misc/sgi-gru/gru_instructions.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru_instructions.h	2010-06-09 08:11:38.907960603 -0500
+++ linux/drivers/misc/sgi-gru/gru_instructions.h	2010-06-09 08:11:43.303963161 -0500
@@ -112,7 +112,8 @@ struct gru_instruction_bits {
     unsigned char		reserved3: 1;
     unsigned char		tlb_fault_color: 1;
     /* DW 1 */
-    unsigned long		idef4;		/* 42 bits: TRi1, BufSize */
+    unsigned int		idef4;		/* 32 bits: TRi1, BufSize */
+    unsigned int		sw_reserved;
     /* DW 2-6 */
     unsigned long		idef1;		/* BAddr0 */
     unsigned long		idef5;		/* Nelem */
@@ -136,7 +137,13 @@ struct gru_instruction {
 		unsigned int	tri0;
 	};
     };
-    unsigned long		tri1_bufsize;		/* DW 1 */
+    union {
+	unsigned long		tri1_bufsize_64;	/* DW 1 */
+	struct {
+    		unsigned int	tri1_bufsize_32;
+		unsigned int	sw_reserved;
+	};
+    };
     unsigned long		baddr0;			/* DW 2 */
     unsigned long		nelem;			/* DW 3 */
     unsigned long		op1_stride;		/* DW 4 */
@@ -411,7 +418,7 @@ static inline void gru_ivload(void *cb,
 
 	ins->baddr0 = (long)mem_addr;
 	ins->nelem = nelem;
-	ins->tri1_bufsize = tri1;
+	ins->tri1_bufsize_64 = tri1;
 	gru_start_instruction(ins, __opdword(OP_IVLOAD, 0, xtype, IAA_RAM, 0,
 					tri0, CB_IMA(hints)));
 }
@@ -424,7 +431,7 @@ static inline void gru_ivstore(void *cb,
 
 	ins->baddr0 = (long)mem_addr;
 	ins->nelem = nelem;
-	ins->tri1_bufsize = tri1;
+	ins->tri1_bufsize_64 = tri1;
 	gru_start_instruction(ins, __opdword(OP_IVSTORE, 0, xtype, IAA_RAM, 0,
 					tri0, CB_IMA(hints)));
 }
@@ -452,7 +459,7 @@ static inline void gru_ivset(void *cb, u
 	ins->baddr0 = (long)mem_addr;
 	ins->op2_value_baddr1 = value;
 	ins->nelem = nelem;
-	ins->tri1_bufsize = tri1;
+	ins->tri1_bufsize_64 = tri1;
 	gru_start_instruction(ins, __opdword(OP_IVSET, 0, xtype, IAA_RAM, 0,
 					0, CB_IMA(hints)));
 }
@@ -488,7 +495,7 @@ static inline void gru_bcopy(void *cb, c
 	ins->baddr0 = (long)src;
 	ins->op2_value_baddr1 = (long)dest;
 	ins->nelem = nelem;
-	ins->tri1_bufsize = bufsize;
+	ins->tri1_bufsize_64 = bufsize;
 	gru_start_instruction(ins, __opdword(OP_BCOPY, 0, xtype, IAA_RAM,
 					IAA_RAM, tri0, CB_IMA(hints)));
 }

