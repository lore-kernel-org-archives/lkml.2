Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab2D0Eks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 00:40:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37650 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2D0Ekq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 00:40:46 -0400
MIME-Version: 1.0
Date: Thu, 26 Apr 2012 21:40:46 -0700
Message-ID: <CAK3+h2xG+r15XKa_imx0m6xPnfXYE22YdMBoeLpW2VrjD_4C0Q@mail.gmail.com>
Subject: Silent kernel/hardware lockup debug
From: Vincent Li <vincent.mc.li@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am running centos 6 based kernel (2.6.32-71.18.2.el6.x86_64) with a
few external kernel modules on a system with 12 cpu. the OS is on
raid1 and LVM. the system sometimes locks up with nothing on the
console, sysrq magic does not work, no softlockup/hardlockup message,
I even turned on all kernel lock debugging, still nothing when the
system locks up. but this lockup happens rarely and maybe only once
for a few weeks or months.

then I found a way to  reproduce this weird silent kernel/hardware
lockup by running following code a few times in  a day:

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

main ()
{
  time_t now;

  time(&now);
  printf("%s", ctime(&now));

  char *timestamp = ctime(&now);

  FILE *ofp;
  char *outputFilename = "/var/log/lockupcli.log";


  ofp = fopen(outputFilename, "a");

  if (ofp == NULL) {
     fprintf(stderr, "Can't open output file %s!\n", outputFilename);
     exit(1);
  }

  fprintf(ofp, "executed lockupcli at: %s\n", timestamp);

  fsync((int)ofp);
  fsync((int)ofp);

  fclose(ofp);

  printf("sleep 5 seconds to save log file to disk\n" );
  sleep(5);
  printf("starting clear interrupt flag loop\n" );

  iopl(3);

  for (;;) { asm("cli"); }

}

this code will first trigger NMI watchdog oops and kernel panic, then
cause the system reboot. the weird part is that after kernel panic
reboot, the system boots up and runs fine for 10 - 50 mintues, then
the kernel/hardware locks up all the sudden and nothing on the console
output. console is not responding and sysrq magic key does not work.
I run above test code in a cron job every hour and the kernel/hardware
locks up silent 3 - 5 times in 24 hours. If I don't run above test
code, the system stays up running fine for days, weeks, months.

so I am thinking what the test code did to make this silent
kernel/hardware lockup happen more frequent. the theory I have in mind
is that the test code caused kernel panic and may affected kernel file
system activity either in raid1 or lvm or something else. I searched
linux-raid mailing list and found one or two deadlock bugs in raid1,
but it appears all fixed in 2.6.32. I am aslo suspecting maybe these
external kernel modules may also cause the silent lockup, but I don't
have code access to these external kernel modules.

so I am seeking advices from broad kernel community on how to
diagnosis this slient kernel/hardware lockup, is it possible some
kernel file system or I/O activity caused the silent lockup? I am also
thinking maybe unloading these external kernel modules and do the same
test to eliminate the possibility of external kernel modules causing
the problem, is that good to try?

I didn't post dmesg and .config since it contains external kernel
modules configs that may not be allowed by external partners, I can
remove those configs info if you think that would help you give better
advices.

Thanks

Vincent
