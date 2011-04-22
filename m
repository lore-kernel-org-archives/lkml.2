Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab1DVLlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 07:41:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab1DVLlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 07:41:49 -0400
Message-ID: <4DB1697B.10606@redhat.com>
Date: Fri, 22 Apr 2011 05:41:47 -0600
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.9
MIME-Version: 1.0
To: Josef Bacik <josef@toxicpanda.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1303414954-3315-1-git-send-email-josef@redhat.com>	<loom.20110422T001650-760@post.gmane.org> <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com>
In-Reply-To: <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com>
X-Enigmail-Version: 1.1.2
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig764D8EB177A1BF7EFB092AD6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig764D8EB177A1BF7EFB092AD6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04/21/2011 07:22 PM, Josef Bacik wrote:
>> You absolutely need to match Solaris semantics, which are documented a=
s follows:
>>
>>         =EF=BF=BD  If whence is SEEK_HOLE, the offset of the start of =
the  next  hole
>>            greater than or equal to the supplied offset is returned. T=
he def-
>>            inition of a hole is provided near the end of the DESCRIPTI=
ON.
>>
>> Note that in that definition, SEEK_HOLE does _not_ reposition the file=
 offset
>> (it returns the offset of the next hole, which might be at the end of =
the file
>> since all files have a virtual hole at the end, but leaves the positio=
n
>> unchanged).  I'd have to write a test program on Solaris to see whethe=
r that
>> definition is actually true, or if it is a bug in the Solaris man page=
=2E
>=20
> lseek's purpose is to reposition the file position, so I'd imagine
> this is just a bug in the man page.

Confirmed that the Solaris man page is buggy and does not accurately
describe the semantics that are actually implemented.  My testing showed:=


lseek(fd, off, SEEK_HOLE) has four cases:

off < end, in data: repositions to the next hole as if by lseek(fd,
next_hole, SEEK_CUR); the next hole is guaranteed to exist, even if at
end of file

off < end, in hole, and later in file has data: repositions as if by
lseek(fd, off, SEEK_CUR)

off < end, in hole, and no further data in file: repositions as if by
lseek(fd, 0, SEEK_END)

off =3D=3D end: fails with ENXIO

lseek(fd, off, SEEK_DATA) has four cases:

off < end, in data: repositions as if by lseek(fd, off, SEEK_CUR)

off < end, in hole, and later in file has data: repositions to the next
data as if by lseek(fd, next_data, SEEK_CUR)

off < end, in hole, and remainder of file is hold: fails with ENXIO

off =3D=3D end: fails with ENXIO


Here's how I tested:

$ uname -sr
SunOS 5.10
$ cat foo.c
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>

static int
make_sparse (const char *name)
{
  int fd =3D open (name, O_RDWR | O_CREAT | O_TRUNC, 0600);
  if (fd < 0)
    return fd;
  printf ("creating %s\n", name);
  if (write (fd, "a", 1) !=3D 1)
    goto cleanup;
  if (lseek (fd, 1024*1024, SEEK_CUR) =3D=3D -1)
    goto cleanup;
  if (write (fd, "b", 1) !=3D 1)
    goto cleanup;
  if (lseek (fd, 0, SEEK_SET) !=3D 0)
    goto cleanup;
  return fd;
 cleanup:
  close (fd);
  return -1;
}

int
main (int argc, char **argv)
{
  off_t off;
  off_t end;
  int fd =3D argc > 2 ? open (argv[1], O_RDONLY)
    : make_sparse (argc > 1 ? argv[1] : "file");

  perror(NULL);
  if (fd < 0)
    return 2;

  printf ("fpathconf gives %ld, ENXIO is %d\n",
          fpathconf (fd, _PC_MIN_HOLE_SIZE), ENXIO);

  puts ("\ntesting at start");
  errno =3D 0;
  off =3D lseek (fd, 0, SEEK_CUR);
  printf ("CUR at offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 0, SEEK_HOLE);
  printf ("HOLE gives offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 0, SEEK_CUR);
  printf ("CUR at offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 0, SEEK_DATA);
  printf ("DATA gives offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 0, SEEK_CUR);
  printf ("CUR at offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 0, SEEK_HOLE);
  printf ("HOLE gives offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 0, SEEK_CUR);
  printf ("CUR at offset %lld, errno %d\n", (long long) off, errno);

  puts ("\ntesting at end");

  errno =3D 0;
  off =3D end =3D lseek (fd, 0, SEEK_END);
  printf ("end at offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, end, SEEK_HOLE);
  printf ("HOLE gives offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 0, SEEK_CUR);
  printf ("CUR at offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, end, SEEK_DATA);
  printf ("DATA gives offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 0, SEEK_CUR);
  printf ("CUR at offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, end - 1, SEEK_HOLE);
  printf ("HOLE gives offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 0, SEEK_CUR);
  printf ("CUR at offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, end - 1, SEEK_DATA);
  printf ("DATA gives offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 0, SEEK_CUR);
  printf ("CUR at offset %lld, errno %d\n", (long long) off, errno);

  puts ("\ntesting at offset 1");

  errno =3D 0;
  off =3D lseek (fd, 1, SEEK_HOLE);
  printf ("HOLE gives offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 0, SEEK_CUR);
  printf ("CUR at offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 1, SEEK_DATA);
  printf ("DATA gives offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 0, SEEK_CUR);
  printf ("CUR at offset %lld, errno %d\n", (long long) off, errno);

  puts ("\ntesting at offset 200000");

  errno =3D 0;
  off =3D lseek (fd, 200000, SEEK_HOLE);
  printf ("HOLE gives offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 0, SEEK_CUR);
  printf ("CUR at offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 200000, SEEK_DATA);
  printf ("DATA gives offset %lld, errno %d\n", (long long) off, errno);

  errno =3D 0;
  off =3D lseek (fd, 0, SEEK_CUR);
  printf ("CUR at offset %lld, errno %d\n", (long long) off, errno);

  if (close (fd))
    return 3;
  return 0;
}
$ ./foo
creating file
Error 0
fpathconf gives 512, ENXIO is 6

testing at start
CUR at offset 0, errno 0
HOLE gives offset 131072, errno 0
CUR at offset 131072, errno 0
DATA gives offset 0, errno 0
CUR at offset 0, errno 0
HOLE gives offset 131072, errno 0
CUR at offset 131072, errno 0

testing at end
end at offset 1048578, errno 0
HOLE gives offset -1, errno 6
CUR at offset 1048578, errno 0
DATA gives offset -1, errno 6
CUR at offset 1048578, errno 0
HOLE gives offset 1048578, errno 0
CUR at offset 1048578, errno 0
DATA gives offset 1048577, errno 0
CUR at offset 1048577, errno 0

testing at offset 1
HOLE gives offset 131072, errno 0
CUR at offset 131072, errno 0
DATA gives offset 1, errno 0
CUR at offset 1, errno 0

testing at offset 200000
HOLE gives offset 200000, errno 0
CUR at offset 200000, errno 0
DATA gives offset 1048576, errno 0
CUR at offset 1048576, errno 0
$ gtruncate -s 1M sparse
$ ./foo sparse 2
Error 0
fpathconf gives 512, ENXIO is 6

testing at start
CUR at offset 0, errno 0
HOLE gives offset 0, errno 0
CUR at offset 0, errno 0
DATA gives offset -1, errno 6
CUR at offset 0, errno 0
HOLE gives offset 0, errno 0
CUR at offset 0, errno 0

testing at end
end at offset 1048576, errno 0
HOLE gives offset -1, errno 6
CUR at offset 1048576, errno 0
DATA gives offset -1, errno 6
CUR at offset 1048576, errno 0
HOLE gives offset 1048576, errno 0
CUR at offset 1048576, errno 0
DATA gives offset -1, errno 6
CUR at offset 1048576, errno 0

testing at offset 1
HOLE gives offset 1, errno 0
CUR at offset 1, errno 0
DATA gives offset -1, errno 6
CUR at offset 1, errno 0

testing at offset 200000
HOLE gives offset 1048576, errno 0
CUR at offset 1048576, errno 0
DATA gives offset -1, errno 6
CUR at offset 1048576, errno 0
$

--=20
Eric Blake   eblake@redhat.com    +1-801-349-2682
Libvirt virtualization library http://libvirt.org


--------------enig764D8EB177A1BF7EFB092AD6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJNsWl7AAoJEKeha0olJ0NqltMH+wdyQuyVhhblj7nA64xcau3A
izaKFls5/I6lf0ypyeFoaixPHJ0Di9H8N0ef7uATZIuhFUEfatHyTRJ15XuEdo8o
q4qdcjLZaqZs9SOa5CDcxQZOMVApzgZOorCsSvS6uQ5PhUumOmp8IefNSLfCTNrL
styLAStlzyQGnSA7w83hpPjLJqcjYo/zMpPNa5vrnoxVoodkjDceX4ahWEHXckU+
M1GGoBTIHuUCnKDv6fhjiwARL5exgvu/6m8nTclWKw/vrUdvqGHs6Br8zEGZ6mpE
JuV6iyeEZn5idRIIwk8vS8ajs2GQGo3id3ZF4QkCIAmHm5h1YEPV2xl7YJ3aVm0=
=dUW7
-----END PGP SIGNATURE-----

--------------enig764D8EB177A1BF7EFB092AD6--
