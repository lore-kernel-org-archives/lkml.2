Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161041Ab2JXTzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:55:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:45341 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964884Ab2JXTzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:55:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,642,1344236400"; 
   d="asc'?scan'208";a="239698531"
Date: Wed, 24 Oct 2012 22:45:52 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 10/10] thp: implement refcounting for huge zero page
Message-ID: <20121024194552.GA24460@otc-wbsnb-06>
References: <1350280859-18801-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1350280859-18801-11-git-send-email-kirill.shutemov@linux.intel.com>
 <20121018164502.b32791e7.akpm@linux-foundation.org>
 <20121018235941.GA32397@shutemov.name>
 <20121023063532.GA15870@shutemov.name>
 <20121022234349.27f33f62.akpm@linux-foundation.org>
 <20121023070018.GA18381@otc-wbsnb-06>
 <20121023155915.7d5ef9d1.akpm@linux-foundation.org>
 <20121023233801.GA21591@shutemov.name>
 <20121024122253.5ecea992.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20121024122253.5ecea992.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 24, 2012 at 12:22:53PM -0700, Andrew Morton wrote:
> On Wed, 24 Oct 2012 02:38:01 +0300
> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
>=20
> > On Tue, Oct 23, 2012 at 03:59:15PM -0700, Andrew Morton wrote:
> > > On Tue, 23 Oct 2012 10:00:18 +0300
> > > "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> > >=20
> > > > > Well, how hard is it to trigger the bad behavior?  One can easily
> > > > > create a situation in which that page's refcount frequently switc=
hes
> > > > > from 0 to 1 and back again.  And one can easily create a situatio=
n in
> > > > > which the shrinkers are being called frequently.  Run both at the=
 same
> > > > > time and what happens?
> > > >=20
> > > > If the goal is to trigger bad behavior then:
> > > >=20
> > > > 1. read from an area where a huge page can be mapped to get huge ze=
ro page
> > > >    mapped. hzp is allocated here. refcounter =3D=3D 2.
> > > > 2. write to the same page. refcounter =3D=3D 1.
> > > > 3. echo 3 > /proc/sys/vm/drop_caches. refcounter =3D=3D 0 -> free t=
he hzp.
> > > > 4. goto 1.
> > > >=20
> > > > But it's unrealistic. /proc/sys/vm/drop_caches is only root-accessi=
ble.
> > >=20
> > > Yes, drop_caches is uninteresting.
> > >=20
> > > > We can trigger shrinker only under memory pressure. But in this, mo=
st
> > > > likely we will get -ENOMEM on hzp allocation and will go to fallbac=
k path
> > > > (4k zero page).
> > >=20
> > > I disagree.  If, for example, there is a large amount of clean
> > > pagecache being generated then the shrinkers will be called frequently
> > > and memory reclaim will be running at a 100% success rate.  The
> > > hugepage allocation will be successful in such a situation?
> >=20
> > Yes.
> >=20
> > Shrinker callbacks are called from shrink_slab() which happens after pa=
ge
> > cache reclaim, so on next reclaim round page cache will reclaim first a=
nd
> > we will avoid frequent alloc-free pattern.
>=20
> I don't understand this.  If reclaim is running continuously (which can
> happen pretty easily: "dd if=3D/fast-disk/large-file") then the zero page
> will be whipped away very shortly after its refcount has fallen to
> zero.
>=20
> > One more thing we can do: increase shrinker->seeks to something like
> > DEFAULT_SEEKS * 4. In this case shrink_slab() will call our callback af=
ter
> > callbacks with DEFAULT_SEEKS.
>=20
> It would be useful if you could try to make this scenario happen.  If
> for some reason it doesn't happen then let's understand *why* it
> doesn't happen.
>=20
> I'm thinking that such a workload would be the above dd in parallel
> with a small app which touches the huge page and then exits, then gets
> executed again.  That "small app" sounds realistic to me.  Obviously
> one could exercise the zero page's refcount at higher frequency with a
> tight map/touch/unmap loop, but that sounds less realistic.  It's worth
> trying that exercise as well though.
>=20
> Or do something else.  But we should try to probe this code's
> worst-case behaviour, get an understanding of its effects and then
> decide whether any such workload is realisic enough to worry about.

Okay, I'll try few memory pressure scenarios.

Meanwhile, could you take patches 01-09? Patch 09 implements simpler
allocation scheme. It would be nice to get all other code tested.
Or do you see any other blocker?

--=20
 Kirill A. Shutemov

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiEVwAAoJEAd+omnVudOMi7gP/ROh/ocVBGxEtSWi9skeJUdN
+r2mLlui5bYqu12gbXzOcJSpqaefvG6BiAaaGl3GMAlWhIvLBvew7m+t3jlBsbIZ
V305R0Vea50qYddOmw11TVtTWZR25+bEY94vHDndF8AJ4NXof+ytf/QqRFPPkebU
+cwNdxJPmRKw3u0FMkEpY6xbBLIFm1sVxQITIYqH5tZD9bkDGsOyeQj2DaHbtI3p
nhExB6zr7gYNff+WnhHFdPpGResRUMXtBbJl51pTkcxY+p1J4h6tz2ee9wOuKp+4
Co6H3tL8BOkH1YYONnWWYty7mcM7Sq47lQMaVBMLBzt8QENbsjCifhPHgdCMjj6m
0EjwvUKuQe2uqON1IH9N+MidS0bdwe7Wnv2Lmok8j0h+hBEp9Aj/FMZXQMDFnbeF
kBIoIVfYVyD0Vk3vZDejj1LPjmVQVvddSSNV22QnFrBfG3G69RYBZnT3QtEUpZmF
/lVDW1CjDYsO7B14hYaSg2gr1RhGVTdq0/iRnkLVlINO/Pq5FJuY9E5f50bvPUvM
dx+T3P59HBXoZU1kHpVk9/rV9I17YGomBeAA2xmn4OQ5Dv3EkYO2FwIVSP+KHpCp
XnagOOsiYaAu1pvIMZeFN29keZbM2/yOI6lsgnvj2x/BzA6ywM09LMyMf9dIMltA
WwaxuYW1Pogfb6+LgguJ
=XaGy
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
