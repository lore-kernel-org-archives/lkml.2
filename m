Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834Ab2D0RNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:13:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:32807 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760780Ab2D0RNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:13:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120427164643.GG27997@infradead.org>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
 <CA+55aFy7QLXRWQSjUiYNhX5B9p-0AJ4LSWc=km8hJ55ku=ho0A@mail.gmail.com> <20120427164643.GG27997@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 10:12:45 -0700
X-Google-Sender-Auth: ODnk2umBt0Fi5wnSyXI7B-9cId0
Message-ID: <CA+55aFyZ+pMRn_Na_o5A3yWeUbXj2J_FVS8jbHgdD-UfPbOD5g@mail.gmail.com>
Subject: Re: [GIT PULL 0/4] perf/annotate loop detection V2, fixes
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 9:46 AM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Fri, Apr 27, 2012 at 09:35:58AM -0700, Linus Torvalds escreveu:
>> Btw, don't get me wrong. I really like the changes. It's just that now
>> that the asm is almost readable, the remaining stupid default decode
>> format details just show up so much more clearly.
>
> Hey, I love the comments and suggestions, keep them coming when you feel
> like doing it.

I found another problem, and I think this one is more fundamental.

The "loop detection" is completely and utterly broken.

It seems to think that a backwards jump implies a loop. But that's not
at all true.

In fact, many backwards jumps are the *reverse* of loops. They are due
to *cold* code, that is totally uninteresting, and that was done
out-of-line. The backwards jump is not a loop at all, it's a jump back
to the hot code. In fact, it's often a jump back to the *exit* of a
function, when the cold code returns an error value (but the actual
code to do the "return" part was generated earlier as part of the hot
normal case code).

So making a big deal out of it as if it was a loop can be actively
wrong and misleading.

(And yes, I'm looking at an example of that right now -
__d_lookup_rcu() has this, for example)

Now, it's often nice to see the line to find the branch target
(whether it's a loop or not), but you don't show them for forwards
branches, you only show them for backwards branches, as if the
backwards branches were somehow more important. But they really really
aren't.

                    Linus
