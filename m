Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1AYCIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 21:08:12 -0500
Received: from smtp.outflux.net ([198.145.64.163]:44688 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab1AYCIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 21:08:10 -0500
Date: Mon, 24 Jan 2011 18:07:55 -0800
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
Subject: [PATCH 2/2] use %pK and %Klx for /proc/kallsyms and /proc/modules
Message-ID: <20110125020755.GM4979@outflux.net>
References: <20110125020321.GK4979@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125020321.GK4979@outflux.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of messing with permissions on these files, use %pK and %Klx
for kernel addresses to reduce potential information leaks that might
be used to help target kernel privilege escalation exploits.

Note that instead of changing %x to %p, this introduces the "K" flag
to printf numbers. Without this, some legitimately 0x0 values
in /proc/kallsyms would have changed from 00000000 to "(null)".

However, build-time warnings are emitted when built with -Wformat
  warning: unknown conversion type character 'K' in format
even though it produced sensible results.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 kernel/kallsyms.c |    4 ++--
 kernel/module.c   |    4 ++--
 lib/vsprintf.c    |   23 +++++++++++++++++++++++
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 6f6d091..080294d 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -477,11 +477,11 @@ static int s_show(struct seq_file *m, void *p)
 		 */
 		type = iter->exported ? toupper(iter->type) :
 					tolower(iter->type);
-		seq_printf(m, "%0*lx %c %s\t[%s]\n",
+		seq_printf(m, "%K0*lx %c %s\t[%s]\n",
 			   (int)(2 * sizeof(void *)),
 			   iter->value, type, iter->name, iter->module_name);
 	} else
-		seq_printf(m, "%0*lx %c %s\n",
+		seq_printf(m, "%K0*lx %c %s\n",
 			   (int)(2 * sizeof(void *)),
 			   iter->value, iter->type, iter->name);
 	return 0;
diff --git a/kernel/module.c b/kernel/module.c
index 34e00b7..0f46775 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1168,7 +1168,7 @@ static ssize_t module_sect_show(struct module_attribute *mattr,
 {
 	struct module_sect_attr *sattr =
 		container_of(mattr, struct module_sect_attr, mattr);
-	return sprintf(buf, "0x%lx\n", sattr->address);
+	return sprintf(buf, "0x%Klx\n", sattr->address);
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
index d3023df..736c174 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -382,6 +382,7 @@ char *put_dec(char *buf, unsigned long long num)
 #define LEFT	16		/* left justified */
 #define SMALL	32		/* use lowercase in hex (must be 32 == 0x20) */
 #define SPECIAL	64		/* prefix hex with "0x", octal with "0" */
+#define HIDEVAL	128		/* only CAP_SYSLOG can see real value */
 
 enum format_type {
 	FORMAT_TYPE_NONE, /* Just a string part */
@@ -416,6 +417,9 @@ struct printf_spec {
 };
 
 static noinline_for_stack
+char *string(char *buf, char *end, const char *s, struct printf_spec spec);
+
+static noinline_for_stack
 char *number(char *buf, char *end, unsigned long long num,
 	     struct printf_spec spec)
 {
@@ -428,6 +432,24 @@ char *number(char *buf, char *end, unsigned long long num,
 	int need_pfx = ((spec.flags & SPECIAL) && spec.base != 10);
 	int i;
 
+	if (spec.flags & HIDEVAL) {
+		/*
+		 * HIDEVAL cannot be used in IRQ context because its test
+		 * for CAP_SYSLOG would be meaningless.
+		 */
+		if (in_irq() || in_serving_softirq() || in_nmi()) {
+			if (spec.field_width == -1)
+				spec.field_width = 2 * sizeof(void *);
+			return string(buf, end, "K-error", spec);
+		} else if ((kptr_restrict == 0) ||
+			 (kptr_restrict == 1 &&
+			  has_capability_noaudit(current, CAP_SYSLOG))) {
+			/* do not hide value */
+		} else {
+			num = 0;
+		}
+	}
+
 	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
 	 * produces same digits or (maybe lowercased) letters */
 	locase = (spec.flags & SMALL);
@@ -1138,6 +1160,7 @@ int format_decode(const char *fmt, struct printf_spec *spec)
 		case ' ': spec->flags |= SPACE;   break;
 		case '#': spec->flags |= SPECIAL; break;
 		case '0': spec->flags |= ZEROPAD; break;
+		case 'K': spec->flags |= HIDEVAL; break;
 		default:  found = false;
 		}
 
-- 
1.7.2.3


-- 
Kees Cook
Ubuntu Security Team
