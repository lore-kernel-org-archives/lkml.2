Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab2KBOgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:36:00 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:54237 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab2KBOf7 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 2 Nov 2012 10:35:59 -0400
Message-Id: <5093E88602000078000A61A3@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Nov 2012 14:36:38 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] xen-pciback: simplify and tighten parsing of
 device IDs
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part1726D966.2__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__Part1726D966.2__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Now that at least one of the conformance problems of the kernel's
sscanf() was addressed (commit da99075c1d368315e1508b6143226c0d27b621e0),
we can improve the parsing done in xen-pciback both in terms of code
readability and correctness (in particular properly rejecting input
strings not well formed).

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/xen/xen-pciback/pci_stub.c |   83 +++++++++++++++++---------------=
-----
 1 file changed, 39 insertions(+), 44 deletions(-)

--- 3.7-rc3-xen-pciback.orig/drivers/xen/xen-pciback/pci_stub.c
+++ 3.7-rc3-xen-pciback/drivers/xen/xen-pciback/pci_stub.c
@@ -897,42 +897,35 @@ static struct pci_driver xen_pcibk_pci_d
 static inline int str_to_slot(const char *buf, int *domain, int *bus,
 			      int *slot, int *func)
 {
-	int err;
-	char wc =3D '*';
+	int parsed =3D 0;
=20
-	err =3D sscanf(buf, " %x:%x:%x.%x", domain, bus, slot, func);
-	switch (err) {
+	switch (sscanf(buf, " %x:%x:%x.%x %n", domain, bus, slot, func,
+		       &parsed)) {
 	case 3:
 		*func =3D -1;
-		err =3D sscanf(buf, " %x:%x:%x.%c", domain, bus, slot, =
&wc);
+		sscanf(buf, " %x:%x:%x.* %n", domain, bus, slot, &parsed);
 		break;
 	case 2:
 		*slot =3D *func =3D -1;
-		err =3D sscanf(buf, " %x:%x:*.%c", domain, bus, &wc);
-		if (err >=3D 2)
-			++err;
+		sscanf(buf, " %x:%x:*.* %n", domain, bus, &parsed);
 		break;
 	}
-	if (err =3D=3D 4 && wc =3D=3D '*')
+	if (parsed && !buf[parsed])
 		return 0;
-	else if (err < 0)
-		return -EINVAL;
=20
 	/* try again without domain */
 	*domain =3D 0;
-	wc =3D '*';
-	err =3D sscanf(buf, " %x:%x.%x", bus, slot, func);
-	switch (err) {
+	switch (sscanf(buf, " %x:%x.%x %n", bus, slot, func, &parsed)) {
 	case 2:
 		*func =3D -1;
-		err =3D sscanf(buf, " %x:%x.%c", bus, slot, &wc);
+		sscanf(buf, " %x:%x.* %n", bus, slot, &parsed);
 		break;
 	case 1:
 		*slot =3D *func =3D -1;
-		err =3D sscanf(buf, " %x:*.%c", bus, &wc) + 1;
+		sscanf(buf, " %x:*.* %n", bus, &parsed);
 		break;
 	}
-	if (err =3D=3D 3 && wc =3D=3D '*')
+	if (parsed && !buf[parsed])
 		return 0;
=20
 	return -EINVAL;
@@ -941,13 +934,20 @@ static inline int str_to_slot(const char
 static inline int str_to_quirk(const char *buf, int *domain, int *bus, =
int
 			       *slot, int *func, int *reg, int *size, int =
*mask)
 {
-	int err;
+	int parsed =3D 0;
+
+	sscanf(buf, " %4x:%2x:%2x.%d-%8x:%1x:%8x %n", domain, bus, slot, =
func,
+	       reg, size, mask, &parsed);
+	if (parsed && !buf[parsed])
+		return 0;
=20
-	err =3D
-	    sscanf(buf, " %04x:%02x:%02x.%d-%08x:%1x:%08x", domain, bus, =
slot,
-		   func, reg, size, mask);
-	if (err =3D=3D 7)
+	/* try again without domain */
+	*domain =3D 0;
+	sscanf(buf, " %2x:%2x.%d-%8x:%1x:%8x %n", bus, slot, func, reg, =
size,
+	       mask, &parsed);
+	if (parsed && !buf[parsed])
 		return 0;
+
 	return -EINVAL;
 }
=20
@@ -1339,8 +1339,6 @@ static int __init pcistub_init(void)
=20
 	if (pci_devs_to_hide && *pci_devs_to_hide) {
 		do {
-			char wc =3D '*';
-
 			parsed =3D 0;
=20
 			err =3D sscanf(pci_devs_to_hide + pos,
@@ -1349,51 +1347,48 @@ static int __init pcistub_init(void)
 			switch (err) {
 			case 3:
 				func =3D -1;
-				err =3D sscanf(pci_devs_to_hide + pos,
-					     " (%x:%x:%x.%c) %n",
-					     &domain, &bus, &slot, &wc,
-					     &parsed);
+				sscanf(pci_devs_to_hide + pos,
+				       " (%x:%x:%x.*) %n",
+				       &domain, &bus, &slot, &parsed);
 				break;
 			case 2:
 				slot =3D func =3D -1;
-				err =3D sscanf(pci_devs_to_hide + pos,
-					     " (%x:%x:*.%c) %n",
-					     &domain, &bus, &wc, &parsed) =
+ 1;
+				sscanf(pci_devs_to_hide + pos,
+				       " (%x:%x:*.*) %n",
+				       &domain, &bus, &parsed);
 				break;
 			}
=20
-			if (err !=3D 4 || wc !=3D '*') {
+			if (!parsed) {
 				domain =3D 0;
-				wc =3D '*';
 				err =3D sscanf(pci_devs_to_hide + pos,
 					     " (%x:%x.%x) %n",
 					     &bus, &slot, &func, &parsed);
 				switch (err) {
 				case 2:
 					func =3D -1;
-					err =3D sscanf(pci_devs_to_hide + =
pos,
-						     " (%x:%x.%c) %n",
-						     &bus, &slot, &wc,
-						     &parsed);
+					sscanf(pci_devs_to_hide + pos,
+					       " (%x:%x.*) %n",
+					       &bus, &slot, &parsed);
 					break;
 				case 1:
 					slot =3D func =3D -1;
-					err =3D sscanf(pci_devs_to_hide + =
pos,
-						     " (%x:*.%c) %n",
-						     &bus, &wc, &parsed) + =
1;
+					sscanf(pci_devs_to_hide + pos,
+					       " (%x:*.*) %n",
+					       &bus, &parsed);
 					break;
 				}
-				if (err !=3D 3 || wc !=3D '*')
-					goto parse_error;
 			}
=20
+			if (parsed <=3D 0)
+				goto parse_error;
+
 			err =3D pcistub_device_id_add(domain, bus, slot, =
func);
 			if (err)
 				goto out;
=20
-			/* if parsed<=3D0, we've reached the end of the =
string */
 			pos +=3D parsed;
-		} while (parsed > 0 && pci_devs_to_hide[pos]);
+		} while (pci_devs_to_hide[pos]);
 	}
=20
 	/* If we're the first PCI Device Driver to register, we're the



--=__Part1726D966.2__=
Content-Type: text/plain; name="linux-3.7-rc3-xen-pciback-parse.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-3.7-rc3-xen-pciback-parse.patch"

xen-pciback: simplify and tighten parsing of device IDs=0A=0ANow that at =
least one of the conformance problems of the kernel's=0Asscanf() was =
addressed (commit da99075c1d368315e1508b6143226c0d27b621e0),=0Awe can =
improve the parsing done in xen-pciback both in terms of code=0Areadability=
 and correctness (in particular properly rejecting input=0Astrings not =
well formed).=0A=0ASigned-off-by: Jan Beulich <jbeulich@suse.com>=0A=0A---=
=0A drivers/xen/xen-pciback/pci_stub.c |   83 +++++++++++++++++------------=
--------=0A 1 file changed, 39 insertions(+), 44 deletions(-)=0A=0A--- =
3.7-rc3-xen-pciback.orig/drivers/xen/xen-pciback/pci_stub.c=0A+++ =
3.7-rc3-xen-pciback/drivers/xen/xen-pciback/pci_stub.c=0A@@ -897,42 =
+897,35 @@ static struct pci_driver xen_pcibk_pci_d=0A static inline int =
str_to_slot(const char *buf, int *domain, int *bus,=0A 			   =
   int *slot, int *func)=0A {=0A-	int err;=0A-	char wc =3D =
'*';=0A+	int parsed =3D 0;=0A =0A-	err =3D sscanf(buf, " =
%x:%x:%x.%x", domain, bus, slot, func);=0A-	switch (err) {=0A+	=
switch (sscanf(buf, " %x:%x:%x.%x %n", domain, bus, slot, func,=0A+		=
       &parsed)) {=0A 	case 3:=0A 		*func =3D -1;=0A-		=
err =3D sscanf(buf, " %x:%x:%x.%c", domain, bus, slot, &wc);=0A+		=
sscanf(buf, " %x:%x:%x.* %n", domain, bus, slot, &parsed);=0A 		=
break;=0A 	case 2:=0A 		*slot =3D *func =3D -1;=0A-		=
err =3D sscanf(buf, " %x:%x:*.%c", domain, bus, &wc);=0A-		if =
(err >=3D 2)=0A-			++err;=0A+		sscanf(buf,=
 " %x:%x:*.* %n", domain, bus, &parsed);=0A 		break;=0A 	=
}=0A-	if (err =3D=3D 4 && wc =3D=3D '*')=0A+	if (parsed && !buf[parsed])=
=0A 		return 0;=0A-	else if (err < 0)=0A-		return =
-EINVAL;=0A =0A 	/* try again without domain */=0A 	*domain =
=3D 0;=0A-	wc =3D '*';=0A-	err =3D sscanf(buf, " %x:%x.%x", bus, =
slot, func);=0A-	switch (err) {=0A+	switch (sscanf(buf, " =
%x:%x.%x %n", bus, slot, func, &parsed)) {=0A 	case 2:=0A 		=
*func =3D -1;=0A-		err =3D sscanf(buf, " %x:%x.%c", bus, =
slot, &wc);=0A+		sscanf(buf, " %x:%x.* %n", bus, slot, &parsed);=0A =
		break;=0A 	case 1:=0A 		*slot =3D *func =
=3D -1;=0A-		err =3D sscanf(buf, " %x:*.%c", bus, &wc) + 1;=0A+	=
	sscanf(buf, " %x:*.* %n", bus, &parsed);=0A 		break;=0A 	=
}=0A-	if (err =3D=3D 3 && wc =3D=3D '*')=0A+	if (parsed && !buf[parsed])=
=0A 		return 0;=0A =0A 	return -EINVAL;=0A@@ -941,13 =
+934,20 @@ static inline int str_to_slot(const char=0A static inline int =
str_to_quirk(const char *buf, int *domain, int *bus, int=0A 			=
       *slot, int *func, int *reg, int *size, int *mask)=0A {=0A-	=
int err;=0A+	int parsed =3D 0;=0A+=0A+	sscanf(buf, " %4x:%2x:%2x.%=
d-%8x:%1x:%8x %n", domain, bus, slot, func,=0A+	       reg, size, mask, =
&parsed);=0A+	if (parsed && !buf[parsed])=0A+		return 0;=0A =0A-	=
err =3D=0A-	    sscanf(buf, " %04x:%02x:%02x.%d-%08x:%1x:%08x", =
domain, bus, slot,=0A-		   func, reg, size, mask);=0A-	if (err =
=3D=3D 7)=0A+	/* try again without domain */=0A+	*domain =3D 0;=0A+	=
sscanf(buf, " %2x:%2x.%d-%8x:%1x:%8x %n", bus, slot, func, reg, size,=0A+	=
       mask, &parsed);=0A+	if (parsed && !buf[parsed])=0A 		=
return 0;=0A+=0A 	return -EINVAL;=0A }=0A =0A@@ -1339,8 +1339,6 @@ =
static int __init pcistub_init(void)=0A =0A 	if (pci_devs_to_hide && =
*pci_devs_to_hide) {=0A 		do {=0A-			=
char wc =3D '*';=0A-=0A 			parsed =3D 0;=0A =0A 		=
	err =3D sscanf(pci_devs_to_hide + pos,=0A@@ -1349,51 +1347,48 @@ =
static int __init pcistub_init(void)=0A 			switch =
(err) {=0A 			case 3:=0A 				=
func =3D -1;=0A-				err =3D sscanf(pci_devs_to_=
hide + pos,=0A-					     " (%x:%x:%x.%c) =
%n",=0A-					     &domain, &bus, &slot, =
&wc,=0A-					     &parsed);=0A+		=
		sscanf(pci_devs_to_hide + pos,=0A+				=
       " (%x:%x:%x.*) %n",=0A+				       &domain, =
&bus, &slot, &parsed);=0A 				break;=0A 		=
	case 2:=0A 				slot =3D func =3D -1;=0A-	=
			err =3D sscanf(pci_devs_to_hide + pos,=0A-		=
			     " (%x:%x:*.%c) %n",=0A-				=
	     &domain, &bus, &wc, &parsed) + 1;=0A+				=
sscanf(pci_devs_to_hide + pos,=0A+				       " =
(%x:%x:*.*) %n",=0A+				       &domain, &bus, =
&parsed);=0A 				break;=0A 			=
}=0A =0A-			if (err !=3D 4 || wc !=3D '*') {=0A+		=
	if (!parsed) {=0A 				domain =3D 0;=0A-	=
			wc =3D '*';=0A 				err =3D =
sscanf(pci_devs_to_hide + pos,=0A 					   =
  " (%x:%x.%x) %n",=0A 					     &bus, &slot, =
&func, &parsed);=0A 				switch (err) {=0A 		=
		case 2:=0A 					func =3D =
-1;=0A-					err =3D sscanf(pci_devs_to_hide + =
pos,=0A-						     " (%x:%x.%c) =
%n",=0A-						     &bus, &slot, =
&wc,=0A-						     &parsed);=0A+	=
				sscanf(pci_devs_to_hide + pos,=0A+		=
			       " (%x:%x.*) %n",=0A+				=
	       &bus, &slot, &parsed);=0A 					=
break;=0A 				case 1:=0A 				=
	slot =3D func =3D -1;=0A-					=
err =3D sscanf(pci_devs_to_hide + pos,=0A-					=
	     " (%x:*.%c) %n",=0A-						=
     &bus, &wc, &parsed) + 1;=0A+					=
sscanf(pci_devs_to_hide + pos,=0A+					   =
    " (%x:*.*) %n",=0A+					       &bus, =
&parsed);=0A 					break;=0A 			=
	}=0A-				if (err !=3D 3 || wc !=3D '*')=0A-	=
				goto parse_error;=0A 			=
}=0A =0A+			if (parsed <=3D 0)=0A+				=
goto parse_error;=0A+=0A 			err =3D pcistub_device_id_a=
dd(domain, bus, slot, func);=0A 			if (err)=0A 		=
		goto out;=0A =0A-			/* if parsed<=3D0, =
we've reached the end of the string */=0A 			pos +=3D =
parsed;=0A-		} while (parsed > 0 && pci_devs_to_hide[pos]);=0A+	=
	} while (pci_devs_to_hide[pos]);=0A 	}=0A =0A 	/* If =
we're the first PCI Device Driver to register, we're the=0A
--=__Part1726D966.2__=--
