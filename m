Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2CEVqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:46:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38712 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab2CEVq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:46:29 -0500
Date: Mon, 5 Mar 2012 15:46:22 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dustin Kirkland <dustin.kirkland@gazzang.com>,
        ecryptfs@vger.kernel.org
Subject: Re: Linus GIT (3.3.0-rc6+) -- INFO: possible circular locking
 dependency detected
Message-ID: <20120305214621.GC29910@boyd>
References: <CAHFgRy-V3ZFK6QrC2++Rvyi4e_f-03Xdr9sj4PUJORVq21GiEw@mail.gmail.com>
 <20120305132334.e3fc92cb.akpm@linux-foundation.org>
 <20120305213557.GO23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="s9fJI615cBHmzTOP"
Content-Disposition: inline
In-Reply-To: <20120305213557.GO23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s9fJI615cBHmzTOP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-03-05 21:35:58, Al Viro wrote:
> On Mon, Mar 05, 2012 at 01:23:34PM -0800, Andrew Morton wrote:
> > mmap_sem nests inside i_mutex.
> >=20
> > On the path
> >=20
> > 	munmap
> > 	->ecryptfs_vma_close
> > 	  ->filemap_write_and_wait
> > 	    ->generic_file_aio_write
> >=20
> > we're taking i_mutex inside mmap_sem.  So the problem is triggered by
> > ecryptfs_vma_close() calling filemap_write_and_wait() inside munmap()'s
> > mmap_sem.
> >=20
> > Question is: what did we recently change to cause this to happen?
>=20
> AFAICS, it's commit 32001d6fe9ac6b0423e674a3093aa56740849f3b
> Author: Tyler Hicks <tyhicks@canonical.com>
> Date:   Mon Nov 21 17:31:29 2011 -0600
>=20
>     eCryptfs: Flush file in vma close

Yes, it is definitely this commit. This is mainly what brought about my
patch to fix the incorrect logic around lockdep_set_class() in
lockdep_annotate_inode_mutex_key(). With that patch, I no longer saw
these lockdep warnings, so I wrote it off. Al has since made it clear
that this locking order is wrong.

This should fix itself when I revert
57db4e8d73ef2b5e94a3f412108dff2576670a8a. We'll no longer need this
flush in vma_close(), so 32001d6fe9ac6b0423e674a3093aa56740849f3b will
be reverted, too. I was planning on waiting until 3.4 to do all of that
since it will be a somewhat big change (even though it is mainly
reverting of patches).

Tyler

--s9fJI615cBHmzTOP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPVTQtAAoJENaSAD2qAscKaKAQAKgD+08pJ0NuSDt/AmXwNOaV
zfF1LSFB/CBxXcTO79RgEaY/bnoIRPijjFrf4BE8m200MfgBRjXGAtBDlJknjd6U
bSiDYmEirVpNVUfvfHVHHFBXDIkq0wP2YnlgLQ4uBO4Yk4VYg2d4yjuf6jw8ZExz
LaQeNp13VG//sRnKi1puhnPcwOwGfnMpD9UhiqSZg5qTjq9vcGUVi1bsuPgrmKHE
dZAHOzjagcpCMzJAJKvL4hcakPvAZP+MjBUKoEZdlnL+d6fviTWxtk0qFj24UgL9
bajnSFKXCZrgfIeCJNRAzLGLOVGmKjjw2LRnq4oxlFxUSWPlvzzunWrXvphotBPE
XmQ/xdOjD41ICOsjpSbmyfn8KTNufPyyeyYD9XZzwcn7D/b6F96NM8CZUg2bhttf
mohRZnZrtYF+5NSSIpUvzPZsseTDouEor8b8YaQIw4qErigIHfzmQ2Kb0zeAK9be
/kpePIWMYK9KBkityK74VMwPxEk5YdZGLEUo8YNbwMdtS/nrkb1UD62UuUqNyocZ
VdYW7sST0P37nVzQu6IO8YHbs4yyLUBkvGeZKoVm02UPDeV5jy6mcMshOQ1UblWx
3mBBWzi0C+LpF6aYD/ZNlMY23X+b9OPNn3/kVdTQl+K0fAog+ZAk51pErtBMLRzr
20AJokvL2ll8rdjFIhiQ
=jeX9
-----END PGP SIGNATURE-----

--s9fJI615cBHmzTOP--
