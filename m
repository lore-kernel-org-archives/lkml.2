Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1APP6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 10:58:37 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36273 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1APP6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 10:58:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MTii7/AH/LC7ur3qG3mP5e1MAzhUWP1bmYJlC2eTh+HVUYOUluss3gGMiaB1n8DbJA
         /aTGXb/WPUd2jbBxFXrnI43GfUvvc5qu1buTrWP7nXSITWjZh3gPZ+kjmzvfScCUQzOQ
         SbjXavf0q5M7UBnoX8k4EHSNrR3X5ishcqLag=
Subject: Re: [PATCH 1/1] mtd: nand: add check for out of page read
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jason Liu <liu.h.jason@gmail.com>
Cc: Jason Liu <r64343@freescale.com>, David.Woodhouse@intel.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikSVLNaFOT55piRosOCyJ9uXQ85QD0u3w75UimU@mail.gmail.com>
References: <1290156045-11719-1-git-send-email-r64343@freescale.com>
	 <1292340409.2538.40.camel@localhost>
	 <AANLkTi=zB7UBjkvGYv_wdwZpH1Ghatn6eye1z5616h4X@mail.gmail.com>
	 <1292777645.13362.3.camel@koala>
	 <AANLkTikSVLNaFOT55piRosOCyJ9uXQ85QD0u3w75UimU@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Jan 2011 17:58:30 +0200
Message-ID: <1295193510.2470.2.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 14:06 +0800, Jason Liu wrote:
> Hi, Artem,
> 
> 2010/12/20 Artem Bityutskiy <dedekind1@gmail.com>:
> > On Wed, 2010-12-15 at 09:55 +0800, Jason Liu wrote:
> >> >        /* Do not allow reads past end of device */
> >> >        if (unlikely(from >= mtd->size ||
> >> >                     ops->ooboffs + readlen > ((mtd->size >> chip->page_shift) -
> >> >                                        (from >> chip->page_shift)) * len)) {
> >> >                DEBUG(MTD_DEBUG_LEVEL0, "%s: Attempt read beyond end "
> >> >                                        "of device\n", __func__);
> >> >                return -EINVAL;
> >> >        }
> >>
> >> Here the mtd->size in nand_base.c should be the NAND flash chip size,
> >
> > I think this is partition size as well.
> 
> I think you are wrong. This should be the NAND flash chip size not the
> partition size.

Yes, thanks for pointing this.

The patch below fixes the issue you found. I've also pushed this patch
to my l2-mtd-2.6 tree. If you can test it, please, do, but it fixes the
issue when nandsim is used.


>From 2b6dc448005afdfe48ac2096d24694b8ea3ac88b Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Sun, 16 Jan 2011 17:50:54 +0200
Subject: [PATCH] mtd: mtdpart: disallow reading OOB past the end of the partition

This patch fixes the mtdpart bug which allows users reading OOB past the
end of the partition. This happens because 'part_read_oob()' allows reading
multiple OOB areas in one go, and mtdparts does not validate the OOB
length in the request.

Although there is such check in 'nand_do_read_oob()' in nand_base.c, but
it checks that we do not read past the flash chip, not the partition,
because in nand_base.c we work with the whole chip (e.g., mtd->size
in nand_base.c is the size of the whole chip). So this check cannot
be done correctly in nand_base.c and should be instead done in mtdparts.c.

This problem was reported by Jason Liu <r64343@freescale.com> and reproduced
with nandsim:

$ modprobe nandsim first_id_byte=0x20 second_id_byte=0xaa third_id_byte=0x00 \
                   fourth_id_byte=0x15 parts=0x400,0x400
$ modprobe nandsim mtd_oobtest.ko dev=0
$ dmesg
= snip =
mtd_oobtest: attempting to read past end of device
mtd_oobtest: an error is expected...
mtd_oobtest: error: read past end of device
= snip =
mtd_oobtest: finished with 2 errors

Reported-by: Jason Liu <liu.h.jason@gmail.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 drivers/mtd/mtdpart.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 79e3689..d2b932f 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -120,8 +120,25 @@ static int part_read_oob(struct mtd_info *mtd, loff_t from,
 		return -EINVAL;
 	if (ops->datbuf && from + ops->len > mtd->size)
 		return -EINVAL;
-	res = part->master->read_oob(part->master, from + part->offset, ops);
 
+	/*
+	 * If OOB is also requested, make sure that we do not read past the end
+	 * of this partition.
+	 */
+	if (ops->oobbuf) {
+		size_t len, pages;
+
+		if (ops->mode == MTD_OOB_AUTO)
+			len = mtd->oobavail;
+		else
+			len = mtd->oobsize;
+		pages = mtd_div_by_ws(mtd->size, mtd);
+		pages -= mtd_div_by_ws(from, mtd);
+		if (ops->ooboffs + ops->ooblen > pages * len)
+			return -EINVAL;
+	}
+
+	res = part->master->read_oob(part->master, from + part->offset, ops);
 	if (unlikely(res)) {
 		if (res == -EUCLEAN)
 			mtd->ecc_stats.corrected++;
-- 
1.7.3.4

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

