Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1FETaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 15:30:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41308 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab1FETaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 15:30:24 -0400
Date: Sun, 5 Jun 2011 21:30:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Message-ID: <20110605193001.GB3971@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <e64e1b3c64858820d12c48fa739efbd1485e79d5.1307292171.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e64e1b3c64858820d12c48fa739efbd1485e79d5.1307292171.git.luto@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@MIT.EDU> wrote:

> This patch is not perfect: the vread_tsc and vread_hpet functions 
> are still at a fixed address.  Fixing that might involve making 
> alternative patching work in the vDSO.

Can you see any problem with them? Here is how they are looking like 
currently:

ffffffffff600100 <vread_tsc>:
ffffffffff600100:	55                   	push   %rbp
ffffffffff600101:	48 89 e5             	mov    %rsp,%rbp
ffffffffff600104:	66 66 90             	data32 xchg %ax,%ax
ffffffffff600107:	66 66 90             	data32 xchg %ax,%ax
ffffffffff60010a:	0f 31                	rdtsc  
ffffffffff60010c:	89 c1                	mov    %eax,%ecx
ffffffffff60010e:	48 89 d0             	mov    %rdx,%rax
ffffffffff600111:	48 8b 14 25 28 0d 60 	mov    0xffffffffff600d28,%rdx
ffffffffff600118:	ff 
ffffffffff600119:	48 c1 e0 20          	shl    $0x20,%rax
ffffffffff60011d:	48 09 c8             	or     %rcx,%rax
ffffffffff600120:	48 39 d0             	cmp    %rdx,%rax
ffffffffff600123:	73 03                	jae    ffffffffff600128 <vread_tsc+0x28>
ffffffffff600125:	48 89 d0             	mov    %rdx,%rax
ffffffffff600128:	5d                   	pop    %rbp
ffffffffff600129:	c3                   	retq   

ffffffffff60012a <vread_hpet>:
ffffffffff60012a:	55                   	push   %rbp
ffffffffff60012b:	48 89 e5             	mov    %rsp,%rbp
ffffffffff60012e:	8b 04 25 f0 f0 5f ff 	mov    0xffffffffff5ff0f0,%eax
ffffffffff600135:	89 c0                	mov    %eax,%eax
ffffffffff600137:	5d                   	pop    %rbp
ffffffffff600138:	c3                   	retq   

There's no obvious syscall instruction in them that i can see. No 
0x0f 0x05 pattern (even misaligned), no 0xcd-anything.

We could even 'tie down' the actual assembly by moving this all to a 
.S - this way we protect against GCC accidentally generating 
something dangerous in there. I suggested that before.

Thanks,

	Ingo
