Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab2AWXtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:49:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152Ab2AWXta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:49:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:25 2012
Message-Id: <20120123234025.586103450@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:39:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [31/90] mac80211: fix rx->key NULL pointer dereference in promiscuous mode
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -109,7 +109,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 		if (status->flag & RX_FLAG_MMIC_ERROR)
 			goto mic_fail;
 
-		if (!(status->flag & RX_FLAG_IV_STRIPPED))
+		if (!(status->flag & RX_FLAG_IV_STRIPPED) && rx->key)
 			goto update_iv;
 
 		return RX_CONTINUE;


