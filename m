Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1IEOgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 10:36:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47803 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab1IEOgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 10:36:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110905103925.GC5466@quack.suse.cz>
References: <1314892622-18267-1-git-send-email-consul.kautuk@gmail.com>
	<20110901143333.51baf4ae.akpm@linux-foundation.org>
	<CAFPAmTQbdhNgFNoP0RyS0E9Gm4djA-W_4JWwpWZ7U=XnTKR+cg@mail.gmail.com>
	<20110902112133.GD12182@quack.suse.cz>
	<CAFPAmTSh-WWJjtuNjZsdEcaK-zSf8CvBmrRGFTmd_HZQNAKUCw@mail.gmail.com>
	<CAFPAmTTJQddd-vHjCpvyfsHhursRXBwNzF4zoVHL3=ggztE8Qg@mail.gmail.com>
	<20110902151450.GF12182@quack.suse.cz>
	<CAFPAmTQxBK32zutyiX9DJLS2F+z6jxsV71xOwa0sivxSY5MD1Q@mail.gmail.com>
	<20110905103925.GC5466@quack.suse.cz>
Date: Mon, 5 Sep 2011 20:06:04 +0530
Message-ID: <CAFPAmTR5f_GW_oha07Bf0_LNXhigZri_w2N_XTEqM+X+-Ae-Rw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/backing-dev.c: Call del_timer_sync instead of del_timer
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dave Chinner <dchinner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>  OK, I don't care much whether we have there del_timer() or
> del_timer_sync(). Let me just say that the race you are afraid of is
> probably not going to happen in practice so I'm not sure it's valid to be
> afraid of CPU cycles being burned needlessly. The timer is armed when an
> dirty inode is first attached to default bdi's dirty list. Then the default
> bdi flusher thread would have to be woken up so that following happens:
>        CPU1                            CPU2
>  timer fires -> wakeup_timer_fn()
>                                        bdi_forker_thread()
>                                          del_timer(&me->wakeup_timer);
>                                          wb_do_writeback(me, 0);
>                                          ...
>                                          set_current_state(TASK_INTERRUPTIBLE);
>  wake_up_process(default_backing_dev_info.wb.task);
>
>  Especially wb_do_writeback() is going to take a long time so just that
> single thing makes the race unlikely. Given del_timer_sync() is slightly
> more costly than del_timer() even for unarmed timer, it is questionable
> whether (chance race happens * CPU spent in extra loop) > (extra CPU spent
> in del_timer_sync() * frequency that code is executed in
> bdi_forker_thread())...
>

Ok, so this means that we can compare the following 2 paths of code:
i)   One extra iteration of the bdi_forker_thread loop, versus
ii)  The amount of time it takes for the del_timer_sync to wait till
the timer_fn
     on the other CPU finishes executing + schedule resulting in a
guaranteed sleep.

Considering both situations to be a race till the tasks are ejected
from the runqueue
(i.e., sleep), I think ii) should be a better option, don't you think ?
Scenario i)  will result in execution of the entire schedule()
function once without
resulting in the "sleep" of the task. Also, if another task schedules,
it could take a
lot of CPU cycles before we return to this (bdi-default) task.
Scenario ii) will result only in the execution of a couple of more
iterations of the
del_timer_sync loop which will quickly respond to completion of
timer_fn on other CPU
and lead to removal of current task as per the call to schedule with
guaranteed sleep.

Is my reasoning correct/adequate ?

I know that the bdi_forker_thread anyways doesn't do much on its own,
but I'm just
understanding your expert opinion(s) on this aspect of the kernel code. :)
