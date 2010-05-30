Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0E3URn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 16:17:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36490 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545Ab0E3URl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 16:17:41 -0400
Date: Sun, 30 May 2010 22:17:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, hweight: Fix UML boot crash
Message-ID: <20100530201738.GB2498@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Borislav Petkov <borislav.petkov@amd.com>,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
	user-mode-linux-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <201005271944.09541.toralf.foerster@gmx.de>
 <AANLkTimKwxYxM_PExplIDK1WPTQ9e_-CHn5SnIvfjfUg@mail.gmail.com>
 <20100530150214.GA1565@liondog.tnic>
 <201005301728.25976.toralf.foerster@gmx.de>
 <20100530170346.GC1565@liondog.tnic>
 <4C02B020.2040103@zytor.com>
 <20100530193956.GA2498@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20100530193956.GA2498@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This bothers me, because it really feels like something is fundamentally
> > broken in UML tryingto track the upstream architecture, and this is just
> > a bandage.
> 
> First of all, scratch that patch. It is indeed dumb idea to sprinkle UML
> special cases in x86 just because they include it.
> 
> Which begs the question why _is_ UML sucking in x86 stuff and can anyone
> provide us with some sensible reasons? Because if there aren't any, it
> is their includes that should be fixed. Let me see what I can do to
> redirect hweight stuff properly...

Ok, AFAICT UML is sucking in the includes of the sub-architecture the
UML "guest" is running on. See below¹ for the whole gcc string make
executes. Among the switches is

"-I/home/boris/kernel/linux-2.6/arch/x86/include"

so there will be no untangling today. Instead, we could do another
bandaid which is confined to UML include space only and redirect
arch_hweight.h includes to the generic ones. Check this out, it seems to
work here:

--
From: Borislav Petkov <bp@alien8.de>
Date: Sun, 30 May 2010 22:11:32 +0200
Subject: [PATCH] um, hweight: Fix UML boot crash

Obviously UML cannot stomach callee reg-saving trickery
introduced with d61931d89be506372d01a90d1755f6d0a9fafe2d
(x86: Add optimized popcnt variants) and oopses during boot:
http://marc.info/?l=linux-kernel&m=127522065202435&w=2

Redirect arch_hweight.h include from the x86 portion to the generic
arch_hweight.h which is a fallback to the software hweight routines.

LKML-Reference: <201005271944.09541.toralf.foerster@gmx.de>
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/um/include/asm/arch_hweight.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)
 create mode 100644 arch/um/include/asm/arch_hweight.h

diff --git a/arch/um/include/asm/arch_hweight.h b/arch/um/include/asm/arch_hweight.h
new file mode 100644
index 0000000..c656cf4
--- /dev/null
+++ b/arch/um/include/asm/arch_hweight.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_UM_HWEIGHT_H
+#define _ASM_UM_HWEIGHT_H
+
+#include <asm-generic/bitops/arch_hweight.h>
+
+#endif
-- 
1.7.1









¹ gcc -Wp,-MD,arch/um/sys-x86_64/.delay.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include -I/home/boris/kernel/linux-2.6/arch/um/include -Iinclude  -include include/generated/autoconf.h -D__KERNEL__ -I/home/boris/kernel/linux-2.6/arch/um/sys-x86_64 -m64 -I/home/boris/kernel/linux-2.6/arch/x86/include -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -Os -D__arch_um__ -DSUBARCH=\"x86_64\" -I/home/boris/kernel/linux-2.6/arch/um/include/shared -I/home/boris/kernel/linux-2.6/arch/um/sys-x86_64/shared -I/home/boris/kernel/linux-2.6/arch/um/include/shared/skas -Dvmap=kernel_vmap -Din6addr_loopback=kernel_in6addr_loopback -Din6addr_any=kernel_in6addr_any -fno-builtin -m64 -funit-at-a-time -D_LARGEFILE64_SOURCE -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask -Dmktime=kernel_mktime -Wframe-larger-than=2048 -fno-stack-protector -fno-omit-frame-pointer -fno-optimize-sibling-calls -g -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm -fconserve-stack   -D"KBUILD_STR(s)=\#s" -D"KBUILD_BASENAME=KBUILD_STR(delay)"  -D"KBUILD_MODNAME=KBUILD_STR(delay)"  -c -o arch/um/sys-x86_64/delay.o arch/um/sys-x86_64/delay.c


-- 
Regards/Gruss,
    Boris.
