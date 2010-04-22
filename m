Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab0DVQXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:23:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45177 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0DVQXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:23:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=W/Do6X7Nw1p0dhQPeykJ0ZBUR2Na98Mk/m6UJkfOJxHt+XjqqZVPuiwNOBx7MVRSpd
         aea3MUyF0R9yud7M0an5YxnHiq8d3vd4DyMc1e8bNPaGBZN8YCJ0oh8L9FIRJLm6kw6Y
         ZeqlAKJY7xTmC+f0nY0wgJM+rIoAn1l9JlUM4=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       Haren Myneni <hbabu@us.ibm.com>, Eric Biederman <ebiederm@xmission.com>,
       Neil Horman <nhorman@tuxdriver.com>, Cong Wang <amwang@redhat.com>,
       kexec@lists.infradead.org
Subject: [PATCH 2/5] Modify parse_crashkernel* for new syntax
Date: Thu, 22 Apr 2010 18:23:09 +0200
Message-Id: <1271953392-6324-3-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com>
References: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crashkernel= syntax of kernel command line was extended to allow
reservation of two memory regions for dump-capture kernel.

Syntax for simple case was changed from

    crashkernel=size[@offset]

to

    crashkernel=<low>/<high>

Where <low> and <high> are memory regions for dump-capture kernel in
usual crashkernel format (size@offset).

Crashkernel syntax, involving conditional reservation based on memory
size, was changed from

    crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]

to

    crashkernel=<range1>:<low_size1>[/<high_size1>]
                [,<range2>:<low_size2>[/high_size2],...]
                [@low_offset][/high_offset]

New syntax is backward compatible.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 include/linux/kexec.h |    5 ++
 kernel/kexec.c        |  116 +++++++++++++++++++++++++++++++++++++------------
 2 files changed, 93 insertions(+), 28 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 1a3b0a3..d2063f8 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -207,6 +207,11 @@ extern size_t vmcoreinfo_max_size;
 
 int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
+int __init parse_crashkernel_ext(char *cmdline, unsigned long long system_ram,
+				 unsigned long long *crash_size,
+				 unsigned long long *crash_base,
+				 unsigned long long *crash_size_hi,
+				 unsigned long long *crash_base_hi);
 int crash_shrink_memory(unsigned long new_size);
 size_t crash_get_memory_size(void);
 
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 1bd0199..b8fd6eb 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1229,23 +1229,42 @@ module_init(crash_notes_memory_init)
  */
 
 
+static char * __init parse_crashkernel_region(char		*cmdline,
+					     unsigned long long	*crash_size,
+					     unsigned long long	*crash_base)
+{
+	char *cur = cmdline;
+
+	*crash_size = memparse(cmdline, &cur);
+	if (cmdline == cur) {
+		pr_warning("crashkernel: memory value expected\n");
+		return 0;
+	}
+
+	if (*cur == '@')
+		*crash_base = memparse(cur + 1, &cur);
+	return cur;
+}
+
 /*
  * This function parses command lines in the format
  *
- *   crashkernel=ramsize-range:size[,...][@offset]
+ *   crashkernel=ramsize-range:size[/size2][,...][@offset][/offset2]
  *
  * The function returns 0 on success and -EINVAL on failure.
  */
-static int __init parse_crashkernel_mem(char 			*cmdline,
+static int __init parse_crashkernel_mem(char			*cmdline,
 					unsigned long long	system_ram,
 					unsigned long long	*crash_size,
-					unsigned long long	*crash_base)
+					unsigned long long	*crash_base,
+					unsigned long long	*crash_size_hi,
+					unsigned long long	*crash_base_hi)
 {
 	char *cur = cmdline, *tmp;
 
 	/* for each entry of the comma-separated list */
 	do {
-		unsigned long long start, end = ULLONG_MAX, size;
+		unsigned long long start, end = ULLONG_MAX, size, size_hi;
 
 		/* get the start of the range */
 		start = memparse(cur, &tmp);
@@ -1287,6 +1306,17 @@ static int __init parse_crashkernel_mem(char 			*cmdline,
 			return -EINVAL;
 		}
 		cur = tmp;
+
+		if (*cur == '/') {
+			cur++;
+			size_hi = memparse(cur, &tmp);
+			if (cur == tmp) {
+				pr_warning("Memory value expected\n");
+				return -EINVAL;
+			}
+			cur = tmp;
+		}
+
 		if (size >= system_ram) {
 			pr_warning("crashkernel: invalid size\n");
 			return -EINVAL;
@@ -1295,6 +1325,8 @@ static int __init parse_crashkernel_mem(char 			*cmdline,
 		/* match ? */
 		if (system_ram >= start && system_ram < end) {
 			*crash_size = size;
+			if (crash_size_hi)
+				*crash_size_hi = size_hi;
 			break;
 		}
 	} while (*cur++ == ',');
@@ -1310,6 +1342,17 @@ static int __init parse_crashkernel_mem(char 			*cmdline,
 						"after '@'\n");
 				return -EINVAL;
 			}
+			cur = tmp;
+			if (*cur == '/') {
+				cur++;
+				if (crash_base_hi)
+					*crash_base_hi = memparse(cur, &tmp);
+				if (cur == tmp) {
+					pr_warning("Memory value expected "
+						   "after '@'\n");
+					return -EINVAL;
+				}
+			}
 		}
 	}
 
@@ -1319,43 +1362,46 @@ static int __init parse_crashkernel_mem(char 			*cmdline,
 /*
  * That function parses "simple" (old) crashkernel command lines like
  *
- * 	crashkernel=size[@offset]
+ *	crashkernel=size[@offset][/size_hi][@offset_hi]
  *
  * It returns 0 on success and -EINVAL on failure.
  */
-static int __init parse_crashkernel_simple(char 		*cmdline,
-					   unsigned long long 	*crash_size,
-					   unsigned long long 	*crash_base)
+static int __init parse_crashkernel_simple(char			*cmdline,
+					   unsigned long long	*crash_size,
+					   unsigned long long	*crash_base,
+					   unsigned long long	*crash_size_hi,
+					   unsigned long long	*crash_base_hi)
 {
-	char *cur = cmdline;
+	char *cur = parse_crashkernel_region(cmdline, crash_size, crash_base);
 
-	*crash_size = memparse(cmdline, &cur);
-	if (cmdline == cur) {
-		pr_warning("crashkernel: memory value expected\n");
+	if (!cur) {
 		return -EINVAL;
+	} else if (*cur == '/' && crash_size_hi && crash_base_hi) {
+		cur = parse_crashkernel_region(cur + 1, crash_size_hi,
+					       crash_base_hi);
+		if (!cur)
+			return -EINVAL;
 	}
-
-	if (*cur == '@')
-		*crash_base = memparse(cur+1, &cur);
-
 	return 0;
 }
 
-/*
- * That function is the entry point for command line parsing and should be
- * called from the arch-specific code.
- */
-int __init parse_crashkernel(char 		 *cmdline,
-			     unsigned long long system_ram,
-			     unsigned long long *crash_size,
-			     unsigned long long *crash_base)
+int __init parse_crashkernel_ext(char		 *cmdline,
+				 unsigned long long system_ram,
+				 unsigned long long *crash_size,
+				 unsigned long long *crash_base,
+				 unsigned long long *crash_size_hi,
+				 unsigned long long *crash_base_hi)
 {
-	char 	*p = cmdline, *ck_cmdline = NULL;
+	char	*p = cmdline, *ck_cmdline = NULL;
 	char	*first_colon, *first_space;
 
 	BUG_ON(!crash_size || !crash_base);
 	*crash_size = 0;
 	*crash_base = 0;
+	if (crash_size_hi)
+		*crash_size_hi = 0;
+	if (crash_base_hi)
+		*crash_base_hi = 0;
 
 	/* find crashkernel and use the last one if there are more */
 	p = strstr(p, "crashkernel=");
@@ -1377,15 +1423,29 @@ int __init parse_crashkernel(char 		 *cmdline,
 	first_space = strchr(ck_cmdline, ' ');
 	if (first_colon && (!first_space || first_colon < first_space))
 		return parse_crashkernel_mem(ck_cmdline, system_ram,
-				crash_size, crash_base);
+					     crash_size, crash_base,
+					     crash_size_hi, crash_base_hi);
 	else
 		return parse_crashkernel_simple(ck_cmdline, crash_size,
-				crash_base);
+						crash_base, crash_size_hi,
+						crash_base_hi);
 
 	return 0;
 }
 
-
+/*
+ * That function is the entry point for command line parsing and should be
+ * called from the arch-specific code.
+ */
+int __init parse_crashkernel(char		 *cmdline,
+			     unsigned long long system_ram,
+			     unsigned long long *crash_size,
+			     unsigned long long *crash_base)
+{
+	return parse_crashkernel_ext(cmdline, system_ram,
+				     crash_size, crash_base,
+				     0, 0);
+}
 
 void crash_save_vmcoreinfo(void)
 {
-- 
1.7.0.1

