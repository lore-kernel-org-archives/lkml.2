Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab1BGG3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 01:29:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49086 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab1BGG3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 01:29:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q/lII8G/bI47d8fU1ikJC5E5UGAWsqaq8u5a9rePwnlAmJwh+jS+kNwjv70MMxJFT/
         5O39gjr4R4VXSNaKzXUqZDU+Tvo9ALIVSpDhBslEjo/6VackjV6N07IN3xteqt/KJYOO
         fblsiKSDGyhmWNpZaLtAQx39lOPWM1ngQXQ7k=
MIME-Version: 1.0
In-Reply-To: <1297058877.800990.238556019385.3.gpush@pororo>
References: <201102011711.31258.jeremy.kerr@canonical.com>
	<1297058877.800990.238556019385.3.gpush@pororo>
Date: Mon, 7 Feb 2011 15:29:13 +0900
Message-ID: <AANLkTinq=HieqGUFthm04F21RuLijg2mZH+eoan9p5HN@mail.gmail.com>
Subject: Re: [RFC, PATCH 3/3] clk: add warnings for incorrect enable/prepare semantics
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 3:07 PM, Jeremy Kerr <jeremy.kerr@canonical.com> wrote:
> This change adds warnings to check for:
>
>  1) enabling a clock that hasn't been prepared; and
>
>  2) unpreparing a clock that is still enabled
>
> While the correctness can't be guaranteed, these warnings should cover
> most situations.
>
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
>
> ---
>  drivers/clk/clk.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 51dbd33..2369959 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -35,6 +35,8 @@ void clk_unprepare(struct clk *clk)
>        if (!clk->ops->unprepare)
>                return;
>
> +       WARN_ON(clk->enable_count);
> +
>        mutex_lock(&clk->prepare_lock);
>        if (--clk->prepare_count == 0)
>                clk->ops->unprepare(clk);
> @@ -50,6 +52,8 @@ int clk_enable(struct clk *clk)
>        if (!clk->ops->enable)
>                return 0;
>
> +       WARN_ON(clk->ops->prepare && clk->prepare_count);
> +

Shouldn't the prepare_count be checked against 0 ?
