Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab2CLFUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 01:20:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17822 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab2CLFUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 01:20:08 -0400
Date: Mon, 12 Mar 2012 08:22:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 2/4] Drivers: hv: Support the newly introduced KVP
 messages in the driver
Message-ID: <20120312052221.GE3337@mwanda>
References: <1331422300-4330-1-git-send-email-kys@microsoft.com>
 <1331422331-4381-1-git-send-email-kys@microsoft.com>
 <1331422331-4381-2-git-send-email-kys@microsoft.com>
 <20120311104230.GC3337@mwanda>
 <6E21E5352C11B742B20C142EB499E0481B75B403@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20120311184916.GD3337@mwanda>
 <6E21E5352C11B742B20C142EB499E0481B75D433@TK5EX14MBXC122.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7LkOrbQMr4cezO2T"
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481B75D433@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090205.4F5D877A.0002,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7LkOrbQMr4cezO2T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 11, 2012 at 08:53:57PM +0000, KY Srinivasan wrote:
>=20
>=20
> > -----Original Message-----
> > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > Sent: Sunday, March 11, 2012 2:49 PM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@su=
se.com;
> > Alan Stern
> > Subject: Re: [PATCH 2/4] Drivers: hv: Support the newly introduced KVP
> > messages in the driver
> >=20
> > On Sun, Mar 11, 2012 at 04:56:06PM +0000, KY Srinivasan wrote:
> > > > Probably that's not enough to make a difference and we'd need to
> > > > introduce a new function.
> > > >
> > > > Btw I don't know if utf16s_to_utf8s() counts the NUL char or not.
> > > > It feels like maybe we could end up with ->value_size equal to
> > > > HV_KVP_EXCHANGE_MAX_VALUE_SIZE + 1.
> > >
> > > The MAX value is set to accommodate the maximum string that will ever
> > > be handled including the string terminator. The function utf16s_to_ut=
f8s()
> > > returns the converted string length but the returned length does not
> > > include the string terminator (like strlen), hence the "+1".
> > >
> >=20
> > sprintf() and friends copy the NUL terminator but utf16s_to_utf8s()
> > doesn't so the code isn't right and it does seem like maybe we could
> > end up with a ->value_size equal to HV_KVP_EXCHANGE_MAX_VALUE_SIZE +
> > 1.
>=20
> You are right in that utf16s_to_utf8s() does not copy the string
> terminator. This is not an issue in this case since the buffer for
> the utf8 string is zeroed out to begin with (this memory was
> allocated using kzalloc()). The return value of the
> utf16s_to_utf8s() is the length of the utf8s string as what would
> be returned by strlen.


There is no strlen() involved...  It returns the number of bytes
copied to the output string.  It doesn't copy a NUL.  We pass
HV_KVP_EXCHANGE_MAX_VALUE_SIZE bytes as the limit.  So it fills up
the buffer with non-null characters and we have an off-by-one.

> I add one to take into account the string
> terminator character for further processing. As I said before the
> MAX value takes into account the terminating character for all the
> strings handled.

So you're saying that since we control the input string, we'll never
hit the max?  Still, why not pass HV_KVP_EXCHANGE_MAX_VALUE_SIZE - 1
to leave room for the NUL just for correctness?  We'd still add one
to the return value but we wouldn't go over the size of the buffer.

Again, I don't really know how utf16s_to_utf8s() works so I might
have misunderstood.

regards,
dan carpenter


--7LkOrbQMr4cezO2T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPXYgNAAoJEOnZkXI/YHqRcvcP/iXdQS/02I9rY87O0YX2R1oq
K9mEU+/Fo4il34mZU1Nv7wCk3ICSKSPpf75N2I+k5OYMQ50c4sI0d19Oum0vTYiB
4eetEqDBXjUpbiAkG4WxnxyEpZyIJ+G1P2LtPAyUioGbG4ZxSN5D1Ao/2wM32Qc5
0GNZ/E8QEogmPk1TT1LD0JzKuv0y8Pr+BLVp+TLmZT+YCBnAfPS5ZxGHi2yxq+RL
Gt5Lu3wdKnpm10Z7URpTK1c55DSRpyrrAKw24M6qkhgn/y3e4ouypUATr7MJn47s
V1jUvmYdPwz7CMvTY+Ha2OQthewBgWxwV975D6YXVKO1R2ZkudTa4HWeYpmx94bT
TRpBTBOxf5TcM0ZzOXVV7gSdWHh76DVU4b9SGrfG/elL5/qn7f1BzYc52BnbwHV5
TC5Qvgi4XoNeZuVRdowIzSig2vLX+YJBZecRnURO4wRxw9U0oMaECF0mHpSJVXtn
XVafbB6A4bKiDZqdrZP0YCKT34+G18ylh3FkoxqHndRSiQ7qSYH//kOkSN9hkqk0
hf2kQ26xJMAx5XfqiGO9oP+2GslWSePYGTHYJjgtFKPb7qR7+lrhdNVsGRvpVamb
b6+Gb4RGmQD/FHTTUQWhr/PK4IEFgITCZ43VDHbA+YzQ7nK+uDA39HDe4YobBqwr
93kJCTgHnl3c8Lm0M244
=8arB
-----END PGP SIGNATURE-----

--7LkOrbQMr4cezO2T--
