Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0IEQAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 12:00:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36543 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab0IEQAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 12:00:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LgsKyHSbVhjsQ98l92zNOdw4/Ac+e75FDzDjtxXlS+eYE852uO9igp0FmMaLkXm53y
         YCE7M+MTIjE6ys9DllE52ypgin+5NVtJAYZjbXgRZdXwtXChFmb/dM/8j2PiIFdVaEbN
         wtEa0c8yyy+6gn0OskzmZxMvz4tJ3YNfIz7Q0=
MIME-Version: 1.0
In-Reply-To: <7c720d238d9d5ba6f483cdd7303315e4@secure211.sgcpanel.com>
References: <1283443098-15262-1-git-send-email-tom.leiming@gmail.com>
	<ee6a42fe148f72518d475ff3838fc32a@secure211.sgcpanel.com>
	<AANLkTimts7SjE9EKrmsSkynWsQc_VtJUVVigrFs2VtrK@mail.gmail.com>
	<AANLkTikiFbw6xz5jbvgPR5-X5mZxDkOjLdFuc=vG10qK@mail.gmail.com>
	<1fb6fc37cd0f017043d5c124bca4bb1a@secure211.sgcpanel.com>
	<AANLkTi=4J5u4SEh5jSPxObceWdAom51R+H_j8oApG5PG@mail.gmail.com>
	<7c720d238d9d5ba6f483cdd7303315e4@secure211.sgcpanel.com>
Date: Mon, 6 Sep 2010 00:00:12 +0800
Message-ID: <AANLkTimf2af9QBw2s93n6Ja5cgHODudfwmMqKc02GmbC@mail.gmail.com>
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
> On Sun, 5 Sep 2010 14:42:51 +0800, Ming Lei <tom.leiming@gmail.com> wrote:
>> issue #1:(musb device not work with cable connected with PC)
>>         -twl->asleep is set as zero in .probe since bootloader has not
>> powerdown phy
>>         -EVENT_VBUS returned from twl4030_usb_linkstat since usb cable
>> is connected with PC
>>         -twl4030_phy_resume is called but does nothing since
>> twl->asleep is zero
>>         -the following are not called to initialize otg phy:
>>                  twl4030_phy_power / twl4030_i2c_access /
>>                  twl4030_usb_set_mode
>>         -so musb device mode does not work
>
> ok, I see. So what you could do is enable regulators on probe
> based on PHYPWR bit.

This patch will enable regulators on probe based on current link state
returned from twl4030_usb_linkstat instead of PHYPWR bit. If vbus or
ID event detected, call __twl4030_phy_resume to enable regulators/
phy power/set mode to make phy into work state, or else call
__twl4030_phy_power(0) to power down otg phy.

See twl4030_usb_phy_init introduced in the patch.

>> No, .asleep flag is set according to the current link state,
>> instead of the initial state of transceiver. I don't think the patch
>> will cause break anything. If you think it will, please describe the
>> break in detail.
>
> if we revert that patch, you'll see that usb3v1 ldos are left on

You commit before does fix one problem, which may keep phy in
power on even no cable connected, so I do not request a simple
revert, :-).

> if we never plug/unplug usb cable. AFAIR, the reset state of those
> LDOs is ON, so that's why we need that patch.

>From Table 5-373 of TPS65950 manual[1], usb3v1 ldo is in sleep state
after reset. But it is put into active state in twl4030_usb_ldo_init now,
seems activating it too early.  I have verified it OK on beagle board to
remove the early activating of usb3v1 in twl4030_usb_ldo_init. I'll merge
it into the v2 of the patch and post it for your review.

>
> I'll try to work on it monday judging I'll have laptop and HW
> available by then.

Very good, thanks your work!

[1], TPS65950 Technical Reference Manual, http://www.ti.com/litv/pdf/swcu050e


thanks,
-- 
Lei Ming
