Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0GKRDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 13:03:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51323 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab0GKRDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 13:03:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:cc:date:message-id:mime-version:content-type;
        b=wLXttxCJSl3nVPKs6Q5aYuav9rWOA64TP7tZoLZOiwNugZrR13C6+PApIh7+Bw7/jR
         xg+1dmG5faAWj3REl9ao0pVyk6UCar5TzLpk1Ywou7qkRhtkzWZt5Hom48sqxBeef3GP
         y95fYmvKaRHDwJtd7c7wj2o0165Vr5t0s7JHM=
From: "Patrick J. LoPresti" <lopresti@gmail.com>
To: ocfs2-devel@oss.oracle.com
Subject: [PATCH 1/2] JBD2: Allow feature checks before journal recovery
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Date: Sun, 11 Jul 2010 10:03:03 -0700
Message-ID: <871vbax86w.fsf@patl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before we start accessing a huge (> 16 TiB) OCFS2 volume, we need to
confirm that its journal supports 64-bit offsets.  So we need to check
the journal's feature bits before recovering the journal.

This is not possible with JBD2 at present, because the journal
superblock (where the feature bits reside) is not loaded from disk until
the journal is recovered.

This patch loads the journal superblock in
jbd2_journal_check_used_features() if it has not already been loaded,
allowing us to check the feature bits before journal recovery.

Signed-off-by: Patrick LoPresti <lopresti@gmail.com>

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index bc2ff59..c5a864f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1365,6 +1365,8 @@ int jbd2_journal_check_used_features (journal_t *journal, unsigned long compat,
 
 	if (!compat && !ro && !incompat)
 		return 1;
+	if (journal_get_superblock(journal))
+		return 0;
 	if (journal->j_format_version == 1)
 		return 0;
 
