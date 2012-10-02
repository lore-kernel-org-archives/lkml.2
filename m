Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab2JBDvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 23:51:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55345 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2JBDvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 23:51:13 -0400
Date: Tue, 2 Oct 2012 13:50:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Timur Tabi <timur@freescale.com>
Subject: linux-next: manual merge of the dt-rh tree with Linus' tree
Message-Id: <20121002135059.3b97bb158fcb6417daa3a7ae@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Oct_2012_13_50_59_+1000_Tu/btOT+y/m5A2LE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Oct_2012_13_50_59_+1000_Tu/btOT+y/m5A2LE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rob,

Today's linux-next merge of the dt-rh tree got a conflict in
drivers/of/base.c include/linux/of.h between commit 3296193d1421 ("dt:
introduce for_each_available_child_of_node, of_get_next_available_child")
from Linus' tree and commit 9c19761a7ecd ("dt: introduce
of_get_child_by_name to get child node by name") from the dt-rh tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/of/base.c
index 4a8d46f,e2e8136..0000000
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@@ -364,33 -364,29 +364,56 @@@ struct device_node *of_get_next_child(c
  EXPORT_SYMBOL(of_get_next_child);
 =20
  /**
 + *	of_get_next_available_child - Find the next available child node
 + *	@node:	parent node
 + *	@prev:	previous child of the parent node, or NULL to get first
 + *
 + *      This function is like of_get_next_child(), except that it
 + *      automatically skips any disabled nodes (i.e. status =3D "disabled=
").
 + */
 +struct device_node *of_get_next_available_child(const struct device_node =
*node,
 +	struct device_node *prev)
 +{
 +	struct device_node *next;
 +
 +	read_lock(&devtree_lock);
 +	next =3D prev ? prev->sibling : node->child;
 +	for (; next; next =3D next->sibling) {
 +		if (!of_device_is_available(next))
 +			continue;
 +		if (of_node_get(next))
 +			break;
 +	}
 +	of_node_put(prev);
 +	read_unlock(&devtree_lock);
 +	return next;
 +}
 +EXPORT_SYMBOL(of_get_next_available_child);
 +
 +/**
+  *	of_get_child_by_name - Find the child node by name for a given parent
+  *	@node:	parent node
+  *	@name:	child name to look for.
+  *
+  *      This function looks for child node for given matching name
+  *
+  *	Returns a node pointer if found, with refcount incremented, use
+  *	of_node_put() on it when done.
+  *	Returns NULL if node is not found.
+  */
+ struct device_node *of_get_child_by_name(const struct device_node *node,
+ 				const char *name)
+ {
+ 	struct device_node *child;
+=20
+ 	for_each_child_of_node(node, child)
+ 		if (child->name && (of_node_cmp(child->name, name) =3D=3D 0))
+ 			break;
+ 	return child;
+ }
+ EXPORT_SYMBOL(of_get_child_by_name);
+=20
+ /**
   *	of_find_node_by_path - Find a node matching a full OF path
   *	@path:	The full path to match
   *
diff --cc include/linux/of.h
index 5c7a158,fabb524..0000000
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@@ -190,9 -190,8 +190,11 @@@ extern struct device_node *of_get_paren
  extern struct device_node *of_get_next_parent(struct device_node *node);
  extern struct device_node *of_get_next_child(const struct device_node *no=
de,
  					     struct device_node *prev);
 +extern struct device_node *of_get_next_available_child(
 +	const struct device_node *node, struct device_node *prev);
 +
+ extern struct device_node *of_get_child_by_name(const struct device_node =
*node,
+ 					const char *name);
  #define for_each_child_of_node(parent, child) \
  	for (child =3D of_get_next_child(parent, NULL); child !=3D NULL; \
  	     child =3D of_get_next_child(parent, child))

--Signature=_Tue__2_Oct_2012_13_50_59_+1000_Tu/btOT+y/m5A2LE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQamSjAAoJEECxmPOUX5FEzmYP/3WYcjzLIls+VQtTlamvM6Rk
ySfyyKeJIb16hfoKJkg+fNetpULlUj2/A6E15pcEiVX7VssgNSeKJDyXIkT5NohD
EIAQg2nKiwrrnql+jQij3MEs8utH+eAZTasfuFxPa9C5Y6msFzF1fy2Gtj9106dA
gTt2pUMxmA6q0Rad6sVI4P0QG0wah8Y1+MmdmYmkZppBrm2xwO7/QRbJRsfcvvCL
GfUpRnHkzFgVVU2s766PxbfsIN9SuYFvHy/Lt/dUKcrH44L1FBS8cx34AAk3yZGC
DyNQNrg/18J1XkCSX3/8fwtJ+YHRrv1JdIFGb4lFiZOe6hjzFZN1bO3nP9hyJQAu
7griEMnGSKKeM29miH6WM+jqI+cED2fZxpUHeTV3vj+UhgHxFLm8p/5V592xlkOt
kuwr2DBnQmgrPxKKPwLHwyLkDdkXJdS9RB4arL+EYzVToMFqb6559ImA9Z8PoSJp
kVIFrauVSwyt3fo6xvBCJuiWjs15hLI2jF9XAU8kWhJT4Wbm5EYLinrdZ1OYhEiO
0qc3rriErmtVGFaexpvmEULNXAihD1XBurHEyIy8hSYWzcG9CiDHgeFxtxcZ0gKq
4ytt+eA0yn3C/bwVNgzA83PxSOW666pfask+FwJqSc+Wub7E1hJumWQ5aNMMKYCq
e34jzL/X9hkIaE7mwtL7
=08Z+
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Oct_2012_13_50_59_+1000_Tu/btOT+y/m5A2LE--
