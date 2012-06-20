Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab2FTWXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:23:11 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4254 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab2FTWXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:23:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Jun 2012 15:19:54 -0700
Message-ID: <4FE24D31.3070608@nvidia.com>
Date: Wed, 20 Jun 2012 15:22:41 -0700
From: "Pierre-Loup A. Griffais" <pgriffais@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@ghostprotocols.net>, <torvalds@linux-foundation.org>,
        Mike Sartain <mikesart@valvesoftware.com>
Subject: [PATCH] perf symbols: Follow .gnu_debuglink section to find separate
 symbols
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .gnu_debuglink section is specified to contain the filename of the
debug info file, as well as a CRC that can be used to validate it.

This doesn't currently use the checksum and relies on the usual build-id
matching for validation.

This provides more context:
http://sourceware.org/gdb/onlinedocs/gdb/Separate-Debug-Files.html

Signed-off-by: Pierre-Loup A. Griffais <pgriffais@nvidia.com>
Reported-by: Mike Sartain <mikesart@valvesoftware.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 tools/perf/util/symbol.c |   65 +++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/symbol.h |    1 +
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 3e2e5ea..4788092 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1590,11 +1590,62 @@ out:
 	return err;
 }
 
+static int filename__read_debuglink(const char *filename,
+				    char *path, size_t size)
+{
+	int fd, err = -1;
+	Elf *elf;
+	GElf_Ehdr ehdr;
+	GElf_Shdr shdr;
+	Elf_Data *data;
+	Elf_Scn *sec;
+	Elf_Kind ek;
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0)
+		goto out;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL) {
+		pr_debug2("%s: cannot read %s ELF file.\n", __func__, filename);
+		goto out_close;
+	}
+
+	ek = elf_kind(elf);
+	if (ek != ELF_K_ELF)
+		goto out_close;
+
+	if (gelf_getehdr(elf, &ehdr) == NULL) {
+		pr_err("%s: cannot get elf header.\n", __func__);
+		goto out_close;
+	}
+
+	sec = elf_section_by_name(elf, &ehdr, &shdr,
+				  ".gnu_debuglink", NULL);
+	if (sec == NULL)
+		goto out_close;
+
+	data = elf_getdata(sec, NULL);
+	if (data == NULL)
+		goto out_close;
+
+	/* the start of this section is a zero-terminated string */
+	strncpy(path, data->d_buf, size);
+
+	elf_end(elf);
+
+out_close:
+	close(fd);
+out:
+	return err;
+}
+
 char dso__symtab_origin(const struct dso *dso)
 {
 	static const char origin[] = {
 		[SYMTAB__KALLSYMS]	      = 'k',
 		[SYMTAB__JAVA_JIT]	      = 'j',
+		[SYMTAB__DEBUGLINK]           = 'l',
 		[SYMTAB__BUILD_ID_CACHE]      = 'B',
 		[SYMTAB__FEDORA_DEBUGINFO]    = 'f',
 		[SYMTAB__UBUNTU_DEBUGINFO]    = 'u',
@@ -1662,10 +1713,22 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	 */
 	want_symtab = 1;
 restart:
-	for (dso->symtab_type = SYMTAB__BUILD_ID_CACHE;
+	for (dso->symtab_type = SYMTAB__DEBUGLINK;
 	     dso->symtab_type != SYMTAB__NOT_FOUND;
 	     dso->symtab_type++) {
 		switch (dso->symtab_type) {
+		case SYMTAB__DEBUGLINK: {
+			char *last_slash;
+			strncpy(name, dso->long_name, size);
+			last_slash = name + dso->long_name_len;
+			while (last_slash && *last_slash != '/')
+				last_slash--;
+			if (last_slash)
+				last_slash++;
+			filename__read_debuglink(dso->long_name, last_slash,
+						 size - (last_slash - name));
+			}
+			break;
 		case SYMTAB__BUILD_ID_CACHE:
 			/* skip the locally configured cache if a symfs is given */
 			if (symbol_conf.symfs[0] ||
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index af0752b..a884b99 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -257,6 +257,7 @@ enum symtab_type {
 	SYMTAB__KALLSYMS = 0,
 	SYMTAB__GUEST_KALLSYMS,
 	SYMTAB__JAVA_JIT,
+	SYMTAB__DEBUGLINK,
 	SYMTAB__BUILD_ID_CACHE,
 	SYMTAB__FEDORA_DEBUGINFO,
 	SYMTAB__UBUNTU_DEBUGINFO,
-- 
1.7.9.5
