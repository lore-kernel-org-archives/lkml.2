Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab0IXQ2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:28:07 -0400
Received: from kroah.org ([198.145.64.141]:46073 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528Ab0IXQ2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:03 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:16 2010
Message-Id: <20100924162616.115425259@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "David S. Miller" <davem@davemloft.net>
Subject: [14/80] UNIX: Do not loop forever at unix_autobind().
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit a9117426d0fcc05a194f728159a2d43df43c7add ]

We assumed that unix_autobind() never fails if kzalloc() succeeded.
But unix_autobind() allows only 1048576 names. If /proc/sys/fs/file-max is
larger than 1048576 (e.g. systems with more than 10GB of RAM), a local user can
consume all names using fork()/socket()/bind().

If all names are in use, those who call bind() with addr_len == sizeof(short)
or connect()/sendmsg() with setsockopt(SO_PASSCRED) will continue

  while (1)
        yield();

loop at unix_autobind() till a name becomes available.
This patch adds a loop counter in order to give up after 1048576 attempts.

Calling yield() for once per 256 attempts may not be sufficient when many names
are already in use, for __unix_find_socket_byname() can take long time under
such circumstance. Therefore, this patch also adds cond_resched() call.

Note that currently a local user can consume 2GB of kernel memory if the user
is allowed to create and autobind 1048576 UNIX domain sockets. We should
consider adding some restriction for autobind operation.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/unix/af_unix.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -673,6 +673,7 @@ static int unix_autobind(struct socket *
 	static u32 ordernum = 1;
 	struct unix_address *addr;
 	int err;
+	unsigned int retries = 0;
 
 	mutex_lock(&u->readlock);
 
@@ -698,9 +699,17 @@ retry:
 	if (__unix_find_socket_byname(net, addr->name, addr->len, sock->type,
 				      addr->hash)) {
 		spin_unlock(&unix_table_lock);
-		/* Sanity yield. It is unusual case, but yet... */
-		if (!(ordernum&0xFF))
-			yield();
+		/*
+		 * __unix_find_socket_byname() may take long time if many names
+		 * are already in use.
+		 */
+		cond_resched();
+		/* Give up if all names seems to be in use. */
+		if (retries++ == 0xFFFFF) {
+			err = -ENOSPC;
+			kfree(addr);
+			goto out;
+		}
 		goto retry;
 	}
 	addr->hash ^= sk->sk_type;


