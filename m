Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab2HSI2N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:28:13 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:34331 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2HSI2J convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Sun, 19 Aug 2012 04:28:09 -0400
Message-Id: <5030B1A5020000780008A200@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Sun, 19 Aug 2012 09:28:05 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <andi@firstfloor.org>, <ak@linux.intel.com>,
        <linux-kernel@vger.kernel.org>
Cc: <x86@kernel.org>, <akpm@linux-foundation.org>, <mmarek@suse.cz>,
        <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 46/74] x86, lto: Disable fancy hweight
 optimizations for LTO
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
 <1345345030-22211-47-git-send-email-andi@firstfloor.org>
In-Reply-To: <1345345030-22211-47-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <andi@firstfloor.org> 08/19/12 4:58 AM >>>
>--- a/arch/x86/Kconfig
>+++ b/arch/x86/Kconfig
>@@ -224,8 +224,9 @@ config X86_32_LAZY_GS
 >
>config ARCH_HWEIGHT_CFLAGS
>    string
>-    default "-fcall-saved-ecx -fcall-saved-edx" if X86_32
>-    default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64
>+    default "-fcall-saved-ecx -fcall-saved-edx" if X86_32 && !LTO
>+    default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64 && !LTO
>+    default "" if LTO
 
By moving this last line first you can avoid modifying the other two lines.

>--- a/arch/x86/include/asm/arch_hweight.h
>+++ b/arch/x86/include/asm/arch_hweight.h
>@@ -25,9 +25,14 @@ static inline unsigned int __arch_hweight32(unsigned int w)
>{
>    unsigned int res = 0;
 >
>+#ifdef CONFIG_LTO
>+    res  = __sw_hweight32(w);
>+#else
>+
>    asm (ALTERNATIVE("call __sw_hweight32", POPCNT32, X86_FEATURE_POPCNT)
>             : "="REG_OUT (res)
>             : REG_IN (w));
>+#endif
 
Isn't this a little to harsh? Rather than not using popcnt at all, why don't you just add
the necessary clobbers to the asm() in the LTO case?

Jan

