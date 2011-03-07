Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab1CGLux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:50:53 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:34024 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab1CGLuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:50:52 -0500
Date: Mon, 7 Mar 2011 17:20:46 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, anton@samba.org,
        benh@kernel.crashing.org
Subject: [PATCH 4/7] powerpc/pseries: Add hcall to read 4 ptes at a time in
	real mode
Message-ID: <20110307115046.GF8194@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    powerpc/pseries: Add hcall to read 4 ptes at a time in real mode

    Commit: f90ece28c1f5b3ec13fe481406857fe92f4bc7d1 upstream

    This adds plpar_pte_read_4_raw() which can be used read 4 PTEs from
    PHYP at a time, while in real mode.

    It also creates a new hcall9 which can be used in real mode.  It's the
    same as plpar_hcall9 but minus the tracing hcall statistics which may
    require variables outside the RMO.

    Signed-off-by: Michael Neuling <mikey@neuling.org>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Kamalesh babulal <kamalesh@linux.vnet.ibm.com>
    cc: Anton Blanchard <anton@samba.org>
---
 arch/powerpc/include/asm/hvcall.h               |    1
 arch/powerpc/platforms/pseries/hvCall.S         |   38 ++++++++++++++++++++++++
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   18 +++++++++++
 3 files changed, 57 insertions(+)

Index: b/arch/powerpc/include/asm/hvcall.h
===================================================================
--- a/arch/powerpc/include/asm/hvcall.h	2011-03-07 00:39:02.479557984 -0800
+++ b/arch/powerpc/include/asm/hvcall.h	2011-03-07 00:39:54.627591230 -0800
@@ -268,6 +268,7 @@
  */
 #define PLPAR_HCALL9_BUFSIZE 9
 long plpar_hcall9(unsigned long opcode, unsigned long *retbuf, ...);
+long plpar_hcall9_raw(unsigned long opcode, unsigned long *retbuf, ...);

 /* For hcall instrumentation.  One structure per-hcall, per-CPU */
 struct hcall_stats {
Index: b/arch/powerpc/platforms/pseries/hvCall.S
===================================================================
--- a/arch/powerpc/platforms/pseries/hvCall.S	2011-03-07 00:39:57.707593225 -0800
+++ b/arch/powerpc/platforms/pseries/hvCall.S	2011-03-07 00:45:13.523789676 -0800
@@ -202,3 +202,41 @@
	mtcrf	0xff,r0

	blr				/* return r3 = status */
+
+/* See plpar_hcall_raw to see why this is needed */
+_GLOBAL(plpar_hcall9_raw)
+        HMT_MEDIUM
+
+        mfcr    r0
+        stw     r0,8(r1)
+
+        std     r4,STK_PARM(r4)(r1)     /* Save ret buffer */
+
+        mr      r4,r5
+        mr      r5,r6
+        mr      r6,r7
+        mr      r7,r8
+        mr      r8,r9
+        mr      r9,r10
+        ld      r10,STK_PARM(r11)(r1)    /* put arg7 in R10 */
+        ld      r11,STK_PARM(r12)(r1)    /* put arg8 in R11 */
+        ld      r12,STK_PARM(r13)(r1)    /* put arg9 in R12 */
+
+        HVSC                            /* invoke the hypervisor */
+
+        mr      r0,r12
+        ld      r12,STK_PARM(r4)(r1)
+        std     r4,  0(r12)
+        std     r5,  8(r12)
+        std     r6, 16(r12)
+        std     r7, 24(r12)
+        std     r8, 32(r12)
+        std     r9, 40(r12)
+        std     r10,48(r12)
+        std     r11,56(r12)
+        std     r0, 64(r12)
+
+        lwz     r0,8(r1)
+        mtcrf   0xff,r0
+
+	blr                             /* return r3 = status */
Index: b/arch/powerpc/platforms/pseries/plpar_wrappers.h
===================================================================
--- a/arch/powerpc/platforms/pseries/plpar_wrappers.h	2011-03-07 00:45:28.363798700 -0800
+++ b/arch/powerpc/platforms/pseries/plpar_wrappers.h	2011-03-07 02:10:59.321850879 -0800
@@ -169,6 +169,24 @@
	return rc;
 }

+/*
+ * plpar_pte_read_4_raw can be called in real mode.
+ * ptes must be 8*sizeof(unsigned long)
+ */
+static inline long plpar_pte_read_4_raw(unsigned long flags, unsigned long ptex,
+					unsigned long *ptes)
+
+{
+       long rc;
+       unsigned long retbuf[PLPAR_HCALL9_BUFSIZE];
+
+       rc = plpar_hcall9_raw(H_READ, retbuf, flags | H_READ_4, ptex);
+
+       memcpy(ptes, retbuf, 8*sizeof(unsigned long));
+
+       return rc;
+}
+
 static inline long plpar_pte_protect(unsigned long flags, unsigned long ptex,
		unsigned long avpn)
 {
