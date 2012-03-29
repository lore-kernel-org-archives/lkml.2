Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab2C2UGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:06:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39709 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933762Ab2C2UGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:06:33 -0400
Message-ID: <4F74C0B2.1010100@zytor.com>
Date: Thu, 29 Mar 2012 13:06:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
CC: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, Michael Davidson <md@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace
 handler
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com> <1332787168-20457-5-git-send-email-vnagarnaik@google.com> <4F714982.6020208@zytor.com> <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com> <4F73CC3A.2080901@zytor.com> <CAL26m8+zbbqngfK0fYb+A2UBQ1fZ9Uxrf4VLWqU1VuMzkcF4xw@mail.gmail.com> <20120329062031.GB1376@gmail.com> <CAL26m8+BmN=DxR7LbukM7S4w9XcURjfDFizUNpEcZA_8g4JNVg@mail.gmail.com> <4F74B42F.3050100@zytor.com> <CAL26m8JA4HJQayJW2nYbVpHD7mgd0Bz6rFMipq2Nf6OECiyk1Q@mail.gmail.com>
In-Reply-To: <CAL26m8JA4HJQayJW2nYbVpHD7mgd0Bz6rFMipq2Nf6OECiyk1Q@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 12:43 PM, Vaibhav Nagarnaik wrote:
> 
> However, we agree that the syscall tracing as implemented currently is
> a bit unwieldy. We would want to be a part of the re-designing effort
> if there is a momentum in the community towards that goal. We would be
> happy to contribute towards this effort.
> 

I had a long discussion with Frederic over IRC earlier today.  We came
up with the following strawman:

1. A system call thunk (which could be enabled/disabled by patching the
syscall table.)  This provides an entry and exit hook, and also sets a
per-thread flag to capture userspace traffic.

2. Instrumenting get_user/put_user/copy_from_user/copy_to_user to
capture traffic to userspace.  This captures the *full* set of system
call arguments, including things addressed via pointers.  Furthermore,
it captures the exact versions fed to or returned from the kernel, and
deals with data-dependent collection like ioctl().

This has to be done with extreme care to avoid introducing overhead in
the no-tracing case, however, as these functions are extraordinarily
performance sensitive.  This probably will require careful patching in
the first enable/last disable case.

3. There will need to be userspace tools written to decode the resulting
trace buffer.  This is pretty much needed anyway, but once you throw in
complex data structures it becomes even more so.  A trace will basically
consist of:

SYSCALL_ENTRY <syscall number> <arg1..6>
COPY_FROM_USER <address> <data>
  ...
COPY_TO_USER <address> <data>
  ...
SYSCALL_EXIT <return value>

Outputting this in human-readable format requires some reasonably
sophisticated logic, but the *HUGE* advantage is that not only is all
the information there, it is *correct by construction*.

	-hpa
