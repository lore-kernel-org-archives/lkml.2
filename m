Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab2FVSxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:53:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35497 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab2FVSxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:53:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120622183827.GA8014@virgo.local>
References: <20120622133650.GA24136@gmail.com> <CA+55aFySaZ4huXgPM0yGPezAhnE9zT81tucC9WnDs5Ps+7+hGA@mail.gmail.com>
 <20120622183827.GA8014@virgo.local>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Jun 2012 11:52:43 -0700
X-Google-Sender-Auth: qiJjqWCDwNhtQ9HsfEfKx3lmRPg
Message-ID: <CA+55aFzpNtLSQvcOOut--2UkkMyqSb9e0_VO3JAxvZRTv7YT1g@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 11:38 AM, Hagen Paul Pfeifer <hagen@jauu.net> wrote:
>>
>>Because that mcount thing is expensive as hell, if people haven't
>>noticed (and I'm not talking about just the call instruction that I
>>think we can stub out - it changes code generation in other ways too).
>>And it looks like distros enable it by default, which annoys my
>>performance-optimizing soul deeply.
>
> Isn't it stubed out already? Already replaced by nops at boot time by
> ftrace_code_disable() and friends!? But yes, there may be spots where the
> additional mcount() call avoid optimization.

So even stubbed out, it's quite noticeable. The call causes the
function prologue to change quite a bit.

That's actually especially true with newer versions of gcc that
*finally* seem to have done the "don't always generate the full
prologue if some case doesn't need it" optimization. So functions that
have early-out conditions (quite common) will exit before even having
done the prologue, and without doing the whole frame pointer setup
etc.

Except if mcount generation is on. Then gcc will always do the
prologue and frame pointer setup before doing the mcount, because
mcount wants it.

So it really isn't just the extra call instruction.

I may be more sensitive to this than most, because I look at profiles
and the function prologue just looks very ugly with the call mcount
thing. Ugh.

                  Linus
