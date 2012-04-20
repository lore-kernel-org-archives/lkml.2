Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab2DTSH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:07:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39203 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab2DTSHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:07:55 -0400
Date: Fri, 20 Apr 2012 19:07:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
Message-ID: <20120420180748.GI6871@ZenIV.linux.org.uk>
References: <1334865448.2429.35.camel@falcor>
 <20120420004303.GB6871@ZenIV.linux.org.uk>
 <CA+55aFxQR8g3TycW7nOVjjnnsaWWW-Gh74-bV6rUm+7SRTm25g@mail.gmail.com>
 <20120420025438.GD6871@ZenIV.linux.org.uk>
 <CA+55aFzinX_6DVvDTyxrsP6VEHVY2Q+Y=e+qksnAjR+oT3GZew@mail.gmail.com>
 <20120420080914.GF6871@ZenIV.linux.org.uk>
 <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com>
 <20120420160848.GG6871@ZenIV.linux.org.uk>
 <20120420164239.GH6871@ZenIV.linux.org.uk>
 <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 10:21:35AM -0700, Linus Torvalds wrote:
> On Fri, Apr 20, 2012 at 9:42 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Actually, I like the per-CPU spinlock variant better; the thing is,
> > with that scheme we get normal fput() (i.e. non-nodefer variant)
> > non-blocking. ?How about this:
> 
> What's the advantage of a per-cpu lock?
> 
> If you make the work be per-cpu, then you're better with no locking at
> all: just disable interrupts (which you do anyway).

Point taken.

> The thing I do not like about the schedule_work approach is that it
> (a) totally hides the real cost  - which is the scheduling - and (b)
> it is so asynchronous that it will happen potentially long after the
> task dropped the reference.

[snip]

> This is why I suggested you look at Oleg's patches. If we guarantee
> that things won't be delayed past re-entering user mode, all those
> issues go away.

I've looked at them.  One obvious problem is that it tracehook_notify_resume()
is not universally called.  AFAICS, hexagon, m68k, microblaze, score, um
and xtensa never call tracehook_notify_resume().  Out of those, hexagon is
manually checking TIF_NOTIFY_RESUME and does key_replace_session_keyring(),
so the call could be easily added into the same place; the rest of those
guys don't even look at TIF_NOTIFY_RESUME anywhere near their signal*.c
and m68k/um/xtensa don't even have it defined, let alone handled.  So this
stuff depends on some amount of asm glue hacking on several architectures ;-/

Another is that final fput() can, indeed, happen in kernel threads, so
pure switch to task_work_add() won't be enough.  I agree that having this
stuff flushed before we return to userland would be a good thing; the
question is, can we easily tell if there will be such a return to userland?
