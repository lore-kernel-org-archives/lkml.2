Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab0JNU4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 16:56:54 -0400
Received: from claw.goop.org ([74.207.240.146]:40555 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070Ab0JNU4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 16:56:51 -0400
Message-ID: <4CB76E8B.2090309@goop.org>
Date: Thu, 14 Oct 2010 13:56:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: [PATCH] x86: hold mm->page_table_lock while doing vmalloc_sync
Content-Type: multipart/mixed;
 boundary="------------090004080502090601010908"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090004080502090601010908
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



Take mm->page_table_lock while syncing the vmalloc region.  This prevents
a race with the Xen pagetable pin/unpin code, which expects that the
page_table_lock is already held.  If this race occurs, then Xen can see
an inconsistent page type (a page can either be read/write or a pagetable
page, and pin/unpin converts it between them), which will cause either
the pin or the set_p[gm]d to fail; either will crash the kernel.

vmalloc_sync_all() should be called rarely, so this extra use of
page_table_lock should not interfere with its normal users.

The mm pointer is stashed in the pgd page's index field, as that won't
be otherwise used for pgd pages.

Bug reported by Ian Campbell <ian.cambell@eu.citrix.com>
Derived from a patch by Jan Beulich <jbeulich@novell.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index a34c785..422b363 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -28,6 +28,8 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
 extern spinlock_t pgd_lock;
 extern struct list_head pgd_list;
 
+extern struct mm_struct *pgd_page_get_mm(struct page *page);
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else  /* !CONFIG_PARAVIRT */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 4c4508e..b7f9ae1 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -229,7 +229,16 @@ void vmalloc_sync_all(void)
 
 		spin_lock_irqsave(&pgd_lock, flags);
 		list_for_each_entry(page, &pgd_list, lru) {
-			if (!vmalloc_sync_one(page_address(page), address))
+			spinlock_t *pgt_lock;
+			int ret;
+
+			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
+
+			spin_lock(pgt_lock);
+			ret = vmalloc_sync_one(page_address(page), address);
+			spin_unlock(pgt_lock);
+
+			if (!ret)
 				break;
 		}
 		spin_unlock_irqrestore(&pgd_lock, flags);
@@ -341,11 +350,19 @@ void vmalloc_sync_all(void)
 		spin_lock_irqsave(&pgd_lock, flags);
 		list_for_each_entry(page, &pgd_list, lru) {
 			pgd_t *pgd;
+			spinlock_t *pgt_lock;
+
 			pgd = (pgd_t *)page_address(page) + pgd_index(address);
+
+			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
+			spin_lock(pgt_lock);
+
 			if (pgd_none(*pgd))
 				set_pgd(pgd, *pgd_ref);
 			else
 				BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_ref));
+
+			spin_unlock(pgt_lock);
 		}
 		spin_unlock_irqrestore(&pgd_lock, flags);
 	}
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 5c4ee42..c70e57d 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -87,7 +87,19 @@ static inline void pgd_list_del(pgd_t *pgd)
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 
-static void pgd_ctor(pgd_t *pgd)
+
+static void pgd_set_mm(pgd_t *pgd, struct mm_struct *mm)
+{
+	BUILD_BUG_ON(sizeof(virt_to_page(pgd)->index) < sizeof(mm));
+	virt_to_page(pgd)->index = (pgoff_t)mm;
+}
+
+struct mm_struct *pgd_page_get_mm(struct page *page)
+{
+	return (struct mm_struct *)page->index;
+}
+
+static void pgd_ctor(struct mm_struct *mm, pgd_t *pgd)
 {
 	/* If the pgd points to a shared pagetable level (either the
 	   ptes in non-PAE, or shared PMD in PAE), then just copy the
@@ -105,8 +117,10 @@ static void pgd_ctor(pgd_t *pgd)
 	}
 
 	/* list required to sync kernel mapping updates */
-	if (!SHARED_KERNEL_PMD)
+	if (!SHARED_KERNEL_PMD) {
+		pgd_set_mm(pgd, mm);
 		pgd_list_add(pgd);
+	}
 }
 
 static void pgd_dtor(pgd_t *pgd)
@@ -272,7 +286,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	 */
 	spin_lock_irqsave(&pgd_lock, flags);
 
-	pgd_ctor(pgd);
+	pgd_ctor(mm, pgd);
 	pgd_prepopulate_pmd(mm, pgd, pmds);
 
 	spin_unlock_irqrestore(&pgd_lock, flags);



--------------090004080502090601010908
Content-Type: text/plain;
 name="x86-lock-page_table_lock-in-vmalloc_sync.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="x86-lock-page_table_lock-in-vmalloc_sync.patch"

RnJvbSA2ZGRlYzkxODQ3M2RlZWQyMGMyYjQyYTE5NTMwNjA4ZWY5NmI3YWZjIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZXJlbXkgRml0emhhcmRpbmdlIDxqZXJlbXkuZml0
emhhcmRpbmdlQGNpdHJpeC5jb20+CkRhdGU6IFR1ZSwgMjEgU2VwIDIwMTAgMTI6MDE6NTEg
LTA3MDAKU3ViamVjdDogW1BBVENIXSB4ODY6IGhvbGQgbW0tPnBhZ2VfdGFibGVfbG9jayB3
aGlsZSBkb2luZyB2bWFsbG9jX3N5bmMKClRha2UgbW0tPnBhZ2VfdGFibGVfbG9jayB3aGls
ZSBzeW5jaW5nIHRoZSB2bWFsbG9jIHJlZ2lvbi4gIFRoaXMgcHJldmVudHMKYSByYWNlIHdp
dGggdGhlIFhlbiBwYWdldGFibGUgcGluL3VucGluIGNvZGUsIHdoaWNoIGV4cGVjdHMgdGhh
dCB0aGUKcGFnZV90YWJsZV9sb2NrIGlzIGFscmVhZHkgaGVsZC4gIElmIHRoaXMgcmFjZSBv
Y2N1cnMsIHRoZW4gWGVuIGNhbiBzZWUKYW4gaW5jb25zaXN0ZW50IHBhZ2UgdHlwZSAoYSBw
YWdlIGNhbiBlaXRoZXIgYmUgcmVhZC93cml0ZSBvciBhIHBhZ2V0YWJsZQpwYWdlLCBhbmQg
cGluL3VucGluIGNvbnZlcnRzIGl0IGJldHdlZW4gdGhlbSksIHdoaWNoIHdpbGwgY2F1c2Ug
ZWl0aGVyCnRoZSBwaW4gb3IgdGhlIHNldF9wW2dtXWQgdG8gZmFpbDsgZWl0aGVyIHdpbGwg
Y3Jhc2ggdGhlIGtlcm5lbC4KCnZtYWxsb2Nfc3luY19hbGwoKSBzaG91bGQgYmUgY2FsbGVk
IHJhcmVseSwgc28gdGhpcyBleHRyYSB1c2Ugb2YKcGFnZV90YWJsZV9sb2NrIHNob3VsZCBu
b3QgaW50ZXJmZXJlIHdpdGggaXRzIG5vcm1hbCB1c2Vycy4KClRoZSBtbSBwb2ludGVyIGlz
IHN0YXNoZWQgaW4gdGhlIHBnZCBwYWdlJ3MgaW5kZXggZmllbGQsIGFzIHRoYXQgd29uJ3QK
YmUgb3RoZXJ3aXNlIHVzZWQgZm9yIHBnZHMuCgpCdWcgcmVwb3J0ZWQgYnkgSWFuIENhbXBi
ZWxsIDxpYW4uY2FtYmVsbEBldS5jaXRyaXguY29tPgpEZXJpdmVkIGZyb20gYSBwYXRjaCBi
eSBKYW4gQmV1bGljaCA8amJldWxpY2hAbm92ZWxsLmNvbT4KClNpZ25lZC1vZmYtYnk6IEpl
cmVteSBGaXR6aGFyZGluZ2UgPGplcmVteS5maXR6aGFyZGluZ2VAY2l0cml4LmNvbT4KCmRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9wZ3RhYmxlLmggYi9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS9wZ3RhYmxlLmgKaW5kZXggYTM0Yzc4NS4uNDIyYjM2MyAxMDA2NDQKLS0t
IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcGd0YWJsZS5oCisrKyBiL2FyY2gveDg2L2luY2x1
ZGUvYXNtL3BndGFibGUuaApAQCAtMjgsNiArMjgsOCBAQCBleHRlcm4gdW5zaWduZWQgbG9u
ZyBlbXB0eV96ZXJvX3BhZ2VbUEFHRV9TSVpFIC8gc2l6ZW9mKHVuc2lnbmVkIGxvbmcpXTsK
IGV4dGVybiBzcGlubG9ja190IHBnZF9sb2NrOwogZXh0ZXJuIHN0cnVjdCBsaXN0X2hlYWQg
cGdkX2xpc3Q7CiAKK2V4dGVybiBzdHJ1Y3QgbW1fc3RydWN0ICpwZ2RfcGFnZV9nZXRfbW0o
c3RydWN0IHBhZ2UgKnBhZ2UpOworCiAjaWZkZWYgQ09ORklHX1BBUkFWSVJUCiAjaW5jbHVk
ZSA8YXNtL3BhcmF2aXJ0Lmg+CiAjZWxzZSAgLyogIUNPTkZJR19QQVJBVklSVCAqLwpkaWZm
IC0tZ2l0IGEvYXJjaC94ODYvbW0vZmF1bHQuYyBiL2FyY2gveDg2L21tL2ZhdWx0LmMKaW5k
ZXggNGM0NTA4ZS4uYjdmOWFlMSAxMDA2NDQKLS0tIGEvYXJjaC94ODYvbW0vZmF1bHQuYwor
KysgYi9hcmNoL3g4Ni9tbS9mYXVsdC5jCkBAIC0yMjksNyArMjI5LDE2IEBAIHZvaWQgdm1h
bGxvY19zeW5jX2FsbCh2b2lkKQogCiAJCXNwaW5fbG9ja19pcnFzYXZlKCZwZ2RfbG9jaywg
ZmxhZ3MpOwogCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KHBhZ2UsICZwZ2RfbGlzdCwgbHJ1KSB7
Ci0JCQlpZiAoIXZtYWxsb2Nfc3luY19vbmUocGFnZV9hZGRyZXNzKHBhZ2UpLCBhZGRyZXNz
KSkKKwkJCXNwaW5sb2NrX3QgKnBndF9sb2NrOworCQkJaW50IHJldDsKKworCQkJcGd0X2xv
Y2sgPSAmcGdkX3BhZ2VfZ2V0X21tKHBhZ2UpLT5wYWdlX3RhYmxlX2xvY2s7CisKKwkJCXNw
aW5fbG9jayhwZ3RfbG9jayk7CisJCQlyZXQgPSB2bWFsbG9jX3N5bmNfb25lKHBhZ2VfYWRk
cmVzcyhwYWdlKSwgYWRkcmVzcyk7CisJCQlzcGluX3VubG9jayhwZ3RfbG9jayk7CisKKwkJ
CWlmICghcmV0KQogCQkJCWJyZWFrOwogCQl9CiAJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
JnBnZF9sb2NrLCBmbGFncyk7CkBAIC0zNDEsMTEgKzM1MCwxOSBAQCB2b2lkIHZtYWxsb2Nf
c3luY19hbGwodm9pZCkKIAkJc3Bpbl9sb2NrX2lycXNhdmUoJnBnZF9sb2NrLCBmbGFncyk7
CiAJCWxpc3RfZm9yX2VhY2hfZW50cnkocGFnZSwgJnBnZF9saXN0LCBscnUpIHsKIAkJCXBn
ZF90ICpwZ2Q7CisJCQlzcGlubG9ja190ICpwZ3RfbG9jazsKKwogCQkJcGdkID0gKHBnZF90
ICopcGFnZV9hZGRyZXNzKHBhZ2UpICsgcGdkX2luZGV4KGFkZHJlc3MpOworCisJCQlwZ3Rf
bG9jayA9ICZwZ2RfcGFnZV9nZXRfbW0ocGFnZSktPnBhZ2VfdGFibGVfbG9jazsKKwkJCXNw
aW5fbG9jayhwZ3RfbG9jayk7CisKIAkJCWlmIChwZ2Rfbm9uZSgqcGdkKSkKIAkJCQlzZXRf
cGdkKHBnZCwgKnBnZF9yZWYpOwogCQkJZWxzZQogCQkJCUJVR19PTihwZ2RfcGFnZV92YWRk
cigqcGdkKSAhPSBwZ2RfcGFnZV92YWRkcigqcGdkX3JlZikpOworCisJCQlzcGluX3VubG9j
ayhwZ3RfbG9jayk7CiAJCX0KIAkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcGdkX2xvY2ss
IGZsYWdzKTsKIAl9CmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9tbS9wZ3RhYmxlLmMgYi9hcmNo
L3g4Ni9tbS9wZ3RhYmxlLmMKaW5kZXggNWM0ZWU0Mi4uYzcwZTU3ZCAxMDA2NDQKLS0tIGEv
YXJjaC94ODYvbW0vcGd0YWJsZS5jCisrKyBiL2FyY2gveDg2L21tL3BndGFibGUuYwpAQCAt
ODcsNyArODcsMTkgQEAgc3RhdGljIGlubGluZSB2b2lkIHBnZF9saXN0X2RlbChwZ2RfdCAq
cGdkKQogI2RlZmluZSBVTlNIQVJFRF9QVFJTX1BFUl9QR0QJCQkJXAogCShTSEFSRURfS0VS
TkVMX1BNRCA/IEtFUk5FTF9QR0RfQk9VTkRBUlkgOiBQVFJTX1BFUl9QR0QpCiAKLXN0YXRp
YyB2b2lkIHBnZF9jdG9yKHBnZF90ICpwZ2QpCisKK3N0YXRpYyB2b2lkIHBnZF9zZXRfbW0o
cGdkX3QgKnBnZCwgc3RydWN0IG1tX3N0cnVjdCAqbW0pCit7CisJQlVJTERfQlVHX09OKHNp
emVvZih2aXJ0X3RvX3BhZ2UocGdkKS0+aW5kZXgpIDwgc2l6ZW9mKG1tKSk7CisJdmlydF90
b19wYWdlKHBnZCktPmluZGV4ID0gKHBnb2ZmX3QpbW07Cit9CisKK3N0cnVjdCBtbV9zdHJ1
Y3QgKnBnZF9wYWdlX2dldF9tbShzdHJ1Y3QgcGFnZSAqcGFnZSkKK3sKKwlyZXR1cm4gKHN0
cnVjdCBtbV9zdHJ1Y3QgKilwYWdlLT5pbmRleDsKK30KKworc3RhdGljIHZvaWQgcGdkX2N0
b3Ioc3RydWN0IG1tX3N0cnVjdCAqbW0sIHBnZF90ICpwZ2QpCiB7CiAJLyogSWYgdGhlIHBn
ZCBwb2ludHMgdG8gYSBzaGFyZWQgcGFnZXRhYmxlIGxldmVsIChlaXRoZXIgdGhlCiAJICAg
cHRlcyBpbiBub24tUEFFLCBvciBzaGFyZWQgUE1EIGluIFBBRSksIHRoZW4ganVzdCBjb3B5
IHRoZQpAQCAtMTA1LDggKzExNywxMCBAQCBzdGF0aWMgdm9pZCBwZ2RfY3RvcihwZ2RfdCAq
cGdkKQogCX0KIAogCS8qIGxpc3QgcmVxdWlyZWQgdG8gc3luYyBrZXJuZWwgbWFwcGluZyB1
cGRhdGVzICovCi0JaWYgKCFTSEFSRURfS0VSTkVMX1BNRCkKKwlpZiAoIVNIQVJFRF9LRVJO
RUxfUE1EKSB7CisJCXBnZF9zZXRfbW0ocGdkLCBtbSk7CiAJCXBnZF9saXN0X2FkZChwZ2Qp
OworCX0KIH0KIAogc3RhdGljIHZvaWQgcGdkX2R0b3IocGdkX3QgKnBnZCkKQEAgLTI3Miw3
ICsyODYsNyBAQCBwZ2RfdCAqcGdkX2FsbG9jKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tKQogCSAq
LwogCXNwaW5fbG9ja19pcnFzYXZlKCZwZ2RfbG9jaywgZmxhZ3MpOwogCi0JcGdkX2N0b3Io
cGdkKTsKKwlwZ2RfY3RvcihtbSwgcGdkKTsKIAlwZ2RfcHJlcG9wdWxhdGVfcG1kKG1tLCBw
Z2QsIHBtZHMpOwogCiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcGdkX2xvY2ssIGZsYWdz
KTsK
--------------090004080502090601010908--
