Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423771Ab2LGBlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:41:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49020 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423073Ab2LGBlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:41:16 -0500
Message-ID: <1354844463.20838.33.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 06/89] device_cgroup: fix RCU usage
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Aristeu Rozanski <aris@redhat.com>, Li Zefan <lizefan@huawei.com>
Date: Fri, 07 Dec 2012 01:41:03 +0000
In-Reply-To: <20121206193602.GD3034@herton-Z68MA-D2H-B3>
References: <20121203143146.549859007@decadent.org.uk>
	 <20121203143147.609467839@decadent.org.uk>
	 <20121206193602.GD3034@herton-Z68MA-D2H-B3>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-V9KwnbxfphfqBSpD9XFo"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-V9KwnbxfphfqBSpD9XFo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-12-06 at 17:36 -0200, Herton Ronaldo Krzesinski wrote:
> On Mon, Dec 03, 2012 at 02:31:52PM +0000, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Tejun Heo <tj@kernel.org>
> >=20
> > commit 201e72acb2d3821e2de9ce6091e98859c316b29a upstream.
> >=20
> > dev_cgroup->exceptions is protected with devcgroup_mutex for writes
> > and RCU for reads; however, RCU usage isn't correct.
> >=20
> > * dev_exception_clean() doesn't use RCU variant of list_del() and
> >   kfree().  The function can race with may_access() and may_access()
> >   may end up dereferencing already freed memory.  Use list_del_rcu()
> >   and kfree_rcu() instead.
> >=20
> > * may_access() may be called only with RCU read locked but doesn't use
> >   RCU safe traversal over ->exceptions.  Use list_for_each_entry_rcu().
> >=20
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
> > Cc: Aristeu Rozanski <aris@redhat.com>
> > Cc: Li Zefan <lizefan@huawei.com>
> > [bwh: Backported to 3.2:
> >  - Adjust context
> >  - Exception list is called whitelist]
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>=20
> I belive this backport is uneeded for 3.2 (or any stable <=3D 3.6), since
> may_access_whitelist (may_access now in mainline) isn't called under
> rcu_read_lock.

I think you're right.  There are other readers that do rely on
rcu_read_lock(), but I don't think any of them can race with
devcgroup_destroy() (and if they can, it would have to use
kfree_rcu(dev_cgroup) as well).

You were too late for 3.2.35 but I'll revert this in the next update.

Ben.

> > ---
> >  security/device_cgroup.c |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >=20
> > --- a/security/device_cgroup.c
> > +++ b/security/device_cgroup.c
> > @@ -202,8 +202,8 @@ static void devcgroup_destroy(struct cgr
> > =20
> >  	dev_cgroup =3D cgroup_to_devcgroup(cgroup);
> >  	list_for_each_entry_safe(wh, tmp, &dev_cgroup->whitelist, list) {
> > -		list_del(&wh->list);
> > -		kfree(wh);
> > +		list_del_rcu(&wh->list);
> > +		kfree_rcu(wh, rcu);
> >  	}
> >  	kfree(dev_cgroup);
> >  }
> > @@ -278,7 +278,7 @@ static int may_access_whitelist(struct d
> >  {
> >  	struct dev_whitelist_item *whitem;
> > =20
> > -	list_for_each_entry(whitem, &c->whitelist, list) {
> > +	list_for_each_entry_rcu(whitem, &c->whitelist, list) {
> >  		if (whitem->type & DEV_ALL)
> >  			return 1;
> >  		if ((refwh->type & DEV_BLOCK) && !(whitem->type & DEV_BLOCK))
> >=20
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe stable" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
>=20

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-V9KwnbxfphfqBSpD9XFo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUMFJL+e/yOyVhhEJAQqI6w//d0hED75RNkDYF1ZYapRsm2LTirbDvO2J
Y1HaEh35GtPtLIoNEOFo7FvQAPPV9VGvqjtrpeAoHO4NEIHNxyLPrt07VFGpvo1Q
eZVJoeRbx6W1R7Sf7utwni9/Tlw4Wzb62deu+SSxeSjs+0QJCWhbQpU1413ND7Fz
J8YhA5PBSZN/ui+ZmDa9+4TTX9ra/8WJsHVhxOLG7lO0WP+LVMojejRLKWoZ0Vbc
GAZQEk33obOtmKNIzx2oF0YjxmBJfIviTs/ktZyzRlli0gJU/8AOD4/j8l8EyeBE
hnPZplMXMHwHEYK3O5eMCP9bR7RuqYvLhYkDHYddU9WLpF2zola6+vdjBFghm93t
YePRVr2ctICmop5VB5iwRAfZhwRG18nSL1HbMOgdydlMxXlabrzpV8KKYdH2osK5
5UoYiyMzNRnP+BNykvwh8SgJCEAeenW63cIdE3UpaqOh/dJNs5bmlFONxF1Oipn9
YKditvkOtUXkpmNESihCdW17rsy/yfxnXJrkr+BnhuxB5pVMOnNka55ZVdvAWzbO
UBBKGXXk1+8mY8u9Z29hkHVSyoiFhhHpUhW62noaoHSJq/NMspOqUF4dPdjqaJqg
8mllTrETjhYQsjpi62wfNLZZeXSVcPi+h/hH02lyVatRHjg0Pe2IMPTQUquKjkJ/
cbeF3Rv6OSQ=
=AsJq
-----END PGP SIGNATURE-----

--=-V9KwnbxfphfqBSpD9XFo--
