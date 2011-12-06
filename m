Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab1LFFgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 00:36:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46753 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab1LFFgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 00:36:42 -0500
Date: Tue, 6 Dec 2011 16:36:28 +1100
From: NeilBrown <neilb@suse.de>
To: Kent Overstreet <koverstreet@google.com>
Cc: tejun@google.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: Re: Possible changes to bio cloning and some related stuff
Message-ID: <20111206163628.7ab8545f@notabene.brown>
In-Reply-To: <20111206051101.GA8171@dhcp-172-18-216-138.mtv.corp.google.com>
References: <20111206051101.GA8171@dhcp-172-18-216-138.mtv.corp.google.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dKV8au/ohyohmTKAjzl5iD8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dKV8au/ohyohmTKAjzl5iD8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Dec 2011 21:11:01 -0800 Kent Overstreet <koverstreet@google.com>
wrote:

> So, I finally got around to debugging various bcache on md issues, and I
> ran into a rather sticky problem:
>=20
> bio_alloc() can fail if nr_iovecs > BIO_MAX_PAGES. That itself is not a
> problem, but then when a bio is cloned it's always done by cloning the
> _entire_ original bio vec, from 0 to max_vecs - not the range from
> bi_idx to bi_vcnt.
>=20
> Basically, whenever bcache generates some io internally it uses a single
> bio to describe the entire io - regardless of whether or not the bio
> would be too big for the underlying device; it then splits the bio as
> many times as need be when it's actually submitted.
>=20
> This works beautifully for dumb drivers - I'm actually planning on
> making my code generic and integrating it with the block layer so that
> the same approach could be easily used by other code that generates
> bios, it would allow a _lot_ of code to be deleted from the kernel.

Sounds promising.

>=20
> But for stacking drivers, the mere existence of a bio with max_vecs >
> BIO_MAX_PAGES breaks things, regardless of how many pages are actually
> being used in this bio.
>=20
> So, IMO __bio_clone(), bio_clone_mddev(), and whatever other code ought
> to be changed to only copy bi_idx to bi_vcnt from the original bio -
> it'd make it consistent with how bios are used elsewhere. Thoughts? The
> actual patches should be trivial, it'll mostly just be a matter of
> grepping around and finding everything, I think.

I'm not against this.  There are a few places where md assumes there is a 1=
-1
mapping between original and cloned bios.  It probably wouldn't be too hard
to find those and adjust them to your new scheme.

So if you write patches I'll help make sure they work on md.

Thanks,
NeilBrown

--Sig_/dKV8au/ohyohmTKAjzl5iD8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt2p3Dnsnt1WYoG5AQIAxRAAhbnamCNN23v05BW09oDPLR1vV1JTCq/3
g9AHEJzv8Ipn1PT6QHAJ7oS7HiJyHRQF2DmHqVv/egIHzqR/rSUb3CtR9zxmMHUc
bvlgS7lO6ncwQwEzocCtVfZxBHeq8Y/eRiwJO/DiVS24M8oNmI1bx3rGYiGkYfNN
OqDIUEr6VUtymHSYQsLCu4e59mbOv1q8a9fuIOjWauTfeX6DTeJ7w0pLGVWtXk0Z
nQ2uixpcp3vQ6ccJ9WUk0rgIrb++5f+avBnMrpYMuK864nZ8oc9ewVATcJG87xTW
yPQDnqoZTtpc33upFLyesk37Rg2+nZzXvVKHQWDeNLAQtrajLE/n5vOMPBvLiHBn
Lw+RNQgdX9yTKh7MFxf7AeviqVZwc2AwbjySHLGxIAeA9cWvnR7aKsEGRl9UEN9y
W2MLKGHcUQw03NX50PbbsNy8rRgLIEo+kmh3l5dG8Wi+43zsDs1LuXeYknB5M4p5
JKoAC8PJ2axip8wqRq1JMg5D8mtM1GtA1BicDt2b3CofwlfUf6SLXu1v2ZOgl+2O
i6LJm3J7LkoqJj28EOcLBVg6JBidsOKTaZji/DmcP+1baCMeDFydDY1FM4oJpdSD
lzPTRE2KVJWkJpZEf6axAe4dmOWENt/MShB6BOpzc0xXfCLIUBbXq8E6BCficRwZ
w2tw85W28x0=
=0gxG
-----END PGP SIGNATURE-----

--Sig_/dKV8au/ohyohmTKAjzl5iD8--
