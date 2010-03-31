Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab0CaMck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 08:32:40 -0400
Received: from adelie.canonical.com ([91.189.90.139]:40574 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932829Ab0CaMci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 08:32:38 -0400
Message-ID: <4BB340E1.2060704@canonical.com>
Date: Wed, 31 Mar 2010 14:32:33 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: Re: [76/89] sparc: TIF_ABI_PENDING bit removal
References: <20100330225855.912036111@linux.site>
In-Reply-To: <20100330225855.912036111@linux.site>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------030803000009030305000006"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030803000009030305000006
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Greg KH wrote:
> 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------

> --- a/arch/sparc/include/asm/thread_info_64.h
> +++ b/arch/sparc/include/asm/thread_info_64.h
> @@ -227,12 +227,11 @@ register struct thread_info *current_thr
>  /* flag bit 8 is available */
>  #define TIF_SECCOMP		9	/* secure computing */
>  #define TIF_SYSCALL_AUDIT	10	/* syscall auditing active */
> -/* flag bit 11 is available */
>  /* NOTE: Thread flags >= 12 should be ones we have no interest
>   *       in using in assembly, else we can't use the mask as
>   *       an immediate value in instructions such as andcc.
>   */

For some reason I accidentally dropped the comment about bit 11. Replacment
patch attached.

Stefan

--------------030803000009030305000006
Content-Type: text/x-diff;
 name="0002-sparc-TIF_ABI_PENDING-bit-removal.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-sparc-TIF_ABI_PENDING-bit-removal.patch"

>From d021848a33c6d276b8ab81aef14002f88e20d0d7 Mon Sep 17 00:00:00 2001
From: David Miller <davem@davemloft.net>
Date: Thu, 28 Jan 2010 21:42:02 -0800
Subject: [PATCH] sparc: TIF_ABI_PENDING bit removal

commit 94673e968cbcce07fa78dac4b0ae05d24b5816e1 upstream.

Here are the sparc bits to remove TIF_ABI_PENDING now that
set_personality() is called at the appropriate place in exec.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 arch/sparc/include/asm/elf_64.h         |   13 +++----------
 arch/sparc/include/asm/thread_info_64.h |    3 +--
 arch/sparc/kernel/process_64.c          |    8 --------
 3 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/arch/sparc/include/asm/elf_64.h b/arch/sparc/include/asm/elf_64.h
index d42e393..9968085 100644
--- a/arch/sparc/include/asm/elf_64.h
+++ b/arch/sparc/include/asm/elf_64.h
@@ -196,17 +196,10 @@ static inline unsigned int sparc64_elf_hwcap(void)
 #define ELF_PLATFORM	(NULL)
 
 #define SET_PERSONALITY(ex)				\
-do {	unsigned long new_flags = current_thread_info()->flags; \
-	new_flags &= _TIF_32BIT;			\
-	if ((ex).e_ident[EI_CLASS] == ELFCLASS32)	\
-		new_flags |= _TIF_32BIT;		\
+do {	if ((ex).e_ident[EI_CLASS] == ELFCLASS32)	\
+		set_thread_flag(TIF_32BIT);		\
 	else						\
-		new_flags &= ~_TIF_32BIT;		\
-	if ((current_thread_info()->flags & _TIF_32BIT) \
-	    != new_flags)				\
-		set_thread_flag(TIF_ABI_PENDING);	\
-	else						\
-		clear_thread_flag(TIF_ABI_PENDING);	\
+		clear_thread_flag(TIF_32BIT);		\
 	/* flush_thread will update pgd cache */	\
 	if (personality(current->personality) != PER_LINUX32)	\
 		set_personality(PER_LINUX |		\
diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index 1b45a7b..14c25fe 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -232,7 +232,7 @@ register struct thread_info *current_thread_info_reg asm("g6");
  *       in using in assembly, else we can't use the mask as
  *       an immediate value in instructions such as andcc.
  */
-#define TIF_ABI_PENDING		12
+/* flag bit 12 is available */
 #define TIF_MEMDIE		13
 #define TIF_POLLING_NRFLAG	14
 #define TIF_FREEZE		15	/* is freezing for suspend */
@@ -246,7 +246,6 @@ register struct thread_info *current_thread_info_reg asm("g6");
 #define _TIF_32BIT		(1<<TIF_32BIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
-#define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 4041f94..3714fdb 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -365,14 +365,6 @@ void flush_thread(void)
 	struct thread_info *t = current_thread_info();
 	struct mm_struct *mm;
 
-	if (test_ti_thread_flag(t, TIF_ABI_PENDING)) {
-		clear_ti_thread_flag(t, TIF_ABI_PENDING);
-		if (test_ti_thread_flag(t, TIF_32BIT))
-			clear_ti_thread_flag(t, TIF_32BIT);
-		else
-			set_ti_thread_flag(t, TIF_32BIT);
-	}
-
 	mm = t->task->mm;
 	if (mm)
 		tsb_context_switch(mm);
-- 
1.6.3.3


--------------030803000009030305000006--
