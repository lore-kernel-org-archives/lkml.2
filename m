Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1ACKKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 05:10:35 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54655 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1ACKKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 05:10:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qrz75cLsVVAmFtu2853GBtgduLB3wtUjgraiRr7EccLWYpibhn3qXfCgzjAxGZl6+z
         IRW30ethUeZtX8OGUHGJdu7Vq7Ez1j+Yngnzylo6SY6qvYCSesta6NFQBnOQOHGUCKb0
         4ZmCzuVkydWGVRkoopv22AD1pbRak6lHW2FI8=
MIME-Version: 1.0
In-Reply-To: <14208EBD-49DC-4780-AC65-DF0A042DDBF9@marvell.com>
References: <AANLkTin7OYXzCYty8pDxyzE_Bg83=+L8jmcaoEMSf4QM@mail.gmail.com>
	<1294002510-2324-1-git-send-email-tardyp@gmail.com>
	<14208EBD-49DC-4780-AC65-DF0A042DDBF9@marvell.com>
Date: Mon, 3 Jan 2011 11:10:32 +0100
Message-ID: <AANLkTinOZS8CT7Ov1R5Xa680jyEbC6LG3yPzUFFPQUBh@mail.gmail.com>
Subject: Re: [PATCH] mmc: add MMC_QUIRK_BROKEN_CLK_GATING
From: Pierre Tardy <tardyp@gmail.com>
To: Philip Rakity <prakity@marvell.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        "Gao, Yunpeng" <yunpeng.gao@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Takashi Iwai <tiwai@suse.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 2, 2011 at 11:23 PM, Philip Rakity <prakity@marvell.com> wrote:
>
> why not just not compile the the code without clock gating defined ?
>
> and if code cannot run with it clock gating defined do a
> #error ?

The problem here is not related to the drivers that wont compile with
clock gating.
sdio clock gating, is that you gate the sdio bus clock when you dont need it.

Because some vendors sdio card IP is bad, some card are not working
properly when you do this (Their interrupt logic might need a clock to
trigger interrupt, or they are derivating their own internal clock
from the sdio bus clock). Those card are wrong thus I'm using a quirk
to deal with them.

The problem is that we still dont know how many card are wrong and
what are they. So that's why I'm making it default for all sdio card
at the moment.
When we'll have more experience on this, we can switch the behaviour,
and make it a default off.


> Also from the diff I think you patch changes the behavior of SD/eMMC cards which may not be what you want .
The quirk is only set for sdio cards, which is, I think, equivalent to
the previous implementation.

-       if (mmc_card_sdio(card))
-               return false;
-
-       return true;
+       return !(card->quirks & MMC_QUIRK_BROKEN_CLK_GATING);

@@ -785,6 +785,12 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
+        card->quirks |= MMC_QUIRK_BROKEN_CLK_GATING;


This code is made to propose a solution for allowing drivers owner
that *knows* that their card work with CG, to disable the quirk in
their probe function.

Pierre
