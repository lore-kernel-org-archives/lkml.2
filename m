Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161612Ab1FAILj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:11:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:43435 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161598Ab1FAILa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:11:30 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:21 2011
Message-Id: <20110601080320.201293652@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:55 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jacek Luczak <luczak.jacek@gmail.com>,
        Vlad Yasevich <vladislav.yasevich@hp.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [059/146] SCTP: fix race between sctp_bind_addr_free() and sctp_bind_addr_conflict()
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jacek Luczak <difrost.kernel@gmail.com>

[ Upstream commit c182f90bc1f22ce5039b8722e45621d5f96862c2 ]

During the sctp_close() call, we do not use rcu primitives to
destroy the address list attached to the endpoint.  At the same
time, we do the removal of addresses from this list before
attempting to remove the socket from the port hash

As a result, it is possible for another process to find the socket
in the port hash that is in the process of being closed.  It then
proceeds to traverse the address list to find the conflict, only
to have that address list suddenly disappear without rcu() critical
section.

Fix issue by closing address list removal inside RCU critical
section.

Race can result in a kernel crash with general protection fault or
kernel NULL pointer dereference:

kernel: general protection fault: 0000 [#1] SMP
kernel: RIP: 0010:[<ffffffffa02f3dde>]  [<ffffffffa02f3dde>] sctp_bind_addr_conflict+0x64/0x82 [sctp]
kernel: Call Trace:
kernel:  [<ffffffffa02f415f>] ? sctp_get_port_local+0x17b/0x2a3 [sctp]
kernel:  [<ffffffffa02f3d45>] ? sctp_bind_addr_match+0x33/0x68 [sctp]
kernel:  [<ffffffffa02f4416>] ? sctp_do_bind+0xd3/0x141 [sctp]
kernel:  [<ffffffffa02f5030>] ? sctp_bindx_add+0x4d/0x8e [sctp]
kernel:  [<ffffffffa02f5183>] ? sctp_setsockopt_bindx+0x112/0x4a4 [sctp]
kernel:  [<ffffffff81089e82>] ? generic_file_aio_write+0x7f/0x9b
kernel:  [<ffffffffa02f763e>] ? sctp_setsockopt+0x14f/0xfee [sctp]
kernel:  [<ffffffff810c11fb>] ? do_sync_write+0xab/0xeb
kernel:  [<ffffffff810e82ab>] ? fsnotify+0x239/0x282
kernel:  [<ffffffff810c2462>] ? alloc_file+0x18/0xb1
kernel:  [<ffffffff8134a0b1>] ? compat_sys_setsockopt+0x1a5/0x1d9
kernel:  [<ffffffff8134aaf1>] ? compat_sys_socketcall+0x143/0x1a4
kernel:  [<ffffffff810467dc>] ? sysenter_dispatch+0x7/0x32

Signed-off-by: Jacek Luczak <luczak.jacek@gmail.com>
Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>
Reviewed-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sctp/bind_addr.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -140,14 +140,12 @@ void sctp_bind_addr_init(struct sctp_bin
 /* Dispose of the address list. */
 static void sctp_bind_addr_clean(struct sctp_bind_addr *bp)
 {
-	struct sctp_sockaddr_entry *addr;
-	struct list_head *pos, *temp;
+	struct sctp_sockaddr_entry *addr, *temp;
 
 	/* Empty the bind address list. */
-	list_for_each_safe(pos, temp, &bp->address_list) {
-		addr = list_entry(pos, struct sctp_sockaddr_entry, list);
-		list_del(pos);
-		kfree(addr);
+	list_for_each_entry_safe(addr, temp, &bp->address_list, list) {
+		list_del_rcu(&addr->list);
+		call_rcu(&addr->rcu, sctp_local_addr_free);
 		SCTP_DBG_OBJCNT_DEC(addr);
 	}
 }


