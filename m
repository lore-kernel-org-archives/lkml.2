Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab0HCObf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:31:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab0HCObe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:31:34 -0400
Date: Tue, 3 Aug 2010 11:31:15 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Dave Martin <dave.martin@linaro.org>
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        kernel-team@lists.ubuntu.com, Will Deacon <Will.Deacon@arm.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH 1/2] perf events: Fix mmap offset determination
Message-ID: <20100803143115.GW29507@ghostprotocols.net>
References: <1280836116-6654-1-git-send-email-dave.martin@linaro.org> <1280836116-6654-2-git-send-email-dave.martin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280836116-6654-2-git-send-email-dave.martin@linaro.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 03, 2010 at 12:48:35PM +0100, Dave Martin escreveu:
> Fix buggy-looking code which unnecessarily adjusts the file offset
> fields read from /proc/*/maps.
> 
> This may have gone unnoticed since the offset is usually 0 (and the
> logic in util/symbol.c may work incorrectly for other offset values).
> 
> I make assumptions about the intended design here.  The cover note
> accompanying this patch contains a more detailed explanation.
> 
> Signed-off-by: Dave Martin <dave.martin@linaro.org>

Doing some investigation here...

4af8b35d (Anton Blanchard 2010-04-03 164)      pbf += 3;
4af8b35d (Anton Blanchard 2010-04-03 165)      n = hex2u64(pbf, &vm_pgoff);
4af8b35d (Anton Blanchard 2010-04-03 166)      /* pgoff is in bytes, not pages */
4af8b35d (Anton Blanchard 2010-04-03 167)      if (n >= 0)
4af8b35d (Anton Blanchard 2010-04-03 168)              ev.mmap.pgoff = vm_pgoff << getpagesize();
4af8b35d (Anton Blanchard 2010-04-03 169)      else
4af8b35d (Anton Blanchard 2010-04-03 170)              ev.mmap.pgoff = 0;

commit 4af8b35db6634dd1e0d616de689582b6c93550af
Author: Anton Blanchard <anton@samba.org>
Date:   Sat Apr 3 22:53:31 2010 +1100

    perf symbols: Fill in pgoff in mmap synthesized events
    
    When we synthesize mmap events we need to fill in the pgoff field.
    
    I wasn't able to test this completely since I couldn't find an
    executable region with a non 0 offset. We will see it when we start
    doing data profiling.

------------------------

Yeah, not reassuring comment, looking at fs/proc/task_mmu.c we see:

static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
{
        struct mm_struct *mm = vma->vm_mm;
        struct file *file = vma->vm_file;
        int flags = vma->vm_flags;
        unsigned long ino = 0;
        unsigned long long pgoff = 0;
        dev_t dev = 0;
        int len;

        if (file) {
                struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
                dev = inode->i_sb->s_dev;
                ino = inode->i_ino;
                pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
        }

        seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
                        vma->vm_start,
                        vma->vm_end,
                        flags & VM_READ ? 'r' : '-',
                        flags & VM_WRITE ? 'w' : '-',
                        flags & VM_EXEC ? 'x' : '-',
                        flags & VM_MAYSHARE ? 's' : 'p',
                        pgoff,
                        MAJOR(dev), MINOR(dev), ino, &len);

----------------------------------------------------------------------------

So yes, we're double shifting that, your patch is correct, applying it.

> ---
>  tools/perf/util/event.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 6b0db55..db8a1d4 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -151,7 +151,6 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
>  			continue;
>  		pbf += n + 3;
>  		if (*pbf == 'x') { /* vm_exec */
> -			u64 vm_pgoff;
>  			char *execname = strchr(bf, '/');
>  
>  			/* Catch VDSO */
> @@ -162,12 +161,7 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
>  				continue;
>  
>  			pbf += 3;
> -			n = hex2u64(pbf, &vm_pgoff);
> -			/* pgoff is in bytes, not pages */
> -			if (n >= 0)
> -				ev.mmap.pgoff = vm_pgoff << getpagesize();
> -			else
> -				ev.mmap.pgoff = 0;
> +			n = hex2u64(pbf, &ev.mmap.pgoff);
>  
>  			size = strlen(execname);
>  			execname[size - 1] = '\0'; /* Remove \n */
> -- 
> 1.7.0.4
