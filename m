Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2LMTfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 14:35:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:28334 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162Ab2LMTfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 14:35:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,275,1355126400"; 
   d="asc'?scan'208";a="233642024"
Date: Thu, 13 Dec 2012 21:35:50 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] PCI Hotplug: workaround for Thunderbolt on Acer
 Aspire S5
Message-ID: <20121213193550.GB23994@otc-wbsnb-06>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1355412708-20046-2-git-send-email-kirill.shutemov@linux.intel.com>
 <20121213184441.GB12105@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <20121213184441.GB12105@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 13, 2012 at 10:44:41AM -0800, Greg KH wrote:
> On Thu, Dec 13, 2012 at 05:31:46PM +0200, Kirill A. Shutemov wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >=20
> > Correct ACPI PCI hotplug imeplementation should have _RMV method in a
> > PCI slot (device under pci bridge). In Acer Aspire S5 case we have it
> > deeper in hierarchy:
> >=20
> > Device (RP05)
> > {
> >    // ...
> >    Device (HRUP)
> >    {
> >        // ...
> >        Device (HRDN)
> >        {
> >            // ...
> >            Device (EPUP)
> >            {
> >                // ...
> >                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
> >                {
> >                    Return (One)
> >                }
> >            }
> >        }
> >    }
> > }
> >=20
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  drivers/pci/hotplug/acpi_pcihp.c |   13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >=20
> > diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acp=
i_pcihp.c
> > index 2a47e82..d92ebfb 100644
> > --- a/drivers/pci/hotplug/acpi_pcihp.c
> > +++ b/drivers/pci/hotplug/acpi_pcihp.c
> > @@ -422,6 +422,19 @@ static int pcihp_is_ejectable(acpi_handle handle)
> >  	status =3D acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
> >  	if (ACPI_SUCCESS(status) && removable)
> >  		return 1;
> > +
> > +	/*
> > +	 * Workaround for Thunderbolt implementation on Acer Aspire S5.
> > +	 *
> > +	 * Correct ACPI PCI hotplug imeplementation has _RMV method in a PCI
> > +	 * slot (device under pci bridge). In Acer Aspire S5 case we have it
> > +	 * deeper in hierarchy.
> > +	 */
> > +	status =3D acpi_evaluate_integer(handle, "HRDN.EPUP._RMV", NULL,
> > +			&removable);
> > +	if (ACPI_SUCCESS(status) && removable)
> > +		return 1;
>=20
> I have no objection to this patch as-is, but I wonder how will other
> BIOSes implement this "incorrectly" in the future.  Should we always
> just try to walk the whole PCI slot heirachy looking for the _RMV
> attribute?  That should solve the problem where someone else places this
> at another location for the slot, right?

I'm new with PCI and I'm not sure what problems can cause false positive
here.
What will heppend if we find yet another PCI-to-PCI bridge in the hierarchy
and some of slots of that bridge will have _RMV method? Is it possible,
right?

I prefer postpone any generalization before we will find any similar bug
on other HW. (I naively hope BIOS developers will not repeat theirs bugs).

> Is there any test for Windows that ensures that this gets placed in the
> "correct" location that we can rely on?

No idea. I haven't seen any Windows.

--=20
 Kirill A. Shutemov

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQyi4WAAoJEAd+omnVudOMlVUP+wfjyOYeVJZBqgHAQwifUX9U
rc1w4wwfE8w92d5vmesl7k3YOnKL8wGh6YaG0EDLpMSEYWAbj6bdA6fekiFnardL
8Q3QkHwrgKsycIrQcib2IGqk5/Dd365pjXV8/3BwjSB24Dw/7e5NpmJUbsYcUDYn
fXIYFV3Ow/GSMRXnJ3nDh2tkVP8BE6Y3OkDA3TU4Y/q1Fxr3IoPxKU3EoG/0iv7x
xUt/JUyzgzu3Uo7lU02PfDuPJoSfb9uW2wR+ZqtD1hGj0xp4Z/1o1TpJ4FMuXRIA
J4o3vc3ThixtiGJhmRTRHZvHwGTRqvLPYusv+cPW4jMFlG6WQmHLx/GdrCK5WkSK
ViCBU4Eqt5K6zTTiAhtbXkXlt//xKbyeRuqglj/GRiWQcsIK0XbRiWHAZB+Tt3or
9yUyWDTfC1yHrlbrBSz4HgHKlLpdfZWOasLOrCPw6WSJx5aEPH3aRHSGUt14kBNv
ATjGX/Vwqtmm/uBApfM6vLV91JWpiyaO5czrFXqIBQG7RZZvWH8SxGdr/ikjocja
7Kfs6j1thoqXoT4S6Bdh0pvYtxxNwrFXrBo3igdfopYwMU3Zm7Vmk+W5LN+xDo09
VHfFhLLNBOQtF7WsmYB81GW/dp3zPXOu8yKFcjlAxoOoBq4YxSV9S//81tL1eLJU
PvPSBgZWOfIgxOW5Ycnx
=OaTg
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
