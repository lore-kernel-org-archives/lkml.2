Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922Ab1LPBNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 20:13:15 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50488 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1LPBNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 20:13:13 -0500
MIME-Version: 1.0
In-Reply-To: <20111215235017.GA2242@legolas.emea.dhcp.ti.com>
References: <1323988934-11350-1-git-send-email-felipe.contreras@gmail.com>
	<20111215230143.GA2090@legolas.emea.dhcp.ti.com>
	<CAMP44s1JMwF95nOgZLvdL7ke6fYz-ar5SDv=Lu-5QJ==0bkH=Q@mail.gmail.com>
	<20111215235017.GA2242@legolas.emea.dhcp.ti.com>
Date: Fri, 16 Dec 2011 03:13:13 +0200
Message-ID: <CAMP44s1GCPRjV4weNN1GpboDPbzUobBLVP+u2Y4QvHrt2KoG_Q@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: fix pm_runtime mismatch
From: Felipe Contreras <felipe.contreras@gmail.com>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, stable@vger.kernel.org,
        Hema Kalliguddi <hemahk@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 1:50 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Fri, Dec 16, 2011 at 01:31:02AM +0200, Felipe Contreras wrote:
>> On Fri, Dec 16, 2011 at 1:01 AM, Felipe Balbi <balbi@ti.com> wrote:
>> > On Fri, Dec 16, 2011 at 12:42:14AM +0200, Felipe Contreras wrote:
>> >> --- a/drivers/usb/musb/musb_core.c
>> >> +++ b/drivers/usb/musb/musb_core.c
>> >> @@ -2012,8 +2012,6 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
>> >>       if (status < 0)
>> >>               goto fail3;
>> >>
>> >> -     pm_runtime_put(musb->controller);
>> >
>> > To me the real fix would be add the missing pm_runtime_get_sync(). On
>> > probe() we're actually accessing MUSB's address space which needs it's
>> > clocks turned on. I guess it's only working now by chance, probably
>> > because glue layer calls pm_runtime_get_sync() to access it's own
>> > address space and that uses the same clocks.
>>
>> Are you sure it's "musb-hdrc", and not "musb-omap2430" the one
>> accessing the relevant address-space? From the runtime_pm
>> documentation it looks like only the probe function should deal with
>> this.
>>
>> If "musb-hdrc" was truly accessing these registers, then I would get
>> the same failure because the clocks are turned off, but I don't...
>
> see musb_core_init(); You don't see any problems when accessing those
> addresses because musb_platform_init() will fall into
> omap2430_musb_init() which calls pm_runtime_get_sync(), and the same
> clock actually enables both address spaces (musb-omap2430 and
> musb-hdrc).

That's true, but how would I go test this theory? Call
pm_runtime_put_sync() at the end of omap2430_musb_init()?

Also, I think most pm_runtime_disable() calls shouldn't be there...
That would tell PM to activate power for the device, which is not what
we want. The core drivers code will take care of truly disabling the
pm_runtime stuff _without_ activating the device.

Cheers.

-- 
Felipe Contreras
