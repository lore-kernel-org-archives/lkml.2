Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab0GVAhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 20:37:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:59978 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab0GVAhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 20:37:12 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 2/5] repair gdbstub to match the gdbserial protocol specification
Date: Wed, 21 Jul 2010 19:36:12 -0500
Message-Id: <1279758975-16658-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1279758975-16658-2-git-send-email-jason.wessel@windriver.com>
References: <1279758975-16658-1-git-send-email-jason.wessel@windriver.com>
 <1279758975-16658-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Jul 2010 00:36:28.0705 (UTC) FILETIME=[EC716110:01CB2935]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gdbserial protocol handler should return an empty packet instead
of an error string when ever it responds to a command it does not
implement.

The problem cases come from a debugger client sending
qTBuffer, qTStatus, qSearch, qSupported.

The incorrect response from the gdbstub leads the debugger clients to
not function correctly.  Recent versions of gdb will not detach correctly as a result of this behavior.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
---
 kernel/debug/gdbstub.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index 4b17b32..e8fd686 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -621,10 +621,8 @@ static void gdb_cmd_query(struct kgdb_state *ks)
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
@@ -665,10 +663,9 @@ static void gdb_cmd_query(struct kgdb_state *ks)
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
1.6.3.3

