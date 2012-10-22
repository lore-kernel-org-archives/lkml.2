Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab2JVTvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:51:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab2JVTvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:51:04 -0400
Date: Mon, 22 Oct 2012 12:51:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qing Z <njumical@gmail.com>
Cc: mingo@kernel.org, ben@decadent.org.uk, markivx@codeaurora.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, cxie4@marvell.com,
        binw@marvell.com, wwang27@marvell.com, xjian@marvell.com,
        zhangwm@marvell.com, Qing Zhu <qzhu@marvell.com>
Subject: Re: [PATCH] panic: fix incomplete panic log in panic()
Message-Id: <20121022125103.59a655b7.akpm@linux-foundation.org>
In-Reply-To: <CAE-am1NxHZ2aGrcwPYxdSXwB-59bf2q9uMwS8gA=Fg9w6LVxFA@mail.gmail.com>
References: <BD54883EA7DE8B41A61B7E723561C711139F75D348@sc-vexch3.marvell.com>
	<CAE-am1NFB+opbid_f7RA_9EXUKjPCJssdOcZBrEQmQHG4EP9Gg@mail.gmail.com>
	<20121015150204.6f837a39.akpm@linux-foundation.org>
	<CAE-am1OY8Tjv6a004-NfhEe1DXTGcFC6ogVAmtVdESW8sZ_R4w@mail.gmail.com>
	<20121017170654.638e20bf.akpm@linux-foundation.org>
	<CAE-am1NxHZ2aGrcwPYxdSXwB-59bf2q9uMwS8gA=Fg9w6LVxFA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012 22:54:54 +0800
Qing Z <njumical@gmail.com> wrote:

> Hi Andrew,
>           Basically, console_unlock() should be called to make panic
> log printed.  Call console_unlock() in panic have some risks when
> recurse in it(are there other bad cases?). The condition is very rare
> and the two issue cases I list always happen between console_lock()
> and console_unlock(). So I think we need to couple with
> console_lock(), but should avoid the case that panic happen in
> console_unlock().  I think it is a more modest and safe way.  Please
> corect me if there is something wrong. Thanks!
> 
> bool Is_in_console_unlock;
> void console_unlock(void)
> {
>        ...
> +      Is_in_console_unlock = ture;
>         /* flush buffered message fragment immediately to console */
>         console_cont_flush(text, sizeof(text));
> again:
>         for (;;) {
>         ....
>  +       Is_in_console_unlock = false;
> }
> 
> void panic(const char *fmt, ...)
> {
>         ....
> +      /*
> +       * we should unlock console here to make oops log printed, in case
> +       * console is locked before panic in this cpu, or other cpus lock the
> +       * console before be stopped.
> +       */
> +      if( unlikely(console_locked) && !Is_in_console_unlock )
> +           {
> +                  console_unlock();
> +                  console_locked = 0;
> +            }
> 
>         /*
>          * Note smp_send_stop is the usual smp shutdown function, which
>          * unfortunately means it may not be hardened to work in a panic
>          * situation.
>          */
>         smp_send_stop();
> 
>         ....
> }

Well, if something like that will solve the problem then yes, I guess
that is the way to go.  It's not pretty, but it is clear and direct,
and this isn't a pretty problem!

But is this approach sufficient?  What happens in the case of an oops
or a BUG() inside console_lock()?

