Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab2BQI7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 03:59:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:10060 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab2BQI7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 03:59:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="118566230"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
CC: "Li, Shaohua" <shaohua.li@intel.com>, Jan Beulich <JBeulich@suse.com>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>
Subject: [PATCH 2/3] Xen pad paravirt interface
Thread-Topic: [PATCH 2/3] Xen pad paravirt interface
Thread-Index: AcztUjkgdUkSYt9KSnaf70j5GjXZdQ==
Date: Fri, 17 Feb 2012 08:57:49 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233509D85E@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233509D85ESHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233509D85ESHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 9b7dbe30e9d2a862a0931ee365e832bbd4d6c2e5 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Fri, 10 Feb 2012 20:34:46 +0800
Subject: [PATCH 2/3] Xen pad paravirt interface

Redirect paravirt template to Xen pv ops, preparing for Xen core parking.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 arch/x86/xen/enlighten.c   |    6 ++++++
 drivers/xen/Makefile       |    1 +
 drivers/xen/xen_acpi_pad.c |    8 ++++++++
 include/xen/xen-ops.h      |    3 +++
 4 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xen/xen_acpi_pad.c

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 12eb07b..5b4f209 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1023,6 +1023,11 @@ static const struct pv_cpu_ops xen_cpu_ops __initcon=
st =3D {
 	.end_context_switch =3D xen_end_context_switch,
 };
=20
+static const struct pv_pad_ops xen_pad_ops __initconst =3D {
+	.acpi_pad_init =3D xen_acpi_pad_init,
+	.acpi_pad_exit =3D xen_acpi_pad_exit,
+};
+
 static const struct pv_apic_ops xen_apic_ops __initconst =3D {
 #ifdef CONFIG_X86_LOCAL_APIC
 	.startup_ipi_hook =3D paravirt_nop,
@@ -1126,6 +1131,7 @@ asmlinkage void __init xen_start_kernel(void)
 	pv_init_ops =3D xen_init_ops;
 	pv_cpu_ops =3D xen_cpu_ops;
 	pv_apic_ops =3D xen_apic_ops;
+	pv_pad_ops =3D xen_pad_ops;
=20
 	x86_init.resources.memory_setup =3D xen_memory_setup;
 	x86_init.oem.arch_setup =3D xen_arch_setup;
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index aa31337..c0268c9 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_SWIOTLB_XEN)		+=3D swiotlb-xen.o
 obj-$(CONFIG_XEN_DOM0)			+=3D pci.o
 obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+=3D xen-pciback/
 obj-$(CONFIG_XEN_PRIVCMD)		+=3D xen-privcmd.o
+obj-$(CONFIG_XEN_DOM0)			+=3D xen_acpi_pad.o
=20
 xen-evtchn-y				:=3D evtchn.o
 xen-gntdev-y				:=3D gntdev.o
diff --git a/drivers/xen/xen_acpi_pad.c b/drivers/xen/xen_acpi_pad.c
new file mode 100644
index 0000000..63ab2fb
--- /dev/null
+++ b/drivers/xen/xen_acpi_pad.c
@@ -0,0 +1,8 @@
+int xen_acpi_pad_init(void)
+{
+	return 0;
+}
+
+void xen_acpi_pad_exit(void)
+{
+}
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 03c85d7..eeb0d38 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -28,4 +28,7 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma=
,
 			       unsigned long mfn, int nr,
 			       pgprot_t prot, unsigned domid);
=20
+int xen_acpi_pad_init(void);
+void xen_acpi_pad_exit(void);
+
 #endif /* INCLUDE_XEN_OPS_H */
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC829233509D85ESHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0002-Xen-pad-paravirt-interface.patch"
Content-Description: 0002-Xen-pad-paravirt-interface.patch
Content-Disposition: attachment;
	filename="0002-Xen-pad-paravirt-interface.patch"; size=2549;
	creation-date="Fri, 17 Feb 2012 08:52:46 GMT";
	modification-date="Fri, 17 Feb 2012 16:49:16 GMT"
Content-Transfer-Encoding: base64

RnJvbSA5YjdkYmUzMGU5ZDJhODYyYTA5MzFlZTM2NWU4MzJiYmQ0ZDZjMmU1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogRnJpLCAxMCBGZWIgMjAxMiAyMDozNDo0NiArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMi8z
XSBYZW4gcGFkIHBhcmF2aXJ0IGludGVyZmFjZQoKUmVkaXJlY3QgcGFyYXZpcnQgdGVtcGxhdGUg
dG8gWGVuIHB2IG9wcywgcHJlcGFyaW5nIGZvciBYZW4gY29yZSBwYXJraW5nLgoKU2lnbmVkLW9m
Zi1ieTogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+Ci0tLQogYXJjaC94ODYv
eGVuL2VubGlnaHRlbi5jICAgfCAgICA2ICsrKysrKwogZHJpdmVycy94ZW4vTWFrZWZpbGUgICAg
ICAgfCAgICAxICsKIGRyaXZlcnMveGVuL3hlbl9hY3BpX3BhZC5jIHwgICAgOCArKysrKysrKwog
aW5jbHVkZS94ZW4veGVuLW9wcy5oICAgICAgfCAgICAzICsrKwogNCBmaWxlcyBjaGFuZ2VkLCAx
OCBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZl
cnMveGVuL3hlbl9hY3BpX3BhZC5jCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYveGVuL2VubGlnaHRl
bi5jIGIvYXJjaC94ODYveGVuL2VubGlnaHRlbi5jCmluZGV4IDEyZWIwN2IuLjViNGYyMDkgMTAw
NjQ0Ci0tLSBhL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYworKysgYi9hcmNoL3g4Ni94ZW4vZW5s
aWdodGVuLmMKQEAgLTEwMjMsNiArMTAyMywxMSBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHB2X2Nw
dV9vcHMgeGVuX2NwdV9vcHMgX19pbml0Y29uc3QgPSB7CiAJLmVuZF9jb250ZXh0X3N3aXRjaCA9
IHhlbl9lbmRfY29udGV4dF9zd2l0Y2gsCiB9OwogCitzdGF0aWMgY29uc3Qgc3RydWN0IHB2X3Bh
ZF9vcHMgeGVuX3BhZF9vcHMgX19pbml0Y29uc3QgPSB7CisJLmFjcGlfcGFkX2luaXQgPSB4ZW5f
YWNwaV9wYWRfaW5pdCwKKwkuYWNwaV9wYWRfZXhpdCA9IHhlbl9hY3BpX3BhZF9leGl0LAorfTsK
Kwogc3RhdGljIGNvbnN0IHN0cnVjdCBwdl9hcGljX29wcyB4ZW5fYXBpY19vcHMgX19pbml0Y29u
c3QgPSB7CiAjaWZkZWYgQ09ORklHX1g4Nl9MT0NBTF9BUElDCiAJLnN0YXJ0dXBfaXBpX2hvb2sg
PSBwYXJhdmlydF9ub3AsCkBAIC0xMTI2LDYgKzExMzEsNyBAQCBhc21saW5rYWdlIHZvaWQgX19p
bml0IHhlbl9zdGFydF9rZXJuZWwodm9pZCkKIAlwdl9pbml0X29wcyA9IHhlbl9pbml0X29wczsK
IAlwdl9jcHVfb3BzID0geGVuX2NwdV9vcHM7CiAJcHZfYXBpY19vcHMgPSB4ZW5fYXBpY19vcHM7
CisJcHZfcGFkX29wcyA9IHhlbl9wYWRfb3BzOwogCiAJeDg2X2luaXQucmVzb3VyY2VzLm1lbW9y
eV9zZXR1cCA9IHhlbl9tZW1vcnlfc2V0dXA7CiAJeDg2X2luaXQub2VtLmFyY2hfc2V0dXAgPSB4
ZW5fYXJjaF9zZXR1cDsKZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL01ha2VmaWxlIGIvZHJpdmVy
cy94ZW4vTWFrZWZpbGUKaW5kZXggYWEzMTMzNy4uYzAyNjhjOSAxMDA2NDQKLS0tIGEvZHJpdmVy
cy94ZW4vTWFrZWZpbGUKKysrIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKQEAgLTIwLDYgKzIwLDcg
QEAgb2JqLSQoQ09ORklHX1NXSU9UTEJfWEVOKQkJKz0gc3dpb3RsYi14ZW4ubwogb2JqLSQoQ09O
RklHX1hFTl9ET00wKQkJCSs9IHBjaS5vCiBvYmotJChDT05GSUdfWEVOX1BDSURFVl9CQUNLRU5E
KQkrPSB4ZW4tcGNpYmFjay8KIG9iai0kKENPTkZJR19YRU5fUFJJVkNNRCkJCSs9IHhlbi1wcml2
Y21kLm8KK29iai0kKENPTkZJR19YRU5fRE9NMCkJCQkrPSB4ZW5fYWNwaV9wYWQubwogCiB4ZW4t
ZXZ0Y2huLXkJCQkJOj0gZXZ0Y2huLm8KIHhlbi1nbnRkZXYteQkJCQk6PSBnbnRkZXYubwpkaWZm
IC0tZ2l0IGEvZHJpdmVycy94ZW4veGVuX2FjcGlfcGFkLmMgYi9kcml2ZXJzL3hlbi94ZW5fYWNw
aV9wYWQuYwpuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwLi42M2FiMmZiCi0tLSAv
ZGV2L251bGwKKysrIGIvZHJpdmVycy94ZW4veGVuX2FjcGlfcGFkLmMKQEAgLTAsMCArMSw4IEBA
CitpbnQgeGVuX2FjcGlfcGFkX2luaXQodm9pZCkKK3sKKwlyZXR1cm4gMDsKK30KKwordm9pZCB4
ZW5fYWNwaV9wYWRfZXhpdCh2b2lkKQoreworfQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS94ZW4veGVu
LW9wcy5oIGIvaW5jbHVkZS94ZW4veGVuLW9wcy5oCmluZGV4IDAzYzg1ZDcuLmVlYjBkMzggMTAw
NjQ0Ci0tLSBhL2luY2x1ZGUveGVuL3hlbi1vcHMuaAorKysgYi9pbmNsdWRlL3hlbi94ZW4tb3Bz
LmgKQEAgLTI4LDQgKzI4LDcgQEAgaW50IHhlbl9yZW1hcF9kb21haW5fbWZuX3JhbmdlKHN0cnVj
dCB2bV9hcmVhX3N0cnVjdCAqdm1hLAogCQkJICAgICAgIHVuc2lnbmVkIGxvbmcgbWZuLCBpbnQg
bnIsCiAJCQkgICAgICAgcGdwcm90X3QgcHJvdCwgdW5zaWduZWQgZG9taWQpOwogCitpbnQgeGVu
X2FjcGlfcGFkX2luaXQodm9pZCk7Cit2b2lkIHhlbl9hY3BpX3BhZF9leGl0KHZvaWQpOworCiAj
ZW5kaWYgLyogSU5DTFVERV9YRU5fT1BTX0ggKi8KLS0gCjEuNy4xCgo=

--_002_DE8DF0795D48FD4CA783C40EC829233509D85ESHSMSX101ccrcorpi_--
