Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab1A0AmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:42:13 -0500
Received: from smtp.outflux.net ([198.145.64.163]:60471 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab1A0AmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:42:12 -0500
Date: Wed, 26 Jan 2011 16:41:29 -0800
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, Marcus Meissner <meissner@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Eugene Teo <eugeneteo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>,
        Changli Gao <xiaosuo@gmail.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>
Subject: [PATCH v2] use %pK for /proc/kallsyms and /proc/modules
Message-ID: <20110127004129.GH4981@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In an effort to reduce kernel address leaks that might be used to
help target kernel privilege escalation exploits, this patch uses
%pK when displaying addresses in /proc/kallsyms, /proc/modules, and
/sys/module/*/sections/*.

Note that this changes %x to %p, so some legitimately 0 values in
/proc/kallsyms would have changed from 00000000 to "(null)". To avoid
this, "(null)" is not used when using the "K" format. Anything that was
already successfully parsing "(null)" in addition to full hex digits
should have no problem with this change. (Thanks to Joe Perches for
the suggestion.)

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
v2:
 - ditch %0* with 2*sizeof(void*) prefixing since %p is already rendered
   to that width, thanks to Joe Perches.

---
 kernel/kallsyms.c |    6 ++----
 kernel/module.c   |    4 ++--
 lib/vsprintf.c    |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 6f6d091..ff37fbd 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -477,12 +477,10 @@ static int s_show(struct seq_file *m, void *p)
 		 */
 		type = iter->exported ? toupper(iter->type) :
 					tolower(iter->type);
-		seq_printf(m, "%0*lx %c %s\t[%s]\n",
-			   (int)(2 * sizeof(void *)),
+		seq_printf(m, "%pK %c %s\t[%s]\n",
 			   iter->value, type, iter->name, iter->module_name);
 	} else
-		seq_printf(m, "%0*lx %c %s\n",
-			   (int)(2 * sizeof(void *)),
+		seq_printf(m, "%pK %c %s\n",
 			   iter->value, iter->type, iter->name);
 	return 0;
 }
diff --git a/kernel/module.c b/kernel/module.c
index 34e00b7..748465c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1168,7 +1168,7 @@ static ssize_t module_sect_show(struct module_attribute *mattr,
 {
 	struct module_sect_attr *sattr =
 		container_of(mattr, struct module_sect_attr, mattr);
-	return sprintf(buf, "0x%lx\n", sattr->address);
+	return sprintf(buf, "0x%pK\n", sattr->address);
 }
 
 static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
@@ -3224,7 +3224,7 @@ static int m_show(struct seq_file *m, void *p)
 		   mod->state == MODULE_STATE_COMING ? "Loading":
 		   "Live");
 	/* Used by oprofile and other similar tools. */
-	seq_printf(m, " 0x%p", mod->module_core);
+	seq_printf(m, " 0x%pK", mod->module_core);
 
 	/* Taints info */
 	if (mod->taints)
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index d3023df..288d770 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -991,7 +991,7 @@ static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	      struct printf_spec spec)
 {
-	if (!ptr) {
+	if (!ptr && *fmt != 'K') {
 		/*
 		 * Print (null) with the same width as a pointer so it makes
 		 * tabular output look nice.
-- 
1.7.2.3


-- 
Kees Cook
Ubuntu Security Team
