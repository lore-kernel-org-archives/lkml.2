Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab0JELFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:05:38 -0400
Received: from smtp.nokia.com ([192.100.122.230]:62812 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab0JELFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:05:37 -0400
Subject: Re: [PATCH 1/1] wait: using uninitialized member of wait queue
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: ext =?UTF-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu,
        gregkh@suse.de, a.p.zijlstra@chello.nl, xiaosuo@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <op.vj3mn1fl7p4s8u@pikus>
References: <cover.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
	 <dfd3348b7971bee89360efb85f8d622e6574b003.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
	 <op.vj3mn1fl7p4s8u@pikus>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 15:00:38 +0400
Message-ID: <1286276438.24366.42.camel@ekuznets-lx-nokia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 05 Oct 2010 11:04:13.0141 (UTC) FILETIME=[0B2D7850:01CB647D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

'wait_queue_t' is passed to prepare_to_wait() function where 'flags' is
used, e.g:
File: /mm/mempool.c
void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
{       .....
         .....
	init_wait(&wait);
	prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
	.....
}

Best Regards,
Evgeny

On Tue, 2010-10-05 at 12:41 +0200, ext Michał Nazarewicz wrote:
> On Tue, 05 Oct 2010 10:47:57 +0200, Evgeny Kuznetsov
> <EXT-Eugeny.Kuznetsov@nokia.com> wrote:
> > Member "flags" of "wait_queue_t" struct  is used in several places
> in
> > kernel code without beeing initialized. "flags" is used in bitwise
> operations.
>                        ^^^^^^ -- "being"
> 
> > If "flags" not initialized then unexpected behaviour may have place.
> > Incorrect flags maybe used later in code.
> > Struct "wait_queue_t" is initialized in function "init_wait()". But
> > "init_wait()" do not initialize "flag" member.
>                  ^^ -- does         ^^^^ -- "flags"
> 
> > Added initialization of "wait_queue_t.flags" with zero value into
> "init_wait".
> 
> > diff --git a/include/linux/wait.h b/include/linux/wait.h
> > index 0836ccc..3efc9f3 100644
> > --- a/include/linux/wait.h
> > +++ b/include/linux/wait.h
> > @@ -614,6 +614,7 @@ int wake_bit_function(wait_queue_t *wait,
> unsigned mode, int sync, void *key);
> >               (wait)->private =
> current;                              \
> >               (wait)->func =
> autoremove_wake_function;                \
> >               INIT_LIST_HEAD(&(wait)->task_list);                     \
> > +             (wait)->flags =
> 0;                                      \
> >       } while (0)
> > /**
> 
> I'd turn init_wait() into a static inline.  Otherwise looks good to
> me.
> (Interestingly, init_wait() is used only in 3 places in the kernel and
> none uses flags.)
> 
> -- 
> Best regards,                                        _     _
> | Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
> | Computer Science,  Michał "mina86" Nazarewicz       (o o)
> +----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo-- 

