Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab1K0GiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 01:38:24 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61090 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1K0GiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 01:38:22 -0500
MIME-Version: 1.0
In-Reply-To: <20111125123720.GA31564@gamma.logic.tuwien.ac.at>
References: <20111122072730.GA32225@gamma.logic.tuwien.ac.at>
	<CANUX_P15En9bHVx4bhq6=XKPZnC2u+QyVJ+jnm4ns=39DrOBtg@mail.gmail.com>
	<2D0C7905-AEB2-4DE4-89B1-945D89F2B5D6@logic.at>
	<CANUX_P21PDdyo4u-x_1A0Lcqf-33yHgzUxddAoc3juGRNnrcDg@mail.gmail.com>
	<20111122124357.GA32440@gamma.logic.tuwien.ac.at>
	<CANUX_P0uyyuK4netV6srYCh9FsC4cpGzxobHE3T38n5RvvA0RQ@mail.gmail.com>
	<20111123015503.GC23203@gamma.logic.tuwien.ac.at>
	<CANUX_P1zDDzMy5yrFXSZAkMQ-87uu-fE1e-2sCEgHJi4dh5eiw@mail.gmail.com>
	<20111125122143.GA30404@gamma.logic.tuwien.ac.at>
	<CANUX_P1hFzSVPQzd6gq3tLY7hu+LX5suph6uHP+hq6+7rdAK1w@mail.gmail.com>
	<20111125123720.GA31564@gamma.logic.tuwien.ac.at>
Date: Sun, 27 Nov 2011 08:38:21 +0200
Message-ID: <CANUX_P2mGQX9H-f7OFusjUrv8ey56JNzFVEdKJkAejsg9zVNkQ@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, that was my impression too, but still, I wanted to mention it.
>
>> I am already on week-end here and will look at it more carefully
>> later. First impression is that things are messy here. I guess we are
>> getting in a bad failure path that wasn't checked...
>
> No problem, I can cope with it.
>

you can always disable 11n: modprobe 11n_disable=1.

Well... Something is really weird here:
mac80211 requests from us to:
* start agg
* stop agg
* agg operational

this is not a legal sequence

BTW - I am under this impression that mac80211 hasn't been compiled
with HT debug flag. Can you please set this compilation flag ?

I also would like you to add this line in iwlagn_mac_ampdu_action:


static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
				   struct ieee80211_vif *vif,
				   enum ieee80211_ampdu_mlme_action action,
				   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
				   u8 buf_size)
{
	struct iwl_priv *priv = hw->priv;
	int ret = -EINVAL;
	struct iwl_station_priv *sta_priv = (void *) sta->drv_priv;

	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
		     sta->addr, tid);

dump_stack();   <<<<========================================= new line

	if (!(priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE))
		return -EACCES;



This will give an insight at why is mac80211 calling the driver and
better point me to the bug.


Thanks !
