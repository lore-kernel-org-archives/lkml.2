Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab1FJN14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:27:56 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38222 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab1FJN1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:27:54 -0400
Date: Fri, 10 Jun 2011 09:27:48 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: arnd@arndb.de, akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        mingo@elte.hu, randy.dunlap@oracle.com, josh@joshtriplett.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        mgorman@suse.de, linux-mm@kvack.org
Subject: Re: [PATCH] Add debugging boundary check to pfn_to_page
Message-ID: <20110610132748.GA5759@mgebm.net>
References: <1307560734-3915-1-git-send-email-emunson@mgebm.net>
 <1307566168.3048.137.camel@nimitz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <1307566168.3048.137.camel@nimitz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 08 Jun 2011, Dave Hansen wrote:

> On Wed, 2011-06-08 at 15:18 -0400, Eric B Munson wrote:
> > -#define __pfn_to_page(pfn)                             \
> > -({     unsigned long __pfn =3D (pfn);                    \
> > -       struct mem_section *__sec =3D __pfn_to_section(__pfn);    \
> > -       __section_mem_map_addr(__sec) + __pfn;          \
> > +#ifdef CONFIG_DEBUG_MEMORY_MODEL
> > +#define __pfn_to_page(pfn)                                            =
 \
> > +({     unsigned long __pfn =3D (pfn);                                 =
   \
> > +       struct mem_section *__sec =3D __pfn_to_section(__pfn);         =
   \
> > +       struct page *__page =3D __section_mem_map_addr(__sec) + __pfn; =
   \
> > +       WARN_ON(__page->flags =3D=3D 0);                               =
     \
> > +       __page;                                                        =
 \
>=20
> What was the scenario you're trying to catch here?  If you give a really
> crummy __pfn, you'll probably go off the end of one of the mem_section[]
> arrays, and get garbage back for __sec.  You might also get a NULL back
> from __section_mem_map_addr() if the section is possibly valid, but just
> not present on this particular system.
>=20
> I _think_ the only kind of bug this will catch is if you have a valid
> section, with a valid section_mem_map[] but still manage to find
> yourself with an 'struct page' unclaimed by any zone and thus
> uninitialized.

This is the case I was going after.  I will rework for a V2 based on the
feedback here.

>=20
> You could catch a lot more cases by being a bit more paranoid:
>=20
> void check_pfn(unsigned long pfn)
> {
> 	int nid;
> =09
> 	// hacked in from pfn_to_nid:
> 	// Don't actually do this, add a new helper near pfn_to_nid()
> 	// Can this even fit in the physnode_map?
> 	if (pfn / PAGES_PER_ELEMENT > ARRAY_SIZE(physnode_map))
> 		WARN();
>=20
> 	// Is there a valid nid there?
> 	nid =3D pfn_to_nid(pfn);
> 	if (nid =3D=3D -1)
> 		WARN();
> =09
> 	// check against NODE_DATA(nid)->node_start_pfn;
> 	// check against NODE_DATA(nid)->node_spanned_pages;
> }
> >  })
> > +#else
> > +#define __pfn_to_page(pfn)                                            =
 \
> > +({     unsigned long __pfn =3D (pfn);                                 =
   \
> > +       struct mem_section *__sec =3D __pfn_to_section(__pfn);         =
   \
> > +       __section_mem_map_addr(__sec) + __pfn;  \
> > +})
> > +#endif /* CONFIG_DEBUG_MEMORY_MODEL */=20
>=20
> Instead of making a completely new __pfn_to_page() in the debugging
> case, I'd probably do something like this:
>=20
> #ifdef CONFIG_DEBUG_MEMORY_MODEL
> #define check_foo(foo) {\
> 	some_check_here(foo);\
> 	WARN_ON(foo->flags);\
> }
> #else
> #define check_foo(foo) do{}while(0)
> #endif;
>=20
> #define __pfn_to_page(pfn)                                             \
> ({     unsigned long __pfn =3D (pfn);                                    \
>        struct mem_section *__sec =3D __pfn_to_section(__pfn);            \
>        struct page *__page =3D __section_mem_map_addr(__sec) + __pfn;    \
>        check_foo(page)							\
>        __page;                                                         \
>  })
>=20
> That'll make sure that the two copies of __pfn_to_page() don't
> accidentally diverge.  It also makes it a lot easier to read, I think.
>=20
> -- Dave
>=20

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8hvUAAoJEH65iIruGRnNj0YH/juWjOLtEst08mRTW+su+Ogf
qfFlQ/XBzc6QbKhTzZlUrldobjDD/rbFFIXj2PBytbSSw/ZGGHuZRKPuQoyaPj39
k5L41VkB1Fx+uwHiFh0gAHGe0eQ9iQwdJIWvLrBZrW4Ud5VDs09sg0QWbRRSEDoR
FExqZw4RXSRhWOZF630X7OJA00/dcAkU5VBiQtF+ZOiYpfwS7DQMGA4TCEzbmyM3
XJVgXbFFpm8u/Nuzi+UCG5MPNuhctJW7R0LHmU94xr9mEmen2XaZvwlwWNI/K+D6
lwWm/b13Q+GUyod4iUHrVqFqk8n15da79aLeTmCNaCIvqaMtAhQdwSokm53RaX0=
=2zMr
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
