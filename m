Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab2DTRWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:22:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64705 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab2DTRV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:21:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120420164239.GH6871@ZenIV.linux.org.uk>
References: <1334772473.2137.22.camel@falcor> <20120418183938.GH6589@ZenIV.linux.org.uk>
 <1334865448.2429.35.camel@falcor> <20120420004303.GB6871@ZenIV.linux.org.uk>
 <CA+55aFxQR8g3TycW7nOVjjnnsaWWW-Gh74-bV6rUm+7SRTm25g@mail.gmail.com>
 <20120420025438.GD6871@ZenIV.linux.org.uk> <CA+55aFzinX_6DVvDTyxrsP6VEHVY2Q+Y=e+qksnAjR+oT3GZew@mail.gmail.com>
 <20120420080914.GF6871@ZenIV.linux.org.uk> <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com>
 <20120420160848.GG6871@ZenIV.linux.org.uk> <20120420164239.GH6871@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Apr 2012 10:21:35 -0700
X-Google-Sender-Auth: 80uG6BEmYLjd-2_PTTZxqJWzjSQ
Message-ID: <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 9:42 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Actually, I like the per-CPU spinlock variant better; the thing is,
> with that scheme we get normal fput() (i.e. non-nodefer variant)
> non-blocking.  How about this:

What's the advantage of a per-cpu lock?

If you make the work be per-cpu, then you're better with no locking at
all: just disable interrupts (which you do anyway).

And if you want to use a spinlock, don't bother with the percpu side.

The thing I do not like about the schedule_work approach is that it
(a) totally hides the real cost  - which is the scheduling - and (b)
it is so asynchronous that it will happen potentially long after the
task dropped the reference.

And seriously - that is user-visible behavior.

For example, think about this *common* pattern:

  open+mmap+close+unlink+munmap

which would trigger the whole deferred fput, but also triggers the
actual real unlink() at fput time.

Right now, you can have that kind of thing in a program and
immediately unmount the filesystem afterwards (replace "unmount" with
"cannot see silly-renamed files" etc).

The "totally asynchronous deferral" literally *breaks*semantics*.

Sure, it won't be noticeable in 99.99% of all cases, and I doubt you
can trigger much of a test for it. But it's potential real breakage,
and it's going to be hard to ever see. And then when it *does* happen,
it's going to be totally impossible to debug.

It's not just the "last unlink" thing that gets delayed. It things
like file locking. It's "drop_file_write_access()". It's whatever
random thing that file does at "release()". It's a ton of things like
that. Delaying them has user-visible actions.

That's a whole can of complexities and worries outside of the kernel
interface that you are completely ignoring - just because you are
trying to solve the *simple* complexity of locking interaction
entirely within the kernel.

I think that's a bit myopic. We don't even *know* what the problems
with the async approach might be. Your "simple" solution is simple
only inside the kernel.

This is why I suggested you look at Oleg's patches. If we guarantee
that things won't be delayed past re-entering user mode, all those
issues go away.

                     Linus
