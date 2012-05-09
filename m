Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab2EIKPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 06:15:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:61641 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab2EIKPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 06:15:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="138583889"
Date: Wed, 9 May 2012 13:16:34 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v4] hwmon: coretemp: use list instead of fixed size
 array for temp data
Message-ID: <20120509101634.GA24566@otc-wbsnb-06>
References: <1336474175-5714-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1336495180.22553.68.camel@groeck-laptop>
 <20120509070906.GA21556@otc-wbsnb-06>
 <20120509072339.GB21556@otc-wbsnb-06>
 <20120509095617.GB15630@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20120509095617.GB15630@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 09, 2012 at 02:56:17AM -0700, Guenter Roeck wrote:
> On Wed, May 09, 2012 at 03:23:39AM -0400, Kirill A. Shutemov wrote:
> > On Wed, May 09, 2012 at 10:09:06AM +0300, Kirill A. Shutemov wrote:
> > > On Tue, May 08, 2012 at 09:39:40AM -0700, Guenter Roeck wrote:
> > > > On Tue, 2012-05-08 at 06:49 -0400, Kirill A. Shutemov wrote:
> > > > > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > > > >=20
> > > > > Let's rework code to allow arbitrary number of cores on a CPU, not
> > > > > limited by hardcoded array size.
> > > > >=20
> > > > > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.co=
m>
> > > > > ---
> > > > >  v4:
> > > > >    - address issues pointed by Guenter Roeck;
> > > > >  v3:
> > > > >    - drop redundant refcounting and checks;
> > > > >  v2:
> > > > >    - fix NULL pointer dereference. Thanks to R, Durgadoss;
> > > > >    - use mutex instead of spinlock for list locking.
> > > > > ---
> > > >=20
> > > > Hi Kirill,
> > > >=20
> > > > unfortunately now we have another race condition :(. See below ...
> > >=20
> > > Ughh..
> > >=20
> > > > > @@ -557,11 +579,22 @@ exit_free:
> > > > >  static int __devexit coretemp_remove(struct platform_device *pde=
v)
> > > > >  {
> > > > >  	struct platform_data *pdata =3D platform_get_drvdata(pdev);
> > > > > -	int i;
> > > > > +	struct temp_data *tdata;
> > > > > =20
> > > > > -	for (i =3D MAX_CORE_DATA - 1; i >=3D 0; --i)
> > > > > -		if (pdata->core_data[i])
> > > > > -			coretemp_remove_core(pdata, &pdev->dev, i);
> > > > > +	for (;;) {
> > > > > +		mutex_lock(&pdata->temp_data_lock);
> > > > > +		if (!list_empty(&pdata->temp_data_list)) {
> > > > > +			tdata =3D list_first_entry(&pdata->temp_data_list,
> > > > > +					struct temp_data, list);
> > > > > +			list_del(&tdata->list);
> > > > > +		} else
> > > > > +			tdata =3D NULL;
> > > > > +		mutex_unlock(&pdata->temp_data_lock);
> > > > > +
> > > > > +		if (!tdata)
> > > > > +			break;
> > > > > +		coretemp_remove_core(tdata, &pdev->dev);
> > > > > +	}
> > > > > =20
> > > > Unfortunately, that results in a race condition, since the tdata li=
st
> > > > entry is gone before the attribute file is deleted.
> > > >=20
> > > > I think you can still use list_for_each_entry_safe, only outside the
> > > > mutex, and remove the list entry at the end of coretemp_remove_core=
()
> >=20
> > I haven't got how list_for_each_entry_safe() will be really safe without
> > the lock.
> >=20
> We know that it by itself won't be called multiple times. So the only que=
stion is=20
> if the functions to add/remove a core can be called while coretemp_remove=
 is called,
> or if that is mutually exclusive (not that the current code handles this =
case).
>=20
> Fortunately, there is a function to block CPU removal/insertion: get_onli=
ne_cpus()
> and put_online_cpus(). I have no idea if it is necessary to protect coret=
emp_remove()
> with it, but it might be on the safe side anyway.
>=20
> > > > after deleting the attribute file. Just keep the code as it was, and
> > > > remove the list entry (mutex-protected) where core_data[] was set to
> > > > NULL.
> > >=20
> > > I think
> > >=20
> > > if (tdata)
> > > 	return -ENODEV;
> > >=20
> > > in show methods will fix the issue. Right?
> >=20
> > It won't. Stupid me.
> >=20
> > But the check + kref seems will work...
> >=20
> Yes, but would be way too complicated.

More code, yes, but complicated? What you propose looks like a trick. It
has too many assumptions on context.

I personally prefer kref since it's straight forward and more friendly for
future changes.

--=20
 Kirill A. Shutemov

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqkQCAAoJEAd+omnVudOMnF8P/08WuxOSnABat7mfPvN3oEV3
styvuTPdXe2BgKuYrnPwLVKdDSCNHJ/0c6qNSdl1X38XQ+oAj7xZyPCyR2MmF7qy
nxMFTTokDWXuKxKpNZnTV1Zr0/brNmZ9zLWNu4HDA8RQQxAEjPmYpFqoQpNFDO1P
DRB+Dy2VXZ6Bt9+OP/1lt05MbAsZhVYtZFqSxA1+PAMxH19FNZJBTlILg4pFLuG2
sDh2FL3nplU0RoMOlI+sN+ro2QajsK01i25wdACQFWIpFYr0wXqCTrp+tqh5yvtj
Zep37ObH6wToFaZewrIj1YrWD4ZqxJrU3jwqD8DTN62nYYgEOAy6TdsyrDJKMGZl
dE83mZ2SWxZKNpT2nUoRLy+9PdupPk+s4t1TUdI2OXf6GfaelprUF88Zenno09Jz
1szC7+xXTVI0/78KLJpG6ESm7MNfFOB7MErT5UsGdOlupzUAqmtAKjLc5pcLM9AL
pnf1DTQe5hPHgCbjqc5ZeiaJJp+GDTVuKMI6CxFIEHgeq4UeXtDusZ2Zhoid5NDP
kdGhKqRt48KpRdcjUKDTFfHsLot9uKL4L0GXG9DbVYatlbng6UR2OSLDFnAgewrV
PHKu9PBRR4Em2bMf+cnggNIY5TawvnsnQe76r+mdgQnvLXHthVXv6F+iJvSc5H7C
guffO2o+XUAzgmO9evRy
=6d32
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
