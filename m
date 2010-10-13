Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab0JMIR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:17:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36991 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab0JMIR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:17:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vQbs7lkYRht/rcbXV0aQbUathDSPfDYkLJcRhiYOTVYDLSJED/qd+U7xEZKZyPOHSf
         qrpJFZVW+xlJ3wIzXGElwsTRuPlpkUTlMY+eJWsC71xBjRomA+roSePCJ0SIdNKDuHhr
         /pMHALb3XVL0NBlOO2K1M9x2XQeNhouA/o8sQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] jbd: Check return value of __getblk()
Date: Wed, 13 Oct 2010 17:17:18 +0900
Message-Id: <1286957838-5579-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fail journal creation if __getblk() returns NULL.  unlikely() is
added because it is called in a loop and we've been OK without
the check until now.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/journal.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 7fee247..3290fe9 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -950,6 +950,8 @@ int journal_create(journal_t *journal)
 		if (err)
 			return err;
 		bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
+		if (unlikely(!bh))
+			return -ENOMEM;
 		lock_buffer(bh);
 		memset (bh->b_data, 0, journal->j_blocksize);
 		BUFFER_TRACE(bh, "marking dirty");
-- 
1.7.0.4

