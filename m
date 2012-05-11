Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab2EKMQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 08:16:18 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2701 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab2EKMQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 08:16:17 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
Message-ID: <4FAD0304.5060200@broadcom.com>
Date: Fri, 11 May 2012 14:16:04 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Kay Sievers" <kay@vrfy.org>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: in-kernel drivers and firmware loader
References: <4FACF02B.7070006@broadcom.com>
 <CAPXgP12qaNm1Vh=8isf2gq=sUW8hOgi_STNfTuOqg5XT4KgwZA@mail.gmail.com>
In-Reply-To: <CAPXgP12qaNm1Vh=8isf2gq=sUW8hOgi_STNfTuOqg5XT4KgwZA@mail.gmail.com>
X-Enigmail-Version: 1.5pre
X-WSS-ID: 63B3DC903E031669302-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 01:03 PM, Kay Sievers wrote:
> On Fri, May 11, 2012 at 12:55 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> To my memory (which fails from time to time) you posted a message on
>> using the asynchronous API for firmware loading as some drivers were
>> blocking on it in the module initialization. So for our driver we
>> decoupled the initialization from probe and subsequently the firmware
>> request. Assuming this solves the udev issue, but I am currently looking
>> into a somewhat related issue with our driver built-in.
>>
>> I am testing on a PandaBoard which boots a linux kernel without a initrd
>> and our device is detected before the root filesystem is mounted. I was
>> expecting the async firmware request to get called back immediatly with
>> firmware pointer being NULL. The behaviour is slightly different as this
>> callback is coming after 60 seconds, which is the timeout. I guess the
>> uevent just gets lost without the kernel knowing it. Is that correct?
> 
> It's probably sent, but nothing see it because there is no userspace
> that would have subscribed.
> 
> If udev is started later during bootup, and the coldplug triggers all
> events again, the firmware request should be found and be fulfilled by
> userspace -- at least that's the theory.
> 
> Can you reach the box with a login before the 60 seconds are reached?
> 
> Do you see a firmware request (directory) still hanging around in
> /sys/class/firmware/ ?
> 
> Kay
> 

Thanks, Kay

Here is the

# cd /sys/class/firmware/mmc1\:0001\:2/
# ls
data       device     loading    power      subsystem  uevent
# cat uevent
FIRMWARE=brcm/brcmfmac-sdio.bin
TIMEOUT=60
ASYNC=1
# cat loading
0

Not sure if loading content means anything or it presence is indicating
it is in progress. Below also the dmesg output.

Gr. AvS

[    6.801452] brcmfmac: brcmf_sdbrcm_probe: completed!!
[    6.801483] brcmfmac: brcmf_sdbrcm_probe: request firmware
"brcm/brcmfmac-sdio.bin"
[    6.802703] brcmfmac: brcmf_ops_sdio_probe: Enter
[    6.802703] brcmfmac: brcmf_ops_sdio_probe: func->class=2
[    6.802734] brcmfmac: brcmf_ops_sdio_probe: sdio_vendor: 0x02d0
[    6.802734] brcmfmac: brcmf_ops_sdio_probe: sdio_device: 0x4329
[    6.802734] brcmfmac: brcmf_ops_sdio_probe: Function#: 0x0003
[    6.895507] smsc95xx 1-1.1:1.0: eth0: register 'smsc95xx' at
usb-ehci-omap.0-1.1, smsc95xx USB 2.0 Ethernet, ca:2a:a4:72:d9:6b
[    6.908111] drivers/usb/core/inode.c: creating file '003'
[    6.921234] mmc2: card claims to support voltages below the defined
range. These will be ignored.
[    6.940582] mmc2: queuing unknown CIS tuple 0x91 (3 bytes)
[    6.947418] mmc2: new SDIO card at address 0001
[    7.001281] kjournald starting.  Commit interval 5 seconds
[    7.014190] EXT3-fs (mmcblk0p2): using internal journal
[    7.019714] EXT3-fs (mmcblk0p2): mounted filesystem with ordered data
mode
[    7.027038] VFS: Mounted root (ext3 filesystem) on device 179:2.
[    7.036437] devtmpfs: mounted
[    7.039764] Freeing init memory: 236K
[    8.119812] hub 2-0:1.0: hub_suspend
[    8.120025] usb usb2: bus auto-suspend, wakeup 1
[    8.120056] ohci-omap3 ohci-omap3.0: suspend root hub
[    9.666809] usb 1-1.1: link qh8-0001/ee2cc700 start 2 [1/0 us]
[   11.448059] smsc95xx 1-1.1:1.0: eth0: link up, 100Mbps, full-duplex,
lpa 0xCDE1
[   67.573059] brcmfmac: brcmf_sdbrcm_fw_callback: enter
[   67.573059] brcmfmac: brcmf_sdbrcm_fw_callback: firmware not found
[   67.573059] brcmfmac: brcmf_sdbrcm_release: Enter

