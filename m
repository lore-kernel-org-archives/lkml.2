Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab2GWJTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 05:19:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64821 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2GWJTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 05:19:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=WxcXFgf+0a1UfAPRWuvWptLm9RjSqW3tEZjyT0Z+4gkA@mail.gmail.com>
References: <1342808038-7558-1-git-send-email-dianders@chromium.org>
	<CAFbHwiQh-Cwo4xo6-vCbvWsmz_cheZK1m3SnwkvSziunV1ShBA@mail.gmail.com>
	<CAD=FV=WxcXFgf+0a1UfAPRWuvWptLm9RjSqW3tEZjyT0Z+4gkA@mail.gmail.com>
Date: Mon, 23 Jul 2012 10:19:16 +0100
Message-ID: <CAFbHwiQNY+R56pbRJBcR9+BcGmJn6bV=7Y0ELNBT1bqkQ6D+kA@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Disable low power mode if SDIO interrupts
 are used
From: Will Newton <will.newton@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        James Hogan <james.hogan@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 3:48 AM, Doug Anderson <dianders@chromium.org> wrote:
> On Sat, Jul 21, 2012 at 3:40 AM, Will Newton <will.newton@gmail.com> wrote:
>>>  static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>>>  {
>>>         struct dw_mci_slot *slot = mmc_priv(mmc);
>>> @@ -871,6 +896,14 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>>>         /* Enable/disable Slot Specific SDIO interrupt */
>>>         int_mask = mci_readl(host, INTMASK);
>>>         if (enb) {
>>> +               /*
>>> +                * Turn off low power mode if it was enabled.  This is a bit of
>>> +                * a heavy operation and we disable / enable IRQs a lot, so
>>> +                * we'll leave them disabled; they will get re-enabled again in
>>> +                * dw_mci_setup_bus().
>>> +                */
>>> +               dw_mci_disable_low_power(mmc);
>>> +
>>
>> Is it safe to just disable low power here or could the setting be
>> overwritten in setup_bus?
>
> Very good question.  In my current setup I don't see setup_bus()
> called during normal operation.  If it were, my kernel messages would
> be constantly spammed with messages like:
>     Bus speed (slot %d) = %dHz (slot req %dHz, actual %dHZ div = %d)
>
> ...and they're not.  Things may be different with different SDIO cards perhaps?

Yeah I think setup_bus should only setup the card clock once at
startup but it may also be required on resume?

I should probably mention I have not tested this driver with any SDIO
devices, although I believe there are other people out there who do!
