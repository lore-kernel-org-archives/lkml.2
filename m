Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147Ab1FWSB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:01:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:34917 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933543Ab1FWRhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 158/247] powerpc/pseries: Add hcall to read 4 ptes at a time in real mode
Date: Thu, 23 Jun 2011 13:33:46 -0400
Message-Id: <1308850515-15242-99-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Neuling <mikey@neuling.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f90ece28c1f5b3ec13fe481406857fe92f4bc7d1 upstream.

This adds plpar_pte_read_4_raw() which can be used read 4 PTEs from
PHYP at a time, while in real mode.

It also creates a new hcall9 which can be used in real mode.  It's the
same as plpar_hcall9 but minus the tracing hcall statistics which may
require variables outside the RMO.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/include/asm/hvcall.h               |    1 +
 arch/powerpc/platforms/pseries/hvCall.S         |   38 +++++++++++++++++++++++
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   18 +++++++++++
 3 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index f027581..f0d067c 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -281,6 +281,7 @@ long plpar_hcall_raw(unsigned long opcode, unsigned long *retbuf, ...);
  */
 #define PLPAR_HCALL9_BUFSIZE 9
 long plpar_hcall9(unsigned long opcode, unsigned long *retbuf, ...);
+long plpar_hcall9_raw(unsigned long opcode, unsigned long *retbuf, ...);
 
 /* For hcall instrumentation.  One structure per-hcall, per-CPU */
 struct hcall_stats {
diff --git a/arch/powerpc/platforms/pseries/hvCall.S b/arch/powerpc/platforms/pseries/hvCall.S
index 383a5d0..48d2057 100644
--- a/arch/powerpc/platforms/pseries/hvCall.S
+++ b/arch/powerpc/platforms/pseries/hvCall.S
@@ -228,3 +228,41 @@ _GLOBAL(plpar_hcall9)
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
diff --git a/arch/powerpc/platforms/pseries/plpar_wrappers.h b/arch/powerpc/platforms/pseries/plpar_wrappers.h
index 6c4fd2c..d980111 100644
--- a/arch/powerpc/platforms/pseries/plpar_wrappers.h
+++ b/arch/powerpc/platforms/pseries/plpar_wrappers.h
@@ -191,6 +191,24 @@ static inline long plpar_pte_read_raw(unsigned long flags, unsigned long ptex,
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
-- 
1.7.4.4

