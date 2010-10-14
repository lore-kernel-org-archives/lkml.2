Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab0JNK6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 06:58:54 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38709 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab0JNK6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 06:58:53 -0400
Date: Thu, 14 Oct 2010 12:58:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: Randy Dunlap <randy.dunlap@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        akpm <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Subject: [PATCH] bitops.h: Widen BIT macro to support 64-bit types
Message-ID: <20101014105855.GB31247@aftab>
References: <20101013131057.88238be6.randy.dunlap@oracle.com>
 <20101014042409.GB29342@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014042409.GB29342@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Wed, Oct 13, 2010 at 04:10:57PM -0400
> 
> > The BIT() macro works on unsigned longs, but this warning happens
> > on i386 (X86_32), where UL is 32 bits and this value needs to be
> > 64 bits, so use open-coded ULL.
> > 
> > drivers/edac/mce_amd.c:262: warning: left shift count >= width of type
> 
> Ok, so BIT() should be fixed to work with the largest type available,
> IMHO. Let me cook up something.

Maybe something like the following. Build-tested with the crosstool
(http://www.kernel.org/pub/tools/crosstool) on the following arches:
alpha blackfin cris hppa64 ia64 mips64 sparc.

Any objections?

--
From: Borislav Petkov <Borislav.Petkov@amd.com>
Date: Thu, 14 Oct 2010 12:00:17 +0200
Subject: [PATCH] bitops.h: Widen BIT macro to support 64-bit types

Nowadays, every arch defines an unsigned 64-bit type using either one
of the include/asm-generic/int-l{,l}64.h headers. Thus, make the BIT()
macro return that 64-bit type by default. This makes sense on x86 when
manipulating MSR values and prevents overflow errors on 32-bit arches,
for example.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/bitops.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index fc68053..7b9170b 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -3,7 +3,7 @@
 #include <asm/types.h>
 
 #ifdef	__KERNEL__
-#define BIT(nr)			(1UL << (nr))
+#define BIT(nr)			(U64_C(1) << (nr))
 #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
 #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
 #define BITS_PER_BYTE		8
-- 
1.7.3.1.50.g1e633

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
