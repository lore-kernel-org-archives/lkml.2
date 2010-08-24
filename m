Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab0HXXHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:07:52 -0400
Received: from kroah.org ([198.145.64.141]:32848 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933689Ab0HXXDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:40 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:10 2010
Message-Id: <20100824224510.037385334@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sven Eckelmann <sven.eckelmann@gmx.de>
Subject: [101/114] Staging: batman-adv: Dont write in not allocated packet_buff
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sven Eckelmann <sven.eckelmann@gmx.de>

commit f86b9984250fa2b71ce36d4693a939a58579583b upstream.

Each net_device in a system will automatically managed as a possible
batman_if and holds different informations like a buffer with a prepared
originator messages. To reduce the memory usage, the packet_buff will
only be allocated when the interface is really added/enabled for
batman-adv.

The function to update the hw address information inside the packet_buff
just assumes that the packet_buff is always initialised and thus the
kernel will just oops when we try to change the hw address of a not
already fully enabled interface.

We must always check if the packet_buff is allocated before we try to
change information inside of it.

Reported-by: Tim Glaremin <Tim.Glaremin@web.de>
Reported-by: Kazuki Shimada <zukky@bb.banban.jp>
Signed-off-by: Sven Eckelmann <sven.eckelmann@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/batman-adv/hard-interface.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/staging/batman-adv/hard-interface.c
+++ b/drivers/staging/batman-adv/hard-interface.c
@@ -128,6 +128,9 @@ static bool hardif_is_iface_up(struct ba
 
 static void update_mac_addresses(struct batman_if *batman_if)
 {
+	if (!batman_if || !batman_if->packet_buff)
+		return;
+
 	addr_to_string(batman_if->addr_str, batman_if->net_dev->dev_addr);
 
 	memcpy(((struct batman_packet *)(batman_if->packet_buff))->orig,
@@ -338,6 +341,7 @@ static struct batman_if *hardif_add_inte
 	batman_if->if_num = -1;
 	batman_if->net_dev = net_dev;
 	batman_if->if_status = IF_NOT_IN_USE;
+	batman_if->packet_buff = NULL;
 	INIT_LIST_HEAD(&batman_if->list);
 
 	check_known_mac_addr(batman_if->net_dev->dev_addr);


