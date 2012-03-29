Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213Ab2C2Wkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:40:52 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60581 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759508Ab2C2Wkj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:40:39 -0400
MIME-Version: 1.0
In-Reply-To: <4F74C0B2.1010100@zytor.com>
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
 <1332787168-20457-5-git-send-email-vnagarnaik@google.com> <4F714982.6020208@zytor.com>
 <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com>
 <4F73CC3A.2080901@zytor.com> <CAL26m8+zbbqngfK0fYb+A2UBQ1fZ9Uxrf4VLWqU1VuMzkcF4xw@mail.gmail.com>
 <20120329062031.GB1376@gmail.com> <CAL26m8+BmN=DxR7LbukM7S4w9XcURjfDFizUNpEcZA_8g4JNVg@mail.gmail.com>
 <4F74B42F.3050100@zytor.com> <CAL26m8JA4HJQayJW2nYbVpHD7mgd0Bz6rFMipq2Nf6OECiyk1Q@mail.gmail.com>
 <4F74C0B2.1010100@zytor.com>
From: David Sharp <dhsharp@google.com>
Date: Thu, 29 Mar 2012 15:40:17 -0700
Message-ID: <CAJL_ekvU8sjt0wi6GjrMiqy03kBZ6YzQkz9TO+MQzQAr_-2VnQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace handler
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, Michael Davidson <md@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 1:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> I had a long discussion with Frederic over IRC earlier today.  We came
> up with the following strawman:
>
> 1. A system call thunk (which could be enabled/disabled by patching the
> syscall table.)  This provides an entry and exit hook, and also sets a
> per-thread flag to capture userspace traffic.

Our goal is for syscall traces to be as fast as regular tracepoints.
iirc, What we've found is that much of the extra overhead of syscall
tracepoints as compared to regular tracepoints is due to that the code
path for syscall tracing is bundled with checks for ptrace and other
stuff (Vaibhav did all this characterization, he can jump in with
details if wanted). How much work would this "thunk" have to do that
is not either recording the trace or calling the syscall?

>
> 2. Instrumenting get_user/put_user/copy_from_user/copy_to_user to
> capture traffic to userspace.  This captures the *full* set of system
> call arguments, including things addressed via pointers.  Furthermore,
> it captures the exact versions fed to or returned from the kernel, and
> deals with data-dependent collection like ioctl().

Do I understand correctly that you are thinking to copy tho contents
of those buffers into the ring buffer? This sounds useful. However I
think it should be optional and the number of bytes copied should be
limited (tunable). On highly utilized systems, we don't always have a
lot of memory to dedicate to the ring bufffer, so filling it with the
contents of, eg, the payload of "read" or "write" would not be
acceptable under those circumstances. And since events in the ring
buffer can't cross page boundaries, at some threshold this will cause
an unacceptable level of unutilized space in the ring buffer.

(For context, this is coming from the folks that added "tiny" versions
of syscall tracepoints that only put 16 bits of arg0 into the ring
buffer so we can get longer trace durations.)

>
> This has to be done with extreme care to avoid introducing overhead in
> the no-tracing case, however, as these functions are extraordinarily
> performance sensitive.  This probably will require careful patching in
> the first enable/last disable case.
>
> 3. There will need to be userspace tools written to decode the resulting
> trace buffer.  This is pretty much needed anyway, but once you throw in
> complex data structures it becomes even more so.  A trace will basically
> consist of:
>
> SYSCALL_ENTRY <syscall number> <arg1..6>
> COPY_FROM_USER <address> <data>
>  ...
> COPY_TO_USER <address> <data>
>  ...
> SYSCALL_EXIT <return value>
>
> Outputting this in human-readable format requires some reasonably
> sophisticated logic, but the *HUGE* advantage is that not only is all
> the information there, it is *correct by construction*.
>
>        -hpa
