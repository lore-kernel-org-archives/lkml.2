Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379Ab0I0Wv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:51:26 -0400
Received: from nm5-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.204]:38185 "HELO
	nm5-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757483Ab0I0WvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:51:24 -0400
X-Yahoo-Newman-Id: 393318.47594.bm@omp1037.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: cdMwVpoVM1nDVqjE3.JktSVWZssx3rSRogfcVGK2.DZlHBq
 QR4UzALF1FJ0iZSaTcosdFT57V4banGpMnQzWaHg8Ht53EzJ7sYFM.DRCHC3
 qki4WlMZefkLEZp6fRG1WmvlGDHGEyYioOqpnsmxed0V7d_BkA8JG4cuk9YO
 7ijBJPRwymmIjKJiegpg.Ry.bV1OKlfbPgIF.lmNRWx82OtXGB1rcUoEybbH
 okxwvkXiBFL82AxlsZUAwadjOeRbvF8oK_ShlMYf7Ic3sbK_bARzPjm7Luin
 cPZAwebgqjXngtTx2La5Hwc7XAnEZsk3OWYBA.shW8G5Zistagqs-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/3] tcm: Add TPE=1 / UNMAP emulation + passthrough support
Date: Mon, 27 Sep 2010 15:51:17 -0700
Message-Id: <1285627877-6429-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This series adds generic TPE=1 / UNMAP support into TCM Core and TCM/IBLOCK +
TCM/FILEIO subsystem plugin code code to issue blkdev_issue_discard() for
struct block_device that support QUEUE_FLAG_DISCARD.  Using TPE=1 / UNMAP
is also supported with direct struct request passthrough using TCM/pSCSI
and everything required for this to function is included in patch #1.

Patch #1 also includes the addition of the SBC-3 Block Limits VPD (0xb0) page
and adds the following UNMAP related knobs returned into configfs attributes in
/sys/kernel/config/target/core/$HBA/$DEV/attrib, the new ones include:

	*) optimal_sectors (currently set to our ->max_sectors)
	*) max_unmap_block_desc_count (set to 0 by default)
	*) max_unmap_lba_count (set to 0 by default)
	*) unmap_granularity (set to 0 by default)
	*) unmap_granularity_alignment (set to 0 by default)

Patch #2 includes the necessary changes to IBLOCK to detect QUEUE_FLAG_DISCARD
and call transport_generic_unmap() for each UNMAP op.

Patch #3 includes the necessary changes to FILEIO w/ a valid S_ISBLK() to
detect QUEUE_FLAG_DISCARD and call transport_generic_unmap() for each UNMAP
op.  This is the one item I am unsure about, eg: using iget() + iput() to locate
struct block_device for blk_issue_discard()..?  hch..?

So far these patches have been tested with scsi_debug LUNs w/ TPE=1 with both
IBLOCK and FILEIO TPE=1 emulation modes, along with TCM/pSCSI passthrough mode on
v2.6.36-rc4 HVM.  Here is what Block Limits VPD output looks like via TCM_Loop:

	target# sg_inq --page=0xb0 /dev/sdh
	VPD INQUIRY: Block limits page (SBC)
	  Maximum compare and write length: 0 blocks
	  Optimal transfer length granularity: 1 blocks
	  Maximum transfer length: 1024 blocks
	  Optimal transfer length: 1024 blocks
	  Maximum prefetch, xdread, xdwrite transfer length: 0 blocks
	  Maximum unmap LBA count: 0
	  Maximum unmap block descriptor count: 0
	  Optimal unmap granularity: 0
	  Unmap granularity alignment valid: 0
	  Unmap granularity alignment: 0

and with sg_unmap:

	target# sg_unmap -v --lba=78 --num=4 --verbose /dev/sdh
	open /dev/sdh with flags=0x802
	    unmap cdb: 42 00 00 00 00 00 00 00 18 00 
	    unmap parameter list:
	        00 16 00 10 00 00 00 00  00 00 00 00 00 00 00 4e    
	        00 00 00 04 00 00 00 00                         

Comments are welcome!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  tcm: Add Thin Provisioning / UNMAP emulation and Block Limits VPD
    page
  tcm/iblock: Add UNMAP / Block DISCARD support
  tcm/fileio: Add UNMAP / Block DISCARD support

 drivers/target/target_core_configfs.c  |   24 +++++
 drivers/target/target_core_device.c    |   90 +++++++++++++++++++
 drivers/target/target_core_file.c      |   53 +++++++++++-
 drivers/target/target_core_iblock.c    |   19 ++++-
 drivers/target/target_core_transport.c |  152 ++++++++++++++++++++++++++++++++
 include/target/target_core_base.h      |    9 ++-
 include/target/target_core_device.h    |    6 ++
 include/target/target_core_transport.h |   11 +++
 8 files changed, 361 insertions(+), 3 deletions(-)

