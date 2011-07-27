Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab1G0Ez6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:55:58 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:54376 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750909Ab1G0Ez4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:55:56 -0400
Date: Tue, 26 Jul 2011 21:55:54 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] Cross Memory Attach v4
Message-Id: <20110726215554.f87b403e.rdunlap@xenotime.net>
In-Reply-To: <20110727125342.5637308d@lilo>
References: <20110727125342.5637308d@lilo>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011 12:53:42 +0930 Christopher Yeoh wrote:

> Hi Andrew,
> 
> Here's an updated version of the Cross Memory Attach patch. Changes
> since the v3:
> 
> - Adds x86_64 specific wire up
> - Changes behaviour so process_vm_readv and process_vm_writev return
>   the number of bytes successfully read or written even if an error
>   occurs
> - Adds more kernel doc interface comments 
> - rename of some internal functions (process_vm_rw_check_iovecs, 
>   process_vm_rw) so they make more sense. 
> 
> Still need to do benchmarking to see if the optimisation for small
> copies using a local on-stack array in process_vm_rw_core is worth it. 

It's nice to include a diffstat so that people can get a quick patch
summary and see what files are touched.

> diffstat  -w 70 -p 1 cma-v4.patch 
 arch/powerpc/include/asm/systbl.h  |    2 
 arch/powerpc/include/asm/unistd.h  |    4 
 arch/x86/ia32/ia32entry.S          |    2 
 arch/x86/include/asm/unistd_32.h   |    4 
 arch/x86/include/asm/unistd_64.h   |    4 
 arch/x86/kernel/syscall_table_32.S |    2 
 fs/aio.c                           |    4 
 fs/compat.c                        |    7 
 fs/read_write.c                    |    8 
 include/linux/compat.h             |    3 
 include/linux/fs.h                 |    7 
 include/linux/syscalls.h           |   13 
 kernel/sys_ni.c                    |    4 
 mm/Makefile                        |    3 
 mm/process_vm_access.c             |  482 +++++++++++++++++++++++++++
 security/keys/compat.c             |    2 
 security/keys/keyctl.c             |    2 
 17 files changed, 536 insertions(+), 17 deletions(-)


> diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
> new file mode 100644
> index 0000000..a0e3cfb
> --- /dev/null
> +++ b/mm/process_vm_access.c
> @@ -0,0 +1,482 @@
> +/*
> + *  linux/mm/process_vm_access.c
> + *
> + *  Copyright (C) 2010-2011 Christopher Yeoh <cyeoh@au1.ibm.com>, IBM Corp.

Any license for this file?  maybe GPL?

> + */
> +
> +#include <linux/mm.h>
> +#include <linux/uio.h>
> +#include <linux/sched.h>
> +#include <linux/highmem.h>
> +#include <linux/ptrace.h>
> +#include <linux/slab.h>
> +#include <linux/syscalls.h>
> +
> +#ifdef CONFIG_COMPAT
> +#include <linux/compat.h>
> +#endif
> +
> +/*

Any problem with using
/**
so that these are proper kernel-doc notation?
(for all [4] functions here that have such notation)


> + * process_vm_rw_pages - read/write pages from task specified
> + * @task: task to read/write from
> + * @mm: mm for task
> + * @process_pages: struct pages area that can store at least
> + *  nr_pages_to_copy struct page pointers
> + * @pa: address of page in task to start copying from/to
> + * @start_offset: offset in page to start copying from/to
> + * @len: number of bytes to copy
> + * @lvec: iovec array specifying where to copy to/from
> + * @lvec_cnt: number of elements in iovec array
> + * @lvec_current: index in iovec array we are up to
> + * @lvec_offset: offset in bytes from current iovec iov_base we are up to
> + * @vm_write: 0 means copy from, 1 means copy to
> + * @nr_pages_to_copy: number of pages to copy
> + * @bytes_copied: returns number of bytes successfully copied
> + * Returns 0 on success, error code otherwise
> + */
> +static int process_vm_rw_pages(struct task_struct *task,
> +			       struct mm_struct *mm,
> +			       struct page **process_pages,
> +			       unsigned long pa,
> +			       unsigned long start_offset,
> +			       unsigned long len,
> +			       const struct iovec *lvec,
> +			       unsigned long lvec_cnt,
> +			       unsigned long *lvec_current,
> +			       size_t *lvec_offset,
> +			       int vm_write,
> +			       unsigned int nr_pages_to_copy,
> +			       ssize_t *bytes_copied)
> +{


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
