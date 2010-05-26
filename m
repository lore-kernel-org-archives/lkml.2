Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab0EZPjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:39:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60098 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab0EZPjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:39:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u+V9OZ75EX1FHxU/0QagNRg/9iG5JhBj2gdaj8al1QeiTIu6QUJX5Kfr9L1qnjWDRs
         xW15hX0Ewb/cxYFHEDpV78DD8sOoUmNtNHCAc5b3xRGwl1QXc6aqO0aCJE2oXoCLQOzu
         11v/u0jDJAu0LQShuKHrXmFULjK+nDpqPv9dI=
Date: Wed, 26 May 2010 18:38:43 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] tracing: Remove kmemtrace ftrace plugin
Message-ID: <20100526153843.GA6868@localhost>
References: <4BFCE849.7090804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFCE849.7090804@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 05:22:17PM +0800, Li Zefan wrote:
> We have been resisting new ftrace plugins and removing existing
> ones, and kmemtrace has been superseded by kmem trace events
> and perf-kmem, so we remove it.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  Documentation/ABI/testing/debugfs-kmemtrace |   71 ----
>  Documentation/trace/kmemtrace.txt           |  126 -------
>  MAINTAINERS                                 |    7 -
>  include/linux/kmemtrace.h                   |   25 --
>  include/linux/slab_def.h                    |    3 +-
>  include/linux/slub_def.h                    |    3 +-
>  init/main.c                                 |    2 -
>  kernel/trace/Kconfig                        |   20 -
>  kernel/trace/kmemtrace.c                    |  529 ---------------------------
>  kernel/trace/trace.h                        |   13 -
>  kernel/trace/trace_entries.h                |   35 --
>  mm/slab.c                                   |    1 -
>  mm/slub.c                                   |    1 -
>  13 files changed, 4 insertions(+), 832 deletions(-)
>  delete mode 100644 Documentation/ABI/testing/debugfs-kmemtrace
>  delete mode 100644 Documentation/trace/kmemtrace.txt
>  delete mode 100644 include/linux/kmemtrace.h
>  delete mode 100644 kernel/trace/kmemtrace.c

Oh my, this one started quite a massacre judging by other replies! :-)

[snip]

> diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
> index 1812dac..1acfa73 100644
> --- a/include/linux/slab_def.h
> +++ b/include/linux/slab_def.h
> @@ -14,7 +14,8 @@
>  #include <asm/page.h>		/* kmalloc_sizes.h needs PAGE_SIZE */
>  #include <asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
>  #include <linux/compiler.h>
> -#include <linux/kmemtrace.h>
> +
> +#include <trace/events/kmem.h>
>  
>  #ifndef ARCH_KMALLOC_MINALIGN
>  /*
> diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
> index 55695c8..2345d3a 100644
> --- a/include/linux/slub_def.h
> +++ b/include/linux/slub_def.h
> @@ -10,9 +10,10 @@
>  #include <linux/gfp.h>
>  #include <linux/workqueue.h>
>  #include <linux/kobject.h>
> -#include <linux/kmemtrace.h>
>  #include <linux/kmemleak.h>
>  
> +#include <trace/events/kmem.h>
> +
>  enum stat_item {
>  	ALLOC_FASTPATH,		/* Allocation from cpu slab */
>  	ALLOC_SLOWPATH,		/* Allocation by getting a new cpu slab */

[snip]

> diff --git a/mm/slab.c b/mm/slab.c
> index 02786e1..2dba2d4 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -102,7 +102,6 @@
>  #include	<linux/cpu.h>
>  #include	<linux/sysctl.h>
>  #include	<linux/module.h>
> -#include	<linux/kmemtrace.h>
>  #include	<linux/rcupdate.h>
>  #include	<linux/string.h>
>  #include	<linux/uaccess.h>
> diff --git a/mm/slub.c b/mm/slub.c
> index 26f0cb9..a61f1aa 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -17,7 +17,6 @@
>  #include <linux/slab.h>
>  #include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
> -#include <linux/kmemtrace.h>
>  #include <linux/kmemcheck.h>
>  #include <linux/cpu.h>
>  #include <linux/cpuset.h>

I'd suggest including 'trace/events/kmem.h' here as well. Though it most
likely gets the trace_kmem_* stuff through 'linux/slab.h'.

Here's my ack if you need it:

Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>


	Eduard

