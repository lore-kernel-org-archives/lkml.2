Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab2BJTlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:41:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59103 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab2BJTlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:41:49 -0500
Date: Fri, 10 Feb 2012 13:41:42 -0600
From: "'Tyler Hicks'" <tyhicks@canonical.com>
To: Li Wang <liwang@nudt.edu.cn>
Cc: "'Jan Kara'" <jack@suse.cz>, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Yong Peng'" <pengyong@kylinos.com.cn>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, Thieu Le <thieule@chromium.org>
Subject: Re: [PATCH] eCryptfs: Quota check incorrectly ignored
Message-ID: <20120210194142.GB15606@boyd>
References: <1328787572-2030-1-git-send-email-liwang@nudt.edu.cn>
 <528868922.02520@eyou.net>
 <000001cce802$709bf770$51d3e650$@edu.cn>
 <20120210193148.GA15606@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Content-Disposition: inline
In-Reply-To: <20120210193148.GA15606@boyd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-02-10 13:31:49, 'Tyler Hicks' wrote:
> On 2012-02-10 22:44:05, Li Wang wrote:
> > > -----Original Message-----
> > > From: Jan Kara [mailto:jack@suse.cz]
> > > Sent: Friday, February 10, 2012 6:32 PM
> > > To: Li Wang
> > > Cc: Tyler Hicks; ecryptfs@vger.kernel.org; linux-kernel@vger.kernel.o=
rg;
> > Jan
> > > Kara; Yong Peng
> > > Subject: Re: [PATCH] eCryptfs: Quota check incorrectly ignored
> > >=20
> > > On Thu 09-02-12 19:39:32, Li Wang wrote:
> > > > eCryptfs recently modified the write path to perform encryption
> > > > and write down in ecryptfs_writepage(). This function invokes
> > vfs_write()
> > > > to write down the encrypted data to lower page cache. vfs_write() w=
ill
> > > > first make sure this write will not exceed the quota limit for the =
owner
> > > > of the file being written into, if quota is supported by
> > > > the underlying file system, and it is turned on. Normally, it
> > accomplishs
> > > > this job by calling check_idq()/check_bdq() (fs/quota/dquot.c). When
> > system
> > > > dirty ratio is not high, ecryptfs_writepage() is normally invoked b=
y the
> > > > write back kernel thread, who has the capability CAP_SYS_RESOURCE,
> > > > this priority will let check_idq()/check_bdq() directly bypass the =
quota
> > > > check. This sometimes makes data safely written into the disk in sp=
ite
> > of
> > > > exceeding the quota limit.
> > > >
> > > > This patch temporarily removes the CAP_SYS_RESOURCE capability from=
 the
> > > kernel
> > > > thread before invoking vfs_write_lower(), to let it undergo quota c=
heck
> > by
> > > > the lower file system, if necessary. After that, reassign the
> > capability.
> > >   Hmm, but then the error will just be thrown away by the flusher thr=
ead
> > > and the application never learns about it? That doesn't sound like a =
good
> > > solution.
> > >=20
> > > 								Honza
> >=20
> > Yes. we are aware of that, but we have not found better solution, since=
 it
> > seems=20
> > VFS does not supply a file system independent interface to check quota =
early
> > and only
> > (fix us if we are wrong), The file systems just perform the quota check=
 in
> > their own way,=20
> > the routine is wrapped deeply inside the file system specific code path.
> > Maybe we could
> > copy some codes from _dquot_alloc_space() & dquot_alloc_inode
> > (fs/quota/dquot.c) to=20
> > perform quota check on lower inode ourselves, but that is ugly, and we =
are
> > not sure if it works
> > for any file system or not..., On the other side, due to the existence =
of
> > write buffer, and io schedule,
> > the successful write call does not gurantee the data will be written in=
to
> > disk, in terms of that,
> > we do not change much of the semantic of write call.=20
>=20
> Maybe I should just revert 57db4e8d73ef2b5e94a3f412108dff2576670a8a
> (and friends) and go back to the write-through cache model for eCryptfs.
> The write-back model has some nice performance improvements, but we keep
> running into little issues like this. For write-through to work
> reliably, we're going to need some support from the VFS that isn't there
> yet.

Sorry, that should be "For write-back to work reliably, we're going to
need some support from the VFS that isn't there yet."

Tyler

>=20
> Handling ENOSPC correctly is another area that is lacking after the
> switch to write-back. Currently, an application will continue to write
> out data without having any indication that the disk is full. Thieu
> proposed a fix, but it was never merged:
>=20
> http://article.gmane.org/gmane.linux.kernel/1209265
>=20
> So, what do folks think about going back to a write-through cache until
> we have the ability to alert the application of these error conditions?
>=20
> Tyler
>=20
> > =20
> > >=20
> > >=20
> > > >
> > > > Signed-off-by: Li Wang <liwang@nudt.edu.cn>
> > > > Singed-off-by: Yong Peng <pengyong@kylinos.com.cn>
> > > > ---
> > > >
> > > > To repeat this bug,
> > > > 	mount -o usrquota /dev/sda3 /tmp
> > > > 	cd /tmp
> > > > 	edquota -u foo // set the disk quota limit for user foo be m1 bytes
> > > > 	quotaon -a
> > > > 	mount -t ecryptfs cipher plain
> > > >
> > > > 	login the system as user foo
> > > > 	cd /tmp/plain
> > > > 	execute the following simple program
> > > >
> > > > 	int main()
> > > > 	{
> > > > 		char buf[m2]; // m2>m1
> > > > 		FILE *f =3D fopen("dummy", "w");
> > > > 		fwrite(buf, 1, m2, f);
> > > > 		sleep(60); // let the kernel thread do the write back job
> > > > 		fclose(f);
> > > > 		return 0;
> > > > 	}
> > > >
> > > > 	This program can write as much of data as it wants, provided sleep
> > > enough long time before closing the file.
> > > >
> > > >  fs/ecryptfs/crypto.c |   27 +++++++++++++++++++++++++++
> > > >  1 files changed, 27 insertions(+), 0 deletions(-)
> > > >
> > > > diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> > > > index 63ab245..2c1da29 100644
> > > > --- a/fs/ecryptfs/crypto.c
> > > > +++ b/fs/ecryptfs/crypto.c
> > > > @@ -457,6 +457,7 @@ int ecryptfs_encrypt_page(struct page *page)
> > > >  	struct page *enc_extent_page =3D NULL;
> > > >  	loff_t extent_offset;
> > > >  	int rc =3D 0;
> > > > +	struct cred *cred;
> > > >
> > > >  	ecryptfs_inode =3D page->mapping->host;
> > > >  	crypt_stat =3D
> > > > @@ -487,8 +488,34 @@ int ecryptfs_encrypt_page(struct page *page)
> > > >  				   * (PAGE_CACHE_SIZE
> > > >  				      / crypt_stat->extent_size))
> > > >  				  + extent_offset), crypt_stat);
> > > > +		if (current->flags & PF_KTHREAD) {
> > > > +			/*
> > > > +                         * Temporarily remove the
> > > CAP_SYS_RESOURCE capability
> > > > +                         * from the write back kernel thread to le=
t it
> > > undergo
> > > > +                         * quota check by the lower file system
> > > > +                         */
> > > > +			cred =3D prepare_creds();
> > > > +			if (unlikely(!cred)) {
> > > > +				rc =3D -ENOMEM;
> > > > +				goto out;
> > > > +			}
> > > > +			cap_lower(cred->cap_effective, CAP_SYS_RESOURCE);
> > > > +			commit_creds(cred);
> > > > +		}
> > > >  		rc =3D ecryptfs_write_lower(ecryptfs_inode, enc_extent_virt,
> > > >  					  offset, crypt_stat->extent_size);
> > > > +		if (current->flags & PF_KTHREAD) {
> > > > +			/*
> > > > +                         * Reassign the CAP_SYS_RESOURCE
> > > capability
> > > > +                         */
> > > > +			cred =3D prepare_creds();
> > > > +			if (unlikely(!cred)) {
> > > > +				rc =3D -ENOMEM;
> > > > +				goto out;
> > > > +			}
> > > > +			cap_raise(cred->cap_effective, CAP_SYS_RESOURCE);
> > > > +			commit_creds(cred);
> > > > +		}
> > > >  		if (rc < 0) {
> > > >  			ecryptfs_printk(KERN_ERR, "Error attempting "
> > > >  					"to write lower page; rc =3D [%d]"
> > > > --
> > > > 1.7.6.5
> > > --
> > > Jan Kara <jack@suse.cz>
> > > SUSE Labs, CR
> >=20



--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPNXL2AAoJENaSAD2qAscKM5gP/0xgOUD6+J8kgnT715O6OAQT
3ZHpEBqt+hDFpX+ZZKkDT415epqznc4MAhjWJlB8fnD1RDLC5WIksK+gzF4eab9s
cfC6PC+v+UFFywGg5kKuD5VdAvXdGCkF+DlatpWj4+3r34G5C4IxDAy2K/OVRBAQ
vYVgdBoNQdbUqRVG2B54C6cVmp8XtsD4NOM+89jObFEg3NrzBYqGtTxfuAXgJAkw
d1tcYbDw3i862uIdqxeBSrv4KnhL2WMO7Qi95oX3tGvYjuGnMppvT9sm4oBL1Gqw
9t16oOgINg3wI6vpr5M3S6FtqLcu6omXlqq+5A/7rLD46DWqLxIZPyDFZNxhDtWp
cbdOdnoKj2KyU072L9SMfhSiwZv93Dh6zwSnP3ywav1jPC/fKP8DbH/CvFJ7o6C5
cXGdqcXCTZfqXyaDt1EO99UbxRqZscpioKNfkxTPk490aCe53gjCSnqRBmPtGlRT
4G4oo1b7oE4XcXfDZf8PRJvnpPob4Yr0aBcjTev19W6kmK5H31oU0V+jDKHvmCyz
kOXOy/X0I3okVjHLr2mpEQjYxd+kgUi/g2bAIkM5DYcCuJXFJ/RhI2as2PeDf90l
d4mERyd1lEOof7r3J0yPpB5KnNInQH3EmpnOVBMZ/8AdFP6tRI6MgDW+IAd/KtYl
x7vzhLtj6LNc/765UJg/
=isQ4
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--
