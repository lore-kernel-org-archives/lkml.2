Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110Ab1KGFJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 00:09:28 -0500
Received: from straum.hexapodia.org ([207.7.131.186]:37768 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1KGFJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 00:09:27 -0500
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Nov 2011 00:09:27 EST
Date: Sun, 6 Nov 2011 20:59:28 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: long sleep_on_page delays writing to slow storage
Message-ID: <20111107045928.GK8927@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Old-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Fingerprint: A5FC 6141 F76D B6B1 C81F  0FB7 AFA0 A45F ED3D 116D
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am running 1a67a573b (3.1.0-09125 plus a small local patch) on a Core
i7, 8 GB RAM, writing a few GB of data to a slow SD card attached via
usb-storage with vfat.  I mounted without specifying any options,

/dev/sdb1 /mnt/usb vfat rw,nosuid,nodev,noexec,relatime,uid=22448,gid=22448,fmask=0022,dmask=0022,codepage=cp437,iocharset=utf8,shortname=mixed,errors=remount-ro 0 0

and I'm using rsync to write the data.

We end up in a fairly steady state with a half GB dirty:

Dirty:            612280 kB

The dirty count stays high despite running sync(1) in another xterm.

The bug is,

Firefox (iceweasel 7.0.1-4) hangs at random intervals.  One thread is
stuck in sleep_on_page

[<ffffffff810c50da>] sleep_on_page+0xe/0x12
[<ffffffff810c525b>] wait_on_page_bit+0x72/0x74
[<ffffffff811030f9>] migrate_pages+0x17c/0x36f
[<ffffffff810fa24a>] compact_zone+0x467/0x68b
[<ffffffff810fa6a7>] try_to_compact_pages+0x14c/0x1b3
[<ffffffff810cbda1>] __alloc_pages_direct_compact+0xa7/0x15a
[<ffffffff810cc4ec>] __alloc_pages_nodemask+0x698/0x71d
[<ffffffff810f89c2>] alloc_pages_vma+0xf5/0xfa
[<ffffffff8110683f>] do_huge_pmd_anonymous_page+0xbe/0x227
[<ffffffff810e2bf4>] handle_mm_fault+0x113/0x1ce
[<ffffffff8102fe3d>] do_page_fault+0x2d7/0x31e
[<ffffffff812fe535>] page_fault+0x25/0x30
[<ffffffffffffffff>] 0xffffffffffffffff

And it stays stuck there for long enough for me to find the thread and
attach strace.  Apparently it was stuck in

1320640739.201474 munmap(0x7f5c06b00000, 2097152) = 0

for something between 20 and 60 seconds.

There's no reason to let a 6MB/sec high latency device lock up 600 MB of
dirty pages.  I'll have to wait a hundred seconds after my app exits
before the system will return to usability.

And there's no way, AFAICS, for me to work around this behavior in
userland.

And I don't understand how this compact_zone thing is intended to work
in this situation.

edited but nearly full dmesg at
http://web.hexapodia.org/~adi/snow/dmesg-3.1.0-09126-g4730284.txt

Thoughts?

Thanks,
-andy
