Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab2JZAJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:09:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:54194 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848Ab2JZAIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Thomas Pedersen <thomas@cozybit.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 85/85] mac80211: call drv_get_tsf() in sleepable context
Date: Thu, 25 Oct 2012 17:06:43 -0700
Message-Id: <20121026000039.646690756@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Pedersen <thomas@cozybit.com>

commit 55fabefe3695241e6ccfa0cd4974f3fa497693dc upstream.

The call to drv_get/set_tsf() was put on the workqueue to perform tsf
adjustments since that function might sleep. However it ended up inside
a spinlock, whose critical section must be atomic. Do tsf adjustment
outside the spinlock instead, and get rid of a warning.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mesh_sync.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -56,7 +56,6 @@ void mesh_sync_adjust_tbtt(struct ieee80
 	u64 tsfdelta;
 
 	spin_lock_bh(&ifmsh->sync_offset_lock);
-
 	if (ifmsh->sync_offset_clockdrift_max < beacon_int_fraction) {
 		msync_dbg(sdata, "TBTT : max clockdrift=%lld; adjusting\n",
 			  (long long) ifmsh->sync_offset_clockdrift_max);
@@ -69,11 +68,11 @@ void mesh_sync_adjust_tbtt(struct ieee80
 		tsfdelta = -beacon_int_fraction;
 		ifmsh->sync_offset_clockdrift_max -= beacon_int_fraction;
 	}
+	spin_unlock_bh(&ifmsh->sync_offset_lock);
 
 	tsf = drv_get_tsf(local, sdata);
 	if (tsf != -1ULL)
 		drv_set_tsf(local, sdata, tsf + tsfdelta);
-	spin_unlock_bh(&ifmsh->sync_offset_lock);
 }
 
 static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,


