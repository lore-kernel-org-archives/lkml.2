Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965432Ab2EOCqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:46:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965207Ab2EOCqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:46:18 -0400
Message-ID: <4FB1C365.3090006@redhat.com>
Date: Mon, 14 May 2012 22:45:57 -0400
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Sasha Levin <levinsasha928@gmail.com>, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc/mqueue: use correct gfp flags in msg_insert
References: <1337029525-8760-1-git-send-email-levinsasha928@gmail.com> <20120514165401.e4efc2fd.akpm@linux-foundation.org>
In-Reply-To: <20120514165401.e4efc2fd.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4.1
OpenPGP: id=0E572FDD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEF169F383E691F8C0AED1D2F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEF169F383E691F8C0AED1D2F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 5/14/2012 7:54 PM, Andrew Morton wrote:
> On Mon, 14 May 2012 23:05:25 +0200
> Sasha Levin <levinsasha928@gmail.com> wrote:
>=20
>> msg_insert() tries to allocate using GFP_KERNEL, while in both cases w=
hen it's called,
>> it's coming from an atomic context. Introduced by 7dd7edf ("ipc/mqueue=
: improve
>> performance of send/recv").
>>
>> Use GFP_ATOMIC instead.
>>
>> Also, fix up coding style in the kzalloc while we're there.
>>
>> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
>> ---
>>  ipc/mqueue.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
>> index 30f6f8f..9ec6896 100644
>> --- a/ipc/mqueue.c
>> +++ b/ipc/mqueue.c
>> @@ -133,7 +133,7 @@ static int msg_insert(struct msg_msg *msg, struct =
mqueue_inode_info *info)
>>  		else
>>  			p =3D &(*p)->rb_right;
>>  	}
>> -	leaf =3D kzalloc(sizeof(struct posix_msg_tree_node), GFP_KERNEL);
>> +	leaf =3D kzalloc(sizeof(*leaf), GFP_ATOMIC);
>>  	if (!leaf)
>>  		return -ENOMEM;
>>  	rb_init_node(&leaf->rb_node);
>=20
> hm, that should have spewed warnings everywhere the first time anyone
> tested it.  Doug, is a re-read of Documentation/SubmitChecklist needed?=


Re-read?  I never it read it a first time, so hard for me to re-read it.
 But thanks for pointing it out.  Now I've read it.

> Switching to GFP_ATOMIC is a bit regrettable.  Can we avoid this by
> speculatively allocating the memory before taking the lock, then free
> it again if we ended up not using it?

Not really, we take the lock in a different function than this and would
have to pass around a node struct and then free it if we didn't use it.
 I mean, it could be done, but it would fugly the calls around this up.
 The msg_insert() routine is called in two places.  In one place, the
lock is taken right there so you could allocate before and then call.
In the other, it is another function called with the lock held so now
you would have to pass the possible mem allocation around two functions.
 Doable, but ugly.  On the other hand, this is a small struct that
should be coming off one of the small size kmem cache pools (4 pointers
total, a long, and an int, so kmalloc-32 or kmalloc-64 depending on
arch).  That doesn't seem like a likely candidate to fail if there is
memory pressure, especially considering that immediately prior to taking
the lock we call kmalloc with GFP_KERNEL (as part of load_msg()) and so
we should either not be under serious memory pressure or we would have
slept waiting for it to ease up.

I think I can imagine a better way to do this though as part of the
whole request to cache at least one rbnode entry so we get the 0 message
performance of the queue back.  I'll send that patch through once I've
verified it does what I think it will.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigEF169F383E691F8C0AED1D2F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPscNtAAoJELgmozMOVy/dwOkP+we3bttdGfdYlPoRDhDKcnVE
UT43fCRJAa20MBkK2zOzIZuaAMkZ7Chd+PA3qUlj2S8Zq6rbKDfTctxsLwTLUtHq
+NIz2usANcQaTWKUR90EEYjlbFUjZmqd4dYnABTZbGPIlb3u1wG4SQ3izVuUmybK
CgC1IhPt/w6znlLWth/U5lJ/w9IJdJ9sEbzTkXsF3iYrnYLzMaSOoxEK+QF2wAgq
RhV67Nln6zjSTpKELWZ2o8uDp4A0uB4Hi0+/r21Jlm9UXte+HtONaCAxud367Pyb
kVnqXSes+Ib2nHrUWh5g/cwDENOz+Lha4/X3v2S5LlHQWTvwfUv+EGNDAnX9lO/w
dOnp3YSX7jIsxIUl54eRsqAZ9c+uY13FBo2zO/1/VeV7HijcNd7FiKYtwk7d5elr
hD5H6OB3pbx3f6YbWDMal5pY/mfsZit9d+jGi3SztPIyOlWHx0BDMVre0pSYhL2B
sOgXlyYYw8EAR5+3DKkjoAuyK2zIglm9lO1PaIrnMbjgoJAQNimwLKWb6LkznrCN
5HriOu7M7JAxoKZGGz9wmSLFkPgMp8MQsXQgBhvz0JFTquqD6ewRvHYEKkWfhloN
elCXae4aW3AtLpkLXDPjn/ACHlGaND8SbSoGUWyG0qmKmzUQT3FhFygGT2F0trV1
AAImE5dWDyQJjnb/Nm8r
=QAbI
-----END PGP SIGNATURE-----

--------------enigEF169F383E691F8C0AED1D2F--
