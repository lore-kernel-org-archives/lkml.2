Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1D0QYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:24:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26016 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1D0QX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:23:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=mQsELo9Nf7+F/0BfPjp+nhllqikTEUSkq9GkDm5canNaRTeaCtj66PXEWTK+TR3lmS
         ZpejCLcZ9w7vhHWBC7VQ==
MIME-Version: 1.0
In-Reply-To: <BANLkTiks1LaJm_phZYi36z7aSix1fe7TdA@mail.gmail.com>
References: <BANLkTinSOZH=9uD_9uXcVnH-1Yw5K-K3yg@mail.gmail.com>
 <20110425140035.GA27159@comet.dominikbrodowski.net> <BANLkTinaCZcxDEwn-z4u1CmQRm2h+Kkocw@mail.gmail.com>
 <20110425201417.GB1268@comet.dominikbrodowski.net> <BANLkTiks1LaJm_phZYi36z7aSix1fe7TdA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 27 Apr 2011 10:23:36 -0600
Message-ID: <BANLkTikR+ZRwJRGEniW5McH6P+vp-80FvQ@mail.gmail.com>
Subject: Re: PCIE-to-PCI bridge doesn't pass mem resources downstream [Re:
 yenta cardbus problem]
To: =?ISO-8859-1?Q?Germ=E1n_Sanchis?= <eaglecros@gmail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 4:33 AM, Germán Sanchis <eaglecros@gmail.com> wrote:
> 2011/4/25 Dominik Brodowski <linux@dominikbrodowski.net>:
>> Hey,
>>
>> thanks for the additional debug information. It seems to me to be not a
>> bug with the yenta driver, but with the parent PCI bridge instead.
>> Therefore, I've added Jesse and the linux-pci list as recipients. Germán's
>> problem relates to Ubuntu's 2.6.35-derived kernel; lspci snippets follow.
>>
>> Let's look at the (grand-)parent bridge: It offers some, if not much I/O and
>> memory resources for its childs to be used:
>>
>> 00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 03) (prog-if 00 [Normal decode])
>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0
>>        Bus: primary=00, secondary=04, subordinate=09, sec-latency=0
>>        I/O behind bridge: 00001000-00001fff
>>        Memory behind bridge: d6100000-d70fffff
>>        Prefetchable memory behind bridge: 00000000d5100000-00000000d60fffff
>>
>> The PCI bridge, however, does only pass the I/O resources downstream, but
>> _no_ memory at all.
>>
>> 04:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI Express-to-PCI Bridge (rev 03) (prog-if 00 [Normal decode])
>>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0
>>        Bus: primary=04, secondary=05, subordinate=09, sec-latency=0
>>        I/O behind bridge: 00001000-00001fff
>>        Memory behind bridge: fff00000-000fffff
>>
>> The CardBus bridge then has I/O resources to use, but cannot enable memory
>> resources:
>>
>> 05:00.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
>>        Memory window 0: 00000000-00000000 [disabled] (prefetchable)
>>        Memory window 1: 00000000-00000000 [disabled] (prefetchable)
>>        I/O window 0: 00001000-000010ff
>>        I/O window 1: 00001400-000014ff
>>
>> So my question to the PCI folks: why does the PCI bridge fail to pass memory
>> regions downstream, and assign them properly to the CardBus bridge?

The BIOS assigned [mem 0xd6100000-0xd70fffff] (16MB) and [mem
0xd5100000-0xd60fffff 64bit pref] (16MB) to bus 04, but left the
04:00.0 bridge windows to bus 05 disabled.  Linux only enables them if
we find a downstream device that needs resources.  In this case, there
*is* a downstream CardBus bridge (05:00.0) that would like resources.
By default, pci_bus_size_cardbus() requests 64MB for each CardBus
memory window, but there's only 16MB each (prefetchable and
non-prefetchable) available.

I don't think your audio card needs anywhere near 64MB of memory
space.  Can you try booting with "pci=cbmemsize=8M"?

Bjorn
