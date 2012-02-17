Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab2BQAix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:38:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55365 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab2BQAiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:38:51 -0500
Date: Thu, 16 Feb 2012 18:38:49 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: hugetlbfs lockdep spew revisited.
Message-ID: <20120217003848.GB20071@boyd>
References: <20120217000856.GA13112@redhat.com>
 <20120217001634.GH23550@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
In-Reply-To: <20120217001634.GH23550@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-02-16 19:16:34, Josh Boyer wrote:
> On Thu, Feb 16, 2012 at 07:08:57PM -0500, Dave Jones wrote:
> > Remember this ? https://lkml.org/lkml/2011/4/15/272
> > Josh took a stab at fixing it in e096d0c7e2e4e5893792db865dd065ac73cf1f=
00,
> > but it seems to still be there.
>=20
> I think Tyler Hicks actually noticed this a while ago, but his patch has
> been waiting on comment from Al and Christoph:
>=20
> http://thread.gmane.org/gmane.linux.file-systems/58795/focus=3D59565
>=20
> I've been hesitant to comment because I obviously screwed up once
> already.  We could try this patch in Fedora for a while if Al and
> company don't speak up soon.

I'm pretty confident that my patch that Josh linked to would "fix" the
lockdep warning below. According to the backtrace, it is barking about a
directory inode and a regular inode having a circular locking
dependency, so deadlock is not possible in this case.

akpm picked up my patch in the mm tree, but it still hasn't made it into
mainline.

Tyler

>=20
> josh
>=20
> >=20
> > 	Dave
> >=20
> >=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > [ INFO: possible circular locking dependency detected ]
> > 3.3.0-rc3+ #2 Not tainted
> > -------------------------------------------------------
> > trinity/30663 is trying to acquire lock:
> >  (&sb->s_type->i_mutex_key#18){+.+...}, at: [<ffffffff81298169>] hugetl=
bfs_file_mmap+0x89/0x140
> >=20
> > but task is already holding lock:
> >  (&mm->mmap_sem){++++++}, at: [<ffffffff81182d97>] sys_mmap_pgoff+0x1d7=
/0x230
> >=20
> > which lock already depends on the new lock.
> >=20
> >=20
> > the existing dependency chain (in reverse order) is:
> >=20
> > -> #1 (&mm->mmap_sem){++++++}:
> >        [<ffffffff810d073d>] lock_acquire+0x9d/0x220
> >        [<ffffffff811789c0>] might_fault+0x80/0xb0
> >        [<ffffffff811d2997>] filldir+0x77/0xe0
> >        [<ffffffff811e61ae>] dcache_readdir+0x5e/0x220
> >        [<ffffffff811d2c68>] vfs_readdir+0xb8/0xf0
> >        [<ffffffff811d2d99>] sys_getdents+0x89/0x100
> >        [<ffffffff816a5b69>] system_call_fastpath+0x16/0x1b
> >=20
> > -> #0 (&sb->s_type->i_mutex_key#18){+.+...}:
> >        [<ffffffff810d0008>] __lock_acquire+0x1bf8/0x1c20
> >        [<ffffffff810d073d>] lock_acquire+0x9d/0x220
> >        [<ffffffff8169a5b9>] __mutex_lock_common+0x59/0x500
> >        [<ffffffff8169ab94>] mutex_lock_nested+0x44/0x50
> >        [<ffffffff81298169>] hugetlbfs_file_mmap+0x89/0x140
> >        [<ffffffff811826a9>] mmap_region+0x369/0x4f0
> >        [<ffffffff81182b9f>] do_mmap_pgoff+0x36f/0x390
> >        [<ffffffff81182db7>] sys_mmap_pgoff+0x1f7/0x230
> >        [<ffffffff8101eda2>] sys_mmap+0x22/0x30
> >        [<ffffffff816a5b69>] system_call_fastpath+0x16/0x1b
> >=20
> > other info that might help us debug this:
> >=20
> >  Possible unsafe locking scenario:
> >=20
> >        CPU0                    CPU1
> >        ----                    ----
> >   lock(&mm->mmap_sem);
> >                                lock(&sb->s_type->i_mutex_key#18);
> >                                lock(&mm->mmap_sem);
> >   lock(&sb->s_type->i_mutex_key#18);
> >=20
> >  *** DEADLOCK ***
> >=20
> > 1 lock held by trinity/30663:
> >  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81182d97>] sys_mmap_pgoff+=
0x1d7/0x230
> >=20
> > stack backtrace:
> > Pid: 30663, comm: trinity Not tainted 3.3.0-rc3+ #2
> > Call Trace:
> >  [<ffffffff816924d7>] print_circular_bug+0x1fb/0x20c
> >  [<ffffffff810d0008>] __lock_acquire+0x1bf8/0x1c20
> >  [<ffffffff816a1c2d>] ? sub_preempt_count+0x9d/0xd0
> >  [<ffffffff811a40cc>] ? deactivate_slab+0x54c/0x5f0
> >  [<ffffffff810d073d>] lock_acquire+0x9d/0x220
> >  [<ffffffff81298169>] ? hugetlbfs_file_mmap+0x89/0x140
> >  [<ffffffff810d12fd>] ? trace_hardirqs_on_caller+0x10d/0x1a0
> >  [<ffffffff8169a5b9>] __mutex_lock_common+0x59/0x500
> >  [<ffffffff81298169>] ? hugetlbfs_file_mmap+0x89/0x140
> >  [<ffffffff811825e5>] ? mmap_region+0x2a5/0x4f0
> >  [<ffffffff81298169>] ? hugetlbfs_file_mmap+0x89/0x140
> >  [<ffffffff8169ab94>] mutex_lock_nested+0x44/0x50
> >  [<ffffffff81298169>] hugetlbfs_file_mmap+0x89/0x140
> >  [<ffffffff811826a9>] mmap_region+0x369/0x4f0
> >  [<ffffffff812c1e9a>] ? file_map_prot_check+0xaa/0xe0
> >  [<ffffffff81182b9f>] do_mmap_pgoff+0x36f/0x390
> >  [<ffffffff81182d97>] ? sys_mmap_pgoff+0x1d7/0x230
> >  [<ffffffff81182db7>] sys_mmap_pgoff+0x1f7/0x230
> >  [<ffffffff810d12fd>] ? trace_hardirqs_on_caller+0x10d/0x1a0
> >  [<ffffffff8101eda2>] sys_mmap+0x22/0x30
> >  [<ffffffff816a5b69>] system_call_fastpath+0x16/0x1b
> >=20

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPPaGYAAoJENaSAD2qAscKCvEQAJzcrQieyXl9l/YLOVzM67rI
N2qh0aXO0ndJZZ3D7dYeXHHuP7ulxx1zAK9SMi1JVgFsqN5JLmnm6tU3Hbt/rnF0
e6nAmB1Z8V9/R0v4T4KREtAH7BgBx1NXaCXNNHRp6KLBTxC/baQAnblr+i/h9ohY
MoAfb58MzFTa8evCRQesPRB5tvcpapkcQIW4N27ACH72ayxwEA6hi4HGOwayfQEK
3wRoLv6sRodbmWItFDzx4ORZzS1YMCc7H01cQlfW0pmvCAUPpB9F3DmVd63HRS/L
KCz66c3uEOketeC6safZwNdqHSB2USyhnpZfnbbLG6oC5FjoQQlieznKz7CYnRRi
Wph9Aq0p1xcQEvZ/MfBsd76WZn8Wjxv71Usedq0XHCf5aoZ0yJA/GoUQ22TFfSib
aPVbc5R0LXaumK3IbvY8Kr3Cqk/XB0IG5JEQYF6pgJcKNtjeu8IlTpL2jreraZKh
PFx/D0QuuRKrofLSMj3rs3bepxdR3vVnPc8eGpYOU2vgFsgla8nOLtsDnX2fT2lq
K7G/XIC7nHu7LIqdEvW9SefYO99B2VkGIUMOagD49zoXtrVa15JGTLVbeLfu2fqc
Xe3D3RdjhUKENXAN5y42NAWCoNUX+2SOYdSEfUc0JkaoUScwSjD5kMzzn1E8+M9D
e6/U4tgW7NkO6JHmyGlu
=NF4M
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
