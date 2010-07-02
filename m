Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab0GBJpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:45:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62327 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab0GBJpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:45:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nQb5HEizdjg+S9l0K+G6dkduFbhoR+IJ7IWBpBMgKJytmid33bmHR6K1E9HUDbmj/7
         R3mD68m11OYC+Dvfv9RiRtiEV0oeouM1bc2SJdPhX4ktZ8Hbq6jPU/NltS7d5CmjnoR3
         DgB4RdUxaXQ5bd+YadHjbUPYdiEb5NRWWTkjY=
Date: Fri, 2 Jul 2010 12:49:16 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: reiserfs locking (v2)
Message-ID: <20100702094916.GA5103@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Crap, I forgot to munmap. Sorry.

fixed


=3D=3D=3D code =3D=3D=3D


/*

2010, Sergey Senozhatsky. GPLv2

Description:
We have several PIDs working with conftest.mmap.
Actually this is (seems) what hapenning during emacs configure.

traced emacs configure:

vfork() ...
=3D=3D=3D=3D
=2E.. PID 5446

5446 open("conftest.mmap", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0600) =3D 3
write(3,
"g\306isQ\377J\354)\315\272\253\362\373\343F|\302T\370\33\350\347\215vZ.c3\=
237\311\232"...,=20
4096) =3D 4096
close(3)                          =3D 0
open("conftest.txt", O_RDWR|O_CREAT|O_TRUNC|O_LARGEFILE, 0600) =3D 3
write(3, "\0", 1)                 =3D 1
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) =3D 0xb78a8000
close(3)                          =3D 0
munmap(0xb78a8000, 4096)          =3D 0
open("conftest.mmap", O_RDWR|O_LARGEFILE) =3D 3
mmap2(0xb78a8000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, =20
3, 0) =3D 0xb78a8000
read(3,
"*****"...,=20
4096) =3D 4096
close(3)                          =3D 0

open(".", O_RDONLY|O_LARGEFILE)   =3D 3
close(3)                          =3D 0
fstatat64(AT_FDCWD, "conftest.mmap", {st_mode=3DS_IFREG|0600,
st_size=3D4096, ...}, AT_SYMLINK_NOFOLLOW) =3D 0
unlinkat(AT_FDCWD, "conftest.mmap", 0) =3D 0

=3D=3D=3D=3D
=2E.. PID 5449
5449  fstatat64(AT_FDCWD, "conftest.mmap", {st_mode=3DS_IFREG|0600, st_size=
=3D4096, ...}, AT_SYMLINK_NOFOLLOW) =3D 0
5449  unlinkat(AT_FDCWD, "conftest.mmap", 0) =3D 0
5449  execve("/bin/rm", ["rm", "-f", "conftest.mmap", "conftest.txt"]
=2E.
*/

/*
  The code below produces:
[   46.727489] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   46.727495] [ INFO: possible circular locking dependency detected ]
[   46.727499] 2.6.35-rc3-dbg-git5-00446-g36336bc-dirty #64
[   46.727503] -------------------------------------------------------
[   46.727506] a.out/5840 is trying to acquire lock:
[   46.727510]  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<c10f1d5c>] rei=
serfs_file_release+0x12b/0x367
[   46.727526]=20
[   46.727527] but task is already holding lock:
[   46.727530]  (&mm->mmap_sem){++++++}, at: [<c1092937>] sys_mmap_pgoff+0x=
a4/0xe7
[   46.727540]=20
[   46.727541] which lock already depends on the new lock.
[   46.727543]=20
[   46.727546]=20
[   46.727546] the existing dependency chain (in reverse order) is:
[   46.727550]=20
[   46.727551] -> #1 (&mm->mmap_sem){++++++}:
[   46.727557]        [<c104f566>] lock_acquire+0x59/0x70
[   46.727565]        [<c108cf70>] might_fault+0x53/0x70
[   46.727571]        [<c1185438>] copy_to_user+0x30/0x48
[   46.727578]        [<c10afaf9>] filldir64+0x95/0xc9
[   46.727584]        [<c10f257c>] reiserfs_readdir_dentry+0x35d/0x4d9
[   46.727590]        [<c10f270a>] reiserfs_readdir+0x12/0x17
[   46.727596]        [<c10afd17>] vfs_readdir+0x6d/0x92
[   46.727600]        [<c10afe91>] sys_getdents64+0x63/0xa2
[   46.727606]        [<c10027d3>] sysenter_do_call+0x12/0x32
[   46.727612]=20
[   46.727613] -> #0 (&sb->s_type->i_mutex_key#10){+.+.+.}:
[   46.727621]        [<c104ef5c>] __lock_acquire+0x96d/0xbe1
[   46.727626]        [<c104f566>] lock_acquire+0x59/0x70
[   46.727632]        [<c12c5694>] __mutex_lock_common+0x39/0x36b
[   46.727639]        [<c12c5a00>] mutex_lock_nested+0x12/0x15
[   46.727644]        [<c10f1d5c>] reiserfs_file_release+0x12b/0x367
[   46.727650]        [<c10a5805>] fput+0xe0/0x16a
[   46.727657]        [<c1090c9e>] remove_vma+0x28/0x47
[   46.727662]        [<c1091a60>] do_munmap+0x1e8/0x200
[   46.727667]        [<c109230a>] mmap_region+0x6b/0x372
[   46.727672]        [<c109284d>] do_mmap_pgoff+0x23c/0x282
[   46.727678]        [<c1092950>] sys_mmap_pgoff+0xbd/0xe7
[   46.727683]        [<c10027d3>] sysenter_do_call+0x12/0x32
[   46.727689]=20
[   46.727690] other info that might help us debug this:
[   46.727691]=20
[   46.727695] 1 lock held by a.out/5840:
[   46.727698]  #0:  (&mm->mmap_sem){++++++}, at: [<c1092937>] sys_mmap_pgo=
ff+0xa4/0xe7
[   46.727707]=20
[   46.727708] stack backtrace:
[   46.727713] Pid: 5840, comm: a.out Not tainted 2.6.35-rc3-dbg-git5-00446=
-g36336bc-dirty #64
[   46.727717] Call Trace:
[   46.727722]  [<c12c4913>] ? printk+0xf/0x11
[   46.727728]  [<c104dc09>] print_circular_bug+0x8a/0x96
[   46.727734]  [<c104ef5c>] __lock_acquire+0x96d/0xbe1
[   46.727740]  [<c104ccc8>] ? look_up_lock_class+0x6c/0x7b
[   46.727746]  [<c104e462>] ? mark_lock+0x26/0x1b3
[   46.727752]  [<c104f566>] lock_acquire+0x59/0x70
[   46.727758]  [<c10f1d5c>] ? reiserfs_file_release+0x12b/0x367
[   46.727764]  [<c12c5694>] __mutex_lock_common+0x39/0x36b
[   46.727769]  [<c10f1d5c>] ? reiserfs_file_release+0x12b/0x367
[   46.727775]  [<c12c5a00>] mutex_lock_nested+0x12/0x15
[   46.727781]  [<c10f1d5c>] ? reiserfs_file_release+0x12b/0x367
[   46.727786]  [<c10f1d5c>] reiserfs_file_release+0x12b/0x367
[   46.727792]  [<c108d77d>] ? free_pgd_range+0x96/0x12f
[   46.727798]  [<c10a57b5>] ? fput+0x90/0x16a
[   46.727803]  [<c10a5805>] fput+0xe0/0x16a
[   46.727808]  [<c1090c9e>] remove_vma+0x28/0x47
[   46.727814]  [<c1091811>] ? arch_unmap_area_topdown+0x0/0x18
[   46.727819]  [<c1091a60>] do_munmap+0x1e8/0x200
[   46.727825]  [<c109230a>] mmap_region+0x6b/0x372
[   46.727831]  [<c109284d>] do_mmap_pgoff+0x23c/0x282
[   46.727837]  [<c1092950>] sys_mmap_pgoff+0xbd/0xe7
[   46.727842]  [<c10027d3>] sysenter_do_call+0x12/0x32

 =20
 */

#define _GNU_SOURCE

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

int main()
{
	char buf[4096];
	int i =3D 0;
	/* we don't really care */
	for (; i < 4096; i++)
		buf[i] =3D (i + 65) % 255;

	for (i =3D 0; i < 10; i++) {

		int pid =3D fork();
		if (pid > 0 ) {
			printf("parent...");
		} else if (pid =3D=3D 0) {
		=09
			printf("child...\n");
			int fd =3D open("conftest.mmap", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0=
600);
			if (fd > 0) {
				printf("OPEN ok %d\n", fd);
				if (write(fd, buf, 4096) < 0)
					printf("WRITE error\n");
				else
					printf("WRITE ok\n");
			=09
				close(fd);
			} else {
				printf("OPEN error\n");
			}
		=09
			fd =3D open("conftest.mmap", O_RDWR|O_LARGEFILE);
			if (fd > 0) {
				printf("OPEN conftest.mmap %d\n", fd);
			=09
				void *map =3D mmap((void*)0xb78a8000, 4096, PROT_READ|PROT_WRITE, MAP_P=
RIVATE|MAP_FIXED, fd, 0);
				if (map =3D=3D MAP_FAILED) {
					printf("MMAP failed\n");
					goto out;
				} else {
					printf("MMAP ok\n");
				}
			=09
				if (read(fd, buf, 4096) < 0)
					printf("READ failed\n");
				else
					printf("READ ok\n");

				close(fd);
				munmap(map, 4096);
			} else {
				printf("Error: can't open conftest.mmap\n");
			}
		=09
		out:
			fd =3D open(".", O_RDONLY|O_LARGEFILE);
			if (fd > 0) {
				printf("OPEN . ok %d... closing\n", fd);
				close(fd);
			} else {
				printf("OPEN error\n");
			}
		=09
			struct stat _stat;
			if (fstatat(AT_FDCWD, "conftest.mmap", &_stat, AT_SYMLINK_NOFOLLOW) < 0)
				printf("FSTATAT error\n");
			else
				printf("FSTATAT ok\n");
		=09
			if (unlinkat(AT_FDCWD, "conftest.mmap", 0) < 0)
				printf("UNLINKAT error\n");
			else
				printf("UNLINKAT ok\n");

		} else {
			printf("FORK error\n");
		}
	}
=09
	return 0;
}


--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkwtthwACgkQfKHnntdSXjTD2QP+MsiS9JtHMnHKbt9tYYKKAhSJ
/eUIfTFHhfxZlCb6+EMDyccjQimFWHS6IiiqoaiLiO+ahvJ7j4EDP6bLTWavK4D5
r7a3mmSoE/3BXCi9+1umzvtM1FINPp+JmvZ+BanL+Kde49yg5exq/e8j0OyUF5hu
deMPjfb38TM1sM7X6IM=
=jgSf
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
