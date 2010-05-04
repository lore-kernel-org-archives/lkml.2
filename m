Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab0EDDwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 23:52:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52327 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab0EDDws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 23:52:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=rm7m1tEc8DZm/hVm/QVnv9zj+THQsm/UjHN+EW1THZ30M53ruF7D2Lzoa6lyLtuJ/N
         3ToAp0+3PTi0+c6IoHzs1lbb2pWkvzxTWP0TnqvVpT1zLTs6wLj6jpbPPOM36fnhPQeU
         wsKTczE7+kIkJT9mW/ZiPQlS7AYWPw/4no9hE=
MIME-Version: 1.0
Date: Mon, 3 May 2010 21:52:44 -0600
Message-ID: <n2i9b1675091005032052wd935041ew5d96f145309af801@mail.gmail.com>
Subject: Flash IO slow 1.5 MB/s
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I mount my usb key with "sync" option, I get 500kb or less transfer
speeds.  If I use the gnome defaults, I get 60M+ for awhile, and then
it continually drops over time, down to the 500kb/s again.  Gnome
defaults are...

/dev/sdc1 on /media/FLASH type vfat
(rw,nosuid,nodev,noatime,uhelper=hal,shortname=lower,flush,uid=500)

I have done similar tests on both Rally2 64G usb stick and sandisk
ultra (15M/s) SDHC 8G cards.  I get lousy performance on both, unless
I set dirty bytes.  These are both FAT 32.  But, as you can see below,
14 minutes to transfer less than a couple gigs is a little nutty.  The
3 minutes is a lot nicer.  I am using 2.6.33 with a patch from
https://bugzilla.kernel.org/show_bug.cgi?id=15374

As an example, checkout this rsync
time rsync -v --progress /home/share/*.avi /media/disk/
1.avi
   709911016 100%    8.88MB/s    0:01:16 (xfer#1, to-check=1/2)
2.avi
   621254748 100%    8.07MB/s    0:01:13 (xfer#2, to-check=0/2)

sent 1331328404 bytes  received 50 bytes  1510298.87 bytes/sec
total size is 1331165764  speedup is 1.00

real    14m40.863s
user    0m8.473s
sys     0m9.525s

It really looks like there's a scheduling issue.  It seems as if the
system is IO thrashing on the flash drive, and bounces all over the
place in terms of performance.  Sometimes it's really low, like the
2.73M/s, and other times it's really fast, like the 28.86M/s.
Although you can't see it there, there were times when rsync was
registering 200kb/s.  None of them are "really" accurate, as
everything is queued for writing, but the final results of 1.5M/s
(calculated from the "real" time) is terrible.

I have not seen this bad of performance on a normal USB drive, but
only on my USB flash drive, which is FAT32.  In addition, Windows and
Mac systems transfer easily 9M/s write speeds on my rally 2.

If I do the following...
          echo 16000000 > /proc/sys/vm/dirty_bytes
the performance is 9-12M/s all the way through the transfer.  It is
also interesting to note that it hung for 2-5 seconds in the middle,
and then continued, for whatever reason.  Perhaps it was waiting for a
response from the flash drive.  Anyhow, I don't like this solution,
because it affects the entire system.  And, it's really nice to have
100M+/s on the local disks, at times when I'm writing 50-500M and I'm
done.

Now check out this rsync, with the dirty_bytes set.  I see a VERY
consistent transfer speed, which may be "marginally" slower than Mac
or Windows, but I'd have to test to be sure.

tdanotebook sync # time rsync -v --progress /home/share/*.avi /media/disk/
1.avi
   709911016 100%    7.16MB/s    0:01:34 (xfer#1, to-check=1/2)
2.avi
   621254748 100%    7.58MB/s    0:01:18 (xfer#2, to-check=0/2)

sent 1331328404 bytes  received 50 bytes  7673362.85 bytes/sec
total size is 1331165764  speedup is 1.00

real    2m53.456s
user    0m8.325s
sys     0m9.453s

I'm wondering if there's a way of having flash drives default to
dirty_bytes of 16M or less, and all other IO devices use normal
default values?  Perhaps it could become a mount option, or
configurable through /proc or sysctl?  Or, is there a way of improving
"sync" option for these devices, seeing that's what they really should
be.  Windows/Mac have them in "sync" mode, or at least a semi-sync
mode, by default.  Does sync mode just default to 512 byte blocks, and
that's why it's sooo slow?

Or, it may be nice for the system to automatically match the
dirty_bytes to the actual speed of the physical device, adjusting it
dynamically upward until it matches the transfer MB/s.
