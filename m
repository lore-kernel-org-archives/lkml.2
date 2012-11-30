Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1769405Ab2K3TcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:32:25 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41310 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992910Ab2K3TcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:32:05 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 14:32:04 EST
MIME-Version: 1.0
In-Reply-To: <1354301523-5252-2-git-send-email-vpalatin@chromium.org>
References: <1354301523-5252-1-git-send-email-vpalatin@chromium.org> <1354301523-5252-2-git-send-email-vpalatin@chromium.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Nov 2012 11:25:40 -0800
X-Google-Sender-Auth: BwHeIFSIgO-5D38Oq40unHwcEbk
Message-ID: <CA+55aFz4M4GmQbUkD1dhTkLTYka4H+T_phrsXgx+eGe8g9iLYA@mail.gmail.com>
Subject: Re: [PATCH] x86, fpu: avoid FPU lazy restore after suspend
To: Vincent Palatin <vpalatin@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Duncan Laurie <dlaurie@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 10:52 AM, Vincent Palatin <vpalatin@chromium.org> wrote:
> When a cpu enters S3 state, the FPU state is lost.
> After resuming for S3, if we try to lazy restore the FPU for a process running
> on the same CPU, this will result in a corrupted FPU context.

Good catch, and I think the patch is technically correct, but:

> We can just invalidate the "fpu_owner_task", so nobody will try to
> lazy restore a state which no longer exists in the hardware.

I think this works well, but is a tiny bit subtle.

And what I _don't_ necessarily think is the right thing to do is to
only comment on it in the commit message, because it means that later
generations will not necessarily ever notice. And it does result in a
new combination that I don't think we've had before: if the current
task is the owner, we now have "tsk->thread.fpu.has_fpu  = 1" but with
"fpu_owner_task" being NULL.

Which gets us the semantics we want (we will save the current CPU info
when switching away, but we will not restore when switching back), but
my gut feel is that we really want to comment on that exact thing. And
possibly even make a helper function for this in <sm/fpu-internal.h>,
something like

    /*
     * Must be run with preemption disabled: this clears the fpu_owner_task,
     * on this CPU.
     *
     * This will disable any lazy FPU state restore of the current FPU state,
     * but if the current thread owns the FPU, it will still be saved by.
     */
    static inline void __cpu_disable_lazy_restore(void)
    {
        this_cpu_write(fpu_owner_task, NULL);
    }

and in fact I think the right place to do this *might* be in
"native_cpu_die()" instead, at which point it would actually be
something like

    per_cpu(fpu_owner_task, cpu) = NULL;

*after* the CPU is dead, so that nothing ever can actually see the
state where a process is still running on the CPU and might possibly
use the FPU.

I dunno. I think doing it after really killing the CPU (ie in the
native_cpu_die() function) might be easier to think about, but I don't
really hate your patch either (it does make me go "ok, we need to
guarantee no scheduling or FP use after" - which is probably true, but
it's still some non-local thing). Either way, a comment about it and
abstracting whatever the invalidation sequence is in fpu-internal.h
sounds like a good idea.

Hmm?

                  Linus
