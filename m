Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab1LPLqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 06:46:17 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:24801 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1LPLqI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Fri, 16 Dec 2011 06:46:08 -0500
Message-Id: <4EEB3D8B0200007800068759@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 16 Dec 2011 11:46:03 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Alexander van Heukelum" <heukelum@fastmail.fm>, <fweisbec@gmail.com>,
        "Arjan van de Ven" <arjan@infradead.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Use -m-omit-leaf-frame-pointer to shrink text
 size
References: <20111216081915.GA28288@elte.hu>
 <20111216085259.GA2338@elte.hu> <4EEB0E14.9050505@goop.org>
In-Reply-To: <4EEB0E14.9050505@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.12.11 at 10:23, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 12/16/2011 12:53 AM, Ingo Molnar wrote:
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>> [...]
>>>
>>> The call-chains are still intact for quality backtraces and 
>>> for call-chain profiling (perf record -g), as the backtrace 
>>> walker can deduct the full backtrace from the RIP of a leaf 
>>> function and the parent chain.

Are you sure about that even if the leaf function uses rBP for a
different purpose?

>> Hm, noticed one complication while looking at annotated assembly 
>> code in perf top. Code doing function calls from within asm() is 
>> incorrectly marked 'leaf' by GCC:
>>
>> ffffffff812b82d8 <arch_local_save_flags>:
>> ffffffff812b82d8:       ff 14 25 00 d9 c1 81    callq  *0xffffffff81c1d900
>> ffffffff812b82df:       c3                      retq   
>>
>> So all the paravirt details will have to be fixed, so that GCC 
>> is able to see that there's a real function call done inside. 
>> Jeremy, Konrad?

If the above is not a problem, wouldn't this simply result in a skipped
function layer?

Also, iirc it's not just pv-ops that uses calls within asm()-s.

> Um.  So the issue is that a function that contains only pvops looks like
> it's a leaf to gcc and it does some leaf-function optimisation?
> 
> How can we tell gcc the asm contains a call, or otherwise suppress the
> "leaf function" classification?

I'm afraid you can't without adding code (i.e. a dummy function call).

Jan

