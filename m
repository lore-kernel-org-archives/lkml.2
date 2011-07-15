Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab1GOEX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 00:23:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:59328 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab1GOEX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 00:23:26 -0400
Date: Fri, 15 Jul 2011 04:23:18 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-1b3f2a72bbcfdf92e368a44448c45eb639b05b5e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <e73112e4381fff29e31b882c2d0856822edaea53.1310563276.git.luto@mit.edu>
References: <e73112e4381fff29e31b882c2d0856822edaea53.1310563276.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Allow alternative patching in the vDSO
Git-Commit-ID: 1b3f2a72bbcfdf92e368a44448c45eb639b05b5e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Jul 2011 04:23:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b3f2a72bbcfdf92e368a44448c45eb639b05b5e
Gitweb:     http://git.kernel.org/tip/1b3f2a72bbcfdf92e368a44448c45eb639b05b5e
Author:     Andy Lutomirski <luto@mit.edu>
AuthorDate: Wed, 13 Jul 2011 09:24:11 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 13 Jul 2011 11:23:07 -0700

x86-64: Allow alternative patching in the vDSO

This code is short enough and different enough from the module
loader that it's not worth trying to share anything.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Link: http://lkml.kernel.org/r/e73112e4381fff29e31b882c2d0856822edaea53.1310563276.git.luto@mit.edu
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
