Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab3AJTDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:03:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60876 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3AJTDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:03:40 -0500
Date: Thu, 10 Jan 2013 20:03:27 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Message-ID: <20130110190327.GA23110@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130109231758.GA27065@obsidianresearch.com>
 <20130110071937.GG15212@avionic-0098.adnet.avionic-design.de>
 <201301100917.19577.arnd@arndb.de>
 <20130110102544.GA5546@avionic-0098.adnet.avionic-design.de>
 <20130110182007.GA28004@obsidianresearch.com>
 <20130110185505.GA22944@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <20130110185505.GA22944@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:LKzhKXAPsUoE3+GWqjhaXwBaxRJpRDLUhF8BqodysnD
 s5DqRT4eWXgQHABKl2uz/+Rzz2mhA+676tgBab4u8Sai9RSHUV
 wEYECoTE5swPP55Ba6xy+5dZOnq+GfC+SYJcIsKNwblEp3eWUC
 Vgr0vFBJyHXmfZ85bIccZAaWr2yR6172owRE71f20NWlVi7M8W
 XOPAlvwmvk8gEe5RVC5zDxERHTkktaWgbvfl1BNYLoVejo4/O5
 TVeKbFJNEKgnwbMtsRuSRqSWmjPnsTe+bFzeo5obud3LZN7kie
 xuP4KuU2TJWLdIfzeo3vSU3y5An33nLmR61F3aDfOPN4X1SrBt
 ahXjzKsN9z1iviJ98iNy6Xy0RtUaPwb2RkYzuuihxYwDCs10/z
 CWySn8TbGQ2VD6Obkagj1jbEq1cp4KR+20=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2013 at 07:55:05PM +0100, Thierry Reding wrote:
> On Thu, Jan 10, 2013 at 11:20:07AM -0700, Jason Gunthorpe wrote:
> > On Thu, Jan 10, 2013 at 11:25:44AM +0100, Thierry Reding wrote:
> > > On Thu, Jan 10, 2013 at 09:17:19AM +0000, Arnd Bergmann wrote:
> > > > On Thursday 10 January 2013, Thierry Reding wrote:
> > > > > On Wed, Jan 09, 2013 at 04:17:58PM -0700, Jason Gunthorpe wrote:
> > > > > > On Wed, Jan 09, 2013 at 04:12:31PM -0700, Stephen Warren wrote:
> > > > > > You could decrease the size of the mapping to only span the bus
> > > > > > numbers that are configured for use via DT.
> > > > >=20
> > > > > That won't work, unfortunately. The mapping is such that the bus =
number
> > > > > is not encoded in the uppermost bits, the extended register numbe=
r is.
> > > > > So the only thing that we could do is decrease the size of the ex=
tended
> > > > > register space for *all* devices.
> > > >=20
> > > > But you could still a method to map 16 separate areas per bus, each=
 65536
> > > > bytes long, which results in 1MB per bus. That is probably ok, since
> > > > very few systems have more than a handful of buses in practice.
> > > >=20
> > > > In theory, doing static mappings on a per-page base would let you
> > > > do 16 devices at a time, but it's probably worth doing at this fine
> > > > granularity.
> > >=20
> > > I don't understand how this would help. The encoding is like this:
> > >=20
> > > 	[27:24] extended register number
> > > 	[23:16] bus number
> > > 	[15:11] device number
> > > 	[10: 8] function number
> > > 	[ 7: 0] register number
> > >=20
> > > So it doesn't matter whether I use separate areas per bus or not. As
> > > soon as the whole extended configuration space needs to be accessed a
> > > whopping 28 bits (256 MiB) are required.
> >=20
> > You'd piece a mapping together, each bus requires 16 64k mappings, a
> > simple 2d array of busnr*16 of pointers would do the trick. A more
> > clever solution would be to allocate contiguous virtual memory and
> > split that up..
>=20
> Oh, I see. I'm not very familiar with the internals of remapping, so
> I'll need to do some more reading. Thanks for the hints.

I forgot to ask. What's the advantage of having a contiguous virtual
memory area and splitting it up versus remapping each chunk separately?

Thierry

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7xB/AAoJEN0jrNd/PrOhZpEP+we1xAuIrMAjE1b8jylJ+sbZ
aWhd6eAMZOhhfC42ZimjnbE1foHY3LSVmqjYO+U9jKLw8TdwlmVzqXmkOmtekP/+
tjwgymJO2TG7cOV4Au3uwhV5EsAOqynLNgDCOwkyZwAvVo+efiiKZKv+ePOHhCcu
ZXCFJ7cMGdcvaXJfs8zEORTimvsfrqnPw+2GU28UdL2fQ18k1iOg/UQI0TdJvnRA
TZMi55OYKWSrHb5H9QrP7UuDU8XYDK83BXl3U5jAJ6arYRCSIgByMZo63PVtSrp6
22wY6ky4Zy20vRs1ji66NT/VxvcDWKdMTmf5z+wuyY6U1Skq2V14JCrlvuffH4jh
AK8bJpeVqNmh2ccJlHXv08cq68wmXMv+OPoOz7dRlBD6AjcxhlGABZTU3rpAt49y
ujf24T45sEDNKcPcKXlTjjL77P9L41k+VHSPSdKlIuAyFeRxl+2cwy61aneNV0qX
Lk8FmpROusRGg4GFjhOHIz0HxmdkiauEawDp0crFnjwqq6zIgvCtt7M7D5Hz/F/x
PCvCGNGe8akhCfgIXh3JIKYHERxWx2FRtfFjj+2ZG3zL7RR79ET4oQHTHCFH3TIF
E6YdbRZ9eBitvmykZpiLkr7XSKMVEpTmk7tfJWQDBtJ4HVHivDSnn0+MkNgJcCdv
3QhfUnzAiOpBqZnjmy/M
=xrPE
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
