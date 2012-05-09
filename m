Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab2EIHWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:22:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:47595 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab2EIHWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:22:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="141753072"
Date: Wed, 9 May 2012 10:23:39 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v4] hwmon: coretemp: use list instead of fixed size
 array for temp data
Message-ID: <20120509072339.GB21556@otc-wbsnb-06>
References: <1336474175-5714-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1336495180.22553.68.camel@groeck-laptop>
 <20120509070906.GA21556@otc-wbsnb-06>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Content-Disposition: inline
In-Reply-To: <20120509070906.GA21556@otc-wbsnb-06>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 09, 2012 at 10:09:06AM +0300, Kirill A. Shutemov wrote:
> On Tue, May 08, 2012 at 09:39:40AM -0700, Guenter Roeck wrote:
> > On Tue, 2012-05-08 at 06:49 -0400, Kirill A. Shutemov wrote:
> > > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > >=20
> > > Let's rework code to allow arbitrary number of cores on a CPU, not
> > > limited by hardcoded array size.
> > >=20
> > > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > ---
> > >  v4:
> > >    - address issues pointed by Guenter Roeck;
> > >  v3:
> > >    - drop redundant refcounting and checks;
> > >  v2:
> > >    - fix NULL pointer dereference. Thanks to R, Durgadoss;
> > >    - use mutex instead of spinlock for list locking.
> > > ---
> >=20
> > Hi Kirill,
> >=20
> > unfortunately now we have another race condition :(. See below ...
>=20
> Ughh..
>=20
> > > @@ -557,11 +579,22 @@ exit_free:
> > >  static int __devexit coretemp_remove(struct platform_device *pdev)
> > >  {
> > >  	struct platform_data *pdata =3D platform_get_drvdata(pdev);
> > > -	int i;
> > > +	struct temp_data *tdata;
> > > =20
> > > -	for (i =3D MAX_CORE_DATA - 1; i >=3D 0; --i)
> > > -		if (pdata->core_data[i])
> > > -			coretemp_remove_core(pdata, &pdev->dev, i);
> > > +	for (;;) {
> > > +		mutex_lock(&pdata->temp_data_lock);
> > > +		if (!list_empty(&pdata->temp_data_list)) {
> > > +			tdata =3D list_first_entry(&pdata->temp_data_list,
> > > +					struct temp_data, list);
> > > +			list_del(&tdata->list);
> > > +		} else
> > > +			tdata =3D NULL;
> > > +		mutex_unlock(&pdata->temp_data_lock);
> > > +
> > > +		if (!tdata)
> > > +			break;
> > > +		coretemp_remove_core(tdata, &pdev->dev);
> > > +	}
> > > =20
> > Unfortunately, that results in a race condition, since the tdata list
> > entry is gone before the attribute file is deleted.
> >=20
> > I think you can still use list_for_each_entry_safe, only outside the
> > mutex, and remove the list entry at the end of coretemp_remove_core()

I haven't got how list_for_each_entry_safe() will be really safe without
the lock.

> > after deleting the attribute file. Just keep the code as it was, and
> > remove the list entry (mutex-protected) where core_data[] was set to
> > NULL.
>=20
> I think
>=20
> if (tdata)
> 	return -ENODEV;
>=20
> in show methods will fix the issue. Right?

It won't. Stupid me.

But the check + kref seems will work...

--=20
 Kirill A. Shutemov

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqht6AAoJEAd+omnVudOMnSIP/A2BHBOn8ShqXnqz8t2C0scz
3ChLXJWYyioJXH7Kyt1H/v+MW32nXJwsl1Ve2e3mNIO1/JHgrb0szjuIfNDJbwxN
UEuvaNYTk2v9R3Aj7y6E+blfZ+5je5J87o0kqF5EM+uo8CHfx7BR8XeL4sUj673r
dkN5ZVf4zlaby6vkhtA6hS/Q67Ed84zyrr8/9G5ACwG3xPlk9e6wH5Or5ygKeQzX
+wOucGpWJJHZ8bTaaWwAU1F0AYOxkzbnfNcq5dDF1+EREGTlO3Lz2FWlyztho2LY
zHAZ0u5fRDXroxdAFoLuxKuS3vfZX/QvDsyYA2sDSrRSjEWVa2A48WROnaprlIJU
2G5hBoXdn5TNDmhYCFjIvouCB9W5b4aNTIyPpth+IhDJrOnVA+YLPEF7ccr0NqQi
guQUss88I9V4sw0j3jUZbKYtgxVjWtPZXgJbhJfB7lVHxUBEeCE7nE5eRL/JA+yG
nSCvxT30Pewtz4BJga1SmBTtaXuWCVqwFwaXycSRHZrCq+Na/9vQ+ipBClEROC/C
4oPsucK2FK/BTdGaenXZYG7ooFPbyHdFKV+Vfu3dg9rSJXHqn+GnPo2Dx+2D9En7
pykCK3EgfltD5bXhWXL7DMSRisyG6wgqd9OZkBwH7okBS68UI1RTf+F+vAllViAC
Tn3reZdPYCS3taey3nN+
=jTiX
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
