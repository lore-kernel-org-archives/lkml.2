Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882Ab1JEBzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 21:55:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56667 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618Ab1JEBzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 21:55:48 -0400
Date: Tue, 4 Oct 2011 18:57:18 -0700
From: Andrew Morton <akpm00@gmail.com>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Cc: Vinod Koul <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [RFC PATCH 2/2 -mm] RapidIO: TSI721 Add DMA Engine support
Message-Id: <20111004185718.a5806a7e.akpm00@gmail.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E552022D6319@CORPEXCH1.na.ads.idt.com>
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com>
	<1317418715-9666-2-git-send-email-alexandre.bounine@idt.com>
	<20110930151544.31875132.akpm00@gmail.com>
	<0CE8B6BE3C4AD74AB97D9D29BD24E55202291E8D@CORPEXCH1.na.ads.idt.com>
	<20111004144353.18087914.akpm00@gmail.com>
	<0CE8B6BE3C4AD74AB97D9D29BD24E552022D6319@CORPEXCH1.na.ads.idt.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Oct 2011 18:38:09 -0700 "Bounine, Alexandre" <Alexandre.Bounine@idt.com> wrote:

> > No, it can be used all over the place: drivers/net/irda/w83977af_ir.c,
> > drivers/scsi/bnx2fc/bnx2fc_tgt.c,
> > drivers/net/wireless/rt2x00/rt2x00pci.c,
> > drivers/crypto/amcc/crypto4xx_core.c and many nmore.
> 
> In this case I will happily use dma_zalloc_coherent() as soon as
> it is available

geeze, which of us is more lazy?

Here we go...


From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/dma-mapping.h: add dma_zalloc_coherent()

Lots of driver code does a dma_alloc_coherent() and then zeroes out the
memory with a memset.  Make it easy for them.

Cc: Alexandre Bounine <alexandre.bounine@idt.com>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include-linux-dma-mappingh-add-dma_zalloc_coherent
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt   |    7 +++++++
 include/linux/dma-mapping.h |   10 ++++++++++
 2 files changed, 17 insertions(+)

diff -puN include/linux/dma-mapping.h~include-linux-dma-mappingh-add-dma_zalloc_coherent include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~include-linux-dma-mappingh-add-dma_zalloc_coherent
+++ a/include/linux/dma-mapping.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_DMA_MAPPING_H
 #define _LINUX_DMA_MAPPING_H
 
+#include <linux/string.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/dma-attrs.h>
@@ -117,6 +118,15 @@ static inline int dma_set_seg_boundary(s
 		return -EIO;
 }
 
+static inline void *dma_zalloc_coherent(struct device *dev, size_t size,
+					dma_addr_t *dma_handle, gfp_t flag)
+{
+	void *ret = dma_alloc_coherent(dev, size, dma_handle, flag);
+	if (ret)
+		memset(ret, 0, size);
+	return ret;
+}
+
 #ifdef CONFIG_HAS_DMA
 static inline int dma_get_cache_alignment(void)
 {
diff -puN Documentation/DMA-API.txt~include-linux-dma-mappingh-add-dma_zalloc_coherent Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~include-linux-dma-mappingh-add-dma_zalloc_coherent
+++ a/Documentation/DMA-API.txt
@@ -50,6 +50,13 @@ specify the GFP_ flags (see kmalloc) for
 implementation may choose to ignore flags that affect the location of
 the returned memory, like GFP_DMA).
 
+void *
+dma_zalloc_coherent(struct device *dev, size_t size,
+			     dma_addr_t *dma_handle, gfp_t flag)
+
+Wraps dma_alloc_coherent() and also zeroes the returned memory if the
+allocation attempt succeeded.
+
 void
 dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
 			   dma_addr_t dma_handle)
_

