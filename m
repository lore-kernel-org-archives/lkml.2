Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab1B1R7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 12:59:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64337 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1B1R7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 12:59:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Q6IjAtQi0MHqXfBEwibXHsX7m0FB18PVgN0xoxhxWi0YQWHTIdm46ssSGNouCigB+5
         APfhCho7g0dgGTq/Q2qWPRZmtkAXWTJF8HQ951ne1IMEgt8QrJVMseXsZ7sVWVcPk6Lg
         FEDOEIb9b5YqBATUFwxdSHgcoK8j1AMvZ4D94=
Message-ID: <4D6BE26F.2060709@lwfinger.net>
Date: Mon, 28 Feb 2011 11:59:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alessio Igor Bogani <abogani@kernel.org>,
        John Linville <linville@tuxdriver.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>, linux-wireless@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH] rtlwifi: Add the missing rcu_read_lock/unlock
References: <4D6AC9EE.2070904@lwfinger.net> <1298915204-2648-1-git-send-email-abogani@kernel.org>
In-Reply-To: <1298915204-2648-1-git-send-email-abogani@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2011 11:46 AM, Alessio Igor Bogani wrote:
> ===================================================
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> net/mac80211/sta_info.c:125 invoked rcu_dereference_check() without protection!
>
> other info that might help us debug this:
>
> rcu_scheduler_active = 1, debug_locks = 0
> 5 locks held by wpa_supplicant/468:
>   #0:  (rtnl_mutex){+.+.+.}, at: [<c1465d84>] rtnl_lock+0x14/0x20
>   #1:  (&rdev->mtx){+.+.+.}, at: [<f84b8c2b>] cfg80211_mgd_wext_siwfreq+0x6b/0x170 [cfg80211]
>   #2:  (&rdev->devlist_mtx){+.+.+.}, at: [<f84b8c37>] cfg80211_mgd_wext_siwfreq+0x77/0x170 [cfg80211]
>   #3:  (&wdev->mtx){+.+.+.}, at: [<f84b8c44>] cfg80211_mgd_wext_siwfreq+0x84/0x170 [cfg80211]
>   #4:  (&rtlpriv->locks.conf_mutex){+.+.+.}, at: [<f8506476>] rtl_op_bss_info_changed+0x26/0xc10 [rtlwifi]
>
> stack backtrace:
> Pid: 468, comm: wpa_supplicant Not tainted 2.6.38-rc6+ #79
> Call Trace:
>   [<c108806a>] ? lockdep_rcu_dereference+0xaa/0xb0
>   [<f8523d2c>] ? sta_info_get_bss+0x19c/0x1b0 [mac80211]
>   [<f8523d62>] ? ieee80211_find_sta+0x22/0x40 [mac80211]
>   [<f850661c>] ? rtl_op_bss_info_changed+0x1cc/0xc10 [rtlwifi]
>   [<c153671c>] ? __mutex_unlock_slowpath+0x14c/0x160
>   [<c153673d>] ? mutex_unlock+0xd/0x10
>   [<f8507180>] ? rtl_op_config+0x120/0x310 [rtlwifi]
>   [<c10896db>] ? trace_hardirqs_on+0xb/0x10
>   [<f8522169>] ? ieee80211_bss_info_change_notify+0xf9/0x1f0 [mac80211]
>   [<f8506450>] ? rtl_op_bss_info_changed+0x0/0xc10 [rtlwifi]
>   [<f853646f>] ? ieee80211_set_channel+0xbf/0xd0 [mac80211]
>   [<f84b5f41>] ? cfg80211_set_freq+0x121/0x180 [cfg80211]
>   [<f85363b0>] ? ieee80211_set_channel+0x0/0xd0 [mac80211]
>   [<f84b8ceb>] ? cfg80211_mgd_wext_siwfreq+0x12b/0x170 [cfg80211]
>   [<f84b87eb>] ? cfg80211_wext_siwfreq+0x9b/0x100 [cfg80211]
>   [<c153b98b>] ? sub_preempt_count+0x7b/0xb0
>   [<c150f874>] ? ioctl_standard_call+0x74/0x3b0
>   [<c1465d84>] ? rtnl_lock+0x14/0x20
>   [<f84b8750>] ? cfg80211_wext_siwfreq+0x0/0x100 [cfg80211]
>   [<c14568bd>] ? __dev_get_by_name+0x8d/0xb0
>   [<c150fddb>] ? wext_handle_ioctl+0x16b/0x180
>   [<f84b8750>] ? cfg80211_wext_siwfreq+0x0/0x100 [cfg80211]
>   [<c145bc7a>] ? dev_ioctl+0x5ba/0x720
>   [<c108a947>] ? __lock_acquire+0x3e7/0x19b0
>   [<c1443b0b>] ? sock_ioctl+0x1eb/0x290
>   [<c108bfa5>] ? lock_release_non_nested+0x95/0x2f0
>   [<c1443920>] ? sock_ioctl+0x0/0x290
>   [<c114d74d>] ? do_vfs_ioctl+0x7d/0x5c0
>   [<c1112232>] ? might_fault+0x62/0xb0
>   [<c113e3c6>] ? fget_light+0x226/0x390
>   [<c1112278>] ? might_fault+0xa8/0xb0
>   [<c114dd17>] ? sys_ioctl+0x87/0x90
>   [<c1002f9f>] ? sysenter_do_call+0x12/0x38
>
> This work was supported by a hardware donation from the CE Linux Forum.
>
> Signed-off-by: Alessio Igor Bogani<abogani@kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>


> ---
>   drivers/net/wireless/rtlwifi/core.c          |    4 ++++
>   drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |    5 ++++-
>   drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |    5 ++++-
>   3 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
> index 059ab03..e4f4aee 100644
> --- a/drivers/net/wireless/rtlwifi/core.c
> +++ b/drivers/net/wireless/rtlwifi/core.c
> @@ -551,6 +551,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
>   		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_TRACE,
>   			 ("BSS_CHANGED_HT\n"));
>
> +		rcu_read_lock();
>   		sta = ieee80211_find_sta(mac->vif, mac->bssid);
>
>   		if (sta) {
> @@ -563,6 +564,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
>   				mac->current_ampdu_factor =
>   				    sta->ht_cap.ampdu_factor;
>   		}
> +		rcu_read_unlock();
>
>   		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_SHORTGI_DENSITY,
>   					      (u8 *) (&mac->max_mss_density));
> @@ -614,6 +616,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
>   		else
>   			mac->mode = WIRELESS_MODE_G;
>
> +		rcu_read_lock();
>   		sta = ieee80211_find_sta(mac->vif, mac->bssid);
>
>   		if (sta) {
> @@ -648,6 +651,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
>   				 */
>   			}
>   		}
> +		rcu_read_unlock();
>
>   		/*mac80211 just give us CCK rates any time
>   		 *So we add G rate in basic rates when
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
> index 8a67372..e14f743 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
> @@ -730,7 +730,7 @@ void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
>   	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
>   	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
>   	bool defaultadapter = true;
> -	struct ieee80211_sta *sta = ieee80211_find_sta(mac->vif, mac->bssid);
> +	struct ieee80211_sta *sta;
>   	u8 *pdesc = (u8 *) pdesc_tx;
>   	struct rtl_tcb_desc tcb_desc;
>   	u8 *qc = ieee80211_get_qos_ctl(hdr);
> @@ -810,10 +810,13 @@ void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
>   		SET_TX_DESC_LINIP(pdesc, 0);
>   		SET_TX_DESC_PKT_SIZE(pdesc, (u16) skb->len);
>
> +		rcu_read_lock();
> +		sta = ieee80211_find_sta(mac->vif, mac->bssid);
>   		if (sta) {
>   			u8 ampdu_density = sta->ht_cap.ampdu_density;
>   			SET_TX_DESC_AMPDU_DENSITY(pdesc, ampdu_density);
>   		}
> +		rcu_read_unlock();
>
>   		if (info->control.hw_key) {
>   			struct ieee80211_key_conf *keyconf =
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> index 659e0ca..d0b0d43 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> @@ -504,7 +504,7 @@ void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
>   	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
>   	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
>   	bool defaultadapter = true;
> -	struct ieee80211_sta *sta = ieee80211_find_sta(mac->vif, mac->bssid);
> +	struct ieee80211_sta *sta;
>   	struct rtl_tcb_desc tcb_desc;
>   	u8 *qc = ieee80211_get_qos_ctl(hdr);
>   	u8 tid = qc[0]&  IEEE80211_QOS_CTL_TID_MASK;
> @@ -562,10 +562,13 @@ void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
>   		SET_TX_DESC_DATA_BW(txdesc, 0);
>   		SET_TX_DESC_DATA_SC(txdesc, 0);
>   	}
> +	rcu_read_lock();
> +	sta = ieee80211_find_sta(mac->vif, mac->bssid);
>   	if (sta) {
>   		u8 ampdu_density = sta->ht_cap.ampdu_density;
>   		SET_TX_DESC_AMPDU_DENSITY(txdesc, ampdu_density);
>   	}
> +	rcu_read_unlock();
>   	if (info->control.hw_key) {
>   		struct ieee80211_key_conf *keyconf = info->control.hw_key;
>   		switch (keyconf->cipher) {

