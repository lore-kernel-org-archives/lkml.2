Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab1DFUi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:38:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab1DFUiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:38:55 -0400
Date: Wed, 6 Apr 2011 13:38:54 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [PATCH] brk: COMPAT_BRK: fix detection of randomized brk (was Re:
 [regression v2.6.38] Re: [PATCH v2] brk: fix min_brk lower bound computation
 forCOMPAT_BRK)
In-Reply-To: <BANLkTinnvXX70OCrtyYy_2e-zJDqS9f2iw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1104061336190.5855@pobox.suse.cz>
References: <alpine.LNX.2.00.1101030002390.26685@pobox.suse.cz> <alpine.LNX.2.00.1101031237210.26685@pobox.suse.cz> <alpine.LNX.2.00.1101031421470.26685@pobox.suse.cz> <AANLkTinK-TYnY70Wst_FTbEtn7Dwm8wEQoWMewsYM8dh@mail.gmail.com>
 <alpine.LNX.2.00.1103251119120.26754@pobox.suse.cz> <AANLkTi=g5z+GYkbOGbdLQcLaQkpY6yQ6tjGRjjk1H59R@mail.gmail.com> <alpine.LNX.2.00.1103281619320.26754@pobox.suse.cz> <AANLkTi=pNxVY8NZjRhT_aJMQNiTpfkmECqc-ZnTD7ynW@mail.gmail.com> <alpine.LNX.2.00.1104061155530.5855@pobox.suse.cz>
 <BANLkTinnvXX70OCrtyYy_2e-zJDqS9f2iw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Subject: brk: COMPAT_BRK: fix detection of randomized brk

5520e89 ("brk: fix min_brk lower bound computation for COMPAT_BRK")
tried to get the whole logic of brk randomization for legacy (libc5-based)
applications finally right.

It turns out that the way to detect whether brk has actually been randomized in
the end or not introduced by that patch still doesn't work for those binaries,
as reported by Geert.

I don't like it, but currently see no better option than a bit flag in
task_struct to catch the CONFIG_COMPAT_BRK && randomize_va_space == 2
case.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
---

I am not really happy about introducing the bit flag, but I currently 
don't see another option. And it's only for the legacy CONFIG_COMPAT_BRK 
case anyway.

Andrew, Ingo, any opinions/objections?

If not -- Andrew, I guess this should go into current -rc still.

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

