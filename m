Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab1HYCjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 22:39:44 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37474 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751108Ab1HYCjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 22:39:43 -0400
Date: Wed, 24 Aug 2011 22:39:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org
Cc: David Goulet <dgoulet@ev0ke.net>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Anton Blanchard <anton@samba.org>,
        "David S. Miller" <davem@davemloft.net>, stable <stable@kernel.org>
Subject: [PATCH 3.1-rc3/3.0.3] sendmmsg/sendmsg: fix unsafe user pointer
	access
Message-ID: <20110825023940.GA23683@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 22:35:50 up 274 days,  7:38,  5 users,  load average: 0.08, 0.02,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dereferencing a user pointer directly from kernel-space without going
through the copy_from_user family of functions is a bad idea. Two of
such usages can be found in the sendmsg code path called from sendmmsg,
added by

commit c71d8ebe7a4496fb7231151cb70a6baa0cb56f9a upstream.
commit 5b47b8038f183b44d2d8ff1c7d11a5c1be706b34 in the 3.0-stable tree.

Usages are performed through memcmp() and memcpy() directly. Fix those
by using the already copied msg_sys structure instead of the __user *msg
structure. Note that msg_sys can be set to NULL by verify_compat_iovec()
or verify_iovec(), which requires additional NULL pointer checks.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: David Goulet <dgoulet@ev0ke.net>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: Anton Blanchard <anton@samba.org>
CC: David S. Miller <davem@davemloft.net>
CC: stable <stable@kernel.org>
---
 net/socket.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/net/socket.c
===================================================================
--- linux-2.6-lttng.orig/net/socket.c
+++ linux-2.6-lttng/net/socket.c
@@ -1965,8 +1965,9 @@ static int __sys_sendmsg(struct socket *
 	 * used_address->name_len is initialized to UINT_MAX so that the first
 	 * destination address never matches.
 	 */
-	if (used_address && used_address->name_len == msg_sys->msg_namelen &&
-	    !memcmp(&used_address->name, msg->msg_name,
+	if (used_address && msg_sys->msg_name &&
+	    used_address->name_len == msg_sys->msg_namelen &&
+	    !memcmp(&used_address->name, msg_sys->msg_name,
 		    used_address->name_len)) {
 		err = sock_sendmsg_nosec(sock, msg_sys, total_len);
 		goto out_freectl;
@@ -1978,8 +1979,9 @@ static int __sys_sendmsg(struct socket *
 	 */
 	if (used_address && err >= 0) {
 		used_address->name_len = msg_sys->msg_namelen;
-		memcpy(&used_address->name, msg->msg_name,
-		       used_address->name_len);
+		if (msg_sys->msg_name)
+			memcpy(&used_address->name, msg_sys->msg_name,
+			       used_address->name_len);
 	}
 
 out_freectl:
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
