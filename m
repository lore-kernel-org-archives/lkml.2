Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab1FGTdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:33:04 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:53955 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430Ab1FGTdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:33:02 -0400
X-AuditID: 12074422-b7b0eae000007f48-a0-4dee7cf3d88e
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 2/5] x86-64: Allow alternative patching in the vDSO
Date: Tue,  7 Jun 2011 15:32:39 -0400
Message-Id: <9f34abb8ee488207e6b1cc2972eee81a4e612a0d.1307474707.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1307474707.git.luto@mit.edu>
References: <cover.1307474707.git.luto@mit.edu>
In-Reply-To: <cover.1307474707.git.luto@mit.edu>
References: <cover.1307474707.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsUixCmqrPu55p2vwdzr0hZ9V46yW1zeNYfN
	YsulZlaLHxseszqweNxq+8PssXPWXXaPTas62Tw+b5ILYInisklJzcksSy3St0vgypg78zpz
	wVWeisUfJzM1MM7j6mLk5JAQMJGY/HgbE4QtJnHh3nq2LkYuDiGBfYwSi+buZ4Zw1jNKHOhf
	wArhHGKSmLFlLxtIC5uAikTH0gdA7RwcIgJCEkvv1oGEmQXSJOZe/8UCYgsLOEs0zjjECGKz
	CKhKNOzvZAWxeQWCJBp2L2QEaZUQUJA4vyofxOQUMJD4d7sWxBQS0JfY8EUQu+gERoEFjAyr
	GGVTcqt0cxMzc4pTk3WLkxPz8lKLdE31cjNL9FJTSjcxgoKP3UVpB+PPg0qHGAU4GJV4eBNC
	3vkKsSaWFVfmHmKU5GBSEuU1rAYK8SXlp1RmJBZnxBeV5qQWH2KU4GBWEuGdcf2trxBvSmJl
	VWpRPkxKmoNFSZx3jqS6r5BAemJJanZqakFqEUxWhoNDSYJXAxhlQoJFqempFWmZOSUIaSYO
	TpDhPEDDX4Ms5i0uSMwtzkyHyJ9i1OXYeuLtQUYhlrz8vFQpcV4+kEECIEUZpXlwc2BJ4xWj
	ONBbwrxzQKp4gAkHbtIroCVMQEtOnwX5oLgkESEl1cAYN02UzWbia32XzEO3H+96t1jj4lT2
	DRW9uaW+QXw3QpasdVINnLq2beUqv3zu88+TeFRup28xd4gsqvw/VV/3x7dfvruCrrw/dnXB
	8lsBy922f5R/oMesvZNN9vT0qsiytxdZ5r8ujn0wMflHrA3z85qbIm/kbmY4b3k0K/jUw8zJ
	P1VcHtgmKLEUZyQaajEXFScCAFPuPv31AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is short enough and different enough from the module
loader that it's not worth trying to share anything.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/vdso/vma.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 7abd2be..b8b074c1 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -23,11 +23,43 @@ extern unsigned short vdso_sync_cpuid;
 static struct page **vdso_pages;
 static unsigned vdso_size;
 
+static void patch_vdso(void *vdso, size_t len)
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
+			break;
+		}
+	}
+
+	if (!alt_sec)
+		return;  /* nothing to patch */
+
+	alt_data = (void *)hdr + alt_sec->sh_offset;
+
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
1.7.5.2

