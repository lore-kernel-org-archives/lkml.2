Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1FXQ7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:59:20 -0400
Received: from smarthost3.mail.uk.easynet.net ([212.135.6.13]:47225 "EHLO
	smarthost3.mail.uk.easynet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294Ab1FXQ7Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:59:16 -0400
X-Greylist: delayed 2667 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jun 2011 12:59:16 EDT
thread-index: AcwyiehtR4Ds4iPvTbSPFMcHr9PdEg==
References: <216158.20018.qm@web29012.mail.ird.yahoo.com>
In-Reply-To: <216158.20018.qm@web29012.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Message-ID: <31ED5B2F-3AEC-45EC-8D2A-2E3EB313665F@sonatest.com>
Content-Transfer-Encoding: 8BIT
Cc: <linux-kernel@vger.kernel.org>, <johnpol@2ka.mipt.ru>
From: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <dagenaisj@sonatest.com>
Subject: Re: w1/ds1wm regression after 2.6.39: "bus error, retrying"
Content-Class: urn:content-classes:message
Importance: normal
Date: Fri, 24 Jun 2011 12:15:16 -0400
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4841
To: "Paul Parsons" <lost.distance@yahoo.com>
X-Mailer: Apple Mail (2.1084)
X-OriginalArrivalTime: 24 Jun 2011 16:15:17.0375 (UTC) FILETIME=[E82810F0:01CC3289]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Sorry to hear that. 2.6.39's ds1wm driver did not support dynamically finding the slaves on the bus, it would limit it's search to 1 and exit. My modifications implement the hardware assisted search as documented by the ds1wm spec sheet.

There are a couple of ways you can workaround the problem (temporarily or permanently). You might disable the bus scanning altogether (like I explain below) and insert your slave manually (as documented in the kernel w1 docs). If only one slave is present, the bus master will usually just skip the ROM matching part of the communication by doing a "SKIP ROM" which essentially says to the slave "whoever you are, I am talking to you". You could also patch the ds1wm_search function to make it look like it was in 2.6.39, or just use the whole file if it worked fine for you.

Now, to find the real problem, could you try the following:
- to limit trace noise, disable the w1 auto probe by setting the search count to 0, either in "wire" module load ("search_count=0" in /etc/modprobe.conf or the like) or int /sys under your w1 master instance
- build the ds1wm with "#define DEBUG" at the top (before headers), this will prints lots of debug about the accelerated search algorithm progress. (you could also set the retry count to something less than 100 to also limit noise in the trace)
- once booted, trigger one search manually by writing 1 in /sys/bus/w1/devices/w1\ bus\ master/w1_master_search
dmesg will contain a nice trace (although big)

Do you have more than one slave device on the ds1wm bus?

I will try to help as much as I can.
/jfd
On Jun 24, 2011, at 11:08, Paul Parsons wrote:

> The linux-3.0-rc4 DS1WM 1-wire driver is logging "bus error, retrying" error messages on an HP iPAQ hx4700 PDA (XScale-PXA270):
> 
> <snip>
> Driver for 1-wire Dallas network protocol.
> DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
> 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
> ds1wm ds1wm: pass: 1 bus error, retrying
> ds1wm ds1wm: pass: 2 bus error, retrying
> ds1wm ds1wm: pass: 3 bus error, retrying
> ds1wm ds1wm: pass: 4 bus error, retrying
> ds1wm ds1wm: pass: 5 bus error, retrying
> ds1wm ds1wm: pass: 6 bus error, retrying
> ds1wm ds1wm: pass: 7 bus error, retrying
> ds1wm ds1wm: pass: 8 bus error, retrying
> ds1wm ds1wm: pass: 9 bus error, retrying
> ds1wm ds1wm: pass: 10 bus error, retrying
> ds1wm ds1wm: pass: 11 bus error, retrying
> ds1wm ds1wm: pass: 12 bus error, retrying
> ds1wm ds1wm: pass: 13 bus error, retrying
> ds1wm ds1wm: pass: 14 bus error, retrying
> ds1wm ds1wm: pass: 15 bus error, retrying
> ds1wm ds1wm: pass: 16 bus error, retrying
> ds1wm ds1wm: pass: 17 bus error, retrying
> ds1wm ds1wm: pass: 18 bus error, retrying
> ds1wm ds1wm: pass: 19 bus error, retrying
> ds1wm ds1wm: pass: 20 bus error, retrying
> ds1wm ds1wm: pass: 21 bus error, retrying
> ds1wm ds1wm: pass: 22 bus error, retrying
> ds1wm ds1wm: pass: 23 bus error, retrying
> ds1wm ds1wm: pass: 24 bus error, retrying
> ds1wm ds1wm: pass: 25 bus error, retrying
> ds1wm ds1wm: pass: 26 bus error, retrying
> ds1wm ds1wm: pass: 27 bus error, retrying
> ds1wm ds1wm: pass: 28 bus error, retrying
> ds1wm ds1wm: pass: 29 bus error, retrying
> ds1wm ds1wm: pass: 30 bus error, retrying
> ds1wm ds1wm: pass: 31 bus error, retrying
> ds1wm ds1wm: pass: 32 bus error, retrying
> ds1wm ds1wm: pass: 33 bus error, retrying
> pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
> pcmcia 0.0: pcmcia: registering new device pcmcia0.0 (IRQ: 124)
> scsi0 : pata_pcmcia
> ata1: PATA max PIO0 cmd 0xc4820000 ctl 0xc482000e irq 124
> ds1wm ds1wm: pass: 34 bus error, retrying
> ds1wm ds1wm: pass: 35 bus error, retrying
> ds1wm ds1wm: pass: 36 bus error, retrying
> ds1wm ds1wm: pass: 37 bus error, retrying
> ds1wm ds1wm: pass: 38 bus error, retrying
> ds1wm ds1wm: pass: 39 bus error, retrying
> ds1wm ds1wm: pass: 40 bus error, retrying
> ds1wm ds1wm: pass: 41 bus error, retrying
> ds1wm ds1wm: pass: 42 bus error, retrying
> ds1wm ds1wm: pass: 43 bus error, retrying
> ds1wm ds1wm: pass: 44 bus error, retrying
> ata1.00: CFA: CF Card, Ver1.27, max PIO4
> ata1.00: 2014992 sectors, multi 0: LBA 
> ds1wm ds1wm: pass: 45 bus error, retrying
> ds1wm ds1wm: pass: 46 bus error, retrying
> ata1.00: configured for PIO0
> scsi 0:0:0:0: Direct-Access     ATA      CF Card          Ver1 PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 2014992 512-byte logical blocks: (1.03 GB/983 MiB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> sda: sda1
> sd 0:0:0:0: [sda] Attached SCSI removable disk
> ds1wm ds1wm: pass: 47 bus error, retrying
> APM Battery Driver
> mmc0 at 0xc48d2800 irq 130
> Registered led device: hx4700:amber
> Registered led device: hx4700:green
> Registered led device: hx4700:blue
> TCP cubic registered
> NET: Registered protocol family 17
> XScale iWMMXt coprocessor detected.
> pxa-rtc pxa-rtc: setting system clock to 2000-01-01 00:00:07 UTC (946684807)
> Warning: unable to open an initial console.
> VFS: Mounted root (jffs2 filesystem) readonly on device 31:2.
> Freeing init memory: 104K
> mmc0: new SD card at address 1234
> mmcblk0: mmc0:1234 SD01G 972 MiB 
> mmcblk0: p1
> udevd (337): /proc/337/oom_adj is deprecated, please use /proc/337/oom_score_adj instead.
> g_serial gadget: Gadget Serial v2.4
> g_serial gadget: g_serial ready
> pxa27x-udc pxa27x-udc: USB reset
> pxa27x-udc pxa27x-udc: USB reset
> pxa27x-udc pxa27x-udc: USB reset
> g_serial gadget: full speed config #1: Generic Serial config
> ds1wm ds1wm: pass: 1 bus error, retrying
> ds1wm ds1wm: pass: 2 bus error, retrying
> ds1wm ds1wm: pass: 3 bus error, retrying
> <snip>
> ds1wm ds1wm: pass: 91 bus error, retrying
> ds1wm ds1wm: pass: 92 bus error, retrying
> ds1wm ds1wm: pass: 93 bus error, retrying
> ds1wm ds1wm: pass: 1 bus error, retrying
> ds1wm ds1wm: pass: 2 bus error, retrying
> ds1wm ds1wm: pass: 3 bus error, retrying
> <snip>
> ds1wm ds1wm: pass: 29 bus error, retrying
> ds1wm ds1wm: pass: 30 bus error, retrying
> ds1wm ds1wm: pass: 31 bus error, retrying
> ds1wm ds1wm: pass: 1 bus error, retrying
> ds1wm ds1wm: pass: 2 bus error, retrying
> ds1wm ds1wm: pass: 3 bus error, retrying
> <snip>
> ds1wm ds1wm: pass: 98 bus error, retrying
> ds1wm ds1wm: pass: 99 bus error, retrying
> ds1wm ds1wm: pass: 100 bus error, retrying
> ds1wm ds1wm: pass: 1 bus error, retrying
> ds1wm ds1wm: pass: 2 bus error, retrying
> ds1wm ds1wm: pass: 3 bus error, retrying
> <snip>
> ds1wm ds1wm: pass: 92 bus error, retrying
> ds1wm ds1wm: pass: 93 bus error, retrying
> ds1wm ds1wm: pass: 94 bus error, retrying
> ds1wm ds1wm: pass: 1 bus error, retrying
> ds1wm ds1wm: pass: 2 bus error, retrying
> ds1wm ds1wm: pass: 3 bus error, retrying
> <snip>
> ds1wm ds1wm: pass: 98 bus error, retrying
> ds1wm ds1wm: pass: 99 bus error, retrying
> ds1wm ds1wm: pass: 100 bus error, retrying
> <snip>
> 
> The visible result is that the battery charging LED is erratic; sometimes it works, mostly it doesn't.
> 
> The linux-2.6.39 DS1WM 1-wire driver worked OK. I haven't tried 3.0-rc1, 3.0-rc2, or 3.0-rc3.
> 
> Regards.

Jean-Francois Dagenais 
Software Architect - B.Sc.A


Experience the new veo phased array flaw detector at www.sonatestveo.com.


Sonatest AP
2900 chemin des Quatre-Bourgeois
Bureau 305
Quebec City Quebec G1V 1Y4

T| +1 (418) 683 6222 x106   F| +1 (418) 683 7032   M|    W| www.sonatest.com



This message (and any associated files) is intended only for the use of lost.distance@yahoo.com, linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru and may contain information that is confidential, subject to copyright or constitutes a trade secret. If you are not the above recipient(s) you are hereby notified that any dissemination, copying or distribution of this message, or files associated with this message, is strictly prohibited. If you have received this message in error, please notify us immediately by replying to the message and deleting it from your computer. Any views or opinions presented are solely those of the author and do not necessarily represent those of the company.

Think green - help the environment by not printing this email.
