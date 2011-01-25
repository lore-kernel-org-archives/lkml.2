Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1AYCRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 21:17:09 -0500
Received: from mail.perches.com ([173.55.12.10]:3308 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab1AYCRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 21:17:07 -0500
Subject: Re: RFC: introduce "K" flag for printf, similar to %pK
From: Joe Perches <joe@perches.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, Marcus Meissner <meissner@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Eugene Teo <eugeneteo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>,
        Changli Gao <xiaosuo@gmail.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>
In-Reply-To: <20110125020321.GK4979@outflux.net>
References: <20110125020321.GK4979@outflux.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 18:17:04 -0800
Message-ID: <1295921824.14459.28.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 18:03 -0800, Kees Cook wrote:
> In the interests of hiding kernel addresses from userspace (without
> messing with file permissions), I want to use %pK for /proc/kallsyms and
> /proc/modules, but this results in changing several %x's to %p's. The
> primary side-effects is that some legitimately "0" value things in
> /proc/kallsyms turn into "(null)".
> 
> For example in kernel/kallsyms.c:
> -               seq_printf(m, "%0*lx %c %s\t[%s]\n",
> +               seq_printf(m, "%0*pK %c %s\t[%s]\n",
> 
> This results in /proc/kallsyms looking like this:
>           (null) D irq_stack_union
>           (null) D __per_cpu_start
> 0000000000004000 D gdt_page
> ...
> 
> (Secondary effect is building with -Wformat results in harmless warnings
> "warning: '0' flag used with ‘%p’ gnu_printf format".)
> 
> 
> If, on the other hand, I introduce a printf flag "K" for numbers, the
> original behavior is left, and kernel/kallsyms.c changes like this:
> -               seq_printf(m, "%0*lx %c %s\t[%s]\n",
> +               seq_printf(m, "%K0*lx %c %s\t[%s]\n",

Another option would be to allow '0' for
kernel pointers.

Something like (copy/paste, won't apply):

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -991,7 +991,7 @@ static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
              struct printf_spec spec)
 {
-       if (!ptr) {
+       if (!ptr && *fmt != 'K') {
                /*
                 * Print (null) with the same width as a pointer so it makes
                 * tabular output look nice.


