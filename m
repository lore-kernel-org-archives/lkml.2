Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935759Ab2C3W1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:27:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760587Ab2C3VKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:10:48 -0400
Message-Id: <20120330194842.188422866@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ronald Wahl <ronald.wahl@raritan.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 040/149] rtlwifi: rtl8192c: Prevent sleeping from invalid context in rtl8192cu
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit ebecdcc12fed5d3c81853dea61a0a78a5aefab52 upstream.

When driver rtl8192cu is used with the debug level set to 3 or greater,
the result is "sleeping function called from invalid context" due to
an rcu_read_lock() call in the DM refresh routine in driver rtl8192c.
This lock is not necessary as the USB driver does not use the struct
being protected, thus the lock is set only when a PCI interface is
active.

This bug is reported in https://bugzilla.kernel.org/show_bug.cgi?id=42775.

Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
Tested-by: Ronald Wahl <ronald.wahl@raritan.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ronald Wahl <ronald.wahl@raritan.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -1219,13 +1219,18 @@ static void rtl92c_dm_refresh_rate_adapt
 				 ("PreState = %d, CurState = %d\n",
 				  p_ra->pre_ratr_state, p_ra->ratr_state));
 
-			rcu_read_lock();
-			sta = ieee80211_find_sta(mac->vif, mac->bssid);
+			/* Only the PCI card uses sta in the update rate table
+			 * callback routine */
+			if (rtlhal->interface == INTF_PCI) {
+				rcu_read_lock();
+				sta = ieee80211_find_sta(mac->vif, mac->bssid);
+			}
 			rtlpriv->cfg->ops->update_rate_tbl(hw, sta,
 					p_ra->ratr_state);
 
 			p_ra->pre_ratr_state = p_ra->ratr_state;
-			rcu_read_unlock();
+			if (rtlhal->interface == INTF_PCI)
+				rcu_read_unlock();
 		}
 	}
 }


