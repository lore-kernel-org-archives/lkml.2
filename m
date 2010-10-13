Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab0JMHeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 03:34:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:39850 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab0JMHeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 03:34:07 -0400
Subject: Re: [PATCH 1/2] lockdep: check the depth of subclass
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Dmitry Torokhov <dtor@mail.ru>,
        Vojtech Pavlik <vojtech@ucw.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4CB518CD.1010607@dcl.info.waseda.ac.jp>
References: <1286269311-28336-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1286879221.29097.39.camel@twins>  <4CB518CD.1010607@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Oct 2010 09:33:53 +0200
Message-ID: <1286955233.29097.68.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 11:26 +0900, Hitoshi Mitake wrote:
>  >> @@ -639,6 +639,21 @@ look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
>  >>     }
>  >>   #endif
>  >>
>  >> +   if (unlikely(subclass>= MAX_LOCKDEP_SUBCLASSES)) {
>  >> +           /*
>  >> +            * This check should be done not only in __lock_acquire()
>  >> +            * but also here. Because register_lock_class() is also called
>  >> +            * by lock_set_class(). Callers of lock_set_class() can
>  >> +            * pass invalid value as subclass.
>  >> +            */
>  >> +
>  >> +           debug_locks_off();
>  >> +           printk(KERN_ERR "BUG: looking up invalid subclass: %u\n", subclass);
>  >> +           printk(KERN_ERR "turning off the locking correctness validator.\n");
>  >> +           dump_stack();
>  >> +           return NULL;
>  >> +   }
>  >
>  > Would we catch all cases if we moved this check from __lock_acquire()
>  > into register_lock_class()? It would result in only a single instance of
>  > this logic.
>  >
> 
> I think that __lock_acquire() should also check the value of subclass.
> Because it access to the lock->class_cache as array
> before calling look_up_lock_class() after applying this patch.
> 
> So if the check isn't done in __lock_acquire(),
> the invalid addresses might be interpreted as the addresses of
> struct lock_class. 


But __lock_acquire() does:

  if (subclass < NR_LOCKDEP_CACHING_CLASSES)
    class = lock->class_cache[subclass];

  if (!class)
    class = register_lock_class();

So by moving the: subclass >= MAX_LOCKDEP_SUBCLASSES, check into
register_lock_class() it would still trigger for __lock_acquire().
Because NR_LOCKDEP_CACHING_CLASSES <= MAX_LOCKDEP_SUBCLASSES, and thus
for subclass >= MAX_LOCKDEP_SUBCLASSES we'll always call into
register_lock_class() and trigger the failure there, no?


