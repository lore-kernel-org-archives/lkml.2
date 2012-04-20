Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab2DTAb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:31:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43011 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab2DTAb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:31:26 -0400
MIME-Version: 1.0
In-Reply-To: <1334867644-2722-1-git-send-email-acme@infradead.org>
References: <1334867644-2722-1-git-send-email-acme@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Apr 2012 17:31:04 -0700
X-Google-Sender-Auth: GUacBzBLwH79nSjZDK_9UUXMCVE
Message-ID: <CA+55aFxY0MWR2vTRwf7a6+wm0gXet-X+i11=V_OapneciTJJMg@mail.gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 1:33 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
>
> Annotate improvements
>
> Now the default annotate browser uses a much more compact format, implementing
> suggestions made made by several people, notably Linus.
>
> Here is part of the new __list_del_entry annotation:

Ok, so I did a quick test-run, and things are definitely more readable.

However, from a "where is the loop" angle, the one thing that is
actually fairly hard to visually see is the branches.

Sure, you can find them, but they are not nearly as easy to pick out
visually as the branch targets are, and I do wonder if it wouldn't
make sense to try to make them stand out a bit more.

What is visually important is
 (a) seeing that it's a branch
 (b) seeing the direction of the branch (to pick up on loops more easily).

I suspect that doing a whole arrow is just going to be a horrible
criss-crossing mess (although with some graphical UI it might not be
as bad as with the textual one), but I think even just doing it in
entirely local scope of the particular line that contains the branch
would be perfectly fine.

This, for example, is a snippet of a pretty simple function
(avc_lookup()) with a few branches and a few branch targets:

    2.08 │      test   %rdx,%rdx
    0.00 │      jne    38
    0.00 │      jmp    53
    5.13 │ 30:  mov    (%rdx),%rdx
    0.74 │      test   %rdx,%rdx
    0.00 │      je     53
    0.06 │ 38:  lea    -0x20(%rdx),%rax
   59.64 │      cmp    -0x20(%rdx),%edi
    0.40 │      jne    30
   17.36 │      cmp    -0x18(%rdx),%cx
    0.00 │      jne    30
    1.91 │      cmp    0x4(%rax),%esi
    0.00 │      jne    30
    0.22 │      test   %rax,%rax
    0.20 │      je     53
    1.68 │      leaveq
    1.90 │      retq
    0.00 │ 53:  incl   %gs:0xe214
    0.00 │      xor    %eax,%eax

and the branch targets are fairly easy to pick up, but seeing the
branches - and their directions - themselves takes much more parsing.
Ok, it's actually pretty simple above, because they have a faily
obvious pattern, but in bigger functions they really are harder to
pick out.

Now, what if the branch instruction was just followed with a simple
"arrow up/down" thing, and to make the distinction really simple to
see visually, make the indentation slightly different for the
back/forwards case, so that you don't have to really look at the
(crappy) arrow head to find possible loops (backwards jumps).

The above snippet would then become:

    2.08        test   %rdx,%rdx
    0.00        jne    38                  ----v
    0.00        jmp    53                  ----v
    5.13   30:  mov    (%rdx),%rdx
    0.74        test   %rdx,%rdx
    0.00        je     53                  ----v
    0.06   38:  lea    -0x20(%rdx),%rax
   59.64        cmp    -0x20(%rdx),%edi
    0.40        jne    30                      ----^
   17.36        cmp    -0x18(%rdx),%cx
    0.00        jne    30                      ----^
    1.91        cmp    0x4(%rax),%esi
    0.00        jne    30                      ----^
    0.22        test   %rax,%rax
    0.20        je     53                  ----v
    1.68        leaveq
    1.90        retq
    0.00   53:  incl   %gs:0xe214
    0.00        xor    %eax,%eax

where I think it's fairly easy to pick up the branches. Sure, once you
really need to connect them, you do need to compare the offsets (easy
in the above case, less obvious with big complex functions), but just
making it easy to *see* the backwards branches makes it easier to see
the loop, methinks.

I dunno. Just a suggestion. I definitely like the new format better
already, regardless of any arrows.

                   Linus
