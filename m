Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab0LHA7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:48 -0500
Received: from kroah.org ([198.145.64.141]:48582 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960Ab0LHA7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:44 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:26 2010
Message-Id: <20101208005726.347727284@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Stewart <pstew@google.com>, Amod Bodas <amod.bodas@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [050/289] mac80211: reset connection idle when going offchannel
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 4730d5977f3e12b828d354f7752cffd94bdf39e5 upstream.

When we go offchannel mac80211 currently leaves alive the
connection idle monitor. This should be instead postponed
until we come back to our home channel, otherwise by the
time we get back to the home channel we could be triggering
unecesary probe requests. For APs that do not respond to
unicast probe requests (Nexus One is a simple example) this
means we essentially get disconnected after the probes
fails.

This patch has stable fixes for kernels [2.6.35+]

Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/offchannel.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -22,12 +22,15 @@
 static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	local->offchannel_ps_enabled = false;
 
 	/* FIXME: what to do when local->pspolling is true? */
 
 	del_timer_sync(&local->dynamic_ps_timer);
+	del_timer_sync(&ifmgd->conn_mon_timer);
+
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
@@ -85,6 +88,8 @@ static void ieee80211_offchannel_ps_disa
 		mod_timer(&local->dynamic_ps_timer, jiffies +
 			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
+
+	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
 void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local)


