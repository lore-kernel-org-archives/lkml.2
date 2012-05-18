Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946444Ab2ERX0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:26:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65112 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946415Ab2ERXEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:04:31 -0400
Message-Id: <20120518211602.910347044@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Willy Tarreau <w@1wt.eu>,
        Eric Dumazet <edumazet@google.com>
Subject: [ 38/54] tcp: do_tcp_sendpages() must try to push data out on oom conditions
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -850,8 +850,7 @@ new_segment:
 wait_for_sndbuf:
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 wait_for_memory:
-		if (copied)
-			tcp_push(sk, flags & ~MSG_MORE, mss_now, TCP_NAGLE_PUSH);
+		tcp_push(sk, flags & ~MSG_MORE, mss_now, TCP_NAGLE_PUSH);
 
 		if ((err = sk_stream_wait_memory(sk, &timeo)) != 0)
 			goto do_error;


