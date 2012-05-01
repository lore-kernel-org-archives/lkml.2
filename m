Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494Ab2EATiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:38:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536Ab2EATiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:38:07 -0400
Message-ID: <4FA03B99.2040306@redhat.com>
Date: Tue, 01 May 2012 15:38:01 -0400
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [Patch 2/4] ipc/mqueue: correct mq_attr_ok test
References: <1335894655-11398-1-git-send-email-dledford@redhat.com> <4a62cbda48cf31ca796f37fa8904f314f643db57.1335894230.git.dledford@redhat.com> <20120501123430.63f4bf85.akpm@linux-foundation.org>
In-Reply-To: <20120501123430.63f4bf85.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEBEC48C83E0345B4150115DB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEBEC48C83E0345B4150115DB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/01/2012 03:34 PM, Andrew Morton wrote:
> On Tue,  1 May 2012 13:50:53 -0400
> Doug Ledford <dledford@redhat.com> wrote:
>=20
>> While working on the other parts of the mqueue stuff, I noticed that
>> the calculation for overflow in mq_attr_ok didn't actually match
>> reality (this is especially true since my last patch which changed
>> how we account memory slightly).
>=20
> Please cc Manfred on mqueue things?  He still watches ;)
>=20
>> In particular, we used to test for overflow using:
>>   msgs * msgsize + msgs * sizeof(struct msg_msg *)
>>
>> That was never really correct because each message we allocate via
>> load_msg() is actually a struct msg_msg followed by the data for
>> the message (and if struct msg_msg + data exceeds PAGE_SIZE we end
>> up allocating struct msg_msgseg structs too, but accounting for them
>> would get really tedious, so let's ignore those...they're only a
>> pointer in size anyway).  This patch updates the calculation to be
>> more accurate in regards to maximum possible memory consumption by the=

>> mqueue.
>>
>> ...
>>
>> --- a/ipc/mqueue.c
>> +++ b/ipc/mqueue.c
>>
>> ...
>>
>> @@ -684,8 +686,11 @@ static int mq_attr_ok(struct ipc_namespace *ipc_n=
s, struct mq_attr *attr)
>>  	/* check for overflow */
>>  	if (attr->mq_msgsize > ULONG_MAX/attr->mq_maxmsg)
>>  		return 0;
>> -	if ((unsigned long)(attr->mq_maxmsg * (attr->mq_msgsize
>> -	    + sizeof (struct msg_msg *))) <
>> +	mq_treesize =3D attr->mq_maxmsg * sizeof(struct msg_msg) +
>> +		min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
>> +		sizeof(struct posix_msg_tree_node);
>> +	if ((unsigned long)(attr->mq_maxmsg * attr->mq_msgsize +
>> +			    mq_treesize) <
>>  	    (unsigned long)(attr->mq_maxmsg * attr->mq_msgsize))
>>  		return 0;
>>  	return 1;
>=20
> That's a bit of a mouthful.  Does this look OK?
>=20
> --- a/ipc/mqueue.c~ipc-mqueue-correct-mq_attr_ok-test-fix
> +++ a/ipc/mqueue.c
> @@ -672,7 +672,8 @@ static void remove_notification(struct m
>  static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *at=
tr)
>  {
>  	int mq_treesize;
> -
> +	unsigned long total_size;
> +=09
>  	if (attr->mq_maxmsg <=3D 0 || attr->mq_msgsize <=3D 0)
>  		return 0;
>  	if (capable(CAP_SYS_RESOURCE)) {
> @@ -690,9 +691,8 @@ static int mq_attr_ok(struct ipc_namespa
>  	mq_treesize =3D attr->mq_maxmsg * sizeof(struct msg_msg) +
>  		min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
>  		sizeof(struct posix_msg_tree_node);
> -	if ((unsigned long)(attr->mq_maxmsg * attr->mq_msgsize +
> -			    mq_treesize) <
> -	    (unsigned long)(attr->mq_maxmsg * attr->mq_msgsize))
> +	total_size =3D attr->mq_maxmsg * attr->mq_msgsize;
> +	if (total_size + mq_treesize < total_size)
>  		return 0;
>  	return 1;
>  }

Sure, looks fine to me and should preserve the wrap around test behavior.=



--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enigEBEC48C83E0345B4150115DB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPoDuZAAoJELgmozMOVy/do10P/j6d8hLaKz0s+jdxqCjrNCcm
X826TNI9D6ob8fakc2S4cwv7AUpl73bA1Lg4m5h4vvf6QDJK80/eZuRggQBU8lTW
SY2h4+anmQq2VNpgjgMdB3Qgv8+SdWHUmp1N3ANo+5clyJ76h5kwNteXl0QpMn5z
H4ifGPjRNknvocDfp1eUFZlJB5lWG8Z3OdVekBK76CNZ462tM0p/iLM/11S4T5f1
wwef44CFXba3ndFw/xOYm80te4ufX0kiCe3+RI5LvFatQYFyglua+fPtz+oq+kcy
wNI+cW360kufrn0DmVVdYVXeY6YAV9dIkjkXDOMGAcpPGbEzeLmMnKFbj6lj6ybS
DgGk/dMSS78Z+O1T/BUkCmL1IRgtA0fspspHkTSY1H/I5uIiH9A3ad1e4m7MUs1p
sKGcA0abDI0SuFK86IRRQgdZc2/w5naKibRlosUu21rxReqnD6O3Armb1OCyUnZk
rdW/lQDzCsBAssppHEmZYpW45l3Fp8yBqDT0gqjmzgD2tsD0z1MgcLUUAD4YfAhv
DkJgwCPkPY4IDDqbhVTi9ihHCXENHdGHHE/mRUQyhg8vdzH3gjACHazrOh5+mu+Q
kH4fTLJ+tUhFKCk+ECyBvi7BkqYDUSmCtIGYuxcDjtvnjPdqaEx+gFpFXdtKA/b5
Obg1AtCbfJOIkt7q91jK
=7AkX
-----END PGP SIGNATURE-----

--------------enigEBEC48C83E0345B4150115DB--
