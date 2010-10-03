Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab0JCAxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 20:53:37 -0400
Received: from smtp104.sbc.mail.gq1.yahoo.com ([67.195.15.63]:40332 "HELO
	smtp104.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752076Ab0JCAxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 20:53:35 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: S3aw7XYVM1kDZ3Nz9jY99ihmj7k764KTZcbCAFB1PsW9Oh1
 GTdN4UsaroJ5CGpUu4IIavSzqNrnW6OTuNOyUck04hkOQzgNg2EE6Xg1x3f4
 ITv43N1t0fpd1loXloO_rUp0JTbwl9UBUgJcivL8g0S6QNSjhZnkAmW2rs8l
 Iyn9IuZsjZe0QCUvZcSA.KpDoU07AgI5ThKKwsiYDJF0OsgKt4tAjK3bfAft
 O4NgZh6EUw9mc4acFzCaw8.j7_18fxboFs0WVYzzPPPUKEZ6KThg8RZId8g2
 dB__lVgdN4BFNf6cxx4gOJwyv92ySeKg5itrE4CuMSdzC0TgaBaFQFCPp7B4
 FG63E4i_N6EAzRVLdMg--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/2] tcm: Add WRITE_SAME_16 support w/ UNMAP=1 emulation
Date: Sat,  2 Oct 2010 17:53:32 -0700
Message-Id: <1286067212-14449-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This series adds initial support for WRITE_SAME_16 w/ UNMAP=1 emulation into
TCM/IBLOCK and TCM/FILEIO subsystem plugins using generic Block Discard logic.
This also includes proper TCM/pSCSI passthrough support to handle all possible
flavours of WRITE_SAME_16 for underlying HW that supports it.

The main items to note here for the IBLOCK+FILEIO emulated (eg: not passthrough)
case are:

	*) WRITE_SAME_16 w/ PBDATA and LBDATA will return INVALID_FIELD_IN_CDB
	*) WRITE_SAME_16 w/o UNMAP=1 will return INVALID_FIELD_IN_CDB
	*) WRITE_SAME_16 w/ UNMAP=1 will make IBLOCK+FILEIO call
	   transport_generic_write_same(), and not actually write the
	   received payload.

The first patch adds the main WRITE_SAME_16 pieces into TCM_Core, adds the new
emulate_tpws device attribute, and updates Block Limits VPD, Thin Provisioning
VPD and READ_CAPACITY_* to take emulate_tpws=1 into account to signal/handle
SBC-3 TPE=1 operation.

The second patch adds support into IBLOCK + FILEIO for using the TCM Core provided
transport_generic_write_same(), and will set both DEV_ATTRIB(dev)->emulate_tp[ws,u]=1
when blk_queue_discard()==1 signals underlying HW supports some flavour of TPE.

So far this series been tested with TCM_Loop -> (IBLOCK,FILEIO,pSCSI) -> scsi_debug
on v2.6.36-rc6 using explict 'sg_write_same -S' callers via SG_IO.

Once again, many thanks to mkp for sharing his knowledge of this area!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  tcm: Add WRITE_SAME_16 emulation and passthrough support
  tcm/iblock,fileio: Add WRITE_SAME_16 w/ UNMAP=1 bit support

 drivers/target/target_core_configfs.c  |    4 +
 drivers/target/target_core_device.c    |   15 +++++-
 drivers/target/target_core_file.c      |   47 +++++++++++++++-
 drivers/target/target_core_iblock.c    |   21 +++++++-
 drivers/target/target_core_transport.c |   99 ++++++++++++++++++++++++++++++--
 include/target/target_core_base.h      |    5 +-
 include/target/target_core_device.h    |    1 +
 include/target/target_core_transport.h |    6 ++
 8 files changed, 189 insertions(+), 9 deletions(-)

