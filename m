Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab0IKKbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 06:31:23 -0400
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:43897 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750843Ab0IKKbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 06:31:21 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: jOf_nBQVM1lINPn1Y5SN0j6GTPoPhi60b_MR3avQaN58iXi
 KCmtneigoc1xAex4IFlWZjJY8XQHdnDCCjTwj2GOlG.Z1pwJxphNiJdiYVnO
 LJSIky0BPhpOY7uertnfDBrmG_w_5O2lJjHhHrWNLIdN1S22HSd3ygHiEx.y
 PMRhtGqA7BhyZP3Oifew6Eoc0EQetIiJRCYpoeKLiNSndTFuwQa35VCSCNrL
 oNngI_sfa6dXaQEX5cxTZ6nZ7LawWsmSQ9tr0RVko.eefE8Fz76.m_PaY8W_
 Jvyuakw.l.tRyC_pqBMGXW1wxXjSCzzHBxWaGgIaU8z4MITFcrHSJYHcHDz8
 xTKStElaTB1mtztGE8w--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Vasu Dev <vasu.dev@linux.intel.com>,
        Joe Eykholt <jeykholt@cisco.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/2] lio-target: Add support for libcrypto crc32c and crc32-intel offload
Date: Sat, 11 Sep 2010 03:31:16 -0700
Message-Id: <1284201076-22361-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This patch series converts the LIO-Target fabric module from using a legacy
internal slicing by 1x CRC32C algorithm to the slicing by 1x CRC32C available in
crc32c.ko, as well as initial support for the Nehalem series crc32c-intel.ko
instruction offload available since v2.6.27 in late 2008.

So far this series has been lightly tested with a handful of Open-iSCSI client VMs
with the optimized crc32c-intel.ko offload case, and there appears to be some
HeaderDigest failures for one case with RHEL6 B2 x86_64, while Ubuntu i686 on
v2.6.27 and OpenSuse 11.2 x86_64 on v2.6.31 work as expected with HeaderDigest=CRC32C
and DataDigest=CRC32C using the offload on the LIO-Target side.

Currently this patch disables the new iSCSI TPG attribute crc32c_x86_offload
to force the crc32c.ko slicing by x1 CRC32C algorithm until these compatibility
issues with existing libcrc32c clients can be properly resolved with the Nehalem
CRC32C offload instructions running on the LIO-Target side.

Comments are welcome!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  lio-target: Convert to use libcrypto crc32c
  lio-target: Add support for Intel Nehalem crc32-intel libcrypto
    offload

 drivers/target/lio-target/Kbuild                  |    1 -
 drivers/target/lio-target/iscsi_crc.c             |  171 ------------
 drivers/target/lio-target/iscsi_crc.h             |    9 -
 drivers/target/lio-target/iscsi_target.c          |  302 ++++++++++++++++-----
 drivers/target/lio-target/iscsi_target_configfs.c |    6 +
 drivers/target/lio-target/iscsi_target_core.h     |    7 +
 drivers/target/lio-target/iscsi_target_erl1.c     |    1 -
 drivers/target/lio-target/iscsi_target_erl2.c     |    1 -
 drivers/target/lio-target/iscsi_target_login.c    |   76 +++++-
 drivers/target/lio-target/iscsi_target_login.h    |    1 +
 drivers/target/lio-target/iscsi_target_nego.c     |   18 +-
 drivers/target/lio-target/iscsi_target_tmr.c      |    1 -
 drivers/target/lio-target/iscsi_target_tpg.c      |   19 ++
 drivers/target/lio-target/iscsi_target_tpg.h      |    1 +
 14 files changed, 356 insertions(+), 258 deletions(-)
 delete mode 100644 drivers/target/lio-target/iscsi_crc.c
 delete mode 100644 drivers/target/lio-target/iscsi_crc.h

