Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab2C2Cnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 22:43:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59975 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758539Ab2C2CnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 22:43:25 -0400
Message-ID: <4F73CC3A.2080901@zytor.com>
Date: Wed, 28 Mar 2012 19:43:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace
 handler
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com> <1332787168-20457-5-git-send-email-vnagarnaik@google.com> <4F714982.6020208@zytor.com> <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com>
In-Reply-To: <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2012 11:23 AM, Vaibhav Nagarnaik wrote:
> 
> I am sorry I don't see how that would be possible without having some
> sort of architecture dependent changes.

Tough, that's sometimes the way it goes.  On most architectures it's
just a simple table.

> Also as you mentioned, it will have some security considerations.

Not any more than your little scheme.

> If you can suggest a better way without going through this macro
> magic, I will be glad to implement it. The 2 main reasons I made this
> patch was to remove the added latency in syscall tracing and to remove
> penalty for syscalls that are not traced.

But instead you add a penalty for every syscall, even if tracing is
disabled.  Not cool.

> If you can suggest a better way without going through this macro
> magic, I will be glad to implement it.

The more I look at this stuff the more I think it is not just crazy, but
batsh*t crazy... we produce *how* much "metadata" which is stored in
non-pageable kernel memory, and all it seems to be *actually* doing is
store a variable number of parameters in a buffer.

This is insane.  Not just a little insane, but utterly bonkers.

The syscall interface is the single most stable interface in the kernel.
 Just plunk down the system call number and the six arguments in the
buffer, and be done with it.  On the way out, there is a single return
argument, *by design*.  No need to burden the kernel in this way! That
this information can be perfectly well decoded in userspace is already
shown by strace, although it would be highly beneficial if the kernel
build could export information to strace and other tools.  There is
absolutely no need for it to live in kernel memory, though.

	-hpa
