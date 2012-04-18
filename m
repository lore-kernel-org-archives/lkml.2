Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab2DRPF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:05:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38780 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2DRPFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:05:55 -0400
Date: Wed, 18 Apr 2012 17:05:44 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 2/3] i2c-eg20t: Call init() when wait-event timeout occurs
Message-ID: <20120418150544.GE19802@pengutronix.de>
References: <1332741325-7746-1-git-send-email-tomoya.rohm@gmail.com>
 <1332741325-7746-2-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ffoCPvUAPMgSXi6H"
Content-Disposition: inline
In-Reply-To: <1332741325-7746-2-git-send-email-tomoya.rohm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ffoCPvUAPMgSXi6H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 26, 2012 at 02:55:24PM +0900, Tomoya MORINAGA wrote:
>=20
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

Woha, that's copy&paste code all over. May I ask to refactor this?
Something like:

	rtn =3D pch_..._wait_for_checked_xfer();
	if (rtn)
		return rtn;
	// All the things you have to do when rtn =3D=3D 0

in that new function (the name was only a suugestion), you can do all
the checks which are now copy-pasted, e.g.:

 458         rtn =3D pch_i2c_wait_for_xfer_complete(adap);
 459         if (rtn =3D=3D 0) {
 460                 if (pch_i2c_getack(adap)) {
 461                         pch_dbg(adap, "Receive NACK for slave address"
 462                                 "setting\n");
 463                         return -EIO;
 464                 }
 465         } else if (rtn =3D=3D -EIO) { /* Arbitration Lost */
 466                 pch_err(adap, "Lost Arbitration\n");
 467                 pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMAL_B=
IT);
 468                 pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMIF_B=
IT);
 469                 pch_i2c_init(adap);
 470                 return -EAGAIN;
 471         } else { /* wait-event timeout */
 472                 pch_i2c_stop(adap);
		     // Your current fixes added here
 473                 return -ETIME;
 474         }
 	     return 0;

It is only pseudo-code, but I think it can be done and will help the driver.

Thanks,

   Wolfram


> ---
>  drivers/i2c/busses/i2c-eg20t.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20=
t.c
> index d73975b..714b070 100644
> --- a/drivers/i2c/busses/i2c-eg20t.c
> +++ b/drivers/i2c/busses/i2c-eg20t.c
> @@ -445,7 +445,9 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c=
_adap,
>  			pch_i2c_init(adap);
>  			return -EAGAIN;
>  		} else { /* wait-event timeout */
> +			pch_err(adap, "%s(L.%d):wait-event timeout\n", __func__, __LINE__);
>  			pch_i2c_stop(adap);
> +			pch_i2c_init(adap);
>  			return -ETIME;
>  		}
>  	} else {
> @@ -469,7 +471,9 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c=
_adap,
>  		pch_i2c_init(adap);
>  		return -EAGAIN;
>  	} else { /* wait-event timeout */
> +		pch_err(adap, "%s(L.%d):wait-event timeout\n", __func__, __LINE__);
>  		pch_i2c_stop(adap);
> +		pch_i2c_init(adap);
>  		return -ETIME;
>  	}
> =20
> @@ -490,7 +494,9 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c=
_adap,
>  			pch_clrbit(adap->pch_base_address, PCH_I2CSR,
>  				   I2CMIF_BIT);
>  		} else { /* wait-event timeout */
> +			pch_err(adap, "%s(L.%d):wait-event timeout\n", __func__, __LINE__);
>  			pch_i2c_stop(adap);
> +			pch_i2c_init(adap);
>  			return -ETIME;
>  		}
>  	}
> @@ -598,7 +604,9 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_=
adap, struct i2c_msg *msgs,
>  			pch_i2c_init(adap);
>  			return -EAGAIN;
>  		} else { /* wait-event timeout */
> +			pch_err(adap, "%s(L.%d):wait-event timeout\n", __func__, __LINE__);
>  			pch_i2c_stop(adap);
> +			pch_i2c_init(adap);
>  			return -ETIME;
>  		}
>  		pch_i2c_restart(adap);
> @@ -621,7 +629,9 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_=
adap, struct i2c_msg *msgs,
>  			pch_i2c_init(adap);
>  			return -EAGAIN;
>  		} else { /* wait-event timeout */
> +			pch_err(adap, "%s(L.%d):wait-event timeout\n", __func__, __LINE__);
>  			pch_i2c_stop(adap);
> +			pch_i2c_init(adap);
>  			return -ETIME;
>  		}
>  	} else {
> @@ -648,7 +658,9 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_=
adap, struct i2c_msg *msgs,
>  		pch_i2c_init(adap);
>  		return -EAGAIN;
>  	} else { /* wait-event timeout */
> +		pch_err(adap, "%s(L.%d):wait-event timeout\n", __func__, __LINE__);
>  		pch_i2c_stop(adap);
> +		pch_i2c_init(adap);
>  		return -ETIME;
>  	}
> =20
> @@ -677,7 +689,9 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_=
adap, struct i2c_msg *msgs,
>  					return -EIO;
>  				}
>  			} else { /* wait-event timeout */
> +				pch_err(adap, "%s(L.%d):wait-event timeout\n", __func__, __LINE__);
>  				pch_i2c_stop(adap);
> +				pch_i2c_init(adap);
>  				return -ETIME;
>  			}
> =20
> @@ -698,7 +712,9 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_=
adap, struct i2c_msg *msgs,
>  				return -EIO;
>  			}
>  		} else { /* wait-event timeout */
> +			pch_err(adap, "%s(L.%d):wait-event timeout\n", __func__, __LINE__);
>  			pch_i2c_stop(adap);
> +			pch_i2c_init(adap);
>  			return -ETIME;
>  		}
> =20
> --=20
> 1.7.7.6
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ffoCPvUAPMgSXi6H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+O2EgACgkQD27XaX1/VRuyFQCfcm1SxkVwpHBaezGkPyfJjGe5
TGcAn0tcSXZY5RE3jfL1pLscygPQUefZ
=rO1I
-----END PGP SIGNATURE-----

--ffoCPvUAPMgSXi6H--
