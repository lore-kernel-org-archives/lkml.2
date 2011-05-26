Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab1EZBUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 21:20:17 -0400
Received: from tundra.namei.org ([65.99.196.166]:58395 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab1EZBUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 21:20:16 -0400
Date: Thu, 26 May 2011 11:19:34 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Kees Cook <kees.cook@canonical.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Will Drewry <wad@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
In-Reply-To: <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
References: <20110517131902.GF21441@elte.hu> <BANLkTikBK3-KZ10eErQ6Eex_L6Qe2aZang@mail.gmail.com> <1305807728.11267.25.camel@gandalf.stny.rr.com> <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com> <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
 <1306254027.18455.47.camel@twins> <20110524195435.GC27634@elte.hu> <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu> <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Linus Torvalds wrote:

> And per-system-call permissions are very dubious. What system calls
> don't you want to succeed? That ioctl? You just made it impossible to
> do a modern graphical application. Yet the kind of thing where we
> would _want_ to help users is in making it easier to sandbox something
> like the adobe flash player. But without accelerated direct rendering,
> that's not going to fly, is it?

Going back to the initial idea proposed by Will, where seccomp is simply 
extended to filter all syscalls, there is potential benefit in being able 
to limit the attack surface of the syscall API.

This is not security mediation in terms of interaction between things 
(e.g. "allow A to read B").  It's a _hardening_ feature which prevents a 
process from being able to invoke potentially hundreds of syscalls is has 
no need for.  It would allow us to usefully restrict some well-established 
attack modes, e.g. triggering bugs in kernel code via unneeded syscalls.

This is orthogonal to access control schemes (such as SELinux), which are 
about mediating security-relevant interactions between objects.

One area of possible use is KVM/Qemu, where processes now contain entire 
operating systems, and the attack surface between them is now much broader 
e.g. a local unprivileged vulnerability is now effectively a 'remote' full 
system compromise.

There has been some discussion of this within the KVM project.  Using the 
existing seccomp facility is problematic in that it requires significant 
reworking of Qemu to a privsep model, which would also then incur a likely 
unacceptable context switching overhead.  The generalized seccomp filter 
as proposed by Will would provide a significant reduction in exposed 
syscalls and thus guest->host attack surface.

I've cc'd some KVM folk for more input on how this may or may not meet 
their requirements -- Avi/Gleb, there's a background writeup here: 
http://lwn.net/Articles/442569/ .  We may need a proof of concept and/or 
commitment to use this feature for it to be accepted upstream.


- James
-- 
James Morris
<jmorris@namei.org>
