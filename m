Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2CLNBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:01:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29387 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab2CLNBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:01:32 -0400
Date: Mon, 12 Mar 2012 16:03:53 +0300
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
Message-ID: <20120312130353.GF3337@mwanda>
References: <1331422300-4330-1-git-send-email-kys@microsoft.com>
 <1331422331-4381-1-git-send-email-kys@microsoft.com>
 <1331422331-4381-2-git-send-email-kys@microsoft.com>
 <20120311104230.GC3337@mwanda>
 <6E21E5352C11B742B20C142EB499E0481B75B403@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20120311184916.GD3337@mwanda>
 <6E21E5352C11B742B20C142EB499E0481B75D433@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20120312052221.GE3337@mwanda>
 <6E21E5352C11B742B20C142EB499E0481B75D4CE@TK5EX14MBXC122.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+jhVVhN62yS6hEJ8"
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481B75D4CE@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F5DF3A4.0037,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+jhVVhN62yS6hEJ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 12, 2012 at 12:36:53PM +0000, KY Srinivasan wrote:
> Dan,
> I am sorry for not being as precise as I should be:
> utf16s_to_utf8s() takes two length parameters - the length of the utf16 s=
tring
> that is to be converted and the second the length of the utf8 output stri=
ng.
> The windows host manipulates all string in utf16 encoding and the string =
we get
> from the host is guaranteed to be less than or equal to MAX value that we=
 have
> including the terminating character. In my code, I simply pass the length=
 of the=20
> utf16 string as received from the host.
>=20
> The parameter that I am currently passing MAX length value is the "maxout=
"=20
> parameter of the utf16s_utf8s() function. This by definition is the size =
of the
> output buffer and in this case it happens to be MAX characters big.
>=20

I also think I'm not being as clear as I should...  I understand
that you trust the input; I'm say that for correctness sake you
should specify a output size which leaves room for the NUL char.

I can't say I know this code very well so I could be wrong, but it's
what we do inside usb_string() for example.  Can someone who knows
the code check if we should do something like this:

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index 3b2eeaa..3a97f52 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -173,7 +173,7 @@ kvp_send_key(struct work_struct *dummy)
 				in_msg->body.kvp_set.data.value_size,
 				UTF16_LITTLE_ENDIAN,
 				message->body.kvp_set.data.value,
-				HV_KVP_EXCHANGE_MAX_VALUE_SIZE) + 1;
+				HV_KVP_EXCHANGE_MAX_VALUE_SIZE - 1) + 1;
 				break;
=20
 			case REG_U32:
@@ -208,7 +208,7 @@ kvp_send_key(struct work_struct *dummy)
 				in_msg->body.kvp_set.data.key_size,
 				UTF16_LITTLE_ENDIAN,
 				message->body.kvp_set.data.key,
-				HV_KVP_EXCHANGE_MAX_KEY_SIZE) + 1;
+				HV_KVP_EXCHANGE_MAX_KEY_SIZE - 1) + 1;
=20
 			break;
=20
@@ -219,7 +219,7 @@ kvp_send_key(struct work_struct *dummy)
 				in_msg->body.kvp_delete.key_size,
 				UTF16_LITTLE_ENDIAN,
 				message->body.kvp_delete.key,
-				HV_KVP_EXCHANGE_MAX_KEY_SIZE) + 1;
+				HV_KVP_EXCHANGE_MAX_KEY_SIZE - 1) + 1;
=20
 			break;
=20

--+jhVVhN62yS6hEJ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPXfQ4AAoJEOnZkXI/YHqRSOEQAJnjvwzosRTGBCEm8jB/8JIq
dCdufiUUuw66aYovY7oSysmw9w+EI72b1I7b1ZLzaHJzY0FX4+YBuYPz+ETdzbyd
XypgBZUAqnOqiBe7GDK8OP/w7Ns3QHEP+ljD7uo93B72XqbxqDWJBu+5NOEeDYno
HaPe/eM9qTzXI/Hzhphy57+Kvqi4EgSA++OC0F/0i+I8ltvAmCymCbga/GLETkVg
LXdlakiiuKiP3hf7+NxoTT/KHzX0DULKFuM8TbDVqUhwACtPQq95enZS6LJVGqgD
HPmWlRSmP1jJwp5wh5ml+yDI9MKPkJcxE7S4TkVAQAb+eVmM8iXaR9815jWT3zvl
l1uc3vztS7DZ5LdOGOLxpM7/NMWc/jeuEdJcxgd6ejf4sKL9CDBrVoV3UI2KR0Sk
/lIc4x+jeYWVZ0ZvBGVy5tFuO3OLghqfVHBRpwaUEyjGKVrxjd6cWVB+6w5DJLPy
hdui2MGxzPB6xpR8Ou/1C62t6ajDG8kv9SNG7e0+NWdU5KnzlVsdR9j6BcGy2jKs
+N4CDsOYC826UK7qx9Wy5cgA4J7SrC9cGJNmrsEJFVBB4/9Pxbrc+lRVeEcna7s0
+3UoYxMKLCry57rxuZbKw95GoSv82KWYNQRIY0kHZk7lQm9PVZYIEq+0FrQn1iIf
fw7h7x6TqrANEEtMiIzI
=GZz+
-----END PGP SIGNATURE-----

--+jhVVhN62yS6hEJ8--
