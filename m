Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab2BWNhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 08:37:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59652 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab2BWNhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 08:37:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] i.MX31: mxc-rnga: implement waiting for data in driver
Date: Thu, 23 Feb 2012 13:37:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Michael Thalmeier <michael.thalmeier@hale.at>,
        Fabio Estevam <festevam@gmail.com>, michael@thalmeier.at,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>
References: <1329826410-21739-1-git-send-email-michael.thalmeier@hale.at> <CAOMZO5BGVa0HRKqv9nKQUy9iGnQ3FV_6OnguMyk3rAinaJkb6w@mail.gmail.com> <4F43AC8D.5090508@hale.at>
In-Reply-To: <4F43AC8D.5090508@hale.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202231337.20052.arnd@arndb.de>
X-Provags-ID: V02:K0:qbCr/PIsJQt3057e7nCJTz4FsQLiExyuDEBabKEdQBe
 /5OKU/lKY1GcQY9KvohSPKBFhaeBWxkx9Vzm8pE3vSFoVLetIy
 TCEt259XISjG5NmfJy9vVmLqvHaZl5AWgHihgPnX/i+efLIwuV
 nO/RQGjC2hZ7IjJj1H4zT17YTegRHWfM+xU8blLaj5y6GHFTLL
 NIhurDLT4VH/JxFq9nIGAzUyNSUVptK0aLsFQWO/QQPeIT0vIx
 Vj+nXov3VEfN+1ikt7zotkGqmc0hpJPbqpZnOw/Bo+qcBbs3ip
 455yyAAaXS8K8kqjUCuL0fMN6ZasR28+rdcBKAIcb/rTrhU8tv
 3CRAtPGxJIgjCJEcpy0Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 February 2012, Michael Thalmeier wrote:
> On 2012-02-21 14:29, Fabio Estevam wrote:
> 
> > On Tue, Feb 21, 2012 at 10:13 AM, Michael Thalmeier
> > <michael.thalmeier@hale.at> wrote:
> > 
> >> -static int mxc_rnga_data_present(struct hwrng *rng)
> >> +static int mxc_rnga_data_present(struct hwrng *rng, int wait)
> > 
> > This looks good, but ...
> > 
> >>  {
> >> -       int level;
> >> +       int level, i;
> >>        void __iomem *rng_base = (void __iomem *)rng->priv;
> >>
> >> -       /* how many random numbers is in FIFO? [0-16] */
> >> -       level = ((__raw_readl(rng_base + RNGA_STATUS) &
> >> -                       RNGA_STATUS_LEVEL_MASK) >> 8);
> >> +       for (i = 0; i < 20; i++) {
> > 
> > Why the magic "20" here?
> > 
> > It would be better to add a proper timeout mechanism instead, such as
> > time_after(jiffies, timeout)
> > 
> I am absolutely with you.
> The point is only that this is the behaviour of nearly all hw_random
> drivers, and I basically just copied it over into this driver.

Hmm, I guess they are all wrong then ;-)

It would be nice to move the retry loop into common code where it
would be easier to change.

Note that comparing jiffies is not going to help here because the
maximum delay in the loop is less than a jiffy.

	Arnd
