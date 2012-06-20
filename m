Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab2FTTqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:46:05 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54582 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757885Ab2FTTqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:46:03 -0400
Message-ID: <4FE22875.4050805@gentoo.org>
Date: Wed, 20 Jun 2012 21:45:57 +0200
From: Justin <jlec@gentoo.org>
Reply-To: jlec@gentoo.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: Suresh Jayaraman <sjayaraman@suse.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-cachefs@redhat.com
Subject: Re: [PATCH] [RESEND] fs: cachefiles: Add support for large files
 in filesystem caching
References: <4FD5844D.4010900@suse.com> <20120618160408.8d0dd792.akpm@linux-foundation.org> <4FE00DBF.7080405@suse.com> <20120619005214.989e90a8.akpm@linux-foundation.org> <4FE1D1A2.5040605@suse.com>
In-Reply-To: <4FE1D1A2.5040605@suse.com>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig8B04EEE219ECB3C67259871B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8B04EEE219ECB3C67259871B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 20.06.2012 15:35, Suresh Jayaraman wrote:
> On 06/19/2012 01:22 PM, Andrew Morton wrote:
>> On Tue, 19 Jun 2012 10:57:27 +0530 Suresh Jayaraman <sjayaraman@suse.c=
om> wrote:
>>
>>>> How extensively was this change tested?  Please describe the testing=

>>>> which was performed?
>>>>
>>>
>>> The original patch was tested by mounting a NFS share with fscache
>>> option enabled, do a md5sum on a nfs file larger than 2GB and ensure
>>> that the file is getting cached by fscache (watch cache size growing)=

>>> on x86_64.=20
>>
>> Well it will need a lot more coverage testing than that.  truncate?=20
>> expanding truncate?  write, lseek, pwrite, pread(), mmap(MAP_SHARED),
>> behavior at the new max file size (what is that?), etc.
>>
>=20
> The changelog could be slightly misleading as the patch doesn't really
> add LFS support. It just passes O_LARGEFILE flag to dentry_open() to ma=
ke
> VFS allow cachefiles to open larger files (instead of failing it with
> -EOVERFLOW). Cachefiles is just a cache that uses the VFS/VM interfaces=
 to
> get another disk filesystem to do the requisite I/O on its behalf.
> So, I doubt whether more coverage testing is required for this change.
>=20
> Anyway, I'm attaching a quick and dirty test program that might help
> (not well tested though). I'm unable to to test it as I have modified
> my setup and have to redo it.
>=20
> Justin, do you have the setup and can you get this tested?
>=20
>=20
>=20
> /*
>  * Few tests to ensure LFS (Large File Support) is working correctly.
>  *
>  * The requests (seek, truncate, write, mmap etc) that extend beyond th=
e offset
>  * maximum (off_t) should succeed.
>  *
>  * Compile it with -D_FILE_OFFSET_BITS=3D64
>  *
>  * Run it like:
>  * 	./lfs-tests large_file
>  *
>  */
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <fcntl.h>
> #include <unistd.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <sys/mman.h>
>=20
> #define BUF_SZ 32
>=20
> #define err(msg) \
> 	do { perror(msg); exit(EXIT_FAILURE); } while (0)
>=20
>=20
> void report_size(int fd, struct stat *st)
> {
> 	fstat(fd, st);
> 	printf("size of file: %ld\n", st->st_size);
>=20
> 	return;
> }
>=20
> int main(int argc, char *argv[])
> {
> 	int fd;
> 	int rc =3D 0;
> 	unsigned long offset =3D 0;
> 	struct stat stbuf;
> 	char buf[BUF_SZ];
> 	void *file_mem;
>=20
> 	if (argc !=3D 2) {
> 		fprintf(stderr, "Usage: %s test_file\n", argv[0]);
> 		exit(EXIT_FAILURE);
> 	}
>=20
> 	fd =3D open(argv[1], O_RDWR | O_APPEND);
> 	if (fd =3D=3D -1)
> 		err("open");
>=20
> 	memset(buf, 0, sizeof(buf));
>=20
> 	/* seek to the end of file */
> 	offset =3D lseek(fd, 0, SEEK_END);
> 	if (offset < 0)
> 		err("lseek");
>=20
> 	/* seek past the end of file */
> 	offset =3D lseek(fd, BUF_SZ, SEEK_END);
> 	printf("%ld\n", offset);
> 	if (offset < 0)
> 		err("lseek");
>=20
> 	/* truncate it to < 2GB and report size */
> 	rc =3D ftruncate(fd, 2147483648 - BUF_SZ);
> 	if (rc !=3D 0)
> 		err("ftruncate");
>=20
> 	report_size(fd, &stbuf);
>=20
> 	/* truncate it to a size larger than 2GB */
> 	rc =3D ftruncate(fd, 4294967360);
> 	if (rc !=3D 0)
> 		err("ftruncate");
>=20
> 	report_size(fd, &stbuf);
>=20
> 	/* seek to the end of file */
> 	offset =3D lseek(fd, 0, SEEK_END);
> 	if (offset < 0)
> 		err("lseek");
>=20
> 	memset(buf, 'a', sizeof(buf));
>=20
> 	/* write past 4GB */
> 	rc =3D write(fd, buf, sizeof(buf));
> 	if (rc =3D=3D -1)
> 		err("write");
>=20
> 	report_size(fd, &stbuf);
>=20
> 	offset =3D lseek(fd, 0, SEEK_END);
> 	if (offset < 0)
> 		err("lseek");
>=20
> 	/* pwrite and pread */
> 	rc =3D pread(fd, buf, BUF_SZ, offset);
> 	if (rc =3D=3D -1)
> 		err("pread");
>=20
> 	rc =3D pwrite(fd, buf, sizeof(buf), offset);
> 	if (rc =3D=3D -1)=20
> 		err("pwrite");
>=20
> 	report_size(fd, &stbuf);
>=20
> 	/* page align offset */
> 	offset =3D offset & ~(sysconf(_SC_PAGE_SIZE) - 1);
>=20
> 	file_mem =3D mmap(0, BUF_SZ, PROT_WRITE, MAP_SHARED, fd, offset);
> 	if (file_mem =3D=3D MAP_FAILED)
> 		err("mmap");
>=20
> 	munmap(file_mem, 64);
>=20
> 	close(fd);
>=20
> 	return EXIT_SUCCESS;
> }
>=20

Hi,

so here are my test. Both system with fscache enabled.

unpatched kernel (Opensuse 12.1 linux-3.1.10-1.9-default):

$ ./large_file foo
8589934624
size of file: 2147483616
size of file: 4294967360
size of file: 4294967392
size of file: 4294967424


patched kernel (Gentoo Linux linux-3.4.3):


$ ./large_file bar
8589934624
size of file: 2147483616
size of file: 4294967360
size of file: 4294967392
size of file: 4294967424


no crash, everything worked.


Thanks justin




--------------enig8B04EEE219ECB3C67259871B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEAREKAAYFAk/iKHUACgkQgAnW8HDreRYfogCgx3YAR9bx+V93tb+Qnqgt3i0V
aVYAn2OPbl+oxXteXkiTKY07DqeSf16A
=5Fvp
-----END PGP SIGNATURE-----

--------------enig8B04EEE219ECB3C67259871B--
