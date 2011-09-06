Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab1IFXAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 19:00:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754851Ab1IFXAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 19:00:09 -0400
Date: Tue, 6 Sep 2011 15:59:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org, perex@perex.cz,
        tiwai@suse.de
Subject: Re: [PATCH] sound: Fix race condition in the pcm_lib
 "wait for space loop
Message-Id: <20110906155954.bb9c42eb.akpm@linux-foundation.org>
In-Reply-To: <20110905094947.6ece87c2@infradead.org>
References: <20110905094947.6ece87c2@infradead.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Sep 2011 09:49:47 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> >From 2e37f0a4b2289962e1a45d8e02f8a7f7adad619f Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Mon, 5 Sep 2011 09:40:18 -0700
> Subject: [PATCH] sound: Fix race condition in the pcm_lib "wait for space" loop
> 
> The wait_for_avail() function in pcm_lib.c has a race in it (observed in
> practice by an Intel validation group).
> 
> The function is supposed to return once space in the buffer has become
> available, or if some timeout happens.  The entity that creates space (irq
> handler of sound driver and some such) will do a wake up on a waitqueue that
> this function registers for.
> 
> However there are two races in the existing code
> 1) If space became available between the caller noticing there was no space and
>    this function actually sleeping, the wakeup is missed and the timeout
>    condition will happen instead
> 2) If a wakeup happened but not sufficient space became available, the code will loop
>    again and wait for more space. However, if the second wake comes in prior
>    to hitting the schedule_timeout_interruptible(), it will be missed, and
>    potentially you'll wait out until the timeout happens.
> 
> The fix consists of using more careful setting of the current state (so that
> if a wakeup happens in the main loop window, the schedule_timeout() falls
> through) and by checking for available space prior to going into the
> schedule_timeout() loop, but after being on the waitqueue and having the
> state set to interruptible.
> 
> ...
>
> --- a/sound/core/pcm_lib.c
> +++ b/sound/core/pcm_lib.c
> @@ -1761,6 +1761,10 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
>  	snd_pcm_uframes_t avail = 0;
>  	long wait_time, tout;
>  
> +	init_waitqueue_entry(&wait, current);
> +	add_wait_queue(&runtime->tsleep, &wait);
> +	set_current_state(TASK_INTERRUPTIBLE);

Well, this isn't very good either.  if a wakeup gets delivered to
runtime->tsleep before the set_current_state(), this process will go
ahead and incorrectly set itself into TASK_INTERRUPTIBLE state.

That looks like it will be dont-care/cant-happen in this case, but it's
setting a bad example.


