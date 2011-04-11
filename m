Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1DKTdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 15:33:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40597 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab1DKTdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 15:33:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=jaqAUJLvC7B0i87TKyB7vqLApmgtFpKEbK0PqvnpYe/tTGx/ifyQsT1r2+xIGUt7Mh
         NsH6L3U6wdSMcHBxXwRG3mT7UACMo5MJiuW4lgBX6klT1DQRmxrEeCiS5Avmz899K4Nt
         td1rVzUEUA41k7T/YnRb+nv6epUkosiXdJJXc=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Mark Jackson <mpfj-list@mimc.co.uk>
Subject: Re: [regression] 2.6.39-rc1 - Beagleboard usbnet broken
Date: Mon, 11 Apr 2011 21:33:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38; KDE/4.4.5; i686; ; )
Cc: linux-omap@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
References: <4D998DC9.3040109@mimc.co.uk>
In-Reply-To: <4D998DC9.3040109@mimc.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104112133.44794.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=33092
for your bug report, please add your address to the CC list in there, thanks!

On poniedziałek, 4 kwietnia 2011 o 11:22:17 Mark Jackson wrote:
> Running 2.6.38 on my beagleboard, I can boot using nfs:-
> 
> regulator_init_complete: VDVI: incomplete constraints, leaving on
> regulator_init_complete: VDAC: incomplete constraints, leaving on
> usb 1-2: new high speed USB device using ehci-omap and address 2
> mmc0: host does not support reading read-only switch. assuming
> write-enable. mmc0: new high speed SDHC card at address 1234
> usb 1-2: New USB device found, idVendor=0424, idProduct=9514
> usb 1-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> mmcblk0: mmc0:1234 SA04G 3.67 GiB
> hub 1-2:1.0: USB hub found
>  mmcblk0: p1
> hub 1-2:1.0: 5 ports detected
> usb 1-2.1: new high speed USB device using ehci-omap and address 3
> usb 1-2.1: New USB device found, idVendor=0424, idProduct=ec00
> usb 1-2.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> smsc95xx v1.0.4
> smsc95xx 1-2.1:1.0: usb0: register 'smsc95xx' at usb-ehci-omap.0-2.1,
> smsc95xx USB 2.0 Ethernet, 9e:79:dd:1e:2e:5c
> Sending DHCP requests .
> usb0: link up, 100Mbps, full-duplex, lpa 0x45E1
> ., OK
> IP-Config: Got DHCP answer from 10.0.0.1, my address is 10.0.0.113
> IP-Config: Complete:
>      device=usb0, addr=10.0.0.113, mask=255.255.0.0, gw=10.0.0.1,
>      host=10.0.0.113, domain=, nis-domain=(none),
>      bootserver=10.0.0.1, rootserver=10.0.0.100, rootpath=
> VFS: Mounted root (nfs filesystem) on device 0:10.
> .... etc ....
> 
> I have just tried out 2.6.39-rc1, and the usbnet is no longer detected:-
> 
> regulator_init_complete: VDVI: incomplete constraints, leaving on
> regulator_init_complete: VDAC: incomplete constraints, leaving on
> mmc0: host does not support reading read-only switch. assuming
> write-enable. mmc0: new high speed SDHC card at address 1234
> mmcblk0: mmc0:1234 SA04G 3.67 GiB
>  mmcblk0: p1
> VFS: Unable to mount root fs via NFS, trying floppy.
> VFS: Cannot open root device "nfs" or unknown-block(2,0)
> Please append a correct "root=" boot option; here are the available
> partitions: b300         3858432 mmcblk0  driver: mmcblk
>   b301           72261 mmcblk0p1 00000000-0000-0000-0000-000000000mmcblk0p1
> Kernel panic - not syncing: VFS: Unable to mount root fs on
> unknown-block(2,0)
> 
> I have tried a git bisect, but it seems to blame the wrong thing:-
> 
> 087809fce28f50098d9c3ef1a6865c722f23afd2 is the first bad commit
> commit 087809fce28f50098d9c3ef1a6865c722f23afd2
> Author: Jamie Iles <jamie@jamieiles.com>
> Date:   Fri Jan 21 14:11:52 2011 +0000
> 
>     dmaengine/dw_dmac: don't scan descriptors if no xfers in progress
> 
>     Some hardware (picoChip picoXCell in particular) sometimes has
>     the block transfer complete bit being set for a channel after the
>     whole transfer has completed. If we don't have any transfers in the
>     active list then don't bother to scan the descriptors. This often
>     happens in normal operation and doesn't require the channel to be
>     reset.
> 
>     v2: cleanup whitespace
> 
>     Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> :040000 040000 d0dac7f65b52fb1849f77056740d84d06530629f
> :211910a820dad07f0439410cc849c34909a62c2f M
> 
> drivers
> 
> I have attached my .config.  Can anyone help ?
> 
> Cheers
> Mark

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
