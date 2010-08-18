Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0HRB4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 21:56:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64227 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0HRB4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 21:56:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=kPzoBHft2On3j+EHN4dqYSgiBhkidmuzNVVa1AoYMmY/CbJ1XPgVda65LvulnxW8RP
         B94oXkaqXHyE5XuyMQBWlnqSXmSrE7uH5QGaPSXC9pwdKcP+862bnFEpLMJ6/9hWF8CK
         bT2ThhsVehNYuij2KV8lpr6rHhN9fnTh6ZZAw=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <201008180325.17816.rjw@sisk.pl>
References: <AANLkTimnC384BMdwJtk1Rp33YnAXr66HJqPvBegOxGmC@mail.gmail.com>
	<201008180325.17816.rjw@sisk.pl>
Date: Wed, 18 Aug 2010 02:56:38 +0100
Message-ID: <AANLkTimdF_eYurw9k0rQRAzSQ-fZMKsFLupnME_ch1Ru@mail.gmail.com>
Subject: Re: [REGRESSION, bisected] 2.6.36-rc1 - suspend issues
From: trapDoor <trapdoor6@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        trapDoor <trapdoor6@googlemail.com>, Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 2:25 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, August 17, 2010, trapDoor wrote:
>> Hello,
>> The merge window is closed so it's time to hunt for bugs. I've got
>> one, please find details below.
>> -----------------------
>>
>> Working kernels: from 2.6.35 - to 2.6.35.2
>> Non working kernels: from (at least) 2.6.35-git2 - to 2.6.36-rc1
>> -----------------------
>>
>> Description of the problem(s):
>>
>> 1. First of all I confirm that the problem is consistent: suspend
>> works well every time on the 'good' kernels and it newer works (with
>> the symptoms) on any of the 'bad' kernels. I've tested it several
>> times on a couple of 'good' and 'bad' kernels to make sure it's not
>> some random issue.
>>
>> 2. On a bad kernel, this is what happens when I try to switch to suspend mode:
>> - screen goes blank ['No signal detected !'] - that's OK :)
>> - either the CPU fan or PSU fan or both are still running and they
>> won't stop (left it for about 30 min. once)
>> - the power light is on and still, where in suspend mode it should
>> blink - that won't change either
>> - pressing the power button obviously doesn't wake the system up; need
>> to hard reboot
>>
>> 3. Now, when booting again, after an unsuccessful suspend and hard
>> reboot, something happens to my network card (and it doesn't matter
>> what is the next kernel I boot from - it can be any 'good' or 'bad'
>> one):
>> - in Gnome, the gnome-panel network indicator shows my connection as
>> disabled (wired eth0 - the only one I use); enabling it doesn't bring
>> my network up
>>
>> 4. After re-booting from any of the 'good' or 'bad' kernels my network
>> connection is working again.
>> -----------------------
>>
>> Bisecting turned up the following commit. Reverting it in 2.6.36-rc1
>> results in a system that works.
>>
>> commit bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a
>> Author: Arnd Bergmann <arnd@arndb.de>
>> Date:   Sun Jul 11 15:34:05 2010 +0200
>>
>>     HID: hiddev: use usb_find_interface, get rid of BKL
>>
>>     This removes the private hiddev_table in the usbhid
>>     driver and changes it to use usb_find_interface
>>     instead.
>>
>>     The advantage is that we can avoid the race between
>>     usb_register_dev and usb_open and no longer need the
>>     big kernel lock.
>>
>>     This doesn't introduce race condition -- the intf pointer could be
>>     invalidated only in hiddev_disconnect() through usb_deregister_dev(),
>>     but that will block on minor_rwsem and not actually remove the device
>>     until usb_open().
>> -----------------------
>>
>> Despite mentioned issues with network (occurring every time after
>> unsuccessful suspend > hard restart) the bisecting turned up a commit
>> which isn't rather related to network. But I can confirm that
>> reverting only this one commit in 2.6.36-rc1
>> [da5cabf80e2433131bf0ed8993abc0f7ea618c73] fixes the whole problem -
>> suspend works OK and I have no issues with my network after waking the
>> system up, neither after re-booting from the same or any other kernel.
>>
>> Please let me know what further details should I provide. Any logs,
>> hardware specifications? I've also made a brief log recording the
>> bisect if anyone would need it.
>
> Well, we should let the HID maintainer know about the problem (CC added).
>
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Thanks Rafael,
Before I opened this thread I only searched on
http://vger.kernel.org/vger-lists.html for any appropriate mailing
list but nothing linke linux-*hid* there. Now I've found out that
there is a list of all maintainers included in the kernel source. I'll
keep that in mind ..

-- 
Regards
Tomasz
