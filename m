Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab2LARaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 12:30:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37875 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab2LARaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 12:30:01 -0500
MIME-Version: 1.0
In-Reply-To: <1354103571-27394-2-git-send-email-rabin.vincent@stericsson.com>
References: <1354103571-27394-1-git-send-email-rabin.vincent@stericsson.com>
	<1354103571-27394-2-git-send-email-rabin.vincent@stericsson.com>
Date: Sat, 1 Dec 2012 18:30:00 +0100
Message-ID: <CACRpkdYQ8SWKR0ZrT4oHNT-0yuTuR0dCCMLDSR6NxDD5MhcCpw@mail.gmail.com>
Subject: Re: [RFC 2/2] clk: per-user clock accounting for debug
From: Linus Walleij <linus.walleij@linaro.org>
To: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Mike Turquette <mturquette@ti.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 12:52 PM, Rabin Vincent
<rabin.vincent@stericsson.com> wrote:

> When a clock has multiple users, the WARNING on imbalance of
> enable/disable may not show the guilty party since although they may
> have commited the error earlier, the warning is emitted later when some
> other user, presumably innocent, disables the clock.
>
> Provide per-user clock enable/disable accounting and disabler tracking
> in order to help debug these problems.
>
> NOTE: with this patch, clk_get_parent() behaves like clk_get(), i.e. it
> needs to be matched with a clk_put().  Otherwise, memory will leak.
>
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>

Overall this looks very helpful.

> @@ -504,7 +525,15 @@ void clk_disable(struct clk *clk_user)
>         unsigned long flags;
>
>         spin_lock_irqsave(&enable_lock, flags);
> -       __clk_disable(clk);
> +       if (!WARN(clk_user->enable_count == 0,
> +                 "incorrect disable clk dev %s con %s last disabler %pF\n",
> +                 clk_user->dev_id, clk_user->con_id, clk_user->last_disable)) {
> +
> +               clk_user->last_disable = __builtin_return_address(0);
> +               clk_user->enable_count--;
> +
> +               __clk_disable(clk);
> +       }

It seems as if an unbalanced clk_disable() call is done before any
clk_enable() call something like:

"incorrect disable clk dev foo con bar last disabler (null)"

Then the second WARN() will be triggered in __clk_disable().

Have you tried this usecase?

Maybe we can avoid the confusing warning, I don't know.
No big deal maybe.

Apart from that:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
