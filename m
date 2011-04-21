Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1DUOiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:38:25 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3424 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab1DUOiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:38:23 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
To: "Arnd Bergmann" <arnd@arndb.de>
cc: "zajec5@gmail.com" <zajec5@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "George Kashperko" <george@znau.edu.ua>,
        "Jonas Gorski" <jonas.gorski@gmail.com>,
        "Hauke Mehrtens" <hauke@hauke-m.de>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "Andy Botting" <andy@andybotting.com>, "Greg KH" <greg@kroah.com>,
        "Michael Buesch" <m@bues.ch>
Subject: Re: [PATCH] drivers: brcmaxi: provide amba axi functionality in
 separate module
References: <1303331669-31293-1-git-send-email-arend@broadcom.com>
 <201104211612.49805.arnd@arndb.de>
Date: Thu, 21 Apr 2011 16:38:09 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vuallvn63ri7v4@arend-laptop>
In-Reply-To: <201104211612.49805.arnd@arndb.de>
User-Agent: Opera Mail/11.10 (Linux)
X-WSS-ID: 61AE9D983I814964130-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011 16:12:49 +0200, Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 20 April 2011, Arend van Spriel wrote:
>> The open-source community is looking for a library which will detect
>> cores in a chip using axi backplane. Another proposal has been
>> sent by Rafał Miłecki, which registers detected cores in the linux
>> device tree to be claimed by device drivers. This implies cores will
>> always provide a system function to the kernel which is indepent from
>> other cores and have very loose or no coupling. If this is not true,
>> exceptions need to be added in the device registration process. This
>> means knowledge of specific devices from specific vendors is sitting
>> in a bus driver. Whether the exceptions are rarely or likely is a
>> pending question.
>
> Hi Arend,
>
> I have two very general comments about this:
>
>> To feed the discussion this implementation takes a different approach.
>> A calling entity (being a pci device driver, or SoC initialization
>> sequence) registers a table with core identities and a callback  
>> function.
>> It then starts the scan and for each detected core with a callback
>> function it does the call providing the core information. Apart from
>> that it provides some basic operations on the core.
>>
>> It has been tested using the brcmsmac driver (in  
>> drivers/staging/brcm80211).
>
> The API split between PCI and non-PCI devices appears to be
> unhelpful. Can't you abstract the interface so that a user
> would apply the exact same interfaces in both cases, and handle
> the differences internally?

Ok. that can be arranged ;-)

>> +/* Core Codes */
>> +#define	NODEV_CORE_ID		0x700	/* Invalid coreid */
>> +#define	CC_CORE_ID		0x800	/* chipcommon core */
>> +#define	ILINE20_CORE_ID		0x801	/* iline20 core */
>> +#define	SRAM_CORE_ID		0x802	/* sram core */
>> +#define	SDRAM_CORE_ID		0x803	/* sdram core */
>> +#define	PCI_CORE_ID		0x804	/* pci core */
>> +#define	MIPS_CORE_ID		0x805	/* mips core */
>> +#define	ENET_CORE_ID		0x806	/* enet mac core */
>> +#define	CODEC_CORE_ID		0x807	/* v90 codec core */
>> +#define	USB_CORE_ID		0x808	/* usb 1.1 host/device core */
>> +#define	ADSL_CORE_ID		0x809	/* ADSL core */
>> +#define	ILINE100_CORE_ID	0x80a	/* iline100 core */
>> +#define	IPSEC_CORE_ID		0x80b	/* ipsec core */
>> +#define	UTOPIA_CORE_ID		0x80c	/* utopia core */
>> +#define	PCMCIA_CORE_ID		0x80d	/* pcmcia core */
>> +#define	SOCRAM_CORE_ID		0x80e	/* internal memory core */
>> +#define	MEMC_CORE_ID		0x80f	/* memc sdram core */
>> +#define	OFDM_CORE_ID		0x810	/* OFDM phy core */
>> ...
>
> This list to me is a strong hint that the cores behind the AXI bridge
> should normally be actual devices in Linux, i.e. the approach that
> Rafał suggested.  The vast majority of these is something that in Linux
> would be operated by a device driver. The exceptions that I can see
> are CPU cores and bus bridges, both of which we typically also represent
> as devices in the flattened device tree, even though they typically
> don't have a Linux driver attached to them.

Fine. Your providing the kind of feedback I was looking for. The  
OFDM_CORE_ID is also an exception.

So could a device driver claim multiple cores/devices to assure other  
drivers are not accessing those? I would prefer that over having  
exceptions coded in the axi bus driver, like the chipcommon core  
(CC_CORE_ID). I assume it can be done by the device table. Is that correct?

Rafał,

Would it be possible to make chipcommon driver optional (not doing the  
initialization)?

Gr. AvS
-- 
"The world is indeed comic, but the joke is on mankind." — H.P. Lovecraft

