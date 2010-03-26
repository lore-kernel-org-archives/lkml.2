Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab0CZA4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 20:56:09 -0400
Received: from mail-iw0-f196.google.com ([209.85.223.196]:46484 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0CZA4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 20:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RPdg+r+I6TXzaxLUWFaE84i/CY6C1tEk6B95meELoWb92hKdSKpCOLkuAYDAuC2HkV
         Alk5Wyl7Ps/9o4L5ghTZpN7sJDeTRV/IlXyC1P6OkF8tl6pLRyVLUqrMlFY5Fv2fdcHY
         MykuAqd+g0ERuGJSzuSmyMjljr5xXEhRRSfQA=
MIME-Version: 1.0
In-Reply-To: <51f3faa71003161630g69160ea9tc1a2d448682632e5@mail.gmail.com>
References: <20100315150806.GA15354@Dublin.logfs.org>
	 <20100315151041.GA15667@Dublin.logfs.org>
	 <20100315.115748.13754030.davem@davemloft.net>
	 <51f3faa71003151628g5edc4d7av8916ac76cb337bfe@mail.gmail.com>
	 <20100316083501.GA3489@Dublin.logfs.org>
	 <51f3faa71003161630g69160ea9tc1a2d448682632e5@mail.gmail.com>
Date: Thu, 25 Mar 2010 18:56:03 -0600
Message-ID: <51f3faa71003251756h17374375yd3a5d2acee2ffab9@mail.gmail.com>
Subject: Re: [Regression] r8169: enable 64-bit DMA by default for PCI Express 
	devices (v2)
From: Robert Hancock <hancockrwd@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@dublin.logfs.org>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       romieu@fr.zoreil.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 5:30 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On Tue, Mar 16, 2010 at 2:35 AM, Jörn Engel <joern@dublin.logfs.org> wrote:
>> On Mon, 15 March 2010 17:28:45 -0600, Robert Hancock wrote:
>>>
>>> What are the symptoms?
>>
>> No more network. :)
>>
>> According to ifconfig the interface is up and running.  If I read
>> /sys/class/net/eth0 correctly, two packets have been sent and none
>> received.  LED on network card and switch is off.  mii-tool is
>> unhappy.
>>
>> With patch in:
>> Bikini:~# mii-tool
>>  No MII transceiver present!.
>>
>> With patch reverted:
>> Bikini:~# mii-tool
>> eth0: negotiated 100baseTx-FD flow-control, link ok
>>
>> I just noticed lspci is also unhappy.
>>
>> With patch in:
>> Bikini:~# lspci -vv > lspci
>> pcilib: sysfs_read_vpd: read failed: Connection timed out.
>>
>> With patch reverted:
>> Bikini:~# lspci -vv > lspci2
>> Bikini:~# diff -u lspci*
>> --- lspci       2010-03-16 09:03:02.000000000 +0100
>> +++ lspci2      2010-03-16 09:09:36.000000000 +0100
>> @@ -246,7 +246,7 @@
>>                Vector table: BAR=4 offset=00000000
>>                PBA: BAR=4 offset=00000800
>>        Capabilities: [cc] Vital Product Data
>> -               Not readable
>> +               Unknown small resource type 00, will not decode more.
>>        Capabilities: [100] Advanced Error Reporting
>>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>
>> As you might expect, delta is part of the ethernet controller.
>>
>> All "With patch in" output above is typed off the screen.  Beware of
>> typos.
>>
>>> Does setting use_dac=0 in the module options
>>> for r8169 also resolve the problem?
>>
>> /sys/modules/r8169 does not exist.  How odd.  Anyway, simply changing
>> the default in r8169.c to 0 fixes the problems for me.  Good call.
>
>
> I can't really explain how the MII and lspci output is being
> affected.. However, it's possible that some of the chips supported by
> this driver don't actually support 64-bit DMA. Your chip is quite a
> bit older than mine (RTL8102E seems to be one of the older, if not the
> oldest, PCI-E chipset supported by the driver).
>
> Francois, do you know if that's the case, or do you have any active
> contacts at Realtek who can say?
>
> In the meantime, I don't object to reverting the patch for now unless
> we get this sorted out quickly..

Francois, ping? Is there anyone else that has access to this kind of
information about these chips?

It's kind of interesting that there's only been one report of this
though. Either the affected chips are rare among people testing
2.6.34-rc or there's something more to this. Maybe something
wierd/unusual about Jörn's system?

Jörn, are any other devices on your system working with 64-bit
addressing? Try doing this:

find /sys -name "*dma_mask_bits*" | xargs cat

Does anything show more than 32?
