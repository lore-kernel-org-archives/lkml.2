Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab1KKQNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:13:37 -0500
Received: from senmx12-mx.siemens-enterprise.com ([62.134.46.10]:57777 "EHLO
	senmx12-mx.siemens-enterprise.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757997Ab1KKQNg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:13:36 -0500
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Nov 2011 11:13:35 EST
From: "Kokoris, Ioannis" <ioannis.kokoris@siemens-enterprise.com>
To: "timur@freescale.com" <timur@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Date: Fri, 11 Nov 2011 17:05:11 +0100
Subject: [PATCH] P1021: set IReady in QE Microcode Upload 
Thread-Topic: [PATCH] P1021: set IReady in QE Microcode Upload 
Thread-Index: Acygi7EZZWKJ/MoNQ2quPipLxtyV5Q==
Message-ID: <026483A88B848047A08C3F03E20822D0267B1F4A55@MCHP058A.global-ad.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

QE Microcode Initialization using qe_upload_microcode() does not work on P1021 if the IRAM-Ready register is not set after the microcode upload. This patch adds a definition for the "I-RAM Ready" register and sets it uppon microcode upload completion.


Signed-off-by: Ioannis Kokkoris <ioannis.kokoris@siemens-enterprise.com>


diff -Nru a/arch/powerpc/include/asm/immap_qe.h b/arch/powerpc/include/asm/immap_qe.h
--- a/arch/powerpc/include/asm/immap_qe.h	2011-11-11 17:47:45.000000000 +0200
+++ b/arch/powerpc/include/asm/immap_qe.h	2011-11-11 17:49:31.000000000 +0200
@@ -26,7 +26,9 @@
 struct qe_iram {
 	__be32	iadd;		/* I-RAM Address Register */
 	__be32	idata;		/* I-RAM Data Register */
-	u8	res0[0x78];
+	u8	res0[0x04];
+	__be32	iready;		/* I-RAM Ready Register */
+	u8	res1[0x70];
 } __attribute__ ((packed));
 
 /* QE Interrupt Controller */
diff -Nru a/arch/powerpc/include/asm/qe.h b/arch/powerpc/include/asm/qe.h
--- a/arch/powerpc/include/asm/qe.h	2011-11-11 17:47:57.000000000 +0200
+++ b/arch/powerpc/include/asm/qe.h	2011-11-11 17:49:42.000000000 +0200
@@ -499,6 +499,7 @@
 /* I-RAM */
 #define QE_IRAM_IADD_AIE	0x80000000	/* Auto Increment Enable */
 #define QE_IRAM_IADD_BADDR	0x00080000	/* Base Address */
+#define QE_IRAM_READY           0x80000000      /* Ready */
 
 /* UPC */
 #define UPGCR_PROTOCOL	0x80000000	/* protocol ul2 or pl2 */
diff -Nru a/arch/powerpc/sysdev/qe_lib/qe.c b/arch/powerpc/sysdev/qe_lib/qe.c
--- a/arch/powerpc/sysdev/qe_lib/qe.c	2011-11-11 17:48:44.000000000 +0200
+++ b/arch/powerpc/sysdev/qe_lib/qe.c	2011-11-11 17:49:59.000000000 +0200
@@ -377,6 +377,9 @@
 
 	for (i = 0; i < be32_to_cpu(ucode->count); i++)
 		out_be32(&qe_immr->iram.idata, be32_to_cpu(code[i]));
+	
+	/* Set I-RAM Ready Register */	
+	out_be32(&qe_immr->iram.iready, be32_to_cpu(QE_IRAM_READY));
 }
 
 /*
--

Best Regards,
Ioannis

