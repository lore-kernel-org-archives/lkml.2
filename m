Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2HTK5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 06:57:20 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:33083 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2HTK5S convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Mon, 20 Aug 2012 06:57:18 -0400
Message-Id: <50323427020000780009660E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 20 Aug 2012 11:57:11 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: <x86@kernel.org>, <akpm@linux-foundation.org>, <ak@linux.intel.com>,
        <mmarek@suse.cz>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 46/74] x86, lto: Disable fancy hweight
 optimizations for LTO
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
 <1345345030-22211-47-git-send-email-andi@firstfloor.org>
 <5030B1A5020000780008A200@nat28.tlf.novell.com>
 <20120819151516.GS11413@one.firstfloor.org>
In-Reply-To: <20120819151516.GS11413@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.08.12 at 17:15, Andi Kleen <andi@firstfloor.org> wrote:
>> >--- a/arch/x86/include/asm/arch_hweight.h
>> >+++ b/arch/x86/include/asm/arch_hweight.h
>> >@@ -25,9 +25,14 @@ static inline unsigned int __arch_hweight32(unsigned int w)
>> >{
>> >    unsigned int res = 0;
>>  >
>> >+#ifdef CONFIG_LTO
>> >+    res  = __sw_hweight32(w);
>> >+#else
>> >+
>> >    asm (ALTERNATIVE("call __sw_hweight32", POPCNT32, X86_FEATURE_POPCNT)
>> >             : "="REG_OUT (res)
>> >             : REG_IN (w));
>> >+#endif
>>  
>> Isn't this a little to harsh? Rather than not using popcnt at all, why don't 
>> you just add the necessary clobbers to the asm() in the LTO case?
> 
> gcc lacks the means to declare that a asm uses an external symbol
> currently. Ok we could make it visible. But there's no way to make the
> special calling convention work anyways, at least not without someone 
> changing gcc to allow to declare this per function.

That's not the point: The point really is that you could allow the
alternative regardless of LTO, and just penalize the LTO case
by having even the asm clobber the registers that a function call
would not preserve.

> I'm not sure the optimization is really worth it anyways, hweight should
> be uncommon.

That's a separate question (but I sort of agree - not sure whether
CPU mask weights ever get calculated on hot paths).

Jan

