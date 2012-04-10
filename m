Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab2DJAEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:04:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53751 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2DJAEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:04:04 -0400
Date: Mon, 9 Apr 2012 17:04:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1
 sticks-and-crashs)
In-Reply-To: <CA+55aFwa40cv_TYdU3dKHPPJQo2omLpi8y6k6KBhJ5uP12f29A@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1204091657250.21813@chino.kir.corp.google.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com> <20120408195044.13ea6c8e.akpm@linux-foundation.org> <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com> <alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com>
 <CA+55aFxUQJC+_aA0qnj0b-LoGfCjfFoG3HXgQ+7LND7y8dFDhw@mail.gmail.com> <alpine.DEB.2.00.1204091355280.10873@chino.kir.corp.google.com> <CA+55aFztPW2x1grh2Z7RTOxKZ29_Ha6-kDkJXgdghFHQ61EZOQ@mail.gmail.com> <alpine.DEB.2.00.1204091603430.21813@chino.kir.corp.google.com>
 <CA+55aFwa40cv_TYdU3dKHPPJQo2omLpi8y6k6KBhJ5uP12f29A@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-807357491-1334016243=:21813"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-807357491-1334016243=:21813
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 9 Apr 2012, Linus Torvalds wrote:

> > You could that if you also turned the check for "ret == NOTIFY_OK" in
> > profile_handoff_task() into "ret & NOTIFY_OK" in your patch, otherwise you
> > get a double free from __put_task_struct() and oprofile.
> 
> Why? NOTIFY_DONE is zero.
> 

Oops, right.

> >  (1)  fix the lowmemorykiller so it doesn't need to use these notifiers at
> >      all, which isn't difficult, for 3.4, then
> 
> I do think that that makes sense. Fixing people to not use notifiers
> is always a good idea. Why would anybody sane even care about the
> process going away anyway? If some lowmemorykiller decides to kill off
> a process that no longer exists, kill() should happily return ENOSRCH,
> and we're all good
> 

It's apparently waiting for a killed thread to exit before selecting 
another victim or the one second timeout expires.  (And you only get to 
prevent needless kills if you have CONFIG_PROFILING, otherwise it doesn't 
care.)

> At the same time, the *only* user of that stupid handoff thing is
> oprofile, afaik, and if we use a refcount, why the hell doesn't
> oprofile just use a refcount to begin with, instead of using that
> notifier?: IOW, *both* users of the notifier seem to be just retarded.
> 

Agreed and since the current implementation relies on CONFIG_PROFILING I 
think it's safe to remove the notifier and add a hook only for oprofile so 
it can do free_task() when it wants to.  No refcounting required.

I've already proposed a patch that removes the notifier for 
lowmemorykiller with the added benefit that it doesn't rely on 
CONFIG_PROFILING at all.  If that's merged for 3.4, I'll remove the task 
handoff callchain entirely for 3.5 since oprofile is the only user.
--397155492-807357491-1334016243=:21813--
