Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab1JCHg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 03:36:57 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:49010 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1JCHgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 03:36:52 -0400
Date: Mon, 3 Oct 2011 13:05:27 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org
Cc: Vivek Goyal <vgoyal@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
Subject: [Patch 2/4][kexec-tools] Recognise NT_NOCOREDUMP elf-note type
Message-ID: <20111003073527.GB22694@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20111003070735.GJ2223@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003070735.GJ2223@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel vmcore may contain a new elf-note of type NT_NOCOREDUMP. Include this
new note, whose address and length are made available at
/sys/kernel/nt_nocoredump, while loading elf-headers.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---

diff --git a/kexec/crashdump-elf.c b/kexec/crashdump-elf.c
index 8d82db9..b009227 100644
--- a/kexec/crashdump-elf.c
+++ b/kexec/crashdump-elf.c
@@ -39,7 +39,9 @@ int FUNC(struct kexec_info *info,
 	long int nr_cpus = 0;
 	uint64_t notes_addr, notes_len;
 	uint64_t vmcoreinfo_addr, vmcoreinfo_len;
+	uint64_t nt_nocoredump_addr, nt_nocoredump_len;
 	int has_vmcoreinfo = 0;
+	int has_nt_nocoredump = 0;
 	uint64_t vmcoreinfo_addr_xen, vmcoreinfo_len_xen;
 	int has_vmcoreinfo_xen = 0;
 	int (*get_note_info)(int cpu, uint64_t *addr, uint64_t *len);
@@ -57,6 +59,9 @@ int FUNC(struct kexec_info *info,
 		has_vmcoreinfo = 1;
 	}
 
+	if (get_kernel_nt_nocoredump(&nt_nocoredump_addr, &nt_nocoredump_len) == 0)
+		has_nt_nocoredump = 1;
+
 	if (xen_present() &&
 	    get_xen_vmcoreinfo(&vmcoreinfo_addr_xen, &vmcoreinfo_len_xen) == 0) {
 		has_vmcoreinfo_xen = 1;
@@ -179,6 +184,21 @@ int FUNC(struct kexec_info *info,
 		dbgprintf_phdr("vmcoreinfo header", phdr);
 	}
 
+	if (has_nt_nocoredump && !(info->kexec_flags & KEXEC_PRESERVE_CONTEXT)) {
+		phdr = (PHDR *) bufp;
+		bufp += sizeof(PHDR);
+		phdr->p_type	= PT_NOTE;
+		phdr->p_flags	= 0;
+		phdr->p_offset  = phdr->p_paddr = nt_nocoredump_addr;
+		phdr->p_vaddr   = 0;
+		phdr->p_filesz	= phdr->p_memsz	= nt_nocoredump_len;
+		/* Do we need any alignment of segments? */
+		phdr->p_align	= 0;
+
+		(elf->e_phnum)++;
+		dbgprintf_phdr("nocoredump note present", phdr);
+	}
+
 	if (has_vmcoreinfo_xen) {
 		phdr = (PHDR *) bufp;
 		bufp += sizeof(PHDR);
diff --git a/kexec/crashdump.c b/kexec/crashdump.c
index 945b052..0ee05f0 100644
--- a/kexec/crashdump.c
+++ b/kexec/crashdump.c
@@ -136,12 +136,43 @@ static int get_vmcoreinfo(const char *kdump_info, uint64_t *addr, uint64_t *len)
 	return 0;
 }
 
+static int get_nt_nocoredump(const char *kdump_info, uint64_t *addr, uint64_t *len)
+{
+	char line[MAX_LINE];
+	int count;
+	FILE *fp;
+	unsigned int temp2;
+	unsigned long long temp;
+
+	*addr = 0;
+	*len = 0;
+
+	if (!(fp = fopen(kdump_info, "r")))
+		return -1;
+	if (!fgets(line, sizeof(line), fp))
+		die("Cannot parse %s: %s\n", kdump_info, strerror(errno));
+	count = sscanf(line, "%Lx %x", &temp, &temp2);
+	if (count != 2)
+		die("Cannot parse %s: %s\n", kdump_info, strerror(errno));
+
+	*addr = (uint64_t) temp;
+	*len = (uint64_t) temp2;
+
+	fclose(fp);
+	return 0;
+}
 /* Returns the physical address of start of crash notes buffer for a kernel. */
 int get_kernel_vmcoreinfo(uint64_t *addr, uint64_t *len)
 {
 	return get_vmcoreinfo("/sys/kernel/vmcoreinfo", addr, len);
 }
 
+/* Returns the physical address of start of nocoredump buffer for a kernel. */
+int get_kernel_nt_nocoredump(uint64_t *addr, uint64_t *len)
+{
+	return get_nt_nocoredump("/sys/kernel/nt_nocoredump", addr, len);
+}
+
 int get_xen_vmcoreinfo(uint64_t *addr, uint64_t *len)
 {
 	return get_vmcoreinfo("/sys/hypervisor/vmcoreinfo", addr, len);
-- 
1.7.4.1

