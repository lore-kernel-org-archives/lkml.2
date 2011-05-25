Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab1EYNfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:35:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:54939 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932596Ab1EYNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:35:08 -0400
Date: Wed, 25 May 2011 15:34:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Li <Steven.Li@Atheros.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haijun Liu <Haijun.Liu@Atheros.com>, Hong Fan <Hong.Fan@Atheros.com>,
        Vic Wei <Vic.Wei@Atheros.com>,
        "Jack Chen(Taipei)" <Sheng-Kuan.Chen@Atheros.com>,
        Robert Chang <Robert.Chang@Atheros.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-bluetooth@vger.kernel.org
Subject: Re: Bluetooth USB device keeps same PID/VID after DFU
In-Reply-To: <6AAC4214B9104E409FF4885ACB62A96101A78AD852@SHEXMB-01.global.atheros.com>
Message-ID: <alpine.LNX.2.00.1105251534350.29497@jikos.suse.cz>
References: <6AAC4214B9104E409FF4885ACB62A96101A78AD852@SHEXMB-01.global.atheros.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=gb2312; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ adding some relevant CCs ]

On Wed, 25 May 2011, Steven Li wrote:

> Hi Marcel:
>
> Here is steve from Atheros.  Glad to contact you here. we have some concerns to the btusb device driver.
> Present USB Bluetooth implementation in Linux has some limitations. Many vendors need to load patch and other specific operations during device probe or disconnect to their Bluetooth device, but btusb driver gives limitation to this behavior.  It needs to add the Bluetooth device PID/VID into the btusb blacklist, and use the vendor specific driver to load firmware. By this, it causes the Bluetooth device "MUST" have two PID/VIDs in Linux.  But on windows platform, the device can always keep one same PID/VID.  It is hard for us to handle this issue with current btusb design.
> Moreover in our Atheros 3012 chip, we also need to switch the 3012 chip between "normal" mode and "pre-boot" mode during PC reboot,  with current btusb design, we have to make changes in btusb.c directly, but it is our chip specific requirements.  Therefore, we¡¯d like to propose some methods to make the Bluetooth device has only one PID/VID by proper btusb modification and also for other vendor extensions such as mode switch.
>
> Currently, we have three proposals. And I attached our rough patches for these three proposals.
> They are totally not formal, I attached them just want to make you easy to understand.
>
> And from here, Let me explain more of  these proposal one by one.
>
> # Proposal 1.
> This option could be refer to what it¡¯s working for lots of UART Bluetooth devices in Linux.
> Mainly, vendor driver would be built as an object of btusb.ko. This should be same as those UART Bluetooth drivers.
> In our case, ath3k would be built as an object file according to CONFIG_BT_ATH3K define.
> Then btusb kernel module will be composed of btusb.o and ath3k.o.  So it is easy to make one PID/VID device work.
> This concept was oriented by hci_uart driver.  It can jump to individual entry function based on different ID.
> And things like mode switch also could be handled by just adding function like switch_mode() in ath3k.c.
>
> # Proposal 2.
> This option is to export btusb common functions, and vendor driver (for example our ath3k) can be taken as the extension of btusb.
> , and it can first downloads the firmware and then use those functions exported in btusb driver
> to setup the hci Bluetooth device.  Moreover if it is possible, we are also propose to refine the btusb.c and split the btusb.c to btusb_core.c and btusb_generic.c,
> In the btusb_core.c. It includes all the  Bluetooth usb common operations and these Bluetooth usb functions will be exported,
> and the btusb_generic.c is the real generic Bluetooth driver remains support all current Bluetooth device ,which uses the btusb_core functions.
> And vendor driver can also call those usb common operations in the btusb_core.c.
> With this proposal, Since the ath3k driver are the only owner of the bluetooth device, only one PID/VID is necessary.
> And it is very easy to handle the mode switch case in itself either. Please check btusb_ath3k_2.patch for detail.
>
> # Proposal 3.
> This option is to add "quirk device" to btusb driver. We found actually you added lots of so-called ¡°quirk¡± implementation in btusb driver for many vendors.
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=cfeb414537b1d7c23ba202f198fa4154cd5a4856
> Vendor specific driver can call btusb_register_quirk_device() function to  register itself to the btusb driver.
> So during the device probe, the btusb will try to match the device id, and if it is a ¡°quirk¡± device, it will call
> the ¡°quirk¡± device¡¯s specific function first.  Every vendor can use this quirk to download their firmware and keep the same PID/VID with proper codes in btusb.c.
> This proposal is also able to handle the mode switch case.
>
> Please give your comments and suggestion for our proposals.
> We are hoping to make one PID/VID work and contribute to the community.
> Thank you very much for  your helping !
>
> Best Regards,
> Steven,
>
>
>

-- 
Jiri Kosina

