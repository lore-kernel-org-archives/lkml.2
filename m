Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0KIJJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:09:52 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52735 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab0KIJJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:09:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aV+cTM0GzESscAFafoyb7S12NUqH9+wm6Foq/5WHWCJFcL8/XzulGcD7K0z42tSHU2
         lUmkYaix9RmYHj3zFu3WXaJbe+CjqxHhqMZMKgOy1+ZOiADJTBBpoanbQJWlNo5GHLHP
         o3x62cIAxYQt2Deb+2xsSkIjIOtSEilgs4dsE=
Date: Tue, 9 Nov 2010 11:09:31 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, sergey.senozhatsky@gmail.com
Subject: Re: suspicious rcu_dereference_check() usage splat
Message-ID: <20101109090931.GH3971@swordfish.minsk.epam.com>
References: <20101107071414.GA3600@deepthought.bhanu.net>
 <20101107185013.GC15561@linux.vnet.ibm.com>
 <20101108153957.GA3418@deepthought.bhanu.net>
 <20101108202437.GH4032@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+Z7/5fzWRHDJ0o7Q"
Content-Disposition: inline
In-Reply-To: <20101108202437.GH4032@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+Z7/5fzWRHDJ0o7Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (11/08/10 12:24), Paul E. McKenney wrote:
> Looking over the patch again, the scope of the RCU read-side critical
> section needs to expand to cover the use of the pointer as well as the
> call to find_task_by_vpid().  So, for example:
>=20
> 		case IOPRIO_WHO_PROCESS:
> 			rcu_read_lock();
> 			if (!who)
> 				p =3D current;
> 			else
> 				p =3D find_task_by_vpid(who);
> 			if (p)
> 				ret =3D set_task_ioprio(p, ioprio);
> 			rcu_read_unlock();
> 			break;
> 		case IOPRIO_WHO_PGRP:
>=20
>=20
> Otherwise, the task could go away before the last use.
>=20
> Sergey, could you please make this change and re-post your patch?
>=20
> 							Thanx, Paul
>=20

Hello,
Should we protect set_task_ioprio? Critical operations are protected
with rcu_read_lock/rcu_read_unlock in set_task_ioprio, the rest is protected
via task_lock(task)/task_unlock(task).


	Sergey

--+Z7/5fzWRHDJ0o7Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAkzZD8sACgkQfKHnntdSXjThQwP+JG6kYPHV867PXF+WUx2nP5tK
CzafMgFIwBdWk08T2Bd3WnPaK6U7Xyb5py+GcbC8vuExAB3eBdFiYqyKt1nMRYsl
dZM8q6JXomz4yD7g4V0jHXuQwINdjje+ga4oEOxbSEy9h8AgsEhBo9Wsz1FUPh68
z7JLvsz1AGrSt9yWj5U=
=5xNs
-----END PGP SIGNATURE-----

--+Z7/5fzWRHDJ0o7Q--
