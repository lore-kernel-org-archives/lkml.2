Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab2GUFO3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 01:14:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39238 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2GUFO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 01:14:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120721040816.GA7313@kroah.com>
References: <CAMbhsRTX=t4UMfmrJRyXidSTWXvaC5L9aFdTFL03wYYKrUE5qw@mail.gmail.com>
	<20120721040816.GA7313@kroah.com>
Date: Fri, 20 Jul 2012 22:14:27 -0700
X-Google-Sender-Auth: ygsa93UBSX-oyKCgOYQ012ss3t0
Message-ID: <CAMbhsRTjEn4ZSir-N2DX5HM9fueagAXpDFnx8OpPM2m6hgOXXQ@mail.gmail.com>
Subject: Re: sysfs permissions on dynamic attributes (led delay_on and delay_off)
From: Colin Cross <ccross@android.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 9:08 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Jul 20, 2012 at 05:46:14PM -0700, Colin Cross wrote:
>> I'm trying to use the standard ledtrig-timer.c code to handle led
>> blinking for notifications on an Android device, and I'm hitting some
>> issues with setting permissions on the dynamically created delay_on
>> and delay_off attributes.  For most sysfs files, we have userspace
>> uevent parser that watches for device add notifications and
>> chowns/chmods attributes.  This doesn't work for delay_on and
>> delay_off, because they are created later, when "timer" is written to
>> the trigger attribute.  There is no uevent when the new files are
>> created, and sysfs doesn't support inotify, so I don't see any way to
>> receive an event to set the permissions.  This issue exists any time
>> that device_create_file is called after device_add.
>>
>> What is the appropriate way to get an event to set the permissions?
>> Add inotify support for sysfs file creation?  Send a KOBJ_CHANGE
>> uevent in device_create_file?
>
> No.
>
>> Send a KOBJ_CHANGE uevent from the driver after calling
>> device_create_file?
>
> Yes.
>
>> Dynamically create a timer device under /sys/class/leds/<led> so a new
>> add uevent gets sent?
>
> Ick.
>
>> Promote blinking to be a core led feature instead of a trigger, so the
>> files are always present?
>
> That's the best thing, why not just do that?

It doesn't solve the general case.  For example, any driver that is
loaded as a module and then calls device_create_file will suffer the
same problem.  But since it solves the one I care about, I'll look
into it.
