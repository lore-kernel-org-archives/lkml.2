Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab2K0QCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:02:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43806 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755373Ab2K0QCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:02:42 -0500
Message-ID: <1354032158.4266.60.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 188/270] iwlwifi: fix 6000 series channel switch command
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Tue, 27 Nov 2012 16:02:38 +0000
In-Reply-To: <1353949160-26803-189-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
	 <1353949160-26803-189-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Jd/LowFx9O/3Taty6B9A"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Jd/LowFx9O/3Taty6B9A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-11-26 at 14:57 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7u1 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> commit 8f7b8db6e0557c8437adf9371e020cd89a7e85dc upstream.
>=20
> The channel switch command for 6000 series devices
> is larger than the maximum inline command size of
> 320 bytes. The command is therefore refused with a
> warning. Fix this by allocating the command and
> using the NOCOPY mechanism.
>=20
> Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> [ herton: file name is different on 3.5, code differs a little bit at
>   the end, adjusted context ]
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>

Also missing from 3.4; the filename is different again
(drivers/net/wireless/iwlwifi/iwl-6000.c) but this should otherwise be
applicable with one line of fuzz at the end.

Ben.

> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-devices.c |   39 +++++++++++++++---=
------
>  1 file changed, 24 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-devices.c b/drivers/net=
/wireless/iwlwifi/iwl-agn-devices.c
> index 48533b3..8ab0a7c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
> @@ -653,7 +653,7 @@ static int iwl6000_hw_channel_switch(struct iwl_priv =
*priv,
>  	 * See iwlagn_mac_channel_switch.
>  	 */
>  	struct iwl_rxon_context *ctx =3D &priv->contexts[IWL_RXON_CTX_BSS];
> -	struct iwl6000_channel_switch_cmd cmd;
> +	struct iwl6000_channel_switch_cmd *cmd;
>  	const struct iwl_channel_info *ch_info;
>  	u32 switch_time_in_usec, ucode_switch_time;
>  	u16 ch;
> @@ -663,18 +663,25 @@ static int iwl6000_hw_channel_switch(struct iwl_pri=
v *priv,
>  	struct ieee80211_vif *vif =3D ctx->vif;
>  	struct iwl_host_cmd hcmd =3D {
>  		.id =3D REPLY_CHANNEL_SWITCH,
> -		.len =3D { sizeof(cmd), },
> +		.len =3D { sizeof(*cmd), },
>  		.flags =3D CMD_SYNC,
> -		.data =3D { &cmd, },
> +		.dataflags[0] =3D IWL_HCMD_DFL_NOCOPY,
>  	};
> +	int err;
> =20
> -	cmd.band =3D priv->band =3D=3D IEEE80211_BAND_2GHZ;
> +	cmd =3D kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd)
> +		return -ENOMEM;
> +
> +	hcmd.data[0] =3D cmd;
> +
> +	cmd->band =3D priv->band =3D=3D IEEE80211_BAND_2GHZ;
>  	ch =3D ch_switch->channel->hw_value;
>  	IWL_DEBUG_11H(priv, "channel switch from %u to %u\n",
>  		      ctx->active.channel, ch);
> -	cmd.channel =3D cpu_to_le16(ch);
> -	cmd.rxon_flags =3D ctx->staging.flags;
> -	cmd.rxon_filter_flags =3D ctx->staging.filter_flags;
> +	cmd->channel =3D cpu_to_le16(ch);
> +	cmd->rxon_flags =3D ctx->staging.flags;
> +	cmd->rxon_filter_flags =3D ctx->staging.filter_flags;
>  	switch_count =3D ch_switch->count;
>  	tsf_low =3D ch_switch->timestamp & 0x0ffffffff;
>  	/*
> @@ -690,30 +697,32 @@ static int iwl6000_hw_channel_switch(struct iwl_pri=
v *priv,
>  			switch_count =3D 0;
>  	}
>  	if (switch_count <=3D 1)
> -		cmd.switch_time =3D cpu_to_le32(priv->ucode_beacon_time);
> +		cmd->switch_time =3D cpu_to_le32(priv->ucode_beacon_time);
>  	else {
>  		switch_time_in_usec =3D
>  			vif->bss_conf.beacon_int * switch_count * TIME_UNIT;
>  		ucode_switch_time =3D iwl_usecs_to_beacons(priv,
>  							 switch_time_in_usec,
>  							 beacon_interval);
> -		cmd.switch_time =3D iwl_add_beacon_time(priv,
> -						      priv->ucode_beacon_time,
> -						      ucode_switch_time,
> -						      beacon_interval);
> +		cmd->switch_time =3D iwl_add_beacon_time(priv,
> +						       priv->ucode_beacon_time,
> +						       ucode_switch_time,
> +						       beacon_interval);
>  	}
>  	IWL_DEBUG_11H(priv, "uCode time for the switch is 0x%x\n",
> -		      cmd.switch_time);
> +		      cmd->switch_time);
>  	ch_info =3D iwl_get_channel_info(priv, priv->band, ch);
>  	if (ch_info)
> -		cmd.expect_beacon =3D is_channel_radar(ch_info);
> +		cmd->expect_beacon =3D is_channel_radar(ch_info);
>  	else {
>  		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
>  			ctx->active.channel, ch);
>  		return -EFAULT;
>  	}
> =20
> -	return iwl_dvm_send_cmd(priv, &hcmd);
> +	err =3D iwl_dvm_send_cmd(priv, &hcmd);
> +	kfree(cmd);
> +	return err;
>  }
> =20
>  struct iwl_lib_ops iwl6000_lib =3D {

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-Jd/LowFx9O/3Taty6B9A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULTkHue/yOyVhhEJAQqTvQ/9H0xoeOebuxtPbGU7Snt+CaTOyaZzOb8F
pYDAgl8BVsFjOri87ifWrrhNcO2o2vuQDEXUE8OO9ToUalmcWEozEltI7DWEGzei
cukRgYeXG69/4A8C8PrAZ8j5kGir0RFUOE1Id2eH9efeAGd6cqIiQf8ooU5W7KVb
UCrUJRnxz7d1QWBx4CX3NfsBXxOQo65AMYmK56MS2nBCoktbX3t14H6mTTMGe6W4
fc1omD3og0jTl+Jxeihm8LeOtze0uthqd6HU53WnU+A/VKtQzNpTnfWzZiIHLB9D
X2LN/O6KYJjXm6BXri26bmE3UPOYREKFQNxDiSzG7z50zrdLv0Xtj1GiPKm824wh
Fq6I62+c5O7EKQPScizFVFVlxsRwlyclvmylc7Lce6UfPkn/QnSmDGjhEpti8wMI
8lPw6dSGxBQ6vpHWr9PoO7aldoBta9u9rYUK8f6LQcIxUwLfbJe+voDvxlP2ozWj
L8CeBpCU9SFoJ1cG+Gy0zpme2gCxM5wMPpaYUxeI4H4b/PJPLft+AfKnLYFxP1ns
f9wNgUFxIIcXwICPgNzpqg+PowWLZfgYAyw0BoKtsfe9bnznXS30DPB2eeFChtQF
tQIaXECOad0HDZIe2DNRaXXVnL7R7Zfr8RBwIHbAv+TBMW+2rh6/HZcr5UqcO5oT
TuXV2rmVkQg=
=ZDTD
-----END PGP SIGNATURE-----

--=-Jd/LowFx9O/3Taty6B9A--
