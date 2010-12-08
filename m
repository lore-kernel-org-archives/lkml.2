Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab0LHByP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:54:15 -0500
Received: from kroah.org ([198.145.64.141]:48562 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933Ab0LHA7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:40 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:26 2010
Message-Id: <20101208005725.947974784@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes@sipsolutions.net>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [046/289] mac80211: fix possible null-pointer de-reference
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit d12c74528e3065c90df70fbc06ec6ffd6e804738 upstream.

This patch not only fixes a null-pointer de-reference
that would be triggered by a PLINK_OPEN frame with mis-
matching/incompatible mesh configuration, but also
responds correctly to non-compatible PLINK_OPEN frames
by generating a PLINK_CLOSE with the right reason code.

The original bug was detected by smatch.
( http://repo.or.cz/w/smatch.git )

net/mac80211/mesh_plink.c +574 mesh_rx_plink_frame(168)
error: we previously assumed 'sta' could be null.

Reviewed-and-Tested-by: Steve deRosier <steve@cozybit.com>
Reviewed-and-Tested-by: Javier Cardona <javier@cozybit.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/mesh_plink.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -412,7 +412,7 @@ void mesh_rx_plink_frame(struct ieee8021
 	enum plink_event event;
 	enum plink_frame_type ftype;
 	size_t baselen;
-	bool deactivated;
+	bool deactivated, matches_local = true;
 	u8 ie_len;
 	u8 *baseaddr;
 	__le16 plid, llid, reason;
@@ -487,6 +487,7 @@ void mesh_rx_plink_frame(struct ieee8021
 	/* Now we will figure out the appropriate event... */
 	event = PLINK_UNDEFINED;
 	if (ftype != PLINK_CLOSE && (!mesh_matches_local(&elems, sdata))) {
+		matches_local = false;
 		switch (ftype) {
 		case PLINK_OPEN:
 			event = OPN_RJCT;
@@ -498,7 +499,15 @@ void mesh_rx_plink_frame(struct ieee8021
 			/* avoid warning */
 			break;
 		}
-		spin_lock_bh(&sta->lock);
+	}
+
+	if (!sta && !matches_local) {
+		rcu_read_unlock();
+		reason = cpu_to_le16(MESH_CAPABILITY_POLICY_VIOLATION);
+		llid = 0;
+		mesh_plink_frame_tx(sdata, PLINK_CLOSE, mgmt->sa, llid,
+				    plid, reason);
+		return;
 	} else if (!sta) {
 		/* ftype == PLINK_OPEN */
 		u32 rates;
@@ -522,7 +531,7 @@ void mesh_rx_plink_frame(struct ieee8021
 		}
 		event = OPN_ACPT;
 		spin_lock_bh(&sta->lock);
-	} else {
+	} else if (matches_local) {
 		spin_lock_bh(&sta->lock);
 		switch (ftype) {
 		case PLINK_OPEN:
@@ -564,6 +573,8 @@ void mesh_rx_plink_frame(struct ieee8021
 			rcu_read_unlock();
 			return;
 		}
+	} else {
+		spin_lock_bh(&sta->lock);
 	}
 
 	mpl_dbg("Mesh plink (peer, state, llid, plid, event): %pM %s %d %d %d\n",


