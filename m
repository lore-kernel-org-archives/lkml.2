Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0JPXNE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 19:13:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58388 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab0JPXNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 19:13:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=s8oZ89cvo9hzx7Vz5rqNMyj+F/LLdAgU5OaJvNkxMDfFyO+2r28Kq77v79Fyd39f6/
         E3/y9s/+O4DDCyMXj1rEwPLweQrw4kB3sXFi+mPkKSyhP4LXB7GAceifbBd87j8HFF6G
         fi3sym1Hc0RUjIpa8DJAe5PinV9/yXxKIibKk=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] Results of my work on memorystick subsystem
Date: Sun, 17 Oct 2010 01:12:48 +0200
Message-Id: <1287270774-18796-1-git-send-email-maximlevitsky@gmail.com>
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
So I refactored the driver and added a lot of debug output future users.
Currently both MS and MSPro work fine.

patch #4 adds support for lagacy memorysticks.
Everything just works, not a single corruption this far.

patch #5, is what I did recently.
I rewrote large chunks on mspro_blk.c to use the common code I added in patch #1.
I also added lot of debug code, comments.

patch #6 adds more cleanups.

Now register window changes are completely hidden and automatic.
Functions that state machines call are explictly marked as so,
and that assumption is tested.
the card->current_mrq isn't passed as a pointer to functions
as this just complicates the code.

Code is tested with 2 mspro cards and one MS card.

Thanks again to Alex for his work.

***Changes from V1 ***

* Fixed brown paper bug in memstick core.
memset had its 2 and 3 arguments swapped.

* Cleaned a lot the PIO code in my r592 driver.
Now it finally looks sane.
Also tested it throughfully.

* Endiannes fixes in Jmicron driver and r592

Best regards,
	Maxim Levitsky

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

   * PIO non-aligned write work, expect that they sometimes hose the DMA.... (regardless of the alignment)

   * TPC_P0, TPC_P1 not aligned transfters work just fine despite a statement in the datasheet
   that they are undefined.... (only mention of this problem)


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
   card status register is 0.

