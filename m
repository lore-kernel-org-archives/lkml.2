Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab1BPAT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:19:28 -0500
Received: from kroah.org ([198.145.64.141]:38829 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab1BPATX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:30 2011
Message-Id: <20110216001430.195331271@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [051/272] mac80211: add missing synchronize_rcu
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit d2460f4b2fa6dbdeec800414f9cf5b1fc8b71197 upstream.

commit ad0e2b5a00dbec303e4682b403bb6703d11dcdb2
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Tue Jun 1 10:19:19 2010 +0200

    mac80211: simplify key locking

removed the synchronization against RCU and thus
opened a race window where we can use a key for
TX while it is already freed. Put a synchronisation
into the right place to close that window.

Reported-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>

---
 net/mac80211/key.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -366,6 +366,12 @@ static void __ieee80211_key_destroy(stru
 	if (!key)
 		return;
 
+	/*
+	 * Synchronize so the TX path can no longer be using
+	 * this key before we free/remove it.
+	 */
+	synchronize_rcu();
+
 	if (key->local)
 		ieee80211_key_disable_hw_accel(key);
 


