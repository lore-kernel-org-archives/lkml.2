Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934542Ab2DLSBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:01:10 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46490 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2DLSBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:01:08 -0400
MIME-Version: 1.0
From: Jonathan Kliegman <kliegs@chromium.org>
Date: Thu, 12 Apr 2012 14:00:47 -0400
X-Google-Sender-Auth: 6n3Y9DQTsB8kQU8GeTWDQjQQp94
Message-ID: <CAPQV+nMqJDOyfvg+naQZaUUgqfR0xCnbcxUxdEoXmwJhkmN7Tg@mail.gmail.com>
Subject: Adding hysteresis to thermal_zone_device_update in drivers/thermal/thermal_sys.c
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking at thermal_zone_device_update in
drivers/thermal/thermal_sys.c to add hysteresis for turning on
non-critical fans.  While doing this I noticed that when a fan changed
state as a result of this function, it would trigger the function
being reentered again.  The function itself is protected by a
mutex_lock call so its safe to do so.  However this means that logic
such as "check if temperature exceeded trips value for this call and
previous call" doesn't work as the two calls can be occurring at the
same time.

The actual reason for reentering is that thermal_zone_device_update in
addition to being called on a timer, will also be called from
acpi_thermal_notify which gets triggered when a fan transitions state
to on or off.  So if thermal_zone_device_update decides to turn a fan
on or off, it will immediately be called again.

What is the right way to fix this and add the ability to check that
the temperature has maintained a value over the trips value?  Should I
look at changing the callback path for fan change to not call
thermal_zone_device_update if its what triggered the fan change?  Or
would it be better to implement more complicated checks on the
temperature values to take into account the time it first passed the
trips threshold rather than just checking that a previous check saw it
over the threshold?

-Jon
