Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab2DIXZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 19:25:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64238 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758151Ab2DIXZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 19:25:56 -0400
Date: Mon, 9 Apr 2012 16:25:52 -0700 (PDT)
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
In-Reply-To: <CA+55aFztPW2x1grh2Z7RTOxKZ29_Ha6-kDkJXgdghFHQ61EZOQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1204091603430.21813@chino.kir.corp.google.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com> <20120408195044.13ea6c8e.akpm@linux-foundation.org> <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com> <alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com>
 <CA+55aFxUQJC+_aA0qnj0b-LoGfCjfFoG3HXgQ+7LND7y8dFDhw@mail.gmail.com> <alpine.DEB.2.00.1204091355280.10873@chino.kir.corp.google.com> <CA+55aFztPW2x1grh2Z7RTOxKZ29_Ha6-kDkJXgdghFHQ61EZOQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-1665819623-1334013033=:21813"
Content-ID: <alpine.DEB.2.00.1204091610450.21813@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-1665819623-1334013033=:21813
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1204091610451.21813@chino.kir.corp.google.com>

On Mon, 9 Apr 2012, Linus Torvalds wrote:

> > Right, we can't handoff the freeing of the task_struct to more than one
> > notifier.  It seems misdesigned from the beginning and what we really want
> > is to hijack task->usage for __put_task_struct(task) if we have such a
> > notifier callchain and require each one (currently just oprofile) to take
> > a reference on task->usage for NOTIFY_OK and then be responsible for
> > dropping the reference when it's done with it later instead of requiring
> > it to free the task_struct itself.
> 
> We could make notifier.c just "or" all the return values together, and
> then it's ok if *one* person returns NOTIFY_OK.
> 

You could that if you also turned the check for "ret == NOTIFY_OK" in 
profile_handoff_task() into "ret & NOTIFY_OK" in your patch, otherwise you 
get a double free from __put_task_struct() and oprofile.

> Of course, that's not how notifiers are documented to work, but quite
> frankly, notifiers with non-zero values that don't sat STOP are broken
> as-is anyway, so you might we well do a logical "or" of the return
> values and at least make things like this work.
> 

It works fine if the callbacks are correctly implemented, it's just that 
the task handoff in kernel/profile.c is broken because it assumes only one 
callback will return NOTIFY_OK, meaning it will eventually free, and its 
only checking the return value of the last notifier called to see if 
__put_task_struct() should immediately free.

In defense of notifiers, though, it works fine right now for memory 
hotplug.  The last issue I had with it was when slab lacked a callback 
when a node was onlined or offlined in 2.6.34 and then I added memory 
hotplug support for that allocator and it has since worked fine.  For 
things like MEM_GOING_OFFLINE, returning NOTIFY_BAD is great if the 
subsystem of interest can't allow the memory to go offline (in-use slab 
objects, for example).  In the memory hotplug usecase, we certainly don't 
want to stop at NOTIFY_OK because we need to notify every subsystem on the 
callchain.

> Oh well. So my suggestion right now would be something like the
> attached. It's still horribly broken, it actively breaks documented
> notifier behavior, but dammit, if the notifier people don't like
> 'or'ing return values together they should damn well return zero from
> the notifier that doesn't do anything. And returning an error will
> exit out, so..
> 

Instead of this and it's possible bad interactions with other notifiers 
during the -rc cycle, I think it would be better to

 (1)  fix the lowmemorykiller so it doesn't need to use these notifiers at 
      all, which isn't difficult, for 3.4, then

 (2a) change the task handoff to a refcount on task->usage after the final
      put_task_struct() using the notifier and then allow it to be freed 
      after everybody does a put_handoff_task_struct() for 3.5

	or

 (2b) remove the task handoff notifier callchain entirely and just tie it
      directly to oprofile since android won't be using it anymore after 
      (1).
--397155492-1665819623-1334013033=:21813--
