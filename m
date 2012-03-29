Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab2C2BTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:19:35 -0400
Received: from home.keithp.com ([63.227.221.253]:59815 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757915Ab2C2BT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:19:29 -0400
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH] Revert "Bluetooth: Always enable management interface"
Date: Wed, 28 Mar 2012 18:19:18 -0700
Message-Id: <1332983958-2734-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 4b95a24ce12c4545fd7d2e3075841dc3119d1d71.

My USB bluetooth device does not show up with this patch in place.

Signed-off-by: Keith Packard <keithp@keithp.com>
---

This patch seems so innocuous, but when added to the kernel, it keeps
my USB bluetooth device from appearing to user mode at all. With the
mgmt interface enabled:

	$ hcitool dev
	Devices:

With this patch reverted:

	$ hcitool dev
	Devices:
		hci0	04:0C:CE:DF:7B:C9

I bisected to this revision, and then reverted it on top of version

	v3.3-6972-ge22057c	e22057c8599373e5caef0bc42bdb95d2a361ab0d

(which is where I'm trying to move drm-intel-fixes to)

I think this is the third consecutive merge window that has broken my
bluetooth interface in some way? At least I know enough to check
now...

 net/bluetooth/hci_sock.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 63afd23..d8b16cf 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -50,6 +50,8 @@
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/hci_mon.h>
 
+static bool enable_mgmt;
+
 static atomic_t monitor_promisc = ATOMIC_INIT(0);
 
 /* ----- HCI socket interface ----- */
@@ -649,7 +651,7 @@ static int hci_sock_bind(struct socket *sock, struct sockaddr *addr, int addr_le
 		break;
 
 	case HCI_CHANNEL_CONTROL:
-		if (haddr.hci_dev != HCI_DEV_NONE) {
+		if (haddr.hci_dev != HCI_DEV_NONE || !enable_mgmt) {
 			err = -EINVAL;
 			goto done;
 		}
@@ -1127,3 +1129,6 @@ void hci_sock_cleanup(void)
 
 	proto_unregister(&hci_sk_proto);
 }
+
+module_param(enable_mgmt, bool, 0644);
+MODULE_PARM_DESC(enable_mgmt, "Enable Management interface");
-- 
1.7.9

