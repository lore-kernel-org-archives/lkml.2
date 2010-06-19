Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0FSSue (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 14:50:34 -0400
Received: from amavis-smtp.knology.net ([75.76.199.6]:43417 "EHLO
	amavis-smtp.knology.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab0FSSud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 14:50:33 -0400
X-Greylist: delayed 1120 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Jun 2010 14:50:33 EDT
Subject: Re: PROBLEM: SIS7019 stops recording after 42 min
From: David Dillow <dave@thedillows.org>
To: linux@schou.dk
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
In-Reply-To: <AANLkTimO5PXmJiIPDw82MTA53mLSl-OC0e1SOEh7v8pH@mail.gmail.com>
References: <AANLkTimO5PXmJiIPDw82MTA53mLSl-OC0e1SOEh7v8pH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Jun 2010 14:31:38 -0400
Message-ID: <1276972298.22889.16.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-8.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not trimming for the benefit of alsa-devel, cc'd. Please trim replies.

On Sat, 2010-06-19 at 16:13 +0200, Hans Schou wrote:
> Hi
> 
> I have a problem with recording sound when using the sound chip
> SIS7019 with both kernel 2.6.26 and 2.6.34. After recording about 42
> minutes it kind a stops recording, more precisely it is taking a pause
> of exactly 10 seconds between each reading.
> 
> As recorder I have tried several programs and all of them fails after
> 42 minutes. Some programs uses Alsa and some uses the old deprecated
> method. In this example I have logged sox rec.
> 
> Recording method in a script:
>   strace -tt -o strace.log rec -c 1 -r 44100 -2 sox.wav &
>   sleep 3000
>   kill $?

I think the answer is no, but to be sure -- are you talking directly to
the hardware device, or are you going through pulseaudio?

While rec is running, can you capture the configuration using
head -1000 /proc/asound/card0/pcm0c/sub0/*
Once you have the information, there is no need to run it all the way
out.

I think that's the right path, but I'm going from memory so you may have
to look around under /proc/asound. I'm trying to get my MicroClient up
and running again so I can try to reproduce this. This information will
help me narrow my focus to the correct area of the driver.

Can you try using arecord? You can use options to tell it how to
configure the PCM. Especially interesting will be to configure 2 periods
per buffer vs whatever rec uses. 2 periods per buffer uses the hardware
interrupts to clock out periods, where as 3+ uses a more complex
mechanism. You can also use -M to use mmap vs not.

> Recording start 17:41:29 and undtil 18:23:38.977278 it writes about
> 6-7 times per second to disk. Then it begin only writing every 10
> seconds. At this point it had written 27222 times to disk and the
> amount of data written so far is 28684288 bytes (including
> wav-header).
> 
> WorkARound: When the recording stops, one can just exit 'rec' and
> start it again and record another 42 minutes. Reboot is not necessary.
> Apparently, the re-init of the sound chip fixes the problem.
> 
> On other systems with nVidia CK804 or emu10k I do not have the same problem.
> 
> I have looked at sound/pci/sis7019.c but I do not really know what I
> should look for. None of the numbers in my observations is in the
> power of 2 which I would expect it was. Like, I expected it stopped
> recording after 64MB or so, but that is not the case.
> 
> Linux version 2.6.34-norhtec-sis (root@norh) (gcc version 4.1.2
> 20061115 (prerelease) (Debian 4.1.1-21)) #7 Wed Jun 16 00:32:56 CEST
> 2010
> (the kernel used was compiled on this system.)
> 
> # scripts/ver_linux
> Gnu C                  4.1.2
> Gnu make               3.81
> binutils               2.17
> util-linux             2.12r
> mount                  2.12r
> module-init-tools      3.3-pre2
> e2fsprogs              1.40-WIP
> Linux C Library        scripts/ver_linux: line 63: /proc/self/maps: No
> such file or directory
> Dynamic linker (ldd)   2.3.6
> Net-tools              1.60
> Console-tools          0.2.3
> Sh-utils               5.97
> udev                   105
> 
> # lspci -vvv
> 00:01.4 Multimedia audio controller: Silicon Integrated Systems [SiS]
> SiS7019 Audio Accelerator
>         Subsystem: Silicon Integrated Systems [SiS] SiS7019 Audio
> Accelerator
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 64 (500ns min, 6000ns max)
>         Interrupt: pin B routed to IRQ 10
>         Region 0: I/O ports at dc00 [size=256]
>         Region 1: Memory at dfff8000 (32-bit, non-prefetchable)
> [size=16K]
>         Capabilities: [60] Power Management version 2
>                 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Kernel driver in use: SiS7019
>         Kernel modules: snd-sis7019
> 
> Here is a snip from the log file when it goes from reading 7 times per
> second to every 10th second. Note two times "ioctl" within a second
> and then it goes over to a delay with 10 seconds between each "ioctl":
> 
> 18:23:38.611877 ioctl(4, 0x800c4151, 0xbf96b1d0) = 0
> 18:23:38.784635 gettimeofday({1276446218, 785207}, NULL) = 0
> 18:23:38.786609 write(2, "\rTime: 42:08.19 [00:00.00] of 00:"..., 78)= 78
> 18:23:38.789354
> write(3,"p\377q\377n\377k\377l\377p\377o\377o\377k\377n\377p\377q\377n\377o\377k\377l\377p"...,4096)
> = 4096
> 18:23:38.791590
> write(3,"j\377l\377l\377j\377l\377k\377m\377k\377l\377n\377j\377l\377l\377n\377n\377g\377m"...,12288)
> = 12288
> 18:23:38.794425 gettimeofday({1276446218, 795024}, NULL) = 0
> 18:23:38.795762 ioctl(4, 0x800c4151, 0xbf96b1d0) = 0
> 18:23:38.970451 gettimeofday({1276446218, 971018}, NULL) = 0
> 18:23:38.972293 write(2, "\rTime: 42:08.37 [00:00.00] of 00:"..., 78)= 78
> 18:23:38.975134
> write(3,"k\377m\377o\377k\377i\377j\377m\377o\377o\377m\377k\377m\377o\377k\377p\377n\377o"...,4096)
> = 4096
> 18:23:38.977278
> write(3,"m\377j\377p\377n\377n\377r\377m\377o\377o\377o\377l\377h\377l\377l\377m\377o\377o"...,12288)
> = 12288
> 18:23:38.980176 gettimeofday({1276446218, 980773}, NULL) = 0
> 18:23:38.981516 ioctl(4, 0x800c4151, 0xbf96b1d0) = 0
> 18:23:48.983347 ioctl(4, 0x800c4151, 0xbf96b1d0) = 0
> 18:23:48.985710 gettimeofday({1276446228, 986317}, NULL) = 0
> 18:23:48.987784 write(2, "\rTime: 42:08.56 [00:00.00] of 00:"..., 78) = 78
> 18:23:48.990733
> write(3,"j\377k\377l\377l\377l\377n\377l\377q\377q\377j\377l\377m\377m\377p\377o\377o\377q"...,4096)
> = 4096
> 18:23:48.992814
> write(3,"p\377m\377k\377s\377r\377m\377o\377m\377k\377k\377j\377j\377l\377p\377o\377r\377l"...,12288)
> = 12288
> 18:23:48.995694 gettimeofday({1276446228, 996297}, NULL) = 0
> 18:23:48.997046 ioctl(4, 0x800c4151, 0xbf96b1d0) = 0
> 18:23:48.999574 gettimeofday({1276446229, 186}, NULL) = 0
> 18:23:49.003421
> write(3,"l\377l\377m\377o\377q\377q\377n\377m\377q\377r\377s\377p\377n\377t\377r\377m\377n"...,4096)
> = 4096
> 18:23:49.005517
> write(3,"o\377m\377l\377p\377m\377p\377o\377m\377p\377p\377q\377o\377j\377m\377r\377m\377r"...,12288)
> = 12288
> 18:23:49.008337 gettimeofday({1276446229, 8945}, NULL) = 0
> 18:23:49.009699 ioctl(4, 0x800c4151, 0xbf96b1d0) = 0
> 18:23:59.007878 ioctl(4, 0x800c4151, 0xbf96b1d0) = 0
> 
> Version of sox: SoX v14.0.1
> 
> Full log file is 780KB compressed:
> http://schou.dk/linux/sis7019/strace.sis7019.sox-rec.2010-06-13.log.bz2
> 
> Hardware system used is a Norhtec MicroClient Jr with SIS550 CPU:
> http://www.norhtec.com/products/mcjrmx/index.html
> 
> best regards/hans


