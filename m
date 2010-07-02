Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab0GBIQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 04:16:22 -0400
Received: from coyote.quickmin.net ([217.14.112.24]:60537 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab0GBIQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 04:16:18 -0400
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=hH3tSqRmH73DjXz5kfc4L0J4bU/CxTIrtjb7b8d8xr2lOQC8hvPCF3Yvhpkq2nSkJsaQBn2i1QYjSEkolhmGsCyMhVbOAuyWMpJSmTu0kgt3dojfzzADkHevWxfWX+leOQiQ1qDGsSB7nQhVvJ4uxQ3VFArNgbN2/BEDcZz6cS8=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] dynamic_debug: parse module parameters to enable dynamic printk at load time
User-Agent: KMail/1.13.5 (Linux/2.6.31.12-0.2-default; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201005261425.39058.roman.fietze@telemotive.de> <201006291325.29983.roman.fietze@telemotive.de> <20100701204318.GG2829@redhat.com>
In-Reply-To: <20100701204318.GG2829@redhat.com>
MIME-Version: 1.0
Message-ID: <201007021016.12057.roman.fietze@telemotive.de>
Date: Fri, 2 Jul 2010 10:16:11 +0200
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 02.07.2010 10:16:12,
	Serialize by Router on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 02.07.2010 10:16:14,
	Serialize complete at 02.07.2010 10:16:14
Content-Transfer-Encoding: 7bit
Content-Type: multipart/signed;
  boundary="nextPart1833459.m1uYjFGn50";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1833459.m1uYjFGn50
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello Jason, hello LKML,

On Thursday 01 July 2010 22:43:19 Jason Baron wrote:

> make sense.
> ...
> I would keep as simple as possible for now.

So here we go with a first proposal. I think this can be just a base
for discussions, because I'm not yet used to tweak around in the guts
of the kernel itself, so there must be better solutions compared to
what I can offer here.

BTW, I had to move the ddebug setup below the parameter parsing and
setup, just in case somebody is wondering.

=46rom 7ae21e5fc935e6aef4801e0ebce1886bdd2a7b74 Mon Sep 17 00:00:00 2001
=46rom: Roman Fietze <roman.fietze@telemotive.de>
Date: Fri, 2 Jul 2010 10:06:20 +0200
Subject: [PATCH] dynamic_debug: parse module parameters to enable dynamic=20
printk at load time

When a module is loaded do an additional check for a module parameter
named "dprintk" of type bool or int. If this paremeter is unequal to 0
then set the dynamic debug print flag right at load time.

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
=2D--
 include/linux/dynamic_debug.h |    2 +-
 kernel/module.c               |   50 +++++++++++++++++++++++++++++++------=
=2D--
 lib/dynamic_debug.c           |   27 +++++++++++++++++++--
 3 files changed, 63 insertions(+), 16 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index f8c2e17..1b790a7 100644
=2D-- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -37,7 +37,7 @@ struct _ddebug {
=20
=20
 int ddebug_add_module(struct _ddebug *tab, unsigned int n,
=2D				const char *modname);
+				const char *modname, bool p_flag);
=20
 #if defined(CONFIG_DYNAMIC_DEBUG)
 extern int ddebug_remove_module(char *mod_name);
diff --git a/kernel/module.c b/kernel/module.c
index 1016b75..58b4713 100644
=2D-- a/kernel/module.c
+++ b/kernel/module.c
@@ -1954,10 +1954,35 @@ static inline void add_kallsyms(struct module *mod,
 }
 #endif /* CONFIG_KALLSYMS */
=20
=2Dstatic void dynamic_debug_setup(struct _ddebug *debug, unsigned int num)
+static void dynamic_debug_setup(struct _ddebug *debug,
+				unsigned int num_debug,
+				struct kernel_param *params,
+				unsigned int num_kp)
 {
 #ifdef CONFIG_DYNAMIC_DEBUG
=2D	if (ddebug_add_module(debug, num, debug->modname))
+	bool p_flag =3D 0;
+
+	while (num_kp--) {
+		if (!strcmp("dprintk", params->name)) {
+			if (params->get =3D=3D param_get_bool) {
+				if (params->flags & KPARAM_ISBOOL)
+					p_flag =3D *(bool *)params->arg;
+				else
+					p_flag =3D *(int *)params->arg;
+			}
+			else if (params->get =3D=3D param_get_int) {
+				p_flag =3D *((int *)params->arg);
+			}
+			else {
+				pr_err("invalid type of dprintk module "
+				       "parameter adding module: %s\n",
+				       debug->modname);
+			}
+			break;
+		}
+		params++;
+	}
+	if (ddebug_add_module(debug, num_debug, debug->modname, p_flag))
 		printk(KERN_ERR "dynamic debug error adding module: %s\n",
 					debug->modname);
 #endif
@@ -2387,16 +2412,6 @@ static noinline struct module *load_module(void __us=
er=20
*umod,
 	kfree(strmap);
 	strmap =3D NULL;
=20
=2D	if (!mod->taints) {
=2D		struct _ddebug *debug;
=2D		unsigned int num_debug;
=2D
=2D		debug =3D section_objs(hdr, sechdrs, secstrings, "__verbose",
=2D				     sizeof(*debug), &num_debug);
=2D		if (debug)
=2D			dynamic_debug_setup(debug, num_debug);
=2D	}
=2D
 	err =3D module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
@@ -2443,6 +2458,17 @@ static noinline struct module *load_module(void __us=
er=20
*umod,
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
=20
+	if (!mod->taints) {
+		struct _ddebug *debug;
+		unsigned int num_debug;
+
+		debug =3D section_objs(hdr, sechdrs, secstrings, "__verbose",
+				     sizeof(*debug), &num_debug);
+		if (debug)
+			dynamic_debug_setup(debug, num_debug,
+					    mod->kp, mod->num_kp);
+	}
+
 	/* Get rid of temporary copy */
 	vfree(hdr);
=20
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index d6b8b9b..2ea876b 100644
=2D-- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -652,7 +652,7 @@ static const struct file_operations ddebug_proc_fops =
=3D {
  * and add it to the global list.
  */
 int ddebug_add_module(struct _ddebug *tab, unsigned int n,
=2D			     const char *name)
+		      const char *name, bool p_flag)
 {
 	struct ddebug_table *dt;
 	char *new_name;
@@ -671,6 +671,26 @@ int ddebug_add_module(struct _ddebug *tab, unsigned in=
t=20
n,
 	dt->ddebugs =3D tab;
=20
 	mutex_lock(&ddebug_lock);
+	if (p_flag) {
+		struct _ddebug *dp =3D dt->ddebugs;
+		size_t i =3D dt->num_ddebugs;
+		while (i--) {
+			dp->flags |=3D _DPRINTK_FLAGS_PRINT;
+			dt->num_enabled++;
+			dynamic_debug_enabled |=3D (1LL << dp->primary_hash);
+			dynamic_debug_enabled2 |=3D (1LL << dp->secondary_hash);
+			if (verbose) {
+				char flagbuf[8];
+				printk(KERN_INFO
+				       "ddebug: added %s:%d [%s]%s %s\n",
+				       dp->filename, dp->lineno,
+				       dt->mod_name, dp->function,
+				       ddebug_describe_flags(dp, flagbuf,
+							    =20
sizeof(flagbuf)));
+			}
+			dp++;
+		}
+	}
 	list_add_tail(&dt->link, &ddebug_tables);
 	mutex_unlock(&ddebug_lock);
=20
@@ -748,7 +768,8 @@ static int __init dynamic_debug_init(void)
 		iter_start =3D iter;
 		for (; iter < __stop___verbose; iter++) {
 			if (strcmp(modname, iter->modname)) {
=2D				ret =3D ddebug_add_module(iter_start, n,=20
modname);
+				ret =3D ddebug_add_module(iter_start, n,=20
modname,
+							0);
 				if (ret)
 					goto out_free;
 				n =3D 0;
@@ -757,7 +778,7 @@ static int __init dynamic_debug_init(void)
 			}
 			n++;
 		}
=2D		ret =3D ddebug_add_module(iter_start, n, modname);
+		ret =3D ddebug_add_module(iter_start, n, modname, 0);
 	}
 out_free:
 	if (ret) {
=2D-=20
1.7.1




Roman

=2D-=20
Roman Fietze                Telemotive AG B=FCro M=FChlhausen
Breitwiesen                              73347 M=FChlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de

Amtsgericht Ulm                                HRB 541321
Vorstand:
Peter Kersten, Markus Fischer, Franz Diller, Markus Stolz

--nextPart1833459.m1uYjFGn50
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkwtoEwACgkQp5XY/BK//MLpvACfTtBeW4sXVzDLvcdBGlp8bycT
nDEAn27DGbms8NJsi2EYaUGby6HWGcy5
=thVx
-----END PGP SIGNATURE-----

--nextPart1833459.m1uYjFGn50--
