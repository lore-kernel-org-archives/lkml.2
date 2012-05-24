Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab2EXSqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:46:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57024 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718Ab2EXSqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:46:35 -0400
Message-ID: <4FBE81C1.8020009@zytor.com>
Date: Thu, 24 May 2012 11:45:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Roland McGrath <mcgrathr@google.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, netdev@parisplace.org,
        linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        luto@mit.edu, serge.hallyn@canonical.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, jmorris@namei.org
Subject: Re: [RFC PATCH 0/3] move the secure_computing call
References: <20120522173942.GJ11775@ZenIV.linux.org.uk>    <1337875681-20717-1-git-send-email-wad@chromium.org>    <4FBE5E3C.9070600@zytor.com>    <CAB=4xhp3WYoD6RnY+Y=XV18RiCLOeT-dsDmHxAVUYpaSUMpZdA@mail.gmail.com> <e73397a67afcb95c39a4560fe104912a.squirrel@webmail.greenhost.nl>
In-Reply-To: <e73397a67afcb95c39a4560fe104912a.squirrel@webmail.greenhost.nl>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 11:27 AM, Indan Zupancic wrote:
> 
> If so, then the seccomp check needs to be redone after any ptrace
> changes, or we should give up and just do the seccomp check first,
> instead of possibly looping forever. PTRACE_EVENT_SECCOMP has the
> same problem.
> 
> If a seccomp filtered task can do ptrace(), it can easily bypass
> the seccomp filter by ptracing any task not under the same filter
> but from the same user. And then it can puppeteer the victim into
> doing anything it wishes. So pretending seccomp can make a ptracer
> secure is futile, I think. Perhaps it's better to keep it simple and
> always do the seccomp test first and ignore ptrace changes, however
> sad that may seem. Seccomp had the power to stop ptrace(). It didn't,
> so it shouldn't try to do it afterwards either.
> 
> It's a bit fuzzy though, only reason why doing seccomp first is more
> convenient is because seccomp can generate ptrace events. I don't
> think it will make a difference in practice because ptrace(2) won't
> be allowed by seccomp filters anyway, so it's a bit of a theoretical
> problem.
> 

No, that's not the reason to do seccomp first.  The reason to do seccomp
first is that a seccomp filter can be part of the process execution and
can completely transform the system call picture.

Consider UML, for example.  It uses ptrace to capture system calls and
execute them on the behalf of the process.  It needs to know what system
calls *actually* are done by the virtual process.

(Note: that being said, UML might very well be better done using seccomp
filters *instead* of ptrace, but that's another matter.)

I agree with you, if the process is traceable it is rather questionable
to claim any kind of security; more likely consider that a debugging
mode and tell people to lock out ptrace for real sandboxing.

	-hpa

