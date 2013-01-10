Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3AJK0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:26:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62450 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3AJK0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:26:14 -0500
Date: Thu, 10 Jan 2013 11:25:44 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Message-ID: <20130110102544.GA5546@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130109231758.GA27065@obsidianresearch.com>
 <20130110071937.GG15212@avionic-0098.adnet.avionic-design.de>
 <201301100917.19577.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <201301100917.19577.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:7CD95tWdq+zox7q1W7OHJgiBSawMuQ7QPFvLqQQ//C/
 F92WdfUpsaN0I0j2SU8a/gTa/UEo8iY7Y4qa8oAadCKgUTrL+O
 2tSdSomWJBp4iFr4gcQ4X1fHWwul0Q3ySFz4Wjd+h1ImVbwpmT
 ud2ZvPFhUOrAFmLQ64BWhL2ioE4gj278Tgx5l51muvIZvvc3QL
 rgK8qGhg0EtuFya1cJdg9LJHLKUEtapGslWSgYKzWdz6szTgxT
 GYyNVPtZl2RuZj/3AlT3Z4nTBTuz8WViNIyKp97KpgRlcosHCQ
 x/e++PBj+hh/mkWmT3XkC4qA/AY9ipAmDIuUCsvvZsUVMaDZe0
 pLfd2BEiYtiedDek6DQ9AxM0ILhveAVbcZI5RkYjfCuoQeu5/O
 E+q+spM+rs8gD9OwrQh+yFy96tUviEn5I4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2013 at 09:17:19AM +0000, Arnd Bergmann wrote:
> On Thursday 10 January 2013, Thierry Reding wrote:
> > On Wed, Jan 09, 2013 at 04:17:58PM -0700, Jason Gunthorpe wrote:
> > > On Wed, Jan 09, 2013 at 04:12:31PM -0700, Stephen Warren wrote:
> > > You could decrease the size of the mapping to only span the bus
> > > numbers that are configured for use via DT.
> >=20
> > That won't work, unfortunately. The mapping is such that the bus number
> > is not encoded in the uppermost bits, the extended register number is.
> > So the only thing that we could do is decrease the size of the extended
> > register space for *all* devices.
>=20
> But you could still a method to map 16 separate areas per bus, each 65536
> bytes long, which results in 1MB per bus. That is probably ok, since
> very few systems have more than a handful of buses in practice.
>=20
> In theory, doing static mappings on a per-page base would let you
> do 16 devices at a time, but it's probably worth doing at this fine
> granularity.

I don't understand how this would help. The encoding is like this:

	[27:24] extended register number
	[23:16] bus number
	[15:11] device number
	[10: 8] function number
	[ 7: 0] register number

So it doesn't matter whether I use separate areas per bus or not. As
soon as the whole extended configuration space needs to be accessed a
whopping 28 bits (256 MiB) are required.

What you propose would work if only regular configuration space is
supported. I'm not sure if that's an option.

> > > Are there any concerns about these config registers being accessed
> > > from a context where a new mapping can't be made? Interrupt? Machine
> > > Check? PCI-E Advanced Error Reporting?
> >=20
> > I haven't checked but I would expect configuration space accesses to not
> > happen in interrupt context. Usually they are limited to enumeration and
> > driver probe.
>=20
> Actually, AER probably needs this, and I believe some broken devices=20
> need to mask interrupts using the PCI command word in the config space,
> it it can happen.

Ugh... that would kill any such dynamic mapping approach. Perhaps if we
could mark a device as requiring a static mapping we could pin that
cache entry. But that doesn't sound very encouraging.

Thierry

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7pcoAAoJEN0jrNd/PrOhzWAQAJU8h6+cUFml8Y/ItAuxpx7X
4JokweZ46zAbLIRfTn7XVX7ICa80iPbgf0eJjno2w9mDpr1NA6DUvNg4/IWncM1t
3yQngkKc98gz0rRV7wjpzlTav8q1W5KjTK4WexEX+n6Z6rsjAtlxIzViAvSPOekH
Nr/oHRaAYirdndAH8dmL8aifZKayaHDKYtVCIJ2xQOXTyplwZYIN5DWFWs4pdHta
IE5ZUTc5qf8djpvrlIcjBrPPVSxS6B/04uU9ovbFxbrqIGhnnwfqlYNiU+j+p57x
sRV0QsXk0XwAPvAdD3JzQsSB2U6ZEKlDleOWNO3yhFWobFQrLF9zktzm4wIvooo6
e4aekihXMHjCN2CjRl7dk/NXw2dyFY4AIc1YEdDuXXt3N8eUhamvDVV9RMvx80wK
CiiKA1M1SuEqHRKK7CBPSrGMBo3alogKNwAtPPfqAjPaiELtkmgjOGa4x/rzmVBH
M4VsH/C+p231Hg5vdQ+GKYgPEV0OYZ90BJpGUSZMeYliAroVenXgo37NDozD+Mdu
hW8lmae/L10twv36bZu720P16aU9RF60Mqa7x/RpLePt112VgyAA6vTc5V0ARGF5
Im4zjmaPp6vG67byaXXJb5aokg0sIfo1ezFnS6oMrqV8Wg+2clhWu8KQ7JTcDjPV
UhtFN0S5FBlhiZigRKGN
=sViQ
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
