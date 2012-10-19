Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab2JSBos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 21:44:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab2JSBoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 21:44:46 -0400
Date: Fri, 19 Oct 2012 12:44:54 +1100
From: NeilBrown <neilb@suse.de>
To: Jan Kara <jack@suse.cz>, "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Fabio Coatti <fabio.coatti@gmail.com>,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Subject: Re: ext3 issue on 3.6.1
Message-ID: <20121019124454.316ecfac@notabene.brown>
In-Reply-To: <20121018220809.GD17646@quack.suse.cz>
References: <CADpTngUPcX71qjE2QKhYqgDg7tZoz+pu8A6nE9DT-zbFKWGx1g@mail.gmail.com>
	<20121018212357.GA17646@quack.suse.cz>
	<1350596425.1366.15.camel@x61.thuisdomein>
	<20121018220809.GD17646@quack.suse.cz>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ffbc9QlNkBZq0r_4_/eT/mM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ffbc9QlNkBZq0r_4_/eT/mM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Oct 2012 00:08:09 +0200 Jan Kara <jack@suse.cz> wrote:

> On Thu 18-10-12 23:40:25, Paul Bolle wrote:
> > On Thu, 2012-10-18 at 23:23 +0200, Jan Kara wrote:
> > > On Fri 12-10-12 14:57:55, Fabio Coatti wrote:
> > > > [13031.051521] ------------[ cut here ]------------
> > > > [13031.051576] WARNING: at fs/inode.c:280 drop_nlink+0x1b/0x35()
> > > > [13031.051624] Hardware name: ProLiant BL465c G7
> > > > [13031.051668] Pid: 3344, comm: php Tainted: G        W
> > > > 3.6.1-1000hz-preempt #2
> > > > [13031.051746] Call Trace:
> > > > [13031.051787]  [<ffffffff810578c4>] ? warn_slowpath_common+0x73/0x=
87
> > > > [13031.051837]  [<ffffffff810ec628>] ? drop_nlink+0x1b/0x35
> > > > [13031.051885]  [<ffffffff8118ad51>] ? nfs_dentry_iput+0x33/0x49
> > > > [13031.051934]  [<ffffffff810ea920>] ? d_kill+0xe8/0x108
> > > > [13031.051980]  [<ffffffff810eb001>] ? dput+0x147/0x154
> > > > [13031.052027]  [<ffffffff810d9e46>] ? __fput+0x19a/0x1b2
> > > > [13031.052073]  [<ffffffff8106bdf0>] ? task_work_run+0x4c/0x60
> > > > [13031.052123]  [<ffffffff815ff5e8>] ? int_signal+0x12/0x17
> > > > [13031.052169] ---[ end trace e60232a455c8e2dd ]---
> > >   And this seems unrelated - likely an NFS problem... Let's sort this=
 out
> > > if you still see it after ext3 issue is solved.
> >=20
> > Looks rather similar too https://lkml.org/lkml/2012/8/29/165 , doesn't
> > it?
>   Yup. I wonder why that patch didn't get merged. Neil?
>=20
> 								Honza

Don't know.  Maybe I slipped under Trond's radar some how.

Trond:  can you comment on and hopefully apply this patch?

Subject of original email was "WARNING: at fs/inode.c:280 drop_nlink+0x31/0=
x33()


Thanks,
NeilBrown

------
Subject: NFS: avoid warning from nfs_drop_nlink

If you remove a file which is open, NFS will 'silly-rename' it to a
hidden file.
If you then remove that hidden file, and then close the open file,
then nfs_dentry_iput will perform an extra drop_nlink().
Since 3.3-rc1, this has produced a warning.
The simplest way to suppress it is to use "nfs_drop_nlink" which
checks for i_nlink being zero.

Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 627f108..268af03 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1174,7 +1174,7 @@ static void nfs_dentry_iput(struct dentry *dentry,
struct inode *inode) NFS_I(inode)->cache_validity |=3D NFS_INO_INVALID_DATA;
=20
 	if (dentry->d_flags & DCACHE_NFSFS_RENAMED) {
-		drop_nlink(inode);
+		nfs_drop_nlink(inode);
 		nfs_complete_unlink(dentry, inode);
 	}
 	iput(inode);


--Sig_/ffbc9QlNkBZq0r_4_/eT/mM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUICwljnsnt1WYoG5AQI/QQ//RX427gIOs2BIiaa1zudiSV+3G9tJwAvW
qqXb5FY8mj2+UOJh0/kheio+xwO+Q+uySztyIcBZIn9/uNBaTviziA8zvrOxyqpN
IU4AADOnQkbLv1g7/pBgeIy9YuDdgtwyihOmYm1moo/lwMBz/zLFqEbDM0AMXWk9
HhU2ip6O7QpNwRy/uHRwjp+1fFuc9kvR6slsDJoF/Cr/mbmszpkFB31TjWtm3PMw
1mjS1sUo4u+35AEF5hOeC/vDHUj3IIHwj3com7WX3G0vHnSdw65d2mDxTsSRgzCQ
vhuoJ/jTZJRWNTGeEagCNfdPDI+J/tfxcNTQGFKW5h7DKDBnjyjfuqDPOMwjY009
vtPmWq3QPIMe46jHpiejLYmRbTjk/xWeVdh2g49RwbsfkDKqsKAdrnyVqGrlVlnf
n6xLG6i9iGVK6cNmVx6E8Tn/ar6QkVZemds2/i4OzDS+VDGNM3VzMF1OtB79q3BX
IWNQXDuMbCwYvFCaVS0oLe1XBczfl81dLb+Rcyf0jkF2voRCWhih0S5P3AmQQQOW
wtiQXNri7kfXa6J6gVjdvbPJGnNbA1EO06qbKvneIYac3t4EpJMp8HMJ+z1R396E
fwXfaheoDpXTYsWdYjZBXtMpKWQweH1A9J7yYLWw+ODnWSdnl7g0coNH9IVyJJt+
f7x+tQLikoc=
=1hYg
-----END PGP SIGNATURE-----

--Sig_/ffbc9QlNkBZq0r_4_/eT/mM--
