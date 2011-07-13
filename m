Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1GMNYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:24:32 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:65181 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696Ab1GMNY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:24:28 -0400
X-AuditID: 1209190c-b7c65ae00000117c-73-4e1d9c94aedf
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@amd64.org>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 3/8] x86-64: Allow alternative patching in the vDSO
Date: Wed, 13 Jul 2011 09:24:11 -0400
Message-Id: <e73112e4381fff29e31b882c2d0856822edaea53.1310563276.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310563276.git.luto@mit.edu>
References: <cover.1310563276.git.luto@mit.edu>
In-Reply-To: <cover.1310563276.git.luto@mit.edu>
References: <cover.1310563276.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsUixCmqrDtljqyfQVsDh0XflaPsFhcbt7FY
	tK6dz25xedccNostl5pZLTad+M1o8WPDY1YHdo/uR58YPW61/WH22DnrLrvHplWdbB7nrvUx
	e3zeJBfAFsVlk5Kak1mWWqRvl8CVcf/IJNaCPbwVb68+Zm9g/MbVxcjJISFgIjH14F52CFtM
	4sK99WxdjFwcQgL7GCXev3vCBOFsYJSY0vgfynnGJHHp7DpmkBY2ARWJjqUPgBIcHCICQhJL
	79aBhJkFnjBKTNirD2ILC7hJnD/QyQ5SwiKgKrF1njlImFcgSOLzkevMEIvlJI5cfs4EYnMK
	GEjMWXAD7CAhAX2J5x2HmXGJT2AUWMDIsIpRNiW3Sjc3MTOnODVZtzg5MS8vtUjXUC83s0Qv
	NaV0EyM4bCV5djC+Oah0iFGAg1GJh1c2XsZPiDWxrLgy9xCjJAeTkiiv6mxZPyG+pPyUyozE
	4oz4otKc1OJDjBIczEoivPUNQDnelMTKqtSifJiUNAeLkjhvufd/XyGB9MSS1OzU1ILUIpis
	DAeHkgSvODA+hQSLUtNTK9Iyc0oQ0kwcnCDDeYCGC4PU8BYXJOYWZ6ZD5E8x6nKcOrPgCKMQ
	S15+XqqUOO9nkOsEQIoySvPg5sDSzStGcaC3hHn/gVTxAFMV3KRXQEuYgJasswJbUpKIkJJq
	YMz/stdGV22Ws6/UtWelURK5ryJ4pULCHJ8kvT2csPHsvrB5QtYBM7r0jjEs4K+7ICuldoJ1
	XXSAs9XEIFZ3f50bd3hTnpgYJHW3vmnqvC1z26pM6eRsa5dpt5vWJUuprzI6Fvz4M3+WdbiD
	8lGtBddyi57c/mCww3lPaujik9q7bxxpy38frMRSnJFoqMVcVJwIADNR+7MSAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is short enough and different enough from the module
loader that it's not worth trying to share anything.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/vdso/vma.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 7abd2be..c39938d 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -23,11 +23,44 @@ extern unsigned short vdso_sync_cpuid;
 static struct page **vdso_pages;
 static unsigned vdso_size;
 
+static void __init patch_vdso(void *vdso, size_t len)
+{
+	Elf64_Ehdr *hdr = vdso;
+	Elf64_Shdr *sechdrs, *alt_sec = 0;
+	char *secstrings;
+	void *alt_data;
+	int i;
+
+	BUG_ON(len < sizeof(Elf64_Ehdr));
+	BUG_ON(memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0);
+
+	sechdrs = (void *)hdr + hdr->e_shoff;
+	secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+
+	for (i = 1; i < hdr->e_shnum; i++) {
+		Elf64_Shdr *shdr = &sechdrs[i];
+		if (!strcmp(secstrings + shdr->sh_name, ".altinstructions")) {
+			alt_sec = shdr;
+			goto found;
+		}
+	}
+
+	/* If we get here, it's probably a bug. */
+	pr_warning("patch_vdso: .altinstructions not found\n");
+	return;  /* nothing to patch */
+
+found:
+	alt_data = (void *)hdr + alt_sec->sh_offset;
+	apply_alternatives(alt_data, alt_data + alt_sec->sh_size);
+}
+
 static int __init init_vdso_vars(void)
 {
 	int npages = (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE;
 	int i;
 
+	patch_vdso(vdso_start, vdso_end - vdso_start);
+
 	vdso_size = npages << PAGE_SHIFT;
 	vdso_pages = kmalloc(sizeof(struct page *) * npages, GFP_KERNEL);
 	if (!vdso_pages)
-- 
1.7.6

