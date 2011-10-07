Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1JGTNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 15:13:20 -0400
Received: from mail.agmk.net ([91.192.224.71]:38361 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab1JGTNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 15:13:17 -0400
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: include/arch/x86/swab.h badness?
Date: Fri, 7 Oct 2011 21:13:09 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc8-00060-g47ea91b; KDE/4.7.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201110072113.09495.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

during compiling some byte-order related code for 32-bit x86 which uses glibc's
#include <byteorder.h> i've noticed that __be*_to_cpu uses a generic i386 (ror+xchg) impl.
quick investigation shows that #include <linux/asm/swab.h> sucks a little ;)

please look at the current linux implementation:

static __inline__ __u32 __arch_swab32(__u32 val)
{
#ifdef __i386__
# ifdef CONFIG_X86_BSWAP
        __asm__("bswap %0" : "=r" (val) : "0" (val));
# else
        __asm__("xchgb %b0,%h0\n\t"     /* swap lower bytes     */
            "rorl $16,%0\n\t"   /* swap words           */
            "xchgb %b0,%h0"     /* swap higher bytes    */
            : "=q" (val)
            : "0" (val));
# endif

#else /* __i386__ */
        __asm__("bswapl %0"
            : "=r" (val)
            : "0" (val));
#endif
        return val;
}

in the userspace, the __i386__ is always defined by gcc for any -march=i486/i586/...
and the CONFIG_X86_BSWAP is never defined, so the userspace always ends with inlined
assembly with generic i386 implementation :(

could you please improve this #ifdefs to get bswap opcodes for i486+ ?
maybe the __builtin_bswap* should be used in recent kernel tree?

BR,
Paweł.

