Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab1LOGgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:36:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62795 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab1LOGgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:36:16 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20111215133229.20e7f0f2@notabene.brown>
References: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
	<20111215133229.20e7f0f2@notabene.brown>
Date: Thu, 15 Dec 2011 15:36:15 +0900
X-Google-Sender-Auth: c-1Pm1WKKdB9iJq8M9ewqZJ_Pho
Message-ID: <CAJ0PZbQHjtit8bUyJx996PD5eBzd3SHapHQ0qjhMfTUmn0Q+0Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] introduce External Connector Class (extcon)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 11:32 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 14 Dec 2011 19:28:25 +0900 MyungJoo Ham <myungjoo.ham@samsung.com>
> wrote:
>
>> Note that previously, the patchset has been submitted as
>> "Multistate Switch Class".
>>
>> For external connectors, which may have different types of cables attached
>> (USB, TA, HDMI, Analog A/V, and others), we often have seperated device
>> drivers that detect the state changes at the port and device drivers that
>> do something according to the state changes.
>>
>> For example, when MAX8997-MUIC detects a Charger cable insertion, another
>> device driver (such as MAX8903 charger, MAX8997 charger, Charger Manager,
>> or board file) needs to set charger current limit accordingly and when
>> MAX8997-MUIC detects a HDMI cable insertion, multimedia device drivers
>> need to do some operations accordingly.
>
> Hi,
>  a few comments...
>
> 1/ I still don't understand why this needs to a single device which can
>   report multiple cables, rather than simply having multiple devices each
>   of which reports a single cable at a time.
>
>   i.e. A physical 32 bit port might be represented as several 'extcon'
>   devices each of which reports a different function: USB, HDMI, Charger,
>   etc.
>

Implementing what you've suggested would require another device driver
or framework to relay notifications from the physical 32 bit port to
several 'extcon' devices unless the physical 32 bit port has 32 IRQ
lines or addresses. If it is implemented in a device driver, we will
reimplement the same feature in every multi-port device drivers. If we
make another framework, we are simply seperating extcon framework into
two seperated frameworks.

It is because the "report" comes from a single device ("notifier":
implementing extcon device) and multiple cables and devices using the
cables need to listen to the "report" ("notifiee": registering
notifier block to the extcon device). With the FSA9480 USB Switch,
MAX8997 MUIC, or MAX77693 MUIC representing an external connector with
multiple cables possible, it is impossible to create one device to
handle events from one cable. We simply have only one GPIO for the
interrupt and one I2C slave address for them. Even when we implement
one device for one cable, we need something working as a "network
router" between the connector(WAN port) and cables (LAN ports), which
is "extcon" in this case.

If we implement an extcon-like device to handle each possible cable
state and notify devices according to every cable state, then, it
would like implementing extcon class code at each extcon-like device
driver. We would need to implement this method (registering cable
interest) in every extcon-like device (MUIC / USB Switch / ...)

>   The fact that the devices are related can be made clear by the choice of
>   port names.
>
>   If these is a good reason, it needs to be included in the patch
>   somewhere, possibly in a file in Documentation, so that when someone comes
>   along to use this class in a year or two they can understand all the
>   consequences of any decision they make (and so that I stop asking now:-)

With the current patchset,

extcon_register_interest(null_obj, "max8997-muic.0", "HDMI", nb_callback);

registers the notifier-block callback for a specific cable "HDMI" of
max8997-muic.0

Do you mean to include a usage description like above in
Documentation? If so, I'll make one under linux/Documentation/extcon/
later.

>
> 2/ When you have multiple cable options, the 'state' sysfs file looks
>   like e.g.
>      USB 0, HDMI 1, DVI 1
>
>   Having list values in sysfs files is generally frowned upon but sometimes
>   is necessary.  However I'm not sure this is a good format to use.
>   There aren't a whole lot of examples to follow (because it is so frowned
>   upon) but one option is
>
>      USB  [HDMI] [DVI]
>
>   where the selected option(s) are in square brackets.
>   Another might be
>
>    USB=0
>    HDMI=1
>    DVI=1
>
>   with newlines - just like in the 'uevent' file.

Yes. This looks much better. Thanks.

>
>   Also I think that some pairs of cables are mutually exclusive while others
>   aren't.  This fact isn't made apparent in the 'state' file.  Maybe it
>   should be.
>

I think as long as the notifier (extcon class device) is the only one
who is supposed to have the right to write and userspace cannot write
state value, I don't think this is required. Such relation should be
dealt in the notifier device and all the others who are "readers" do
not need to know such detail.

>   Whatever format is used should be documented in the
>   Documentation/ABI file.

Yes, I will add that one.

>
>   Of course this problem would go away if you didn't allow multiple
>   concurrent cables per port.
>
> 3/ The use of extcon_get_extcon_dev() requires that the port device be
>   registered before the device that wants to be notified by it.  Ensuring
>   correct ordering of device discovery is (I believe) not always easy -
>   particularly with module loading.
>
>   Would it make sense to instead have one device register as a
>   switch-provider and the other device register as a switch-listener and as
>   soon as they both exist they get connected: a bit like how 'devices' and
>   'drivers' can be registered in any order.
>   Maybe the same device/driver infrastructure could be reused (an extcon
>   bus maybe?) but I'm not really familiar enough with it to say (Greg??).
>
>   What I do know is that I have repeatedly tripped over the fact that you
>   cannot use a GPIO line until the gpiochip has been registered and
>   sometimes the device that needs it is registered before the device which
>   provides it.  I wouldn't like to see that happening here too.
>
>   Are there other examples of inter-device dependencies that can be used as
>   a model?

Yes, this has been sometimes a problem for me as well.

What if let "extcon_register_interest" returns <0 for errors, "1" if
successfully registered, and "0" if the extcon name does not exists
(probably will be "probed" later?) and register the requested interest
later when the corresponding extcon is probed?

Then, I'll need to add "bool effective" in the struct
extcon_specific_cable_nb so that the notifee (caller of
extcon_register_interest()) my know if the interest is effectively
registered or still pending.

Also, I may need to add an option to extcon_register_interest stating
whether it is ok to be "pending" if extcon_name does not exist or is
should return error if extcon_name does not exist.

Anyway, it seems that extcon_register_interest is the only one that
needs to care this inter-device dependencies because
extcon_register/unregister_interest are the only ones supposed to be
called by notifee (depending devices).

>
>
>
>>
>> This patchset supports the usage of notifier for passing such information
>> between device drivers.
>>
>> Another issue is that at a single switch port, there might be multiple
>> and heterogeneous cables attached at the same time. Besides the state
>> (Attached or Detached) of each cable may alter independently.
>>
>> In order to address such issues, Android kernel's "Switch" class seems to
>> be a good basis and we have implemented "Multistate Switch Class" based on
>> it. The "Switch" class code of Android kernel is GPL as well.
>
> Do you need to update this text to remove "Multistate Switch Class" ??
>

Yes, I do.


Thank you for your comments.


Cheers!
MyungJoo

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
