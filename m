Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab0DHQRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 12:17:01 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:48486 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758583Ab0DHQRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 12:17:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=cIJ+1nbNNpfko2xMbQqJBFw/ECu9dtPuA4Uqqzxq3CXPhR9nPKPi55H8ugpXoS1MtQ
         o7j9pspHOxspVAJKud5UeFcw0DK4aKqmwvHLbflIPK3I6OtlmOeDMv90ZnoYKMolQwO2
         3O3fT77bdjVjrSHhpsYjUS9qKYzI8k4OWtcMY=
MIME-Version: 1.0
In-Reply-To: <y2z4bc8bc021004051214qf2adadf6u54862990349a7433@mail.gmail.com>
References: <y2z4bc8bc021004051214qf2adadf6u54862990349a7433@mail.gmail.com>
Date: Thu, 8 Apr 2010 18:16:58 +0200
Message-ID: <n2j4bc8bc021004080916k54ab3f1an140ed2bd00bd327f@mail.gmail.com>
Subject: Re: [PATCH] compal-laptop.c: added JHL90, battery & hwmon interface
From: Roald Frederickx <roald.frederickx@gmail.com>
To: mingo@redhat.com, superm1@ubuntu.com, mario_limonciello@dell.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I overlooked a patch (I reverted back to an older kernel for an
unrelated issue), this should be applied for the current kernel:

--- compal-laptop.c     2010-04-05 20:44:22.727791103 +0200
+++ compal-laptop-new.c 2010-04-06 16:29:00.799286626 +0200
@@ -928,12 +928,15 @@
      /* Register backlight stuff */

      if (!acpi_video_backlight_support()) {
-               compalbl_device = backlight_device_register(DRIVER_NAME,
-                                               NULL, NULL, &compalbl_ops);
+               struct backlight_properties props;
+               memset(&props, 0, sizeof(struct backlight_properties));
+               props.max_brightness = BACKLIGHT_LEVEL_MAX;
+               compalbl_device = backlight_device_register(DRIVER_NAME,
+                                                           NULL, NULL,
+                                                           &compalbl_ops,
+                                                           &props);
              if (IS_ERR(compalbl_device))
                      return PTR_ERR(compalbl_device);
-
-               compalbl_device->props.max_brightness = BACKLIGHT_LEVEL_MAX;
      }

      ret = platform_driver_register(&compal_driver);


2010/4/5 Roald Frederickx <roald.frederickx@gmail.com>:
> Dear kernel developers,
>
> On February the fourth I have contacted Cezary Jackiewicz regarding a
> (large) addition to the compal-laptop driver (he is listed in the
> maintainers file as the person to contact). However I still haven't
> received any reply to date. I have recently checked the github commits
> on this driver and I saw some activity during February and March. I
> have patched my original addition to the driver to reflect the changes
> that were made to the driver in the meantime. This mail is sent to all
> the people that were involved in those github commits (excluding
> Linus) and to the kernel mailing list.
>
>
> About the additions:
>
> The driver now supports the Compal JHL90 (which I use) and it has some
> added features. The biggest novelties are a battery interface
> (power_supply) and a temperature and fan control interface (hmwon).
>
> Much of the original code of the old features is still there, but I've
> changed some names to keep the naming more coherent with the added
> functionalities.
>
> This is my first kernel patch, so I'm new to this. I've added my name
> and email address as an author (I'm willing to respond to questions,
> and/or to test future versions on a JHL90 platform). I also bumped up
> the version number to 0.2.7 as this is quite a big change.
>
>
> Some technical stuff about the new driver:
>
> NOTE: First of all, I'm not sure if the extra features also work on
> the other Compal boards. If it turns out they only work on the JHL90,
> then the driver can easily be altered to only enable them if the DMI
> detection find such a board. (I can make those changes, should this be
> needed.)
>
> I've noticed a quirk in my fan controller. I have to re-send the
> wanted pwm-level to the controller every so often. If I don't do this,
> the fanspeed will slowly rise until after a couple of minutes it's at
> full speed. (Note that every normal userland application will probably
> update the pwm-level every so often anyway, based on temperature
> readings, so this might not be an issue in practice) If this turns out
> to be a problem with all the controllers, maybe we should implement a
> kernel timer and have the driver re-send the pwm level every XX
> seconds to make this transparent to userspace? (However, I couldn't
> immediately find a way to do this *cleanly*.)
>
> Additional information can be found in the source comments.
>
>
> Lastly: the code. I've just inserted the entire source code. A diff
> wouldn't be of much use given the amount of code that was altered and
> added. It's attached as a bzipped tarball containing two files:
> compal-laptop.c and the advised README.
>
>
> Kind regards,
>
> Roald Frederickx
>
