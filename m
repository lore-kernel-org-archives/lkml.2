Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934372Ab2C3MHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:07:12 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:39088 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933847Ab2C3MHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:07:05 -0400
Date: Fri, 30 Mar 2012 14:06:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Sharp <dhsharp@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, Michael Davidson <md@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace
 handler
Message-ID: <20120330120657.GC13022@somewhere.redhat.com>
References: <4F714982.6020208@zytor.com>
 <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com>
 <4F73CC3A.2080901@zytor.com>
 <CAL26m8+zbbqngfK0fYb+A2UBQ1fZ9Uxrf4VLWqU1VuMzkcF4xw@mail.gmail.com>
 <20120329062031.GB1376@gmail.com>
 <CAL26m8+BmN=DxR7LbukM7S4w9XcURjfDFizUNpEcZA_8g4JNVg@mail.gmail.com>
 <4F74B42F.3050100@zytor.com>
 <CAL26m8JA4HJQayJW2nYbVpHD7mgd0Bz6rFMipq2Nf6OECiyk1Q@mail.gmail.com>
 <4F74C0B2.1010100@zytor.com>
 <CAJL_ekvU8sjt0wi6GjrMiqy03kBZ6YzQkz9TO+MQzQAr_-2VnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJL_ekvU8sjt0wi6GjrMiqy03kBZ6YzQkz9TO+MQzQAr_-2VnQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 03:40:17PM -0700, David Sharp wrote:
> On Thu, Mar 29, 2012 at 1:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > I had a long discussion with Frederic over IRC earlier today.  We came
> > up with the following strawman:
> >
> > 1. A system call thunk (which could be enabled/disabled by patching the
> > syscall table.)  This provides an entry and exit hook, and also sets a
> > per-thread flag to capture userspace traffic.
> 
> Our goal is for syscall traces to be as fast as regular tracepoints.
> iirc, What we've found is that much of the extra overhead of syscall
> tracepoints as compared to regular tracepoints is due to that the code
> path for syscall tracing is bundled with checks for ptrace and other
> stuff (Vaibhav did all this characterization, he can jump in with
> details if wanted). How much work would this "thunk" have to do that
> is not either recording the trace or calling the syscall?
> 
> >
> > 2. Instrumenting get_user/put_user/copy_from_user/copy_to_user to
> > capture traffic to userspace.  This captures the *full* set of system
> > call arguments, including things addressed via pointers.  Furthermore,
> > it captures the exact versions fed to or returned from the kernel, and
> > deals with data-dependent collection like ioctl().
> 
> Do I understand correctly that you are thinking to copy tho contents
> of those buffers into the ring buffer? This sounds useful. However I
> think it should be optional and the number of bytes copied should be
> limited (tunable). On highly utilized systems, we don't always have a
> lot of memory to dedicate to the ring bufffer, so filling it with the
> contents of, eg, the payload of "read" or "write" would not be
> acceptable under those circumstances. And since events in the ring
> buffer can't cross page boundaries, at some threshold this will cause
> an unacceptable level of unutilized space in the ring buffer.
> 
> (For context, this is coming from the folks that added "tiny" versions
> of syscall tracepoints that only put 16 bits of arg0 into the ring
> buffer so we can get longer trace durations.)

BTW, since tracing overhead (in terms of volume and throughput) is
important for you guys, have you considered adding some option to ftrace
to ignore the "common" fields on the trace record:

        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;
        field:int common_padding;       offset:8;       size:4; signed:1;

I think you talked about that on the last kernel summit. This would be
interesting for everyone.

You can find out the pid on top of sched switch events. The rest is probably useless
most of the time.
