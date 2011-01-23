Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1AWXBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 18:01:20 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20461 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab1AWXBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 18:01:19 -0500
Date: Mon, 24 Jan 2011 00:01:56 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH][RFC] Check poll_select_set_timeout return value in
 sys_poll
Message-ID: <alpine.LNX.2.00.1101232356180.30955@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

poll_select_set_timeout() may return -EINVAL if it's given invalid 
arguments. In sys_poll() we don't check the return value. The way 
poll_select_set_timeout() is called here currently I don't think can ever 
actually fail, but it doesn't hurt to be defensive - code has a tendency 
to change over time. This patch checks the return value and returns 
-EINVAL just like we do elsewhere if it does fail.

What do you think? Is this just pointless overhead or actually worth it as 
an "insurance policy"?

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 select.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)
diff --git a/fs/select.c b/fs/select.c
index e56560d..333d5aa 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -922,8 +922,9 @@ SYSCALL_DEFINE3(poll, struct pollfd __user *, ufds, unsigned int, nfds,
 
 	if (timeout_msecs >= 0) {
 		to = &end_time;
-		poll_select_set_timeout(to, timeout_msecs / MSEC_PER_SEC,
-			NSEC_PER_MSEC * (timeout_msecs % MSEC_PER_SEC));
+		if (poll_select_set_timeout(to, timeout_msecs / MSEC_PER_SEC,
+			NSEC_PER_MSEC * (timeout_msecs % MSEC_PER_SEC)))
+			return -EINVAL;
 	}
 
 	ret = do_sys_poll(ufds, nfds, to);


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

