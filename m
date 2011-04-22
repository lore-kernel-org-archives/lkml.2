Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1DVQk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:40:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188Ab1DVQk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:40:26 -0400
Message-ID: <4DB1AF6F.4040706@redhat.com>
Date: Fri, 22 Apr 2011 10:40:15 -0600
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sunil Mushran <sunil.mushran@oracle.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Christoph Hellwig <hch@infradead.org>,
        Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <loom.20110422T001650-760@post.gmane.org> <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com> <20110422045054.GB17795@infradead.org> <20110422112852.GB1627@x4.trippels.de> <4DB16B72.1050702@redhat.com> <4DB1AC9D.3010706@oracle.com>
In-Reply-To: <4DB1AC9D.3010706@oracle.com>
X-Enigmail-Version: 1.1.2
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig1C0842EA7F24039D388DEDF1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1C0842EA7F24039D388DEDF1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/22/2011 10:28 AM, Sunil Mushran wrote:
> On 04/22/2011 04:50 AM, Eric Blake wrote:
>> That blog also mentioned the useful idea of adding FIND_HOLE and
>> FIND_DATA, not implemented in Solaris, but which could easily be
>> provided as additional lseek constants in Linux to locate the start of=

>> the next chunk without repositioning and which could ease application
>> programmer's life a bit.  After all, cp wants to know where data ends
>> without repositioning (FIND_HOLE), read() that much data which
>> repositions in the process, then skip to the next chunk of data
>> (SEEK_DATA) - two lseek() calls per iteration if we have 4 constants,
>> but 3 per iteration if we only have SEEK_HOLE and have to manually
>> rewind.
>=20
> while(1) {
>     read(block);
>     if (block_all_zeroes)
>         lseek(SEEK_DATA);
> }
>=20
> What's wrong with the above? If this is the case, even SEEK_HOLE
> is not needed but should be added as it is already in Solaris.

Because you don't know if the block is the same size as the minimum
hole, and because some systems require rather large holes (my Solaris
testing on a zfs system didn't have holes until 128k), that's a rather
large amount of reading just to prove that the block has all zeros to
know that it is even worth trying the lseek(SEEK_DATA).  My gut feel is
that doing the lseek(SEEK_HOLE) up front coupled with seeking back to
the same position is more efficient than manually checking for a run of
zeros (less cache pollution, works with 4k read buffers without having
to know filesystem hole size).

>=20
> My problem with FIND_* is that we are messing with the well understood
> semantics of lseek().

You'll notice I didn't propose any FIND_* constants for POSIX.

> And if generic_file_llseek_unlocked() treats SEEK_DATA as SEEK_CUR and

You meant SEEK_SET not SEEK_CUR, but...

> SEEK_HOLE as SEEK_END (both with zero offset) then we don't even
> have to bother with the finding the "correct" error code.

=2E..that's still not compatible with Solaris.  On a file with size of 0
bytes, lseek(fd, 1, SEEK_SET) and lseek(fd, 0, SEEK_END) will both
succeed, but lseek(fd, 1, SEEK_DATA) and lseek(fd, 0, SEEK_HOLE) must
fail with ENXIO (the offset was at or beyond the size of the file).

For a file with no holes, Solaris semantics behave as if:

off_t lseek(int fildes, off_t offset, int whence)
{
    off_t cur, end;
    switch (whence)
    {
    case SEEK_HOLE:
    case SEEK_DATA:
        cur =3D lseek(fildes, 0, SEEK_CUR);
        if (cur < 0)
            return cur;
        end =3D lseek(fildes, 0, SEEK_END);
        if (end < 0)
            return end;
        if (offset < end)
            return whence =3D=3D SEEK_HOLE ? end : lseek(fildes, offset,
SEEK_SET);
        lseek(fildes, cur, SEEK_SET);
        errno =3D ENXIO;
        return -1;
    default:
        ... /* Existing implementation */
    }
}

--=20
Eric Blake   eblake@redhat.com    +1-801-349-2682
Libvirt virtualization library http://libvirt.org


--------------enig1C0842EA7F24039D388DEDF1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJNsa9vAAoJEKeha0olJ0NqvsYH/2tGi1Yu6Ux1lHLSGFCE5JYl
7RKp0SYzm4LMJ0mCC+dIeXgwqi0S7bpchZSjO7WtJAW70WSlv+OLHuv99LVLDLK/
HP1dJvSkiUph3kWVg8yj3e7juJz5ws2JJApW1RrzRwy2dc3OZxiCs1uQgPL+w7L3
AKPfwpGcDmvEr5IFRaf7NVuVUY+tFtpZmK9NZckChXHj2M7Vp8aRtormlABAqREB
dXxirtlmsByZpH5zEftCWxe2B3ivnPgkBeIJalFGevLJHyjpY9NDsYU7PaqgO/T9
UEICayadjEDc4dq9eKmcPvfaz3YLf7Y2T0AMB6ui3SyAaPW4L3NUTgD7wbyyhSs=
=ZSdK
-----END PGP SIGNATURE-----

--------------enig1C0842EA7F24039D388DEDF1--
