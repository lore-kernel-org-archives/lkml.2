Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab1BOFHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 00:07:08 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:61473 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1BOFHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 00:07:06 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: vfs-scale, d_revalidate from nfsd
To: Nick Piggin <npiggin@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTik1bj=Z9xFv8JfYrxqefFL1owmH=Rctj=XnH4Mp@mail.gmail.com>
References: <8855.1294927436@jrobl> <AANLkTik1bj=Z9xFv8JfYrxqefFL1owmH=Rctj=XnH4Mp@mail.gmail.com>
Date: Tue, 15 Feb 2011 14:07:00 +0900
Message-ID: <11234.1297746420@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nick Piggin:
> On Fri, Jan 14, 2011 at 1:03 AM, J. R. Okajima <hooanon05@yahoo.co.jp> wrot=
> e:
> > NFSD calls filesystem's ->d_revalidate() with the parameter nd =3D=3D NUL=
> L.
	:::
> Ah, good catch.
>
> I'm going to change the d_revalidate API so it takes and inode and rcu-walk
> flag parameter to make it easier for filesystems to implement rcu-walk.
>
> That will take care of this NULL nd case.

While you might already know there are similar parts in fs/namei.c, I'd
like to write here just to make sure.

- nfsd calls lookup_one_len()
- lookup_one_len()
  + __lookup_hash() with nd=NULL
    + do_revalidate(dentry, nd)
      or/and
    + d_alloc_and_lookup(base, name, nd)

- do_revalidate(dentry, nd)
  + status = d_revalidate(dentry, nd)
    + d_op->d_revalidate(dentry, nd)	<-- previous mail pointed out
  + if (status < 0) {
	if (!(nd->flags & LOOKUP_RCU))	<-- this also needs fixing
		dput(dentry);
    } else {
	if (nameidata_dentry_drop_rcu_maybe(nd, dentry)) <-- and here
		return ERR_PTR(-ECHILD);
    }

And if ->d_revalidate() can return ECHILD when 'nd' is NULL,
then nameidata_dentry_drop_rcu() call in d_revalidate() needs fixing
too.

I don't think ->lookup(inode, dentry, nd) call in d_alloc_and_lookup()
is a problem since every FS which supports NFS-exporting never refer
'nd' already.


J. R. Okajima
