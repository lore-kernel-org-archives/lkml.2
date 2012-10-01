Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644Ab2JAXgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:36:00 -0400
Received: from 1wt.eu ([62.212.114.60]:35084 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612Ab2JAXAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:07 -0400
Message-Id: <20121001225200.827014556@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:13 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>,
        =?ISO-8859-15?q?R=E9mi=20Denis-Courmont?= 
	<remi.denis-courmont@nokia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 076/180] phonet: Check input from user before allocating
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <levinsasha928@gmail.com>

[ Upstream commit bcf1b70ac6eb0ed8286c66e6bf37cb747cbaa04c ]

A phonet packet is limited to USHRT_MAX bytes, this is never checked during
tx which means that the user can specify any size he wishes, and the kernel
will attempt to allocate that size.

In the good case, it'll lead to the following warning, but it may also cause
the kernel to kick in the OOM and kill a random task on the server.

[ 8921.744094] WARNING: at mm/page_alloc.c:2255 __alloc_pages_slowpath+0x65/0x730()
[ 8921.749770] Pid: 5081, comm: trinity Tainted: G        W    3.4.0-rc1-next-20120402-sasha #46
[ 8921.756672] Call Trace:
[ 8921.758185]  [<ffffffff810b2ba7>] warn_slowpath_common+0x87/0xb0
[ 8921.762868]  [<ffffffff810b2be5>] warn_slowpath_null+0x15/0x20
[ 8921.765399]  [<ffffffff8117eae5>] __alloc_pages_slowpath+0x65/0x730
[ 8921.769226]  [<ffffffff81179c8a>] ? zone_watermark_ok+0x1a/0x20
[ 8921.771686]  [<ffffffff8117d045>] ? get_page_from_freelist+0x625/0x660
[ 8921.773919]  [<ffffffff8117f3a8>] __alloc_pages_nodemask+0x1f8/0x240
[ 8921.776248]  [<ffffffff811c03e0>] kmalloc_large_node+0x70/0xc0
[ 8921.778294]  [<ffffffff811c4bd4>] __kmalloc_node_track_caller+0x34/0x1c0
[ 8921.780847]  [<ffffffff821b0e3c>] ? sock_alloc_send_pskb+0xbc/0x260
[ 8921.783179]  [<ffffffff821b3c65>] __alloc_skb+0x75/0x170
[ 8921.784971]  [<ffffffff821b0e3c>] sock_alloc_send_pskb+0xbc/0x260
[ 8921.787111]  [<ffffffff821b002e>] ? release_sock+0x7e/0x90
[ 8921.788973]  [<ffffffff821b0ff0>] sock_alloc_send_skb+0x10/0x20
[ 8921.791052]  [<ffffffff824cfc20>] pep_sendmsg+0x60/0x380
[ 8921.792931]  [<ffffffff824cb4a6>] ? pn_socket_bind+0x156/0x180
[ 8921.794917]  [<ffffffff824cb50f>] ? pn_socket_autobind+0x3f/0x90
[ 8921.797053]  [<ffffffff824cb63f>] pn_socket_sendmsg+0x4f/0x70
[ 8921.798992]  [<ffffffff821ab8e7>] sock_aio_write+0x187/0x1b0
[ 8921.801395]  [<ffffffff810e325e>] ? sub_preempt_count+0xae/0xf0
[ 8921.803501]  [<ffffffff8111842c>] ? __lock_acquire+0x42c/0x4b0
[ 8921.805505]  [<ffffffff821ab760>] ? __sock_recv_ts_and_drops+0x140/0x140
[ 8921.807860]  [<ffffffff811e07cc>] do_sync_readv_writev+0xbc/0x110
[ 8921.809986]  [<ffffffff811958e7>] ? might_fault+0x97/0xa0
[ 8921.811998]  [<ffffffff817bd99e>] ? security_file_permission+0x1e/0x90
[ 8921.814595]  [<ffffffff811e17e2>] do_readv_writev+0xe2/0x1e0
[ 8921.816702]  [<ffffffff810b8dac>] ? do_setitimer+0x1ac/0x200
[ 8921.818819]  [<ffffffff810e2ec1>] ? get_parent_ip+0x11/0x50
[ 8921.820863]  [<ffffffff810e325e>] ? sub_preempt_count+0xae/0xf0
[ 8921.823318]  [<ffffffff811e1926>] vfs_writev+0x46/0x60
[ 8921.825219]  [<ffffffff811e1a3f>] sys_writev+0x4f/0xb0
[ 8921.827127]  [<ffffffff82658039>] system_call_fastpath+0x16/0x1b
[ 8921.829384] ---[ end trace dffe390f30db9eb7 ]---

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Acked-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/phonet/pep.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 9cdd35e..7481d70 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -851,6 +851,9 @@ static int pep_sendmsg(struct kiocb *iocb, struct sock *sk,
 	int flags = msg->msg_flags;
 	int err, done;
 
+	if (len > 65535)
+		return -EMSGSIZE;
+
 	if (msg->msg_flags & MSG_OOB || !(msg->msg_flags & MSG_EOR))
 		return -EOPNOTSUPP;
 
-- 
1.7.2.1.45.g54fbc



