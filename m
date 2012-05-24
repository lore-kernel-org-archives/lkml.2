Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095Ab2EXS1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:27:48 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:33086 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458Ab2EXS1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:27:46 -0400
Message-ID: <e73397a67afcb95c39a4560fe104912a.squirrel@webmail.greenhost.nl>
In-Reply-To: <CAB=4xhp3WYoD6RnY+Y=XV18RiCLOeT-dsDmHxAVUYpaSUMpZdA@mail.gmail.com>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk>
    <1337875681-20717-1-git-send-email-wad@chromium.org>
    <4FBE5E3C.9070600@zytor.com>
    <CAB=4xhp3WYoD6RnY+Y=XV18RiCLOeT-dsDmHxAVUYpaSUMpZdA@mail.gmail.com>
Date: Thu, 24 May 2012 20:27:43 +0200
Subject: Re: [RFC PATCH 0/3] move the secure_computing call
From: "Indan Zupancic" <indan@nul.nu>
To: "Roland McGrath" <mcgrathr@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Will Drewry" <wad@chromium.org>,
        linux-kernel@vger.kernel.org, netdev@parisplace.org,
        linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        luto@mit.edu, serge.hallyn@canonical.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, jmorris@namei.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: e462de357cb394d64966911c06262bc8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 20:07, Roland McGrath wrote:
> On Thu, May 24, 2012 at 9:13 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> I think this really screws with using seccomp for self-interception.  I
>> wouldn't inherently be opposed to the following flow:
>>
>> 	seccomp -> ptrace -> seccomp
>>
>> ... i.e. if ptrace is enabled and we enable something, run it through
>> seccomp again, but there are bunch of use cases (mostly involving
>> SIGSYS) where doing ptrace before seccomp is just bizarre.
>
> Are you sure?  This is ptrace syscall tracing going first.
> If seccomp generates a SIGSYS, then ptrace will still get its opportunity
> to intercept the signal and change the register state however it likes.

If so, then the seccomp check needs to be redone after any ptrace
changes, or we should give up and just do the seccomp check first,
instead of possibly looping forever. PTRACE_EVENT_SECCOMP has the
same problem.

If a seccomp filtered task can do ptrace(), it can easily bypass
the seccomp filter by ptracing any task not under the same filter
but from the same user. And then it can puppeteer the victim into
doing anything it wishes. So pretending seccomp can make a ptracer
secure is futile, I think. Perhaps it's better to keep it simple and
always do the seccomp test first and ignore ptrace changes, however
sad that may seem. Seccomp had the power to stop ptrace(). It didn't,
so it shouldn't try to do it afterwards either.

It's a bit fuzzy though, only reason why doing seccomp first is more
convenient is because seccomp can generate ptrace events. I don't
think it will make a difference in practice because ptrace(2) won't
be allowed by seccomp filters anyway, so it's a bit of a theoretical
problem.

Greetings,

Indan


