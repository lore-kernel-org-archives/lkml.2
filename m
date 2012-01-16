Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab2APSxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:53:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43076 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598Ab2APStz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:49:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:19 2012
Message-Id: <20120116184519.576410596@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:45:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [46/48] mac80211: fix rx->key NULL pointer dereference in promiscuous mode
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 1140afa862842ac3e56678693050760edc4ecde9 upstream.

Since:

commit 816c04fe7ef01dd9649f5ccfe796474db8708be5
Author: Christian Lamparter <chunkeey@googlemail.com>
Date:   Sat Apr 30 15:24:30 2011 +0200

    mac80211: consolidate MIC failure report handling

is possible to that we dereference rx->key == NULL when driver set
RX_FLAG_MMIC_STRIPPED and not RX_FLAG_IV_STRIPPED and we are in
promiscuous mode. This happen with rt73usb and rt61pci at least.

Before the commit we always check rx->key against NULL, so I assume
fix should be done in mac80211 (also mic_fail path has similar check).

References:
https://bugzilla.redhat.com/show_bug.cgi?id=769766
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2012-January/004395.html

Reported-by: Stuart D Gathman <stuart@gathman.org>
Reported-by: Kai Wohlfahrt <kai.scorpio@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/wpa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -105,7 +105,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 		if (status->flag & RX_FLAG_MMIC_ERROR)
 			goto mic_fail;
 
-		if (!(status->flag & RX_FLAG_IV_STRIPPED))
+		if (!(status->flag & RX_FLAG_IV_STRIPPED) && rx->key)
 			goto update_iv;
 
 		return RX_CONTINUE;


