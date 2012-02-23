Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab2BWUaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:30:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2BWUaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:30:12 -0500
Date: Thu, 23 Feb 2012 12:30:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
        Chris Wright <chrisw@sous-sol.org>, Daniel Rahn <drahn@suse.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jack Steiner <steiner@sgi.com>, Tony Ernst <tee@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, pci: Increase the number of iommus supported
 to be MAX_IO_APICS v2
Message-Id: <20120223123011.cfe4ae35.akpm@linux-foundation.org>
In-Reply-To: <20120223004931.121722197@gulag1.americas.sgi.com>
References: <20120223004930.817124691@gulag1.americas.sgi.com>
	<20120223004931.121722197@gulag1.americas.sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Feb 2012 18:49:32 -0600
Mike Travis <travis@sgi.com> wrote:

> The number of IOMMUs supported should be the same as the number of IO APICS.
> This limit comes into play when the IOMMUs are identity mapped, thus the
> number of possible IOMMUs in the "static identity" (si) domain should be
> this same number.
> 
> Version 2: Fix compile error on ia64 (it uses the DMAR logic but does not
> define MAX_IO_APICS.)  Check to insure that iommu_bmp does not overflow.

Here's your v2 delta:

--- a/drivers/iommu/intel-iommu.c~x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics-v2
+++ a/drivers/iommu/intel-iommu.c
@@ -354,10 +354,17 @@ static int hw_pass_through = 1;
 /* si_domain contains mulitple devices */
 #define DOMAIN_FLAG_STATIC_IDENTITY	(1 << 2)
 
+/* define the limit of IOMMUs supported in each domain */
+#ifdef	CONFIG_X86
+#define	IOMMU_UNITS_SUPPORTED	MAX_IO_APICS
+#else
+#define	IOMMU_UNITS_SUPPORTED	64
+#endif
+
 struct dmar_domain {
 	int	id;			/* domain id */
 	int	nid;			/* node id */
-	DECLARE_BITMAP(iommu_bmp, MAX_IO_APICS);
+	DECLARE_BITMAP(iommu_bmp, IOMMU_UNITS_SUPPORTED);
 					/* bitmap of iommus this domain uses*/
 
 	struct list_head devices; 	/* all devices' list */
@@ -2401,12 +2408,17 @@ static int __init init_dmars(void)
 	 * endfor
 	 */
 	for_each_drhd_unit(drhd) {
-		g_num_of_iommus++;
 		/*
 		 * lock not needed as this is only incremented in the single
 		 * threaded kernel __init code path all other access are read
 		 * only
 		 */
+		if (g_num_of_iommus < IOMMU_UNITS_SUPPORTED)
+			g_num_of_iommus++;
+		else
+			printk_once(KERN_ERR,
+			  "MAX number (%d) of IOMMUs supported exceeded\n",
+			  IOMMU_UNITS_SUPPORTED);
 	}
 
 	g_iommus = kcalloc(g_num_of_iommus, sizeof(struct intel_iommu *),


The printk_once() is wrong, isn't it?  There should not be a comma.

Also we can tweak the code flow and the message to avoid dorky
80-column games:

--- a/drivers/iommu/intel-iommu.c~x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics-v2-fix
+++ a/drivers/iommu/intel-iommu.c
@@ -2413,11 +2413,11 @@ static int __init init_dmars(void)
 		 * threaded kernel __init code path all other access are read
 		 * only
 		 */
-		if (g_num_of_iommus < IOMMU_UNITS_SUPPORTED)
+		if (g_num_of_iommus < IOMMU_UNITS_SUPPORTED) {
 			g_num_of_iommus++;
-		else
-			printk_once(KERN_ERR,
-			  "MAX number (%d) of IOMMUs supported exceeded\n",
+			continue;
+		}
+		printk_once(KERN_ERR "intel-iommu: exceeded %d IOMMUs\n",
 			  IOMMU_UNITS_SUPPORTED);
 	}
 
_

