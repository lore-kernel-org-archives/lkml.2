Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2KETxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:53:39 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49756 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab2KETxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:53:37 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Xi Wang <xi.wang@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] [SCSI] mvsas: fix multiple shift issues
Date: Mon,  5 Nov 2012 14:53:00 -0500
Message-Id: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main issue is that bit(n) is defined as:

	(u32)1 << n

Thus bit(n) with n >= 32 will produce 0 or 1, depending on the
architecture.  This is also undefined behavior in C.

The OR with sata_reg_set (u64) then doesn't work because bit()
does a 32-bit shift, which should have been a 64-bit shift:

	if (i >= 32) {
		mvi->sata_reg_set |= bit(i);
		...
	}

The other two patches fix similar oversized shift issues.

Xi Wang (3):
  [SCSI] mvsas: fix shift in mvs_94xx_assign_reg_set()
  [SCSI] mvsas: fix shift in mvs_94xx_free_reg_set()
  [SCSI] mvsas: fix shift in mv_ffc64()

 drivers/scsi/mvsas/mv_94xx.c |    8 +++++---
 drivers/scsi/mvsas/mv_94xx.h |   14 ++------------
 drivers/scsi/mvsas/mv_sas.h  |    2 +-
 3 files changed, 8 insertions(+), 16 deletions(-)

-- 
1.7.10.4

