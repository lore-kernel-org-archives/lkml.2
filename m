Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab2GJItQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 04:49:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:23168 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab2GJItO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 04:49:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="169720117"
Date: Tue, 10 Jul 2012 11:50:34 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Doug Ledford <dledford@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RFC, PATCH] CLONE_NEWIPC and exit_group()
Message-ID: <20120710085034.GA24645@otc-wbsnb-06>
References: <20120626120425.GA10275@otc-wbsnb-06>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <20120626120425.GA10275@otc-wbsnb-06>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 26, 2012 at 03:04:25PM +0300, Kirill A. Shutemov wrote:
> Hi,
>=20
> Patch to move kern_unmount() out of exit_group() code path is below.

Andrew, do you have any opinion about the patch?

> Dmitry, could you check if it's beneficial for your use-case?
>=20
> Results are not that impressive. Microbenchmark:
>=20
> #define _GNU_SOURCE
> #include <unistd.h>
> #include <sched.h>
> #include <stdlib.h>
> #include <sys/types.h>
> #include <sys/wait.h>
>=20
> int main(int argc, char *argv[])
> {
>         int i;
>=20
>         for (i =3D 0; i < 1000; i++) {
>                 if (fork())
>                         continue;
>=20
>                 unshare(CLONE_NEWIPC);
>                 exit(0);
>         }
>=20
>         while (wait(NULL) > 0)
>                 ;
>=20
>         return 0;
> }
>=20
> Before:
>=20
>  Performance counter stats for './test' (10 runs):
>=20
>        2645.849247 task-clock                #    3.203 CPUs utilized    =
        ( +-  3.43% )
>              2,375 context-switches          #    0.001 M/sec            =
        ( +-  0.35% )
>              1,579 CPU-migrations            #    0.001 M/sec            =
        ( +-  0.90% )
>             37,516 page-faults               #    0.014 M/sec            =
        ( +-  0.44% )
>      5,739,887,800 cycles                    #    2.169 GHz              =
        ( +-  3.50% ) [84.21%]
>      5,126,092,712 stalled-cycles-frontend   #   89.31% frontend cycles i=
dle     ( +-  3.78% ) [84.47%]
>      3,779,607,146 stalled-cycles-backend    #   65.85% backend  cycles i=
dle     ( +-  4.06% ) [68.26%]
>      1,210,768,660 instructions              #    0.21  insns per cycle
>                                              #    4.23  stalled cycles pe=
r insn  ( +-  1.01% ) [86.28%]
>        213,318,802 branches                  #   80.624 M/sec            =
        ( +-  1.16% ) [84.49%]
>          2,417,038 branch-misses             #    1.13% of all branches  =
        ( +-  0.70% ) [84.55%]
>=20
>        0.826165497 seconds time elapsed                                  =
        ( +-  1.26% )
>=20
> After:
>=20
>  Performance counter stats for './test' (10 runs):
>=20
>        4248.846649 task-clock                #    6.370 CPUs utilized    =
        ( +- 13.50% )
>              2,343 context-switches          #    0.001 M/sec            =
        ( +-  1.51% )
>              1,624 CPU-migrations            #    0.000 M/sec            =
        ( +-  2.53% )
>             37,416 page-faults               #    0.009 M/sec            =
        ( +-  0.41% )
>      9,314,096,247 cycles                    #    2.192 GHz              =
        ( +- 13.64% ) [83.75%]
>      8,482,679,429 stalled-cycles-frontend   #   91.07% frontend cycles i=
dle     ( +- 14.46% ) [83.79%]
>      5,807,497,239 stalled-cycles-backend    #   62.35% backend  cycles i=
dle     ( +- 14.79% ) [67.65%]
>      1,556,594,531 instructions              #    0.17  insns per cycle
>                                              #    5.45  stalled cycles pe=
r insn  ( +-  5.41% ) [85.00%]
>        282,682,358 branches                  #   66.532 M/sec            =
        ( +-  5.56% ) [84.32%]
>          2,610,583 branch-misses             #    0.92% of all branches  =
        ( +-  4.42% ) [83.90%]
>=20
>        0.667023551 seconds time elapsed                                  =
        ( +- 12.10% )
>=20
> Any thoughts if it makes sense?
>=20
> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
> index 5499c92..1a4cfd8 100644
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -67,6 +67,8 @@ struct ipc_namespace {
> =20
>  	/* user_ns which owns the ipc ns */
>  	struct user_namespace *user_ns;
> +
> +	struct work_struct free_ns_work;
>  };
> =20
>  extern struct ipc_namespace init_ipc_ns;
> diff --git a/ipc/namespace.c b/ipc/namespace.c
> index f362298c..edbf885 100644
> --- a/ipc/namespace.c
> +++ b/ipc/namespace.c
> @@ -16,6 +16,8 @@
> =20
>  #include "util.h"
> =20
> +static void free_ns(struct work_struct *work);
> +
>  static struct ipc_namespace *create_ipc_ns(struct task_struct *tsk,
>  					   struct ipc_namespace *old_ns)
>  {
> @@ -27,6 +29,7 @@ static struct ipc_namespace *create_ipc_ns(struct task_=
struct *tsk,
>  		return ERR_PTR(-ENOMEM);
> =20
>  	atomic_set(&ns->count, 1);
> +	INIT_WORK(&ns->free_ns_work, free_ns);
>  	err =3D mq_init_ns(ns);
>  	if (err) {
>  		kfree(ns);
> @@ -116,6 +119,15 @@ static void free_ipc_ns(struct ipc_namespace *ns)
>  	kfree(ns);
>  }
> =20
> +static void free_ns(struct work_struct *work)
> +{
> +	struct ipc_namespace *ns =3D container_of(work, struct ipc_namespace,
> +			free_ns_work);
> +
> +	mq_put_mnt(ns);
> +	free_ipc_ns(ns);
> +}
> +
>  /*
>   * put_ipc_ns - drop a reference to an ipc namespace.
>   * @ns: the namespace to put
> @@ -137,8 +149,7 @@ void put_ipc_ns(struct ipc_namespace *ns)
>  	if (atomic_dec_and_lock(&ns->count, &mq_lock)) {
>  		mq_clear_sbinfo(ns);
>  		spin_unlock(&mq_lock);
> -		mq_put_mnt(ns);
> -		free_ipc_ns(ns);
> +		schedule_work(&ns->free_ns_work);
>  	}
>  }
> =20
> --=20
>  Kirill A. Shutemov



--=20
 Kirill A. Shutemov

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP++zaAAoJEAd+omnVudOMCMUQALRE4LuWW+p+0YW7ssfDybzi
sD2v9v83a/Le6GuRR22peB+1fUw87JJ9Yzg6ZS9S51ZpgoeE0HX2A+0l3gtL7APu
mq+2AFC6Ng7VYMNvvQsdRiEbMZAbKG7pTpRF79xFzWB55DqUZ35IiGJO/Y3IIwFv
vdewKj61HrIBh9av4hdVc4GWWTdo3hujn/DDQ2dYWne4MbaLkKhBlbvBfSjXbjrf
3NJvHiVFSKuR8Rw7LHS9COG21bESHWogoGbHSW13Xc6eCFou0d5ZXi7l1bYvNs+A
MlXWWb3smFcxkkL3cL7KHtCXY8XIaNj7JfY3CdAtV4HlStbNRp7BWHfSJVT24Ij5
4qSqHUjEibrQGk7aEY2K6LPEYXar5OtrCc+WZOfmLp4P0djfCNfYvLv22Pjd48UV
yl8hbeFTuylyLe418X9AJG2UAsgVZFcVNhf9twxwqJLKZzNXwUCrYqBBeIu7131R
FbLQJE/V0fGTUEVDmZ1s77lZI4Ml5xoB61MY9j+bOQtOqDDkQ4LUtVkM5PoueHzC
oA8FIlROC0cRlTZT5YpKMqDWSavs2ehBvFBcmp6/FOZf7jaZTZ6vFt38notDh5qM
ZeqJHkc+xnelU5bqmYr3y1OzRcxo7ZEF0WTac1DBhZ3R9gI1XvcTs38ZsKZHwCph
ky+TwS5GVrlpFv+DZY+W
=YGCX
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
