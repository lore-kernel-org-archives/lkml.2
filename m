Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab2DIPkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 11:40:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65482 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab2DIPkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 11:40:15 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
 <20120408195044.13ea6c8e.akpm@linux-foundation.org> <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
 <alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Apr 2012 08:39:52 -0700
X-Google-Sender-Auth: BTR0CR-mIdDHXuRFyXkNhkvUWvU
Message-ID: <CA+55aFxUQJC+_aA0qnj0b-LoGfCjfFoG3HXgQ+7LND7y8dFDhw@mail.gmail.com>
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
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 3:15 AM, David Rientjes <rientjes@google.com> wrote:
>
> I think you nailed it.
>
> I suspect the problem is 1eda5166c764 ("staging: android/lowmemorykiller:
> Don't unregister notifier from atomic context") merged during the 3.4
> merge window and, unfortunately, backported to stable.

Ok. That does seem to match everything.

However, I think your patch is the wrong one.

The real bug is actually that those notifiers are a f*cking joke, and
the return value from the notifier is a mistake.

So I personally think that the real problem is this code in
profile_handoff_task:

        return (ret == NOTIFY_OK) ? 1 : 0;

and ask yourself two questions:

 - what the hell does NOTIFY_OK/NOTIFY_DONE mean?
 - what happens if there are multiple notifiers that all (or some)
return NOTIFY_OK?

I'll tell you what my answers are:

 (a) NOTIFY_DONE is the "ok, everything is fine, you can free the
task-struct". It's also what that handoff notifier thing returns if
there are no notifiers registered at all.

     So the fix to the Android lowmemorykiller is as simple as just
changing NOTIFY_OK to NOTIFY_DONE, which will mean that the caller
will properly free the task struct.

     The NOTIFY_OK/NOTIFY_DONE difference really does seem to be just
"NOTIFY_OK means that I will free the task myself later". That's what
the oprofile uses, and it frees the task.

 (b) But the whole interface is a total f*cking mess. If *multiple*
people return NOTIFY_OK, they're royally fucked. And the whole (and
only) point of notifiers is that you can register multiple different
ones independently.

So quite frankly, the *real* bug is not in that android driver
(although I'd say that we should just make it return NOTIFY_DONE and
be done with it). The real bug is that the whole f*cking notifier is a
mistake, and checking the error return was the biggest mistake of all.

Werner: just test David's patch (do *not* change both the error value
*and* apply David's patch - that would free the task-struct twice). I
don't think his patch is what I want to apply eventually, but it
should fix the issue.

Sadly, I don't think we have anybody who really "owns"
kernel/profile.c - the thing is broken, it was misdesigned, and nobody
really cares. Which is why we'll probably have to fix this by just
making that Android thing return NOTIFY_DONE, and just accept that the
whole thing is a f*cking joke.

                         Linus
