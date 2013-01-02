Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab3ABJfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 04:35:12 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:63806 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab3ABJfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 04:35:10 -0500
Message-ID: <50E3FDFA.4070203@suse.cz>
Date: Wed, 02 Jan 2013 10:29:30 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Ivo Sieben <meltedpianoman@gmail.com>
CC: linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] tty: Only wakeup the line discipline idle queue when
 queue is active
References: <1355842130-15482-1-git-send-email-meltedpianoman@gmail.com>
In-Reply-To: <1355842130-15482-1-git-send-email-meltedpianoman@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 03:48 PM, Ivo Sieben wrote:
> Before waking up the tty line discipline idle queue first check if the queue is
> active (non empty). This prevents unnecessary entering the critical section in
> the wake_up() function and therefore avoid needless scheduling overhead on a
> PREEMPT_RT system caused by two processes being in the same critical section.
> 
> Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
> ---
> 
>  Remark:
>  This patch has kind of a long history... I first tried to prevent the critical
>  section in the wakeup() function itself by a change in the scheduler. But after
>  review remarks from Oleg Nesterov it turned out that using the
>  waitqueue_active() was a much nicer way to prevent it. See also
>  https://lkml.org/lkml/2012/10/25/159
> 
>  drivers/tty/tty_ldisc.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
> index c578229..e96d187 100644
> --- a/drivers/tty/tty_ldisc.c
> +++ b/drivers/tty/tty_ldisc.c
> @@ -64,7 +64,9 @@ static void put_ldisc(struct tty_ldisc *ld)
>  		return;
>  	}
>  	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
> -	wake_up(&ld->wq_idle);
> +
> +	if (waitqueue_active(&ld->wq_idle))
> +		wake_up(&ld->wq_idle);

Looks good, but I would prefer the layer to provide us with
wake_up_if_active...

-- 
js
suse labs
