Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0HMVmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:42:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43239 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0HMVmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jk2pv8UZav6wy/m9xpBzg55wkNADoyjFH3I2NNBv/OFetuZlsywMNox5E5kF7r0rWT
         FRv31OQq1YTSYcOCm/YU431HkPYmhRMqGwltNsSaNgm+f8fTd8znoZ8BlPqnJC2Utt4H
         2jPAaVzTNoq3dxHlc7wF+ZA95E0mtzjSF0G2A=
MIME-Version: 1.0
In-Reply-To: <20100517212138.GA21629@elte.hu>
References: <20100517212138.GA21629@elte.hu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 13 Aug 2010 17:42:15 -0400
Message-ID: <AANLkTikvJna6vnc73RVhVAJZ8mERJoFk=V6Nwq-3HHWz@mail.gmail.com>
Subject: Re: [GIT PULL] core/hweight changes for v2.6.35
To: Borislav Petkov <petkovbb@googlemail.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 17:21, Ingo Molnar wrote:
>  arch/alpha/include/asm/bitops.h            |   18 +++++----
>  arch/ia64/include/asm/bitops.h             |   11 +++--
>  arch/sparc/include/asm/bitops_64.h         |   11 +++--
>  arch/x86/include/asm/bitops.h              |    4 +-
>  include/asm-generic/bitops/arch_hweight.h  |   25 ++++++++++++
>  include/asm-generic/bitops/const_hweight.h |   42 ++++++++++++++++++++
>  include/asm-generic/bitops/hweight.h       |    8 +---

did this miss Blackfin because the original patch was against the
2.6.34 tree ?  just wondering why it now build fails ...

doing a simple grep shows that the new "tile" arch may also be broken
as it uses "hweight32" ...

considering __sw_hweightX only exist when the generic hweight is in
play, wouldnt it make sense to have
include/asm-generic/bitops/arch_hweight.h not always define things ?
then most arches can simply pull in
include/asm-generic/bitops/hweight.h without having to worry about the
random inner details of hweight cruft.

diff --git a/include/asm-generic/bitops/arch_hweight.h
b/include/asm-generic/bitops/arch_hweight.h
index 6a211f4..3a62e38 100644
--- a/include/asm-generic/bitops/arch_hweight.h
+++ b/include/asm-generic/bitops/arch_hweight.h
@@ -1,8 +1,15 @@
 #ifndef _ASM_GENERIC_BITOPS_ARCH_HWEIGHT_H_
 #define _ASM_GENERIC_BITOPS_ARCH_HWEIGHT_H_

+#ifdef CONFIG_GENERIC_HWEIGHT
+
 #include <asm/types.h>

+extern unsigned int __sw_hweight8(unsigned int w);
+extern unsigned int __sw_hweight16(unsigned int w);
+extern unsigned int __sw_hweight32(unsigned int w);
+extern unsigned long __sw_hweight64(__u64 w);
+
 static inline unsigned int __arch_hweight32(unsigned int w)
 {
    return __sw_hweight32(w);
@@ -22,4 +29,7 @@ static inline unsigned long __arch_hweight64(__u64 w)
 {
    return __sw_hweight64(w);
 }
+
+#endif /* CONFIG_GENERIC_HWEIGHT */
+
 #endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index fc68053..2e58012 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -10,11 +10,6 @@
 #define BITS_TO_LONGS(nr)  DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 #endif

-extern unsigned int __sw_hweight8(unsigned int w);
-extern unsigned int __sw_hweight16(unsigned int w);
-extern unsigned int __sw_hweight32(unsigned int w);
-extern unsigned long __sw_hweight64(__u64 w);
-
 /*
  * Include this here because some architectures need generic_ffs/fls in
  * scope
-mike
