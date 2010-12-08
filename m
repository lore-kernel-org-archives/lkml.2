Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab0LHA75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:57 -0500
Received: from kroah.org ([198.145.64.141]:48635 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab0LHA7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:53 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:27 2010
Message-Id: <20101208005727.328517812@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [060/289] mac80211: delete AddBA response timer
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 44271488b91c9eecf249e075a1805dd887e222d2 upstream.

We never delete the addBA response timer, which
is typically fine, but if the station it belongs
to is deleted very quickly after starting the BA
session, before the peer had a chance to reply,
the timer may fire after the station struct has
been freed already. Therefore, we need to delete
the timer in a suitable spot -- best when the
session is being stopped (which will happen even
then) in which case the delete will be a no-op
most of the time.

I've reproduced the scenario and tested the fix.

This fixes the crash reported at
http://mid.gmane.org/4CAB6F96.6090701@candelatech.com

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/agg-tx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -177,6 +177,8 @@ int ___ieee80211_stop_tx_ba_session(stru
 
 	del_timer_sync(&tid_tx->addba_resp_timer);
 
+	del_timer_sync(&tid_tx->addba_resp_timer);
+
 	/*
 	 * After this packets are no longer handed right through
 	 * to the driver but are put onto tid_tx->pending instead,


