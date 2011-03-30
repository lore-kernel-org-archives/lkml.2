Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab1C3RFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:05:06 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60810 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1C3RFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:05:04 -0400
Date: Wed, 30 Mar 2011 12:04:58 -0500
From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        greg@kroah.com, dhowells@redhat.com, jmorris@namei.org,
        serge.hallyn@canonical.com
Subject: Re: [PATCH] capabilites: allow the application of capability
 limits to usermode helpers
Message-ID: <20110330170458.GB7219@peq.hallyn.com>
References: <20110329211251.28682.63651.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
In-Reply-To: <20110329211251.28682.63651.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Quoting Eric Paris (eparis@redhat.com):
> There is no way to limit the capabilities of usermodehelpers. This problem
> reared its head recently when someone complained that any user with
> cap_net_admin was able to load arbitrary kernel modules, even though the =
user
> didn't have cap_sys_module.  The reason is because the actual load is don=
e by
> a usermode helper and those always have the full cap set.  This patch add=
es new
> sysctls which allow us to bound the permissions of usermode helpers.
>=20
> /proc/sys/kernel/usermodehelper/bset
> /proc/sys/kernel/usermodehelper/inheritable
>=20
> You must have CAP_SYS_MODULE  and CAP_SETPCAP to change these (changes are
> &=3D ONLY).  When the kernel launches a usermodehelper it will do so with=
 these
> as the bset and pI.
>=20
> -v2:	make globals static
> 	create spinlock to protect globals
>=20
> -v3:	require both CAP_SETPCAP and CAP_SYS_MODULE
> -v4:	fix the typo s/CAP_SET_PCAP/CAP_SETPCAP/ because I didn't commit
> Signed-off-by: Eric Paris <eparis@redhat.com>
> No-objection-from: Serge E. Hallyn <serge.hallyn@canonical.com>

Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>

thanks,
-serge

> Acked-by: David Howells <dhowells@redhat.com>
> ---
>=20
>  include/linux/kmod.h |    3 ++
>  kernel/kmod.c        |  100 ++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  kernel/sysctl.c      |    6 +++
>  3 files changed, 109 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
> index 6efd7a7..79bb98d 100644
> --- a/include/linux/kmod.h
> +++ b/include/linux/kmod.h
> @@ -24,6 +24,7 @@
>  #include <linux/errno.h>
>  #include <linux/compiler.h>
>  #include <linux/workqueue.h>
> +#include <linux/sysctl.h>
> =20
>  #define KMOD_PATH_LEN 256
> =20
> @@ -109,6 +110,8 @@ call_usermodehelper(char *path, char **argv, char **e=
nvp, enum umh_wait wait)
>  				       NULL, NULL, NULL);
>  }
> =20
> +extern struct ctl_table usermodehelper_table[];
> +
>  extern void usermodehelper_init(void);
> =20
>  extern int usermodehelper_disable(void);
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 9cd0591..06fdea2 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -25,6 +25,7 @@
>  #include <linux/kmod.h>
>  #include <linux/slab.h>
>  #include <linux/completion.h>
> +#include <linux/cred.h>
>  #include <linux/file.h>
>  #include <linux/fdtable.h>
>  #include <linux/workqueue.h>
> @@ -43,6 +44,13 @@ extern int max_threads;
> =20
>  static struct workqueue_struct *khelper_wq;
> =20
> +#define CAP_BSET	(void *)1
> +#define CAP_PI		(void *)2
> +
> +static kernel_cap_t usermodehelper_bset =3D CAP_FULL_SET;
> +static kernel_cap_t usermodehelper_inheritable =3D CAP_FULL_SET;
> +static DEFINE_SPINLOCK(umh_sysctl_lock);
> +
>  #ifdef CONFIG_MODULES
> =20
>  /*
> @@ -132,6 +140,7 @@ EXPORT_SYMBOL(__request_module);
>  static int ____call_usermodehelper(void *data)
>  {
>  	struct subprocess_info *sub_info =3D data;
> +	struct cred *new;
>  	int retval;
> =20
>  	spin_lock_irq(&current->sighand->siglock);
> @@ -153,6 +162,19 @@ static int ____call_usermodehelper(void *data)
>  			goto fail;
>  	}
> =20
> +	retval =3D -ENOMEM;
> +	new =3D prepare_kernel_cred(current);
> +	if (!new)
> +		goto fail;
> +
> +	spin_lock(&umh_sysctl_lock);
> +	new->cap_bset =3D cap_intersect(usermodehelper_bset, new->cap_bset);
> +	new->cap_inheritable =3D cap_intersect(usermodehelper_inheritable,
> +					     new->cap_inheritable);
> +	spin_unlock(&umh_sysctl_lock);
> +
> +	commit_creds(new);
> +
>  	retval =3D kernel_execve(sub_info->path,
>  			       (const char *const *)sub_info->argv,
>  			       (const char *const *)sub_info->envp);
> @@ -418,6 +440,84 @@ unlock:
>  }
>  EXPORT_SYMBOL(call_usermodehelper_exec);
> =20
> +static int proc_cap_handler(struct ctl_table *table, int write,
> +			 void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	struct ctl_table t;
> +	unsigned long cap_array[_KERNEL_CAPABILITY_U32S];
> +	kernel_cap_t new_cap;
> +	int err, i;
> +
> +	if (write && (!capable(CAP_SETPCAP) ||
> +		      !capable(CAP_SYS_MODULE)))
> +		return -EPERM;
> +
> +	/*
> +	 * convert from the global kernel_cap_t to the ulong array to print to
> +	 * userspace if this is a read.
> +	 */
> +	spin_lock(&umh_sysctl_lock);
> +	for (i =3D 0; i < _KERNEL_CAPABILITY_U32S; i++)  {
> +		if (table->data =3D=3D CAP_BSET)
> +			cap_array[i] =3D usermodehelper_bset.cap[i];
> +		else if (table->data =3D=3D CAP_PI)
> +			cap_array[i] =3D usermodehelper_inheritable.cap[i];
> +		else
> +			BUG();
> +	}
> +	spin_unlock(&umh_sysctl_lock);
> +
> +	t =3D *table;
> +	t.data =3D &cap_array;
> +
> +	/*
> +	 * actually read or write and array of ulongs from userspace.  Remember
> +	 * these are least significant 32 bits first
> +	 */
> +	err =3D proc_doulongvec_minmax(&t, write, buffer, lenp, ppos);
> +	if (err < 0)
> +		return err;
> +
> +	/*
> +	 * convert from the sysctl array of ulongs to the kernel_cap_t
> +	 * internal representation
> +	 */
> +	for (i =3D 0; i < _KERNEL_CAPABILITY_U32S; i++)
> +		new_cap.cap[i] =3D cap_array[i];
> +
> +	/*
> +	 * Drop everything not in the new_cap (but don't add things)
> +	 */
> +	spin_lock(&umh_sysctl_lock);
> +	if (write) {
> +		if (table->data =3D=3D CAP_BSET)
> +			usermodehelper_bset =3D cap_intersect(usermodehelper_bset, new_cap);
> +		if (table->data =3D=3D CAP_PI)
> +			usermodehelper_inheritable =3D cap_intersect(usermodehelper_inheritab=
le, new_cap);
> +	}
> +	spin_unlock(&umh_sysctl_lock);
> +
> +	return 0;
> +}
> +
> +struct ctl_table usermodehelper_table[] =3D {
> +	{
> +		.procname	=3D "bset",
> +		.data		=3D CAP_BSET,
> +		.maxlen		=3D _KERNEL_CAPABILITY_U32S * sizeof(unsigned long),
> +		.mode		=3D 0600,
> +		.proc_handler	=3D proc_cap_handler,
> +	},
> +	{
> +		.procname	=3D "inheritable",
> +		.data		=3D CAP_PI,
> +		.maxlen		=3D _KERNEL_CAPABILITY_U32S * sizeof(unsigned long),
> +		.mode		=3D 0600,
> +		.proc_handler	=3D proc_cap_handler,
> +	},
> +	{ }
> +};
> +
>  void __init usermodehelper_init(void)
>  {
>  	khelper_wq =3D create_singlethread_workqueue("khelper");
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index c0bb324..965134b 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -56,6 +56,7 @@
>  #include <linux/kprobes.h>
>  #include <linux/pipe_fs_i.h>
>  #include <linux/oom.h>
> +#include <linux/kmod.h>
> =20
>  #include <asm/uaccess.h>
>  #include <asm/processor.h>
> @@ -616,6 +617,11 @@ static struct ctl_table kern_table[] =3D {
>  		.child		=3D random_table,
>  	},
>  	{
> +		.procname	=3D "usermodehelper",
> +		.mode		=3D 0555,
> +		.child		=3D usermodehelper_table,
> +	},
> +	{
>  		.procname	=3D "overflowuid",
>  		.data		=3D &overflowuid,
>  		.maxlen		=3D sizeof(int),
>=20

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNk2K6AAoJEHmllQITXQdF8AgH/RDWKdOXjySrBXaCc7LQR29M
tPxdgl+/w7aKxsWF9iXxoIsMSKQXGhY1+J9QyoWpP9LWJ3njXcofZjg3x7uX94Ex
JNnCrhjMFHhI6evPz00l0jqXA5lrg/LVqaDmpoTwJs+oKNj+3kHMQtdLpMrCKqjO
RX6fNIthfYgBEdHPVN1h4nHdNurRRfsxXsrHso1Ljkc4DhaUsEKZaDRbf+mIM6zP
Z+e6a/IwsYrfJ5tbA37tppActh3tcVcIEYj31g/peeZV1L5MHlkn0jemPIWyQJ8I
zauWoBsWj5/uuIcGJ7tU6ae7iFLo1kWI1x03TwWSf6k2xeRfx3uwdf04mgrS1pY=
=40oa
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
