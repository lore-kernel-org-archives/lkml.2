Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab2EIGAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:00:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39169 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756865Ab2EIFxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:45 -0400
Message-Id: <20120509055049.606592242@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
        Dave Airlie <airlied@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 145/167] [PATCH] rtlwifi: Fix oops on unload
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 44eb65cfd8da4b9c231238998729e858e963a980 upstream.

Under some circumstances, a PCI-based driver reports the following OOPs:

Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Oops: 0000 [#1] SMP
--snip--
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Pid: 19627, comm: rmmod
Not tainted 3.2.9-2.fc16.x86_64 #1 LENOVO 05962RU/05962RU
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] RIP:
0010:[<ffffffffa0418d39>]  [<ffffffffa0418d39>]
rtl92ce_get_desc+0x19/0xd0 [rtl8192ce]
--snip--
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Process rmmod (pid:
19627, threadinfo ffff880050262000, task ffff8801156d5cc0)
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Stack:
Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  0000000000000002
ffff8801176c2540 ffff880050263ca8 ffffffffa03348e7
Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  0000000000000282
0000000180150014 ffff880050263fd8 ffff8801176c2810
Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  ffff880050263bc8
ffffffff810550e2 00000000000002c0 ffff8801176c0d40
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Call Trace:
Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffffa03348e7>]
_rtl_pci_rx_interrupt+0x187/0x650 [rtlwifi]
--snip--
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Code: ff 09 d0 89 07 48
83 c4 08 5b 5d c3 66 0f 1f 44 00 00 55 48 89 e5 53 48 83 ec 08 66 66
66 66 90 40 84 f6 89 d3 74 13 84 d2 75 57 <8b> 07 48 83 c4 08 5b 5d c1
e8 1f c3 0f 1f 00 84 d2 74 ed 80 fa
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] RIP
[<ffffffffa0418d39>] rtl92ce_get_desc+0x19/0xd0 [rtl8192ce]
Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  RSP <ffff880050263b58>
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] CR2: 00000000000006e0
Mar 19 08:14:35 kvothe kernel: [ 6584.646491] ---[ end trace
8636c766dcfbe0e6 ]---

This oops is due to interrupts not being disabled in this particular path.

Reported-by: Dave Airlie <airlied@gmail.com>
Tested-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rtlwifi/pci.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 288b035..cc15fdb 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1941,6 +1941,7 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
 		rtl_deinit_deferred_work(hw);
 		rtlpriv->intf_ops->adapter_stop(hw);
 	}
+	rtlpriv->cfg->ops->disable_interrupt(hw);
 
 	/*deinit rfkill */
 	rtl_deinit_rfkill(hw);
-- 
1.7.10



