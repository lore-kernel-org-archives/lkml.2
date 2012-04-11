Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945Ab2DLACE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:02:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35695 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933835Ab2DKXQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:16:15 -0400
Message-Id: <20120411231023.148457861@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "jan p. springer" <jsd@igroup.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 29/78] mac80211: fix possible tid_rx->reorder_timer use after free
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit d72308bff5c2fa207949a5925b020bce74495e33 upstream.

Is possible that we will arm the tid_rx->reorder_timer after
del_timer_sync() in ___ieee80211_stop_rx_ba_session(). We need to stop
timer after RCU grace period finish, so move it to
ieee80211_free_tid_rx(). Timer will not be armed again, as
rcu_dereference(sta->ampdu_mlme.tid_rx[tid]) will return NULL.

Debug object detected problem with the following warning:
ODEBUG: free active (active state 0) object type: timer_list hint: sta_rx_agg_reorder_timer_expired+0x0/0xf0 [mac80211]

Bug report (with all warning messages):
https://bugzilla.redhat.com/show_bug.cgi?id=804007

Reported-by: "jan p. springer" <jsd@igroup.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/agg-rx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -49,6 +49,8 @@ static void ieee80211_free_tid_rx(struct
 		container_of(h, struct tid_ampdu_rx, rcu_head);
 	int i;
 
+	del_timer_sync(&tid_rx->reorder_timer);
+
 	for (i = 0; i < tid_rx->buf_size; i++)
 		dev_kfree_skb(tid_rx->reorder_buf[i]);
 	kfree(tid_rx->reorder_buf);
@@ -91,7 +93,6 @@ void ___ieee80211_stop_rx_ba_session(str
 				     tid, WLAN_BACK_RECIPIENT, reason);
 
 	del_timer_sync(&tid_rx->session_timer);
-	del_timer_sync(&tid_rx->reorder_timer);
 
 	call_rcu(&tid_rx->rcu_head, ieee80211_free_tid_rx);
 }


