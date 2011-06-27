Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1F0VR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:17:28 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:48997 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab1F0VRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:17:24 -0400
From: Richard Weinberger <richard@nod.at>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH][Resend] Fix infinite loop in search_binary_handler()
Date: Mon, 27 Jun 2011 23:17:04 +0200
Message-Id: <1309209424-32679-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When search_binary_handler() is called to find a handler
for /sbin/modprobe it will end up in an infinite loop because
it executes request_module() to load a binfmt module with
/sbin/modprobe...

Running a x86_64 kernel without ia32 emulation and a x86 user land
triggers this issue.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/exec.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 97e0d52..7271b22 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1411,7 +1411,10 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			    printable(bprm->buf[2]) &&
 			    printable(bprm->buf[3]))
 				break; /* -ENOEXEC */
-			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
+
+			/* Avoid an infinite loop */
+			if (strcmp(modprobe_path, bprm->filename))
+				request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
 #endif
 		}
 	}
-- 
1.7.5.4

