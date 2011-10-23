Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905Ab1JWSoe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 14:44:34 -0400
Received: from fmmailgate06.web.de ([217.72.192.247]:52844 "EHLO
	fmmailgate06.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1JWSod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 14:44:33 -0400
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Oct 2011 14:44:33 EDT
Date: Sun, 23 Oct 2011 20:37:46 +0200 (CEST)
From: "Roland Kletzing" <devzero@web.de>
To: linux-kernel@vger.kernel.org
Cc: ext-adrian.hunter@nokia.com
Message-ID: <69501156.1798237.1319395066798.JavaMail.fmail@mwmweb003>
Subject: mtd_stresstest module bricked my dockstar
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: normal
Sensitivity: Normal
X-Provags-ID: V01U2FsdGVkX191r234DGS0CSzxQIc6ACmAGmBX727Qfs8nEDKlTHOnlS4vzqH1ds/2
 uXGHMIAtyiLRLViXRiWmxg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello folks,
i was (really) happily fiddling  with my dockstar NAS for the last 2 days and managed to get 3.0.4 vanilla kernel running on that device, and since i wanted do do some more testing with heartbeat/led, i fired up my proven "load all sort of modules until the kernel oopses, crashes, freezes" routine (i happily ran on x86 for years as a proven source for oopsing or hanging the kernel and/or for reporting unknown bugs) and this was the last thing i saw in dmesg:
mtd_stresstest: MTD device size 1048576, eraseblock size 131072, page size 2048, count of eraseblocks 8, pages per eraseblock 64, OOB
 size 64
mtd_stresstest: scanning for bad eraseblocks
mtd_stresstest: scanned 8 eraseblocks, 0 are bad
mtd_stresstest: doing operations
mtd_stresstest: 0 operations done
mtd_stresstest: 1024 operations done
mtd_stresstest: 2048 operations done
.....

could not stop that, could not kill modprobe, could not unload module - device dead, no signs of life after power-cycle anymore.

DOH!

Let`s have a look:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7163cea15f7b362795b858e7c130cd617aecc0aa

ok - in there for a while.

Kconfig:

config MTD_TESTS
tristate "MTD tests support"
depends on m
help
  This option includes various MTD tests into compilation. The tests
  should normally be compiled as kernel modules. The modules perform
  various checks and verifications when loaded.


???  
"depends on m" ? 
Perform checks and verification when loaded ?
So, there is a linux kernel module which (apparently) stress-tests (i.e. overwrites) the MTD and somehow from a derived config in a third party kernel that module got it´s way into my 3.0.4 build - and on module load, it started to hammer on the first mtd it came across without any sign of warning and without any safeguard ? (i.e. the module kills your data just by loading it?)

It may be that it`s not recommended or considered "best practise" to load all sorts of unkown modules (i.e. find /lib/modules.... -name "*.ko"....)  - but people do (see https://bugzilla.novell.com/show_bug.cgi?id=224522[https://bugzilla.novell.com/show_bug.cgi?id=224522] ). And it`s not obvious that it`s THAT dangerous. And for me this is the first time Linux REALLY managed to badly brick my hardware in such a rigorous way.  Maybe someone can understand that i`m not really amused, as there is no easy way to recover, as seen on http://www.yourwarrantyisvoid.com/2010/09/08/dead-dockstar-resurrected-with-jtag/[http://www.yourwarrantyisvoid.com/2010/09/08/dead-dockstar-resurrected-with-jtag/] 

Luckily, i got that dockstar for cheap and have some more, so let`s call that "shit really happens".

I don`t want to accuse anybody, that module has it`s purpose, but please consider adding more safeguard against such issues.

One last question:
Is there any other really dangerous stuff like this inside the kernel ? (found mtd_torturetest, which seems another beast like this)

regards
Roland

ps:
Someone want the Dockstar for spending the hours and the money for debrick ? Or for extracting gold and other precious metals from electronic waste ? ;)

___________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192
