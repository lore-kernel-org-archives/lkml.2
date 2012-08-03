Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab2HCCcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 22:32:11 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:51056 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2HCCcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 22:32:07 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q732VHdN006502, This message is released by code: ctaloc0852
Message-ID: <501B37F4.80206@realsil.com.cn>
Date: Fri, 3 Aug 2012 10:31:16 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 1/3] drivers/misc: Add realtek card reader core driver
References: <1343720536-22077-1-git-send-email-wei_wang@realsil.com.cn> <201207311123.25862.arnd@arndb.de> <5018CA65.1080906@realsil.com.cn> <201208011431.02050.arnd@arndb.de>
In-Reply-To: <201208011431.02050.arnd@arndb.de>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年08月01日 22:31, Arnd Bergmann 写道:
>
> I understand where you are coming from, but IMHO a bus driver would
> make more sense if the bus was a low-level abstraction that allows you
> to add new high-level drivers (memstick, smartmedia, ...) without
> having to modify the low-level drivers, which I believe is not possible
> with your current code.
>
> In reality, what you have seems to be actually more like
>
>     sdmmc    memstick
>         \       /
>          \     /
>           \   /
>      rtsx bus driver
>        /         \
>       /           \
>      /             \
>     /               \
>   rtsx-pci         rtsx-usb
>    /    \           /    \
>  pci-mmc \       usb-mmc  \
>    pci-memstick       usb-memstick
>
> The best driver abstractions have the most specific code as a top-level
> module that calls into more generic code.
>
> What I would suggest you do is to have the code that is common between
> the USB and PCI drivers in a loadable module that both of the other
> modules call into:
>
>
>    sdmmc-pci      sdmmc-usb        memstick-pci      memstick-usb
>      \   \           /   \             /    \           /   |
>       |   \         /     \           /      \         /    |
>       |    \       /       \___      /        \       /     |
>       \    sdmmc-common     ___|____/      memstick-common  |
>        \     |             /   |                       |    /
>         \____|______      /    |____________      _____|___/
>              |      \    /                  \    /     |   
>              |     pci-common             usb-common   |
>              \              \              /           /
>               \              \            /            /
>                \_____________ \          /____________/
>                              \rtsx-common/
>
>
> You can skip a few of these if they are not needed, but in principle
> you should get the idea. In this example, the pci-common and the
> usb-common drivers would each be MFD driver that export a bunch
> of slave devices. All the mmc specific code that you currently
> have in the pci driver would then go all the way to the top into
> the sdmmc-pci driver, and anything that is shared goes into one
> of the lower modules.
>
> 	Arnd

Hi Arnd:

I got your ideas. Bus driver depending on other modules is indeed a bad
style.

In our situation, just take pci device for example, pci-common is the
place to detect card plugged or unplugged, so pci-common is required to
call and probe sdmmc-pci or memstick-pci. If not using bus driver, I
need to fulfill my own mechanism, like callback functions and other
internal data structures, to achieve this goal. But bus driver can
easily finish this job. I still prefer to retain bus driver, but detach
the adapter part from the original bus driver. So the bus driver will
not depend on other modules any more, and don't need any further
modification if adding new high-level drivers. I will also move all the
mmc specific code to sdmmc-pci driver. pci-common only contains the
generic code related to pci operations. Just like the below diagram:

   sdmmc-pci      sdmmc-usb        memstick-pci      memstick-usb
     \   \           /   \             /    \           /   |
      |   \         /     \           /      \         /    |
      |    \       /       \___      /        \        |    |
      \     \ ____/         ___|____/          \_______|    |
       \     |             /   |                       |    /
        \____|______      /    |____________      _____|___/
             |      \    /                  \    /     |   
             |     pci-common             usb-common   |
             \              \              /           /
              \              \            /           /
               \_____________ \          /___________/
                             \rtsx-slot-bus/


And I plan to push sdmmc-pci and sdmmc-usb to drivers/mmc/host, push
memstick-pci and memstick-usb to drivers/memstick/host, and push
pci-common, usb-common and rtsx-slot-bus to drivers/mfd/realtek_cr.

I would like to receive your suggestions. Thank you.

Best regards,
wwang

