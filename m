Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab2AAPet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 10:34:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55594 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2AAPep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 10:34:45 -0500
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        k.skarlatos@gmail.com, shirishpargaonkar@gmail.com
Subject: [PATCH] cifs: fix bad buffer length check in coalesce_t2
Date: Sun,  1 Jan 2012 10:34:39 -0500
Message-Id: <1325432079-21179-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current check looks to see if the RFC1002 length is larger than
CIFSMaxBufSize, and fails if it is. The buffer is actually larger than
that by MAX_CIFS_HDR_SIZE.

This bug has been around for a long time, but the fact that we used to
cap the clients MaxBufferSize at the same level as the server tended
to paper over it. Commit c974befa changed that however and caused this
bug to bite in more cases.

Reported-and-Tested-by: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8cd4b52..27c4f25 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -282,7 +282,7 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 	byte_count = be32_to_cpu(pTargetSMB->smb_buf_length);
 	byte_count += total_in_buf2;
 	/* don't allow buffer to overflow */
-	if (byte_count > CIFSMaxBufSize)
+	if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4)
 		return -ENOBUFS;
 	pTargetSMB->smb_buf_length = cpu_to_be32(byte_count);
 
-- 
1.7.7.4

