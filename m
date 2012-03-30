Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154Ab2C3L53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:57:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42179 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933525Ab2C3L5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:57:24 -0400
Date: Fri, 30 Mar 2012 13:57:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, Michael Davidson <md@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace
 handler
Message-ID: <20120330115715.GB13022@somewhere.redhat.com>
References: <1332787168-20457-5-git-send-email-vnagarnaik@google.com>
 <4F714982.6020208@zytor.com>
 <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com>
 <4F73CC3A.2080901@zytor.com>
 <CAL26m8+zbbqngfK0fYb+A2UBQ1fZ9Uxrf4VLWqU1VuMzkcF4xw@mail.gmail.com>
 <20120329062031.GB1376@gmail.com>
 <CAL26m8+BmN=DxR7LbukM7S4w9XcURjfDFizUNpEcZA_8g4JNVg@mail.gmail.com>
 <4F74B42F.3050100@zytor.com>
 <CAL26m8JA4HJQayJW2nYbVpHD7mgd0Bz6rFMipq2Nf6OECiyk1Q@mail.gmail.com>
 <4F74C0B2.1010100@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F74C0B2.1010100@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 01:06:10PM -0700, H. Peter Anvin wrote:
> On 03/29/2012 12:43 PM, Vaibhav Nagarnaik wrote:
> > 
> > However, we agree that the syscall tracing as implemented currently is
> > a bit unwieldy. We would want to be a part of the re-designing effort
> > if there is a momentum in the community towards that goal. We would be
> > happy to contribute towards this effort.
> > 
> 
> I had a long discussion with Frederic over IRC earlier today.  We came
> up with the following strawman:
> 
> 1. A system call thunk (which could be enabled/disabled by patching the
> syscall table.)  This provides an entry and exit hook, and also sets a
> per-thread flag to capture userspace traffic.
> 
> 2. Instrumenting get_user/put_user/copy_from_user/copy_to_user to
> capture traffic to userspace.  This captures the *full* set of system
> call arguments, including things addressed via pointers.  Furthermore,
> it captures the exact versions fed to or returned from the kernel, and
> deals with data-dependent collection like ioctl().
> 
> This has to be done with extreme care to avoid introducing overhead in
> the no-tracing case, however, as these functions are extraordinarily
> performance sensitive.  This probably will require careful patching in
> the first enable/last disable case.
> 
> 3. There will need to be userspace tools written to decode the resulting
> trace buffer.  This is pretty much needed anyway, but once you throw in
> complex data structures it becomes even more so.  A trace will basically
> consist of:
> 
> SYSCALL_ENTRY <syscall number> <arg1..6>
> COPY_FROM_USER <address> <data>
>   ...
> COPY_TO_USER <address> <data>
>   ...
> SYSCALL_EXIT <return value>
> 
> Outputting this in human-readable format requires some reasonably
> sophisticated logic, but the *HUGE* advantage is that not only is all
> the information there, it is *correct by construction*.
> 
> 	-hpa


Note we have the relevant tracepoints in place with the "raw_syscalls"
events subsystem. They are generic with only two tracepoints sys_enter
and sys_exit and they blindly dump the syscall number/arg/return value:

$ cat /sys/kernel/debug/tracing/events/raw_syscalls/sys_enter/format 
name: sys_enter
ID: 53
format:
        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;
        field:int common_padding;       offset:8;       size:4; signed:1;

        field:long id;  offset:16;      size:8; signed:1;
        field:unsigned long args[6];    offset:24;      size:48;        signed:0;

print fmt: "NR %ld (%lx, %lx, %lx, %lx, %lx, %lx)", REC->id, REC->args[0], REC->args[1], REC->args[2], REC->args[3], 
REC->args[4], REC->args[5]

$ cat /sys/kernel/debug/tracing/events/raw_syscalls/sys_exit/format 
name: sys_exit
ID: 52
format:
        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;
        field:int common_padding;       offset:8;       size:4; signed:1;

        field:long id;  offset:16;      size:8; signed:1;
        field:long ret; offset:24;      size:8; signed:1;

print fmt: "NR %ld = %ld", REC->id, REC->ret

Now we have yet to do the syscall table patching and the copy_*_user() tracepoints.
But other than these details the bulk of the remaining work is in userspace.
