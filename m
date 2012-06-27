Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab2F0Kt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 06:49:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42791 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858Ab2F0Kt0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 06:49:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120627060939.GD14913@gmail.com>
References: <CAPXgP124qFG=QdO4H7qsp1bhY4BOp-PJEz7-4v-Dhi13LW+GDQ@mail.gmail.com>
 <20120627060939.GD14913@gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 27 Jun 2012 12:49:05 +0200
Message-ID: <CAPXgP10OLwd2v57qJqoJMTkXrM+7C8uhFoydy6HUEbfPfFVN8Q@mail.gmail.com>
Subject: Re: cosmetic printk() issue with lockdep warning in arch/x86/kernel/alternative.c
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartmann <greg@kroah.com>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 8:09 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> [    0.353960]  #5lockdep: fixing up alternatives.
>> [    0.427948]  #6lockdep: fixing up alternatives.
>> [    0.501937]  #7 Ok.
>> [    0.575952] Brought up 8 CPUs
>
> We could certainly change the lockdep printouts - but I'm really
> not sure it's wise to fight those kinds of printk() usage
> patterns:
>
> Piecemail wise printouts are handy and natural as they follow
> actual code flow. As the code progresses so do the continued
> printk()s get progressed. We use single-line printouts to not
> use up too much screen real estate during bootup.
>
> So ... why not do what I suggested very, very early on: don't
> touch printk screen output itself *AT ALL* - keep it simple and
> direct, don't add complexity to the pathway of kernel code
> trying to communicate a kernel bug to the user.

Not sure if I follow, this is exactly the case of: "We use single-line
printouts to not use up too much screen real estate" you mention. What
happens here is that the CPU code does not want hundreds of lines on
big boxes, hence it does try to fold them into one line with CONT
print. The lockdep print just prints a full terminated line
*in-between* every CONT of the stream.

As said, it's cosmetic, but it's obviously ugly and wrong to do that.
That's all. I'm not interested in the text it prints, it will not hurt
anything if we don't change it, it just looks ugly.

> Instead solve your needs by simply tracing printk() calls and
> the resulting strings [with a string event - I think Steve
> posted an RFC patch for that early on - apply that patch and
> recover the events - we could build-in this portion of tracing
> whenever CONFIG_PRINTK is enabled to make sure the facility is
> always available] and reconstruct the lines and the full
> ASCII-string events in user-space: if PID,CPU is traced and
> there's one record per printk() call then it's *trivial* to
> reconstruct 99.9% of the printk lines in the user-space code
> that receives the trace events.

As mentioned in the earlier discussion weeks ago, I'm not convinced
that tracing is the replacement for general purpose system logging.
Tracing to me is more an optional analysis and debugging tool to me,
not do much something we make mandatory now, that must work for every
little box out there, without any further configuration.

We just want a more reliable kernel logging, and for some logs the
context it was created in, very much like dev_printk() was supposed to
do, just in a working manner.

What we do already for userspace service logging, we want to integrate
the kernel logs for the related devices too:
  https://plus.google.com/108087225644395745666/posts/iuFEgBZT3co

This is mainly about being able to *filter* the log, relate it to a
context, and query it at a later from userspace tools. The main
consumer is still the admin or human in front of it, but without the
grep and regex.

> Keep /proc/kmsg and don't change it much - but trace printk()
> calls form your new systemd code. WHY don't you use that
> approach? It's actually totally sensible, useful, it keeps the
> printk status quo in place, improves other usecases and can be
> done using existing facilities...

Why would we want another buffer for the same data? I really don't see
the benefit that much, but I might miss it.

Kmsg to us, is the counterpart of syslog, and that seems just good
enough, when messages do not interleave anymore, have sequence
numbers, and some simple device/context annotation. The kernel needs
to maintain and buffer them anyway and all that comes for almost free.

All we want is a reliable printk, and that is not only nice when we
retrieve the logs, it's also nice for internal things like ksmg_dump()
or any other user that was fiddling with possible dangling pointers in
the past in the old kmsg byte buffer.

I personally could understand if we wanted to replace the entire kmsg
buffering with the tracing buffer code, and make the trace buffer
mandatory that way. That would, in theory at least, unify things. But
I really don't see at the moment how we could require another entirely
independent facility to just make "plain old syslog" work better.

Thanks,
Kay
