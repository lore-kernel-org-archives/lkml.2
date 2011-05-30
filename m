Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab1E3HNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:13:39 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53891 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab1E3HNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:13:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=MjpTZYEV+GM71HPBt8G1OLO3tiWOCkf8MH9+NswNPvam6Ew8O7+zLExc07GxMihrW8
         9CRfwAc43z79HE9WgN3nqZch/dryGdWqztqbxOsbplIUCAu43VBdKxo3nNMTAkXZ+D+I
         lAhXPQrbfXb5w0OT8PGl8fMOYshygl+crzbfU=
From: Connor Hansen <cmdkhh@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Borislav Petkov <bp@alien8.de>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, Connor Hansen <cmdkhh@gmail.com>
Subject: [PATCH 1/2] ide-cd: Fix signedness warning
Date: Mon, 30 May 2011 00:13:32 -0700
Message-Id: <1306739612-29239-1-git-send-email-cmdkhh@gmail.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the legit warnings 'make W=3 drivers/ide/ide-cd.o´ generates is

drivers/ide/ide-cd.c: In function .ide_cdrom_prep_fs.:
drivers/ide/ide-cd.c:1314: warning: conversion to .unsigned int. from .int. may change the sign of the result

because queue_logical_block_size() returns unsigned short but hard_sect
is defined as int. Fix that no matter how low the potential for this
becoming a bug is.

Signed-off-by: Connor Hansen <cmdkhh@gmail.com>
---
 drivers/ide/ide-cd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 6e5123b..c1de54a 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1309,7 +1309,7 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 /* standard prep_rq_fn that builds 10 byte cmds */
 static int ide_cdrom_prep_fs(struct request_queue *q, struct request *rq)
 {
-	int hard_sect = queue_logical_block_size(q);
+	unsigned short hard_sect = queue_logical_block_size(q);
 	long block = (long)blk_rq_pos(rq) / (hard_sect >> 9);
 	unsigned long blocks = blk_rq_sectors(rq) / (hard_sect >> 9);
 
-- 
1.7.4.4

