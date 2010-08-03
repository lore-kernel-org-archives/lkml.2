Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab0HCKGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:06:46 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:57848 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab0HCKGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:06:44 -0400
Message-ID: <4C57EA2F.6050308@davidnewall.com>
Date: Tue, 03 Aug 2010 19:36:39 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Doug Dahlby <Doug.Dahlby@atheros.com>, linux-kernel@vger.kernel.org,
        mcgrof@gmail.com, jirislaby@gmail.com
Subject: Re: Using unsigned int for loop counters - better performance for
 Architectures - urban hacker legend?
References: <AANLkTi=AuFBwT5AjRdjrkbe3=5d36TNr4Cp=r0VnEogH@mail.gmail.com> <4C53EF30.5020303@davidnewall.com> <B7132A25476D334D9130FE7532F2A563109FED150D@SC1EXMB-MBCL.global.atheros.com> <20100802193712.GB8920@tux> <B7132A25476D334D9130FE7532F2A563109FED151A@SC1EXMB-MBCL.global.atheros.com> <20100802204827.GF8920@tux>
In-Reply-To: <20100802204827.GF8920@tux>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> Doug, I'm adding your response to lkml as its the best answer I've gotten so far.

If I may point out, Doug's result is correct for his combination of CPU 
and compiler, but not necessarily for other combinations. It is not 
something that should be promulgated unless you caveat by architecture 
and even version of compiler. As Linux is architecture neutral, the 
question about performance of signed versus unsigned is irrelevant 
except in architecture-specific code, and you would code it in 
assembler, not in C.

Don't recommend signed versus unsigned for reason of efficiency, only 
for reason of clarity or accuracy.

When I compile Doug's function for ia32 using gcc (Ubunut 
4.3.3-5ubuntu4) with -O3, I get totally different code emitted than he:

signed_count_down:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	popl	%ebp
	movl	%eax, %edx
	sarl	$31, %edx
	notl	%edx
	andl	%edx, %eax
	ret

The exact same code is emitted if the loop is changed to count up (i.e; 
int j; for (j = 0; j < limit; j++) ...)

By contrast, the code emitted when using unsigned, regardless of whether 
counting up or down, is:

unsigned_count_up:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	popl	%ebp
	ret

I find this code interesting because it contains no loop and no test. It 
works because, in the case of unsigned loop, the function returns its 
input. When limit is signed, the function returns its input if that is 
positive, otherwise it returns zero. Observe that the unsigned code is 
identical to the signed but for the addition of the four instructions 
before the (unsigned code's) ret.

I think all instructions on IA32 take multiple stages to execute. These 
stages occur inside a "pipeline;" op-codes are fed in one end and, a few 
cycles later, the result pops out the other. To make the machine, IA32 
uses multiple execution units in parallel, i.e. multiple pipelines, with 
each unit running one stage behind, and executing the instruction 
following, the previous execution unit. Some instructions, however, 
cannot be executed in parallel. Consider a conditional-branch: should 
the next instruction be the target of the branch or the one that follows 
the branch? Whichever answer you think is best, some of the time it will 
be wrong and when that occurs the second and subsequent pipelines must 
be flushed, thus stalling the CPU (that is, it produces no results) for 
some number of cycles. So it can be understood that elimination of the 
branches gives a big performance boost on ia32.

Consider the four extra instructions in the signed code: These load 
limit into a register and then shift right by 31 bits. If limit is 
negative, it's 32nd bit will be a one, otherwise a zero. The shift moves 
that 32nd bit into the remaining 31, giving -1 for negative limit, 
otherwise zero. The notl instruction inverts this value; thus the 
function returns 0&limit (which is always zero) for negative limit, 
otherwise -1&limit (which is always limit.) It's a clever optimisation; 
but one which would be wrong to write except in very limited circumstances.

When coding, if you must choose between the two, you should usually 
write something which is easily understood rather than something which 
is fast. Fast-but-confusing code is likely to bite someone down the 
track, and as we've seen, might not even produce the efficient machine 
code that you expect.

Here is my favourite example of what not to do. Your task is to name it.

void ???(int i, int j) { i ^= j ^= i ^= j; }

As Knuth (probably) said, "Premature optimization is the root of all evil."
