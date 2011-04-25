Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab1DYUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:25:29 -0400
Received: from 1wt.eu ([62.212.114.60]:34394 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366Ab1DYUZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:15 -0400
Message-Id: <20110425200236.253156945@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamalesh babulal <kamalesh@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 075/173] powerpc/pseries: Add hcall to read 4 ptes at a time in real mode
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit f90ece28c1f5b3ec13fe481406857fe92f4bc7d1 upstream.

This adds plpar_pte_read_4_raw() which can be used read 4 PTEs from
PHYP at a time, while in real mode.

It also creates a new hcall9 which can be used in real mode.  It's the
same as plpar_hcall9 but minus the tracing hcall statistics which may
require variables outside the RMO.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamalesh babulal <kamalesh@linux.vnet.ibm.com>
Cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/include/asm/hvcall.h               |    1 
 arch/powerpc/platforms/pseries/hvCall.S         |   38 ++++++++++++++++++++++++
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   18 +++++++++++
 3 files changed, 57 insertions(+)

--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -268,6 +268,7 @@ long plpar_hcall_raw(unsigned long opcod
  */
 #define PLPAR_HCALL9_BUFSIZE 9
 long plpar_hcall9(unsigned long opcode, unsigned long *retbuf, ...);
+long plpar_hcall9_raw(unsigned long opcode, unsigned long *retbuf, ...);
 
 /* For hcall instrumentation.  One structure per-hcall, per-CPU */
 struct hcall_stats {
--- a/arch/powerpc/platforms/pseries/hvCall.S
+++ b/arch/powerpc/platforms/pseries/hvCall.S
@@ -202,3 +202,41 @@ _GLOBAL(plpar_hcall9)
 	mtcrf	0xff,r0
 
 	blr				/* return r3 = status */
+
+/* See plpar_hcall_raw to see why this is needed */
+_GLOBAL(plpar_hcall9_raw)
+	HMT_MEDIUM
+
+	mfcr	r0
+	stw	r0,8(r1)
+
+	std     r4,STK_PARM(r4)(r1)     /* Save ret buffer */
+
+	mr	r4,r5
+	mr	r5,r6
+	mr	r6,r7
+	mr	r7,r8
+	mr	r8,r9
+	mr	r9,r10
+	ld	r10,STK_PARM(r11)(r1)	 /* put arg7 in R10 */
+	ld	r11,STK_PARM(r12)(r1)	 /* put arg8 in R11 */
+	ld	r12,STK_PARM(r13)(r1)    /* put arg9 in R12 */
+
+	HVSC				/* invoke the hypervisor */
+
+	mr	r0,r12
+	ld	r12,STK_PARM(r4)(r1)
+	std	r4,  0(r12)
+	std	r5,  8(r12)
+	std	r6, 16(r12)
+	std	r7, 24(r12)
+	std	r8, 32(r12)
+	std	r9, 40(r12)
+	std	r10,48(r12)
+	std	r11,56(r12)
+	std	r0, 64(r12)
+
+	lwz	r0,8(r1)
+	mtcrf	0xff,r0
+
+	blr				/* return r3 = status */
--- a/arch/powerpc/platforms/pseries/plpar_wrappers.h
+++ b/arch/powerpc/platforms/pseries/plpar_wrappers.h
@@ -169,6 +169,24 @@ static inline long plpar_pte_read_raw(un
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
+	long rc;
+	unsigned long retbuf[PLPAR_HCALL9_BUFSIZE];
+
+	rc = plpar_hcall9_raw(H_READ, retbuf, flags | H_READ_4, ptex);
+
+	memcpy(ptes, retbuf, 8*sizeof(unsigned long));
+
+	return rc;
+}
+
 static inline long plpar_pte_protect(unsigned long flags, unsigned long ptex,
 		unsigned long avpn)
 {


