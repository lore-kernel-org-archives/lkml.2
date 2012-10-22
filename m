Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab2JVAqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 20:46:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49439 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab2JVAqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 20:46:45 -0400
Date: Mon, 22 Oct 2012 11:46:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Message-Id: <20121022114637.708c241afa08f14c32635fb8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__22_Oct_2012_11_46_37_+1100_5n7IUR0+FTtjWvAr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Oct_2012_11_46_37_+1100_5n7IUR0+FTtjWvAr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
net/mac80211/mlme.c between commit 3a40414f826a ("mac80211: connect with
HT20 if HT40 is not permitted") from the wireless tree and commit
04ecd2578e71 ("mac80211: track needed RX chains for channel contexts")
from the wireless-next tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/mac80211/mlme.c
index 1b7eed2,469d864..0000000
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@@ -3104,44 -3181,43 +3183,51 @@@ static int ieee80211_prep_channel(struc
  		}
  	}
 =20
 -	if (ht_oper) {
 +	if (ht_oper && sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
+ 		const u8 *ht_cap_ie;
+ 		const struct ieee80211_ht_cap *ht_cap;
+ 		u8 chains =3D 1;
+=20
 -		channel_type =3D NL80211_CHAN_HT20;
 +		/*
 +		 * cfg80211 already verified that the channel itself can
 +		 * be used, but it didn't check that we can do the right
 +		 * HT type, so do that here as well. If HT40 isn't allowed
 +		 * on this channel, disable 40 MHz operation.
 +		 */
 =20
 -		if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
 -			switch (ht_oper->ht_param &
 -					IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 -			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 +		switch (ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 +		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 +			if (cbss->channel->flags & IEEE80211_CHAN_NO_HT40PLUS)
 +				ifmgd->flags |=3D IEEE80211_STA_DISABLE_40MHZ;
 +			else
  				channel_type =3D NL80211_CHAN_HT40PLUS;
 -				break;
 -			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
 +			break;
 +		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
 +			if (cbss->channel->flags & IEEE80211_CHAN_NO_HT40MINUS)
 +				ifmgd->flags |=3D IEEE80211_STA_DISABLE_40MHZ;
 +			else
  				channel_type =3D NL80211_CHAN_HT40MINUS;
 -				break;
 -			}
 +			break;
  		}
- 	}
 =20
- 	if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
- 		/* can only fail due to HT40+/- mismatch */
- 		channel_type =3D NL80211_CHAN_HT20;
- 		sdata_info(sdata,
- 			   "disabling 40 MHz due to multi-vif mismatch\n");
- 		ifmgd->flags |=3D IEEE80211_STA_DISABLE_40MHZ;
- 		WARN_ON(!ieee80211_set_channel_type(local, sdata,
- 						    channel_type));
+ 		ht_cap_ie =3D cfg80211_find_ie(WLAN_EID_HT_CAPABILITY,
+ 					     cbss->information_elements,
+ 					     cbss->len_information_elements);
+ 		if (ht_cap_ie && ht_cap_ie[1] >=3D sizeof(*ht_cap)) {
+ 			ht_cap =3D (void *)(ht_cap_ie + 2);
+ 			chains =3D ieee80211_mcs_to_chains(&ht_cap->mcs);
+ 		}
+ 		sdata->needed_rx_chains =3D min(chains, local->rx_chains);
+ 	} else {
+ 		sdata->needed_rx_chains =3D 1;
  	}
 =20
- 	local->oper_channel =3D cbss->channel;
- 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+ 	/* will change later if needed */
+ 	sdata->smps_mode =3D IEEE80211_SMPS_OFF;
 =20
- 	return 0;
+ 	ieee80211_vif_release_channel(sdata);
+ 	return ieee80211_vif_use_channel(sdata, cbss->channel, channel_type,
+ 					 IEEE80211_CHANCTX_SHARED);
  }
 =20
  static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,

--Signature=_Mon__22_Oct_2012_11_46_37_+1100_5n7IUR0+FTtjWvAr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQhJdtAAoJEECxmPOUX5FEsmUP/19q0x2j4FOHi7wVYSloXIiZ
WzwLt1Hj6YnVPZ6YEg5oMfUlw2nOvpDGRhgM7x7LBDbqC5I5w572oYI4/VIpuxXl
kRy6RudK/sOwwPY6F9/Qf4/TEkM0pHbqlrtTMLqBc0NKABJTaOR531A5P6NkLQf1
8VFiYNnK64mI5t/2Z5FwndMbP7MP7Y6xq3s5yKdRqMSVpJuNlerauGzGgTADJJ6C
Wg0ST0U1foxZlo12ZSUFu5g9L3hSKinXIm7TpnyI6OgCEMUHXxOJ+jij3XDSaT4p
u/CRfsHHwuaqhIDGuwJ2XEzyVHlD0Il7mrTHWRxTMBKuUJXOYOVmv3Ylklb18zKZ
FzNSffHvsY/tfRj55HMA/oRHVCmFcmMefK/mnQBPxTJvWFD6c/tNQ148ycTyohQy
SZNhZZ91aYaeb6SjYSoZ0TCyMXtiIQymFnUXJCvk6srZwrh7oK/T8fXYhn7hPJyO
qTVUuG8mp0CsOblqP7eDDMypma6qXr6PnyaXnb31cPS3SWxhH1zHHocft4HU1wBM
VCaQLvEnEDuHcjXZ8F30LxJdimGuYIERc7/3cmaI56cHLEcYSCPERfzn9IqFQs20
SD+SzsFtRGQcuTJuHkAIEs7N+IG7Tk7VKP+ymLDcz8fkkpQhuRJzbTItLYcvG7QA
QGQfNXWN2U0R88eqay+R
=5wJb
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Oct_2012_11_46_37_+1100_5n7IUR0+FTtjWvAr--
