Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935582Ab0HFSim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:38:42 -0400
Received: from kroah.org ([198.145.64.141]:48712 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964946Ab0HFSgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:36:05 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:02 2010
Message-Id: <20100806183202.594463680@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [29/38] mac80211: avoid scheduling while atomic in mesh_rx_plink_frame
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John W. Linville <linville@tuxdriver.com>

commit c937019761a758f2749b1f3a032b7a91fb044753 upstream.

While mesh_rx_plink_frame holds sta->lock...

mesh_rx_plink_frame ->
	mesh_plink_inc_estab_count ->
		ieee80211_bss_info_change_notify

...but ieee80211_bss_info_change_notify is allowed to sleep.  A driver
taking advantage of that allowance can cause a scheduling while
atomic bug.  Similar paths exist for mesh_plink_dec_estab_count,
so work around those as well.

http://bugzilla.kernel.org/show_bug.cgi?id=16099

Also, correct a minor kerneldoc comment error (mismatched function names).

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/mesh_plink.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -65,7 +65,6 @@ void mesh_plink_inc_estab_count(struct i
 {
 	atomic_inc(&sdata->u.mesh.mshstats.estab_plinks);
 	mesh_accept_plinks_update(sdata);
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 }
 
 static inline
@@ -73,7 +72,6 @@ void mesh_plink_dec_estab_count(struct i
 {
 	atomic_dec(&sdata->u.mesh.mshstats.estab_plinks);
 	mesh_accept_plinks_update(sdata);
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 }
 
 /**
@@ -115,7 +113,7 @@ static struct sta_info *mesh_plink_alloc
 }
 
 /**
- * mesh_plink_deactivate - deactivate mesh peer link
+ * __mesh_plink_deactivate - deactivate mesh peer link
  *
  * @sta: mesh peer link to deactivate
  *
@@ -123,18 +121,23 @@ static struct sta_info *mesh_plink_alloc
  *
  * Locking: the caller must hold sta->lock
  */
-static void __mesh_plink_deactivate(struct sta_info *sta)
+static bool __mesh_plink_deactivate(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	bool deactivated = false;
 
-	if (sta->plink_state == PLINK_ESTAB)
+	if (sta->plink_state == PLINK_ESTAB) {
 		mesh_plink_dec_estab_count(sdata);
+		deactivated = true;
+	}
 	sta->plink_state = PLINK_BLOCKED;
 	mesh_path_flush_by_nexthop(sta);
+
+	return deactivated;
 }
 
 /**
- * __mesh_plink_deactivate - deactivate mesh peer link
+ * mesh_plink_deactivate - deactivate mesh peer link
  *
  * @sta: mesh peer link to deactivate
  *
@@ -142,9 +145,15 @@ static void __mesh_plink_deactivate(stru
  */
 void mesh_plink_deactivate(struct sta_info *sta)
 {
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	bool deactivated;
+
 	spin_lock_bh(&sta->lock);
-	__mesh_plink_deactivate(sta);
+	deactivated = __mesh_plink_deactivate(sta);
 	spin_unlock_bh(&sta->lock);
+
+	if (deactivated)
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 }
 
 static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
@@ -381,10 +390,16 @@ int mesh_plink_open(struct sta_info *sta
 
 void mesh_plink_block(struct sta_info *sta)
 {
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	bool deactivated;
+
 	spin_lock_bh(&sta->lock);
-	__mesh_plink_deactivate(sta);
+	deactivated = __mesh_plink_deactivate(sta);
 	sta->plink_state = PLINK_BLOCKED;
 	spin_unlock_bh(&sta->lock);
+
+	if (deactivated)
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 }
 
 
@@ -397,6 +412,7 @@ void mesh_rx_plink_frame(struct ieee8021
 	enum plink_event event;
 	enum plink_frame_type ftype;
 	size_t baselen;
+	bool deactivated;
 	u8 ie_len;
 	u8 *baseaddr;
 	__le16 plid, llid, reason;
@@ -651,8 +667,9 @@ void mesh_rx_plink_frame(struct ieee8021
 		case CNF_ACPT:
 			del_timer(&sta->plink_timer);
 			sta->plink_state = PLINK_ESTAB;
-			mesh_plink_inc_estab_count(sdata);
 			spin_unlock_bh(&sta->lock);
+			mesh_plink_inc_estab_count(sdata);
+			ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 			mpl_dbg("Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
 			break;
@@ -684,8 +701,9 @@ void mesh_rx_plink_frame(struct ieee8021
 		case OPN_ACPT:
 			del_timer(&sta->plink_timer);
 			sta->plink_state = PLINK_ESTAB;
-			mesh_plink_inc_estab_count(sdata);
 			spin_unlock_bh(&sta->lock);
+			mesh_plink_inc_estab_count(sdata);
+			ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 			mpl_dbg("Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
 			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->sta.addr, llid,
@@ -702,11 +720,13 @@ void mesh_rx_plink_frame(struct ieee8021
 		case CLS_ACPT:
 			reason = cpu_to_le16(MESH_CLOSE_RCVD);
 			sta->reason = reason;
-			__mesh_plink_deactivate(sta);
+			deactivated = __mesh_plink_deactivate(sta);
 			sta->plink_state = PLINK_HOLDING;
 			llid = sta->llid;
 			mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 			spin_unlock_bh(&sta->lock);
+			if (deactivated)
+				ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->sta.addr, llid,
 					    plid, reason);
 			break;


