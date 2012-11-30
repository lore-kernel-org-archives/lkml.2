Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab2K3Tsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:48:30 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43001 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab2K3Ts3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:48:29 -0500
MIME-Version: 1.0
In-Reply-To: <50B90B31.3000907@zytor.com>
References: <1354301523-5252-1-git-send-email-vpalatin@chromium.org>
 <1354301523-5252-2-git-send-email-vpalatin@chromium.org> <CA+55aFz4M4GmQbUkD1dhTkLTYka4H+T_phrsXgx+eGe8g9iLYA@mail.gmail.com>
 <50B90B31.3000907@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Nov 2012 11:41:47 -0800
X-Google-Sender-Auth: pVEtMqMhNxs1yeWkgRm3UBmhXS0
Message-ID: <CA+55aFyoAq+w6eNAyOJ00cpFEaGE=eKzMMtr9kEtMuUU820oYg@mail.gmail.com>
Subject: Re: [PATCH] x86, fpu: avoid FPU lazy restore after suspend
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vincent Palatin <vpalatin@chromium.org>, Ingo Molnar <mingo@redhat.com>,
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

On Fri, Nov 30, 2012 at 11:38 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/30/2012 11:25 AM, Linus Torvalds wrote:
>>
>> and in fact I think the right place to do this *might* be in
>> "native_cpu_die()" instead, at which point it would actually be
>> something like
>>
>>     per_cpu(fpu_owner_task, cpu) = NULL;
>>
>> *after* the CPU is dead, so that nothing ever can actually see the
>> state where a process is still running on the CPU and might possibly
>> use the FPU.
>>
>> I dunno. I think doing it after really killing the CPU (ie in the
>> native_cpu_die() function) might be easier to think about, but I don't
>> really hate your patch either (it does make me go "ok, we need to
>> guarantee no scheduling or FP use after" - which is probably true, but
>> it's still some non-local thing). Either way, a comment about it and
>> abstracting whatever the invalidation sequence is in fpu-internal.h
>> sounds like a good idea.
>>
>
> Hmm... from my point of view it would almost seem saner to do this on
> the way *up*... as part of CPU (re-)initialization.  After all, the
> "nothing is currently running on this CPU" is part of the initial state
> of the CPU, regardless of if we have ever been online before or not.

That works for me too, and has the similar advantage of being easier
to think about than "the cpu is actually still being used, and we're
playing tricks with the FPU state cache" approach.

Regardless, much credit to Vincent (and presumably others on the
chromium team) for finding and debugging this.

             Linus
