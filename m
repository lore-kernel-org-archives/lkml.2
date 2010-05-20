Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab0ETUSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 16:18:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab0ETUSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 16:18:02 -0400
Date: Thu, 20 May 2010 16:17:29 -0400
From: Jason Baron <jbaron@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       vgoyal@redhat.com
Subject: Re: [PATCH 07/13] jump label v8: sort jump table at build-time
Message-ID: <20100520201728.GA18815@redhat.com>
References: <cover.1274283321.git.jbaron@redhat.com> <f9a6149e89c8c0131e1ac1fa5ea163c4f5b023d1.1274283321.git.jbaron@redhat.com> <20100519.153634.266077873.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519.153634.266077873.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 03:36:34PM -0700, David Miller wrote:
> > diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> > index 2092361..fe6f8be 100644
> > --- a/scripts/mod/modpost.c
> > +++ b/scripts/mod/modpost.c
> > @@ -17,6 +17,8 @@
> >  #include "modpost.h"
> >  #include "../../include/generated/autoconf.h"
> >  #include "../../include/linux/license.h"
> > +#include <linux/types.h>
> > +#include "jump_entry.h"
> >  
> 
> This breaks the build on non-jump_label-supporting architectures
> because only they will have the jump_entry.h header file.
> 
> I'm really getting tired trying to test your changes and every single
> time as I go through doing very basic build testing I always hit one
> patch that assumes jump label support exists, or assumes some x86'ism.

sorry about that. I mis-tested it. anyways here's the interdiff to this
patch to fix. btw, how do the sparc bits look?

thanks,

-Jason


diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index fe6f8be..cc87012 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -18,7 +18,9 @@
 #include "../../include/generated/autoconf.h"
 #include "../../include/linux/license.h"
 #include <linux/types.h>
-#include "jump_entry.h"
+#ifdef CONFIG_HAVE_ARCH_JUMP_LABEL
+ #include "jump_entry.h"
+#endif
 
 /* Some toolchains use a `_' prefix for all user symbols. */
 #ifdef CONFIG_SYMBOL_PREFIX
@@ -377,6 +379,8 @@ void release_file(void *file, unsigned long size)
 	munmap(file, size);
 }
 
+#ifdef CONFIG_HAVE_ARCH_JUMP_LABEL
+
 static void swap_jump_label_entries(struct jump_entry *previous, struct jump_entry *next)
 {
 	struct jump_entry tmp;
@@ -421,6 +425,8 @@ static void sort_jump_label_table(struct elf_info *info, Elf_Ehdr *hdr)
 	} while (swapped == 1);
 }
 
+#endif
+
 static int parse_elf(struct elf_info *info, const char *filename)
 {
 	unsigned int i;
@@ -539,8 +545,10 @@ static int parse_elf(struct elf_info *info, const char *filename)
 		sym->st_size  = TO_NATIVE(sym->st_size);
 	}
 
+#ifdef CONFIG_HAVE_ARCH_JUMP_LABEL
 	if (enable_jump_label)
 		sort_jump_label_table(info, hdr);
+#endif
 
 	return 1;
 }
