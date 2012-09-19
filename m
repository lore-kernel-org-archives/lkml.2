Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2ISFas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 01:30:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41892 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab2ISFah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 01:30:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120919045038.GA2248@netboy.at.omicron.at>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
 <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com>
 <5057BE59.3050903@linaro.org> <20120918180200.GA2281@netboy.at.omicron.at>
 <5058BD9E.30909@linaro.org> <20120919045038.GA2248@netboy.at.omicron.at>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 18 Sep 2012 22:30:15 -0700
Message-ID: <CALCETrUoU+MPnV2kuy4UmAfHvSVtfXBt-zQ=QAvhZx3qXgTvXQ@mail.gmail.com>
Subject: Re: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
To: Richard Cochran <richardcochran@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 9:50 PM, Richard Cochran
<richardcochran@gmail.com> wrote:
> On Tue, Sep 18, 2012 at 11:29:50AM -0700, John Stultz wrote:
>> I believe its mostly historical, but on some architectures that
>> history has become an established ABI, making it technical.
>
> Fine, but what do you mean by "ABI?" Are you talking about magic
> addresses for functions?
>
> Without knowing the dirty details, what I imagine is a jump/branch
> from the arch-specific code into the common implementation.

I suspect (based mostly on speculation) that this is possible for
everything except ia64.  ia64 looks like it uses a highly magical
syscall entry, where user code jumps to a special address for *all*
syscalls, and that code does some kind of partial kernel entry.  Very
careful asm code can run in that weird state, and that code implements
gettimeofday.  Now, if that code could return back to normal execution
and jump to a vdso, it could use common code, I guess.

This assumes that all architectures that want to use vclock_gettime,
etc are capable of sharing a page of read-only kernel memory with
userspace at a fixed address or can otherwise make the VVAR macro
work.  The only architectures I actually understand are x86-{32,64},
which can.  I don't think anyone cares about x86-32 enough to
implement it, though.

--Andy
