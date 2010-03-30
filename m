Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab0CaAlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:41:15 -0400
Received: from kroah.org ([198.145.64.141]:48445 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab0C3XI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:08:59 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:48 2010
Message-Id: <20100330224947.910378595@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Varga <nite@hq.alert.sk>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [14/45] tcp: fix CONFIG_TCP_MD5SIG + CONFIG_PREEMPT timer BUG()
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robert Varga <nite@hq.alert.sk>

commit 657e9649e745b06675aa5063c84430986cdc3afa upstream.

I have recently came across a preemption imbalance detected by:

<4>huh, entered ffffffff80644630 with preempt_count 00000102, exited with 00000101?
<0>------------[ cut here ]------------
<2>kernel BUG at /usr/src/linux/kernel/timer.c:664!
<0>invalid opcode: 0000 [1] PREEMPT SMP

with ffffffff80644630 being inet_twdr_hangman().

This appeared after I enabled CONFIG_TCP_MD5SIG and played with it a
bit, so I looked at what might have caused it.

One thing that struck me as strange is tcp_twsk_destructor(), as it
calls tcp_put_md5sig_pool() -- which entails a put_cpu(), causing the
detected imbalance. Found on 2.6.23.9, but 2.6.31 is affected as well,
as far as I can tell.

Signed-off-by: Robert Varga <nite@hq.alert.sk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_minisocks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -362,7 +362,7 @@ void tcp_twsk_destructor(struct sock *sk
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_timewait_sock *twsk = tcp_twsk(sk);
 	if (twsk->tw_md5_keylen)
-		tcp_put_md5sig_pool();
+		tcp_free_md5sig_pool();
 #endif
 }
 


