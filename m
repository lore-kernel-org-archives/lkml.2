Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab0HXQfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:35:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642Ab0HXQfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:35:37 -0400
Date: Tue, 24 Aug 2010 18:31:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: [RFC PATCH 1/3] timer: fix comments of try_to_del_timer_sync()
Message-ID: <20100824163149.GA7415@redhat.com>
References: <1282633129-9187-1-git-send-email-yong.zhang0@gmail.com> <1282633129-9187-2-git-send-email-yong.zhang0@gmail.com> <20100824121109.GA13061@redhat.com> <20100824124958.GA3070@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824124958.GA3070@zhy>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, Yong Zhang wrote:
>
> On Tue, Aug 24, 2010 at 02:11:09PM +0200, Oleg Nesterov wrote:
> > On 08/24, Yong Zhang wrote:
> > >
> > > From: Yong Zhang <yong.zhang@windriver.com>
> > >
> > > In commit fd450b7318b75343fd76b3d95416853e34e72c95, it was saying
> > > try_to_del_timer_sync() can be used in interrupt context.
> >
> > Yes, but not in UP case.
>
> Yeah, but in UP case there is no try_to_del_timer_sync(), it's redefined
> to del_timer().

Ah, indeed, I forgot. This was another reason for the comment.

> > Please remove "#ifdef CONFIG_SMP" from set_running_timer(), then iirc
> > it can be used from irq.
>
> I have noticed your comments in the commit log, but I think it's about
> introducing the same semantic of try_to_del_timer_sync() on UP as well
> as SMP. But this patch is focusing on the current code(SMP special).
> Not about realizing try_to_del_timer_sync() on UP case. Do we need
> to do that?

I dunno.

But look, currently try_to_del_timer_sync() is not allowed from interrupt
even if it works with CONFIG_SMP.

If we "officially" allow it to use from irq, it should work on UP too but
it doesn't. del_timer() can't hang, but it can never return -1 to indicate
we hit the running timer.

Consider:

	// runs in interrup context

	if (try_do_del_timer_sync(&TIMER) > 0)
		kfree(something_which_can_be_used_by_TIMER_func);		

This is unsafe on UP.


del_timer_sync == del_timer is fine on UP. Since it must not be called
from irq, it can never hit the running timer.

Oleg.

