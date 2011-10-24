Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1JXUJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:09:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54274 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab1JXUJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:09:37 -0400
Date: Mon, 24 Oct 2011 22:09:33 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg KH <gregkh@suse.de>, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC 3/4] lib: devres: add convenience function to remap a
 resource
Message-ID: <20111024200933.GB6326@pengutronix.de>
References: <1319445729-14841-1-git-send-email-w.sang@pengutronix.de>
 <1319445729-14841-4-git-send-email-w.sang@pengutronix.de>
 <20111024154307.GB24914@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <20111024154307.GB24914@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> On Mon, Oct 24, 2011 at 10:42:08AM +0200, Wolfram Sang wrote:
> > * the new function is not named 'devm_ioremap_resource' because it does=
 more than
> >   just ioremap, namely request_mem_region. I didn't want to create impl=
icit
> >   knowledge here.
>=20
> Maybe devm_request_and_ioremap_resource()?  Maybe it's a bit long but
> A_to_B names are usually used for trivial conversions.

I had this name in mind, too. Yet, it implies that the function requests a
resource but in fact it requests a mem_region. Requesting a resource (e.g.
platform_get_resource) is THE thing the function does not do. So I scrapped
this name. But will do some more brainstorming for a better name in V2.

>=20
> > +int __must_check devm_resource_to_mapped_ptr(struct device *dev,
> > +			struct resource *res, void __iomem **dest)
>=20
> If we're already printing out dev_err(), I think we can live with
> %NULL return on error.

Yes, already fixed this way.

> > +{
> > +	resource_size_t size;
> > +	const char *name;
> > +
> > +	BUG_ON(!dev || !dest);
> > +
> > +	*dest =3D NULL;
> > +
> > +	if (!res || resource_type(res) !=3D IORESOURCE_MEM) {
> > +		dev_err(dev, "invalid resource\n");
> > +		return -ENOENT;
> > +	}
> > +
> > +	size =3D resource_size(res);
> > +	name =3D res->name ?: dev_name(dev);
> > +
> > +	if (!devm_request_mem_region(dev, res->start, size, name)) {
> > +		dev_err(dev, "can't request region for resource %pR\n", res);
> > +		return -EBUSY;
> > +	}
> > +
> > +	if (res->flags & IORESOURCE_CACHEABLE)
> > +		*dest =3D devm_ioremap(dev, res->start, size);
> > +	else
> > +		*dest =3D devm_ioremap_nocache(dev, res->start, size);
> > +
> > +	if (!*dest) {
> > +		dev_err(dev, "ioremap failed for resource %pR\n", res);
> > +		return -ENOMEM;
> > +	}
>=20
> So, for library functions, it's nice if the function doesn't hold any
> extra resource on error return.  devres has grouping to support this.
> You just need to wrap allocations inside a group and remove it on
> success and release on error.  ie.
>=20
> 	if (!devres_open_group(dev, NULL, GFP_KERNEL))
> 		return NULL;
> 	if (alloc_resource(0) < 0)
> 		goto fail;
> 	if (alloc_resource(1) < 0)
> 		goto fail;
> 	devres_remove_group(dev, NULL);
> 	return 0;
> fail:
> 	devres_release_group(dev, NULL);
> 	return 0;

I am not sure I got what you mean here, but wouldn't it be easier to simply
call devm_release_mem_region() when devm_ioremap comes back with a NULL
pointer?

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6lxf0ACgkQD27XaX1/VRtxiQCgr1SlL0N/kmHdyrwkzhxVEpHD
PB4An1LMcrwe+FEXyrp1Lqo004S8GpJ6
=OoUg
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
