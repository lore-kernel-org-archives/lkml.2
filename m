Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab0I0Kyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:54:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60294 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab0I0Kyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TUl5kHHQDfFnbDBcJy/s/fxAp6RxHOVfx+/up5YDYjZpcZc3PTC+mNzgHfN4chQFzw
         JNHxg+ahhOIh+0QgMv476gYrcU5zy2c52n6B1qAIkNmzQ4/o512BUk8djGc5N5NmVrv1
         VjabT+b49wW5ntiX4R0vrXRihB6xZwsfNPbXk=
MIME-Version: 1.0
In-Reply-To: <AANLkTinkxokX9BGtxysYOr19xbZR4S8oPRYUAyneutzc@mail.gmail.com>
References: <1285529740-28232-1-git-send-email-notasas@gmail.com>
	<AANLkTinkxokX9BGtxysYOr19xbZR4S8oPRYUAyneutzc@mail.gmail.com>
Date: Mon, 27 Sep 2010 13:54:36 +0300
Message-ID: <AANLkTinh+JTwyE4E33QXdnZ8obYA8S0SU71i3kGi=wRT@mail.gmail.com>
Subject: Re: [PATCH v3] power_supply: Add driver for TWL4030/TPS65950 BCI charger
From: Grazvydas Ignotas <notasas@gmail.com>
To: Arun Murthy <arunrmurthy.83@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Madhusudhan <madhu.cr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 10:21 AM, Arun Murthy <arunrmurthy.83@gmail.com> wrote:
> On Mon, Sep 27, 2010 at 1:05 AM, Grazvydas Ignotas <notasas@gmail.com>
> wrote:
>> ---
>> This is v3 of BCI charger driver I first sent nearly a year ago [1].
>> I've updated it to use the new OTG notifiers for VBUS notifications,
>> however it still is not able to determine charge current to use.
>> For that reason there is now a temporary module param to enable USB
>> charging, until I can figure out how to get that info from the gadget
>> stack (hopefully Felipe can help me here).
>
> On detecting USB plug, the driver is suppose to detect the type of usb
> device. Then if the device is a PC(standard host) the charging current is to
> be obtained from the usb stack. Hence the driver will have to wait until the
> usb stack or driver notifies the current that can be drawn. The usb stack or
> driver gets to know the amount of current to be drawn through the
> negotiations that happen between the host and device.

I'm aware of that, the question was how to get that from Linux USB
stack (which Felipe already responded).

<snip>

> Only AC and USB monitoring is achieved by registering with power supply
> class.
> How is battery monitored?
> An instance of battery is to be registered with power supply class in order
> to monitor battery.

The problem is that BCI is only active while charging, when it is not
charging most (all?) monitoring registers freeze and no monitoring
happens (BCI registers read frozen values from last charge). So I
don't register battery as it has no useful data to report. I heard it
is possible to use MADC to perform monitoring while not charging, so
battery can be added when MADC driver is merged and corresponding code
is written for this driver.

>>
>> +
>> +static struct platform_driver twl4030_bci_driver = {
>> +       .probe          = twl4030_bci_probe,
>> +       .remove         = __devexit_p(twl4030_bci_remove),
>> +       .driver         = {
>> +               .name   = "twl4030_bci",
>> +               .owner  = THIS_MODULE,
>> +       },
>> +};
>
> dev_pm_ops can be use

nothing to do there right now, the driver relies on FSM change
interrupts from BCI to update state.
