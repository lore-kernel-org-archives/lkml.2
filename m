Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab2IKP5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 11:57:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141Ab2IKP5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 11:57:39 -0400
Date: Tue, 11 Sep 2012 17:59:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [PATCH] fs: prevent double-free on an error path in core dumper
Message-ID: <20120911155950.GA7431@redhat.com>
References: <1347380162-2359-1-git-send-email-vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347380162-2359-1-git-send-email-vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys, let's not discuss this offlist... add lkml/cc's

On 09/11, Denys Vlasenko wrote:
>
> If elf_note_info_init fails to allocate memory for info->fields,
> it frees already alloceted stuff and returns error to its caller,
> fill_note_info. Which in turn returns error to its caller,
> elf_core_dump. Which jumps to cleanup label and calls free_note_info,
> which will happily try to free all info->fields again. BOOM.

This is !CORE_DUMP_USE_REGSET case, please mention this in the
changelog. And s/fs:/coredump:/ in the subject ;)

OK, I think you are right, but unless I missed something there
is a better fix.

> This is the fix.
>
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> ---
>  fs/binfmt_elf.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 760d7f5..b2b7034 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1617,7 +1617,7 @@ static void free_note_info(struct elf_note_info *info)
>  	kfree(info->psinfo.data);
>  }
>
> -#else
> +#else /* !CORE_DUMP_USE_REGSET */
>
>  /* Here is the structure in which status of each thread is captured. */
>  struct elf_thread_status
> @@ -1718,6 +1718,8 @@ static int elf_note_info_init(struct elf_note_info *info)
>  	kfree(info->psinfo);
>   notes_free:
>  	kfree(info->notes);
> +	/* The caller will try to clean us up again, must set ptrs to NULL */

Exactly. The caller will do free_note_info() and info was zeroed at the
start. See below

> +	memset(info, 0, sizeof(*info));

Yes, this will fix the problem.

But, again, the caller does free_note_info(), so why elf_note_info_init()
tries to handle the kmalloc failures? Afaics, we can simplify the code
and fix the bug.

What do you think about the patch below?

Oleg.

--- x/fs/binfmt_elf.c
+++ x/fs/binfmt_elf.c
@@ -1696,30 +1696,19 @@ static int elf_note_info_init(struct elf
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
 	if (!info->psinfo)
-		goto notes_free;
+		return 0;
 	info->prstatus = kmalloc(sizeof(*info->prstatus), GFP_KERNEL);
 	if (!info->prstatus)
-		goto psinfo_free;
+		return 0;
 	info->fpu = kmalloc(sizeof(*info->fpu), GFP_KERNEL);
 	if (!info->fpu)
-		goto prstatus_free;
+		return 0;
 #ifdef ELF_CORE_COPY_XFPREGS
 	info->xfpu = kmalloc(sizeof(*info->xfpu), GFP_KERNEL);
 	if (!info->xfpu)
-		goto fpu_free;
+		return 0;
 #endif
 	return 1;
-#ifdef ELF_CORE_COPY_XFPREGS
- fpu_free:
-	kfree(info->fpu);
-#endif
- prstatus_free:
-	kfree(info->prstatus);
- psinfo_free:
-	kfree(info->psinfo);
- notes_free:
-	kfree(info->notes);
-	return 0;
 }
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,

