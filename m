Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab1EYTym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:54:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33411 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab1EYTyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:54:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110525190602.GC17864@elte.hu>
References: <1305807728.11267.25.camel@gandalf.stny.rr.com>
	<BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>
	<BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
	<1306254027.18455.47.camel@twins>
	<20110524195435.GC27634@elte.hu>
	<alpine.LFD.2.02.1105242239230.3078@ionos>
	<20110525150153.GE29179@elte.hu>
	<alpine.LFD.2.02.1105251836030.3078@ionos>
	<20110525180100.GY19633@outflux.net>
	<BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
	<20110525190602.GC17864@elte.hu>
Date: Wed, 25 May 2011 14:54:39 -0500
Message-ID: <BANLkTinUQ8XnNWBpKkzP5UPS4cdVT1T0EQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
From: Will Drewry <wad@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 2:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> And per-system-call permissions are very dubious. What system calls
>> don't you want to succeed? That ioctl? You just made it impossible
>> to do a modern graphical application. Yet the kind of thing where
>> we would _want_ to help users is in making it easier to sandbox
>> something like the adobe flash player. But without accelerated
>> direct rendering, that's not going to fly, is it?
>
> I was under the impression that Will had a very specific application
> in mind which actually works today and uses the inferior version of
> seccomp.
>
> Will, mind filling us in on that?

With pleasure!  I'll be a bit overly verbose to ensure I'm covering my
bases, I hope it's not too tedious.

Support for using system call filtering will be added to the Chromium
browser if it is accepted here.  At present, Chromium separates the
processing of untrusted input (html, javascript, images) into
standalone renderer processes.  In an effort to reduce the risks
associated with processing the data we put those renderers in a chroot
with a private VFS and PID namespace. This limits the ability for a
compromised renderer to signal() another process outside of the
"sandbox" or access files it shouldn't.

Ideally, the only exposed surface to the renderer would be the IPC
mechanism, memory allocation, etc.  That isn't possible today though
[*].  The renderer gets the whole syscall ABI.  In many cases, adding
support for (all of the) LSMs to the sandboxing methodology would help
mitigate the exposure.  There would be the code paths that handle the
user input prior to calling the LSM hooks, but after that point, the
renderer could be denied, shutdown, etc.  Unfortunately, there's no
one-to-one mapping from system calls to LSM hooks (nor do all stock
kernels from distros come with a pre-chosen and configured LSM).

To supply some concreteness, the perf_counter_open() system call comes
to mind.  It suffered from a stack-based buffer overflow when
processing the user-supplied arguments, and there was no effective
mechanism, LSM or otherwise, to prevent its access.  In my usecase, if
only a whitelist of required system calls was made available to the
Chromium renderer processes, then the addition of a bug like
perf_counter_open()'s to the kernel would not have provided a direct
means to escape the user-level sandboxing and execute arbitrary code
in the kernel.


As I mentioned, if it is possible to expand seccomp to provide a
system call access mechanism (bitmask, whatever),  I will expand the
Chromium sandbox to make use of it on every linux distro that ships
with it enabled.  In addition, my immediate work focus is on Chromium
OS.  I would like to apply system call filtering to every daemon in
the distribution alongside additional security defenses.  Also, I am
aware of many server-side uses but can't promise immediate deployment
in the same fashion.



[It's also worth noting that as more browser plugins, like Adobe
Flash, migrate to the Pepper API (chrome,mozilla), they will no longer
need direct hardware access (ioctl()s, fs, etc).  All system access
will be brokered via the browser which lets them be sandboxed entirely
-- including system call filtering is supported by the host platform.]

[*] it is possible to do crazy, on-the-fly syscall rewriting with
seccomp(1) and a trusted thread, but the performance cost is huge, the
portability is nil (pure asm), and the risk of a security bug is high.

> I'd agree that adding any of this without a real serious app making
> real use of it would be pointless. I discussed this under the
> impression that the app existed :-)
>
> I also got the very distinct impression from the various iterations
> that a real usecase existed behind it - all the fixes and
> considerations looked very realistic, not designed up for security's
> sake.
>
>> So I'm sorry for throwing cold water on you guys, but the whole
>> "let's come up with a new security gadget" thing just makes me go
>> "oh no, not again".
>
> Fair enough :-)

I don't want to boil the ocean and certainly am not interested in
reliving the LSM-wars. I want the missing piece of the puzzle when it
comes to reducing exposed kernel code.  seccomp.mode=1 is so close,
but its overly restrictive nature has made it implausible for nearly
all real-world uses.  A slight expansion to allow a system call
bitmask or simple filters would be sufficient for Chromium OS,
Chromium, qemu, and lxc use, among others.


Thanks for reading and replying!
will
