Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab0LHA7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:45 -0500
Received: from kroah.org ([198.145.64.141]:48574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756842Ab0LHA7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:42 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:26 2010
Message-Id: <20101208005726.158366461@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amod Bodas <amod.bodas@atheros.com>,
        Vasanth Thiagarajan <vasanth.thiagarajan@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [048/289] mac80211: fix offchannel assumption upon association
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 8d4780eb1ece4e8109b4f6b2e5e61f7fc593c3f4 upstream.

Association is dealt with as an atomic offchannel operation,
we do this because we don't know we are associated until we
get the associatin response from the AP. When we do get the
associatin response though we were never clearing the offchannel
state. This has a few implications, we told drivers we were
still offchannel, and the first configured TX power for the
channel does not take into account any power constraints.

For ath9k this meant ANI calibration would not start upon
association, and we'd have to wait until the first bgscan
to be triggered. There may be other issues this resolves
but I'm too lazy to comb the code to check.

Cc: Amod Bodas <amod.bodas@atheros.com>
Cc: Vasanth Thiagarajan <vasanth.thiagarajan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -108,7 +108,8 @@ int ieee80211_hw_config(struct ieee80211
 		chan = scan_chan;
 		channel_type = NL80211_CHAN_NO_HT;
 		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
-	} else if (local->tmp_channel) {
+	} else if (local->tmp_channel &&
+		   local->oper_channel != local->tmp_channel) {
 		chan = scan_chan = local->tmp_channel;
 		channel_type = local->tmp_channel_type;
 		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;


