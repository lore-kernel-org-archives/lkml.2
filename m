Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab2BUBuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 20:50:25 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:46455 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab2BUBuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 20:50:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jwboyer@gmail.com designates 10.180.80.8 as permitted sender) smtp.mail=jwboyer@gmail.com; dkim=pass header.i=jwboyer@gmail.com
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
	<alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org>
	<alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org>
	<alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org>
	<alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org>
Date: Mon, 20 Feb 2012 20:50:22 -0500
Message-ID: <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
From: Josh Boyer <jwboyer@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 2:48 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Sun, 19 Feb 2012 13:27:00 -0800
> Subject: [PATCH v2 3/3] i387: support lazy restore of FPU state
>
> This makes us recognize when we try to restore FPU state that matches
> what we already have in the FPU on this CPU, and avoids the restore
> entirely if so.
>
> To do this, we add two new data fields:
>
>  - a percpu 'fpu_owner_task' variable that gets written any time we
>   update the "has_fpu" field, and thus acts as a kind of back-pointer
>   to the task that owns the CPU.  The exception is when we save the FPU
>   state as part of a context switch - if the save can keep the FPU
>   state around, we leave the 'fpu_owner_task' variable pointing at the
>   task whose FP state still remains on the CPU.
>
>  - a per-thread 'last_cpu' field, that indicates which CPU that thread
>   used its FPU on last.  We update this on every context switch
>   (writing an invalid CPU number if the last context switch didn't
>   leave the FPU in a lazily usable state), so we know that *that*
>   thread has done nothing else with the FPU since.
>
> These two fields together can be used when next switching back to the
> task to see if the CPU still matches: if 'fpu_owner_task' matches the
> task we are switching to, we know that no other task (or kernel FPU
> usage) touched the FPU on this CPU in the meantime, and if the current
> CPU number matches the 'last_cpu' field, we know that this thread did no
> other FP work on any other CPU, so the FPU state on the CPU must match
> what was saved on last context switch.
>
> In that case, we can avoid the 'f[x]rstor' entirely, and just clear the
> CR0.TS bit.
>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

I haven't tried really figuring this out yet, but building the Fedora kernel
on x86_64 with your latest tree results in:

ERROR: "fpu_owner_task" [lib/raid6/raid6_pq.ko] undefined!
ERROR: "fpu_owner_task" [arch/x86/kvm/kvm.ko] undefined!
ERROR: "fpu_owner_task" [arch/x86/crypto/sha1-ssse3.ko] undefined!
ERROR: "fpu_owner_task" [arch/x86/crypto/serpent-sse2-x86_64.ko] undefined!
ERROR: "fpu_owner_task" [arch/x86/crypto/ghash-clmulni-intel.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
+ exit 1

Since this patch went in as 7e16838d94b566a1, I'm guessing it's at least
related.

I'm building again with more verbose output but I thought I'd send this out
quickly.

josh
