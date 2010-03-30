Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab0C3XcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:32:06 -0400
Received: from kroah.org ([198.145.64.141]:46587 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab0C3XVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:31 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:38 2010
Message-Id: <20100330224838.272240842@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Chapman <jchapman@katalix.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [119/156] l2tp: Fix UDP socket reference count bugs in the pppol2tp driver
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Chapman <jchapman@katalix.com>

[ Upstream commit c3259c8a7060d480e8eb2166da0a99d6879146b4 ]

This patch fixes UDP socket refcnt bugs in the pppol2tp driver.

A bug can cause a kernel stack trace when a tunnel socket is closed.

A way to reproduce the issue is to prepare the UDP socket for L2TP (by
opening a tunnel pppol2tp socket) and then close it before any L2TP
sessions are added to it. The sequence is

Create UDP socket
Create tunnel pppol2tp socket to prepare UDP socket for L2TP
  pppol2tp_connect: session_id=0, peer_session_id=0
L2TP SCCRP control frame received (tunnel_id==0)
  pppol2tp_recv_core: sock_hold()
  pppol2tp_recv_core: sock_put
L2TP ZLB control frame received (tunnel_id=nnn)
  pppol2tp_recv_core: sock_hold()
  pppol2tp_recv_core: sock_put
Close tunnel management socket
  pppol2tp_release: session_id=0, peer_session_id=0
Close UDP socket
  udp_lib_close: BUG

The addition of sock_hold() in pppol2tp_connect() solves the problem.

For data frames, two sock_put() calls were added to plug a refcnt leak
per received data frame. The ref that is grabbed at the top of
pppol2tp_recv_core() must always be released, but this wasn't done for
accepted data frames or data frames discarded because of bad UDP
checksums. This leak meant that any UDP socket that had passed L2TP
data traffic (i.e. L2TP data frames, not just L2TP control frames)
using pppol2tp would not be released by the kernel.

WARNING: at include/net/sock.h:435 udp_lib_unhash+0x117/0x120()
Pid: 1086, comm: openl2tpd Not tainted 2.6.33-rc1 #8
Call Trace:
 [<c119e9b7>] ? udp_lib_unhash+0x117/0x120
 [<c101b871>] ? warn_slowpath_common+0x71/0xd0
 [<c119e9b7>] ? udp_lib_unhash+0x117/0x120
 [<c101b8e3>] ? warn_slowpath_null+0x13/0x20
 [<c119e9b7>] ? udp_lib_unhash+0x117/0x120
 [<c11598a7>] ? sk_common_release+0x17/0x90
 [<c11a5e33>] ? inet_release+0x33/0x60
 [<c11577b0>] ? sock_release+0x10/0x60
 [<c115780f>] ? sock_close+0xf/0x30
 [<c106e542>] ? __fput+0x52/0x150
 [<c106b68e>] ? filp_close+0x3e/0x70
 [<c101d2e2>] ? put_files_struct+0x62/0xb0
 [<c101eaf7>] ? do_exit+0x5e7/0x650
 [<c1081623>] ? mntput_no_expire+0x13/0x70
 [<c106b68e>] ? filp_close+0x3e/0x70
 [<c101eb8a>] ? do_group_exit+0x2a/0x70
 [<c101ebe1>] ? sys_exit_group+0x11/0x20
 [<c10029b0>] ? sysenter_do_call+0x12/0x26

Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/pppol2tp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -756,6 +756,7 @@ static int pppol2tp_recv_core(struct soc
 
 	/* Try to dequeue as many skbs from reorder_q as we can. */
 	pppol2tp_recv_dequeue(session);
+	sock_put(sock);
 
 	return 0;
 
@@ -772,6 +773,7 @@ discard_bad_csum:
 	UDP_INC_STATS_USER(&init_net, UDP_MIB_INERRORS, 0);
 	tunnel->stats.rx_errors++;
 	kfree_skb(skb);
+	sock_put(sock);
 
 	return 0;
 
@@ -1662,6 +1664,7 @@ static int pppol2tp_connect(struct socke
 		if (tunnel_sock == NULL)
 			goto end;
 
+		sock_hold(tunnel_sock);
 		tunnel = tunnel_sock->sk_user_data;
 	} else {
 		tunnel = pppol2tp_tunnel_find(sock_net(sk), sp->pppol2tp.s_tunnel);


