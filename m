Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1ABHXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:33 -0500
Received: from mail.windriver.com ([147.11.1.11]:35542 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1ABHXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:25 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 113/260] tcp: select(writefds) don't hang up when a peer close connection
Date: Sun,  2 Jan 2011 02:16:49 -0500
Message-Id: <1293952756-15010-114-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:13.0383 (UTC) FILETIME=[C6BF7170:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit d84ba638e4ba3c40023ff997aa5e8d3ed002af36 upstream.

This issue come from ruby language community. Below test program
hang up when only run on Linux.

	% uname -mrsv
	Linux 2.6.26-2-486 #1 Sat Dec 26 08:37:39 UTC 2009 i686
	% ruby -rsocket -ve '
	BasicSocket.do_not_reverse_lookup = true
	serv = TCPServer.open("127.0.0.1", 0)
	s1 = TCPSocket.open("127.0.0.1", serv.addr[1])
	s2 = serv.accept
	s2.close
	s1.write("a") rescue p $!
	s1.write("a") rescue p $!
	Thread.new {
	  s1.write("a")
	}.join'
	ruby 1.9.3dev (2010-07-06 trunk 28554) [i686-linux]
	#<Errno::EPIPE: Broken pipe>
	[Hang Here]

FreeBSD, Solaris, Mac doesn't. because Ruby's write() method call
select() internally. and tcp_poll has a bug.

SUS defined 'ready for writing' of select() as following.

|  A descriptor shall be considered ready for writing when a call to an output
|  function with O_NONBLOCK clear would not block, whether or not the function
|  would transfer data successfully.

That said, EPIPE situation is clearly one of 'ready for writing'.

We don't have read-side issue because tcp_poll() already has read side
shutdown care.

|        if (sk->sk_shutdown & RCV_SHUTDOWN)
|                mask |= POLLIN | POLLRDNORM | POLLRDHUP;

So, Let's insert same logic in write side.

- reference url
  http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/31065
  http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/31068

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/tcp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4fbf481..205ea31 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -453,7 +453,8 @@ unsigned int tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 				if (sk_stream_wspace(sk) >= sk_stream_min_wspace(sk))
 					mask |= POLLOUT | POLLWRNORM;
 			}
-		}
+		} else
+			mask |= POLLOUT | POLLWRNORM;
 
 		if (tp->urg_data & TCP_URG_VALID)
 			mask |= POLLPRI;
-- 
1.7.3.3

