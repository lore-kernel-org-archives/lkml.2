Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab0H1Gxr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 02:53:47 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:48732 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751748Ab0H1Gxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 02:53:46 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 50tz3H0VM1l6UNnJghrpxrmI2a3a9m3sXre_3gl1kUVjUq_
 AxrIdZfPDtqprQ8NlIa74sR2VD1KRURqSds7qnIZRoJoKCV_9Sx8DUbfs1Y1
 MutJpM.MS9NzLy.VUpc79jKpl8k2WfGG5QBBTROsQHXK_gTzu6QpiMIalSlM
 URNMo42tIZgnFDQ79P1lta.06wPnWLLOTNWzYxwuKC5pTYlna8.bmpkiTYDa
 uqCDrdiVJ3RWEueB8.RoXtcEcufsm9VojEnfGJQRX_xfZFLADt3Kkc_QJ_rU
 eyh7DZsTBPsiV_ylbYu7bbFyW9UlQ4zrKZBXIn1smYkwU6DvP.rRr8A4-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <teheo@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/3] tcm: SYNCHRONIZE_CACHE emulation fixes and IBLOCK support
Date: Fri, 27 Aug 2010 23:53:42 -0700
Message-Id: <1282978422-16905-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings hch, tejun and Co,

These patches are a follow up to the series posted recently for lio-core-2.6.git/lio-4.0
here:

[PATCH 0/4] tcm: Add WriteCache + FUA Write support to TCM/FILEIO
http://marc.info/?l=linux-scsi&m=128288359913333&w=2

The first and second patch follows hch's recommendation and remove the extra
'flush entire cache of device' struct se_subsystem_api->do_sync_cache() caller
from TCM Core in the original commit, and converts transport_generic_synchronize_cache()
and FILEIO dependent code to use struct se_subsystem_api->do_sync_cache_range()
for *both* the SYNCHRONIZE_CACHE emulation cases of 'per LBA + Number of Blocks Range'
flush and 'flush entrire cache of device' op.

The third patch in the series adds new support for WriteCache and FUA WRITE emulation
into the TCM/IBLOCK subsystem plugin using block/blk-barrier.c:blkdev_issue_flush()
w/ BLKDEV_IFL_WAIT flag.  Note that since blkdev_issue_flush() does not support a
LBA + Range flush, all TCM/IBLOCK SYNCHRONIZE_CACHE and FUA WRITE ops involving a
LBA + Range are converted into a global device cache flush op w/ blkdev_issue_flush().

Many thanks again to hch for his guidence in this area,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  tcm/fileio: Remove struct se_subsystem_api->do_sync_cache() usage
  tcm: Remove struct se_subsystem_api->do_sync_cache()
  tcm/iblock: Add WriteCache and Forced Unit Access WRITE emulation

 drivers/target/target_core_file.c      |   31 ++++----
 drivers/target/target_core_iblock.c    |  119 ++++++++++++++++++++++++++++++-
 drivers/target/target_core_iblock.h    |    1 +
 drivers/target/target_core_transport.c |   21 +-----
 include/target/target_core_transport.h |    7 --
 5 files changed, 135 insertions(+), 44 deletions(-)

