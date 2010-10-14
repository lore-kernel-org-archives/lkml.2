Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0JNArw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:47:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56721 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab0JNAru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Mp2Y9XYooZ0ZBIP53JLfqowZ3xxWE89eU6jREe9qzSz5/jpKSwAmh/emfNAI323gUy
         DU96++5tlrTO39xoqfzXwr3aQMO8ir7pJmy6V5z0zUjDbO2U3FD+jC9sUx3qwo6S0tpc
         ILEoMPDWVIKewUHYN47akdwsJItqbn2jifwIQ=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Results of my work on memorystick subsystem
Date: Thu, 14 Oct 2010 02:39:59 +0200
Message-Id: <1287016805-5175-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a result of lot of work I did improving the memorystick
subsystem and its drivers.

patch #1 add common code to memorystick core that makes card drivers easier
to understand

patch #2 just add a driver for my card reader

patch #3 reworks the Jmicron driver.
I can write a novel about the problems I had to go through with this device
(mostly hardware bugs I belive).
So I refactored the driver (pretty much rewritten large chunks of it)
Added a lot of debug output too to help future users.
Currently both MS and MSPro work fine.

patch #4 adds support for lagacy memorysticks.
Everything just works, not a single corruption this far.

patch #5, is what I did recently.
I rewrote large chunks on mspro_blk.c to make it much cleaner
and use the common code I added in patch #1.
I also added lot of debug code, comments.

and patch #6 contines adds even more cleanups, and makes whole
memctick subsystem look nice and clean.
Many non obivous functions were removen.
Now register window changes are completely hidden and automatic.
Functions that state machines call are explictly marked as so,
and that assumption is tested.

Code is tested with 2 mspro cards and one MS card.

Thanks again to Alex for his work.

***Appendix***

Jmicron hardware bugs (the novel):

#1: FIFO write ready bit in INT status register is stuck to 1.
   It is stuck forever as soon as fifo
   is used for writing even once.
   Therefore if interrupt is shared (and here it is), its easy
   to 'service' the device while it doesn't need any service


#2: Its not possible to stuff the FIFO before TPC transfer.
   One really have to wait for write ready interrupt, even though the write ready status is stuck.


#3: TPCs with non 4 aligned length woes:
   Facts:

   * non 4 aligned DMA write hangs the system hard, maybe on bus level.

   * PIO read succedes but controller truncates the data stored in the FIFO to closest 4 byte boundary.
   That is if you read 26 bytes, it will save 24 bytes in the FIFO

   * TPC_P0, TPC_P1 not aligned transfters work just fine despite a statement in the datasheet
   (only mention of this problem)


#4: As soon as write PIO is used, then later write DMA fails.
   Facts:

   * This is triggered only by PIO write of registers
   (only happens in ms_block.c when it writes param + oob. Thats why mspro_blk isn't affected)
   Doing short DMA writes is a nice workaround.

   * Doing PIO writes in h_msb_read_page don't cause the problem.
     Therefore the bug causing sequence should be similiar to h_msb_write_block:

       1. PIO write of param + extra (10 bytes) or even padded to 12 or 16 bytes
       2. inline write (TPC_P0) of MS_CMD_BLOCK_WRITE + wait for int
       3. read of INT register via STATUS
       3. DMA write of MS_TPC_WRITE_LONG_DATA
       4. DMA write of MS_TPC_WRITE_LONG_DATA
           ---------timeout-----------
 
   * In fact first DMA write succedes, but next one fails, and so do all following writes

   * The problem persits till reboot, and shows up even if PIO isn't used again.
   Other way to "fix" it, is to put device in D3 and back to D0

   * Serial/parallel mode don't affect anything.

   After bug reproduction:

    * DMA writes stop working completely, therefore mspro_blk looses writes as well

    * PIO still works just fine. Its possible just to load the driver without dma support, and it works correctly.

    * DMA reads work just fine.

#5: Auto_Get_INT feature just doesn't work.
   Datasheet says that intreg is placed to TPC_P0, but that doesn't happen....


Best regards,
	Maxim Levitsky

