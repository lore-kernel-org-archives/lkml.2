Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1K2EyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 23:54:18 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46732 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab1K2EyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 23:54:17 -0500
MIME-Version: 1.0
In-Reply-To: <1322539673.17003.45.camel@frodo>
References: <1322539673.17003.45.camel@frodo>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 Nov 2011 20:53:55 -0800
X-Google-Sender-Auth: H8smgPucSMpmjVH9LExsYhlh3s4
Message-ID: <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
Subject: Re: Perhaps a side effect regarding NMI returns
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 8:07 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> If enabling interrupts also enables NMIs, then there's no side effect.

The only thing that enables NMI's again is 'iret', afaik. Of course,
it can be *any* iret, so once you enable interrupts, you can get a
timer interrupt, and the timer interrupt returning with iret will
re-enable NMI's then too.

I would suggest that the actual NMI handler itself should probably
never use that paranoid exit at all, and just always use a regular
iret. Screw scheduling and TIF checks.

Probably only the exceptions that can happen *during* NMI (eg debug,
stack exception, double-fault etc) should use the paranoid versions
that try to avoid using iret.

Because I think you're right - we shouldn't call schedule() from
within the NMI handler, even if we do enable interrupts and switch to
the normal stack. Even if it probably does happen to work normally.

But I have to admit to not necessarily thinking it through a lot.

                            Linus
