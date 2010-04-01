Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0DANWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 09:22:14 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:48922 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab0DANWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 09:22:03 -0400
Date: Thu, 1 Apr 2010 15:21:56 +0200
From: Daniel Mack <daniel@caiaq.de>
To: LKML <linux-kernel@vger.kernel.org>,
       AKML <linux-arm-kernel@lists.infradead.org>,
       linux-wireless@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Sven Neumann <s.neumann@raumfeld.com>
Subject: Memory corruption with 2.6.32.10, but not with 2.6.34-rc3
Message-ID: <20100401132156.GJ30807@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we observed repeated occurances of memory corruptions (Ooopes somewhere
deep down in the memory mangement code) on ARM PXA300 based boards.

The systems we see this on (arch/arm/mach-pxa/raumfeld.c) feature a
libertas chipset for WiFi, an ethernet controller (smsc9220), a USB
fullspeed host, and NAND flash which is used as UBIFS storage.

Currently, these boards run a 2.6.32.10 kernel. After collecting
evidences for a week or so about when and how and why the memory
corruptions happen, I tried a 2.6.34-rc3 today and the issue seems fixed
there. So - appearantly some important fix since 2.6.32 didn't get
enough care to be backported to the stable branch.

The bug is rather hard to trigger. What I currently do is: after the
system booted from NAND (UBIFS root partition), I wait for the WPA2
secured WiFi link to get active and then download a file (~8MB) over
WiFi to local storage. This download is done in an endless loop. Once in
a while this crashes the 2.6.32.10 kernel instantly, sometimes it takes
up to ~5hrs to happen.

Some findings I collected over the last weeks:

 - when calling wget with '-O /dev/null' to not write any file
   -> does NOT crash

 - downloading via Ethernet instead of WiFi
   -> does NOT crash

 - writing the file to either a tmpfs parition or a fatfs (on USB
   connected external media)
   -> DOES still crash (so it is most likely not an UBIFS issue)

 - passing --download-rate=50000 to wget (to limit the traffic
   thruput to 50kb/s) _in_creases the probability of the crash

 - running userspace applications which heavily allocate and
   deallocate memory doesn't seem to make the bug more likely or
   unlikely

So my current summary is that this is related to WiFi, but OTOH it still
only happens when file system traffic is issued.

We would like to have a fix for this annoying bug in the stable series
(especially 2.6.32.x) as well, but I don't have much ideas about where
to search for it. Hence, I would appreciate if maintainers could think
about any possible commits in the described time window which haven't
reached stable. Does the description ring anyone's bell?

I can cherry-pick things if anyone pin-points something and run
lont-time tests again. Any pointer appreciated.

Thanks,
Daniel

