Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030591Ab2GLKut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:50:49 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:65157 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933641Ab2GLKur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:50:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120711234229.GF2772@gmail.com>
References: <1341439772-649-1-git-send-email-linus.walleij@linaro.org>
	<20120711234229.GF2772@gmail.com>
Date: Thu, 12 Jul 2012 12:50:46 +0200
Message-ID: <CACRpkdZOgquPF1FXo7LBeFOYhheqx+_ENTn6w4qcKGBqeHnvFQ@mail.gmail.com>
Subject: Re: [PATCH] clk: allow clocks without parents to change rate
From: Linus Walleij <linus.walleij@linaro.org>
To: Mike Turquette <mturquette@ti.com>, Pawel Moll <pawel.moll@arm.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Ulf Hansson <ulf.hansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 1:42 AM, Mike Turquette <mturquette@ti.com> wrote:

> This has been fixed in Pawell's patch, "clk: Check parent for NULL in
> clk_change_rate".

Yes, that'll probably work.

A small nitpick though:

I have slightly different semantics, Pawel's patch assigns zero if
parent is NULL, then use that as fallback, whereas I check for the
parent being NULL all the way. I was worried that the old sematics
could change like this:

So here it takes that:

+       if (clk->parent)
+               best_parent_rate = clk->parent->rate;
+

And I was cautious that if this changes the parent rate:

+               clk->ops->set_rate(clk->hw, clk->new_rate, best_parent_rate);

Then this passes the old parent rate to the recalc function:

+               clk->rate = clk->ops->recalc_rate(clk->hw, best_parent_rate);

It has no side-effects on my system but I worried about
others, so I just left the behaviour to re-read the rate from the parent
every time if possible.

Yours,
Linus Walleij
