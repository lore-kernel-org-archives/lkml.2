Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab0KVFsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 00:48:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768Ab0KVFsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 00:48:53 -0500
Date: Sun, 21 Nov 2010 21:44:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc3 (fixmap build error)
Message-Id: <20101121214450.62fac5a4.akpm@linux-foundation.org>
In-Reply-To: <AANLkTi=4scuTeRyr1WuGbzk2jKdU_Ugu61ABoXPuXnVK@mail.gmail.com>
References: <AANLkTi=Di4UQMYyJ_wpZ6N=NZt1+3EeXL7FUsBX004YL@mail.gmail.com>
	<20101121181655.4996cdde.randy.dunlap@oracle.com>
	<AANLkTi=4scuTeRyr1WuGbzk2jKdU_Ugu61ABoXPuXnVK@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010 20:33:07 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Nov 21, 2010 at 6:16 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> > I thought that I saw a patch for this one, but I can't find it now.
> >
> > on i386:
> > arch/x86/built-in.o: In function `fix_to_virt':
> > /usr/builds/linux-2.6.37-rc3/arch/x86/include/asm/fixmap.h:207: undefined reference to `__this_fixmap_does_not_exist'
> 
> Hmm. Does it help to mark __set_fixmap_offset() as "__always_inline"
> rather than just "inline"?

yup.

Subject: arch/x86/include/asm/fixmap.h: mark __set_fixmap_offset as __always_inline
From: Andrew Morton <akpm@linux-foundation.org>

When compiling arch/x86/kernel/early_printk_mrst.c with i386 allmodconfig,
gcc-4.1.0 generates an out-of-line copy of __set_fixmap_offset() which
contains a reference to __this_fixmap_does_not_exist which the compiler cannot
elide.

Marking __set_fixmap_offset() as __always_inline prevents this.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/fixmap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/early_printk_mrst.c~arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline arch/x86/kernel/early_printk_mrst.c
diff -puN arch/x86/include/asm/fixmap.h~arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline arch/x86/include/asm/fixmap.h
--- a/arch/x86/include/asm/fixmap.h~arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline
+++ a/arch/x86/include/asm/fixmap.h
@@ -220,8 +220,8 @@ static inline unsigned long virt_to_fix(
 }
 
 /* Return an pointer with offset calculated */
-static inline unsigned long __set_fixmap_offset(enum fixed_addresses idx,
-				phys_addr_t phys, pgprot_t flags)
+static __always_inline unsigned long
+__set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
 {
 	__set_fixmap(idx, phys, flags);
 	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
_

