Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab0IEGmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 02:42:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64052 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab0IEGmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 02:42:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=guS57syZljqhn3dUZCejNOf57FoeJSw2B1Bb/2VxQP0nQIdiswCWt4MOnwDJN/1owh
         GXw6sfYh1a6yB8//4aUfw5yVa7WRM289NqwotrGkEvjhQw0ia2SkLxKQ7Y/wTRCVb5OW
         ae9ZdigYDbF3roTWKdeX3PPLU1E6ZWIa49eCw=
MIME-Version: 1.0
In-Reply-To: <1fb6fc37cd0f017043d5c124bca4bb1a@secure211.sgcpanel.com>
References: <1283443098-15262-1-git-send-email-tom.leiming@gmail.com>
	<ee6a42fe148f72518d475ff3838fc32a@secure211.sgcpanel.com>
	<AANLkTimts7SjE9EKrmsSkynWsQc_VtJUVVigrFs2VtrK@mail.gmail.com>
	<AANLkTikiFbw6xz5jbvgPR5-X5mZxDkOjLdFuc=vG10qK@mail.gmail.com>
	<1fb6fc37cd0f017043d5c124bca4bb1a@secure211.sgcpanel.com>
Date: Sun, 5 Sep 2010 14:42:51 +0800
Message-ID: <AANLkTi=4J5u4SEh5jSPxObceWdAom51R+H_j8oApG5PG@mail.gmail.com>
Subject: Re: [PATCH] USB: otg: twl4030: fix phy initialization
From: Ming Lei <tom.leiming@gmail.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <felipe.balbi@nokia.com>, Anand Gadiyar <gadiyar@ti.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/5 Felipe Balbi <me@felipebalbi.com>:
> Hi,
>
> On Sat, 4 Sep 2010 23:36:39 +0800, Ming Lei <tom.leiming@gmail.com> wrote:
>> Considered bit PHYPWD of PHY_PWR_CTRL is zero at default,
>> say, OTG phy is not put into power down after system poweron,
>> so 2.6.36-rc3 will make musb device mode broken if bootloader
>> doesn't touch  PHYPWD of PHY_PWR_CTRL.
>>
>> Could you ack the patch if no further objections or give other
>> suggestions?
>
> I don't see why that patch should cause problems with device
> mode. Fact is that transceiver is only "asleep" when PHYPWD
> bit is true and without setting that flag correctly we were
> leaving phy's LDOs powered on for nothing when we were
> booting without a USB cable connected.
>
> If you don't explain exactly what is the problem you see
> (besides the WARN) it's to help any further, specially now

Oh, I already explain the cause in detail in this thread.

          http://marc.info/?l=linux-kernel&m=128347462130590&w=2

No problem, do it again, if you have any questions about the explanation
please feel free to let me know.

issue #1:(musb device not work with cable connected with PC)
        -twl->asleep is set as zero in .probe since bootloader has not
powerdown phy
        -EVENT_VBUS returned from twl4030_usb_linkstat since usb cable
is connected with PC
        -twl4030_phy_resume is called but does nothing since
twl->asleep is zero
        -the following are not called to initialize otg phy:
                 twl4030_phy_power / twl4030_i2c_access / twl4030_usb_set_mode
        -so musb device mode does not work

issue #2:(regulator 'unbalanced disables' warnings )
        -twl->asleep is set as zero in .probe since bootloader has
not powerdown phy
        -EVENT_NONE returned from twl4030_usb_linkstat since no usb cable is
connected with board
        -twl4030_phy_suspend is called
        -twl4030_phy_power is called since twl->asleep is zero
        -regulator_disable is called for power down case
        -so cause the kernel warning since no regulator_enable is called before

> that I'm 100% without HW to test against. I'm also in a
> big hurry packing a buch of stuff for moving to another
> appartment, so if there isn't enough information, I can't
> be of any help.

Sorry for disturbing you, hope you have a happy moving, :-)

>
> Still, I would NACK you patch because I don't think it's
> approaching the correct problem. If you only see that WARN,
> you could start by chaging the code so that:
>
> if (!regulator_is_enabled(twl->usb3v1)
>    regulator_enable(twl->usb3v1);

Yes, it is another fix for the issue #2, just different way for
the same problem, right?

>
> and similarly for the regulator_disable() call, then check
> whether there are any other problems. If there are, we will
> take it from there.
>
> All in all, I doubt that patch would cause break anything
> since it's just checking the initial state from the
> transceiver itself to set a flag in the driver structure,
> that's all.

No, .asleep flag is set according to the current link state,
instead of the initial state of transceiver. I don't think the patch
will cause break anything. If you think it will, please describe the
break in detail.

thanks,

-- 
Lei Ming
