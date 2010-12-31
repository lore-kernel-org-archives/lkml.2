Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750976Ab0LaAIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 19:08:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34066 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab0LaAIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 19:08:04 -0500
Date: Fri, 31 Dec 2010 11:07:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the vfs-scale tree with Linus' tree
Message-Id: <20101231110753.1257bef3.sfr@canb.auug.org.au>
In-Reply-To: <20101231105432.ee0a7488.sfr@canb.auug.org.au>
References: <20101231105432.ee0a7488.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__31_Dec_2010_11_07_53_+1100_7hkqvTPOeGcWba/M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__31_Dec_2010_11_07_53_+1100_7hkqvTPOeGcWba/M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[cc'ing Christoph properly this time.  The author field in the commit in
Liunus' tree has an unqualified email address which I copy-and-pasted ...]

On Fri, 31 Dec 2010 10:54:32 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the vfs-scale tree got a conflict in
> Documentation/filesystems/Locking between commit
> b83be6f20a0e468f715b14225c9f897538dfe5ad ("update
> Documentation/filesystems/Locking") from Linus' tree and various commits
> from the vfs-scale tree.
>=20
> I fixed it up (as best I could - see below) and can carry the fix as
> necessary.
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc Documentation/filesystems/Locking
> index 7686e76,c1a7e72..0000000
> --- a/Documentation/filesystems/Locking
> +++ b/Documentation/filesystems/Locking
> @@@ -18,13 -22,15 +22,14 @@@ prototypes
>   	char *(*d_dname)((struct dentry *dentry, char *buffer, int buflen);
>  =20
>   locking rules:
> - 		dcache_lock	rename_lock	->d_lock	may block
> - d_revalidate:	no		no		no		yes
> - d_hash		no		no		no		yes
> - d_compare:	no		yes		no		no=20
> - d_delete:	yes		no		yes		no
> - d_release:	no		no		no		yes
> - d_iput:		no		no		no		yes
>  -	none have BKL
> + 		rename_lock	->d_lock	may block	rcu-walk
> + d_revalidate:	no		no		yes		no
> + d_revalidate_rcu:no		no		yes (ref-walk)	maybe
> + d_hash		no		no		no		maybe
> + d_compare:	yes		no		no		maybe
> + d_delete:	no		yes		no		no
> + d_release:	no		no		yes		no
> + d_iput:		no		no		yes		no
>   d_dname:	no		no		no		no
>  =20
>   --------------------------- inode_operations --------------------------=
-=20
> @@@ -41,11 -47,12 +46,13 @@@ ata *)
>   	int (*rename) (struct inode *, struct dentry *,
>   			struct inode *, struct dentry *);
>   	int (*readlink) (struct dentry *, char __user *,int);
>  -	int (*follow_link) (struct dentry *, struct nameidata *);
>  +	void * (*follow_link) (struct dentry *, struct nameidata *);
>  +	void (*put_link) (struct dentry *, struct nameidata *, void *);
>   	void (*truncate) (struct inode *);
> - 	int (*permission) (struct inode *, int, struct nameidata *);
> + 	int (*permission) (struct inode *, int);
> + 	int (*permission_rcu) (struct inode *, int, unsigned int);
>   	int (*check_acl)(struct inode *, int);
> + 	int (*check_acl_rcu)(struct inode *, int, unsigned int);
>   	int (*setattr) (struct dentry *, struct iattr *);
>   	int (*getattr) (struct vfsmount *, struct dentry *, struct kstat *);
>   	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int=
);
> @@@ -74,7 -77,7 +81,8 @@@ put_link:	n
>   truncate:	yes		(see below)
>   setattr:	yes
>   permission:	no
> + permission_rcu: no (may not block if called in rcu-walk mode)
>  +check_acl:	no
>   getattr:	no
>   setxattr:	yes
>   getxattr:	no


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__31_Dec_2010_11_07_53_+1100_7hkqvTPOeGcWba/M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNHR7ZAAoJEDMEi1NhKgbs2YgIAJu6Ux4Ogf7opH/nOji2n9b+
PSIvbZ22PgIXVfBk80be+pPyleqNLQqK6Yx2iLhp+GV5Phy99yvLz2xvPRdumN61
t9uAaPkqXrwJ1twZinBfoQ0WUTkPuRVnUXHurd59dnSP7f2rHyHhs7jqrzxE4kDy
I45eLOmG5d0ck9zd41u1ZrGLF2fDxtX56LkcvSPeS6zdYmIR/ewVfBLbFAi79/2P
CGKmf0RlTDw1gRQyogqV5XaXzVaBlpkY8modMxVolbm73EdRBDs6+ZpIYrLMS6JR
krnkcIAkFrlmUu3Fe6VI8Yotu3sGB46DZACyxX3MIUSpOq3qwXSRHFzII3Rairs=
=mCwF
-----END PGP SIGNATURE-----

--Signature=_Fri__31_Dec_2010_11_07_53_+1100_7hkqvTPOeGcWba/M--
