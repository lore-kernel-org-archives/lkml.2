Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab1LELVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:21:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56187 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab1LELVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:21:14 -0500
Message-ID: <4EDCA87F.6020201@kernel.org>
Date: Mon, 05 Dec 2011 03:18:23 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Fix and re-enable vsyscall=emulate
References: <CALCETrXAiHs9PyziHBm-gZRiyahYafbxxUSxJUcFh=a-0th0EQ@mail.gmail.com> <cover.1320712291.git.luto@amacapital.net> <CALCETrVxHvH61D-xY6vq4ymWXAVOdj8=XV_ENqLQUJ5rMieuEg@mail.gmail.com>
In-Reply-To: <CALCETrVxHvH61D-xY6vq4ymWXAVOdj8=XV_ENqLQUJ5rMieuEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2011 02:47 PM, Andy Lutomirski wrote:
> On Mon, Nov 7, 2011 at 4:33 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> The really nice fix (wiring up access_ok failures to be able to raise
>> signals) won't be ready on time for 3.2, so let's try the simpler fix
>> for now.
> 
> I spoke to hpa about this a couple days ago, and he pointed out a
> problem with making access_ok send signals.  Userspace expects signals
> that come with full context information to be restartable, and many
> system calls are not restartable.  read() and write() are the obvious
> examples: once they're processed the beginning of the buffer, unless
> they adjust their parameters, they can't safely be restarted.  So
> without massive changes, I think allowing access_ok to raise a signal
> with full context is asking for trouble.
> 
> I can still do the patch with two modes: signals without context via
> arch_prctl and signals with context via vsyscall emulation, but that's
> probably overkill for fixing this bug.  I'd say just apply these
> patches as is (for 3.3).
> 

It's somewhat questionable if the "return -EFAULT and deliver SIGSEGV"
semantic resolves the problem; obviously the signal handler isn't
restartable, but returning from the signal handler will at least cause
the application to see the EFAULT and not try to restart a system call
in a way that is likely to cause massive failure.  If the handler is
aware about what needs to be done then it can correct the situation and
restart the system call -- but it would have to have detailed
information about the state before the system call.

I am also concerned about information leaks from the kernel.  The
existing kernel paths are not necessarily designed to be robust against
giving out additional error information.  This may be a theoretical
concern, but there have been real security holes in the past from these
kinds of changes.

	-hpa
