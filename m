Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab0F2GEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 02:04:49 -0400
Received: from sh.osrg.net ([192.16.179.4]:41286 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab0F2GEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 02:04:47 -0400
Date: Tue, 29 Jun 2010 15:04:29 +0900
To: James.Bottomley@HansenPartnership.com
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       grundler@parisc-linux.org, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] scsi: remove dma_is_consistent usage in 53c700
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1277736958.10879.43.camel@mulgrave.site>
References: <1277651328.4366.7.camel@mulgrave.site>
	<20100628123503Z.fujita.tomonori@lab.ntt.co.jp>
	<1277736958.10879.43.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100629150201C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 29 Jun 2010 15:04:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010 09:55:58 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > > > I think that we can safely remove the above usage:
> > > > 
> > > > - such old systems haven't triger the above checking for long.
> > > > 
> > > > - the above condition is important for systems that can't allocate
> > > >   coherent memory if these systems do DMA. So probably it would be
> > > >   better to have such checking in arch's DMA initialization code
> > > >   instead of a driver.
> > > 
> > > Well, we can't check in the architecture because it's a driver specific
> > > thing ... I suppose making it a rule that dma_get_cache_alignment()
> > > *must* be <= L1_CACHE_BYTES fixes it ... we seem to have no architecture
> > > violating that, so just add it to the documentation, and the check can
> > > go.
> > 
> > Seems that on some architectures (arm and mips at least),
> > dma_get_cache_alignment() could greater than L1_CACHE_BYTES. But they
> > simply return the possible maximum size of cache size like:
> > 
> > static inline int dma_get_cache_alignment(void)
> > {
> > 	/* XXX Largest on any MIPS */
> > 	return 128;
> > }
> > 
> > So practically, we should be safe. I guess that we can simply convert
> > them to return L1_CACHE_BYTES.
> 
> As long as that's architecturally true, yes.   I mean I can't imagine
> any architecture that had a dma alignment requirement that was greater
> than its L1 cache width ... but I've been surprised be for making
> "Obviously this can't happen ..." type statements where MIPS is
> concerned.

How about using ARCH_KMALLOC_MINALIGN instead of L1_CACHE_BYTES?

In the previous merge window, we made sure that all the architectures
defines the minimum alignment and width of DMA properly (and the fully
coherent architectures don't define ARCH_KMALLOC_MINALIGN).

dma_get_cache_alignment should be equal to ARCH_KMALLOC_MINALIGN if an
architecture defines ARCH_KMALLOC_MINALIGN (probably,
dma_get_cache_alignment() can be implemented in the common place with
ARCH_KMALLOC_MINALIGN. It would be better to rename
ARCH_KMALLOC_MINALIGN to something like ARCH_DMA_MINALIGN).

It might be better to place DMA_ALIGN(x) in the common place. Seems
that some drivers wrongly use L1_CACHE_ALIGN() to get the dma
alignment. Well, using cache alignment magic in drivers isn't a good
idea though...

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] 53c700: remove dma_is_consistent usage in 53c700

ARCH_KMALLOC_MINALIGN returns the minimum alignment and width of DMA
on architectures that define ARCH_KMALLOC_MINALIGN (if it's not
defined, architectures are fully coherent).

So we can use ARCH_KMALLOC_MINALIGN instead of L1_CACHE_BYTES and
safely remove the alignment checking.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/53c700.c |    1 -
 drivers/scsi/53c700.h |   17 ++++++++++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 80dc3ac..f5fd923 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -311,7 +311,6 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	hostdata->status = memory + STATUS_OFFSET;
 	/* all of these offsets are L1_CACHE_BYTES separated.  It is fatal
 	 * if this isn't sufficient separation to avoid dma flushing issues */
-	BUG_ON(!dma_is_consistent(hostdata->dev, pScript) && L1_CACHE_BYTES < dma_get_cache_alignment());
 	hostdata->slots = (struct NCR_700_command_slot *)(memory + SLOTS_OFFSET);
 	hostdata->dev = dev;
 
diff --git a/drivers/scsi/53c700.h b/drivers/scsi/53c700.h
index e06bdfe..469552b 100644
--- a/drivers/scsi/53c700.h
+++ b/drivers/scsi/53c700.h
@@ -222,16 +222,23 @@ struct NCR_700_Host_Parameters {
 	 * memory.  All the msgin, msgout and status are allocated in
 	 * this memory too (at separate cache lines).  TOTAL_MEM_SIZE
 	 * represents the total size of this area */
+
+#ifdef ARCH_KMALLOC_MINALIGN
+#define DMA_ALIGN(x) ALIGN(x, ARCH_KMALLOC_MINALIGN)
+#else
+#define DMA_ALIGN(x) ALIGN(x, 1)
+#endif
+
 #define	MSG_ARRAY_SIZE	8
-#define	MSGOUT_OFFSET	(L1_CACHE_ALIGN(sizeof(SCRIPT)))
+#define	MSGOUT_OFFSET	(DMA_ALIGN(sizeof(SCRIPT)))
 	__u8	*msgout;
-#define MSGIN_OFFSET	(MSGOUT_OFFSET + L1_CACHE_ALIGN(MSG_ARRAY_SIZE))
+#define MSGIN_OFFSET	(MSGOUT_OFFSET + DMA_ALIGN(MSG_ARRAY_SIZE))
 	__u8	*msgin;
-#define STATUS_OFFSET	(MSGIN_OFFSET + L1_CACHE_ALIGN(MSG_ARRAY_SIZE))
+#define STATUS_OFFSET	(MSGIN_OFFSET + DMA_ALIGN(MSG_ARRAY_SIZE))
 	__u8	*status;
-#define SLOTS_OFFSET	(STATUS_OFFSET + L1_CACHE_ALIGN(MSG_ARRAY_SIZE))
+#define SLOTS_OFFSET	(STATUS_OFFSET + DMA_ALIGN(MSG_ARRAY_SIZE))
 	struct NCR_700_command_slot	*slots;
-#define	TOTAL_MEM_SIZE	(SLOTS_OFFSET + L1_CACHE_ALIGN(sizeof(struct NCR_700_command_slot) * NCR_700_COMMAND_SLOTS_PER_HOST))
+#define	TOTAL_MEM_SIZE	(SLOTS_OFFSET + DMA_ALIGN(sizeof(struct NCR_700_command_slot) * NCR_700_COMMAND_SLOTS_PER_HOST))
 	int	saved_slot_position;
 	int	command_slot_count; /* protected by state lock */
 	__u8	tag_negotiated;
-- 
1.6.5

