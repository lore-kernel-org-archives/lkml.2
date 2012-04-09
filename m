Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab2DIXzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 19:55:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63914 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2DIXzp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 19:55:45 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1204091603430.21813@chino.kir.corp.google.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
 <20120408195044.13ea6c8e.akpm@linux-foundation.org> <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
 <alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com>
 <CA+55aFxUQJC+_aA0qnj0b-LoGfCjfFoG3HXgQ+7LND7y8dFDhw@mail.gmail.com>
 <alpine.DEB.2.00.1204091355280.10873@chino.kir.corp.google.com>
 <CA+55aFztPW2x1grh2Z7RTOxKZ29_Ha6-kDkJXgdghFHQ61EZOQ@mail.gmail.com> <alpine.DEB.2.00.1204091603430.21813@chino.kir.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Apr 2012 16:55:23 -0700
X-Google-Sender-Auth: aCdZfMHQ2TLX8eXngAECOm66P2U
Message-ID: <CA+55aFwa40cv_TYdU3dKHPPJQo2omLpi8y6k6KBhJ5uP12f29A@mail.gmail.com>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 4:25 PM, David Rientjes <rientjes@google.com> wrote:
>
> You could that if you also turned the check for "ret == NOTIFY_OK" in
> profile_handoff_task() into "ret & NOTIFY_OK" in your patch, otherwise you
> get a double free from __put_task_struct() and oprofile.

Why? NOTIFY_DONE is zero.

I do agree that we *also* could do the "& NOTIFY_OK" and make it
clearer that we're oring bits together. And we could document the
stupid notifier interfaces to do this all, and just make the rules be
*sane* when you have multiple notifiers.

And sane rules would be either:

 - you always return an error return, and notifiers all return either
0 or a negative error number, and we stop on the first error and
return that.

 - you return a bitmask, and we or all bits together (and we can
certainly continue to have a "stop here" bit)

But the current notifier semantics are just insane. The whole "we
return the last return value" is crazy. It's by definition a random
number, since the whole point of notifiers is that there can be
multiple, and they aren't "ordered". So the whole "last return value"
is something I just look at and say: "Whoever designed that is a
f*cking moron".

(And if that happens to be some younger version of me, I am happy that
I got over it. But I'm pretty sure I have never touched that broken
notifier code in my life)

> It works fine if the callbacks are correctly implemented, it's just that
> the task handoff in kernel/profile.c is broken because it assumes only one
> callback will return NOTIFY_OK, meaning it will eventually free, and its
> only checking the return value of the last notifier called to see if
> __put_task_struct() should immediately free.

We can easily document it as "only oprofile is allowed to return
NOTIFY_OK, this notifier is a big mess, don't even *think* about
returning anything but NOTIFY_DONE".

>  (1)  fix the lowmemorykiller so it doesn't need to use these notifiers at
>      all, which isn't difficult, for 3.4, then

I do think that that makes sense. Fixing people to not use notifiers
is always a good idea. Why would anybody sane even care about the
process going away anyway? If some lowmemorykiller decides to kill off
a process that no longer exists, kill() should happily return ENOSRCH,
and we're all good

So it could just use a "pid", and test for existence with send_sig()
or lookup_pid() or something.

>  (2a) change the task handoff to a refcount on task->usage after the final
>      put_task_struct() using the notifier and then allow it to be freed
>      after everybody does a put_handoff_task_struct() for 3.5

The task handoff code runs too late right now. I guess we could easily
move it up, though.

At the same time, the *only* user of that stupid handoff thing is
oprofile, afaik, and if we use a refcount, why the hell doesn't
oprofile just use a refcount to begin with, instead of using that
notifier?: IOW, *both* users of the notifier seem to be just retarded.

So I'd rather just kill the stupid notifier entirely. In the meantime,
making lowmemorykiller just return zero instead just "fixes" it
(assuming we make the notifier semantics for multiple return codes
sane, which they clearly aren't).

Again, almost every notifier user has always been total crap. It's
just a stupid abstraction. "Something happened". "Oh, ok".

                    Linus
