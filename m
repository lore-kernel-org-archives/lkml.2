Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934073Ab3AIUlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:41:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:43886 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934057Ab3AIUlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:41:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sasha Levin <sasha.levin@oracle.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 110/123] Bluetooth: cancel power_on work when unregistering the device
Date: Wed,  9 Jan 2013 12:35:49 -0800
Message-Id: <20130109201512.566611776@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

commit b9b5ef188e5a2222cfc16ef62a4703080750b451 upstream.

We need to cancel the hci_power_on work in order to avoid it run when we
try to free the hdev.

[ 1434.201149] ------------[ cut here ]------------
[ 1434.204998] WARNING: at lib/debugobjects.c:261 debug_print_object+0x8e/0xb0()
[ 1434.208324] ODEBUG: free active (active state 0) object type: work_struct hint: hci
_power_on+0x0/0x90
[ 1434.210386] Pid: 8564, comm: trinity-child25 Tainted: G        W    3.7.0-rc5-next-
20121112-sasha-00018-g2f4ce0e #127
[ 1434.210760] Call Trace:
[ 1434.210760]  [<ffffffff819f3d6e>] ? debug_print_object+0x8e/0xb0
[ 1434.210760]  [<ffffffff8110b887>] warn_slowpath_common+0x87/0xb0
[ 1434.210760]  [<ffffffff8110b911>] warn_slowpath_fmt+0x41/0x50
[ 1434.210760]  [<ffffffff819f3d6e>] debug_print_object+0x8e/0xb0
[ 1434.210760]  [<ffffffff8376b750>] ? hci_dev_open+0x310/0x310
[ 1434.210760]  [<ffffffff83bf94e5>] ? _raw_spin_unlock_irqrestore+0x55/0xa0
[ 1434.210760]  [<ffffffff819f3ee5>] __debug_check_no_obj_freed+0xa5/0x230
[ 1434.210760]  [<ffffffff83785db0>] ? bt_host_release+0x10/0x20
[ 1434.210760]  [<ffffffff819f4d15>] debug_check_no_obj_freed+0x15/0x20
[ 1434.210760]  [<ffffffff8125eee7>] kfree+0x227/0x330
[ 1434.210760]  [<ffffffff83785db0>] bt_host_release+0x10/0x20
[ 1434.210760]  [<ffffffff81e539e5>] device_release+0x65/0xc0
[ 1434.210760]  [<ffffffff819d3975>] kobject_cleanup+0x145/0x190
[ 1434.210760]  [<ffffffff819d39cd>] kobject_release+0xd/0x10
[ 1434.210760]  [<ffffffff819d33cc>] kobject_put+0x4c/0x60
[ 1434.210760]  [<ffffffff81e548b2>] put_device+0x12/0x20
[ 1434.210760]  [<ffffffff8376a334>] hci_free_dev+0x24/0x30
[ 1434.210760]  [<ffffffff82fd8fe1>] vhci_release+0x31/0x60
[ 1434.210760]  [<ffffffff8127be12>] __fput+0x122/0x250
[ 1434.210760]  [<ffffffff811cab0d>] ? rcu_user_exit+0x9d/0xd0
[ 1434.210760]  [<ffffffff8127bf49>] ____fput+0x9/0x10
[ 1434.210760]  [<ffffffff81133402>] task_work_run+0xb2/0xf0
[ 1434.210760]  [<ffffffff8106cfa7>] do_notify_resume+0x77/0xa0
[ 1434.210760]  [<ffffffff83bfb0ea>] int_signal+0x12/0x17
[ 1434.210760] ---[ end trace a6d57fefbc8a8cc7 ]---

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1793,6 +1793,8 @@ void hci_unregister_dev(struct hci_dev *
 	for (i = 0; i < NUM_REASSEMBLY; i++)
 		kfree_skb(hdev->reassembly[i]);
 
+	cancel_work_sync(&hdev->power_on);
+
 	if (!test_bit(HCI_INIT, &hdev->flags) &&
 	    !test_bit(HCI_SETUP, &hdev->dev_flags)) {
 		hci_dev_lock(hdev);


