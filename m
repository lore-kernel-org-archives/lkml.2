Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab2C1SYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:24:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36537 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab2C1SYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:24:17 -0400
MIME-Version: 1.0
In-Reply-To: <4F714982.6020208@zytor.com>
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
 <1332787168-20457-5-git-send-email-vnagarnaik@google.com> <4F714982.6020208@zytor.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 28 Mar 2012 11:23:46 -0700
Message-ID: <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com>
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace handler
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 10:00 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/26/2012 11:39 AM, Vaibhav Nagarnaik wrote:
>> The syscalls are a tricky bunch to trace, because of their multitude and
>> dynamic nature of the list. In order to solve this, a macro handled the
>> sycalls handler definition and it was expanded into setting up the
>> metadata for the syscall event. A handler hooked into the ptrace syscall
>> tracer to check whether an invoked syscall was supposed to be traced.
>>
>> This added latency to all the invoked syscalls, since they had to be
>> checked for tracing and also affected the latency of syscall that was
>> actually getting traced. For e.g., using a simple program which invokes
>> getuid() in a repeated loop and calculates the average time per syscall
>> invocation found a latency of 570 - 117 = 453 ns added to every traced
>> syscall.
>>
>> This patch changes the syscall macro expansion, to create a function
>> that adds the entry and exit tracepoints for the given syscall so that
>> the latency can be avoided. This was suggested by Mathieu Desnoyers in
>> https://lkml.org/lkml/2010/10/13/337
>>
>> After this patch, the latency added is 370 - 117 = 253 ns per invocation
>> of a traced syscall. This is on par with a simple tracepoint added to
>> any kernel code path.
>>
>> This patch also makes syscall tracing architecture independent as there
>> is no need to have a hook into the architecture specific syscall tracer
>> functions.
>>
>
> I am officially confused here.  You have a single, common, dispatch
> point for all system calls -- why don't you use it?  That is of course
> the system call table.  If you want to trace a system call, override the
> entry point in the syscall table to point to a hook function which can
> provide entry and exit hooks.  It's not even code, it's data, so you
> don't even have to play the code patching song and dance routine
> (although you may have to map it read/write which is normally not the
> case for security reasons.)

I am sorry I don't see how that would be possible without having some
sort of architecture dependent changes. Also as you mentioned, it will
have some security considerations.

If you can suggest a better way without going through this macro
magic, I will be glad to implement it. The 2 main reasons I made this
patch was to remove the added latency in syscall tracing and to remove
penalty for syscalls that are not traced.



Thanks

Vaibhav Nagarnaik
