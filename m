Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab2KVVgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:36:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:49643 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117Ab2KVSka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Szymon Janc <szymon.janc@tieto.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 74/83] NFC: Use dynamic initialization for rwlocks
Date: Wed, 21 Nov 2012 16:42:36 -0800
Message-Id: <20121122004220.614115448@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Szymon Janc <szymon.janc@tieto.com>

commit fe235b58d517d623bf6d40c77afca1b0ee6fc85d upstream.

If rwlock is dynamically allocated but statically initialized it is
missing proper lockdep annotation.

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
Pid: 3352, comm: neard Not tainted 3.5.0-999-nfc+ #2
Call Trace:
[<ffffffff810c8526>] __lock_acquire+0x8f6/0x1bf0
[<ffffffff81739045>] ? printk+0x4d/0x4f
[<ffffffff810c9eed>] lock_acquire+0x9d/0x220
[<ffffffff81702bfe>] ? nfc_llcp_sock_from_sn+0x4e/0x160
[<ffffffff81746724>] _raw_read_lock+0x44/0x60
[<ffffffff81702bfe>] ? nfc_llcp_sock_from_sn+0x4e/0x160
[<ffffffff81702bfe>] nfc_llcp_sock_from_sn+0x4e/0x160
[<ffffffff817034a7>] nfc_llcp_get_sdp_ssap+0xa7/0x1b0
[<ffffffff81706353>] llcp_sock_bind+0x173/0x210
[<ffffffff815d9c94>] sys_bind+0xe4/0x100
[<ffffffff8139209e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[<ffffffff8174ea69>] system_call_fastpath+0x16/0x1b

Signed-off-by: Szymon Janc <szymon.janc@tieto.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/nfc/llcp/llcp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -1182,8 +1182,8 @@ int nfc_llcp_register_device(struct nfc_
 		goto err_rx_wq;
 	}
 
-	local->sockets.lock = __RW_LOCK_UNLOCKED(local->sockets.lock);
-	local->connecting_sockets.lock = __RW_LOCK_UNLOCKED(local->connecting_sockets.lock);
+	rwlock_init(&local->sockets.lock);
+	rwlock_init(&local->connecting_sockets.lock);
 
 	nfc_llcp_build_gb(local);
 


