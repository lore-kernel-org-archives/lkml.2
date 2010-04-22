Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab0DVU3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:29:52 -0400
Received: from kroah.org ([198.145.64.141]:59478 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab0DVT7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:49 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:06 2010
Message-Id: <20100422195406.803312363@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marco Porsch <marco.porsch@siemens.com>,
       Javier Cardona <javier@cozybit.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [021/139] mac80211: fix PREQ processing and one small bug
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Porsch, Marco <marco.porsch@siemens.com>

commit 533866b12cce484994163b1e201778cbac4c04c5 upstream.

1st) a PREQ should only be processed, if it has the same SN and better
metric (instead of better or equal).
2nd) next_hop[ETH_ALEN] now actually used to buffer
mpath->next_hop->sta.addr for use out of lock.

Signed-off-by: Marco Porsch <marco.porsch@siemens.com>
Acked-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/mesh_hwmp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -391,7 +391,7 @@ static u32 hwmp_route_info_get(struct ie
 				if (SN_GT(mpath->sn, orig_sn) ||
 				    (mpath->sn == orig_sn &&
 				     action == MPATH_PREQ &&
-				     new_metric > mpath->metric)) {
+				     new_metric >= mpath->metric)) {
 					process = false;
 					fresh_info = false;
 				}
@@ -611,7 +611,7 @@ static void hwmp_prep_frame_process(stru
 
 	mesh_path_sel_frame_tx(MPATH_PREP, flags, orig_addr,
 		cpu_to_le32(orig_sn), 0, target_addr,
-		cpu_to_le32(target_sn), mpath->next_hop->sta.addr, hopcount,
+		cpu_to_le32(target_sn), next_hop, hopcount,
 		ttl, cpu_to_le32(lifetime), cpu_to_le32(metric),
 		0, sdata);
 	rcu_read_unlock();


