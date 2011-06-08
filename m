Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab1FHRQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:16:51 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:51579 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1FHRQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:16:50 -0400
Date: Wed, 8 Jun 2011 22:46:32 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        anderson@redhat.com
Subject: Re: [RFC Patch 4/6] PANIC_MCE: Introduce a new panic flag for fatal
 MCE, capture related information
Message-ID: <20110608171632.GA11077@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20110526170722.GB23266@in.ibm.com>
 <20110526171521.GD17988@in.ibm.com>
 <m1fwo09g15.fsf@fess.ebiederm.org>
 <20110531174043.GA2000@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531174043.GA2000@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 11:10:43PM +0530, K.Prasad wrote:
> On Fri, May 27, 2011 at 11:04:06AM -0700, Eric W. Biederman wrote:
> > "K.Prasad" <prasad@linux.vnet.ibm.com> writes:
> > 
> > > PANIC_MCE: Introduce a new panic flag for fatal MCE, capture related information
> > >
> > > Fatal machine check exceptions (caused due to hardware memory errors) will now
> > > result in a 'slim' coredump that captures vital information about the MCE. This
> > > patch introduces a new panic flag, and new parameters to *panic functions
> > > that can capture more information pertaining to the cause of crash.
> > >
> > > Enable a new elf-notes section to store additional information about the crash.
> > > For MCE, enable a new notes section that captures relevant register status
> > > (struct mce) to be later read during coredump analysis.
> > 
> > There may be a reason to pass everything struct mce through 5 layers of
> > code but right now it looks like it just makes everything uglier to no
> > real purpose.
> 
> We could have stopped with just a blank elf-note of type NT_MCE
> indicating an MCE triggered panic, but dumping 'struct mce' in it will
> help gather more useful information about the error - especially the
> memory address that experienced unrecoverable error (stored in
> mce->addr).
> 
> The patch 6/6 for the 'crash' tool enabled decoding of 'struct
> mce' to show this information (although the sample log in patch 0/6)
> didn't show these benefits because 'mce-inject' tool used to soft-inject
> these errors doesn't populate all registers with valid contents.
> 
> The idea was that when mce->addr contains physical address is shown
> while decoding coredump, the corresponding memory DIMM could be identified
> for replacement/isolation.
> 
> Given that 'struct mce' isn't placed in a user-space visible file its
> duplicate copies have to be maintained in 'crash' (like it is done in
> 'mcelog' tool), and that's one disadvantage.
> 
> If you think that this complicates the patch, I'll start with a much
> 'slimmer' version (!) of the slimdump and the improvements may be
> contemplated iteratively.

While there are reports that kdump works fine (like in your case) in
capturing the coredump for a crash resulting from fatal MCE,
unfortunately we don't have means to recreate such a behaviour due to
the inability to inject memory errors in hardware to study further.

So our fears arise due to the premise that reading a faulty memory
location leads to undesirable consequences (whether MCE is disabled
or not) and would like to modify the OS to avoid such an operation.

While the ugliness of the patch (which I believe is due to
non-separation of generic and arch-specific code) is something that can
be addressed, I hope that the reasons for the patch are seen to be
valid.

Here's an attempt to make the slimdump patch more generic that can be
used by any hardware generated crash to prevent a coredump from being
captured (compile tested only).

I'll post a more formal version of the patch upon hearing further
comments.

Thanks,
K.Prasad


Index: linux-2.6.orig/include/linux/elf.h
===================================================================
--- linux-2.6.orig.orig/include/linux/elf.h
+++ linux-2.6.orig/include/linux/elf.h
@@ -381,6 +381,8 @@ typedef struct elf64_shdr {
 #define NT_PRPSINFO	3
 #define NT_TASKSTRUCT	4
 #define NT_AUXV		6
+/* Note to indicate absence of coredump for crashes initiated due to hardware errors */
+#define NT_NOCOREDUMP	21
 #define NT_PRXFPREG     0x46e62b7f      /* copied from gdb5.1/include/elf/common.h */
 #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
 #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
Index: linux-2.6.orig/kernel/kexec.c
===================================================================
--- linux-2.6.orig.orig/kernel/kexec.c
+++ linux-2.6.orig/kernel/kexec.c
@@ -1379,7 +1379,7 @@ int __init parse_crashkernel(char 		 *cm
 	return 0;
 }
 
-
+__weak void arch_add_nocoredump_note(u32 *buf) {}
 
 void crash_save_vmcoreinfo(void)
 {
@@ -1395,6 +1395,8 @@ void crash_save_vmcoreinfo(void)
 	buf = append_elf_note(buf, VMCOREINFO_NOTE_NAME, 0, vmcoreinfo_data,
 			      vmcoreinfo_size);
 
+	arch_add_nocoredump_note(buf);
+
 	final_note(buf);
 }
 
Index: linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux-2.6.orig.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
@@ -241,6 +241,30 @@ static atomic_t mce_paniced;
 static int fake_panic;
 static atomic_t mce_fake_paniced;
 
+void arch_add_nocoredump_note(u32 *buf)
+{
+	struct elf_note note;
+	char *note_name = "PANIC_MCE";
+
+	/*
+	 * Prevent coredump from being captured if the panic was triggered due
+	 * to fatal Machine Check Exceptions (MCE).
+	 */
+	if (!mce_paniced)
+		return;
+
+	note.n_namesz = strlen(note_name) + 1;
+	/* We have no additional description */
+	note.n_descsz = 0;
+	note.n_type = NT_NOCOREDUMP;
+
+	memcpy(buf, &note, sizeof(note));
+        buf += (sizeof(note) + 3)/4;
+        memcpy(buf, note_name, note.n_namesz);
+        buf += (note.n_namesz + 3)/4;
+}
+
+
 /* Panic in progress. Enable interrupts and wait for final IPI */
 static void wait_for_panic(void)
 {
Index: linux-2.6.orig/fs/proc/vmcore.c
===================================================================
--- linux-2.6.orig.orig/fs/proc/vmcore.c
+++ linux-2.6.orig/fs/proc/vmcore.c
@@ -529,6 +529,56 @@ static void __init set_vmcore_list_offse
 	}
 }
 
+/*
+ * Check if the crash was due to a fatal Memory Check Exception
+ */
+static int has_nocoredump_note64(void)
+{
+	int i, j, len = 0, rc;
+	Elf64_Ehdr *ehdr_ptr;
+	Elf64_Phdr *phdr_ptr;
+	Elf64_Nhdr *nhdr_ptr;
+
+	ehdr_ptr = (Elf64_Ehdr *)elfcorebuf;
+	phdr_ptr = (Elf64_Phdr *)(elfcorebuf + sizeof(Elf64_Ehdr));
+
+	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
+		void *notes_section;
+		u64 offset, max_sz;
+		if (phdr_ptr->p_type != PT_NOTE)
+			continue;
+		max_sz = phdr_ptr->p_memsz;
+		offset = phdr_ptr->p_offset;
+		notes_section = kmalloc(max_sz, GFP_KERNEL);
+		if (!notes_section)
+			return -ENOMEM;
+		rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
+		if (rc < 0) {
+			kfree(notes_section);
+			return rc;
+		}
+
+		for (j = 0; j < phdr_ptr->p_filesz; j += len) {
+			nhdr_ptr = notes_section + j;
+			if (nhdr_ptr->n_type == NT_NOCOREDUMP)
+			{
+				kfree(notes_section);
+				return 1;
+			}
+			/*
+			 * The elf-64 standard specifies 8-byte alignment while
+			 * append_elf_note function does only 4-byte roundup.
+			 * Hence this code also does a 4-byte roundup.
+			 */
+			len = sizeof(Elf64_Nhdr);
+			len = roundup(len + nhdr_ptr->n_namesz, 4);
+			len = roundup(len + nhdr_ptr->n_descsz, 4);
+		}
+		kfree(notes_section);
+	}
+	return 0;
+}
+
 static int __init parse_crash_elf64_headers(void)
 {
 	int rc=0;
@@ -569,6 +619,19 @@ static int __init parse_crash_elf64_head
 		return rc;
 	}
 
+	phdr_ptr = (Elf64_Phdr *)(elfcorebuf + sizeof(Elf64_Ehdr));
+	if (has_nocoredump_note64() > 0) {
+		/*
+		 * If crash is due to hardware errors, elf-note of
+		 * type NT_NOCOREDUMP is present. If so, don't populate
+		 * sections other than elf-notes. Mark their sizes as zero.
+		 */
+		for (i = 0; i < ehdr.e_phnum; i++, phdr_ptr++) {
+			if (phdr_ptr->p_type != PT_NOTE)
+				phdr_ptr->p_memsz = phdr_ptr->p_filesz = 0;
+		}
+	}
+
 	/* Merge all PT_NOTE headers into one. */
 	rc = merge_note_headers_elf64(elfcorebuf, &elfcorebuf_sz, &vmcore_list);
 	if (rc) {
