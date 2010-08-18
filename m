Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab0HRJ6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 05:58:32 -0400
Received: from stargate.synerway.com ([84.14.10.249]:61015 "EHLO
	kamino.synerway.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751177Ab0HRJ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 05:58:29 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Aug 2010 05:58:29 EDT
Date: Wed, 18 Aug 2010 11:43:13 +0200
From: Pascal GREGIS <pgs@synerway.com>
To: linux-kernel@vger.kernel.org
Subject: ata_sff_drain_fifo
Message-ID: <20100818094313.GA3333@gaiman.synerway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-OriginalArrivalTime: 18 Aug 2010 09:43:13.0482 (UTC) FILETIME=[C6C45AA0:01CB3EB9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a question about the ata_sff_drain_fifo.
I saw it drains the fifo while the ATA_DRQ flag is on.
In my case, I sometimes get a stuck device and this drain is inefficient, trying to figure out why, I noticed the following :
   Jun 9 20:28:36 w11190100sav kernel: ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
   Jun 9 20:28:36 w11190100sav kernel: ata4.00: cmd a0/00:00:00:00:20/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0
   Jun 9 20:28:36 w11190100sav kernel: res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
   Jun 9 20:28:43 w11190100sav kernel: ata4: port is slow to respond, please be patient (Status 0xd0)
   Jun 9 20:29:06 w11190100sav kernel: ata4: port failed to respond (30 secs, Status 0xd0)
   Jun 9 20:29:06 w11190100sav kernel: ata4: soft resetting port
   Jun 9 20:29:06 w11190100sav kernel: ATA: abnormal status 0xD0 on port 0x0001cc07
   Jun 9 20:29:06 w11190100sav last message repeated 4 times
   Jun 9 20:29:36 w11190100sav kernel: ata4.00: qc timeout (cmd 0xa1)
   Jun 9 20:29:36 w11190100sav kernel: ata4.00: failed to IDENTIFY (I/O error, err_mask=0x4)
   Jun 9 20:29:36 w11190100sav kernel: ata4.00: revalidation failed (errno=-5)
   Jun 9 20:29:36 w11190100sav kernel: ata4: failed to recover some devices, retrying in 5 secs
   Jun 9 20:29:49 w11190100sav kernel: ata4: port is slow to respond, please be patient (Status 0xd0)

so the status is 0xD0.
In include/linux/ata.h I see :
	ATA_BUSY		= (1 << 7),	/* BSY status bit */
	...
	ATA_DRQ			= (1 << 3),	/* data request i/o */

so I guess when status is 0xD0, ATA_DRQ is not set but ATA_BUSY is.
It would explain why in my case it doesn't drain anything before trying to reset.

Would it be of any interest to drain the fifo also when the ATA_BUSY flag is on, not only the ATA_DRQ ?

Pascal
