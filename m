Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab1D1QNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:13:19 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57264 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab1D1QNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:13:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=L4iLJPwMwpq56V69r/pEtU131bcbPw/xPa1HdjDvkwPJU6EmMzRTDPqmmqGGfsMmoO
         14xAa8NkR83bLnwznNCiaeILZQWKKTujCUFWOrjBO09GjEh0nGsSXgmhjmocqg+vzcJS
         E8ehlza66oPMPtAjN0ud1BFX3jOHLq3nun414=
Date: Thu, 28 Apr 2011 18:13:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com, eparis@redhat.com,
        agl@chromium.org, mingo@elte.hu, jmorris@namei.org,
        rostedt@goodmis.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call
 filtering
Message-ID: <20110428161304.GG1798@nowhere>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
 <1303960136-14298-2-git-send-email-wad@chromium.org>
 <20110428151241.GD1798@nowhere>
 <BANLkTika4xn5SajxGbRtszqyA4R=4y8M6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTika4xn5SajxGbRtszqyA4R=4y8M6Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 10:29:11AM -0500, Will Drewry wrote:
> On Thu, Apr 28, 2011 at 10:12 AM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
> > Instead of having such multiline filter definition with syscall
> > names prepended, it would be nicer to make the parsing simplier.
> >
> > You could have either:
> >
> >        prctl(PR_SET_SECCOMP, mode);
> >        /* Works only if we are in mode 2 */
> >        prctl(PR_SET_SECCOMP_FILTER, syscall_nr, filter);
> 
> It'd need to be syscall_name instead of syscall_nr.  Otherwise we're
> right back to where Adam's patch was 2+ years ago :)  Using the event
> names from the syscalls infrastructure means the consumer of the
> interface doesn't need to be confident of the syscall number.

Is it really a problem? There are libraries that can resolve that. Of
course I can't recall their name.

> 
> > or:
> >        /*
> >         * If mode == 2, set the filter to syscall_nr
> >         * Recall this for each syscall that need a filter.
> >         * If a filter was previously set on the targeted syscall,
> >         * it will be overwritten.
> >         */
> >        prctl(PR_SET_SECCOMP, mode, syscall_nr, filter);
> >
> > One can erase a previous filter by setting the new filter "1".
> >
> > Also, instead of having a bitmap of syscall to accept. You could
> > simply set "0" as a filter to those you want to deactivate:
> >
> > prctl(PR_SET_SECCOMP, 2, 1, 0); <- deactivate the syscall_nr 1
> >
> > Hm?
> 
> I like the simplicity in not needing to parse anything extra, but it
> does add the need for extra state - either a bit or a new field - to
> represent "enabled/enforcing".

And by the way I'm really puzzled about these. I don't understand
well why we need this.

As for the enable_on_next_syscall. The documentation says
it's useful if you want the filter to only apply to the
child. So if fork immediately follows, you will be able to fork
but if the child doesn't have the right to exec, it won't be able
to do so. Same for the mmap() that involves...

So I'm a bit confused about that.

But yeah if that's really needed, it looks to me better to
reduce the parsing and cut it that way:

	prctl(PR_SET_SECCOMP, 2, syscall_name_or_nr, filter);
	prctl(PR_SECCOMP_APPLY_FILTERS, enable_on_next_syscall?)

or something...

> 
> The only way to do it without a third mode would be to take a
> blacklist model - where all syscalls are allowed by default and the
> caller has to enumerate them all and drop them. That would definitely
> not be the right approach :)
> 
> If a new bit of state was added,  it could be used as:
>   prctl(PR_SET_SECCOMP, 2);
>   prctl(PR_SET_SECCOMP, 2, "sys_read", "fd == 1");  /* add a read filter */
>   prctl(PR_SET_SECCOMP, 2, "sys_write", "fd == 0");  /* add a read filter */
>   ...
>   prctl(PR_SET_SECCOMP, 2, "sys_read", "0");  /* clear the sys_read
> filters and block it */  (or NULL?)
>   prctl(PR_SET_SECCOMP, 2, "enable");  /* Start enforcing */
>   prctl(PR_SET_SECCOMP, 2, "sys_write", "0");  /* Reduce attack
> surface on the fly */
> 
> 
> As to the "0" filter instead of a bitmask, would it make sense to just
> cut over to an hlist now and drop the bitmask?
> It looks like perf
> uses that model, and I'd hope it wouldn't incur too much additional
> overhead.  (The linked list approach now is certainly not scalable for
> a large number of filters!)

The linked list certainly doesn't scale there. But either a hlist for
everything, or a hlist + bitmap to check if the syscall is enabled,
why not. May be start with a pure hlist for any filters and if performance
issues that really matter are pinpointed, then move the "1" and "0"
implementation to a bitmap.

My guess is that doesn't really matter. If it's "1" then you can
just have an empty set of filters for the syscall and it goes ahead
quickly. If it's "0" then the app fails, which is not what I would
call a fast path.

> If that interface seems sane, I can certainly start exploring it and
> see if I hit any surprises (and put it in the next version of the
> patch :).  I think it'll simplify a fair amount of the add/drop code!

Yup.
