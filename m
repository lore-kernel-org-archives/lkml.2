Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab1JYEWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 00:22:24 -0400
Received: from ozlabs.org ([203.10.76.45]:35949 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab1JYEWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 00:22:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <rdunlap@xenotime.net>, Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not built in-tree
In-Reply-To: <4EA57CBF.2050901@xenotime.net>
References: <1319461948.31243.31.camel@deadeye> <4EA57CBF.2050901@xenotime.net>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 25 Oct 2011 14:26:13 +1030
Message-ID: <87k47tpvvm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Oct 2011 07:57:03 -0700, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 10/24/11 06:12, Ben Hutchings wrote:
> > Use of the GPL or a compatible licence doesn't necessarily make the code
> > any good.  We already consider staging modules to be suspect, and this
> > should also be true for out-of-tree modules which may receive very
> > little review.
> > 
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> > Debian has been carrying this for the last few kernel versions.  The
> > recent thread '[RFC] virtualbox tainting.' and discussions at KS suggest
> > that this might be more generally useful.
> > 
> > Ben.
> > 
> >  include/linux/kernel.h |    1 +
> >  kernel/module.c        |    5 +++++
> >  kernel/panic.c         |    2 ++
> >  scripts/mod/modpost.c  |    7 +++++++
> >  4 files changed, 15 insertions(+), 0 deletions(-)
> 
> Hi,
> 
> Please add 'O' to Documentation/oops-tracing.txt.

I did that, and applied the patch.  See below.

Thanks,
Rusty.

From: Ben Hutchings <ben@decadent.org.uk>
Subject: module,bug: Add TAINT_OOT_MODULE flag for modules not built in-tree
Date: Mon, 24 Oct 2011 15:12:28 +0200

Use of the GPL or a compatible licence doesn't necessarily make the code
any good.  We already consider staging modules to be suspect, and this
should also be true for out-of-tree modules which may receive very
little review.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Reviewed-by: Dave Jones <davej@redhat.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (patched oops-tracing.txt)
---
 Documentation/oops-tracing.txt |    2 ++
 include/linux/kernel.h         |    1 +
 kernel/module.c                |    5 +++++
 kernel/panic.c                 |    2 ++
 scripts/mod/modpost.c          |    7 +++++++
 5 files changed, 17 insertions(+)

diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
--- a/Documentation/oops-tracing.txt
+++ b/Documentation/oops-tracing.txt
@@ -263,6 +263,8 @@ characters, each representing a particul
  12: 'I' if the kernel is working around a severe bug in the platform
      firmware (BIOS or similar).
 
+ 13: 'O' if an externally-built ("out-of-tree") module has been loaded.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -369,6 +369,7 @@ extern enum system_states {
 #define TAINT_WARN			9
 #define TAINT_CRAP			10
 #define TAINT_FIRMWARE_WORKAROUND	11
+#define TAINT_OOT_MODULE		12
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2487,6 +2487,9 @@ static int check_modinfo(struct module *
 		return -ENOEXEC;
 	}
 
+	if (!get_modinfo(info, "intree"))
+		add_taint_module(mod, TAINT_OOT_MODULE);
+
 	if (get_modinfo(info, "staging")) {
 		add_taint_module(mod, TAINT_CRAP);
 		printk(KERN_WARNING "%s: module is from the staging directory,"
@@ -3257,6 +3260,8 @@ static char *module_flags(struct module 
 		buf[bx++] = '(';
 		if (mod->taints & (1 << TAINT_PROPRIETARY_MODULE))
 			buf[bx++] = 'P';
+		else if (mod->taints & (1 << TAINT_OOT_MODULE))
+			buf[bx++] = 'O';
 		if (mod->taints & (1 << TAINT_FORCED_MODULE))
 			buf[bx++] = 'F';
 		if (mod->taints & (1 << TAINT_CRAP))
diff --git a/kernel/panic.c b/kernel/panic.c
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -177,6 +177,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_WARN,			'W', ' ' },
 	{ TAINT_CRAP,			'C', ' ' },
 	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
+	{ TAINT_OOT_MODULE,		'O', ' ' },
 };
 
 /**
@@ -194,6 +195,7 @@ static const struct tnt tnts[] = {
  *  'W' - Taint on warning.
  *  'C' - modules from drivers/staging are loaded.
  *  'I' - Working around severe firmware bug.
+ *  'O' - Out-of-tree module has been loaded.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1849,6 +1849,12 @@ static void add_header(struct buffer *b,
 	buf_printf(b, "};\n");
 }
 
+static void add_intree_flag(struct buffer *b, int is_intree)
+{
+	if (is_intree)
+		buf_printf(b, "\nMODULE_INFO(intree, \"Y\");\n");
+}
+
 static void add_staging_flag(struct buffer *b, const char *name)
 {
 	static const char *staging_dir = "drivers/staging";
@@ -2169,6 +2175,7 @@ int main(int argc, char **argv)
 		buf.pos = 0;
 
 		add_header(&buf, mod);
+		add_intree_flag(&buf, !external_module);
 		add_staging_flag(&buf, mod->name);
 		err |= add_versions(&buf, mod);
 		add_depends(&buf, mod, modules);
