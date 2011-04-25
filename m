Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab1DYUc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:32:27 -0400
Received: from 1wt.eu ([62.212.114.60]:34586 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446Ab1DYUZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:25 -0400
Message-Id: <20110425200240.511095244@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: "Desai Kashyap" <Kashyap.Desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 173/173] [SCSI] mptsas: fix hangs caused by ATA pass-through
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ryan Kuester <rkuester@kspace.net>

commit 2a1b7e575b80ceb19ea50bfa86ce0053ea57181d upstream.

I may have an explanation for the LSI 1068 HBA hangs provoked by ATA
pass-through commands, in particular by smartctl.

First, my version of the symptoms.  On an LSI SAS1068E B3 HBA running
01.29.00.00 firmware, with SATA disks, and with smartd running, I'm seeing
occasional task, bus, and host resets, some of which lead to hard faults of
the HBA requiring a reboot.  Abusively looping the smartctl command,

    # while true; do smartctl -a /dev/sdb > /dev/null; done

dramatically increases the frequency of these failures to nearly one per
minute.  A high IO load through the HBA while looping smartctl seems to
improve the chance of a full scsi host reset or a non-recoverable hang.

I reduced what smartctl was doing down to a simple test case which
causes the hang with a single IO when pointed at the sd interface.  See
the code at the bottom of this e-mail.  It uses an SG_IO ioctl to issue
a single pass-through ATA identify device command.  If the buffer
userspace gives for the read data has certain alignments, the task is
issued to the HBA but the HBA fails to respond.  If run against the sg
interface, neither the test code nor smartctl causes a hang.

sd and sg handle the SG_IO ioctl slightly differently.  Unless you
specifically set a flag to do direct IO, sg passes a buffer of its own,
which is page-aligned, to the block layer and later copies the result
into the userspace buffer regardless of its alignment.  sd, on the other
hand, always does direct IO unless the userspace buffer fails an
alignment test at block/blk-map.c line 57, in which case a page-aligned
buffer is created and used for the transfer.

The alignment test currently checks for word-alignment, the default
setup by scsi_lib.c; therefore, userspace buffers of almost any
alignment are given directly to the HBA as DMA targets.  The LSI 1068
hardware doesn't seem to like at least a couple of the alignments which
cross a page boundary (see the test code below).  Curiously, many
page-boundary-crossing alignments do work just fine.

So, either the hardware has an bug handling certain alignments or the
hardware has a stricter alignment requirement than the driver is
advertising.  If stricter alignment is required, then in no case should
misaligned buffers from userspace be allowed through without being
bounced or at least causing an error to be returned.

It seems the mptsas driver could use blk_queue_dma_alignment() to advertise
a stricter alignment requirement.  If it does, sd does the right thing and
bounces misaligned buffers (see block/blk-map.c line 57).  The following
patch to 2.6.34-rc5 makes my symptoms go away.  I'm sure this is the wrong
place for this code, but it gets my idea across.

Acked-by: "Desai Kashyap" <Kashyap.Desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 5c53624..407cb84 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2459,6 +2459,8 @@ mptscsih_slave_configure(struct scsi_device *sdev)
 		ioc->name,sdev->tagged_supported, sdev->simple_tags,
 		sdev->ordered_tags));
 
+	blk_queue_dma_alignment (sdev->request_queue, 512 - 1);
+
 	return 0;
 }
 


