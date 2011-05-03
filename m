Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab1ECB3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 21:29:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58629 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab1ECB3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 21:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n7WSIWCUQMwcqQ+RXtP1Tm5qh8uriSJqxk8R0btLo/HAziXXb9eNhOdIBZ0Y2PHLGP
         MzgAia3bTEdhGRZLLSWsEToBa8stOxp8w78KC6bZUH0qtxw0wwLENQsSsxAXwrj1agdv
         bRA/q6IiQBMG7LpHOBodwBZkAkjAU9n7j2Qzk=
Date: Tue, 3 May 2011 03:29:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Will Drewry <wad@chromium.org>
Cc: Eric Paris <eparis@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        agl@chromium.org, jmorris@namei.org, rostedt@goodmis.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is
 and how it works.
Message-ID: <20110503012857.GA8399@nowhere>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
 <1303960136-14298-4-git-send-email-wad@chromium.org>
 <20110428070636.GC952@elte.hu>
 <1304002571.2101.38.camel@localhost.localdomain>
 <BANLkTi=5NYTM5T2LthVL+8kjQvYWwHSVPg@mail.gmail.com>
 <20110429131845.GA1768@nowhere>
 <BANLkTimhWZURqgAXG45=3CG-bNhv+g-Ftg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimhWZURqgAXG45=3CG-bNhv+g-Ftg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 11:13:44AM -0500, Will Drewry wrote:
> On Fri, Apr 29, 2011 at 8:18 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > PR_SET_SECCOMP_FILTER_APPLY seems only useful if you think there
> > are other cases than enable_on_exec that would be useful for these
> > filters.
> >
> > We can think about a default enable on exec behaviour as Steve pointed
> > out.
> >
> > But I have no idea if other cases may be desirable to apply these
> > filters.
> 
> I nearly have all of the changes in, but I'm still updating my tests.
> In general, I think having both on_exec and now is reasonable is
> because you can write a much tighter filter set if it is embedded in
> the application.  E.g., it may load all its shared libraries, which
> you allow, then lock itself down before touching untrusted content.

Well, that makes sense.

> That said, if the default behavior is enable_on_exec, then you'd only
> call PR_SET_SECCOMP_FILTER_APPLY when you want to apply _now_.  I like
> that.

It could be the default behaviour, which could be overriden with
PR_SET_SECCOMP_FILTER_APPLY. However I'm wondering about that enable_on_exec.

Say you want to accept only stdin/stdout read/write, and you blocked
mmap, open, etc... How can ld load the app and mmap all its shared libraries?
The filters are going to be applied once the interpreter is launched. This
makes me wonder now about the general usability of this and also about
the relevance in a default enable on exec behaviour here.

> 
> That said, I have a general interface question :)  Right now I have:
> prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_ADD, syscall_nr, filter_string);
> prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_DROP, syscall_nr,
> filter_string_or_NULL);
> prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_APPLY, apply_flags);
>   (I will change this to default to apply_on_exec and let FILTER_APPLY
> make it apply _now_ exclusively. :)
> 
> This can easily be mapped to:
> prctl(PR_SET_SECCOMP
>        PR_SET_SECOMP_FILTER_ADD
>        PR_SET_SECOMP_FILTER_DROP
>        PR_SET_SECOMP_FILTER_APPLY
> if that'd be preferable (to keep it all in the prctl.h world).
> 
> Following along the suggestion of reducing custom parsing, it seemed
> to make a lot of sense to make add and drop actions very explicit.
> There is no guesswork so a system call filtered process will only be
> able to perform DROP operations (if prctl is allowed) to reduce the
> allowed system calls.  This also allows more fine grained flexibility
> in addition to the in-kernel complexity reduction.  E.g.,
> Process starts with
>   __NR_read, "fd == 1"
>   __NR_read, "fd == 2"
> later it can call:
>   prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_DROP, __NR_read, "fd == 2");
> to drop one of the filters without disabling "fd == 1" reading.  (Or
> it could pass in NULL to drop all filters).

Hm, but then you don't let the childs be able to restrict further
what you allowed before.

Say I have foo(int a, int b), and I apply these filters:

	__NR_foo, "a == 1";
	__NR_foo, "a == 2";

This is basically "a == 1 || a == 2".

Now I apply the filters and I fork. How can the child
(or current task after the filter is applied) restrict
further by only allowing "b == 2", such that with the
inherited parent filters we have:

	"(a == 1 || a == 2) && b == 2"
	
So what you propose seems to me too limited. I'd rather have this:

SECCOMP_FILTER_SET = remove previous filter entirely and set a new one
SECCOMP_FILTER_GET = get the string of the current filter

The rule would be that you can only set a filter that is intersected
with the one that was previously applied.

It means that if you set filter A and you apply it. If you want to set
filter B thereafter, it must be:

	A && B

OTOH, as long as you haven't applied A, you can override it as you wish.
Like you can have "A || B" instead. Or you can remove it with "1". Of course
if a previous filter was applied before A, then your new filter must be
concatenated: "previous && (A || B)".

Right? And note in this scheme you can reproduce your DROP trick. If
"A || B" is the current filter applied, then you can restrict B by
doing: "(A || B) && A".

So the role of SECCOMP_FILTER_GET is to get the string that matches
the current applied filter.

The effect of this is infinite of course. If you apply A, then apply
B then you need A && B. If later you want to apply C, then you need
A && B && C, etc...

Does that look sane?
