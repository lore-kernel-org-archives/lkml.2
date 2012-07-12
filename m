Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030672Ab2GLPG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 11:06:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:36696 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934000Ab2GLPG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:06:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="191782288"
Date: Thu, 12 Jul 2012 18:07:02 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Doug Ledford <dledford@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RFC, PATCH] CLONE_NEWIPC and exit_group()
Message-ID: <20120712150702.GA1897@otc-wbsnb-06>
References: <20120626120425.GA10275@otc-wbsnb-06>
 <20120710085034.GA24645@otc-wbsnb-06>
 <20120711152422.a1f07bd5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <20120711152422.a1f07bd5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 11, 2012 at 03:24:22PM -0700, Andrew Morton wrote:
> Am I reading that right?  1000 forks take 33 seconds, with basically
> all of it just sitting there asleep?  This look quite terrible - what
> causes this?

It seems free_nsproxy() + synchronize_rcu() are too heavy to be in
exit_group() path. Patch below helps: 8s -> ~0.5s for me.
I'll prepare cleaner patch later if the approach is good enough.

Also, I noticed that put_nsproxy() calls free_nsproxy() without
synchronize_rcu(). It looks wrong.

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index cc37a55..1d26be7 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -24,6 +24,7 @@ struct fs_struct;
  */
 struct nsproxy {
 	atomic_t count;
+	struct work_struct free_nsproxy_work;
 	struct uts_namespace *uts_ns;
 	struct ipc_namespace *ipc_ns;
 	struct mnt_namespace *mnt_ns;
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index b576f7f..63618cc 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -41,13 +41,17 @@ struct nsproxy init_nsproxy =3D {
 #endif
 };
=20
+static void free_nsproxy_synced(struct work_struct *work);
+
 static inline struct nsproxy *create_nsproxy(void)
 {
 	struct nsproxy *nsproxy;
=20
 	nsproxy =3D kmem_cache_alloc(nsproxy_cachep, GFP_KERNEL);
-	if (nsproxy)
+	if (nsproxy) {
 		atomic_set(&nsproxy->count, 1);
+		INIT_WORK(&nsproxy->free_nsproxy_work, free_nsproxy_synced);
+	}
 	return nsproxy;
 }
=20
@@ -178,6 +182,23 @@ void free_nsproxy(struct nsproxy *ns)
 	kmem_cache_free(nsproxy_cachep, ns);
 }
=20
+static void free_nsproxy_synced(struct work_struct *work)
+{
+	struct nsproxy *ns =3D container_of(work, struct nsproxy,
+			free_nsproxy_work);
+
+	/*
+	 * wait for others to get what they want from this nsproxy.
+	 *
+	 * cannot release this nsproxy via the call_rcu() since
+	 * put_mnt_ns() will want to sleep
+	 */
+	synchronize_rcu();
+
+	free_nsproxy(ns);
+}
+
+
 /*
  * Called from unshare. Unshare all the namespaces part of nsproxy.
  * On success, returns the new nsproxy.
@@ -215,16 +236,8 @@ void switch_task_namespaces(struct task_struct *p, str=
uct nsproxy *new)
=20
 	rcu_assign_pointer(p->nsproxy, new);
=20
-	if (ns && atomic_dec_and_test(&ns->count)) {
-		/*
-		 * wait for others to get what they want from this nsproxy.
-		 *
-		 * cannot release this nsproxy via the call_rcu() since
-		 * put_mnt_ns() will want to sleep
-		 */
-		synchronize_rcu();
-		free_nsproxy(ns);
-	}
+	if (ns && atomic_dec_and_test(&ns->count))
+		schedule_work(&ns->free_nsproxy_work);
 }
=20
 void exit_task_namespaces(struct task_struct *p)
--=20
 Kirill A. Shutemov

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/ugWAAoJEAd+omnVudOMZdIQAKQLnXu0vS29XPcl9AbtISUW
LMvLnYakFCxZA5maBovIs+uVloVVfmRGxAacHshXoL0UkJ4eucxEganCUUT3F3EC
a/OEvHgKNErykyFT6NLzl5Ea9SsO9b4EEPoQUlPltXAWzF3ob59AK2tenI33qhun
5rQNVe+xu1dg5SB8TTyKjLMJduKTeAQWqzynZM42bx7xQtouAn14hmWd+71nDi5t
P2v7WLBPsGNS81ajUvMnBwPba4VKQSZGnwFx04CR69P+5Nipl5/SwA2pFk/RDNLL
4W5YvaAH6tbURy6qyBFj6M61qlSPeSCg1lHhPADJ46c/BaKwJLiq/D+IqFdrmcmu
X/VN2LH42PmCSmWtrT3IKtlGmSBQIy6TMgDX1ru45PsQ+OpMh/PjPoO7JQzkzBbH
ZHR+vOBZqG3bGh5VgAjO5NZfCiacyqqcK6g4oKSI4oOZbbwOw+Qd94u0/Y2m68A+
N5zKMR0DxhYIyftD62h7YEjIOtL694MpEXCYu1HwCHk6R67jx/Uf9Yfi4FX8oAsw
kyQHlxuN8gQzxLXEGvX2PEBetwKZ2JUpprEAN/rpmMTVfn5bZvPB/dsdkb6xZQnZ
btAuWkqOI781FIOA4+ZYPGuwuvZgGY0gkvqjhhmI9S4Dq2C99uhrb/Qvx8i3GklC
xav+9J41mp2IxpjTrdqM
=JTPM
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
