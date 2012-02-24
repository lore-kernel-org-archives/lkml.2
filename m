Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab2BXCmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 21:42:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab2BXCmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 21:42:20 -0500
Date: Thu, 23 Feb 2012 21:42:39 -0500
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, a.p.zijlstra@chello.nl,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120224024238.GB3777@redhat.com>
References: <20120221202019.GB2381@redhat.com>
 <1329856745.25686.72.camel@gandalf.stny.rr.com>
 <20120222073251.GB17291@elte.hu>
 <20120222075334.GA25053@elte.hu>
 <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
 <20120222081855.GB25318@elte.hu>
 <20120222213343.GA19758@bloggs.ozlabs.ibm.com>
 <20120223100205.GD24310@elte.hu>
 <CA+55aFwwV3GsqHue8oUsx-XbvSQXSawJ0w5z=wL8ue=EH4ifzw@mail.gmail.com>
 <20120223223348.GA25513@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223223348.GA25513@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 11:33:48PM +0100, Ingo Molnar wrote:
> 
> Before:
> 
> ffffffff810441f0 <sys_getppid>:
> ffffffff810441f0:       8b 05 8a 52 d8 00       mov    0xd8528a(%rip),%eax        # ffffffff81dc9480 <key>
> ffffffff810441f6:       55                      push   %rbp
> ffffffff810441f7:       48 89 e5                mov    %rsp,%rbp
> ffffffff810441fa:       85 c0                   test   %eax,%eax
> ffffffff810441fc:       75 27                   jne    ffffffff81044225 <sys_getppid+0x35>
> ffffffff810441fe:       65 48 8b 04 25 c0 b6    mov    %gs:0xb6c0,%rax
> ffffffff81044205:       00 00
> ffffffff81044207:       48 8b 80 80 02 00 00    mov    0x280(%rax),%rax
> ffffffff8104420e:       48 8b 80 b0 02 00 00    mov    0x2b0(%rax),%rax
> ffffffff81044215:       48 8b b8 e8 02 00 00    mov    0x2e8(%rax),%rdi
> ffffffff8104421c:       e8 2f da 00 00          callq  ffffffff81051c50 <pid_vnr>
> ffffffff81044221:       5d                      pop    %rbp
> ffffffff81044222:       48 98                   cltq
> ffffffff81044224:       c3                      retq
> ffffffff81044225:       48 c7 c7 13 53 98 81    mov    $0xffffffff81985313,%rdi
> ffffffff8104422c:       31 c0                   xor    %eax,%eax
> ffffffff8104422e:       e8 60 0f 6d 00          callq  ffffffff81715193 <printk>
> ffffffff81044233:       eb c9                   jmp    ffffffff810441fe <sys_getppid+0xe>
> ffffffff81044235:       66 66 2e 0f 1f 84 00    data32 nopw %cs:0x0(%rax,%rax,1)
> ffffffff8104423c:       00 00 00 00
> 
> After:
> 
> ffffffff81044290 <sys_getppid>:
> ffffffff81044290:       55                      push   %rbp
> ffffffff81044291:       48 89 e5                mov    %rsp,%rbp
> ffffffff81044294:       e9 00 00 00 00          jmpq   ffffffff81044299 <sys_getppid+0x9>
> ffffffff81044299:       65 48 8b 04 25 c0 b6    mov    %gs:0xb6c0,%rax
> ffffffff810442a0:       00 00
> ffffffff810442a2:       48 8b 80 80 02 00 00    mov    0x280(%rax),%rax
> ffffffff810442a9:       48 8b 80 b0 02 00 00    mov    0x2b0(%rax),%rax
> ffffffff810442b0:       48 8b b8 e8 02 00 00    mov    0x2e8(%rax),%rdi
> ffffffff810442b7:       e8 f4 d9 00 00          callq  ffffffff81051cb0 <pid_vnr>
> ffffffff810442bc:       5d                      pop    %rbp
> ffffffff810442bd:       48 98                   cltq
> ffffffff810442bf:       c3                      retq
> ffffffff810442c0:       48 c7 c7 e3 54 98 81    mov    $0xffffffff819854e3,%rdi
> ffffffff810442c7:       31 c0                   xor    %eax,%eax
> ffffffff810442c9:       e8 71 13 6d 00          callq  ffffffff8171563f <printk>
> ffffffff810442ce:       eb c9                   jmp    ffffffff81044299 <sys_getppid+0x9>
> 
> The prior slowpath test:
> 
> ffffffff810441fa:       85 c0                   test   %eax,%eax
> ffffffff810441fc:       75 27                   jne    ffffffff81044225 <sys_getppid+0x35>
> 
> became even faster and turned into a single NOP, making the 
> fastpath even faster.
> 

and the: mov    0xd8528a(%rip),%eax        # ffffffff81dc9480 <key>

is no longer present.

Thanks,

-Jason
