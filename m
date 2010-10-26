Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab0JZC3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:29:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46026 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab0JZC3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:29:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UMxbXQOhHrrT7A0PEAFnvt1MoONfU2hev66US8MiRMnCynH5S0IylBgPDNUeeneFNP
         ue5g5LoQksM6yCIPcnh2vKZbyF7zLbe8SR2jESL4gGfKtMyLMAJEqRp52euaB3E3S+nQ
         Bw5+dAoDKxaKERmiEkLooVjvaohzueIuBXJfU=
Subject: Re: [PATCH 23/29] memstick: jmb38x_ms: use DMA for all TPCs with
 len greater that 8 by default
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <327472.13750.qm@web37607.mail.mud.yahoo.com>
References: <327472.13750.qm@web37607.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 04:29:46 +0200
Message-ID: <1288060186.4024.186.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 09:12 -0700, Alex Dubov wrote:
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 23/29] memstick: jmb38x_ms: use DMA for all TPCs with len greater that 8 by default
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > This is to workaround a wierd
> > hardware bug:
> > 
> > If PIO write is used, and then after it DMA write is used,
> > DMA
> > engine stops doing writes.
> > That condition even persists after device reset.
> > 
> > To be maxumum safe, we do dma to a scratch page
> > and memcpy from/to it.
> > 
> > Besides this change should just improve performance.
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> 
> I have not noticed this one before, and for all I know the driver was
> tested at Jmicron.
> Can you explain the issue a bit more?
Because you didn't test MS standard, or always wrote OOB and param by
seperate TPCs.

You really don't read my mail.

<quote>
***Appendix***

Jmicron hardware bugs (the novel):

#1: FIFO write ready bit in INT status register is stuck to 1.
   It is stuck forever as soon as fifo
   is used for writing even once.
   Therefore if interrupt is shared (and here it is), its easy
   to 'service' the device while it doesn't need any service


#2: Its not possible to stuff the FIFO before TPC transfer.
   One really have to wait for write ready interrupt, even though the
write ready status is stuck.


#3: TPCs with non 4 aligned length woes:
   Facts:

   * non 4 aligned DMA write hangs the system hard, maybe on bus level.

   * PIO read succedes but controller truncates the data stored in the
FIFO to closest 4 byte boundary.
   That is if you read 26 bytes, it will save 24 bytes in the FIFO

   * TPC_P0, TPC_P1 not aligned transfters work just fine despite a
statement in the datasheet
   (only mention of this problem)


#4: As soon as write PIO is used, then later write DMA fails.
   Facts:

   * This is triggered only by PIO write of registers
   (only happens in ms_block.c when it writes param + oob. Thats why
mspro_blk isn't affected)
   Doing short DMA writes is a nice workaround.

   * Doing PIO writes in h_msb_read_page don't cause the problem.
     Therefore the bug causing sequence should be similiar to
h_msb_write_block:

       1. PIO write of param + extra (10 bytes) or even padded to 12 or
16 bytes
       2. inline write (TPC_P0) of MS_CMD_BLOCK_WRITE + wait for int
       3. read of INT register via STATUS
       3. DMA write of MS_TPC_WRITE_LONG_DATA
       4. DMA write of MS_TPC_WRITE_LONG_DATA
           ---------timeout-----------
 
   * In fact first DMA write succedes, but next one fails, and so do all
following writes

   * The problem persits till reboot, and shows up even if PIO isn't
used again.
   Other way to "fix" it, is to put device in D3 and back to D0

   * Serial/parallel mode don't affect anything.

   After bug reproduction:

    * DMA writes stop working completely, therefore mspro_blk looses
writes as well

    * PIO still works just fine. Its possible just to load the driver
without dma support, and it works correctly.

    * DMA reads work just fine.

#5: Auto_Get_INT feature just doesn't work.
   Datasheet says that intreg is placed to TPC_P0, but that doesn't
happen....
</quote>

