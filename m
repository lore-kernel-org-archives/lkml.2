Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab2CAHNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 02:13:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51772 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab2CAHM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 02:12:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of vda.linux@googlemail.com designates 10.213.105.195 as permitted sender) smtp.mail=vda.linux@googlemail.com; dkim=pass header.i=vda.linux@googlemail.com
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tim Bird <tim.bird@am.sony.com>
Subject: Re: Questions about ptrace on a dying process
Date: Thu, 1 Mar 2012 08:12:54 +0100
User-Agent: KMail/1.8.2
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        linux kernel <linux-kernel@vger.kernel.org>
References: <4F4E6915.1010209@am.sony.com> <m2mx81pi7x.fsf@firstfloor.org> <4F4E8E6A.2020601@am.sony.com>
In-Reply-To: <4F4E8E6A.2020601@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201203010812.54769.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 February 2012 21:45, Tim Bird wrote:
> On 02/29/2012 11:12 AM, Andi Kleen wrote:
> > Tim Bird <tim.bird@am.sony.com> writes:
> > 
> >> ptrace maintainers (and interested parties)...
> >>
> >> I'm working on a crash handler for Linux, which uses ptrace to retrieve information
> >> about a process during it's coredump.  Specifically, from within a core handler
> >> program (started within do_coredump() as a user_mode_helper), I would like to make
> >> ptrace calls against the dying process.
> > 
> > The standard approach is to define a core pipe handler and parse the
> > elf memory dump.
> 
> Yeah - I may be doing something new here.  Android uses ptrace
> in debuggerd, which is their crash reporting tool, but they wake
> it up with signals before the dying program goes into coredump.

I think ptrace API does not provide guarantees that it is possible
to attach to the process when it coredumps.

It might work in current kernels, but might break in new ones.

> I'm taking a different approach and trying to do initiated
> by the coredump feature in Linux.  This makes it so that
> a process does not need to be persistently running to capture
> these events.
> 
> This is on embedded systems, where the dump is not saved.  The dump
> is available via stdin to the core pipe handler, but it would be
> kind of a pain to wrapper that for random access, which is needed
> for stuff like stack unwinding.

Stack unwinding only requires the stack data and knowledge
of the mapped binary and library files. You can parse coredump's ELF header,
and skip all sizable data segments which you won't need anyway.

I estimate that usually you will need to save only ~150k of data
in order to produce a stacktrace, and even then,
only because Linux pre-allocates ridiculously large
stack for every new process - 132k. It can easily be reduced
to something saner with one-line patch.

-- 
vda
