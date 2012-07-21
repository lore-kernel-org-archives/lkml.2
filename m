Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2GUAqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 20:46:17 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42586 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab2GUAqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 20:46:16 -0400
MIME-Version: 1.0
Date: Fri, 20 Jul 2012 17:46:14 -0700
X-Google-Sender-Auth: SKAKYCneP4MShY0eQqjjrWeKXfA
Message-ID: <CAMbhsRTX=t4UMfmrJRyXidSTWXvaC5L9aFdTFL03wYYKrUE5qw@mail.gmail.com>
Subject: sysfs permissions on dynamic attributes (led delay_on and delay_off)
From: Colin Cross <ccross@android.com>
To: lkml <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to use the standard ledtrig-timer.c code to handle led
blinking for notifications on an Android device, and I'm hitting some
issues with setting permissions on the dynamically created delay_on
and delay_off attributes.  For most sysfs files, we have userspace
uevent parser that watches for device add notifications and
chowns/chmods attributes.  This doesn't work for delay_on and
delay_off, because they are created later, when "timer" is written to
the trigger attribute.  There is no uevent when the new files are
created, and sysfs doesn't support inotify, so I don't see any way to
receive an event to set the permissions.  This issue exists any time
that device_create_file is called after device_add.

What is the appropriate way to get an event to set the permissions?
Add inotify support for sysfs file creation?  Send a KOBJ_CHANGE
uevent in device_create_file? Send a KOBJ_CHANGE uevent from the
driver after calling device_create_file?  Dynamically create a timer
device under /sys/class/leds/<led> so a new add uevent gets sent?
Promote blinking to be a core led feature instead of a trigger, so the
files are always present?
