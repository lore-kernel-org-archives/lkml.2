Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2LNKpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 05:45:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:56978 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab2LNKpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 05:45:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,279,1355126400"; 
   d="asc'?scan'208";a="263937726"
Date: Fri, 14 Dec 2012 12:46:26 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 1/3] PCI Hotplug: workaround for Thunderbolt on Acer
 Aspire S5
Message-ID: <20121214104626.GB15240@otc-wbsnb-06>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1355412708-20046-2-git-send-email-kirill.shutemov@linux.intel.com>
 <CAErSpo5eFhpHwnYZvfXPLJ3hnViFXLtgkGXaGR2xNsVaSg0CKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <CAErSpo5eFhpHwnYZvfXPLJ3hnViFXLtgkGXaGR2xNsVaSg0CKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 13, 2012 at 05:22:25PM -0700, Bjorn Helgaas wrote:
> [+cc Rafael]
>=20
> On Thu, Dec 13, 2012 at 8:31 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >
> > Correct ACPI PCI hotplug imeplementation should have _RMV method in a
> > PCI slot (device under pci bridge). In Acer Aspire S5 case we have it
> > deeper in hierarchy:
> >
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
> >
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  drivers/pci/hotplug/acpi_pcihp.c |   13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acp=
i_pcihp.c
> > index 2a47e82..d92ebfb 100644
> > --- a/drivers/pci/hotplug/acpi_pcihp.c
> > +++ b/drivers/pci/hotplug/acpi_pcihp.c
> > @@ -422,6 +422,19 @@ static int pcihp_is_ejectable(acpi_handle handle)
> >         status =3D acpi_evaluate_integer(handle, "_RMV", NULL, &removab=
le);
> >         if (ACPI_SUCCESS(status) && removable)
> >                 return 1;
> > +
> > +       /*
> > +        * Workaround for Thunderbolt implementation on Acer Aspire S5.
> > +        *
> > +        * Correct ACPI PCI hotplug imeplementation has _RMV method in =
a PCI
> > +        * slot (device under pci bridge). In Acer Aspire S5 case we ha=
ve it
> > +        * deeper in hierarchy.
> > +        */
> > +       status =3D acpi_evaluate_integer(handle, "HRDN.EPUP._RMV", NULL,
> > +                       &removable);
>=20
> I don't think encoding an ACPI path from the BIOS of a random machine
> here is the right approach.  The path components are completely
> implementation-dependent, and we'll end up carrying this test forever,
> long after the last Aspire S5 is in the landfill.
>=20
> We need a more generic approach that covers this case.  It would be
> interesting to see the rest of the ACPI namespace details under
> RP05.HRUP.  I guess we have RP05.HRUP._ADR, at least.  I'm not sure
> what the BIOS is trying to tell us by providing
> RP05.HRUP.HRDN.EPUP._RMV, but maybe we could figure it out if we knew
> more about HRDN and EPUP.

My guesses about acronyms:
HRUP -- host router upstream port (connected to PCI root port).
HRDN -- host router downstream port.
EPUP -- end point upstream port.

Looks like BIOS developers tried to be smart and described actual hierarchy
=66rom root port to end point.
The problem is that it doesn't fit to ACPI PCI hotplug. :(

Don't see anything useful in RP05.HRUP:

Device (HRUP)
{
    Name (_ADR, Zero)  // _ADR: Address
    Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
    {
        0x09,=20
        0x04
    })
    Device (HRDN)
    {
        Name (_ADR, 0x00040000)  // _ADR: Address
        Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
        {
            0x09,=20
            0x04
        })
        Device (EPUP)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
            {
                Return (One)
            }
        }
    }
}

--=20
 Kirill A. Shutemov

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQywOCAAoJEAd+omnVudOMLjwP/jKe9sTlRerY9yc7Jfgh8RM2
ACK8QoYfV3uus+P1SIfySKV9/ZYDaPEbKjSPKv+sGnZdCpPXB2J9iGS/UNBwuyvj
tX/kpRulDTAskqiD4IIV3FRGtuh04OgiPRAs3A9SX/vvlQQYTxBBsAqCqy60EQ+U
UK1tFJmd3/sbFvKsaqyOHdaC7dvIsznki1UaQqc2Xc5So5Efl+WNA8862UEVjzhE
UUayHixS6SPw78gRsQr2gf7b9ZbG6BewZ/UJ/VkCMa9oNUQ7+aNPX2l9ziNx4A7p
dKhkxRTprp72iQs3PmsC86kTw4OAtq6YKZLQhhBeIJjWPDai4jOchoYh1QaRbO5G
c5XBGymMZLedrttoPKsqnHd0iQsQoYTCR675dXj+0gxLVVLqidHCxRT/czBzNKeP
tNCgzmv/2ZU/phUY+8Y62Hu36fiJKppbDx7kxYUwf+HiZAev2siV8h9rcbouBJfA
O35laWgoZzDQkOneKVVSVaxyVgCd+DkljQ+5pbpTxiFqzKdvTwlpUlaP30cKgPNE
QjJwlR4PGr/AR4ywN/TXo5bniCsN7OkuxgpU/gMgxu57o8SNj2nwESsYW/JRGNcb
2HG8GMMMSxaPdUSPPQ2x/NfKjdjM/oWy4V+tfeVfr33eOHPO+8rJU7U8m2NL7F0a
49g81XVSA9CfANC7pIge
=pOqO
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
