Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab0JLK1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 06:27:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:44089 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab0JLK1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 06:27:20 -0400
Subject: Re: [PATCH 1/2] lockdep: check the depth of subclass
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Dmitry Torokhov <dtor@mail.ru>,
        Vojtech Pavlik <vojtech@ucw.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1286269311-28336-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1286269311-28336-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Oct 2010 12:27:01 +0200
Message-ID: <1286879221.29097.39.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 18:01 +0900, Hitoshi Mitake wrote:
> Current look_up_lock_class() doesn't check the parameter "subclass".
> This rarely rises problems because the main caller of this function,
> register_lock_class(), checks it.
> But register_lock_class() is not the only function which calls
> look_up_lock_class(). lock_set_class() and its callees also call it.
> And lock_set_class() doesn't check this parameter.
> 
> This will rise problems when the the value of subclass is larger
> MAX_LOCKDEP_SUBCLASSES. Because the address (used as the key of class)
> caliculated with too large subclass has a possibility to point
> another key in different lock_class_key.
> Of course this problem depends on the memory layout and
> occurs with really low possibility.
> 
> And mousedev_create() calles lockdep_set_subclass() and
> sets class of mousedev->mutex as MOUSEDEV_MIX(== 31).
> And if my understanding is correct,
> this subclass doesn't have to be MOUSEDEV_MIX,
> so I modified this value to SINGLE_DEPTH_NESTING.
> 
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Cc: Vojtech Pavlik <vojtech@ucw.cz>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  drivers/input/mousedev.c |    2 +-
>  kernel/lockdep.c         |   15 +++++++++++++++
>  2 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
> index d528a2d..9897334 100644
> --- a/drivers/input/mousedev.c
> +++ b/drivers/input/mousedev.c
> @@ -866,7 +866,7 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
>  	spin_lock_init(&mousedev->client_lock);
>  	mutex_init(&mousedev->mutex);
>  	lockdep_set_subclass(&mousedev->mutex,
> -			     minor == MOUSEDEV_MIX ? MOUSEDEV_MIX : 0);
> +			     minor == MOUSEDEV_MIX ? SINGLE_DEPTH_NESTING : 0);

Ah good find.

>  	init_waitqueue_head(&mousedev->wait);
>  
>  	if (minor == MOUSEDEV_MIX)
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 84baa71..c4c13ae 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -639,6 +639,21 @@ look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
>  	}
>  #endif
>  
> +	if (unlikely(subclass >= MAX_LOCKDEP_SUBCLASSES)) {
> +		/*
> +		 * This check should be done not only in __lock_acquire()
> +		 * but also here. Because register_lock_class() is also called
> +		 * by lock_set_class(). Callers of lock_set_class() can
> +		 * pass invalid value as subclass.
> +		 */
> +
> +		debug_locks_off();
> +		printk(KERN_ERR "BUG: looking up invalid subclass: %u\n", subclass);
> +		printk(KERN_ERR "turning off the locking correctness validator.\n");
> +		dump_stack();
> +		return NULL;
> +	}

Would we catch all cases if we moved this check from __lock_acquire()
into register_lock_class()? It would result in only a single instance of
this logic.


>  	/*
>  	 * Static locks do not have their class-keys yet - for them the key
>  	 * is the lock object itself:

