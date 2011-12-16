Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218Ab1LPJXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 04:23:41 -0500
Received: from claw.goop.org ([74.207.240.146]:50725 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756434Ab1LPJXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 04:23:35 -0500
Message-ID: <4EEB0E14.9050505@goop.org>
Date: Fri, 16 Dec 2011 01:23:32 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_W?= =?ISO-8859-1?Q?eisbecker?= 
	<fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] x86: Use -m-omit-leaf-frame-pointer to shrink text size
References: <20111216081915.GA28288@elte.hu> <20111216085259.GA2338@elte.hu>
In-Reply-To: <20111216085259.GA2338@elte.hu>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 12:53 AM, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> [...]
>>
>> The call-chains are still intact for quality backtraces and 
>> for call-chain profiling (perf record -g), as the backtrace 
>> walker can deduct the full backtrace from the RIP of a leaf 
>> function and the parent chain.
> Hm, noticed one complication while looking at annotated assembly 
> code in perf top. Code doing function calls from within asm() is 
> incorrectly marked 'leaf' by GCC:
>
> ffffffff812b82d8 <arch_local_save_flags>:
> ffffffff812b82d8:       ff 14 25 00 d9 c1 81    callq  *0xffffffff81c1d900
> ffffffff812b82df:       c3                      retq   
>
> So all the paravirt details will have to be fixed, so that GCC 
> is able to see that there's a real function call done inside. 
> Jeremy, Konrad?

Um.  So the issue is that a function that contains only pvops looks like
it's a leaf to gcc and it does some leaf-function optimisation?

How can we tell gcc the asm contains a call, or otherwise suppress the
"leaf function" classification?

The alternative is to just make it a plain C-level indirect call, but
then we'd lose all the patching and callee-save optimisations.

Any suggestions?

Thanks,
    J

