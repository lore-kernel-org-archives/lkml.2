Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab1IZIBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:01:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36165 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1IZIBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:01:21 -0400
Subject: Re: [PATCH 3/3] [RFC] ipc/sem.c: replace busy loop with completion
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>
Date: Mon, 26 Sep 2011 10:00:49 +0200
In-Reply-To: <1316885838-12026-1-git-send-email-manfred@colorfullife.com>
References: <1316885838-12026-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317024050.9084.62.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-09-24 at 19:37 +0200, Manfred Spraul wrote:

	sma = sem_lock(ns, semid);

> @@ -1456,8 +1414,17 @@ sleep_again:
>         /*
>          * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
>          */
> -       error = get_queue_result(&queue);
> -
> +       error = queue.status;
> +       if (error != -EINTR) {
> +               /* If there is a return code, then we can leave immediately. */
> +               if (!IS_ERR(sma)) {
> +                       sem_unlock(sma);
> +               }
> +               /* Except that we must wait for the hands-off */
> +               wait_for_completion(&queue.done);
> +               goto out_free;

		you just lost a sem_unlock() in the IS_ERR() case.

> +       } 
