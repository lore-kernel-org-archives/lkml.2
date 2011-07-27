Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab1G0RKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 13:10:33 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40158 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab1G0RKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 13:10:30 -0400
Date: Wed, 27 Jul 2011 19:10:15 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110727171015.GD19477@aftab>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com>
 <20110724172222.GB12621@aftab>
 <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 01:39:25PM -0400, Linus Torvalds wrote:
> > Yeah, I like the BITS() thing - will change. I actually have a similar
> > macro GENMASK(o, hi) in <drivers/edac/amd64_edac.h> - I should move it
> > to <linux/bitops.h> and rename it to BITS().
> 
> So it may be that BITS() is much too generic a name, and will cause
> problems. A quick "git grep -w BITS" certainly finds a fair number of
> hits. So I don't think it's usable as-is, it was meant more as
> pseudo-code.

How about something like the following instead - it should take care
of all your bitmask generating needs. There are also a couple of
GENMASK/BITMASK identical definitions around the tree which can be
unified while I'm at it too.

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index a3ef66a..b1970e3 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -6,6 +6,19 @@
 #define BIT(nr)                        (1UL << (nr))
 #define BIT_MASK(nr)           (1UL << ((nr) % BITS_PER_LONG))
 #define BIT_WORD(nr)           ((nr) / BITS_PER_LONG)
+
+/*
+ * Create a contiguous bitmask starting at bit position @lo and ending at
+ * position @hi. For example
+ *
+ * GENMASK_ULL(21, 39) gives us the 64bit vector 0x000000ffffe00000.
+ */
+#define _GENMASK_T(cast, type, lo, hi) \
+       (((cast)(1##type << ((hi) - (lo) + 1)) - 1) << (lo))
+#define GENMASK(lo, hi)                _GENMASK_T(unsigned, U, lo, hi)
+#define GENMASK_UL(lo, hi)     _GENMASK_T(unsigned long, UL, lo, hi)
+#define GENMASK_ULL(lo, hi)    _GENMASK_T(unsigned long long, ULL, lo, hi)
+
 #define BITS_PER_BYTE          8
 #define BITS_TO_LONGS(nr)      DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 #endif

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
