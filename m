Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2BVPm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:42:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2BVPmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:42:25 -0500
Date: Wed, 22 Feb 2012 10:42:07 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120222154206.GA3405@redhat.com>
References: <20120222072538.GA17291@elte.hu>
 <4F449ACF.3040807@zytor.com>
 <20120222074839.GA24890@elte.hu>
 <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>
 <20120222080659.GA25318@elte.hu>
 <1329916920.25686.79.camel@gandalf.stny.rr.com>
 <20120222133404.GA14085@elte.hu>
 <1329918881.25686.92.camel@gandalf.stny.rr.com>
 <20120222145614.GA2491@elte.hu>
 <1329923533.25686.106.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329923533.25686.106.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 10:12:13AM -0500, Steven Rostedt wrote:
> On Wed, 2012-02-22 at 15:56 +0100, Ingo Molnar wrote:
> 
> > > Because it really just looks like a stronger "unlikely()" and 
> > > fundamentally it really isn't. [...]
> > 
> > Well, the fact is that right now it *is* a stronger unlikely() 
> > on architectures that have jump-labels and it's mapped to 
> > unlikely() on others.
> > 
> 
> Has gcc been fix to make it truly an unlikely case and remove the "jmp;
> jmp" problem of before? I'm still using gcc 4.6.0 which has the
> following code for a tracepoint (example is the
> trace_sched_migrate_task().
> 
>     5b4a:       e9 00 00 00 00          jmpq   5b4f <set_task_cpu+0x5e>
> 
> The above is the jump label that turns into a nop at boot up.
> 
>     5b4f:       eb 19                   jmp    5b6a <set_task_cpu+0x79>
> 
> Here we jump over some of the trace code (this is the fast path)
> 
>     5b51:       49 8b 7d 08             mov    0x8(%r13),%rdi
>     5b55:       44 89 e2                mov    %r12d,%edx
>     5b58:       48 89 de                mov    %rbx,%rsi
>     5b5b:       41 ff 55 00             callq  *0x0(%r13)
>     5b5f:       49 83 c5 10             add    $0x10,%r13
>     5b63:       49 83 7d 00 00          cmpq   $0x0,0x0(%r13)
>     5b68:       eb 41                   jmp    5bab <set_task_cpu+0xba>
> 
> Below is the continuation of the fast path.
> 
>     5b6a:       48 8b 43 08             mov    0x8(%rbx),%rax
>     5b6e:       44 39 60 18             cmp    %r12d,0x18(%rax)
>     5b72:       74 0c                   je     5b80 <set_task_cpu+0x8f>
> 
> 
> Again, I'm using gcc 4.6.0 and maybe it has been fixed.
> 
> -- Steve
> 
> 

Hi Steve,

Using 4.6.2, I don't see the 'jmp;jmp' issue. I have:

ffffffff810610c0 <set_task_cpu>:
ffffffff810610c0:       55                      push   %rbp
ffffffff810610c1:       48 89 e5                mov    %rsp,%rbp
ffffffff810610c4:       48 81 ec e0 00 00 00    sub    $0xe0,%rsp
ffffffff810610cb:       48 89 5d d8             mov    %rbx,-0x28(%rbp)
ffffffff810610cf:       4c 89 65 e0             mov    %r12,-0x20(%rbp)
ffffffff810610d3:       48 89 fb                mov    %rdi,%rbx
ffffffff810610d6:       4c 89 6d e8             mov    %r13,-0x18(%rbp)
ffffffff810610da:       4c 89 75 f0             mov    %r14,-0x10(%rbp)
ffffffff810610de:       41 89 f4                mov    %esi,%r12d
ffffffff810610e1:       4c 89 7d f8             mov    %r15,-0x8(%rbp)

no double jump here.

ffffffff810610e5:       e9 00 00 00 00          jmpq   ffffffff810610ea <set_task_cpu+0x2a>
ffffffff810610ea:       48 8b 43 08             mov    0x8(%rbx),%rax
ffffffff810610ee:       44 3b 60 18             cmp    0x18(%rax),%r12d
ffffffff810610f2:       74 0d                   je     ffffffff81061101 <set_task_cpu+0x41>
ffffffff810610f4:       48 83 83 a8 00 00 00    addq   $0x1,0xa8(%rbx)
ffffffff810610fb:       01

no double jump here.

ffffffff810610fc:       e9 00 00 00 00          jmpq   ffffffff81061101 <set_task_cpu+0x41>
ffffffff81061101:       48 8b 83 60 06 00 00    mov    0x660(%rbx),%rax
ffffffff81061108:       48 8b 50 40             mov    0x40(%rax),%rdx
ffffffff8106110c:       44 89 e0                mov    %r12d,%eax
ffffffff8106110f:       48 8b 4a 28             mov    0x28(%rdx),%rcx
ffffffff81061113:       48 8b 0c c1             mov    (%rcx,%rax,8),%rcx
ffffffff81061117:       48 89 8b 90 01 00 00    mov    %rcx,0x190(%rbx)
ffffffff8106111e:       48 8b 52 20             mov    0x20(%rdx),%rdx
ffffffff81061122:       48 8b 04 c2             mov    (%rdx,%rax,8),%rax
ffffffff81061126:       48 89 83 88 01 00 00    mov    %rax,0x188(%rbx)
ffffffff8106112d:       48 8b 43 08             mov    0x8(%rbx),%rax
ffffffff81061131:       44 89 60 18             mov    %r12d,0x18(%rax)
ffffffff81061135:       48 8b 5d d8             mov    -0x28(%rbp),%rbx
ffffffff81061139:       4c 8b 65 e0             mov    -0x20(%rbp),%r12
ffffffff8106113d:       4c 8b 6d e8             mov    -0x18(%rbp),%r13
ffffffff81061141:       4c 8b 75 f0             mov    -0x10(%rbp),%r14
ffffffff81061145:       4c 8b 7d f8             mov    -0x8(%rbp),%r15
ffffffff81061149:       c9                      leaveq
ffffffff8106114a:       c3                      retq

....

Do you have 'CONFIG_CC_OPTIMIZE_FOR_SIZE' set?

Thanks,

-Jason
