Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966352Ab2EOWbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 18:31:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56738 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965977Ab2EOWbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 18:31:40 -0400
References: <1336798797-8724-1-git-send-email-skannan@codeaurora.org> <1337114622-11292-1-git-send-email-skannan@codeaurora.org>
User-Agent: K-9 Mail for Android
In-Reply-To: <1337114622-11292-1-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] clk: Fix CLK_SET_RATE_GATE flag validation in clk_set_rate().
From: Richard Zhao <richard.zhao@linaro.org>
Date: Wed, 16 May 2012 06:31:23 +0800
To: Saravana Kannan <skannan@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Message-ID: <258a747f-c7d8-4f15-8446-2c18fe21ccf3@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Saravana Kannan <skannan@codeaurora.org> wrote:

>The clk_set_rate() code shouldn't check the clock's enable count when
>validating CLK_SET_RATE_GATE flag since the enable count could change
>after
>the validation. Similar to clk_set_parent(), it should instead check
>the
>prepare count. The prepare count should go to zero only when the end
>user
>expects the clock to not be enabled in the future. Since the code
>already
>grabs the prepare count before validation, it's not possible for
>prepare
>count to change after validation and by association not possible for a
>well
>behaving end user to enable the clock while the set rate is in
>progress.
>
>Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
>---
>Please let me know if you don't want me to directly email or CC you in
>my
>clock related patches. I don't want to spam anyone. Also, let me know
>if
>you want me add you to my standard list of people to cc in my clock
>patches.
>
> drivers/clk/clk.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>index 09b9112..f5b9d3c 100644
>--- a/drivers/clk/clk.c
>+++ b/drivers/clk/clk.c
>@@ -903,7 +903,7 @@ int clk_set_rate(struct clk *clk, unsigned long
>rate)
> 	if (rate == clk->rate)
> 		goto out;
> 
>-	if ((clk->flags & CLK_SET_RATE_GATE) && __clk_is_enabled(clk)) {
>+	if ((clk->flags & CLK_SET_RATE_GATE) && clk->prepare_count) {
The condition becomes more strict. Looks good.

> 		ret = -EBUSY;
> 		goto out;
> 	}
>-- 
>1.7.8.3
>
>Sent by an employee of the Qualcomm Innovation Center, Inc.
>The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
>Forum.

