Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762666Ab2FVTzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:55:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28881 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab2FVTy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:54:59 -0400
X-Authority-Analysis: v=2.0 cv=cIliQyiN c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=3j4BkbkPAAAA:8 a=RvEWLS4KC4aJKWMv6ZsA:9 a=PUjeQqilurYA:10 a=tXsnliwV7b4A:10 a=Z9puGo2VY4EA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340394896.27036.258.camel@gandalf.stny.rr.com>
Subject: Re: [GIT PULL] perf fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 22 Jun 2012 15:54:56 -0400
In-Reply-To: <20120622190632.GB8014@virgo.local>
References: <20120622133650.GA24136@gmail.com>
	 <CA+55aFySaZ4huXgPM0yGPezAhnE9zT81tucC9WnDs5Ps+7+hGA@mail.gmail.com>
	 <20120622183827.GA8014@virgo.local>
	 <CA+55aFzpNtLSQvcOOut--2UkkMyqSb9e0_VO3JAxvZRTv7YT1g@mail.gmail.com>
	 <20120622190632.GB8014@virgo.local>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 21:06 +0200, Hagen Paul Pfeifer wrote:

> >I may be more sensitive to this than most, because I look at profiles
> >and the function prologue just looks very ugly with the call mcount
> >thing. Ugh.
> 
> Yes, ugh. Even Stevens -mfentry replacement do not change things here.

Why doesn't -mfentry help here? The link I showed still had frame
pointers enabled. With -mfentry, frame pointers do not need to be
enabled. And my latest patches do not automatically enable frame
pointers when enabling function tracing if -mfentry is supported.

I just ran a bunch of compiles against kernel/sched/core.c:

no pg, no mfentry, no fp:

0000000000000882 <schedule>:
 882:   65 48 8b 04 25 00 00    mov    %gs:0x0,%rax
 889:   00 00 
                        887: R_X86_64_32S       current_task
 88b:   57                      push   %rdi
 88c:   48 8b 10                mov    (%rax),%rdx
 88f:   48 85 d2                test   %rdx,%rdx
 892:   74 45                   je     8d9 <schedule+0x57>
 894:   48 83 b8 60 06 00 00    cmpq   $0x0,0x660(%rax)
 89b:   00 
 89c:   75 3b                   jne    8d9 <schedule+0x57>
 89e:   48 8b b8 60 0e 00 00    mov    0xe60(%rax),%rdi
 8a5:   31 c0                   xor    %eax,%eax
 8a7:   48 85 ff                test   %rdi,%rdi
 8aa:   74 1a                   je     8c6 <schedule+0x44>
 8ac:   48 8d 57 08             lea    0x8(%rdi),%rdx
 8b0:   48 39 57 08             cmp    %rdx,0x8(%rdi)
 8b4:   b0 01                   mov    $0x1,%al
 8b6:   75 0e                   jne    8c6 <schedule+0x44>
 8b8:   48 8d 47 18             lea    0x18(%rdi),%rax
 8bc:   48 39 47 18             cmp    %rax,0x18(%rdi)
 8c0:   0f 95 c0                setne  %al
 8c3:   0f b6 c0                movzbl %al,%eax
 8c6:   85 c0                   test   %eax,%eax
 8c8:   74 0f                   je     8d9 <schedule+0x57>
 8ca:   48 85 ff                test   %rdi,%rdi
 8cd:   74 0a                   je     8d9 <schedule+0x57>
 8cf:   be 01 00 00 00          mov    $0x1,%esi
 8d4:   e8 00 00 00 00          callq  8d9 <schedule+0x57>
                        8d5: R_X86_64_PC32      blk_flush_plug_list-0x4
 8d9:   e8 70 f9 ff ff          callq  24e <__schedule>
 8de:   5e                      pop    %rsi
 8df:   c3                      retq   


no pg, no mfentry, with fp:

00000000000008cb <schedule>:
 8cb:   55                      push   %rbp
 8cc:   65 48 8b 04 25 00 00    mov    %gs:0x0,%rax
 8d3:   00 00 
                        8d1: R_X86_64_32S       current_task
 8d5:   48 8b 10                mov    (%rax),%rdx
 8d8:   48 89 e5                mov    %rsp,%rbp
 8db:   48 85 d2                test   %rdx,%rdx
 8de:   74 45                   je     925 <schedule+0x5a>
 8e0:   48 83 b8 60 06 00 00    cmpq   $0x0,0x660(%rax)
 8e7:   00 
 8e8:   75 3b                   jne    925 <schedule+0x5a>
 8ea:   48 8b b8 60 0e 00 00    mov    0xe60(%rax),%rdi
 8f1:   31 c0                   xor    %eax,%eax
 8f3:   48 85 ff                test   %rdi,%rdi
 8f6:   74 1a                   je     912 <schedule+0x47>
 8f8:   48 8d 57 08             lea    0x8(%rdi),%rdx
 8fc:   48 39 57 08             cmp    %rdx,0x8(%rdi)
 900:   b0 01                   mov    $0x1,%al
 902:   75 0e                   jne    912 <schedule+0x47>
 904:   48 8d 47 18             lea    0x18(%rdi),%rax
 908:   48 39 47 18             cmp    %rax,0x18(%rdi)
 90c:   0f 95 c0                setne  %al
 90f:   0f b6 c0                movzbl %al,%eax
 912:   85 c0                   test   %eax,%eax
 914:   74 0f                   je     925 <schedule+0x5a>
 916:   48 85 ff                test   %rdi,%rdi
 919:   74 0a                   je     925 <schedule+0x5a>
 91b:   be 01 00 00 00          mov    $0x1,%esi
 920:   e8 00 00 00 00          callq  925 <schedule+0x5a>
                        921: R_X86_64_PC32      blk_flush_plug_list-0x4
 925:   e8 41 f9 ff ff          callq  26b <__schedule>
 92a:   5d                      pop    %rbp
 92b:   c3                      retq   

The above is our basis. Now lets look at the current -pg

with pg, no mfentry, with fp:

000000000000090c <schedule>:
 90c:   55                      push   %rbp
 90d:   48 89 e5                mov    %rsp,%rbp
 910:   e8 00 00 00 00          callq  915 <schedule+0x9>
                        911: R_X86_64_PC32      mcount-0x4
 915:   65 48 8b 04 25 00 00    mov    %gs:0x0,%rax
 91c:   00 00 
                        91a: R_X86_64_32S       current_task
 91e:   48 8b 10                mov    (%rax),%rdx
 921:   48 85 d2                test   %rdx,%rdx
 924:   74 45                   je     96b <schedule+0x5f>
 926:   48 83 b8 60 06 00 00    cmpq   $0x0,0x660(%rax)
 92d:   00 
 92e:   75 3b                   jne    96b <schedule+0x5f>
 930:   48 8b b8 60 0e 00 00    mov    0xe60(%rax),%rdi
 937:   31 c0                   xor    %eax,%eax
 939:   48 85 ff                test   %rdi,%rdi
 93c:   74 1a                   je     958 <schedule+0x4c>
 93e:   48 8d 57 08             lea    0x8(%rdi),%rdx
 942:   48 39 57 08             cmp    %rdx,0x8(%rdi)
 946:   b0 01                   mov    $0x1,%al
 948:   75 0e                   jne    958 <schedule+0x4c>
 94a:   48 8d 47 18             lea    0x18(%rdi),%rax
 94e:   48 39 47 18             cmp    %rax,0x18(%rdi)
 952:   0f 95 c0                setne  %al
 955:   0f b6 c0                movzbl %al,%eax
 958:   85 c0                   test   %eax,%eax
 95a:   74 0f                   je     96b <schedule+0x5f>
 95c:   48 85 ff                test   %rdi,%rdi
 95f:   74 0a                   je     96b <schedule+0x5f>
 961:   be 01 00 00 00          mov    $0x1,%esi
 966:   e8 00 00 00 00          callq  96b <schedule+0x5f>
                        967: R_X86_64_PC32      blk_flush_plug_list-0x4
 96b:   e8 37 f9 ff ff          callq  2a7 <__schedule>
 970:   5d                      pop    %rbp
 971:   c3                      retq   

Looks like %rsp is saved in %rbp here as well as the call to mcount.

-pg must have frame pointers when -mfentry is not included, so there is
no 'with pg, no mfentry, no fp'. Now lets look at mfentry:

with pg, with mfentry, with fp:

000000000000090c <schedule>:
 90c:   e8 00 00 00 00          callq  911 <schedule+0x5>
                        90d: R_X86_64_PC32      __fentry__-0x4
 911:   55                      push   %rbp
 912:   65 48 8b 04 25 00 00    mov    %gs:0x0,%rax
 919:   00 00 
                        917: R_X86_64_32S       current_task
 91b:   48 8b 10                mov    (%rax),%rdx
 91e:   48 89 e5                mov    %rsp,%rbp
 921:   48 85 d2                test   %rdx,%rdx
 924:   74 45                   je     96b <schedule+0x5f>
 926:   48 83 b8 60 06 00 00    cmpq   $0x0,0x660(%rax)
 92d:   00 
 92e:   75 3b                   jne    96b <schedule+0x5f>
 930:   48 8b b8 60 0e 00 00    mov    0xe60(%rax),%rdi
 937:   31 c0                   xor    %eax,%eax
 939:   48 85 ff                test   %rdi,%rdi
 93c:   74 1a                   je     958 <schedule+0x4c>
 93e:   48 8d 57 08             lea    0x8(%rdi),%rdx
 942:   48 39 57 08             cmp    %rdx,0x8(%rdi)
 946:   b0 01                   mov    $0x1,%al
 948:   75 0e                   jne    958 <schedule+0x4c>
 94a:   48 8d 47 18             lea    0x18(%rdi),%rax
 94e:   48 39 47 18             cmp    %rax,0x18(%rdi)
 952:   0f 95 c0                setne  %al
 955:   0f b6 c0                movzbl %al,%eax
 958:   85 c0                   test   %eax,%eax
 95a:   74 0f                   je     96b <schedule+0x5f>
 95c:   48 85 ff                test   %rdi,%rdi
 95f:   74 0a                   je     96b <schedule+0x5f>
 961:   be 01 00 00 00          mov    $0x1,%esi
 966:   e8 00 00 00 00          callq  96b <schedule+0x5f>
                        967: R_X86_64_PC32      blk_flush_plug_list-0x4
 96b:   e8 37 f9 ff ff          callq  2a7 <__schedule>
 970:   5d                      pop    %rbp
 971:   c3                      retq   


It is identical with non -pg and frame pointers, except that we added a
call to fentry in the start of the function.

with pg, with fentry, no fp:

00000000000008c3 <schedule>:
 8c3:   e8 00 00 00 00          callq  8c8 <schedule+0x5>
                        8c4: R_X86_64_PC32      __fentry__-0x4
 8c8:   65 48 8b 04 25 00 00    mov    %gs:0x0,%rax
 8cf:   00 00 
                        8cd: R_X86_64_32S       current_task
 8d1:   57                      push   %rdi
 8d2:   48 8b 10                mov    (%rax),%rdx
 8d5:   48 85 d2                test   %rdx,%rdx
 8d8:   74 45                   je     91f <schedule+0x5c>
 8da:   48 83 b8 60 06 00 00    cmpq   $0x0,0x660(%rax)
 8e1:   00 
 8e2:   75 3b                   jne    91f <schedule+0x5c>
 8e4:   48 8b b8 60 0e 00 00    mov    0xe60(%rax),%rdi
 8eb:   31 c0                   xor    %eax,%eax
 8ed:   48 85 ff                test   %rdi,%rdi
 8f0:   74 1a                   je     90c <schedule+0x49>
 8f2:   48 8d 57 08             lea    0x8(%rdi),%rdx
 8f6:   48 39 57 08             cmp    %rdx,0x8(%rdi)
 8fa:   b0 01                   mov    $0x1,%al
 8fc:   75 0e                   jne    90c <schedule+0x49>
 8fe:   48 8d 47 18             lea    0x18(%rdi),%rax
 902:   48 39 47 18             cmp    %rax,0x18(%rdi)
 906:   0f 95 c0                setne  %al
 909:   0f b6 c0                movzbl %al,%eax
 90c:   85 c0                   test   %eax,%eax
 90e:   74 0f                   je     91f <schedule+0x5c>
 910:   48 85 ff                test   %rdi,%rdi
 913:   74 0a                   je     91f <schedule+0x5c>
 915:   be 01 00 00 00          mov    $0x1,%esi
 91a:   e8 00 00 00 00          callq  91f <schedule+0x5c>
                        91b: R_X86_64_PC32      blk_flush_plug_list-0x4
 91f:   e8 66 f9 ff ff          callq  28a <__schedule>
 924:   5e                      pop    %rsi
 925:   c3                      retq   

Now here's the big difference from -pg. This is identical to compiling
without frame pointers with the exception of the fentry call at the
start of the function.

Now what's the issue with function prologues with -mfentry?

-- Steve


