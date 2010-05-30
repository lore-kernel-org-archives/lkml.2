Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0E3PCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 11:02:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53289 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab0E3PCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 11:02:19 -0400
Date: Sun, 30 May 2010 17:02:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: current git kernel crashes UML system during boot
Message-ID: <20100530150214.GA1565@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
	Borislav Petkov <borislav.petkov@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	user-mode-linux-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <201005271944.09541.toralf.foerster@gmx.de>
 <AANLkTimYeMO_fc8C5MQedwF646_au4lvEbXkBPmQSxb9@mail.gmail.com>
 <AANLkTimKwxYxM_PExplIDK1WPTQ9e_-CHn5SnIvfjfUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimKwxYxM_PExplIDK1WPTQ9e_-CHn5SnIvfjfUg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, May 30, 2010 at 01:57:05PM +0200

> On Sun, May 30, 2010 at 13:39, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > 2010/5/27 Toralf Förster <toralf.foerster@gmx.de>:
> >> I bisected it to this :
> 
> > After fixing the missing/superfluous slab inclusion issues, I bisected
> > it further to
> >
> > commit d61931d89be506372d01a90d1755f6d0a9fafe2d
> > Author: Borislav Petkov <borislav.petkov@amd.com>
> > Date:   Fri Mar 5 17:34:46 2010 +0100
> >
> >    x86: Add optimized popcnt variants
> >
> >    Add support for the hardware version of the Hamming weight function,
> >    popcnt, present in CPUs which advertize it under CPUID, Function
> >    0x0000_0001_ECX[23]. On CPUs which don't support it, we fallback to the
> >    default lib/hweight.c sw versions.
> >
> >    A synthetic benchmark comparing popcnt with __sw_hweight64 showed almost
> >    a 3x speedup on a F10h machine.
> >
> >    Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> >    LKML-Reference: <20100318112015.GC11152@aftab>
> >    Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> >
> > I reverted that commit on top of current mainline (and fixed up the
> > conflicts), and now
> > it boots again.
> 
> I tried adding
> 
> config ARCH_HWEIGHT_CFLAGS
>         string
>         default "-fcall-saved-ecx -fcall-saved-edx" if !64_BIT
>         default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx
> -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10
> -fcall-saved-r11" if 64_BIT
> 
> to arch/um/Kconfig.x86. Now it got a bit further, but it still crashes:

Ok, this is a kinda stab in the dark but from what I could decypher
from the include hell, one possible fix should be if UML didn't include
<arch/x86/include/asm/arch_hweight.h> but use the software hweight
version only.

Can you guys check whether the following fixes the issue?

Thanks.

--
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 545776e..c9dad12 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -444,7 +444,11 @@ static inline int fls(int x)
 
 #define ARCH_HAS_FAST_MULTIPLIER 1
 
+#ifdef CONFIG_UML
+#include <asm-generic/bitops/arch_hweight.h>
+#else
 #include <asm/arch_hweight.h>
+#endif
 
 #include <asm-generic/bitops/const_hweight.h>
 

-- 
Regards/Gruss,
    Boris.
