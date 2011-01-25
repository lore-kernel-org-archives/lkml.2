Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab1AYCEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 21:04:14 -0500
Received: from smtp.outflux.net ([198.145.64.163]:52714 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab1AYCEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 21:04:13 -0500
Date: Mon, 24 Jan 2011 18:03:22 -0800
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
Subject: RFC: introduce "K" flag for printf, similar to %pK
Message-ID: <20110125020321.GK4979@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the interests of hiding kernel addresses from userspace (without
messing with file permissions), I want to use %pK for /proc/kallsyms and
/proc/modules, but this results in changing several %x's to %p's. The
primary side-effects is that some legitimately "0" value things in
/proc/kallsyms turn into "(null)".

For example in kernel/kallsyms.c:
-               seq_printf(m, "%0*lx %c %s\t[%s]\n",
+               seq_printf(m, "%0*pK %c %s\t[%s]\n",

This results in /proc/kallsyms looking like this:
          (null) D irq_stack_union
          (null) D __per_cpu_start
0000000000004000 D gdt_page
...

(Secondary effect is building with -Wformat results in harmless warnings
"warning: '0' flag used with ‘%p’ gnu_printf format".)


If, on the other hand, I introduce a printf flag "K" for numbers, the
original behavior is left, and kernel/kallsyms.c changes like this:
-               seq_printf(m, "%0*lx %c %s\t[%s]\n",
+               seq_printf(m, "%K0*lx %c %s\t[%s]\n",

The only side-effect from this is when compiling with -Wformat, now we get
these harmless warnings "warning: unknown conversion type character 'K' in
format", as well as breaking the warning parser, so it can't count arguments
correctly any more "warning: format '%s' expects type 'char *', but
argument 4 has type 'long unsigned int'" etc.

I'm not very happy with either situation, but I'll reply to this email
with both versions of the potential patch...

-Kees

-- 
Kees Cook
Ubuntu Security Team
