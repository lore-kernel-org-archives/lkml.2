Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab1KUKs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:48:59 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35475 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab1KUKs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:48:57 -0500
From: Dave Martin <dave.martin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, linux-arm-kernel@lists.infradead.org,
        Dave Martin <dave.martin@linaro.org>
Subject: [PATCH 2/2] ARM: amba: Auto-generate AMBA driver module aliases during modpost
Date: Mon, 21 Nov 2011 10:48:30 +0000
Message-Id: <1321872510-2562-3-git-send-email-dave.martin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1321872510-2562-1-git-send-email-dave.martin@linaro.org>
References: <1321872510-2562-1-git-send-email-dave.martin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary support in file2alias.c to define
suitable aliases based on the amba_id table in AMBA driver modules.

This should be sufficient to allow such modules to be auto-loaded
via udev.  The AMBA bus driver's uevent hotplug code is also
modified to pass an approriate MODALIAS string in the event.

For simplicity, the AMBA ID is treated an an opaque 32-bit numeber.
Module alises use patterns as appropriate to describe the value-
mask pairs described in the driver's amba_id list.

The proposed alias format is (extended regex):

    ^amba:d(HEX){8}$

Where HEX is a single upper-case HEX digit or a pattern (? or []
expression) matching a single upper-case HEX digit, as expected by
udev.

"d" is short for "device", following existing alias naming
conventions for other device types.  This adds some flexibility for
unambiguously extending the alias format in the future by adding
additional leading and trailing fields, if this turns out to be
necessary.

Signed-off-by: Dave Martin <dave.martin@linaro.org>
Acked-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/amba/bus.c       |    9 +++++-
 scripts/mod/file2alias.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index bd230e8..a8c598c 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -52,7 +52,14 @@ static int amba_uevent(struct device *dev, struct kobj_uevent_env *env)
 	int retval = 0;
 
 	retval = add_uevent_var(env, "AMBA_ID=%08x", pcdev->periphid);
-	return retval;
+	if (retval)
+		return retval;
+
+	retval = add_uevent_var(env, "MODALIAS=amba:d%08X", pcdev->periphid);
+	if (retval)
+		return retval;
+
+	return 0;
 }
 #else
 #define amba_uevent NULL
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index f936d1f..363ab46 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -880,6 +880,74 @@ static int do_isapnp_entry(const char *filename,
 	return 1;
 }
 
+/*
+ * Append a match expression for a single masked hex digit.
+ * outp points to a pointer to the character at which to append.
+ *	*outp is updated on return to point just after the appended text,
+ *	to facilitate further appending.
+ */
+static void append_nibble_mask(char **outp,
+			       unsigned int nibble, unsigned int mask)
+{
+	char *p = *outp;
+	unsigned int i;
+
+	switch (mask) {
+	case 0:
+		*p++ = '?';
+		break;
+
+	case 0xf:
+		p += sprintf(p, "%X",  nibble);
+		break;
+
+	default:
+		/*
+		 * Dumbly emit a match pattern for all possible matching
+		 * digits.  This could be improved in some cases using ranges,
+		 * but it has the advantage of being trivially correct, and is
+		 * often optimal.
+		 */
+		*p++ = '[';
+		for (i = 0; i < 0x10; i++)
+			if ((i & mask) == nibble)
+				p += sprintf(p, "%X", i);
+		*p++ = ']';
+	}
+
+	/* Ensure that the string remains NUL-terminated: */
+	*p = '\0';
+
+	/* Advance the caller's end-of-string pointer: */
+	*outp = p;
+}
+
+/*
+ * looks like: "amba:dN"
+ *
+ * N is exactly 8 digits, where each is an upper-case hex digit, or
+ *	a ? or [] pattern matching exactly one digit.
+ */
+static int do_amba_entry(const char *filename,
+			 struct amba_id *id, char *alias)
+{
+	unsigned int digit;
+	char *p = alias;
+
+	if ((id->id & id->mask) != id->id)
+		fatal("%s: Masked-off bit(s) of AMBA device ID are non-zero: "
+		      "id=0x%08X, mask=0x%08X.  Please fix this driver.\n",
+		      filename, id->id, id->mask);
+
+	p += sprintf(alias, "amba:d");
+	for (digit = 0; digit < 8; digit++)
+		append_nibble_mask(&p,
+				   (id->id >> (4 * (7 - digit))) & 0xf,
+				   (id->mask >> (4 * (7 - digit))) & 0xf);
+
+	return 1;
+}
+
 /* Ignore any prefix, eg. some architectures prepend _ */
 static inline int sym_is(const char *symbol, const char *name)
 {
@@ -1047,6 +1115,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 		do_table(symval, sym->st_size,
 			sizeof(struct isapnp_device_id), "isa",
 			do_isapnp_entry, mod);
+	else if (sym_is(symname, "__mod_amba_device_table"))
+		do_table(symval, sym->st_size,
+			sizeof(struct amba_id), "amba",
+			do_amba_entry, mod);
 	free(zeros);
 }
 
-- 
1.7.4.1

