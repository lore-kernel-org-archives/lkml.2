Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1ERHFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 03:05:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58445 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab1ERHFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 03:05:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ZYfsuZsVbVDcLlYMMA8loMQtahnTH+UegSUdQykSk4m5Wor/108bjfHS1jae0B6JV4
         3gm9G0hEm/u2pzD1VBUokKtnFU3wKbCUH6gomdXRaD5ag0NAe47TET9R1NCpjCq8NNnu
         ivEyBVHiAXoxfJZFrGn9QTK/bbYkSYM7yUl0w=
MIME-Version: 1.0
Date: Wed, 18 May 2011 15:05:49 +0800
Message-ID: <BANLkTikz+i6kahgoEAQPzoL9PVpywVb0ug@mail.gmail.com>
Subject: [PATCH] vdso: Fix memory leak of init_vdso_vars().
From: wzt wzt <wzt.wzt@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, ak@linux.intel.com, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com
Content-Type: multipart/mixed; boundary=0016e68ee29dbf771004a387840d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e68ee29dbf771004a387840d
Content-Type: text/plain; charset=UTF-8

Fix memory leak of init_vdso_vars().

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
Reviewed-by: Coly Li <bosong.ly@taobao.com>

---
 arch/x86/vdso/vma.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 4b5d26f..8d9d652 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -44,19 +44,19 @@ static int __init init_vdso_vars(void)
 	vdso_size = npages << PAGE_SHIFT;
 	vdso_pages = kmalloc(sizeof(struct page *) * npages, GFP_KERNEL);
 	if (!vdso_pages)
-		goto oom;
+		goto oom1;
 	for (i = 0; i < npages; i++) {
 		struct page *p;
 		p = alloc_page(GFP_KERNEL);
 		if (!p)
-			goto oom;
+			goto oom2;
 		vdso_pages[i] = p;
 		copy_page(page_address(p), vdso_start + i*PAGE_SIZE);
 	}

 	vbase = vmap(vdso_pages, npages, 0, PAGE_KERNEL);
 	if (!vbase)
-		goto oom;
+		goto oom2;

 	if (memcmp(vbase, "\177ELF", 4)) {
 		printk("VDSO: I'm broken; not ELF\n");
@@ -70,7 +70,13 @@ static int __init init_vdso_vars(void)
 	vunmap(vbase);
 	return 0;

- oom:
+oom2:
+	i--;
+	for (; i >= 0; i--)
+		__free_page(vdso_pages[i]);
+oom1:
+	__free_page(vdso_pages);
+
 	printk("Cannot allocate vdso\n");
 	vdso_enabled = 0;
 	return -ENOMEM;
-- 
1.7.1

--0016e68ee29dbf771004a387840d
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-Fix-memory-leak-of-init_vdso_vars.patch"
Content-Disposition: attachment; 
	filename="0001-Fix-memory-leak-of-init_vdso_vars.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gntx6hsw0

Rml4IG1lbW9yeSBsZWFrIG9mIGluaXRfdmRzb192YXJzKCkuCgpTaWduZWQtb2ZmLWJ5OiBaaGl0
b25nIFdhbmcgPHpoaXRvbmcud2FuZ3p0QGFsaWJhYmEtaW5jLmNvbT4KUmV2aWV3ZWQtYnk6IENv
bHkgTGkgPGJvc29uZy5seUB0YW9iYW8uY29tPgoKLS0tCiBhcmNoL3g4Ni92ZHNvL3ZtYS5jIHwg
ICAxNCArKysrKysrKysrLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCA0
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L3Zkc28vdm1hLmMgYi9hcmNoL3g4
Ni92ZHNvL3ZtYS5jCmluZGV4IDRiNWQyNmYuLjhkOWQ2NTIgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2
L3Zkc28vdm1hLmMKKysrIGIvYXJjaC94ODYvdmRzby92bWEuYwpAQCAtNDQsMTkgKzQ0LDE5IEBA
IHN0YXRpYyBpbnQgX19pbml0IGluaXRfdmRzb192YXJzKHZvaWQpCiAJdmRzb19zaXplID0gbnBh
Z2VzIDw8IFBBR0VfU0hJRlQ7CiAJdmRzb19wYWdlcyA9IGttYWxsb2Moc2l6ZW9mKHN0cnVjdCBw
YWdlICopICogbnBhZ2VzLCBHRlBfS0VSTkVMKTsKIAlpZiAoIXZkc29fcGFnZXMpCi0JCWdvdG8g
b29tOworCQlnb3RvIG9vbTE7CiAJZm9yIChpID0gMDsgaSA8IG5wYWdlczsgaSsrKSB7CiAJCXN0
cnVjdCBwYWdlICpwOwogCQlwID0gYWxsb2NfcGFnZShHRlBfS0VSTkVMKTsKIAkJaWYgKCFwKQot
CQkJZ290byBvb207CisJCQlnb3RvIG9vbTI7CiAJCXZkc29fcGFnZXNbaV0gPSBwOwogCQljb3B5
X3BhZ2UocGFnZV9hZGRyZXNzKHApLCB2ZHNvX3N0YXJ0ICsgaSpQQUdFX1NJWkUpOwogCX0KIAog
CXZiYXNlID0gdm1hcCh2ZHNvX3BhZ2VzLCBucGFnZXMsIDAsIFBBR0VfS0VSTkVMKTsKIAlpZiAo
IXZiYXNlKQotCQlnb3RvIG9vbTsKKwkJZ290byBvb20yOwogCiAJaWYgKG1lbWNtcCh2YmFzZSwg
IlwxNzdFTEYiLCA0KSkgewogCQlwcmludGsoIlZEU086IEknbSBicm9rZW47IG5vdCBFTEZcbiIp
OwpAQCAtNzAsNyArNzAsMTMgQEAgc3RhdGljIGludCBfX2luaXQgaW5pdF92ZHNvX3ZhcnModm9p
ZCkKIAl2dW5tYXAodmJhc2UpOwogCXJldHVybiAwOwogCi0gb29tOgorb29tMjoKKwlpLS07CisJ
Zm9yICg7IGkgPj0gMDsgaS0tKQorCQlfX2ZyZWVfcGFnZSh2ZHNvX3BhZ2VzW2ldKTsKK29vbTE6
CisJX19mcmVlX3BhZ2UodmRzb19wYWdlcyk7CisKIAlwcmludGsoIkNhbm5vdCBhbGxvY2F0ZSB2
ZHNvXG4iKTsKIAl2ZHNvX2VuYWJsZWQgPSAwOwogCXJldHVybiAtRU5PTUVNOwotLSAKMS43LjEK
Cg==
--0016e68ee29dbf771004a387840d--
