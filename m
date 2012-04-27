Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748Ab2D0QgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:36:21 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38962 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab2D0QgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:36:20 -0400
MIME-Version: 1.0
In-Reply-To: <1335452777-27326-1-git-send-email-acme@infradead.org>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 09:35:58 -0700
X-Google-Sender-Auth: 2cqw7osVGCqKQHZnwcmaEYLDUNw
Message-ID: <CA+55aFy7QLXRWQSjUiYNhX5B9p-0AJ4LSWc=km8hJ55ku=ho0A@mail.gmail.com>
Subject: Re: [GIT PULL 0/4] perf/annotate loop detection V2, fixes
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 8:06 AM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
>
> Fixes on top of the previous perf/annotate pull request
>
> . Sometimes a jump points to an offset with no instructions, make the
>  mark jump targets function handle that, for now just ignoring such
>  jump targets, more investigation is needed to figure out how to cope
>  with that.
>
> . Handle jump targets that are outside the function, for now just don't
>  try to draw the connector arrow, right thing seems to be to mark this
>  jump with a -> (right arrow) and handle it like a callq.

Ok, this looks pretty good, but I do have a few comments:

 - the "jumping around" of the loop view is distracting. I think it's
a very useful concept and generally well done, but quite frankly,
scrolling around a function and having the loop detection jump around
as you just want to scroll down is not a good interface. It just makes
the screen flicker annoyingly.

   I think it would be better to just make it static. I'd suggest
perhaps to show the loop when you explicitly ask for it (by pressing
"space" on the branch or the target or whatever), and *perhaps* by
default just statically show any non-overlapping loops (I don't care
what the priority is: inner-most, outer-most or "first branch seen" or
whatever).

 - the instruction decode is now broken. For example, the instruction

        callq  *0x10(%rax)

   now shows up as

        callq  *10

   which is obviously completely bogus - it's even broken the
constant. Your address simplification does something horribly bad.

Btw, since "retq" has a back arrow, maybe "callq" should have a
forward-pointing arrow on it too?

Talking about instruction decode, the instructions that should really
be simplified are things like this:

 - nopl   0x0(%rax,%rax,1)

   That's a totally worthless instruction. It should either be hidden
entirely, or perhaps just called "nop5" (for 5-byte nop)

 - mov    (%r9,%rsi,1),%rax

   That ",1" is completely bogus, and I don't understand why the tools
show that idiotic format to begin with. It's pure garbage. It adds
zero information.

 - mov    0x0(%r13),%r13

   That "0x0" is more useless garbage in the same vein. It is useless,
and just shows instruction encoding details that don't matter.

 - shl    $0x3,%ecx

   What does the "0x" part here really tell us? I'd suggest dropping
it for any constant < 9, because there really is no semantic value to
it.

 - mov    0xb897d9(%rip),%ecx        # ffffffff81c7beb8 <d_hash_shift>

   I think you should use the same simplification that you use for
call (once it is fixed), and just show this as

   mov    d_hash_shift,%ecx

because that's what both a human and a compiler would have written.
The "0xb897d9(%rip)" is not adding any information outside of (again)
pointless instruction encoding details.

Give the encoding details in the 'O'ffset view, by all means.

Btw, don't get me wrong. I really like the changes. It's just that now
that the asm is almost readable, the remaining stupid default decode
format details just show up so much more clearly.

Oh, and I think the long vertical line should just be removed. It's
not really adding anything, and with the loop lines it's just
distracting. Also, it's not even a solid line: it gets colorized by
percentage, and generally doesn't look good.
