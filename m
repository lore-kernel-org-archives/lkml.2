Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215Ab1ESSJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:09:51 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48863 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934183Ab1ESSJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:09:42 -0400
X-Sasl-enc: MbM9m6yKYpLovfzbSeiTPXKumz1ZJvMpRd6s9VPObM01 1305828581
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:06:01 2011
Message-Id: <20110519180601.093375008@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [71/71] iwlegacy: fix IBSS mode crashes
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit eb85de3f84868ca85703a23617b4079ce79a801e upstream.

We should not switch to non-IBSS channels when working in IBSS mode,
otherwise there are microcode errors, and after some time system
crashes.

This bug is only observable when software scan is used in IBSS mode,
so should be considered as regression after:

commit 0263aa45293838b514b8af674a03faf040991a90
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Tue Mar 29 11:24:21 2011 +0200

    iwl3945: disable hw scan by default

However IBSS mode check, which this patch add again, was removed by

commit b2f30e8bdd8ef5f3b5a7ef9146509585a15347d3
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Jan 21 07:32:20 2010 -0800

    iwlwifi: remove IBSS channel sanity check

That commit claim that mac80211 will not use non-IBSS channel in IBSS
mode, what definitely is not true. Bug probably should be fixed in
mac80211, but that will require more work, so better to apply that patch
temporally, and provide proper mac80211 fix latter.

Resolves:
https://bugzilla.kernel.org/show_bug.cgi?id=34452

Reported-and-tested-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-legacy.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-legacy.c
+++ b/drivers/net/wireless/iwlwifi/iwl-legacy.c
@@ -123,6 +123,13 @@ int iwl_legacy_mac_config(struct ieee802
 			goto set_ch_out;
 		}
 
+		if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
+		    !is_channel_ibss(ch_info)) {
+			IWL_DEBUG_MAC80211(priv, "leave - not IBSS channel\n");
+			ret = -EINVAL;
+			goto set_ch_out;
+		}
+
 		spin_lock_irqsave(&priv->lock, flags);
 
 		for_each_context(priv, ctx) {


