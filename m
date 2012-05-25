Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2EYJXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:23:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51201 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2EYJXi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:23:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120524155121.20241.68413.stgit@bob.linux.org.uk>
References: <20120524155121.20241.68413.stgit@bob.linux.org.uk>
Date: Fri, 25 May 2012 17:23:38 +0800
Message-ID: <CACVXFVO2bwuPXTzUvY2Vkq9SsF=zqdfV+p-OQjSFL04nBmzywg@mail.gmail.com>
Subject: Re: [PATCH] tty: fix ldisc lock inversion trace
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:51 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> From: Alan Cox <alan@linux.intel.com>
>
> This is caused by tty_release using tty_lock_pair to lock both
> sides of the pty/tty pair, and then tty_ldisc_release dropping
> and relocking one side only. We can drop both fine, so drop both
> to avoid any lock ordering concerns.
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>
>  drivers/tty/tty_ldisc.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>
>
> diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
> index 173a900..833e851 100644
> --- a/drivers/tty/tty_ldisc.c
> +++ b/drivers/tty/tty_ldisc.c
> @@ -912,10 +912,13 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
>         * race with the set_ldisc code path.
>         */
>
> -       tty_unlock(tty);
> +       /* We don't give a monkeys' about the o_tty lock here but we
> +          must do both to avoid lock inversions against another single
> +          locking case */
> +       tty_unlock_pair(tty, o_tty);
>        tty_ldisc_halt(tty);
>        tty_ldisc_flush_works(tty);
> -       tty_lock(tty);
> +       tty_lock_pair(tty, o_tty);

This still may cause lockdep warning by the following line:

             if (o_tty)
                    tty_ldisc_release(o_tty, NULL);

The tty_unlock_pair in 'tty_ldisc_release(o_tty, NULL)'  may
not match the previous tty_lock_pair. If tty > o_tty, then lockdep
warning will be triggered since the lock to be released is not
at the top of current lock stack.

Thanks,
-- 
Ming Lei
