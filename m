Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab1DCCES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 22:04:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54000 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab1DCCEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 22:04:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ginkel.com; s=google;
        h=mime-version:x-originating-ip:from:date:message-id:subject:to
         :content-type;
        b=fT4aBxhoCFL8AUOpkLgwyBIcQ4v5PMoJRZJ71//dpaTzx4T9ELhv0pvP2gb7aIM3FI
         Lm/FRmUUUZG/+IDjtRJVzFi835oKNKenrYdMN/BRgHUtBBbIE1+XdPTMlbhbw5qZ7CQ4
         sqmIlVIsZIZHkRE9UZV4wp/hUzNlgDF7Fj2es=
MIME-Version: 1.0
X-Originating-IP: [91.17.218.8]
From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Date: Sun, 3 Apr 2011 04:03:46 +0200
Message-ID: <AANLkTim5ctAoaB4+BS7Z-+ARUgTEBO22bkYMUvFtGmoN@mail.gmail.com>
Subject: Soft lockup during suspend since ~2.6.36
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

recently, I upgraded my Linux kernel (running on an Intel Core 2 Quad)
from 2.6.35 to 2.6.38. Unfortunately, I have been experiencing
frequent (but sporadic) freezes during suspend (S3) since then, i.e.,
the system became completely unresponsive (even MagicSysRq stopped
working) after having spun down the hard disks.

I performed a bisect, which pointed out the following commit:

bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a is the first bad commit
commit bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sun Jul 11 15:34:05 2010 +0200

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

    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Cc: Jiri Kosina <jkosina@suse.cz>
    Cc: "Greg Kroah-Hartman" <gregkh@suse.de>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

:040000 040000 4ae14b3ba486373d7a354874e9ad334858f094e3
8041ffda20ca3020a6b60d64235ae179f8186bf0 M      drivers

Booting with no_console_suspend also brings up a BUG mentioning a soft
lockup. As my serial console breaks during suspend, I had to take
photos of the error messages:
  https://secure.tgbyte.de/dropbox/eaghoh9M.jpg
  https://secure.tgbyte.de/dropbox/ecae8ieR.jpg
  https://secure.tgbyte.de/dropbox/vah5ooR9.jpg

Unfortunately, I have so far been unable to get the complete error
message in a single screen capture (as the output is either too
verbose or too scarce).

This bug is present up to (and including) 2.6.38 (I did not try any
later version).

I'd appreciate your help to fix this issue. Let me know if you need
further details.

Thanks,
Thilo

P.S.: Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=31562
