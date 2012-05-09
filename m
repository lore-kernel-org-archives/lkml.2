Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab2EIHIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:08:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:36139 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab2EIHIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:08:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="138525208"
Date: Wed, 9 May 2012 10:09:06 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v4] hwmon: coretemp: use list instead of fixed size
 array for temp data
Message-ID: <20120509070906.GA21556@otc-wbsnb-06>
References: <1336474175-5714-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1336495180.22553.68.camel@groeck-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <1336495180.22553.68.camel@groeck-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 08, 2012 at 09:39:40AM -0700, Guenter Roeck wrote:
> On Tue, 2012-05-08 at 06:49 -0400, Kirill A. Shutemov wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >=20
> > Let's rework code to allow arbitrary number of cores on a CPU, not
> > limited by hardcoded array size.
> >=20
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  v4:
> >    - address issues pointed by Guenter Roeck;
> >  v3:
> >    - drop redundant refcounting and checks;
> >  v2:
> >    - fix NULL pointer dereference. Thanks to R, Durgadoss;
> >    - use mutex instead of spinlock for list locking.
> > ---
>=20
> Hi Kirill,
>=20
> unfortunately now we have another race condition :(. See below ...

Ughh..

> > @@ -557,11 +579,22 @@ exit_free:
> >  static int __devexit coretemp_remove(struct platform_device *pdev)
> >  {
> >  	struct platform_data *pdata =3D platform_get_drvdata(pdev);
> > -	int i;
> > +	struct temp_data *tdata;
> > =20
> > -	for (i =3D MAX_CORE_DATA - 1; i >=3D 0; --i)
> > -		if (pdata->core_data[i])
> > -			coretemp_remove_core(pdata, &pdev->dev, i);
> > +	for (;;) {
> > +		mutex_lock(&pdata->temp_data_lock);
> > +		if (!list_empty(&pdata->temp_data_list)) {
> > +			tdata =3D list_first_entry(&pdata->temp_data_list,
> > +					struct temp_data, list);
> > +			list_del(&tdata->list);
> > +		} else
> > +			tdata =3D NULL;
> > +		mutex_unlock(&pdata->temp_data_lock);
> > +
> > +		if (!tdata)
> > +			break;
> > +		coretemp_remove_core(tdata, &pdev->dev);
> > +	}
> > =20
> Unfortunately, that results in a race condition, since the tdata list
> entry is gone before the attribute file is deleted.
>=20
> I think you can still use list_for_each_entry_safe, only outside the
> mutex, and remove the list entry at the end of coretemp_remove_core()
> after deleting the attribute file. Just keep the code as it was, and
> remove the list entry (mutex-protected) where core_data[] was set to
> NULL.

I think

if (tdata)
	return -ENODEV;

in show methods will fix the issue. Right?

>=20
> >  	device_remove_file(&pdev->dev, &pdata->name_attr);
> >  	hwmon_device_unregister(pdata->hwmon_dev);
> > @@ -641,16 +674,18 @@ static void __cpuinit coretemp_device_remove(unsi=
gned int cpu)
> > =20
> >  static bool __cpuinit is_any_core_online(struct platform_data *pdata)
> >  {
> > -	int i;
> > +	struct temp_data *tdata;
> > +	bool ret =3D false;
> > =20
> > -	/* Find online cores, except pkgtemp data */
> > -	for (i =3D MAX_CORE_DATA - 1; i >=3D 0; --i) {
> > -		if (pdata->core_data[i] &&
> > -			!pdata->core_data[i]->is_pkg_data) {
> > -			return true;
> > +	mutex_lock(&pdata->temp_data_lock);
> > +	list_for_each_entry(tdata, &pdata->temp_data_list, list) {
> > +		if (!tdata->is_pkg_data) {
>=20
> Actually, we don't need is_pkg_data anymore at all. Just test for
> "tdata->id =3D=3D 1" instead. That will simplify the code a bit.

Okay, I'll update this.

> > +			ret =3D true;
> > +			break;
> >  		}
> >  	}
> > -	return false;
> > +	mutex_unlock(&pdata->temp_data_lock);
> > +	return ret;
> >  }
> > =20
> >  static void __cpuinit get_core_online(unsigned int cpu)
> > @@ -697,9 +732,10 @@ static void __cpuinit get_core_online(unsigned int=
 cpu)
> > =20
> >  static void __cpuinit put_core_offline(unsigned int cpu)
> >  {
> > -	int i, indx;
> > +	int i, attr_no;
> >  	struct platform_data *pdata;
> >  	struct platform_device *pdev =3D coretemp_get_pdev(cpu);
> > +	struct temp_data *tdata;
> > =20
> >  	/* If the physical CPU device does not exist, just return */
> >  	if (!pdev)
> > @@ -707,14 +743,15 @@ static void __cpuinit put_core_offline(unsigned i=
nt cpu)
> > =20
> >  	pdata =3D platform_get_drvdata(pdev);
> > =20
> > -	indx =3D TO_ATTR_NO(cpu);
> > +	attr_no =3D TO_ATTR_NO(cpu);
> > =20
> > -	/* The core id is too big, just return */
> > -	if (indx > MAX_CORE_DATA - 1)
> > -		return;
> > -
> > -	if (pdata->core_data[indx] && pdata->core_data[indx]->cpu =3D=3D cpu)
> > -		coretemp_remove_core(pdata, &pdev->dev, indx);
> > +	tdata =3D get_temp_data(pdata, attr_no);
> > +	if (tdata && tdata->cpu =3D=3D cpu) {
> > +		mutex_lock(&pdata->temp_data_lock);
> > +		list_del(&tdata->list);
> > +		mutex_unlock(&pdata->temp_data_lock);
> > +		coretemp_remove_core(tdata, &pdev->dev);
>=20
> Same race condition as above here.
>=20
> > +	}
> > =20
> >  	/*
> >  	 * If a HT sibling of a core is taken offline, but another HT sibling
>=20
>=20

--=20
 Kirill A. Shutemov

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJPqhgSAAoJEAd+omnVudOMOfcP9RH8NB3fqvk6Rd8tylLTciuL
SP+oBK+P0YcEWd12vzGk4ht+i2M7GReruA+ZFokI91NXQKkyoiWKYVVzDwPzA/bl
eGeF4n9VeZNget9mnvoxquaw7cS6W50yGwZ8ag97sizkVmiPdy8p8lKym49sQPq0
dWrcOpcwMZkRXWIihms3la2JYNPiIpUJAi+Wq5pw4ZcLrzCbb568rlBcrTd/h58z
Gfy7H3AhQYmav+3Zduacjh86YCQeJjThc/xOUbdzJTZL9Lh6ZimnKkbK5aS8Pvxh
dMtmkpx/vo4KbjYoCd8zQCSd7PyfhE/mBk6h51n6J8cWQ+WHQaFVs0wlLhxQ51nL
5wjYDet7ntc63D2Yv5ScMYa7PmEYyjxPgbB34MGPbCzGGZWPSNqu7jLunN4dziSy
grWCRVS2/dqL+P2HUoNE+3VGMTJNIbB1qUnAMJgryqJnbHt0aEG0tEi3HqzYZziP
bNRfP5Hiv5doHa4LLoX7TY44oymmQaQCnlhwvC4cjg8me8xBxqEXLDvffjAdZ7Re
ma/u6YpNkfcuIv6Up8hC1G1ePFg/v1ObyBuAQ3gDsRZKOZLuMdZJkTJnaCqmbbBO
m1nZCp6NMGgMC3A/f6SxuX/nJS56XCxrWPOfFC9YziSyTQJ0kQr9EPnBlTD+5wJX
ij5hu3ZpBLRhpmdcV6A=
=cRI/
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
