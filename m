Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab0C3XT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:19:57 -0400
Received: from kroah.org ([198.145.64.141]:45559 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346Ab0C3XTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:06 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:57:12 2010
Message-Id: <20100330225712.379420548@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andrei Emeltchenko <andrei.emeltchenko@nokia.com>,
       "Gustavo F. Padovan" <gustavo@padovan.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [110/116] Bluetooth: Fix kernel crash on L2CAP stress tests
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>

commit c2c77ec83bdad17fb688557b5b3fdc36661dd1c6 upstream.

Added very simple check that req buffer has enough space to
fit configuration parameters. Shall be enough to reject packets
with configuration size more than req buffer.

Crash trace below

[ 6069.659393] Unable to handle kernel paging request at virtual address 02000205
[ 6069.673034] Internal error: Oops: 805 [#1] PREEMPT
...
[ 6069.727172] PC is at l2cap_add_conf_opt+0x70/0xf0 [l2cap]
[ 6069.732604] LR is at l2cap_recv_frame+0x1350/0x2e78 [l2cap]
...
[ 6070.030303] Backtrace:
[ 6070.032806] [<bf1c2880>] (l2cap_add_conf_opt+0x0/0xf0 [l2cap]) from
[<bf1c6624>] (l2cap_recv_frame+0x1350/0x2e78 [l2cap])
[ 6070.043823]  r8:dc5d3100 r7:df2a91d6 r6:00000001 r5:df2a8000 r4:00000200
[ 6070.050659] [<bf1c52d4>] (l2cap_recv_frame+0x0/0x2e78 [l2cap]) from
[<bf1c8408>] (l2cap_recv_acldata+0x2bc/0x350 [l2cap])
[ 6070.061798] [<bf1c814c>] (l2cap_recv_acldata+0x0/0x350 [l2cap]) from
[<bf0037a4>] (hci_rx_task+0x244/0x478 [bluetooth])
[ 6070.072631]  r6:dc647700 r5:00000001 r4:df2ab740
[ 6070.077362] [<bf003560>] (hci_rx_task+0x0/0x478 [bluetooth]) from
[<c006b9fc>] (tasklet_action+0x78/0xd8)
[ 6070.087005] [<c006b984>] (tasklet_action+0x0/0xd8) from [<c006c160>]

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
Acked-by: Gustavo F. Padovan <gustavo@padovan.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bluetooth/l2cap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -2813,6 +2813,11 @@ static inline int l2cap_config_rsp(struc
 			int len = cmd->len - sizeof(*rsp);
 			char req[64];
 
+			if (len > sizeof(req) - sizeof(struct l2cap_conf_req)) {
+				l2cap_send_disconn_req(conn, sk);
+				goto done;
+			}
+
 			/* throw out any old stored conf requests */
 			result = L2CAP_CONF_SUCCESS;
 			len = l2cap_parse_conf_rsp(sk, rsp->data,


