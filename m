Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab2HGW32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:29:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab2HGW3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:29:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 046/122] mac80211: fix crash with single-queue drivers
Date: Tue,  7 Aug 2012 15:25:34 -0700
Message-Id: <20120807221952.349761527@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit a6f38ac3cc853189705006cc1e0f17ce8467a1df upstream.

Larry (and some others I think) reported that with
single-queue drivers mac80211 crashes when waking
the queues. This happens because we allocate just
a single queue for each virtual interface in case
the driver doesn't have at least 4 queues, but the
code stopping/waking the virtual interface queues
wasn't taking this into account.

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/util.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -268,6 +268,10 @@ EXPORT_SYMBOL(ieee80211_ctstoself_durati
 void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 {
 	struct ieee80211_sub_if_data *sdata;
+	int n_acs = IEEE80211_NUM_ACS;
+
+	if (local->hw.queues < IEEE80211_NUM_ACS)
+		n_acs = 1;
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		int ac;
@@ -279,7 +283,7 @@ void ieee80211_propagate_queue_wake(stru
 		    local->queue_stop_reasons[sdata->vif.cab_queue] != 0)
 			continue;
 
-		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		for (ac = 0; ac < n_acs; ac++) {
 			int ac_queue = sdata->vif.hw_queue[ac];
 
 			if (ac_queue == queue ||
@@ -341,6 +345,7 @@ static void __ieee80211_stop_queue(struc
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
+	int n_acs = IEEE80211_NUM_ACS;
 
 	trace_stop_queue(local, queue, reason);
 
@@ -352,11 +357,14 @@ static void __ieee80211_stop_queue(struc
 
 	__set_bit(reason, &local->queue_stop_reasons[queue]);
 
+	if (local->hw.queues < IEEE80211_NUM_ACS)
+		n_acs = 1;
+
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		int ac;
 
-		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		for (ac = 0; ac < n_acs; ac++) {
 			if (sdata->vif.hw_queue[ac] == queue ||
 			    sdata->vif.cab_queue == queue)
 				netif_stop_subqueue(sdata->dev, ac);


