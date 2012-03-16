Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032433Ab2CPHQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 03:16:52 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35186 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab2CPHQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 03:16:50 -0400
Date: Fri, 16 Mar 2012 10:18:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] Drivers: hv: Support the newly introduced KVP
 messages in the driver
Message-ID: <20120316071858.GH3220@mwanda>
References: <1331858893-775-1-git-send-email-kys@microsoft.com>
 <1331858925-827-1-git-send-email-kys@microsoft.com>
 <20120316054556.GH3163@mwanda>
 <6E21E5352C11B742B20C142EB499E0481B7666A2@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkEkAx9hr54EJ73W"
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481B7666A2@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F62E8D8.005A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkEkAx9hr54EJ73W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 16, 2012 at 06:33:35AM +0000, KY Srinivasan wrote:
>=20
>=20
> > -----Original Message-----
> > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > Sent: Friday, March 16, 2012 1:46 AM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@su=
se.com;
> > Alan Stern
> > Subject: Re: [PATCH 1/3] Drivers: hv: Support the newly introduced KVP
> > messages in the driver
> >=20
> > On Thu, Mar 15, 2012 at 05:48:43PM -0700, K. Y. Srinivasan wrote:
> > >  	/*
> > >  	 * The windows host expects the key/value pair to be encoded
> > >  	 * in utf16.
> > >  	 */
> > >  	keylen =3D utf8s_to_utf16s(key_name, strlen(key_name),
> > UTF16_HOST_ENDIAN,
> > > -				(wchar_t *) kvp_data->data.key,
> > > +				(wchar_t *) kvp_data->key,
> > >  				HV_KVP_EXCHANGE_MAX_KEY_SIZE / 2);
> > > -	kvp_data->data.key_size =3D 2*(keylen + 1); /* utf16 encoding */
> > > +	kvp_data->key_size =3D 2*(keylen + 1); /* utf16 encoding */
> > > +
> >=20
> > I feel like a jerk for asking this, but is the output length correct
> > here?  It seems like we could go over again.  Also utf8s_to_utf16s()
> > can return negative error codes, why do we ignore those?
>=20
> We are returning the strings back to the host here. There are checks else=
where
> in the code to ensure that all strings we return to the host can be accom=
modated
> in the available space. For the most part these are strings that the host=
 gave us in the=20
> first place that have already been validated.  Furthermore, there are che=
cks on the=20
> host side to ensure that the returned size parameters are consistent with=
 the protocol=20
> definitions for the key value pair. For instance let us say somehow we go=
t into a=20
> situation where the converted utf16 string occupied the entire MAX sized =
array=20
> without any room for the terminating character and we set the length para=
meter=20
> to 2 more than the MAX value as this code would do. The host would simply=
 discard the=20
> message as an illegal message. This would be more appropriate than sendin=
g a=20
> truncated key or value.
>=20

Uh...  Looking at it again, this code is clearly off by one.  If
we're not going to hit the limit, then we're not going to truncate,
so that's not a concern.  Let's just use the correct limit here.

The problem is that off-by-ones tend to reproduce by copy and paste.
It's best to never introduce any, even harmless ones.

Either that or add a comment.  /* Don't care about wrong limitter
because we trust the input. */.

> With regards to the negative values, negative values indicate a failure o=
f some sort
> in the conversion. Since the host is the recipient here, host will correc=
tly deal with the
> transaction by discarding the tuple. =20

I'm not super familiar with this subsystem.  Where can I find code
for rejecting bad transactions?  It seems like an easy thing to
handle the error in both places.  It makes auditing the code a lot
simpler.

regards,
dan carpenter


--vkEkAx9hr54EJ73W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYuliAAoJEOnZkXI/YHqRlNAP/3hF7fOPlNbbvqw/qXfufDb8
PKApzjZqD7HVkNZ4u/GLUM9RPvFdNjT4amhx7auzcAimqRrpx0cYzJH1o431jb/D
UHt5MPbJEZ/RdjpR8oSG4BLHsBtVkNMedxFbCftBVqZkCsNXV2e/Q5B18vwM8e2g
R8ugkk+zwk434JYXWmMWFKOaFCnpjS/MjVY6qOmxYHcwIpRJPgI82i2kHNPjSBXl
iukCZ5Sjmd6Z1/rKMwL4Uj3nT6lRrLOP3NaATqc20JUlBg/xyALpgQwAY2iecbb8
L3w56Hh9iJhKzUhUWJw5UJDIFz20lss9BakHey1sKWnyhzd9x/MrPaGyb5uQ6yKm
jm5xanWLS4ZPD4rCJ6pPFz3Il1EqyMZf1WD+Fg/e9IORG+OEyN3WSsgv1ukzFDbv
xUVp+ETm6geYMUThGbaQKEi+un8KwjwY/nqtgwjWY7pY5aCbDXQyH1TKzTkCcREM
5IyE77Bv+keCxH9fqMJrKfjRW09/WQpItciU2b7pkVH72qDqPtHGQQHqYBRBgOLD
6Q0U8oPKcE0/Ta21cChdy4QE64r0qroWueyA/ZRGXLhvHn+l3JO5RnVmKBZXd7da
6C/MMemyXRbmQLsQBUj79x880+G3+bnG3FRoj0CCgQXBQHYj1s5GgA3iFZZltRLr
cqiRS6vjO6kbZTZtqV0f
=Tyo7
-----END PGP SIGNATURE-----

--vkEkAx9hr54EJ73W--
