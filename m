Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab2C2Emz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 00:42:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50282 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2C2Emt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 00:42:49 -0400
Date: Thu, 29 Mar 2012 15:42:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Neuling <mikey@neuling.org>, David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, arnd@arndb.de, hpa@zytor.com,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [GIT PULL] Disintegrate and kill asm/system.h
Message-Id: <20120329154238.1ce219f7c998da45452af4b2@canb.auug.org.au>
In-Reply-To: <CA+55aFzn=bsH76hPDUgS-FBP=RVu51gwmRdqjkw5RJO=Q_cRfA@mail.gmail.com>
References: <5599.1332958811@redhat.com>
	<30702.1332989444@neuling.org>
	<20120329135555.06593144b65bf81cc9191f8a@canb.auug.org.au>
	<20120329151544.ef2117821dfb459e8b52af48@canb.auug.org.au>
	<CA+55aFzn=bsH76hPDUgS-FBP=RVu51gwmRdqjkw5RJO=Q_cRfA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Mar_2012_15_42_38_+1100_m1HCmb3RqS76uFQa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Mar_2012_15_42_38_+1100_m1HCmb3RqS76uFQa
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Wed, 28 Mar 2012 21:24:41 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Wed, Mar 28, 2012 at 9:15 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> >
> > The following patch fixes (as much as possible) a powerpc allyesconfig =
build.
>=20
> Ugh:
>=20
> > diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> > index af48e59..1f94ddf 100644
> > --- a/kernel/irq/irqdomain.c
> > +++ b/kernel/irq/irqdomain.c
> > @@ -12,6 +12,9 @@
> > =C2=A0#include <linux/slab.h>
> > =C2=A0#include <linux/smp.h>
> > =C2=A0#include <linux/fs.h>
> > +#ifdef CONFIG_VIRQ_DEBUG
> > +#include <asm/debug.h>
> > +#endif
>=20
> Can we please move that abortion into arch/powerpc/? Instead of making
> generic code even uglier..

How about this (build tested on powerpc allyesconfig):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 29 Mar 2012 14:58:10 +1100
Subject: [PATCH] powerpc: fix fallout from system.h split up

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/kernel/fadump.c |    2 +
 arch/powerpc/kernel/irq.c    |   72 ++++++++++++++++++++++++++++++++++++++=
++++
 arch/powerpc/kernel/kgdb.c   |    1 +
 kernel/irq/irqdomain.c       |   72 --------------------------------------=
----
 4 files changed, 75 insertions(+), 72 deletions(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index cfe7a38..18bdf74 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -40,6 +40,8 @@
 #include <asm/prom.h>
 #include <asm/rtas.h>
 #include <asm/fadump.h>
+#include <asm/debug.h>
+#include <asm/setup.h>
=20
 static struct fw_dump fw_dump;
 static struct fadump_mem_struct fdm;
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 243dbab..ff165f5 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -623,3 +623,75 @@ static int __init setup_noirqdistrib(char *str)
=20
 __setup("noirqdistrib", setup_noirqdistrib);
 #endif /* CONFIG_PPC64 */
+
+#ifdef CONFIG_VIRQ_DEBUG
+static int virq_debug_show(struct seq_file *m, void *private)
+{
+	unsigned long flags;
+	struct irq_desc *desc;
+	const char *p;
+	static const char none[] =3D "none";
+	void *data;
+	int i;
+
+	seq_printf(m, "%-5s  %-7s  %-15s  %-18s  %s\n", "virq", "hwirq",
+		      "chip name", "chip data", "domain name");
+
+	for (i =3D 1; i < nr_irqs; i++) {
+		desc =3D irq_to_desc(i);
+		if (!desc)
+			continue;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+
+		if (desc->action && desc->action->handler) {
+			struct irq_chip *chip;
+
+			seq_printf(m, "%5d  ", i);
+			seq_printf(m, "0x%05lx  ", desc->irq_data.hwirq);
+
+			chip =3D irq_desc_get_chip(desc);
+			if (chip && chip->name)
+				p =3D chip->name;
+			else
+				p =3D none;
+			seq_printf(m, "%-15s  ", p);
+
+			data =3D irq_desc_get_chip_data(desc);
+			seq_printf(m, "0x%16p  ", data);
+
+			if (desc->irq_data.domain->of_node)
+				p =3D desc->irq_data.domain->of_node->full_name;
+			else
+				p =3D none;
+			seq_printf(m, "%s\n", p);
+		}
+
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
+
+	return 0;
+}
+
+static int virq_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, virq_debug_show, inode->i_private);
+}
+
+static const struct file_operations virq_debug_fops =3D {
+	.open =3D virq_debug_open,
+	.read =3D seq_read,
+	.llseek =3D seq_lseek,
+	.release =3D single_release,
+};
+
+static int __init irq_debugfs_init(void)
+{
+	if (debugfs_create_file("virq_mapping", S_IRUGO, powerpc_debugfs_root,
+				 NULL, &virq_debug_fops) =3D=3D NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+__initcall(irq_debugfs_init);
+#endif /* CONFIG_VIRQ_DEBUG */
diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 76a6e40..782bd0a 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -24,6 +24,7 @@
 #include <asm/current.h>
 #include <asm/processor.h>
 #include <asm/machdep.h>
+#include <asm/debug.h>
=20
 /*
  * This table contains the mapping between PowerPC hardware trap types, and
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index af48e59..ae645ab 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -632,78 +632,6 @@ unsigned int irq_linear_revmap(struct irq_domain *doma=
in,
 	return revmap[hwirq];
 }
=20
-#ifdef CONFIG_VIRQ_DEBUG
-static int virq_debug_show(struct seq_file *m, void *private)
-{
-	unsigned long flags;
-	struct irq_desc *desc;
-	const char *p;
-	static const char none[] =3D "none";
-	void *data;
-	int i;
-
-	seq_printf(m, "%-5s  %-7s  %-15s  %-18s  %s\n", "virq", "hwirq",
-		      "chip name", "chip data", "domain name");
-
-	for (i =3D 1; i < nr_irqs; i++) {
-		desc =3D irq_to_desc(i);
-		if (!desc)
-			continue;
-
-		raw_spin_lock_irqsave(&desc->lock, flags);
-
-		if (desc->action && desc->action->handler) {
-			struct irq_chip *chip;
-
-			seq_printf(m, "%5d  ", i);
-			seq_printf(m, "0x%05lx  ", desc->irq_data.hwirq);
-
-			chip =3D irq_desc_get_chip(desc);
-			if (chip && chip->name)
-				p =3D chip->name;
-			else
-				p =3D none;
-			seq_printf(m, "%-15s  ", p);
-
-			data =3D irq_desc_get_chip_data(desc);
-			seq_printf(m, "0x%16p  ", data);
-
-			if (desc->irq_data.domain->of_node)
-				p =3D desc->irq_data.domain->of_node->full_name;
-			else
-				p =3D none;
-			seq_printf(m, "%s\n", p);
-		}
-
-		raw_spin_unlock_irqrestore(&desc->lock, flags);
-	}
-
-	return 0;
-}
-
-static int virq_debug_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, virq_debug_show, inode->i_private);
-}
-
-static const struct file_operations virq_debug_fops =3D {
-	.open =3D virq_debug_open,
-	.read =3D seq_read,
-	.llseek =3D seq_lseek,
-	.release =3D single_release,
-};
-
-static int __init irq_debugfs_init(void)
-{
-	if (debugfs_create_file("virq_mapping", S_IRUGO, powerpc_debugfs_root,
-				 NULL, &virq_debug_fops) =3D=3D NULL)
-		return -ENOMEM;
-
-	return 0;
-}
-__initcall(irq_debugfs_init);
-#endif /* CONFIG_VIRQ_DEBUG */
-
 int irq_domain_simple_map(struct irq_domain *d, unsigned int irq,
 			  irq_hw_number_t hwirq)
 {
--=20
1.7.9.1


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__29_Mar_2012_15_42_38_+1100_m1HCmb3RqS76uFQa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPc+g+AAoJEECxmPOUX5FEKz4P/jdJEhLe8teujGtOU1zekZ73
z6dHQyQ8sCrvnBnwbn40q4R+8Wlc8Qdfs12pOs+4LWZx9pAONvYuPJsIJ0t/Ay+d
VPAWrZop7hNg3GtDZiTYRxMbapihe9UaBUL4lCCi8WoEpZPeE78Ss1CraipNapP4
KqeruGEWg63Nf0TyVEmi/oZ1yGBMBn9S25VRbGRQTitA02XrHRwzSWedFKlhHzwk
XAcW4tVPnWiNr0Jkh60EEH+6TaJyR3ul4HUifjxXCDEomAPpa5a3IwMxZ54A8HlR
Zlw8awfR3RREdFk1j0j8gmEPg5QNNxby2itLTA5jkoFB79r+aOlImYNvLuEuc8WE
M8BYmpLJlsiaAxQV6Jaqy0LKrTHqlmRo0uAqJPybfsrXgzm5bTlo97E5w696zBjC
PlBxlDB2rScAcAaoTpQugNmQ1mBks2QG5OO/XUNlR0d1l5YSFCFl4wtxNRzA4Zwp
VkDG5vGb8LEqOxWjJjsoxygb9eIkOWMODjmNBnYBoQtxlTwfs7gfd3zJjVkZkMA5
pauXOEWMt+vSWS8MUTEJxpr/6dHAxFXmgOvf2PHfSRJo7j3O5xGuqPwOGILc4StN
gH8kV/xOXKkWk7OM9TFL/NAXI8xtd2IEb9It0e/68yrE7uYF6d3NkBflKa6elQNO
Dcwb8AvxLlvJ4m4c0NIJ
=6QDL
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Mar_2012_15_42_38_+1100_m1HCmb3RqS76uFQa--
