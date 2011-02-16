Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab1BPB2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:28:13 -0500
Received: from kroah.org ([198.145.64.141]:39456 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab1BPAWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:39 2011
Message-Id: <20110216001439.049568009@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [140/272] net: add POLLPRI to sock_def_readable()
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 2c6607c611cb7bf0a6750bcea34a258144e302c5 ]

Leonardo Chiquitto found poll() could block forever on tcp sockets and
Urgent data was received, if the event flag only contains POLLPRI.

He did a bisection and found commit 4938d7e0233 (poll: avoid extra
wakeups in select/poll) was the source of the problem.

Problem is TCP sockets use standard sock_def_readable() function for
their sk_data_ready() handler, and sock_def_readable() doesnt signal
POLLPRI.

Only TCP is affected by the problem. Adding POLLPRI to the list of flags
might trigger unnecessary schedules, but URGENT handling is such a
seldom used feature this seems a good compromise.

Thanks a lot to Leonardo for providing the bisection result and a test
program as well.

Reference : http://www.spinics.net/lists/netdev/msg151793.html

Reported-and-bisected-by: Leonardo Chiquitto <leonardo.lists@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/sock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1907,7 +1907,7 @@ static void sock_def_readable(struct soc
 	rcu_read_lock();
 	wq = rcu_dereference(sk->sk_wq);
 	if (wq_has_sleeper(wq))
-		wake_up_interruptible_sync_poll(&wq->wait, POLLIN |
+		wake_up_interruptible_sync_poll(&wq->wait, POLLIN | POLLPRI |
 						POLLRDNORM | POLLRDBAND);
 	sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
 	rcu_read_unlock();


