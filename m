Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab2IQA6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:58:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33915 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754642Ab2IQAvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:25 -0400
Message-Id: <20120917003631.781222120@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 040/135] powerpc/xics: Harden xics hypervisor backend
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 3ce21cdfe93efffa4ffba9cf3ca2576d3d60d6dc upstream.

During kdump stress testing I sometimes see the kdump kernel panic
with:

  Interrupt 0x306 (real) is invalid, disabling it.
  Kernel panic - not syncing: bad return code EOI - rc = -4, value=ff000306

Instead of panicing print the error message, dump the stack the first
time it happens and continue on. Add some more information to the
debug messages as well.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/sysdev/xics/icp-hv.c |   38 ++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/sysdev/xics/icp-hv.c b/arch/powerpc/sysdev/xics/icp-hv.c
index 9518d36..784b3fc 100644
--- a/arch/powerpc/sysdev/xics/icp-hv.c
+++ b/arch/powerpc/sysdev/xics/icp-hv.c
@@ -27,33 +27,49 @@ static inline unsigned int icp_hv_get_xirr(unsigned char cppr)
 {
 	unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
 	long rc;
+	unsigned int ret = XICS_IRQ_SPURIOUS;
 
 	rc = plpar_hcall(H_XIRR, retbuf, cppr);
-	if (rc != H_SUCCESS)
-		panic(" bad return code xirr - rc = %lx\n", rc);
-	return (unsigned int)retbuf[0];
+	if (rc == H_SUCCESS) {
+		ret = (unsigned int)retbuf[0];
+	} else {
+		pr_err("%s: bad return code xirr cppr=0x%x returned %ld\n",
+			__func__, cppr, rc);
+		WARN_ON_ONCE(1);
+	}
+
+	return ret;
 }
 
 static inline void icp_hv_set_xirr(unsigned int value)
 {
 	long rc = plpar_hcall_norets(H_EOI, value);
-	if (rc != H_SUCCESS)
-		panic("bad return code EOI - rc = %ld, value=%x\n", rc, value);
+	if (rc != H_SUCCESS) {
+		pr_err("%s: bad return code eoi xirr=0x%x returned %ld\n",
+			__func__, value, rc);
+		WARN_ON_ONCE(1);
+	}
 }
 
 static inline void icp_hv_set_cppr(u8 value)
 {
 	long rc = plpar_hcall_norets(H_CPPR, value);
-	if (rc != H_SUCCESS)
-		panic("bad return code cppr - rc = %lx\n", rc);
+	if (rc != H_SUCCESS) {
+		pr_err("%s: bad return code cppr cppr=0x%x returned %ld\n",
+			__func__, value, rc);
+		WARN_ON_ONCE(1);
+	}
 }
 
 static inline void icp_hv_set_qirr(int n_cpu , u8 value)
 {
-	long rc = plpar_hcall_norets(H_IPI, get_hard_smp_processor_id(n_cpu),
-				     value);
-	if (rc != H_SUCCESS)
-		panic("bad return code qirr - rc = %lx\n", rc);
+	int hw_cpu = get_hard_smp_processor_id(n_cpu);
+	long rc = plpar_hcall_norets(H_IPI, hw_cpu, value);
+	if (rc != H_SUCCESS) {
+		pr_err("%s: bad return code qirr cpu=%d hw_cpu=%d mfrr=0x%x "
+			"returned %ld\n", __func__, n_cpu, hw_cpu, value, rc);
+		WARN_ON_ONCE(1);
+	}
 }
 
 static void icp_hv_eoi(struct irq_data *d)


