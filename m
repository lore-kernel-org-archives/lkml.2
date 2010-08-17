Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab0HQRB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:01:58 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43189 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab0HQRB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:01:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        b=Dg+uFCiqpbDomlrzG2FcjsrfpUKglaHsVkjoplkplpdwc6QIPyA+X6zMBXAmSf4nAr
         BMft1i8JvuRie6Lsn/RxpZ+U+BxrQ4AlehtEU/JOo6RwxYmnP3thWg98ZFIP9GswcVb+
         WG7tHq1UHAUBWXTwhMs4PvPHcpNITQ19xRAVM=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
Date: Tue, 17 Aug 2010 18:01:54 +0100
Message-ID: <AANLkTimnC384BMdwJtk1Rp33YnAXr66HJqPvBegOxGmC@mail.gmail.com>
Subject: [REGRESSION, bisected] 2.6.36-rc1 - suspend issues
From: trapDoor <trapdoor6@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: arnd@arndb.de, trapDoor <trapdoor6@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
The merge window is closed so it's time to hunt for bugs. I've got
one, please find details below.
-----------------------

Working kernels: from 2.6.35 - to 2.6.35.2
Non working kernels: from (at least) 2.6.35-git2 - to 2.6.36-rc1
-----------------------

Description of the problem(s):

1. First of all I confirm that the problem is consistent: suspend
works well every time on the 'good' kernels and it newer works (with
the symptoms) on any of the 'bad' kernels. I've tested it several
times on a couple of 'good' and 'bad' kernels to make sure it's not
some random issue.

2. On a bad kernel, this is what happens when I try to switch to suspend mode:
- screen goes blank ['No signal detected !'] - that's OK :)
- either the CPU fan or PSU fan or both are still running and they
won't stop (left it for about 30 min. once)
- the power light is on and still, where in suspend mode it should
blink - that won't change either
- pressing the power button obviously doesn't wake the system up; need
to hard reboot

3. Now, when booting again, after an unsuccessful suspend and hard
reboot, something happens to my network card (and it doesn't matter
what is the next kernel I boot from - it can be any 'good' or 'bad'
one):
- in Gnome, the gnome-panel network indicator shows my connection as
disabled (wired eth0 - the only one I use); enabling it doesn't bring
my network up

4. After re-booting from any of the 'good' or 'bad' kernels my network
connection is working again.
-----------------------

Bisecting turned up the following commit. Reverting it in 2.6.36-rc1
results in a system that works.

commit bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sun Jul 11 15:34:05 2010 +0200

    HID: hiddev: use usb_find_interface, get rid of BKL

    This removes the private hiddev_table in the usbhid
    driver and changes it to use usb_find_interface
    instead.

    The advantage is that we can avoid the race between
    usb_register_dev and usb_open and no longer need the
    big kernel lock.

    This doesn't introduce race condition -- the intf pointer could be
    invalidated only in hiddev_disconnect() through usb_deregister_dev(),
    but that will block on minor_rwsem and not actually remove the device
    until usb_open().
-----------------------

Despite mentioned issues with network (occurring every time after
unsuccessful suspend > hard restart) the bisecting turned up a commit
which isn't rather related to network. But I can confirm that
reverting only this one commit in 2.6.36-rc1
[da5cabf80e2433131bf0ed8993abc0f7ea618c73] fixes the whole problem -
suspend works OK and I have no issues with my network after waking the
system up, neither after re-booting from the same or any other kernel.

Please let me know what further details should I provide. Any logs,
hardware specifications? I've also made a brief log recording the
bisect if anyone would need it.

--
Regards
Tomasz B. aka trapDoor
