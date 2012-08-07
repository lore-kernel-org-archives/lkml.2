Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031368Ab2HGWv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:51:29 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42489 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031278Ab2HGWrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:47:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Kosina <jkosina@suse.cz>, "David S. Miller" <davem@davemloft.net>
Subject: [ 38/49] tcp: perform DMA to userspace only if there is a task waiting for it
Date: Tue,  7 Aug 2012 15:44:56 -0700
Message-Id: <20120807222030.278765685@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jiri Kosina <jkosina@suse.cz>

[ Upstream commit 59ea33a68a9083ac98515e4861c00e71efdc49a1 ]

Back in 2006, commit 1a2449a87b ("[I/OAT]: TCP recv offload to I/OAT")
added support for receive offloading to IOAT dma engine if available.

The code in tcp_rcv_established() tries to perform early DMA copy if
applicable. It however does so without checking whether the userspace
task is actually expecting the data in the buffer.

This is not a problem under normal circumstances, but there is a corner
case where this doesn't work -- and that's when MSG_TRUNC flag to
recvmsg() is used.

If the IOAT dma engine is not used, the code properly checks whether
there is a valid ucopy.task and the socket is owned by userspace, but
misses the check in the dmaengine case.

This problem can be observed in real trivially -- for example 'tbench' is a
good reproducer, as it makes a heavy use of MSG_TRUNC. On systems utilizing
IOAT, you will soon find tbench waiting indefinitely in sk_wait_data(), as they
have been already early-copied in tcp_rcv_established() using dma engine.

This patch introduces the same check we are performing in the simple
iovec copy case to the IOAT case as well. It fixes the indefinite
recvmsg(MSG_TRUNC) hangs.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5340,7 +5340,9 @@ int tcp_rcv_established(struct sock *sk,
 			if (tp->copied_seq == tp->rcv_nxt &&
 			    len - tcp_header_len <= tp->ucopy.len) {
 #ifdef CONFIG_NET_DMA
-				if (tcp_dma_try_early_copy(sk, skb, tcp_header_len)) {
+				if (tp->ucopy.task == current &&
+				    sock_owned_by_user(sk) &&
+				    tcp_dma_try_early_copy(sk, skb, tcp_header_len)) {
 					copied_early = 1;
 					eaten = 1;
 				}


