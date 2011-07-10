Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab1GJDWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 23:22:40 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:54737 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755329Ab1GJDWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 23:22:25 -0400
X-AuditID: 1209190c-b7c65ae00000117c-99-4e191af93160
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@amd64.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 3/8] x86-64: Allow alternative patching in the vDSO
Date: Sat,  9 Jul 2011 23:22:10 -0400
Message-Id: <e9c49596e493c1ebb80b52d2dff7bd50191ebc0e.1310267866.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310267866.git.luto@mit.edu>
References: <cover.1310267866.git.luto@mit.edu>
In-Reply-To: <cover.1310267866.git.luto@mit.edu>
References: <cover.1310267866.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsUixG6nrvtTStLPoPuVhEXflaPsFhcbt7FY
	tK6dz25xedccNostl5pZLX5seMzqwObR/egTo8ettj/MHjtn3WX32LSqk83j3LU+Zo/Pm+QC
	2KK4bFJSczLLUov07RK4MmZ9Xs5YcIyn4vWiFpYGxqlcXYycHBICJhITzjUzQthiEhfurWfr
	YuTiEBLYxyjx9fBzdghnPaPE7O+HoTJPmSSWLZjLDNLCJqAi0bH0AVMXIweHiICQxNK7dSA1
	zAKbGCV+bZoINlZYwE1ixtHVrCA2i4CqxJrJG1lA6nkFgiRubq+F2CwnceTycyYQm1PAQGL5
	3dlsILaQgL5E56f97LjEJzAKLGBkWMUom5JbpZubmJlTnJqsW5ycmJeXWqRrqJebWaKXmlK6
	iREUrpySPDsY3xxUOsQowMGoxMP7q1jCT4g1say4MvcQoyQHk5IoLy8w2IX4kvJTKjMSizPi
	i0pzUosPMUpwMCuJ8NZsAirnTUmsrEotyodJSXOwKInzlnv/9xUSSE8sSc1OTS1ILYLJynBw
	KEnwBoIMFSxKTU+tSMvMKUFIM3FwggznARrOCVLDW1yQmFucmQ6RP8Woy3HqzIIjjEIsefl5
	qVLivFIgRQIgRRmleXBzYGnmFaM40FvCvFwgVTzAFAU36RXQEiagJdOfg3xQXJKIkJJqYEy+
	wZ8xldNwoW36rEoTM/XPC9L+hrv4h6WceVFqx3xKvLFkcm3EGSH/F/NVbR4/TXWLseKuvnyk
	a+UG25A/j5ZNb/uVqeYQ8kdHbPnxhPNlmYZTzluuUOpp2RfT8lU29qbkadZjfcdqFVNOHYuN
	l/5km2y+9pq/wMbDG6L0llh8jI+15LlzWomlOCPRUIu5qDgRABd7/UcOAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is short enough and different enough from the module
loader that it's not worth trying to share anything.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/vdso/vma.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 7abd2be..ba92244 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -23,11 +23,41 @@ extern unsigned short vdso_sync_cpuid;
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
+			goto found;
+		}
+	}
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

