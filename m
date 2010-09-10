Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0IJHMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 03:12:38 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:44108 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab0IJHMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 03:12:35 -0400
Date: Fri, 10 Sep 2010 09:11:55 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Ike Panhc <ike.pan@canonical.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 0/8] [Resend] ideapad: using EC command to control
 rf/camera power
Message-ID: <20100910071155.GA1263@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Ike Panhc <ike.pan@canonical.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Corentin Chary <corentincj@iksaif.net>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	"Brown, Len" <len.brown@intel.com>,
	Matthew Garrett <mjg@redhat.com>
References: <20100819193146.GB32665@darkside.kls.lan>
 <4C6E2833.6080407@canonical.com>
 <20100820090824.GA23186@darkside.kls.lan>
 <4C7505A2.3000402@canonical.com>
 <20100830181954.GE31068@darkside.kls.lan>
 <4C7E3DE0.7030209@canonical.com>
 <20100901195617.GD32589@darkside.kls.lan>
 <4C80BA81.20701@canonical.com>
 <20100909181714.GA14951@darkside.kls.lan>
 <4C89D3C0.7040105@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <4C89D3C0.7040105@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 10, 2010 at 02:44:16PM +0800, Ike Panhc wrote:
> On 09/10/2010 02:17 AM, Mario 'BitKoenig' Holbe wrote:
> > Hmmm, with this version and no_bt_rfkill=3D1 I run into the same problem
> > as without the ideapad module: If I switch BT off in Windows and reboot
> > to Linux, the device remains invisible and I have no chance to switch it
> > back on again :/
>=20
> The no_bt_rfkill is a stopgap for dual OS user. when BT is default on, us=
er
> still have the BT sw rfkill registered as hci0. when BT is defualt off, u=
ser
> can re-insert module with no_bt_rfkill=3D0.
>=20
> > I guess this is because the initial device activation does currently
> > only happen in ideapad_register_rfkill() via rfkill_init_sw_state()
> > which is not called if no_bt_rfkill=3D1.
> > A manual call to ideapad_rfk_set() (or ideapad_sync_rfk_state()?) in the
> > no_bt_rfkill=3D1 case would very likely solve this, but I don't know how
> > to provide this call with the correct arguments.
>=20
> Sorry I do not get the point of a manual call. Could you explain more on =
this?
>=20
> ideapad_rfk_set is called when user update /sys/class/rfkill/rfkill?/stat=
e and
> ideapad_sync_rfk_state is called when user touch the hw rfkill switch.

ideapad_rfk_set is also called in ideapad_register_rfkill:

static int ideapad_register_rfkill(struct acpi_device *adevice, int dev)
{
=2E..
	if (no_bt_rfkill && (ideapad_rfk_data[dev].type =3D=3D RFKILL_TYPE_BLUETOO=
TH))
		return 0;
=2E..
	rfkill_init_sw_state(priv->rfk[dev], 0);
}

The rfkill_init_sw_state call to unblock the device finally calls
ideapad_rfk_set. In the no_bt_rfkill=3D1 case rfkill_init_sw_state isn't
called, thus the device is not unblocked if it was blocked before.
Hence, if I prior disabled BT in Windows, the device remains invisible.
This is why I think a manual call to ideapad_rfk_set in the
no_bt_rfkill=3D1 case would make the BT device visible.

"manual" in terms of:
	if (no_bt_rfkill && (ideapad_rfk_data[dev].type =3D=3D RFKILL_TYPE_BLUETOO=
TH))
	{
		ideapad_rfk_set(???, 0);
		return 0;
	}

But I don't know what to provide as "???".


Mario
--=20
"Why are we hiding from the police, daddy?"      | J. E. Guenther
"Because we use SuSE son, they use SYSVR4."      | de.alt.sysadmin.recovery

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTInaOxS+e2HeSPbpAQLbjwf/TzZunMFoitqMJRlkK6GTGVaYr/4DqgWq
7KpkvCQwJ5TXqUageCbw7ikMK92AoNWY+2pWKYl1IGaIxq1gPXnElqO3aTgN3fZE
E1Q1zU4oSARReIw/3CzNOl1u2sfLkT1LUTMEcLgyEWoar6lVlrKmQh/mBb53XWyL
7hGFYtITIkvMgMeIv7mMpdsWq0cmoO/dkXOZlCVWG7b4aBeNmzZoA8Wnrm7Y3pFf
D7UOk813Fv/Q41aIaFYjJ061JhfIXX2EeabHS0pgDcgxxvX2aeVAkD34Qt8JJq56
TDEA19TRtIJ04s4rJSq8xZ2EEZM9Y3B7eHqMxZ1GJvgJYr8K7RKG/w==
=Dy9S
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
