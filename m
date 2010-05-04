Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab0EDBkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 21:40:53 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:37267 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0EDBkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 21:40:52 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 27/39] union-mount: In-kernel copyup routines
In-Reply-To: Your message of "Mon, 03 May 2010 16:12:26 PDT."
             <1272928358-20854-28-git-send-email-vaurora@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
            <1272928358-20854-28-git-send-email-vaurora@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1272937204_7027P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 03 May 2010 21:40:04 -0400
Message-ID: <30882.1272937204@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4BDF7AF5.01FA,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1272937204_7027P
Content-Type: text/plain; charset=us-ascii

On Mon, 03 May 2010 16:12:26 PDT, Valerie Aurora said:
> When a file on the read-only layer of a union mount is altered, it
> must be copied up to the topmost read-write layer.  This patch creates
> union_copyup() and its supporting routines.
> ---
>  fs/union.c            |  244 +++++++++++++++++++++++++++++++++++++++++++++++

> +/**
> + * union_copyup_data - Copy up len bytes of old's data to new
> + *
> + * @old: source file
> + * @new: target file
> + * @len: number of bytes to copy
> + */
> +
> +static int union_copyup_data(struct path *old, struct vfsmount *new_mnt,
> +			     struct dentry *new_dentry, size_t len)
> +{
> +	struct file *old_file;
> +	struct file *new_file;
> +	const struct cred *cred = current_cred();
> +	loff_t offset = 0;
> +	long bytes;
> +	int error;

Should this be 'int error = 0;' ?

> +
> +	if (len == 0)
> +		return 0;
> +
> +	/* Get reference to balance later fput() */
> +	path_get(old);
> +	old_file = dentry_open(old->dentry, old->mnt, O_RDONLY, cred);
> +	if (IS_ERR(old_file))
> +		return PTR_ERR(old_file);
> +
> +	dget(new_dentry);
> +	mntget(new_mnt);
> +	new_file = dentry_open(new_dentry, new_mnt, O_WRONLY, cred);
> +	if (IS_ERR(new_file)) {
> +		error = PTR_ERR(new_file);
> +		goto out_fput;
> +	}
> +
> +	bytes = do_splice_direct(old_file, &offset, new_file, len,
> +				 SPLICE_F_MOVE);
> +	if (bytes < 0)
> +		error = bytes;
> +
> +	fput(new_file);
> +out_fput:
> +	fput(old_file);
> +	return error;
> +}

because otherwise if do_splice_direct() returns a non-negative value,
we can hit 'return error;' without ever having set error to anything?


--==_Exmh_1272937204_7027P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL33r0cC3lWbTT17ARAiArAJ4v7ikspt2rATmc/R0QfacxWz3XBgCgkh4j
NuoEjs6tTGcc1+wHN6xU2/w=
=Iv4e
-----END PGP SIGNATURE-----

--==_Exmh_1272937204_7027P--

