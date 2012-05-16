Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab2EPEhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 00:37:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab2EPEhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 00:37:05 -0400
Message-ID: <4FB32EEE.4090404@redhat.com>
Date: Wed, 16 May 2012 00:37:02 -0400
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Sasha Levin <levinsasha928@gmail.com>, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc/mqueue: use correct gfp flags in msg_insert
References: <1337029525-8760-1-git-send-email-levinsasha928@gmail.com> <20120514165401.e4efc2fd.akpm@linux-foundation.org> <4FB1C365.3090006@redhat.com> <20120515143859.c3cad9b7.akpm@linux-foundation.org>
In-Reply-To: <20120515143859.c3cad9b7.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4.1
OpenPGP: id=0E572FDD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig542FFCA8E22963B52B35C349"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig542FFCA8E22963B52B35C349
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 5/15/2012 5:38 PM, Andrew Morton wrote:
> On Mon, 14 May 2012 22:45:57 -0400
> Doug Ledford <dledford@redhat.com> wrote:

>>> Switching to GFP_ATOMIC is a bit regrettable.  Can we avoid this by
>>> speculatively allocating the memory before taking the lock, then free=

>>> it again if we ended up not using it?
>>
>> Not really, we take the lock in a different function than this and wou=
ld
>> have to pass around a node struct and then free it if we didn't use it=
=2E
>>  I mean, it could be done, but it would fugly the calls around this up=
=2E
>>  The msg_insert() routine is called in two places.  In one place, the
>> lock is taken right there so you could allocate before and then call.
>> In the other, it is another function called with the lock held so now
>> you would have to pass the possible mem allocation around two function=
s.
>>  Doable, but ugly.
>=20
> Well, it's not *too* bad: just pass a void** around, zero it if it got
> used, then unconditionally free it.  Nice and easy.
>=20
> But in a contest between source-level beauty and runtime robustness,
> robustness surely wins?

Sure, things must be robustness.  It's just a question of what qualifies
as robust.

>>  On the other hand, this is a small struct that
>> should be coming off one of the small size kmem cache pools (4 pointer=
s
>> total, a long, and an int, so kmalloc-32 or kmalloc-64 depending on
>> arch).  That doesn't seem like a likely candidate to fail if there is
>> memory pressure, especially considering that immediately prior to taki=
ng
>> the lock we call kmalloc with GFP_KERNEL (as part of load_msg()) and s=
o
>> we should either not be under serious memory pressure or we would have=

>> slept waiting for it to ease up.
>=20
> True.  But weaselly!

And we don't rely on weaselly things in the kernel all the time? ;-)

>> I think I can imagine a better way to do this though as part of the
>> whole request to cache at least one rbnode entry so we get the 0 messa=
ge
>> performance of the queue back.  I'll send that patch through once I've=

>> verified it does what I think it will.
>=20
> That sounds good.

I coded something up, but I'm not happy with it.  Trying again.  One of
my problems is I *really* don't like speculatively allocating this
little struct because in the common case this is a total waste of CPU
cycles.  While my patch sped up operations under any sort of decent
queue depth, it slowed down the queue empty case by 100ns.  I'm trying
to get some of that loss back, and doing a useless speculative
allocation doesn't help :-/

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig542FFCA8E22963B52B35C349
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPsy7uAAoJELgmozMOVy/dTOUP/RVmRFmcRIef91HrCURC4WfU
6PdmOR9vvlJFu0ViUaFtOtQhcmO38FZ2UY3nwmI2xcxpZ/fWrEBUOUPxOG2ntVDt
/9wJLGK0esEnYYApnpN+nFaQShk0A50YAgUyPg22+dPFn8d8aHLTNge/z3dNZFDa
Mw00/fGHtg/taaEjt1V7l/zYsir1wC97N4Sb0oos/leJhY8qm9P8Q/ELVgZJq+nZ
xqvOJ0BJ4FLQv8O8Q9zXm8esHN7juzuuv6oxcPJGfRg0egFdDWM1oNSPlSmkVA2B
dkVXsuegGGeTcudUEuVtEFdAt2us7ienoETSTPgLaSZPsrJuoktiVrHuMNNlQ5A7
JpAUx3ICLGe1VBet5EOXPcXSc8r5Bnp4cCrBRb/ZlBe+xpGco//Hac2rmL3BL5KX
+HhiSwXrIYOYf95JzkTuqgyHVDhy0xERFNAmqszF/d9LjtivitA4QNImxsB/DAVW
b6rDR5CNwcCfaiTDnLEZKDoav7FFMJtaoKLwTLv9jsb9w4bxh/kRHKfpqyJcv8V7
9wF0lnu5Ekq1elNE8v1ws1Tqy2h7RJAMMJwRhptV/dhuTaiTzJYO25y2AA+zqiU7
SwWPzoy9j+VYhFhzEi0W6aNL5AwnJTbi1bHF5g9nLMgKfPLW1cZ1EOPOwU2h+Ty3
pHjghX5/RU/Gt8bzjlnx
=iTPI
-----END PGP SIGNATURE-----

--------------enig542FFCA8E22963B52B35C349--
