Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab1I1WiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:38:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab1I1WiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:38:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:28 2011
Message-Id: <20110928220128.185767598@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Goulet <dgoulet@ev0ke.net>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Anton Blanchard <anton@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [028/244] sendmmsg/sendmsg: fix unsafe user pointer access
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit bc909d9ddbf7778371e36a651d6e4194b1cc7d4c upstream.

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/socket.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/socket.c
+++ b/net/socket.c
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


