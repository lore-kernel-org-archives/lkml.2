Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064Ab2D0SXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:23:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38437 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760485Ab2D0SXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:23:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120427180351.GH27997@infradead.org>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
 <CA+55aFy7QLXRWQSjUiYNhX5B9p-0AJ4LSWc=km8hJ55ku=ho0A@mail.gmail.com>
 <20120427164643.GG27997@infradead.org> <CA+55aFyZ+pMRn_Na_o5A3yWeUbXj2J_FVS8jbHgdD-UfPbOD5g@mail.gmail.com>
 <20120427180351.GH27997@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 11:23:24 -0700
X-Google-Sender-Auth: N-q_ZRFJZGz_DJvUKx-J3CHtDFw
Message-ID: <CA+55aFy2Erkros7qHpNBgbsGyP4azswTzWTFjSb2K4+KcFve2A@mail.gmail.com>
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

On Fri, Apr 27, 2012 at 11:03 AM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
>
>> It seems to think that a backwards jump implies a loop. But that's not
>> at all true.
>
> Yeah, the jump has to be conditional.

Not at all.

Unconditional backwards jumps can easily be parts of loops. It's a
very valid loop that does basically

   for (;;) {
   }

with a few exit cases in the *middle* of the loop. Sometimes that is
the right way to write things, and sometimes gcc rewrites things that
way for other reasons.

And conditional backwards jumps are *not* automatically loops either. Doing a

   if (error)
      return error;

is perfectly normal - and that "return error" may well be a backwards
jump to the "return" code that was generated earlier.

Seriously: backwards jumps are not loops. Not unconditional ones, not
conditional ones.

The only way to find a loop is to follow the flow control and notice
that it closes a loop.

> I should have reworded the "loop detection" with "basic jump arrows" in
> the first place.

.. and that is fine. But then you need to do it for *forwards* jumps
too. There is no difference between backwards and forwards jumps
*unless* you are looking for loops, and if you are looking for loops
you need to actually find the cycle.

                            Linus
