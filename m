Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab2BSX4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 18:56:55 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36533 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2BSX4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 18:56:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.216.135.15 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F417B4F.3040406@zytor.com>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202191423270.3898@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202191426460.3898@i5.linux-foundation.org> <4F417B4F.3040406@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 19 Feb 2012 15:56:33 -0800
X-Google-Sender-Auth: Hb0EOvd5RsgoFq2CqQqEsUU4mZ0
Message-ID: <CA+55aFxJvGRjF63Dv=W7pc3tPcFom1-cGJcoFjGG1CeXkwtMVw@mail.gmail.com>
Subject: Re: [PATCH 2/2] i387: support lazy restore of FPU state
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 2:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I think your logic is correct but suboptimal.

I do agree. But I had two or three previous versions of this that all
worked fine, but that I decided simply weren't safe.

So at some point I just decided that "optimal" was less important than
"simple to think about".

For example, one of the things I originally wanted to do was to be
able to switch to another CPU and back - and if the process didn't use
the FPU on the other CPU, and nothing else used the FPU on the
original one, we would just restore the state.

It's definitely doable (with these same fields), but I decided that
it's not something we actually care about from a performance angle,
and just thinking about it made me worry more than I wanted about the
correctness angle.

Which was why I ended up with that simpler approach.

> What would make more sense to me is that we write last_cpu when we
> *load* the state.

Yes. But writing last_cpu on every context switch, and *only* using a
valid CPU number if the save actually successfully left the state
untouched just made it easier for me to think about it. Then "last_cpu
matches a cpu" validates not just the CPU, but also "and we actually
saved it on this CPU at the *last* context switch".

Because there are multiple ways to use the FPU, and not all of them
come from restoring the math state. There's a few cases where we
initialize it from scratch without restoring it, for example. I
decided I just didn't want to worry about it.

> In kernel_fpu_begin, *if* we end up flushing the state, we should set
> last_cpu to -1 indicating that *no* CPU currently owns the state

No, you really want to use the per-cpu data there, not the thread
data. Because the process that has a 'last_cpu' pointing to this cpu
may not be running right now - that is, after all, the whole point of
the lazy restore: we cache FPU state of a process that isn't even
active.

But this is exactly the kind of thing I got wrong at least twice
before I decided to not even try to be clever about it.

And even now I still would prefer others to look over even my totally
non-subtle logic, just in case there was something else I forgot
about.

But hey, if you can convince me with a counter-patch that "obviously
works", I won't argue too much. I'm just explaining why I ended up
deciding on the stupid-but-fairly-straightforward approach.

                  Linus
