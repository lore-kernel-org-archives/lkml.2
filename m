Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab2IKWRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:17:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2IKWRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:17:41 -0400
Date: Tue, 11 Sep 2012 15:17:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        Alex Kelly <alex.page.kelly@gmail.com>
Subject: Re: mmotm 2012-09-06-16-46 uploaded (fs/binfmt_aout)
Message-Id: <20120911151739.cb5f2f4b.akpm@linux-foundation.org>
In-Reply-To: <504A8707.8080507@xenotime.net>
References: <20120906234735.1B54B20004E@hpza10.eem.corp.google.com>
	<504A8707.8080507@xenotime.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Sep 2012 16:45:11 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 09/06/2012 04:47 PM, akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2012-09-06-16-46 has been uploaded to
> > 
> >    http://www.ozlabs.org/~akpm/mmotm/
> > 
> 
> 
> when CONFIG_COREDUMP is not enabled:
> 
> ERROR: "dump_seek" [fs/binfmt_aout.ko] undefined!
> ERROR: "dump_write" [fs/binfmt_aout.ko] undefined!

Thanks.  I guess we make aout_core_dump() disappear if
CONFIG_COREDUMP=n.

--- a/fs/binfmt_aout.c~coredump-make-core-dump-functionality-optional-fix-fix
+++ a/fs/binfmt_aout.c
@@ -32,31 +32,8 @@
 
 static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout_library(struct file*);
-static int aout_core_dump(struct coredump_params *cprm);
-
-static struct linux_binfmt aout_format = {
-	.module		= THIS_MODULE,
-	.load_binary	= load_aout_binary,
-	.load_shlib	= load_aout_library,
-	.core_dump	= aout_core_dump,
-	.min_coredump	= PAGE_SIZE
-};
-
-#define BAD_ADDR(x)	((unsigned long)(x) >= TASK_SIZE)
-
-static int set_brk(unsigned long start, unsigned long end)
-{
-	start = PAGE_ALIGN(start);
-	end = PAGE_ALIGN(end);
-	if (end > start) {
-		unsigned long addr;
-		addr = vm_brk(start, end - start);
-		if (BAD_ADDR(addr))
-			return addr;
-	}
-	return 0;
-}
 
+#ifdef CONFIG_COREDUMP
 /*
  * Routine writes a core dump image in the current directory.
  * Currently only a stub-function.
@@ -66,7 +43,6 @@ static int set_brk(unsigned long start, 
  * field, which also makes sure the core-dumps won't be recursive if the
  * dumping of the process results in another error..
  */
-
 static int aout_core_dump(struct coredump_params *cprm)
 {
 	struct file *file = cprm->file;
@@ -135,6 +111,32 @@ end_coredump:
 	set_fs(fs);
 	return has_dumped;
 }
+#else
+#define aout_core_dump NULL
+#endif
+
+static struct linux_binfmt aout_format = {
+	.module		= THIS_MODULE,
+	.load_binary	= load_aout_binary,
+	.load_shlib	= load_aout_library,
+	.core_dump	= aout_core_dump,
+	.min_coredump	= PAGE_SIZE
+};
+
+#define BAD_ADDR(x)	((unsigned long)(x) >= TASK_SIZE)
+
+static int set_brk(unsigned long start, unsigned long end)
+{
+	start = PAGE_ALIGN(start);
+	end = PAGE_ALIGN(end);
+	if (end > start) {
+		unsigned long addr;
+		addr = vm_brk(start, end - start);
+		if (BAD_ADDR(addr))
+			return addr;
+	}
+	return 0;
+}
 
 /*
  * create_aout_tables() parses the env- and arg-strings in new user
_

