Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab2DITjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:39:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39291 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2DITi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:38:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120406142423.b2cb2f61.akpm@linux-foundation.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
	<1333051320-30872-14-git-send-email-wad@chromium.org>
	<20120406142423.b2cb2f61.akpm@linux-foundation.org>
Date: Mon, 9 Apr 2012 14:38:54 -0500
Message-ID: <CABqD9haR4pFURoEN1isUQav3FQqoUywU13LUTQ-UwebbwLfESg@mail.gmail.com>
Subject: Re: [PATCH v17 13/15] ptrace,seccomp: Add PTRACE_SECCOMP support
From: Will Drewry <wad@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, corbet@lwn.net, eric.dumazet@gmail.com,
        markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 4:24 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 29 Mar 2012 15:01:58 -0500
> Will Drewry <wad@chromium.org> wrote:
>
>> This change adds support for a new ptrace option, PTRACE_O_TRACESECCOMP,
>> and a new return value for seccomp BPF programs, SECCOMP_RET_TRACE.
>>
>> When a tracer specifies the PTRACE_O_TRACESECCOMP ptrace option, the
>> tracer will be notified, via PTRACE_EVENT_SECCOMP, for any syscall that
>> results in a BPF program returning SECCOMP_RET_TRACE.  The 16-bit
>> SECCOMP_RET_DATA mask of the BPF program return value will be passed as
>> the ptrace_message and may be retrieved using PTRACE_GETEVENTMSG.
>>
>> If the subordinate process is not using seccomp filter, then no
>> system call notifications will occur even if the option is specified.
>>
>> If there is no tracer with PTRACE_O_TRACESECCOMP when SECCOMP_RET_TRACE
>> is returned, the system call will not be executed and an -ENOSYS errno
>> will be returned to userspace.
>>
>> This change adds a dependency on the system call slow path.  Any future
>> efforts to use the system call fast path for seccomp filter will need to
>> address this restriction.
>>
>>
>> ...
>>
>> @@ -410,6 +411,15 @@ int __secure_computing_int(int this_syscall)
>>                       /* Let the filter pass back 16 bits of data. */
>>                       seccomp_send_sigsys(this_syscall, data);
>>                       goto skip;
>> +             case SECCOMP_RET_TRACE:
>> +                     /* Skip these calls if there is no tracer. */
>> +                     if (!ptrace_event_enabled(current, PTRACE_EVENT_SECCOMP))
>> +                             goto skip;
>> +                     /* Allow the BPF to provide the event message */
>> +                     ptrace_event(PTRACE_EVENT_SECCOMP, data);
>> +                     if (fatal_signal_pending(current))
>> +                             break;
>
> I don't have all the patches applied here so the context is missing.
> Perhaps tht would help me understand what this fatal_signal_pending()
> test is doing here.  But an explanatory comment wouldn't hurt.

I'll add a comment along the lines of my answer below!

> What *is* it here for, anyway?

The timely delivery of a fatal signal will silently block tracer event
notification.  By immediately terminating if a fatal signal is
pending, we avoid accidentally executing a system call that the tracer
did not approve of.

http://lxr.linux.no/linux+v3.3.1/kernel/signal.c#L1839

I can be more verbose, but hopefully that covers it well enough - thanks!
