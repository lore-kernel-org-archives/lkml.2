Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab3AJHKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 02:10:30 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61766 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3AJHK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 02:10:28 -0500
Date: Thu, 10 Jan 2013 08:10:01 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Message-ID: <20130110071001.GD15212@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <201301092119.57067.arnd@arndb.de>
 <20130109215428.GA13648@avionic-0098.adnet.avionic-design.de>
 <201301092210.49452.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Content-Disposition: inline
In-Reply-To: <201301092210.49452.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:aUxO/srlA9UsfMMs3lf0dNZ3cZ2IWGx/fn/F8j/qjKc
 xYxpVLKlUO05FZFvv1j10Hvq/ZINXyLy+A1B6EM9mKP2OgPE31
 7o88I47V6XmpbY0j5Fvj06T6q29hyVQihhM1DSF3RqNKl73svp
 fXrv8Y3R04EawQOE4LWr8qxi5WAisV6Z+gQuviDa3hN9Dai9pH
 Bj5Glt4nLJwOIp6Wh/VssYjXKQFplmjtz4g8oXUDgkR3N2Hp/a
 bN3JN5ufFh1OtiVYe5gXlaWGKvuQpR36d+x45200ufJcYQYFQh
 EHbpcI26KKvlHj/duX6pTobWnExwHc78bKdfhddpuuZWFWBNFA
 Fm3mmp6Dd1Qul2DEqe6sSFvwC6nQMuFXA1IVZC+TeX3bl8jRzl
 9Qy1hony9pmHPPNECYU6CgHFSmyk9oFOu4fbQ0R9Dt6xVSNA2J
 zjlA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 09, 2013 at 10:10:49PM +0000, Arnd Bergmann wrote:
> On Wednesday 09 January 2013, Thierry Reding wrote:
> > What happens on Tegra is that we need to map 256 MiB of physical memory
> > to access all the PCIe extended configuration space. However, ioremap()
> > on such a large region fails if not enough vmalloc() space is available.
> >=20
> > This was observed when somebody tested this on CardHu which has a 1 GiB
> > of RAM and therefore remapping the full 256 MiB fails.
>=20
> Hmm, config space accesses are fairly rare and generally not expected
> to be fast, and 256 MB is really a huge waste of virtual address space,
> so I agree that just ioremapping the entire space is not a good
> solution.
>=20
> However, it's not clear that a cache is necessary. Have you measured
> a significant performance benefit of this implementation over just
> iorempping and unmapping a single page for every config space access?

No, I had not actually implemented it that way because I figured I might
just as well implement something generic with the added benefit that
most remapping operations would be cached automatically since the PCI
enumeration algorithms usually access the configuration space of a
single device at a time, so it actually maps to the best case for an LRU
based cache approach.

> Even if we actually want a cache, how about a private implementation
> that just remembers a single page in LRU? I doubt that there are
> more drivers that would benefit from a generalized version that you
> provide.

I can move the code to the Tegra PCIe driver, but there's quite a bit of
code that isn't actually related to the PCI functionality and I'd really
like to avoid cluttering the driver with this implementation. Keeping it
in a more central location will certainly increase the code's visibility
and make it easier for other potential users to find.

Also I just noticed that I hadn't actually added a parameter to the
iomap_cache_create() function to specify the maximum number of pages, so
currently the code only uses a single page anyway. It should be trivial
to change. I guess performance was good enough with a single page that I
didn't have a reason to increase the maximum number of pages.

Thierry

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7mlJAAoJEN0jrNd/PrOho4cQALbzSwxNCIfBwwmk9GtLE5XQ
uqdn6xhQU/mO1BlT6UVa5/4RI84uTfVel0sedtV4BFrJDZJLht9J5TvxmkdzxvXz
ISM0sZbgJ6MMjc3NasG6y0jDcS3qh+zx8zJHmEXE8HN+jud3oXYalSVJSfo80Jsx
QAeK5yicCDkhgHYyZIQhMk8TvI04IhC6/UlejbBWRt14mNeXyq6a0IYVmYTVuMcT
39k2j0VDsaAsnCXOv1cBHkArT7l/VwFZsELcuSmRhKbm4HcX7SotRsUe1J2CKaSo
5HHUCSmkyPCG0fRqn6+g/qAX9QtXxpuieToNxp1po64yJy8ulviTlfD2o9YrBmul
u1ns6gwvqoyKq3QlmKbFutMQKldGxsigQET94S+2fdqOwpx3O58EoFLqGqlV+zlS
4kEvXCs3usAaTxmXQkJbDomcxiW67k4T2BbA6ZJfKZoRokLABdOmBs0wymr9QnjJ
GzzRZqwFyoboJM9t89jn9hfKHnf0gCaZbrCApw4DH2LEceDtec7UeT1+bARDBbVT
07gB797w2zRohZsWW7thGnFzahs7QGEHd3CGDjK9eqOx2pDRKmqryQ5ZH8kVLv6n
UfP0em4az2L/LBw34q7jk/10aNzX6jfAi+2+roxxYQDAYAMF/hmKoudlLsQxsvsV
s2WIjuw1xBKT2TGHtiyh
=5aoQ
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
