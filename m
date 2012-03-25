Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab2CYGc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 02:32:29 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:50811 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab2CYGc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 02:32:26 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian McMenamin <lkmladrian@gmail.com>
Subject: Re: Utility code to generate a VMUFAT filesystem
Date: Sun, 25 Mar 2012 02:32:27 -0400
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh" <linux-sh@vger.kernel.org>,
        Adrian McMenamin <adrianmcmenamin@gmail.com>
References: <CAN628AHjJeLD_bUNGSDmBOo_EW=aFML-VZ-A4GRyAi2eNwA1yw@mail.gmail.com>
In-Reply-To: <CAN628AHjJeLD_bUNGSDmBOo_EW=aFML-VZ-A4GRyAi2eNwA1yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10580978.2dHgQjt6yB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201203250232.29843.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10580978.2dHgQjt6yB
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wednesday 21 March 2012 00:41:17 Adrian McMenamin wrote:
> /*
>  * mkfs.vmufat.c - make a linux (VMUFAT) filesystem
>  *
>  * Copyright (c) 2012 Adrian McMenamin adrianmcmenamin@gmail.com
>  * Licensed under Version 2 of the GNU General Public Licence
>  *
>  * Parts shamelessly copied from other mkfs code
>  * copyright Linus Torvalds and others
>  */

might be useful to sneak into tools/ or Documentation/ or fs/vmufat/

> void usage()

(void)

seems like most (if not just about all) funcs in here should be static

> int checkmount(char* device_name)
> {
> 	FILE * f;
> 	struct mntent * mnt;

kernel style wise, this really should be:
	char *foo;
	FILE *f;
	struct mntent *mnt;
	etc...

device_name here should be const

> 	if ((f =3D setmntent(_PATH_MOUNTED, "r")) =3D=3D NULL)
> 		return;

there is libmount now, but that might be overkill for this small tool

> int readforbad(struct badblocklist** root, char* filename, int verbose)

filename should be const

> {
> 	int error =3D 0;
> 	FILE *listfile;
> 	int badblocks =3D 0;
> 	unsigned long blockno;
> 	...
>=20
> 	while (!feof(listfile)) {
> 		if (fscanf(listfile, "%ld\n", &blockno) !=3D 1) {

%ld is "signed long" but blockno is "unsigned long".  probably want %lu her=
e=20
and elsewhere in this func.

> void _fill_root_block(char* buf, const struct vmuparam* param)

incoming buf is "char *" ...

> 	uint16_t* wordbuf;
>=20
> 	wordbuf =3D (uint16_t *)buf;

=2E.. which you cast up to "uint16_t *" ...

> int mark_root_block(int device_numb, const struct vmuparam *param, int
> verbose) {
> 	char zilches[BLOCKSIZE];
> 	int i, error =3D 0;
>=20
> 	for (i =3D 0; i < BLOCKSIZE; i++)
> 		zilches[i] =3D '\0';
>=20
> 	_fill_root_block(zilches, param);

=2E.. and is declared on the stack as "char *".  there are no alignment=20
requirements here, and iirc, superh doesn't support unaligned loads.  so yo=
u=20
should add gcc aligned attributes, or declare the buffer better:
	uint16_t zilches[BLOCKSIZE / 2];

> int zero_blocks(int device_numb, const struct vmuparam *param, int verbos=
e)
> {
> 	char zilches[BLOCKSIZE];
> 	int i, error =3D -1;
>=20
> 	for (i =3D 0; i < BLOCKSIZE; i++)
> 		zilches[i] =3D '\0';

memset(zilches, '\0', BLOCKSIZE);

> int scanforbad(int device_numb, struct badblocklist** root, int verbose)
> {
> 	int error =3D 0, i;
> 	struct badblocklist *lastbadblock =3D NULL;
> 	off_t size;
> 	long got;
> 	char buffer[BLOCKSIZE];
>=20
> 	size =3D lseek(device_numb, 0, SEEK_END);

if you use fstat() here ...

> 	for (i =3D 0; i < size/BLOCKSIZE; i++)
> 	{
> 		if (verbose > 0)
> 			printf("Testing block %i\n", i);
> 		if (lseek(device_numb, i * BLOCKSIZE, SEEK_SET) !=3D
> 			i * BLOCKSIZE) {
> 			printf("Seek failed on device\n");
> 			error =3D -1;
> 			goto out;
> 		}
> 		got =3D read(device_numb, buffer, BLOCKSIZE);

=2E.. and pread() here, there's no need for the lseek()'s at all.

> 	if (lseek(device_numb, fatblock * BLOCKSIZE, SEEK_SET) < 0)
> 		goto out;
> 	if (read(device_numb, buffer, BLOCKSIZE) !=3D BLOCKSIZE)
> 		goto out;

use pread() instead of lseek() && read()

> 	if (lseek(device_numb, fatblock * BLOCKSIZE, SEEK_SET) < 0)
> 		goto out;
> 	if (write(device_numb, buffer, BLOCKSIZE) !=3D BLOCKSIZE)
> 		goto out;

and pwrite() instead of lseek() && write()

> 	if (checkmount(device_name) < 0)
> 		goto out;
>=20
> 	if (stat(device_name, &statbuf) < 0) {
> 		printf("Cannot get status of %s\n", device_name);
> 		goto out;
> 	}
> 	if (!S_ISBLK(statbuf.st_mode)) {
> 		printf("%s must be a block device\n", device_name);
> 		goto out;
> 	}
> 	device_numb =3D open(device_name, O_RDWR|O_EXCL);

technically you've got a race condition here.  really should do the open() =
and=20
then do fstat() on the fd you get back.

also, what's with the O_EXCL ?  that only makes sense with O_CREAT.

should you open+fstat before checking for the mount point ?  guess it doesn=
't=20
really matter.

it's useful to be able to format regular files as filesystems especially fo=
r=20
debugging.  most mkfs tools issue a warning or prompt by default, and using=
=20
the -f (force) flag allows you to format regular files.
=2Dmike

--nextPart10580978.2dHgQjt6yB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPbrv9AAoJEEFjO5/oN/WBQt4QAJnBvV4tpPfgKU1z2vYWCklj
swy2fcHpbfjoWq+hWwzA3ZWvSmOWeLYUOeAEHNnTcOi6I6azg7+4DqS4ILteEXyA
EwESoR6cZaAPBvO3ItB/e6wNd5HSSDkvL8LxiEyClaCJpMew9GQcPiqB7No50kl6
8dvlOIS+VUkFciSlxI1gXm4HzT51alA7eXgBDp2z0xA+TG90ZRYgtQoa0P+MtBC/
S6d7rSt0p7ckSUgzfBeaALRiJeM8bNyFaxg2rEV76uJHm7oODZ7Q5P/DfbzZv2xZ
H8RAj6nWH9E5KGmsVaAyRU33L9j1XkVmKH1Rome5GknwwhWWDCLNG/JqQD91Uvbb
YA/d6IhBklCBcQnK3x495MYOy8Bv+g3VtpwmX6PSCzbAH4QQi72mifOeGdhPxB0I
QxlxG39XV2/8rxB1NKu1Xf/S/mMpC9Jrekm13qS4AzCE80VzVEPPGtJOCsjnJ92v
L+ZfjN1l+I26DkospuWv2L79OfoSKPNCvWkus81rH/VIeQI+C7SU3QVnjJ38Z4oU
KCZx0p3PLMhpM3AZ0ZVqpqOZ2kP5wNEOwvRkBn3hGp3KnyywzbyY6MQGiVxtpfjY
BTPM+DPROMRWHj4fKc5T55ptNIffhhYUADdz15EpuLq4DtlVCeoW7i5Xv4kRlcMb
Nzv9FujPk1NhktOXiftm
=fXnT
-----END PGP SIGNATURE-----

--nextPart10580978.2dHgQjt6yB--
