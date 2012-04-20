Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab2DTAka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:40:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36850 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2DTAk2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:40:28 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxY0MWR2vTRwf7a6+wm0gXet-X+i11=V_OapneciTJJMg@mail.gmail.com>
References: <1334867644-2722-1-git-send-email-acme@infradead.org> <CA+55aFxY0MWR2vTRwf7a6+wm0gXet-X+i11=V_OapneciTJJMg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Apr 2012 17:40:07 -0700
X-Google-Sender-Auth: Eh3KkOLZuz_Rn6f4JP_neWi5trg
Message-ID: <CA+55aFw7HcpEiffKR_UT=BPn28sRG6BFuho=bY5tnd59jTTVXg@mail.gmail.com>
Subject: Re: [GIT PULL 00/13] Annotation improvements (G+ edition)
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 5:31 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Apr 19, 2012 at 1:33 PM, Arnaldo Carvalho de Melo
> (crappy) arrow head to find possible loops (backwards jumps).
>
> The above snippet would then become:
>
>    2.08        test   %rdx,%rdx
>    0.00        jne    38                  ----v
>    0.00        jmp    53                  ----v
>    5.13   30:  mov    (%rdx),%rdx
>    0.74        test   %rdx,%rdx
>    0.00        je     53                  ----v
>    0.06   38:  lea    -0x20(%rdx),%rax
>   59.64        cmp    -0x20(%rdx),%edi
>    0.40        jne    30                      ----^
>   17.36        cmp    -0x18(%rdx),%cx
>    0.00        jne    30                      ----^
>    1.91        cmp    0x4(%rax),%esi
>    0.00        jne    30                      ----^
>    0.22        test   %rax,%rax
>    0.20        je     53                  ----v
>    1.68        leaveq
>    1.90        retq
>    0.00   53:  incl   %gs:0xe214
>    0.00        xor    %eax,%eax

Side note: I'm not at all certain that the arrows should be at the end
of the line. It might be even better to show it at the head of the
line, ie something like


    2.08        test   %rdx,%rdx
    0.00 v      jne    38
    0.00 v      jmp    53
    5.13   30:  mov    (%rdx),%rdx
    0.74        test   %rdx,%rdx
    0.00 v      je     53
    0.06   38:  lea    -0x20(%rdx),%rax
   59.64        cmp    -0x20(%rdx),%edi
    0.40 ^--    jne    30
   17.36        cmp    -0x18(%rdx),%cx
    0.00 ^--    jne    30
    1.91        cmp    0x4(%rax),%esi
    0.00 ^--    jne    30
    0.22        test   %rax,%rax
    0.20 v      je     53
    1.68        leaveq
    1.90        retq
    0.00   53:  incl   %gs:0xe214
    0.00        xor    %eax,%eax

but then you obviously need to make it work right if a branch is also
a branch target.

Oh, and one other visual clue that could be useful: unconditional
branches (including "ret") that actually end the flow of code and
don't have a fallthrough to the next instruction would be nice to see
clearly. Even perhaps an empty line following them? Although maybe
that would be wasting precious vertical space..

                              Linus
