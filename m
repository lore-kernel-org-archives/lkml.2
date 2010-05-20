Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab0ETVcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 17:32:23 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:52353 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab0ETVcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 17:32:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAC5H9UtGGOJc/2dsb2JhbACeGXK/OoUSBA
Date: Thu, 20 May 2010 17:32:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       vgoyal@redhat.com
Subject: Re: [PATCH 07/13] jump label v8: sort jump table at build-time
Message-ID: <20100520213216.GB14957@Krystal>
References: <cover.1274283321.git.jbaron@redhat.com> <f9a6149e89c8c0131e1ac1fa5ea163c4f5b023d1.1274283321.git.jbaron@redhat.com> <20100519.153634.266077873.davem@davemloft.net> <20100520201728.GA18815@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100520201728.GA18815@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:25:59 up 43 days,  7:19,  5 users,  load average: 0.27, 0.32,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Wed, May 19, 2010 at 03:36:34PM -0700, David Miller wrote:
> > > diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> > > index 2092361..fe6f8be 100644
> > > --- a/scripts/mod/modpost.c
> > > +++ b/scripts/mod/modpost.c
> > > @@ -17,6 +17,8 @@
> > >  #include "modpost.h"
> > >  #include "../../include/generated/autoconf.h"
> > >  #include "../../include/linux/license.h"
> > > +#include <linux/types.h>
> > > +#include "jump_entry.h"
> > >  
> > 
> > This breaks the build on non-jump_label-supporting architectures
> > because only they will have the jump_entry.h header file.
> > 
> > I'm really getting tired trying to test your changes and every single
> > time as I go through doing very basic build testing I always hit one
> > patch that assumes jump label support exists, or assumes some x86'ism.
> 
> sorry about that. I mis-tested it. anyways here's the interdiff to this
> patch to fix. btw, how do the sparc bits look?
> 
> thanks,
> 
> -Jason
> 
> 
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index fe6f8be..cc87012 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -18,7 +18,9 @@
>  #include "../../include/generated/autoconf.h"
>  #include "../../include/linux/license.h"
>  #include <linux/types.h>
> -#include "jump_entry.h"

includes with "" is a bit unexpected in kernel code. Any reason for this ?
Is jump_entry.h shipped in scripts/mod/ ?

> +#ifdef CONFIG_HAVE_ARCH_JUMP_LABEL

ifdefs everywhere cripples the code and make it unreadable. You might
want to try to find another way to deal with the problem. E.g.

create linux/jump_entry.h
which contains 

#ifdef CONFIG_HAVE_ARCH_JUMP_LABEL
#include <asm/jump_entry.h>
#else

define some empty static inlines, and use them in the .c files.

e.g. 

static inline void sort_jump_label_table(struct elf_info *info, Elf_Ehdr *hdr)
{
}

#endif

> + #include "jump_entry.h"
> +#endif
>  
>  /* Some toolchains use a `_' prefix for all user symbols. */
>  #ifdef CONFIG_SYMBOL_PREFIX
> @@ -377,6 +379,8 @@ void release_file(void *file, unsigned long size)
>  	munmap(file, size);
>  }
>  
> +#ifdef CONFIG_HAVE_ARCH_JUMP_LABEL
> +
>  static void swap_jump_label_entries(struct jump_entry *previous, struct jump_entry *next)
>  {
>  	struct jump_entry tmp;
> @@ -421,6 +425,8 @@ static void sort_jump_label_table(struct elf_info *info, Elf_Ehdr *hdr)
>  	} while (swapped == 1);
>  }
>  
> +#endif
> +
>  static int parse_elf(struct elf_info *info, const char *filename)
>  {
>  	unsigned int i;
> @@ -539,8 +545,10 @@ static int parse_elf(struct elf_info *info, const char *filename)
>  		sym->st_size  = TO_NATIVE(sym->st_size);
>  	}
>  
> +#ifdef CONFIG_HAVE_ARCH_JUMP_LABEL
>  	if (enable_jump_label)
>  		sort_jump_label_table(info, hdr);
> +#endif

And remove this ifdef.

Thanks,

Mathieu

>  
>  	return 1;
>  }

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
