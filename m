Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab2HSPPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:15:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58340 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab2HSPPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:15:18 -0400
Date: Sun, 19 Aug 2012 17:15:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <jbeulich@suse.com>
Cc: andi@firstfloor.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, akpm@linux-foundation.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 46/74] x86, lto: Disable fancy hweight optimizations for LTO
Message-ID: <20120819151516.GS11413@one.firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-47-git-send-email-andi@firstfloor.org> <5030B1A5020000780008A200@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5030B1A5020000780008A200@nat28.tlf.novell.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> By moving this last line first you can avoid modifying the other two lines.

Ok.

> 
> >--- a/arch/x86/include/asm/arch_hweight.h
> >+++ b/arch/x86/include/asm/arch_hweight.h
> >@@ -25,9 +25,14 @@ static inline unsigned int __arch_hweight32(unsigned int w)
> >{
> >    unsigned int res = 0;
>  >
> >+#ifdef CONFIG_LTO
> >+    res  = __sw_hweight32(w);
> >+#else
> >+
> >    asm (ALTERNATIVE("call __sw_hweight32", POPCNT32, X86_FEATURE_POPCNT)
> >             : "="REG_OUT (res)
> >             : REG_IN (w));
> >+#endif
>  
> Isn't this a little to harsh? Rather than not using popcnt at all, why don't you just add
> the necessary clobbers to the asm() in the LTO case?

gcc lacks the means to declare that a asm uses an external symbol
currently. Ok we could make it visible. But there's no way to make the
special calling convention work anyways, at least not without someone 
changing gcc to allow to declare this per function.

I'm not sure the optimization is really worth it anyways, hweight should
be uncommon.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
