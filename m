Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855Ab2EJXoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:44:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007Ab2EJXn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:43:59 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/29] MODSIGN: Produce a filtered and canonicalised section
 list [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:43:49 +0100
Message-ID: <20120510234349.4137.40185.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build a list of the sections in which we're interested and canonicalise the
section indices to avoid the problems of the section table being altered by ld
when the signature is linked into the binary and by strip.

The only sections in which we're actually interested are those that are marked
allocatable (which will be kept in memory) and relocation tables that are
applicable to those sections.

Canonicalisation is done by sorting the filtered list in order of section name.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/module-verify.c |   80 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 80 insertions(+), 0 deletions(-)


diff --git a/kernel/module-verify.c b/kernel/module-verify.c
index 5711aeb..13c60c2 100644
--- a/kernel/module-verify.c
+++ b/kernel/module-verify.c
@@ -268,6 +268,80 @@ symcheck_error:
 }
 
 /*
+ * Canonicalise the section table index numbers.
+ *
+ * We build a list of the sections we want to add to the digest and sort it by
+ * name.  We're only interested in adding two types of section:
+ *
+ *  (1) Allocatable sections.  These should have no references to other
+ *      sections.
+ *
+ *  (2) Relocation tables for allocatable sections.  The section table entry
+ *      has a reference to the target section to which the relocations will be
+ *      applied.  The relocation entries have references to symbols in
+ *      non-allocatable sections.  Symbols can be replaced by their contents,
+ *      but do include a further reference to a section - which must be
+ *      canonicalised.
+ *
+ * We also build a map of raw section index to canonical section index.
+ */
+static int module_verify_canonicalise(struct module_verify_data *mvdata)
+{
+	const Elf_Shdr *sechdrs = mvdata->sections;
+	unsigned *canonlist, canon, loop, tmp;
+	bool changed;
+
+	canonlist = kmalloc(sizeof(unsigned) * mvdata->nsects * 2, GFP_KERNEL);
+	if (!canonlist)
+		return -ENOMEM;
+
+	mvdata->canonlist = canonlist;
+	mvdata->canonmap = canonlist + mvdata->nsects;
+	canon = 0;
+
+	for (loop = 1; loop < mvdata->nsects; loop++) {
+		const Elf_Shdr *section = mvdata->sections + loop;
+
+		if (loop == mvdata->sig_index)
+			continue;
+
+		/* We only want allocatable sections and relocation tables */
+		if (section->sh_flags & SHF_ALLOC)
+			canonlist[canon++] = loop;
+		else if ((is_elf_rel(section->sh_type) ||
+			  is_elf_rela(section->sh_type)) &&
+			 mvdata->sections[section->sh_info].sh_flags & SHF_ALLOC)
+			canonlist[canon++] = loop;
+	}
+
+	/* Sort the canonicalisation list */
+	do {
+		changed = false;
+
+		for (loop = 0; loop < canon - 1; loop++) {
+			const char *x, *y;
+
+			x = mvdata->secstrings + sechdrs[canonlist[loop + 0]].sh_name;
+			y = mvdata->secstrings + sechdrs[canonlist[loop + 1]].sh_name;
+
+			if (strcmp(x, y) > 0) {
+				tmp = canonlist[loop + 0];
+				canonlist[loop + 0] = canonlist[loop + 1];
+				canonlist[loop + 1] = tmp;
+				changed = true;
+			}
+		}
+	} while (changed);
+
+	/* What we really want is a raw-to-canon lookup table */
+	memset(mvdata->canonmap, 0xff, mvdata->nsects * sizeof(unsigned));
+	for (loop = 0; loop < canon; loop++)
+		mvdata->canonmap[mvdata->canonlist[loop]] = loop + 1;
+	mvdata->ncanon = canon;
+	return 0;
+}
+
+/*
  * Verify a module's integrity
  */
 int module_verify(const Elf_Ehdr *hdr, size_t size, bool *_gpgsig_ok)
@@ -298,7 +372,13 @@ int module_verify(const Elf_Ehdr *hdr, size_t size, bool *_gpgsig_ok)
 		goto out;
 	}
 
+	/* Produce a canonicalisation map for the sections */
+	ret = module_verify_canonicalise(&mvdata);
+	if (ret < 0)
+		goto out;
+
 	ret = 0;
+	kfree(mvdata.canonlist);
 
 out:
 	switch (ret) {

