Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab2FEHbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 03:31:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:40497 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab2FEHbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 03:31:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="174904195"
Message-ID: <1338881735.2507.36.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] exofs: stop using s_dirt
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Benny Halevy <bhalevy@tonian.com>, osd-dev@open-osd.org
Date: Tue, 05 Jun 2012 10:35:35 +0300
In-Reply-To: <4FCCDE86.4060507@panasas.com>
References: <1338810507-26539-1-git-send-email-dedekind1@gmail.com>
	 <4FCCDE86.4060507@panasas.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-QjHtGA8/26WvRqoUTdrV"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QjHtGA8/26WvRqoUTdrV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-06-04 at 19:12 +0300, Boaz Harrosh wrote:
> I have one question though, which I did not understand at the time?
>=20
> Today at exofs_write_super() we call exofs_sync_fs() (super_operations->s=
ync_fs)
> Who/when calls ->sync_fs() without the ->write_super() below.

Not sure I understood your question correctly, but:

o VFS calls '->sync_fs()' on
  * sync(2)
  * syncfs(2)
  * when unmounting, before calling '->put_super()'
  * when re-mounting, before calling '->remount_fs()'
  * when freezing (happens when suspending the system)
  * when the underlying block device is synced (see 'fsync_bdev()')
o '->write_super()' is called only from one place - from the
  'sync_supers()' function (which is only used by the 'sync_supers'
   kernel thread) if the superblock is dirty. This thread wakes up every
   5 seconds and calls '->write_super()' for all dirty superblocks.

In case of exofs you never set 's_dirt' to non-zero, which means that
'exofs_write_super()' is never called. This means we can remove it and
this won't change anything for exofs.

Basically, in the ideal world where power-cuts and unclean reboots do
not exist, '->write_super()' is not needed because the superblock will
be synced on unmount. The 'write_super()' stuff is about making sure
that your dirty superblock stays dirty only for limited amount of time
(defined via /proc/sys/vm/dirty_writeback_centisecs) and then gets
synced so you have less chances end up with a not completely up-to-date
superblock.

--=20
Best Regards,
Artem Bityutskiy

--=-QjHtGA8/26WvRqoUTdrV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPzbbHAAoJECmIfjd9wqK0ihQP/3vZH+tZ+w/fqfXJdgyL9PkH
bkhQr/TrGGiOZPkHwofuuA79cOkVO4AlKdw4licm7DNbiEnGUvmC/g4CVbVqS8ZQ
IRkvYC4l5wigspcwtm9Kt4hOhCAt30p9dEsdWvyc5vkb+bMXiCqi6X59PA8TUXs6
bk5Xa3ztEh9c4h5+BDiLi0u83vDtklqMG+uhL3y0/1uNQAPLNyVWFZ++tpnq6WoB
FznmvzO3Cbh9EhINMxi/xQ+Ps+dgEHvdSfYVYuoAjHJ0DDgxfGDzhJhcjFgW8wiQ
KweJp01AxGqJF9doQYQtXVbfwlpnOhmjUTKkZAIO6nibjrggwqTCGxN8haPfWSAv
Yd0tqmrmZzREaedYf/aJ6dm8/vtE+/9LUUPJ5T68ylFF/u7eZw1g8Wgkb/yOeDmg
Xt5na83BVEbtD/Ea+8GUclRbK7D7zISad6lsCb+RyYX3nEqrsW9pEWdMJaYtFNaC
aY499BUaXUdtFLOvxuhrpEgO9apnb14IhjGx0LgQBkrJqe7Fj2wwrwVqNhIiZHAy
+m5ywSmyvqgxK1N0U+TdC1kW6fvi0ZKuQK8uZuXr4+muXQeDE9rc5aUVrEQ/W1Tt
UJtQaLiA01GMDXPCiIWOmQ/GbmICXhM3rjPjG8lO6CViaHraTkdgKZukh8n3lCVp
RjbiheFe6Pc9zGEJIVa2
=hSc2
-----END PGP SIGNATURE-----

--=-QjHtGA8/26WvRqoUTdrV--

