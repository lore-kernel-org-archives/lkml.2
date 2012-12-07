Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423998Ab2LGBEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:04:16 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:43888 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423573Ab2LGBAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:00:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Felix Liao <Felix.Liao@watchguard.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 14/27] mac80211: fix remain-on-channel (non-)cancelling
Date: Thu,  6 Dec 2012 16:58:58 -0800
Message-Id: <20121207005829.826364131@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 6bdd253f635f7b2ef027d116933a6c9ec148b87f upstream.

Felix Liao reported that when an interface is set DOWN
while another interface is executing a ROC, the warning
in ieee80211_start_next_roc() (about the first item on
the list having started already) triggers.

This is because ieee80211_roc_purge() calls it even if
it never actually changed the list of ROC items. To fix
this, simply remove the function call. If it is needed
then it will be done by the ieee80211_sw_roc_work()
function when the ROC item that is being removed while
active is cleaned up.

Reported-by: Felix Liao <Felix.Liao@watchguard.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/offchannel.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -453,8 +453,6 @@ void ieee80211_roc_purge(struct ieee8021
 		list_move_tail(&roc->list, &tmp_list);
 		roc->abort = true;
 	}
-
-	ieee80211_start_next_roc(local);
 	mutex_unlock(&local->mtx);
 
 	list_for_each_entry_safe(roc, tmp, &tmp_list, list) {


