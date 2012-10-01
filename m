Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965089Ab2JAXX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:23:56 -0400
Received: from 1wt.eu ([62.212.114.60]:35342 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932873Ab2JAXBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:20 -0400
Message-Id: <20121001225203.596263689@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>, Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 141/180] tcp: do_tcp_sendpages() must try to push data out on oom conditions
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Willy Tarreau <w@1wt.eu>

commit bad115cfe5b509043b684d3a007ab54b80090aa1 upstream.

Since recent changes on TCP splicing (starting with commits 2f533844
"tcp: allow splice() to build full TSO packets" and 35f9c09f "tcp:
tcp_sendpages() should call tcp_push() once"), I started seeing
massive stalls when forwarding traffic between two sockets using
splice() when pipe buffers were larger than socket buffers.

Latest changes (net: netdev_alloc_skb() use build_skb()) made the
problem even more apparent.

The reason seems to be that if do_tcp_sendpages() fails on out of memory
condition without being able to send at least one byte, tcp_push() is not
called and the buffers cannot be flushed.

After applying the attached patch, I cannot reproduce the stalls at all
and the data rate it perfectly stable and steady under any condition
which previously caused the problem to be permanent.

The issue seems to have been there since before the kernel migrated to
git, which makes me think that the stalls I occasionally experienced
with tux during stress-tests years ago were probably related to the
same issue.

This issue was first encountered on 3.0.31 and 3.2.17, so please backport
to -stable.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f095659..b9644d8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -838,8 +838,7 @@ new_segment:
 wait_for_sndbuf:
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 wait_for_memory:
-		if (copied)
-			tcp_push(sk, flags & ~MSG_MORE, mss_now, TCP_NAGLE_PUSH);
+		tcp_push(sk, flags & ~MSG_MORE, mss_now, TCP_NAGLE_PUSH);
 
 		if ((err = sk_stream_wait_memory(sk, &timeo)) != 0)
 			goto do_error;
-- 
1.7.2.1.45.g54fbc



