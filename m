Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab0IXUSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:18:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932Ab0IXUSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:18:08 -0400
Date: Fri, 24 Sep 2010 16:17:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFT PATCH] amiga, atari floppy: Use one request queue per disk
Message-ID: <20100924201756.GB7145@redhat.com>
References: <1285271646-2768-1-git-send-email-vgoyal@redhat.com>
 <4C9CEFD6.3000106@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9CEFD6.3000106@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 08:37:10PM +0200, Jens Axboe wrote:
> On 2010-09-23 21:54, Vivek Goyal wrote:
> > Hi,
> > 
> > We seem to have deprecated the notion of sharing request queue across gendisks. Now we need to instanciate one request queue per disk.
> > 
> > There see to be still some drivers sharing request queue across disks. Arch
> > specific floppy drivers like amiga and atari are doing so.
> > 
> > These are two patches which should fix the issue. But these patches are
> > completely untested. Not even compilte tested. Don't have hardware to test
> > them. 
> > 
> > Would be great if somebody who has the hardware can lend a hand here to
> > see if these patches work.
> 
> I have (tentatively) added both patches to for-2.6.37/drivers. I used the
> latter version of 2/2.

Thanks Jens.

Finally I could setup and do cross compile for m68k. amiga floppy driver
fails to compile. Please find attached the fix.

Thanks
Vivek

o Compile fixes for amiga floppy driver.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/block/amiflop.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6-block/drivers/block/amiflop.c
===================================================================
--- linux-2.6-block.orig/drivers/block/amiflop.c	2010-09-24 16:12:19.000000000 -0400
+++ linux-2.6-block/drivers/block/amiflop.c	2010-09-24 16:13:38.000000000 -0400
@@ -1347,12 +1347,12 @@ static struct request *set_next_request(
 	if (fdc_queue == FD_MAX_UNITS)
 		fdc_queue = 0;
 
-	for(cnt = FD_MAX_UNITS; cnt > 0, cnt--) {
+	for(cnt = FD_MAX_UNITS; cnt > 0; cnt--) {
 
 		if (unit[fdc_queue].type->code == FD_NODRIVE) {
 			if (++fdc_queue == FD_MAX_UNITS)
 				fdc_queue = 0;
-			cotinue;
+			continue;
 		}
 
 		q = unit[fdc_queue].gendisk->queue;
@@ -1827,7 +1827,6 @@ static int __init amiga_floppy_probe(str
 	return 0;
 
 out_probe:
-out_queue:
 	free_irq(IRQ_AMIGA_CIAA_TB, NULL);
 out_irq2:
 	free_irq(IRQ_AMIGA_DSKBLK, NULL);
