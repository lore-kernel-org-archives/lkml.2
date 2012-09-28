Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031023Ab2I1TRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:17:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759083Ab2I1TFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:05:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andre Guedes <andre.guedes@openbossa.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 222/262] Bluetooth: Fix use-after-free bug in SMP
Date: Fri, 28 Sep 2012 11:52:31 -0700
Message-Id: <20120928183024.428830964@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Guedes <andre.guedes@openbossa.org>

commit 61a0cfb008f57ecf7eb28ee762952fb42dc15d15 upstream.

If SMP fails, we should always cancel security_timer delayed work.
Otherwise, security_timer function may run after l2cap_conn object
has been freed.

This patch fixes the following warning reported by ODEBUG:

WARNING: at lib/debugobjects.c:261 debug_print_object+0x7c/0x8d()
Hardware name: Bochs
ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x27
Modules linked in: btusb bluetooth
Pid: 440, comm: kworker/u:2 Not tainted 3.5.0-rc1+ #4
Call Trace:
 [<ffffffff81174600>] ? free_obj_work+0x4a/0x7f
 [<ffffffff81023eb8>] warn_slowpath_common+0x7e/0x97
 [<ffffffff81023f65>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff811746b1>] debug_print_object+0x7c/0x8d
 [<ffffffff810394f0>] ? __queue_work+0x241/0x241
 [<ffffffff81174fdd>] debug_check_no_obj_freed+0x92/0x159
 [<ffffffff810ac08e>] slab_free_hook+0x6f/0x77
 [<ffffffffa0019145>] ? l2cap_conn_del+0x148/0x157 [bluetooth]
 [<ffffffff810ae408>] kfree+0x59/0xac
 [<ffffffffa0019145>] l2cap_conn_del+0x148/0x157 [bluetooth]
 [<ffffffffa001b9a2>] l2cap_recv_frame+0xa77/0xfa4 [bluetooth]
 [<ffffffff810592f9>] ? trace_hardirqs_on_caller+0x112/0x1ad
 [<ffffffffa001c86c>] l2cap_recv_acldata+0xe2/0x264 [bluetooth]
 [<ffffffffa0002b2f>] hci_rx_work+0x235/0x33c [bluetooth]
 [<ffffffff81038dc3>] ? process_one_work+0x126/0x2fe
 [<ffffffff81038e22>] process_one_work+0x185/0x2fe
 [<ffffffff81038dc3>] ? process_one_work+0x126/0x2fe
 [<ffffffff81059f2e>] ? lock_acquired+0x1b5/0x1cf
 [<ffffffffa00028fa>] ? le_scan_work+0x11d/0x11d [bluetooth]
 [<ffffffff81036fb6>] ? spin_lock_irq+0x9/0xb
 [<ffffffff81039209>] worker_thread+0xcf/0x175
 [<ffffffff8103913a>] ? rescuer_thread+0x175/0x175
 [<ffffffff8103cfe0>] kthread+0x95/0x9d
 [<ffffffff812c5054>] kernel_threadi_helper+0x4/0x10
 [<ffffffff812c36b0>] ? retint_restore_args+0x13/0x13
 [<ffffffff8103cf4b>] ? flush_kthread_worker+0xdb/0xdb
 [<ffffffff812c5050>] ? gs_change+0x13/0x13

This bug can be reproduced using hctool lecc or l2test tools and
bluetoothd not running.

Signed-off-by: Andre Guedes <andre.guedes@openbossa.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/smp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -266,10 +266,10 @@ static void smp_failure(struct l2cap_con
 	mgmt_auth_failed(conn->hcon->hdev, conn->dst, hcon->type,
 			 hcon->dst_type, reason);
 
-	if (test_and_clear_bit(HCI_CONN_LE_SMP_PEND, &conn->hcon->flags)) {
-		cancel_delayed_work_sync(&conn->security_timer);
+	cancel_delayed_work_sync(&conn->security_timer);
+
+	if (test_and_clear_bit(HCI_CONN_LE_SMP_PEND, &conn->hcon->flags))
 		smp_chan_destroy(conn);
-	}
 }
 
 #define JUST_WORKS	0x00


