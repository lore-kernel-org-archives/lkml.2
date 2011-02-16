Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab1BPATc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:19:32 -0500
Received: from kroah.org ([198.145.64.141]:38843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab1BPAT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:30 2011
Message-Id: <20110216001430.426961273@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [053/272] mac80211: fix a crash in ieee80211_beacon_get_tim on change_interface
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit eb3e554b4b3a56386ef5214dbe0e3935a350178b upstream.

Some drivers (e.g. ath9k) do not always disable beacons when they're
supposed to. When an interface is changed using the change_interface op,
the mode specific sdata part is in an undefined state and trying to
get a beacon at this point can produce weird crashes.

To fix this, add a check for ieee80211_sdata_running before using
anything from the sdata.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/tx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2207,6 +2207,9 @@ struct sk_buff *ieee80211_beacon_get_tim
 
 	sdata = vif_to_sdata(vif);
 
+	if (!ieee80211_sdata_running(sdata))
+		goto out;
+
 	if (tim_offset)
 		*tim_offset = 0;
 	if (tim_length)


