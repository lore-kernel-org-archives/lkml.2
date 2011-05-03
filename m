Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab1ECBrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 21:47:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48585 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab1ECBrC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 21:47:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BJFtoXsFk8PwIM9OIKMQlStxJ+4D+bIrt3vOfap/4Hvs9TjoMFA9VV1ed+Ctm7LO03
         v2zefNH35fuIB9UfhzCnmOBIR2bUQJwOEdyH2YrdBZne3AhmRKx9cWtsFUYc4pVg9KIS
         Abu4TNLwSF67OQF4WoVWqJFonBLSsRbWkhSM8=
MIME-Version: 1.0
In-Reply-To: <20110503012857.GA8399@nowhere>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	<1303960136-14298-4-git-send-email-wad@chromium.org>
	<20110428070636.GC952@elte.hu>
	<1304002571.2101.38.camel@localhost.localdomain>
	<BANLkTi=5NYTM5T2LthVL+8kjQvYWwHSVPg@mail.gmail.com>
	<20110429131845.GA1768@nowhere>
	<BANLkTimhWZURqgAXG45=3CG-bNhv+g-Ftg@mail.gmail.com>
	<20110503012857.GA8399@nowhere>
Date: Tue, 3 May 2011 03:47:01 +0200
Message-ID: <BANLkTimhugGCnMQ4f2T2HOvwVLrGTREPkg@mail.gmail.com>
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/3 Frederic Weisbecker <fweisbec@gmail.com>:
> On Fri, Apr 29, 2011 at 11:13:44AM -0500, Will Drewry wrote:
>> That said, I have a general interface question :)  Right now I have:
>> prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_ADD, syscall_nr, filter_string);
>> prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_DROP, syscall_nr,
>> filter_string_or_NULL);
>> prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_APPLY, apply_flags);
>>   (I will change this to default to apply_on_exec and let FILTER_APPLY
>> make it apply _now_ exclusively. :)
>>
>> This can easily be mapped to:
>> prctl(PR_SET_SECCOMP
>>        PR_SET_SECOMP_FILTER_ADD
>>        PR_SET_SECOMP_FILTER_DROP
>>        PR_SET_SECOMP_FILTER_APPLY
>> if that'd be preferable (to keep it all in the prctl.h world).
>>
>> Following along the suggestion of reducing custom parsing, it seemed
>> to make a lot of sense to make add and drop actions very explicit.
>> There is no guesswork so a system call filtered process will only be
>> able to perform DROP operations (if prctl is allowed) to reduce the
>> allowed system calls.  This also allows more fine grained flexibility
>> in addition to the in-kernel complexity reduction.  E.g.,
>> Process starts with
>>   __NR_read, "fd == 1"
>>   __NR_read, "fd == 2"
>> later it can call:
>>   prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_DROP, __NR_read, "fd == 2");
>> to drop one of the filters without disabling "fd == 1" reading.  (Or
>> it could pass in NULL to drop all filters).
>
> Hm, but then you don't let the childs be able to restrict further
> what you allowed before.
>
> Say I have foo(int a, int b), and I apply these filters:
>
>        __NR_foo, "a == 1";
>        __NR_foo, "a == 2";
>
> This is basically "a == 1 || a == 2".
>
> Now I apply the filters and I fork. How can the child
> (or current task after the filter is applied) restrict
> further by only allowing "b == 2", such that with the
> inherited parent filters we have:
>
>        "(a == 1 || a == 2) && b == 2"
>
> So what you propose seems to me too limited. I'd rather have this:
>
> SECCOMP_FILTER_SET = remove previous filter entirely and set a new one
> SECCOMP_FILTER_GET = get the string of the current filter
>
> The rule would be that you can only set a filter that is intersected
> with the one that was previously applied.
>
> It means that if you set filter A and you apply it. If you want to set
> filter B thereafter, it must be:
>
>        A && B
>
> OTOH, as long as you haven't applied A, you can override it as you wish.
> Like you can have "A || B" instead. Or you can remove it with "1". Of course
> if a previous filter was applied before A, then your new filter must be
> concatenated: "previous && (A || B)".
>
> Right? And note in this scheme you can reproduce your DROP trick. If
> "A || B" is the current filter applied, then you can restrict B by
> doing: "(A || B) && A".
>
> So the role of SECCOMP_FILTER_GET is to get the string that matches
> the current applied filter.
>
> The effect of this is infinite of course. If you apply A, then apply
> B then you need A && B. If later you want to apply C, then you need
> A && B && C, etc...
>
> Does that look sane?
>

Even better: applying a filter would always automatically be an
intersection of the previous one.

If you do:

SECCOMP_FILTER_SET, __NR_foo, "a == 1 || a == 2"
SECCOMP_FILTER_APPLY
SECCOMP_FILTER_SET, __NR_foo, "b == 2"
SECCOMP_FILTER_APPLY
SECCOMP_FILTER_SET, __NR_foo, "c == 3"
SECCOMP_FILTER_APPLY

The end result is:

"(a == 1 || a == 2) && b == 2  && c == 3"

So that we don't push the burden in the kernel to compare the applied
expression with a new one that may or may not be embraced by parenthesis
and other trickies like that. We simply append to the working one.

Ah and OTOH this:

SECCOMP_FILTER_SET, __NR_foo, "a == 1 || a == 2"
SECCOMP_FILTER_APPLY
SECCOMP_FILTER_SET, __NR_foo, "b == 2"
SECCOMP_FILTER_SET, __NR_foo, "c == 3"

has the following end result:

"(a == 1 || a == 2) && c == 3"

As long as you don't apply the filter, the temporary part is
overriden, but still we keep
the applied part.

Still sane? (or completely nuts?)
