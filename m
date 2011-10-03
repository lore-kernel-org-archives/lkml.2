Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab1JCHhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 03:37:54 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:34137 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab1JCHhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 03:37:48 -0400
Date: Mon, 3 Oct 2011 13:07:35 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org
Cc: Vivek Goyal <vgoyal@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
Subject: [Patch 3/4][makedumpfile] Capture slimdump if elf-note NT_NOCOREDUMP
 present
Message-ID: <20111003073735.GC22694@in.ibm.com>
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

The kernel decides to add a new elf-note of type NT_NOCOREDUMP for various
hardware error triggered crashes where it makes no sense (or sometimes
dangerous) to capture kernel memory into the dump. This patch teaches
'makedumpfile' tool needs to recognise the new elf-note type and act
accordingly.

Since only a 'slimdump' of a very small size (containing only elf-headers and
elf-notes section) will be captured, the coredump will be of ELF type (and not
kdump-compressed format).

Todo: Make changes to the man pages of makedumpfile to describe these changes.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 elf_info.c     |   36 ++++++++++++++++++++++++++++++++++++
 elf_info.h     |    8 ++++++++
 makedumpfile.c |   13 ++++++++++++-
 makedumpfile.h |    1 +
 4 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/elf_info.c b/elf_info.c
index 114dd05..de93d9a 100644
--- a/elf_info.c
+++ b/elf_info.c
@@ -287,6 +287,41 @@ offset_note_desc(void *note)
 	return offset;
 }
 
+/*
+ * The kernel generally adds an elf-note of type NT_NOCOREDUMP if the crash is
+ * due to a hardware error and when it makes no sense to read/store the
+ * crashing kernel's memory. In such a case, only a 'slimdump' is captured.
+ *
+ * This function checks if the elf-header has a note of type NT_NOCOREDUMP.
+ */
+int
+has_nocoredump_note(void)
+{
+	char note[MAX_SIZE_NHDR];
+	off_t offset;
+
+	offset = offset_pt_note_memory;
+	while (offset < offset_pt_note_memory + size_pt_note_memory) {
+		if (lseek(fd_memory, offset, SEEK_SET) < 0) {
+			ERRMSG("Can't seek the dump memory(%s). %s\n",
+			    name_memory, strerror(errno));
+			return FALSE;
+		}
+		if (read(fd_memory, note, sizeof(note)) != sizeof(note)) {
+			ERRMSG("Can't read the dump memory(%s). %s\n",
+			    name_memory, strerror(errno));
+			return FALSE;
+		}
+		if (note_type(note) == NT_NOCOREDUMP) {
+			DEBUG_MSG("kdump will not be collected. "
+				  "NT_NOCOREDUMP elf-note present.\n");
+			return TRUE;
+		}
+		offset += offset_next_note(note);
+	}
+	return FALSE;
+}
+
 static int
 get_pt_note_info(void)
 {
@@ -630,6 +665,7 @@ get_elf_info(int fd, char *filename)
 		ERRMSG("Can't find PT_NOTE Phdr.\n");
 		return FALSE;
 	}
+	has_nocoredump_note();
 	if (!get_pt_note_info()) {
 		ERRMSG("Can't get PT_NOTE information.\n");
 		return FALSE;
diff --git a/elf_info.h b/elf_info.h
index 4dff9c1..10fdc0b 100644
--- a/elf_info.h
+++ b/elf_info.h
@@ -22,6 +22,12 @@
 #define ERASEINFO_NOTE_NAME		"ERASEINFO"
 #define ERASEINFO_NOTE_NAME_BYTES	(sizeof(ERASEINFO_NOTE_NAME))
 
+/*
+ * Temporary definition of new elf-note type for compilation purposes.
+ * Not required when run on a new kernel containing this definition.
+ */
+#define NT_NOCOREDUMP	21
+
 #define MAX_SIZE_NHDR	MAX(sizeof(Elf64_Nhdr), sizeof(Elf32_Nhdr))
 
 
@@ -34,6 +40,8 @@ unsigned long long get_max_paddr(void);
 int get_elf64_ehdr(int fd, char *filename, Elf64_Ehdr *ehdr);
 int get_elf32_ehdr(int fd, char *filename, Elf32_Ehdr *ehdr);
 int get_elf_info(int fd, char *filename);
+int has_nocoredump_note(void);
+
 void free_elf_info(void);
 
 int is_elf64_memory(void);
diff --git a/makedumpfile.c b/makedumpfile.c
index 7b7c266..a73b4f7 100644
--- a/makedumpfile.c
+++ b/makedumpfile.c
@@ -4173,7 +4173,11 @@ write_elf_pages(struct cache_data *cd_header, struct cache_data *cd_page)
 		if (!get_phdr_memory(i, &load))
 			return FALSE;
 
-		if (load.p_type != PT_LOAD)
+		/*
+		 * Do not capture the kernel's memory if flag_nocoredump is
+		 * turned on. This may be dangerous to the system stability.
+		 */
+		if ((load.p_type != PT_LOAD) || (info->flag_nocoredump))
 			continue;
 
 		off_memory= load.p_offset;
@@ -5760,6 +5764,13 @@ create_dumpfile(void)
 		if (!get_elf_info(info->fd_memory, info->name_memory))
 			return FALSE;
 	}
+	/*
+	 * If NT_NOCOREDUMP elf-note is present, indicate the same through
+	 * 'flag_nocoredump' flag. The resultant slimdump will always be in ELF
+	 * format, irrespective of the user options.
+	 */
+	info->flag_nocoredump = info->flag_elf_dumpfile = has_nocoredump_note();
+
 	if (is_xen_memory()) {
 		if (!initial_xen())
 			return FALSE;
diff --git a/makedumpfile.h b/makedumpfile.h
index f0e5da8..faf1c65 100644
--- a/makedumpfile.h
+++ b/makedumpfile.h
@@ -778,6 +778,7 @@ struct DumpInfo {
 	int		flag_exclude_xen_dom;/* exclude Domain-U from xen-kdump */
 	int             flag_dmesg;          /* dump the dmesg log out of the vmcore file */
 	int		flag_nospace;	     /* the flag of "No space on device" error */
+	int		flag_nocoredump;	/* coredump not collected */
 	unsigned long	vaddr_for_vtop;      /* virtual address for debugging */
 	long		page_size;           /* size of page */
 	long		page_shift;
-- 
1.7.4.1

