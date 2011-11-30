Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab1K3PjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 10:39:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab1K3PjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 10:39:03 -0500
Date: Wed, 30 Nov 2011 16:39:30 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [3.2-rc3] 100% CPU usage while in del_timer_sync from
 iwl3945_rs_free_sta
Message-ID: <20111130153929.GA2144@redhat.com>
References: <20111129100727.GD2675@tiehlicka.suse.cz>
 <20111129113906.GA7299@redhat.com>
 <20111130101028.GA2906@tiehlicka.suse.cz>
 <20111130142316.GA2466@redhat.com>
 <20111130140316.GA4153@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <20111130140316.GA4153@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 30, 2011 at 03:03:16PM +0100, Michal Hocko wrote:
> No, didn't help unfortunately...

Lets gather some more messages. Please apply attached simple patch,
recompile with:
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
and provide dmesg.

Thanks
Stanislaw

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mac80211_debug.patch"

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
index 8faeaf2..c728f94 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
@@ -413,6 +413,7 @@ static void *iwl3945_rs_alloc_sta(void *iwl_priv, struct ieee80211_sta *sta, gfp
 	IWL_DEBUG_RATE(priv, "enter\n");
 
 	rs_sta = &psta->rs_sta;
+	printk("%s rs_sta %p\n", __func__, rs_sta);
 
 	spin_lock_init(&rs_sta->lock);
 	init_timer(&rs_sta->rate_scale_flush);
@@ -432,6 +433,10 @@ static void iwl3945_rs_free_sta(void *iwl_priv, struct ieee80211_sta *sta,
 	 * to use iwl_priv to print out debugging) since it may not be fully
 	 * initialized at this point.
 	 */
+
+	printk("%s rs_sta %p\n", __func__, rs_sta);
+	if (WARN_ON(rs_sta->rate_scale_flush.base == NULL))
+		return;
 	del_timer_sync(&rs_sta->rate_scale_flush);
 }
 

--OgqxwSJOaUobr8KG--
