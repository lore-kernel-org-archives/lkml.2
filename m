Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab0FBCbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 22:31:11 -0400
Received: from sh.osrg.net ([192.16.179.4]:35584 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab0FBCbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 22:31:09 -0400
Date: Wed, 2 Jun 2010 11:30:55 +0900
To: jaxboe@fusionio.com
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH -mm 0/3] remove useless ISA_DMA_THRESHOLD
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100601182452.GA3564@kernel.dk>
References: <1275289144-28782-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20100601182452.GA3564@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100602113022I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 02 Jun 2010 11:30:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 20:24:52 +0200
Jens Axboe <jaxboe@fusionio.com> wrote:

> On Mon, May 31 2010, FUJITA Tomonori wrote:
> > This patchset removes useless ISA_DMA_THRESHOLD:
> > 
> > - ISA_DMA_THRESHOLD is irrelevant to the majority of architectures but
> >   they have to define it.
> > 
> > - ISA_DMA_THRESHOLD definition is inconsistent on architectures; ISA
> >   DMA addressing restriction, DMA addressing restriction or something
> >   else.
> > 
> > - Everyone (except for SCSI) uses dma_mask instead of ancient
> >   ISA_DMA_THRESHOLD.
> > 
> > Only SCSI uses ISA_DMA_THRESHOLD for ancient drivers with non-zero
> > unchecked_isa_dma. We can safely remove ISA_DMA_THRESHOLD usage in
> > SCSI. So we can clean up ISA_DMA_THRESHOLD on the whole tree.
> 
> Looks good. James, it's probably easier if I just carry this patch set.

Thanks,

Any tree works for me, I thought about -mm though.

Can you replace [1/3] with the following?

I fixed the subject and the body, s/aha1532/aha1542/;

Somehow I forgot to remove unused BAD_SG_DMA().

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/3] aha1542: remove ISA_DMA_THRESHOLD usage

We can safely remove ISA_DMA_THRESHOLD usage in aha1542. aha1542 uses
ISA_DMA_THRESHOLD to see if:

- the buffers in scatter/list are below 16MB.
- scsi_host is below 16MB.

Both checkings were added in the ancient times but aren't necessary
nowadays since we properly bounce the buffers and allocate scsi_host
below 16MB with non-zero unchecked_isa_dma.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/aha1542.c |   25 -------------------------
 1 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 2a8cf13..4f785f2 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -52,22 +52,6 @@
 #define SCSI_BUF_PA(address)	isa_virt_to_bus(address)
 #define SCSI_SG_PA(sgent)	(isa_page_to_bus(sg_page((sgent))) + (sgent)->offset)
 
-static void BAD_SG_DMA(Scsi_Cmnd * SCpnt,
-		       struct scatterlist *sgp,
-		       int nseg,
-		       int badseg)
-{
-	printk(KERN_CRIT "sgpnt[%d:%d] page %p/0x%llx length %u\n",
-	       badseg, nseg, sg_virt(sgp),
-	       (unsigned long long)SCSI_SG_PA(sgp),
-	       sgp->length);
-
-	/*
-	 * Not safe to continue.
-	 */
-	panic("Buffer at physical address > 16Mb used for aha1542");
-}
-
 #include<linux/stat.h>
 
 #ifdef DEBUG
@@ -691,8 +675,6 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 		}
 		scsi_for_each_sg(SCpnt, sg, sg_count, i) {
 			any2scsi(cptr[i].dataptr, SCSI_SG_PA(sg));
-			if (SCSI_SG_PA(sg) + sg->length - 1 > ISA_DMA_THRESHOLD)
-				BAD_SG_DMA(SCpnt, scsi_sglist(SCpnt), sg_count, i);
 			any2scsi(cptr[i].datalen, sg->length);
 		};
 		any2scsi(ccb[mbo].datalen, sg_count * sizeof(struct chain));
@@ -1133,16 +1115,9 @@ static int __init aha1542_detect(struct scsi_host_template * tpnt)
 				release_region(bases[indx], 4);
 				continue;
 			}
-			/* For now we do this - until kmalloc is more intelligent
-			   we are resigned to stupid hacks like this */
-			if (SCSI_BUF_PA(shpnt) >= ISA_DMA_THRESHOLD) {
-				printk(KERN_ERR "Invalid address for shpnt with 1542.\n");
-				goto unregister;
-			}
 			if (!aha1542_test_port(bases[indx], shpnt))
 				goto unregister;
 
-
 			base_io = bases[indx];
 
 			/* Set the Bus on/off-times as not to ruin floppy performance */
-- 
1.6.5

