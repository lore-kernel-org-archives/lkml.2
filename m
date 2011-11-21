Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab1KUKOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:14:34 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:48052 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab1KUKOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:14:33 -0500
Date: Mon, 21 Nov 2011 15:44:20 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Vivek Goyal <vgoyal@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis.Kletnieks@vt.edu, Nick Bowler <nbowler@elliptictech.com>
Subject: [RFC Patch 2/2][slimdump][makedumpfile] Recognise PANIC_MCE crashes
 to generate slimdu
Message-ID: <20111121101420.GB10194@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20111121095405.GA2289@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121095405.GA2289@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11112100-7014-0000-0000-0000001D6E5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that the kernel indicates the cause of crash through a new field
CRASH_REASON in the VMCOREINFO elf-note, recognise the same. For crashes
caused by PANIC_MCE, avoid capture of kernel memory, instead generate
only a slimdump.

Since 'slimdump' will be of very small size (containing only elf-headers and
elf-notes section), the resultant coredump will be of ELF type (and not
kdump-compressed format).

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 elf_info.c     |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 elf_info.h     |    2 +
 makedumpfile.c |   13 ++++++++++-
 makedumpfile.h |    1 +
 4 files changed, 82 insertions(+), 1 deletions(-)

diff --git a/elf_info.c b/elf_info.c
index 114dd05..a925484 100644
--- a/elf_info.c
+++ b/elf_info.c
@@ -287,6 +287,73 @@ offset_note_desc(void *note)
 	return offset;
 }
 
+#define CRASH_REASON_PANIC_MCE	"CRASH_REASON=PANIC_MCE"
+
+/*
+ * This function checks if the vmcoreinfo note has its CRASH_REASON set as
+ * PANIC_MCE. This is added if the crash is due to a hardware error and
+ * when it makes no sense to read/store the crashing kernel's memory. In
+ * such a case, only a 'slimdump' is captured.
+ */
+int
+is_crash_by_mce(void)
+{
+	int note_size, ret = FALSE;
+	off_t offset;
+	char buf[VMCOREINFO_XEN_NOTE_NAME_BYTES];
+	char note[MAX_SIZE_NHDR];
+	void *vmcoreinfo_note = NULL;
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
+
+		if (read(fd_memory, &buf, sizeof(buf)) != sizeof(buf)) {
+			ERRMSG("Can't read the dump memory(%s). %s\n",
+			    name_memory, strerror(errno));
+			return FALSE;
+		}
+		if (strncmp(VMCOREINFO_NOTE_NAME, buf,
+				VMCOREINFO_NOTE_NAME_BYTES)) {
+			offset += offset_next_note(note);
+			continue;
+		}
+
+		/*
+		 * Now copy VMCOREINFO_NOTE to examine its contents.
+		 * We need to parse it to check if the CRASH_REASON=PANIC_MCE.
+		 */
+		note_size = offset_next_note(note);
+
+		vmcoreinfo_note = malloc(note_size);
+		if(!vmcoreinfo_note) {
+			ERRMSG("Can't allocate memory for the vmcoreinfo note."
+				"%s\n", strerror(errno));
+			return FALSE;
+		}
+		if (read(fd_memory, vmcoreinfo_note, note_size) != note_size) {
+			ERRMSG("Can't read the dump memory(%s). %s\n",
+			    name_memory, strerror(errno));
+			goto exit;
+		}
+		if(strstr(vmcoreinfo_note, CRASH_REASON_PANIC_MCE))
+			ret = TRUE;
+			break;
+	}
+exit:
+	free(vmcoreinfo_note);
+	return ret;
+}
+
 static int
 get_pt_note_info(void)
 {
diff --git a/elf_info.h b/elf_info.h
index 4dff9c1..0437481 100644
--- a/elf_info.h
+++ b/elf_info.h
@@ -34,6 +34,8 @@ unsigned long long get_max_paddr(void);
 int get_elf64_ehdr(int fd, char *filename, Elf64_Ehdr *ehdr);
 int get_elf32_ehdr(int fd, char *filename, Elf32_Ehdr *ehdr);
 int get_elf_info(int fd, char *filename);
+int is_crash_by_mce(void);
+
 void free_elf_info(void);
 
 int is_elf64_memory(void);
diff --git a/makedumpfile.c b/makedumpfile.c
index 7b7c266..15efa90 100644
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
+	info->flag_nocoredump = info->flag_elf_dumpfile = is_crash_by_mce();
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

