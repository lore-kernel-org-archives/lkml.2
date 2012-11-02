Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2KBOgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:36:36 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:46561 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2KBOge (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 2 Nov 2012 10:36:34 -0400
Message-Id: <5093E8A902000078000A61A7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Nov 2012 14:37:13 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] xen-pciback: reject out of range inputs
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartF8C93689.2__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartF8C93689.2__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This add checks for out of range numbers (including in cases where the
folding of slot and function into a single value could yield false
matches).

It also removes the bogus field width restrictions in str_to_quirk() -
nowhere else in the driver this is being done, and hence this function
could reject input the equivalent of which would be happily accepted
in other places (in particular, "0x" prefixes causing the effective
width of the actual number to be either zero or less than what would be
required to cover the full range of valid values). Note that for the
moment this second part is cosmetic only, as the kernel's sscanf()
currently ignores the field widths, but a patch to overcome this is on
its way.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/xen/xen-pciback/pci_stub.c |   39 +++++++++++++++++++++++++-------=
-----
 1 file changed, 27 insertions(+), 12 deletions(-)

--- 3.7-rc3-xen-pciback.orig/drivers/xen/xen-pciback/pci_stub.c
+++ 3.7-rc3-xen-pciback/drivers/xen/xen-pciback/pci_stub.c
@@ -142,7 +142,8 @@ static struct pcistub_device *pcistub_de
 		if (psdev->dev !=3D NULL
 		    && domain =3D=3D pci_domain_nr(psdev->dev->bus)
 		    && bus =3D=3D psdev->dev->bus->number
-		    && PCI_DEVFN(slot, func) =3D=3D psdev->dev->devfn) {
+		    && slot =3D=3D PCI_SLOT(psdev->dev->devfn)
+		    && func =3D=3D PCI_FUNC(psdev->dev->devfn)) {
 			pcistub_device_get(psdev);
 			goto out;
 		}
@@ -191,7 +192,8 @@ struct pci_dev *pcistub_get_pci_dev_by_s
 		if (psdev->dev !=3D NULL
 		    && domain =3D=3D pci_domain_nr(psdev->dev->bus)
 		    && bus =3D=3D psdev->dev->bus->number
-		    && PCI_DEVFN(slot, func) =3D=3D psdev->dev->devfn) {
+		    && slot =3D=3D PCI_SLOT(psdev->dev->devfn)
+		    && func =3D=3D PCI_FUNC(psdev->dev->devfn)) {
 			found_dev =3D pcistub_device_get_pci_dev(pdev, =
psdev);
 			break;
 		}
@@ -936,14 +938,14 @@ static inline int str_to_quirk(const cha
 {
 	int parsed =3D 0;
=20
-	sscanf(buf, " %4x:%2x:%2x.%d-%8x:%1x:%8x %n", domain, bus, slot, =
func,
+	sscanf(buf, " %x:%x:%x.%x-%x:%x:%x %n", domain, bus, slot, func,
 	       reg, size, mask, &parsed);
 	if (parsed && !buf[parsed])
 		return 0;
=20
 	/* try again without domain */
 	*domain =3D 0;
-	sscanf(buf, " %2x:%2x.%d-%8x:%1x:%8x %n", bus, slot, func, reg, =
size,
+	sscanf(buf, " %x:%x.%x-%x:%x:%x %n", bus, slot, func, reg, size,
 	       mask, &parsed);
 	if (parsed && !buf[parsed])
 		return 0;
@@ -955,7 +957,7 @@ static int pcistub_device_id_add(int dom
 {
 	struct pcistub_device_id *pci_dev_id;
 	unsigned long flags;
-	int rc =3D 0;
+	int rc =3D 0, devfn =3D PCI_DEVFN(slot, func);
=20
 	if (slot < 0) {
 		for (slot =3D 0; !rc && slot < 32; ++slot)
@@ -969,13 +971,24 @@ static int pcistub_device_id_add(int dom
 		return rc;
 	}
=20
+	if ((
+#if !defined(MODULE) /* pci_domains_supported is not being exported */ \
+    || !defined(CONFIG_PCI_DOMAINS)
+	     !pci_domains_supported ? domain :
+#endif
+	     domain < 0 || domain > 0xffff)
+	    || bus < 0 || bus > 0xff
+	    || PCI_SLOT(devfn) !=3D slot
+	    || PCI_FUNC(devfn) !=3D func)
+		return -EINVAL;
+
 	pci_dev_id =3D kmalloc(sizeof(*pci_dev_id), GFP_KERNEL);
 	if (!pci_dev_id)
 		return -ENOMEM;
=20
 	pci_dev_id->domain =3D domain;
 	pci_dev_id->bus =3D bus;
-	pci_dev_id->devfn =3D PCI_DEVFN(slot, func);
+	pci_dev_id->devfn =3D devfn;
=20
 	pr_debug(DRV_NAME ": wants to seize %04x:%02x:%02x.%d\n",
 		 domain, bus, slot, func);
@@ -1016,14 +1029,18 @@ static int pcistub_device_id_remove(int
 	return err;
 }
=20
-static int pcistub_reg_add(int domain, int bus, int slot, int func, int =
reg,
-			   int size, int mask)
+static int pcistub_reg_add(int domain, int bus, int slot, int func,
+			   unsigned int reg, unsigned int size,
+			   unsigned int mask)
 {
 	int err =3D 0;
 	struct pcistub_device *psdev;
 	struct pci_dev *dev;
 	struct config_field *field;
=20
+	if (reg > 0xfff || (size < 4 && (mask >> (size * 8))))
+		return -EINVAL;
+
 	psdev =3D pcistub_device_find(domain, bus, slot, func);
 	if (!psdev) {
 		err =3D -ENODEV;
@@ -1254,13 +1271,11 @@ static ssize_t permissive_add(struct dev
 	int err;
 	struct pcistub_device *psdev;
 	struct xen_pcibk_dev_data *dev_data;
+
 	err =3D str_to_slot(buf, &domain, &bus, &slot, &func);
 	if (err)
 		goto out;
-	if (slot < 0 || func < 0) {
-		err =3D -EINVAL;
-		goto out;
-	}
+
 	psdev =3D pcistub_device_find(domain, bus, slot, func);
 	if (!psdev) {
 		err =3D -ENODEV;



--=__PartF8C93689.2__=
Content-Type: text/plain; name="linux-3.7-rc3-xen-pciback-strict.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-3.7-rc3-xen-pciback-strict.patch"

xen-pciback: reject out of range inputs=0A=0AThis add checks for out of =
range numbers (including in cases where the=0Afolding of slot and function =
into a single value could yield false=0Amatches).=0A=0AIt also removes the =
bogus field width restrictions in str_to_quirk() -=0Anowhere else in the =
driver this is being done, and hence this function=0Acould reject input =
the equivalent of which would be happily accepted=0Ain other places (in =
particular, "0x" prefixes causing the effective=0Awidth of the actual =
number to be either zero or less than what would be=0Arequired to cover =
the full range of valid values). Note that for the=0Amoment this second =
part is cosmetic only, as the kernel's sscanf()=0Acurrently ignores the =
field widths, but a patch to overcome this is on=0Aits way.=0A=0ASigned-off=
-by: Jan Beulich <jbeulich@suse.com>=0A=0A---=0A drivers/xen/xen-pciback/pc=
i_stub.c |   39 +++++++++++++++++++++++++------------=0A 1 file changed, =
27 insertions(+), 12 deletions(-)=0A=0A--- 3.7-rc3-xen-pciback.orig/drivers=
/xen/xen-pciback/pci_stub.c=0A+++ 3.7-rc3-xen-pciback/drivers/xen/xen-pciba=
ck/pci_stub.c=0A@@ -142,7 +142,8 @@ static struct pcistub_device *pcistub_d=
e=0A 		if (psdev->dev !=3D NULL=0A 		    && domain =
=3D=3D pci_domain_nr(psdev->dev->bus)=0A 		    && bus =3D=3D =
psdev->dev->bus->number=0A-		    && PCI_DEVFN(slot, func) =
=3D=3D psdev->dev->devfn) {=0A+		    && slot =3D=3D PCI_SLOT(psdev->=
dev->devfn)=0A+		    && func =3D=3D PCI_FUNC(psdev->dev->devfn)) =
{=0A 			pcistub_device_get(psdev);=0A 			=
goto out;=0A 		}=0A@@ -191,7 +192,8 @@ struct pci_dev *pcistub_get=
_pci_dev_by_s=0A 		if (psdev->dev !=3D NULL=0A 		   =
 && domain =3D=3D pci_domain_nr(psdev->dev->bus)=0A 		    && bus =
=3D=3D psdev->dev->bus->number=0A-		    && PCI_DEVFN(slot, =
func) =3D=3D psdev->dev->devfn) {=0A+		    && slot =3D=3D =
PCI_SLOT(psdev->dev->devfn)=0A+		    && func =3D=3D PCI_FUNC(psdev->=
dev->devfn)) {=0A 			found_dev =3D pcistub_device_get_pc=
i_dev(pdev, psdev);=0A 			break;=0A 		}=0A@@ =
-936,14 +938,14 @@ static inline int str_to_quirk(const cha=0A {=0A 	=
int parsed =3D 0;=0A =0A-	sscanf(buf, " %4x:%2x:%2x.%d-%8x:%1x:%8x =
%n", domain, bus, slot, func,=0A+	sscanf(buf, " %x:%x:%x.%x-%x:%x:%x =
%n", domain, bus, slot, func,=0A 	       reg, size, mask, =
&parsed);=0A 	if (parsed && !buf[parsed])=0A 		return 0;=0A =0A 	=
/* try again without domain */=0A 	*domain =3D 0;=0A-	sscanf(buf,=
 " %2x:%2x.%d-%8x:%1x:%8x %n", bus, slot, func, reg, size,=0A+	sscanf(buf,=
 " %x:%x.%x-%x:%x:%x %n", bus, slot, func, reg, size,=0A 	       =
mask, &parsed);=0A 	if (parsed && !buf[parsed])=0A 		return =
0;=0A@@ -955,7 +957,7 @@ static int pcistub_device_id_add(int dom=0A {=0A 	=
struct pcistub_device_id *pci_dev_id;=0A 	unsigned long flags;=0A-	=
int rc =3D 0;=0A+	int rc =3D 0, devfn =3D PCI_DEVFN(slot, func);=0A =
=0A 	if (slot < 0) {=0A 		for (slot =3D 0; !rc && slot < 32; =
++slot)=0A@@ -969,13 +971,24 @@ static int pcistub_device_id_add(int =
dom=0A 		return rc;=0A 	}=0A =0A+	if ((=0A+#if !defined(MODUL=
E) /* pci_domains_supported is not being exported */ \=0A+    || !defined(C=
ONFIG_PCI_DOMAINS)=0A+	     !pci_domains_supported ? domain :=0A+#endif=0A=
+	     domain < 0 || domain > 0xffff)=0A+	    || bus < 0 || bus > =
0xff=0A+	    || PCI_SLOT(devfn) !=3D slot=0A+	    || PCI_FUNC(dev=
fn) !=3D func)=0A+		return -EINVAL;=0A+=0A 	pci_dev_id =3D =
kmalloc(sizeof(*pci_dev_id), GFP_KERNEL);=0A 	if (!pci_dev_id)=0A 		=
return -ENOMEM;=0A =0A 	pci_dev_id->domain =3D domain;=0A 	pci_dev_id-=
>bus =3D bus;=0A-	pci_dev_id->devfn =3D PCI_DEVFN(slot, func);=0A+	=
pci_dev_id->devfn =3D devfn;=0A =0A 	pr_debug(DRV_NAME ": wants to =
seize %04x:%02x:%02x.%d\n",=0A 		 domain, bus, slot, func);=0A@@ =
-1016,14 +1029,18 @@ static int pcistub_device_id_remove(int=0A 	=
return err;=0A }=0A =0A-static int pcistub_reg_add(int domain, int bus, =
int slot, int func, int reg,=0A-			   int size, int =
mask)=0A+static int pcistub_reg_add(int domain, int bus, int slot, int =
func,=0A+			   unsigned int reg, unsigned int =
size,=0A+			   unsigned int mask)=0A {=0A 	int err =
=3D 0;=0A 	struct pcistub_device *psdev;=0A 	struct pci_dev =
*dev;=0A 	struct config_field *field;=0A =0A+	if (reg > 0xfff || =
(size < 4 && (mask >> (size * 8))))=0A+		return -EINVAL;=0A+=0A 	=
psdev =3D pcistub_device_find(domain, bus, slot, func);=0A 	if =
(!psdev) {=0A 		err =3D -ENODEV;=0A@@ -1254,13 +1271,11 @@ static =
ssize_t permissive_add(struct dev=0A 	int err;=0A 	struct pcistub_devi=
ce *psdev;=0A 	struct xen_pcibk_dev_data *dev_data;=0A+=0A 	err =3D =
str_to_slot(buf, &domain, &bus, &slot, &func);=0A 	if (err)=0A 		=
goto out;=0A-	if (slot < 0 || func < 0) {=0A-		err =3D -EINVAL;=0A=
-		goto out;=0A-	}=0A+=0A 	psdev =3D pcistub_device_fi=
nd(domain, bus, slot, func);=0A 	if (!psdev) {=0A 		=
err =3D -ENODEV;=0A
--=__PartF8C93689.2__=--
