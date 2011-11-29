Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab1K2HeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 02:34:20 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51782 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1K2HeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 02:34:18 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
References: <1322539673.17003.45.camel@frodo> <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 28 Nov 2011 23:33:46 -0800
Message-ID: <CAPM31RLSqD8uChMeQeKJWNDx2Ogb4MhN=gJFzdmCayh7ohU5MA@mail.gmail.com>
Subject: Re: Perhaps a side effect regarding NMI returns
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 8:53 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Nov 28, 2011 at 8:07 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> If enabling interrupts also enables NMIs, then there's no side effect.
>
> The only thing that enables NMI's again is 'iret', afaik. Of course,
> it can be *any* iret, so once you enable interrupts, you can get a
> timer interrupt, and the timer interrupt returning with iret will
> re-enable NMI's then too.
>

I double checked versus the manuals tonight after seeing this and I
believe this correct -- an iret is required; some of the verbage is
reasonably explicit to this fact.

> I would suggest that the actual NMI handler itself should probably
> never use that paranoid exit at all, and just always use a regular
> iret. Screw scheduling and TIF checks.
>
> Probably only the exceptions that can happen *during* NMI (eg debug,
> stack exception, double-fault etc) should use the paranoid versions
> that try to avoid using iret.
>
> Because I think you're right - we shouldn't call schedule() from
> within the NMI handler, even if we do enable interrupts and switch to
> the normal stack. Even if it probably does happen to work normally.
>
> But I have to admit to not necessarily thinking it through a lot.
>

At a high level I think we could apply the same logic from the first
paragraph; namely that we will see a timer tick within a jiffy (where
we will have an opportunity to process TIF flags) and it's better to
push schedule() out than the NMI handler.

That said, if TIF_RESCHED has been set by a higher priority RT task
this temporary inversion may not be appreciated.  It's probably worth
fixing properly.

- Paul
