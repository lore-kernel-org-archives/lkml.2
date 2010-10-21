Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab0JUWkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:40:21 -0400
Received: from claw.goop.org ([74.207.240.146]:52042 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab0JUWkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:40:20 -0400
Message-ID: <4CC0C14E.5080205@goop.org>
Date: Thu, 21 Oct 2010 15:40:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] x86: define arch_vm_get_page_prot to set _PAGE_IOMAP on VM_IO
 vmas
Content-Type: multipart/mixed;
 boundary="------------030106020305090903000800"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030106020305090903000800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



Set _PAGE_IOMAP in ptes mapping a VM_IO vma.  This says that the mapping
is of a real piece of physical hardware, and not just system memory.

Xen, in particular, uses to this to inhibit the normal pfn->mfn conversion
that would normally happen - in other words, treat the address directly
as a machine physical address without converting it from pseudo-physical.

[ Impact: make VM_IO mappings map the right thing under Xen ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 3cc06e3..4595ae2 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -394,6 +394,9 @@ static inline unsigned long pages_to_mb(unsigned long npg)
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
 	remap_pfn_range(vma, vaddr, pfn, size, prot)
 
+#define arch_vm_get_page_prot arch_vm_get_page_prot
+extern pgprot_t arch_vm_get_page_prot(unsigned vm_flags);
+
 #if PAGETABLE_LEVELS > 2
 static inline int pud_none(pud_t pud)
 {
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8e43bdd..e68aea6 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -6,6 +6,16 @@
 
 #define PGALLOC_GFP GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO
 
+pgprot_t arch_vm_get_page_prot(unsigned vm_flags)
+{
+	pgprot_t ret = __pgprot(0);
+
+	if (vm_flags & VM_IO)
+		ret = __pgprot(_PAGE_IOMAP);
+
+	return ret;
+}
+
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
 	return (pte_t *)__get_free_page(PGALLOC_GFP);



--------------030106020305090903000800
Content-Type: text/plain;
 name="define-arch_vm_get_page_prot.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="define-arch_vm_get_page_prot.patch"

RnJvbSA4MTU1MGI1MTQzNmMyODIzMTFjNTMxZDNiYTdhNzlkZWZkMjFjNzI5IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZXJlbXkgRml0emhhcmRpbmdlIDxqZXJlbXkuZml0
emhhcmRpbmdlQGNpdHJpeC5jb20+CkRhdGU6IEZyaSwgMjAgRmViIDIwMDkgMTI6NTg6NDIg
LTA4MDAKU3ViamVjdDogW1BBVENIXSB4ODY6IGRlZmluZSBhcmNoX3ZtX2dldF9wYWdlX3By
b3QgdG8gc2V0IF9QQUdFX0lPTUFQIG9uIFZNX0lPIHZtYXMKClNldCBfUEFHRV9JT01BUCBp
biBwdGVzIG1hcHBpbmcgYSBWTV9JTyB2bWEuICBUaGlzIHNheXMgdGhhdCB0aGUgbWFwcGlu
ZwppcyBvZiBhIHJlYWwgcGllY2Ugb2YgcGh5c2ljYWwgaGFyZHdhcmUsIGFuZCBub3QganVz
dCBzeXN0ZW0gbWVtb3J5LgoKWGVuLCBpbiBwYXJ0aWN1bGFyLCB1c2VzIHRvIHRoaXMgdG8g
aW5oaWJpdCB0aGUgbm9ybWFsIHBmbi0+bWZuIGNvbnZlcnNpb24KdGhhdCB3b3VsZCBub3Jt
YWxseSBoYXBwZW4gLSBpbiBvdGhlciB3b3JkcywgdHJlYXQgdGhlIGFkZHJlc3MgZGlyZWN0
bHkKYXMgYSBtYWNoaW5lIHBoeXNpY2FsIGFkZHJlc3Mgd2l0aG91dCBjb252ZXJ0aW5nIGl0
IGZyb20gcHNldWRvLXBoeXNpY2FsLgoKWyBJbXBhY3Q6IG1ha2UgVk1fSU8gbWFwcGluZ3Mg
bWFwIHRoZSByaWdodCB0aGluZyB1bmRlciBYZW4gXQoKU2lnbmVkLW9mZi1ieTogSmVyZW15
IEZpdHpoYXJkaW5nZSA8amVyZW15LmZpdHpoYXJkaW5nZUBjaXRyaXguY29tPgoKZGlmZiAt
LWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BndGFibGUuaCBiL2FyY2gveDg2L2luY2x1
ZGUvYXNtL3BndGFibGUuaAppbmRleCAzY2MwNmUzLi40NTk1YWUyIDEwMDY0NAotLS0gYS9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS9wZ3RhYmxlLmgKKysrIGIvYXJjaC94ODYvaW5jbHVkZS9h
c20vcGd0YWJsZS5oCkBAIC0zOTQsNiArMzk0LDkgQEAgc3RhdGljIGlubGluZSB1bnNpZ25l
ZCBsb25nIHBhZ2VzX3RvX21iKHVuc2lnbmVkIGxvbmcgbnBnKQogI2RlZmluZSBpb19yZW1h
cF9wZm5fcmFuZ2Uodm1hLCB2YWRkciwgcGZuLCBzaXplLCBwcm90KQlcCiAJcmVtYXBfcGZu
X3JhbmdlKHZtYSwgdmFkZHIsIHBmbiwgc2l6ZSwgcHJvdCkKIAorI2RlZmluZSBhcmNoX3Zt
X2dldF9wYWdlX3Byb3QgYXJjaF92bV9nZXRfcGFnZV9wcm90CitleHRlcm4gcGdwcm90X3Qg
YXJjaF92bV9nZXRfcGFnZV9wcm90KHVuc2lnbmVkIHZtX2ZsYWdzKTsKKwogI2lmIFBBR0VU
QUJMRV9MRVZFTFMgPiAyCiBzdGF0aWMgaW5saW5lIGludCBwdWRfbm9uZShwdWRfdCBwdWQp
CiB7CmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9tbS9wZ3RhYmxlLmMgYi9hcmNoL3g4Ni9tbS9w
Z3RhYmxlLmMKaW5kZXggOGU0M2JkZC4uZTY4YWVhNiAxMDA2NDQKLS0tIGEvYXJjaC94ODYv
bW0vcGd0YWJsZS5jCisrKyBiL2FyY2gveDg2L21tL3BndGFibGUuYwpAQCAtNiw2ICs2LDE2
IEBACiAKICNkZWZpbmUgUEdBTExPQ19HRlAgR0ZQX0tFUk5FTCB8IF9fR0ZQX05PVFJBQ0sg
fCBfX0dGUF9SRVBFQVQgfCBfX0dGUF9aRVJPCiAKK3BncHJvdF90IGFyY2hfdm1fZ2V0X3Bh
Z2VfcHJvdCh1bnNpZ25lZCB2bV9mbGFncykKK3sKKwlwZ3Byb3RfdCByZXQgPSBfX3BncHJv
dCgwKTsKKworCWlmICh2bV9mbGFncyAmIFZNX0lPKQorCQlyZXQgPSBfX3BncHJvdChfUEFH
RV9JT01BUCk7CisKKwlyZXR1cm4gcmV0OworfQorCiBwdGVfdCAqcHRlX2FsbG9jX29uZV9r
ZXJuZWwoc3RydWN0IG1tX3N0cnVjdCAqbW0sIHVuc2lnbmVkIGxvbmcgYWRkcmVzcykKIHsK
IAlyZXR1cm4gKHB0ZV90ICopX19nZXRfZnJlZV9wYWdlKFBHQUxMT0NfR0ZQKTsK
--------------030106020305090903000800--
