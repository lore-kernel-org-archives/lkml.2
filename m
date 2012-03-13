Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442Ab2CMAWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:22:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:47388 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758433Ab2CMAV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:21:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jason Wessel <jason.wessel@windriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 046/196] repair gdbstub to match the gdbserial protocol specification
Date: Mon, 12 Mar 2012 20:19:19 -0400
Message-Id: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit fb82c0ff27b2c40c6f7a3d1a94cafb154591fa80 upstream.

The gdbserial protocol handler should return an empty packet instead
of an error string when ever it responds to a command it does not
implement.

The problem cases come from a debugger client sending
qTBuffer, qTStatus, qSearch, qSupported.

The incorrect response from the gdbstub leads the debugger clients to
not function correctly.  Recent versions of gdb will not detach correctly as a result of this behavior.

[PG: file renamed by time of fb82c0ff  kgdb.c --> debug/gdbstub.c]

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/kgdb.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 11f3515..0887213 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -976,10 +976,8 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 	switch (remcom_in_buffer[1]) {
 	case 's':
 	case 'f':
-		if (memcmp(remcom_in_buffer + 2, "ThreadInfo", 10)) {
-			error_packet(remcom_out_buffer, -EINVAL);
+		if (memcmp(remcom_in_buffer + 2, "ThreadInfo", 10))
 			break;
-		}
 
 		i = 0;
 		remcom_out_buffer[0] = 'm';
@@ -1020,10 +1018,9 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 		pack_threadid(remcom_out_buffer + 2, thref);
 		break;
 	case 'T':
-		if (memcmp(remcom_in_buffer + 1, "ThreadExtraInfo,", 16)) {
-			error_packet(remcom_out_buffer, -EINVAL);
+		if (memcmp(remcom_in_buffer + 1, "ThreadExtraInfo,", 16))
 			break;
-		}
+
 		ks->threadid = 0;
 		ptr = remcom_in_buffer + 17;
 		kgdb_hex2long(&ptr, &ks->threadid);
-- 
1.7.9.3

