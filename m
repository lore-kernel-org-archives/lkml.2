Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1ABHxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:53:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:35577 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab1ABHX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:28 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 120/260] UNIX: Do not loop forever at unix_autobind().
Date: Sun,  2 Jan 2011 02:16:56 -0500
Message-Id: <1293952756-15010-121-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:20.0743 (UTC) FILETIME=[CB227D70:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 8df73ff90f00f14d2c7ff7156f7ef153f7e9d3b7 upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/unix/af_unix.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 3d9122e..8c34e3b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -672,6 +672,7 @@ static int unix_autobind(struct socket *sock)
 	static u32 ordernum = 1;
 	struct unix_address *addr;
 	int err;
+	unsigned int retries = 0;
 
 	mutex_lock(&u->readlock);
 
@@ -697,9 +698,17 @@ retry:
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
-- 
1.7.3.3

