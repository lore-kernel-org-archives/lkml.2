Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab1AYCFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 21:05:11 -0500
Received: from smtp.outflux.net ([198.145.64.163]:45740 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab1AYCFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 21:05:09 -0500
Date: Mon, 24 Jan 2011 18:04:50 -0800
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        Marcus Meissner <meissner@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Eugene Teo <eugeneteo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Len Brown <len.brown@intel.com>, Changli Gao <xiaosuo@gmail.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>
Subject: [PATCH 1/2] use %pK for /proc/kallsyms and /proc/modules
Message-ID: <20110125020450.GL4979@outflux.net>
References: <20110125020321.GK4979@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110125020321.GK4979@outflux.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of messing with permissions on these files, use %pK for kernel
addresses to reduce potential information leaks that might be used to
help target kernel privilege escalation exploits.

Note that this changes %x to %p, so some legitimately 0 values in
/proc/kallsyms will change from 00000000 to "(null)". Additionally, when
compiling with -Wformat, these harmless warnings are emitted:
  warning: '0' flag used with ‘%p’ gnu_printf format

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 kernel/kallsyms.c |    4 ++--
 kernel/module.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 6f6d091..074b762 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -477,11 +477,11 @@ static int s_show(struct seq_file *m, void *p)
 		 */
 		type = iter->exported ? toupper(iter->type) :
 					tolower(iter->type);
-		seq_printf(m, "%0*lx %c %s\t[%s]\n",
+		seq_printf(m, "%0*pK %c %s\t[%s]\n",
 			   (int)(2 * sizeof(void *)),
 			   iter->value, type, iter->name, iter->module_name);
 	} else
-		seq_printf(m, "%0*lx %c %s\n",
+		seq_printf(m, "%0*pK %c %s\n",
 			   (int)(2 * sizeof(void *)),
 			   iter->value, iter->type, iter->name);
 	return 0;
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
-- 
1.7.2.3


-- 
Kees Cook
Ubuntu Security Team
