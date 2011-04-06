Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab1DFUId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:08:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab1DFUIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:08:31 -0400
Date: Wed, 6 Apr 2011 13:08:28 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [regression v2.6.38] Re: [PATCH v2] brk: fix min_brk lower bound
 computation for COMPAT_BRK
In-Reply-To: <AANLkTi=pNxVY8NZjRhT_aJMQNiTpfkmECqc-ZnTD7ynW@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1104061155530.5855@pobox.suse.cz>
References: <alpine.LNX.2.00.1101030002390.26685@pobox.suse.cz> <alpine.LNX.2.00.1101031237210.26685@pobox.suse.cz> <alpine.LNX.2.00.1101031421470.26685@pobox.suse.cz> <AANLkTinK-TYnY70Wst_FTbEtn7Dwm8wEQoWMewsYM8dh@mail.gmail.com>
 <alpine.LNX.2.00.1103251119120.26754@pobox.suse.cz> <AANLkTi=g5z+GYkbOGbdLQcLaQkpY6yQ6tjGRjjk1H59R@mail.gmail.com> <alpine.LNX.2.00.1103281619320.26754@pobox.suse.cz> <AANLkTi=pNxVY8NZjRhT_aJMQNiTpfkmECqc-ZnTD7ynW@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011, Geert Uytterhoeven wrote:

> I managed to reproduce it inside ARAnyM, by chrooting into the ramdisk image.
> After adding strace, "strace /sbin/init" for the success case gives:
> 
> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
> -1, 0) = 0xc0004000
> old_mmap(NULL, 578, PROT_READ, MAP_SHARED, 3, 0) = 0xc0007000
> old_mmap(NULL, 663552, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xc0008000
> old_mmap(0xc0008000, 426908, PROT_READ|PROT_EXEC,
> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0xc0008000
> old_mmap(0xc0072000, 24256, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_FIXED, 3, 0x68000) = 0xc0072000
> old_mmap(0xc0078000, 204696, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xc0078000
> brk(0x80005c8e)                         = 0x80005c8e
> brk(0x80006000)                         = 0x80006000
> old_mmap(NULL, 1024, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
> -1, 0) = 0xc0007000
> 
> For the failure case:
> 
> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
> -1, 0) = 0xc0004000
> old_mmap(NULL, 578, PROT_READ, MAP_SHARED, 3, 0) = 0xc0007000
> old_mmap(NULL, 663552, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xc0008000
> old_mmap(0xc0008000, 426908, PROT_READ|PROT_EXEC,
> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0xc0008000
> old_mmap(0xc0072000, 24256, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_FIXED, 3, 0x68000) = 0xc0072000
> old_mmap(0xc0078000, 204696, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xc0078000
> brk(0x80005c8e)                         = 0x80006000
> 
> Major difference:
> 
> -brk(0x80005c8e)                         = 0x80005c8e
> -brk(0x80006000)                         = 0x80006000
> -open("/etc/inittab", O_RDONLY)          = 3
> -fstat(3, {st_mode=S_IFREG|0644, st_size=140, ...}) = 0
> -old_mmap(NULL, 1024, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
> -1, 0) = 0xc0007000
> -read(3, "tty1:console:/sbin/getty 9600 tt"..., 1024) = 140
> -read(3, "", 1024)                       = 0
> +brk(0x80005c8e)                         = 0x80006000
> +open("/dev/console", O_WRONLY)          = 3
> +write(3, "init: ", 6)                   = 6
> +write(3, "cannot open inittab\n", 20)   = 20
>  close(3)                                = 0
> 
> Seems like the binary doesn't like brk() rounding up the requested
> value to the next page...

Could you please test with the patch below? Thanks.




From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] brk: COMPAT_BRK needs more special handling of legacy applications

5520e89 ("brk: fix min_brk lower bound computation for COMPAT_BRK")
tried to get the whole logic of brk randomization for legacy (libc5-based)
applications finally right.

It turns out that the way to detect whether brk has actually been
randomized or not introduced by that patch still doesn't work for those
binaries, as reported by Geert.

I don't like it, but currently see no better option than a bit flag in
task_struct to catch the CONFIG_COMPAT_BRK && randomize_va_space == 2
case.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
NOT-YET-Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 fs/binfmt_elf.c       |    6 +++++-
 include/linux/sched.h |    3 +++
 mm/mmap.c             |    2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f34078d..303983f 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -941,9 +941,13 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->start_stack = bprm->p;
 
 #ifdef arch_randomize_brk
-	if ((current->flags & PF_RANDOMIZE) && (randomize_va_space > 1))
+	if ((current->flags & PF_RANDOMIZE) && (randomize_va_space > 1)) {
 		current->mm->brk = current->mm->start_brk =
 			arch_randomize_brk(current->mm);
+#ifdef CONFIG_COMPAT_BRK
+		current->brk_randomized = 1;
+#endif
+	}
 #endif
 
 	if (current->personality & MMAP_PAGE_ZERO) {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 83bd2e2..239d2fe 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1254,6 +1254,9 @@ struct task_struct {
 #endif
 
 	struct mm_struct *mm, *active_mm;
+#ifdef CONFIG_COMPAT_BRK
+	unsigned brk_randomized:1;
+#endif
 #if defined(SPLIT_RSS_COUNTING)
 	struct task_rss_stat	rss_stat;
 #endif
diff --git a/mm/mmap.c b/mm/mmap.c
index 2ec8eb5..318ed2d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -259,7 +259,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	 * randomize_va_space to 2, which will still cause mm->start_brk
 	 * to be arbitrarily shifted
 	 */
-	if (mm->start_brk > PAGE_ALIGN(mm->end_data))
+	if (current->brk_randomized)
 		min_brk = mm->start_brk;
 	else
 		min_brk = mm->end_data;
-- 
1.7.3.1

